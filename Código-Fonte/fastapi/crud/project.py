from sqlalchemy import or_
from typing import List
from encryption.functions import authenticate_user, get_password_hash
from datetime import datetime
from schemas.project import ProjectCreate, ProjectSimplified
from crud.user import get_user_by_id
from crud.association.project_activity import check_project_activity_association_existence, create_project_activity_association
from crud.association.project_employee import check_project_employee_association_existence, create_project_employee_association
from crud.association.project_rain import check_project_rain_association_existence, create_project_rain_association
from schemas.compact.project import ProjectCompactView
from schemas.activity import Activity
from schemas.project import Project, ProjectEdit
from schemas.user import UserPublic
import models as model

def get_all_projects(db: authenticate_user, skip:int=0, limit:int=1_500):
    return db.query(model.Project).offset(skip).limit(limit).all()

def get_project_by_id(db: authenticate_user, project_id: int):
    return db.query(model.Project).filter(model.Project.id == project_id).first()

def get_projects_associated_with_user_by_id(
    db: authenticate_user, user, user_id: int
) -> List[ProjectSimplified]:
    query_responsible_projects = db.query(model.Project).filter(
        model.Project.responsible_id == user_id,
    )

    query_employee_projects = db.query(model.Project).join(
        model.ProjectEmployeeAssociation,
        model.ProjectEmployeeAssociation.project_id == model.Project.id
    ).filter(
        model.ProjectEmployeeAssociation.employee_id == user_id,
    )

    query_projects_with_user_activities = db.query(model.Project).join(
        model.ProjectActivityAssociation,
        model.ProjectActivityAssociation.project_id == model.Project.id
    ).join(
        model.Activity,
        model.ProjectActivityAssociation.activity_id == model.Activity.id
    ).join(
        model.ActivityEmployeeAssociation,
        model.ActivityEmployeeAssociation.activity_id == model.Activity.id
    ).filter(
        model.ActivityEmployeeAssociation.employee_id == user_id,
    )

    query_projects_with_rain_activities = db.query(model.Project).join(
        model.ProjectRainAssociation,
        model.ProjectRainAssociation.project_id == model.Project.id
    ).join(
        model.Activity,
        model.ProjectRainAssociation.rain_activity_id == model.Activity.id
    ).join(
        model.ActivityEmployeeAssociation,
        model.ActivityEmployeeAssociation.activity_id == model.Activity.id
    ).filter(
        model.ActivityEmployeeAssociation.employee_id == user_id,
    )

    projects = query_responsible_projects.union(
        query_employee_projects,
        query_projects_with_user_activities,
        query_projects_with_rain_activities
    ).all()

    unique_projects = {project.id: project for project in projects}.values()

    simplified_projects = [
        ProjectSimplified(
            id=project.id,
            title=project.title,
            start_date=project.start_date,
            deadline_date=project.deadline_date,
            responsible_id=project.responsible_id,
            responsible_name=project.responsible.name 
        )
        for project in unique_projects
    ]

    return simplified_projects

def get_project_compact_by_id(db: authenticate_user, project_id: int):
    _main_project: Project = db.query(model.Project).filter(model.Project.id == project_id).first()
    if not _main_project:
        return Response(status_code=404)


    def _get_activity_by_id(db: authenticate_user, activity_id: int) -> Activity:
        return db.query(model.Activity).filter(model.Activity.id == activity_id).first()

    _project_responsible: UserPublic = get_user_by_id(db=db, user_id=_main_project.responsible_id, public=True)
    _project_creator: UserPublic = get_user_by_id(db=db, user_id=_main_project.created_by, public=True)

    rain_ids = [rain_assoc.rain_activity_id for rain_assoc in _main_project.rain]
    employee_ids = [emp_assoc.employee_id for emp_assoc in _main_project.employee]

    rains: List[Activity] = [
        _get_activity_by_id(db=db, activity_id=rain_id) for rain_id in rain_ids
    ]
    employees: List[UserPublic] = [
        get_user_by_id(db=db, user_id=emp_id, public=True) for emp_id in employee_ids
    ]

    price = calculate_average_project_price(db=db, project_id=project_id)

    main_project_dict = _main_project.__dict__.copy()
    main_project_dict.pop('rain', None)
    main_project_dict.pop('employee', None)
    _project_compact_view: ProjectCompactView = ProjectCompactView(
        project=Project(
            **main_project_dict,
            rain=rain_ids,
            employee=employee_ids,
        ),
        employees=employees,
        cost=price,
        responsible=UserPublic.from_orm(_project_responsible),
        creator=UserPublic.from_orm(_project_creator),
    )
    return _project_compact_view

