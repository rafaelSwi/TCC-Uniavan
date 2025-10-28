from encryption.functions import authenticate_user
from crud.user import get_user_by_id
from schemas.association.project_employee import ProjectEmployeeCreate
import models as model


def is_project_related_with_logged_user(db: authenticate_user, user, project_id: int) -> bool:
    user_id = user.get('id')

    project_employee_association = db.query(model.ProjectEmployeeAssociation).filter(
        model.ProjectEmployeeAssociation.employee_id == user_id,
        model.ProjectEmployeeAssociation.project_id == project_id
    ).first()

    if project_employee_association:
        return True
    
    project = db.query(model.Project).filter(model.Project.id == project_id).first()
    if project and project.responsible_id == user_id:
        return True

    activities_associated_with_project = db.query(model.Activity).join(
        model.ProjectActivityAssociation
    ).filter(model.ProjectActivityAssociation.project_id == project_id).all()

    for activity in activities_associated_with_project:
        activity_association = db.query(model.ActivityEmployeeAssociation).filter(
            model.ActivityEmployeeAssociation.activity_id == activity.id,
            model.ActivityEmployeeAssociation.employee_id == user_id
        ).first()

        if activity_association:
            return True
    
    return False

def get_projects_associated_with_logged_user(db: authenticate_user, user):
    user_id = user.get('id')
    project_list = []
    project_employee_list = db.query(model.ProjectEmployeeAssociation).filter(model.ProjectEmployeeAssociation.employee_id == user_id).all()
    from crud.project import get_active_projects_sorted_by_deadline
    projects_sorted_by_deadline = get_active_projects_sorted_by_deadline(db=db, filter_by_user_id=user_id)

    for i in projects_sorted_by_deadline:
        project_list.append(i)
    del projects_sorted_by_deadline
    for i in project_employee_list:
        project_list.append(db.query(model.Project).filter(model.Project.id == i.project_id).first())
    del project_employee_list
    projects_created_by_logged_user = db.query(model.Project).filter(model.Project.created_by == user.get('id')).limit(180).all()
    for i in projects_created_by_logged_user:
        project_list.append(i)
    return project_list

def check_project_employee_association_existence(db: authenticate_user, project_id: int, employee_id: int):
    result = db.query(model.ProjectEmployeeAssociation
    ).filter(
        model.ProjectEmployeeAssociation.project_id == project_id
        ).filter(
        model.ProjectEmployeeAssociation.employee_id == employee_id
        ).first()
    return result

def create_project_employee_association(db: authenticate_user, association: ProjectEmployeeCreate):
    if not get_user_by_id(db=db, user_id=association.employee_id):
        print("We tried to create a project_employee association, but the employee ID doesn't exist.")
        return None
    _project_employee = model.ProjectEmployeeAssociation(
        project_id=association.project_id,
        employee_id=association.employee_id,
        deprecated=False,
    )
    db.add(_project_employee)
    db.commit()
    db.refresh(_project_employee)
    return _project_employee