def get_active_projects_sorted_by_deadline(db: authenticate_user, filter_by_user_id: int = None, limit: int = 150):
    active_projects = db.query(model.Project).filter(model.Project.active == True)

    if filter_by_user_id:
        active_projects = active_projects.filter(
            or_(
                model.Project.created_by == filter_by_user_id,
                model.Project.responsible_id == filter_by_user_id
            )
        )

    sorted_projects = active_projects.order_by(
        (model.Project.deadline_date < datetime.now()).desc(),
        model.Project.deadline_date.asc()
    ).limit(limit).all()

    simplified_projects = []
    for project in sorted_projects:
        index_user = get_user_by_id(db=db, user_id=project.responsible_id, public=False)
        simplified_project = ProjectSimplified(
            id=project.id, 
            title=project.title,
            start_date=project.start_date,
            deadline_date=project.deadline_date, 
            responsible_id=index_user.id, 
            responsible_name=index_user.name
        )
        simplified_projects.append(simplified_project)

    return simplified_projects

def get_project_by_creator_id(db: authenticate_user, user_id: int, limit:int=1_500):
    return db.query(model.Project).filter(model.Project.created_by == user_id).limit(limit).all()

def edit_project(db: authenticate_user, user, project_edit: ProjectEdit):
    project: Project = db.query(model.Project).filter(model.Project.id == project_edit.id).first()

    if project is None:
        return None

    project.start_date = project_edit.start_date
    project.deadline_date = project_edit.deadline_date
    project.responsible_id = project_edit.responsible_id

    for i in project_edit.activity:
        if check_project_activity_association_existence(db=db, activity_id=i, project_id=project_edit.id):
            print(f"A new activity was attempted to be associated with a project, but this activity was already associated. (Acti. ID: {i})")
            continue
        else:
            _project_activity = model.ProjectActivityAssociation(
                project_id=project_edit.id,
                activity_id=i
            )
            create_project_activity_association(db=db, association=_project_activity)
            print(f"A new activity was associated with an existing project. (Acti. ID: {i})")

    for i in project_edit.rain:
        if check_project_rain_association_existence(db=db, rain_id=i, project_id=project_edit.id):
            print(f"A new activity was attempted to be associated with a project rain list, but this activity was already associated. (Acti. ID: {i})")
            continue
        else:
            _project_rain = model.ProjectRainAssociation(
                project_id=project_edit.id,
                rain_activity_id=i
            )
            create_project_rain_association(db=db, association=_project_rain)
            print(f"A new activity (rain) was associated with an existing project. (Acti. ID: {i})")

    for i in project_edit.employee:
        if check_project_employee_association_existence(db=db, employee_id=i, project_id=project_edit.id):
            print(f"A new user was attempted to be associated with a project, but this user was already associated. (User. ID: {i})")
            continue
        else:
            _project_employee = model.ProjectEmployeeAssociation(
                project_id=project_edit.id,
                employee_id=i
            )
            create_project_employee_association(db=db, association=_project_employee)
            print(f"A new user was associated with an existing project. (User. ID: {i})")

    db.commit()
    db.refresh(project)
    return project

def create_project(db: authenticate_user, user, project: ProjectCreate):
    user_id = user.get('id')
    _project = model.Project(
        title = project.title,
        start_date = project.start_date,
        deadline_date = project.deadline_date,
        active = project.active,
        responsible_id = project.responsible_id,
        created_by = user_id,
        creation_date = datetime.now()
    )
    db.add(_project)
    db.commit()
    db.refresh(_project)
    return _project

def is_user_responsible_for_any_project(db: authenticate_user, user_id: int) -> bool:
    return db.query(model.Project).filter(model.Project.responsible_id == user_id).first() is not None

def calculate_average_project_price(db: authenticate_user, project_id: int) -> float:
    project = db.query(model.Project).filter(model.Project.id == project_id).first()
    if not project:
        return 0.0

    project_activities = (
        db.query(model.Activity)
        .join(model.ProjectActivityAssociation, model.ProjectActivityAssociation.activity_id == model.Activity.id)
        .filter(model.ProjectActivityAssociation.project_id == project_id)
        .all()
    )

    total_labor_cost = 0.0
    total_material_cost = 0.0

    for activity in project_activities:
        if activity.average_labor_cost:
            total_labor_cost += activity.average_labor_cost

        activity_materials = (
            db.query(model.ActivityMaterialAssociation)
            .filter(model.ActivityMaterialAssociation.activity_id == activity.id)
            .all()
        )

        for am in activity_materials:
            if am.material and am.material.average_price and am.quantity:
                total_material_cost += am.material.average_price * am.quantity

    total_project_price = total_labor_cost + total_material_cost
    return total_project_price