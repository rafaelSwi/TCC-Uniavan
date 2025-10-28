from sqlalchemy import and_, or_
from encryption.functions import authenticate_user
from crud.association.project_employee import get_projects_associated_with_logged_user
from crud.association.activity_restriction import get_activity_restrictions
from crud.association.activity_employee import get_activity_employees
from crud.association.project_activity import get_activities_by_project_id
from datetime import datetime, date
from schemas.activity import ActivityCreate, Activity, ActivityClone
from schemas.chunk import LocationChunkStatus, ChunkActivityStatus
import models as model

def get_all_activities(db: authenticate_user, skip:int=0, limit:int=1_500):
    return db.query(model.Activity).offset(skip).limit(limit).all()

def get_activity_by_id(db: authenticate_user, activity_id: int) -> Activity:
    return db.query(model.Activity).filter(model.Activity.id == activity_id).first()

def get_activity_by_creator_id(db: authenticate_user, user_id: int):
    return db.query(model.Activity).filter(model.Activity.created_by == user_id).all()

def get_activity_projects(db: authenticate_user, activity_id: int):
    _activity_projects = (
        db.query(model.ProjectActivityAssociation)
        .filter(
            model.ProjectActivityAssociation.activity_id == activity_id,
            model.ProjectActivityAssociation.deprecated == False
        )
        .all()
    )
    _projects = []
    for association in _activity_projects:
        _project = db.query(model.Project).filter(model.Project.id == association.project_id).first()
        if _project:
            _projects.append(_project)

    return _projects

def is_activity_related_with_logged_user(db: authenticate_user, user, activity_id: int) -> bool:
    user_id = user.get('id')

    if db.query(model.ActivityEmployeeAssociation).filter(
            model.ActivityEmployeeAssociation.activity_id == activity_id,
            model.ActivityEmployeeAssociation.employee_id == user_id
    ).first():
        return True

    activities = get_activities_with_restrictions_associated_with_logged_user(db=db, user=user)

    if any(i.id == activity_id for i in activities):
        return True

    for activity in activities:
        restrictions = get_activity_restrictions(db=db, activity_id=activity.id)
        if any(restricted_activity.id == activity_id for restricted_activity in restrictions):
            return True

    return False

def can_complete_activity(db: authenticate_user, activity_id: int) -> bool:
    restrictions = get_activity_restrictions(db=db, activity_id=activity_id)
    for restriction in restrictions:
        if restriction:
            if not restriction.done_date:
                return False

    _activity_chunks = (
        db.query(model.ActivityChunkAssociation)
        .filter(
            model.ActivityChunkAssociation.activity_id == activity_id,
            model.ActivityChunkAssociation.deprecated.is_(False),
        )
        .all()
    )

    for activity_chunk in _activity_chunks:
        _chunk: ChunkActivityStatus = db.query(model.ActivityChunkStatus).filter(
            model.ActivityChunkStatus.chunk_id == activity_chunk.chunk_id,
            model.ActivityChunkStatus.activity_id == activity_id
        ).first()
        if _chunk:
            if _chunk.status == False:
                return False

    return True

def is_user_responsible_for_activity_project(db: authenticate_user, activity_id: int, user_id: int) -> bool:
    activity_projects = (
        db.query(model.ProjectActivityAssociation)
        .filter(
            model.ProjectActivityAssociation.activity_id == activity_id,
            model.ProjectActivityAssociation.deprecated == False
        )
        .all()
    )

    for association in activity_projects:
        project = db.query(model.Project).filter(model.Project.id == association.project_id).first()
        if project and project.responsible_id == user_id:
            return True
            
    return False

def get_activities_associated_with_user_by_id(db: authenticate_user, user, user_id: int):
    query_employee_activities = db.query(model.Activity).join(
        model.ActivityEmployeeAssociation,
        model.ActivityEmployeeAssociation.activity_id == model.Activity.id
    ).filter(
        model.ActivityEmployeeAssociation.employee_id == user_id,
    )

    query_created_activities = db.query(model.Activity).filter(
        model.Activity.created_by == user_id,
    )

    query_project_employee_activities = db.query(model.Activity).join(
        model.ProjectActivityAssociation,
        model.ProjectActivityAssociation.activity_id == model.Activity.id
    ).join(
        model.ProjectEmployeeAssociation,
        model.ProjectEmployeeAssociation.project_id == model.ProjectActivityAssociation.project_id
    ).filter(
        model.ProjectEmployeeAssociation.employee_id == user_id,
    )

    query_project_rain_activities = db.query(model.Activity).join(
        model.ProjectRainAssociation,
        model.ProjectRainAssociation.rain_activity_id == model.Activity.id
    ).join(
        model.ProjectEmployeeAssociation,
        model.ProjectEmployeeAssociation.project_id == model.ProjectRainAssociation.project_id
    ).filter(
        model.ProjectEmployeeAssociation.employee_id == user_id,
    )

    activities = query_employee_activities.union(
        query_created_activities,
        query_project_employee_activities,
        query_project_rain_activities
    ).all()

    return activities

def get_activities_with_restrictions_associated_with_logged_user(db: authenticate_user, user):
    user_id = user.get('id')
    
    projects = get_projects_associated_with_logged_user(db=db, user=user)
    activities = set()

    # Para cada projeto, recupera suas atividades
    for project in projects:
        project_activities = get_activities_by_project_id(db=db, project_id=project.id)
        for activity in project_activities:
            activities.add(activity)
            
            restrictions = get_activity_restrictions(db=db, activity_id=activity.id)
            for restriction in restrictions:
                activities.add(restriction)

    clean_activities = list(activities)

    return clean_activities

# created this but not actually used anywere ¯\_(ツ)_/¯
def mark_activity_as_done(db: authenticate_user, activity_id: int):
    activity = get_activity_by_id(db=db, activity_id=activity_id)
    if activity is None:
        return None 
    activity.done = True
    db.commit()
    db.refresh(activity)
    return activity

def update_activity(db: authenticate_user, activity_id: int, updated_activity: ActivityCreate):
    activity = get_activity_by_id(db=db, activity_id=activity_id)
    if activity is None:
        return None

    activity.description = updated_activity.description
    activity.location_id = updated_activity.location_id
    activity.professional_amount = updated_activity.professional_amount
    activity.laborer_amount = updated_activity.laborer_amount
    activity.professional_minutes = updated_activity.professional_minutes
    activity.laborer_minutes = updated_activity.laborer_minutes
    activity.average_labor_cost = updated_activity.average_labor_cost
    
    db.commit()
    db.refresh(activity)
    return activity

def create_activity(db: authenticate_user, user, activity: ActivityCreate):
    user_id = user.get('id')
    _activity = model.Activity(
        description = activity.description,
        location_id = activity.location_id,
        professional_amount = activity.professional_amount,
        laborer_amount = activity.laborer_amount,
        professional_minutes = activity.professional_minutes,
        average_labor_cost = activity.average_labor_cost,
        laborer_minutes = activity.laborer_minutes,
        created_by = user_id,
        start_date=activity.start_date,
        deadline_date=activity.deadline_date,
        creation_date = datetime.now(),
        done = False
    )
    db.add(_activity)
    db.commit()
    db.refresh(_activity)
    return _activity

def create_clone_activity(db: authenticate_user, user, activity: ActivityClone, location_id: int):
    user_id = user.get('id')
    _activity = model.Activity(
        description = activity.description,
        location_id = location_id,
        professional_amount = activity.professional_amount,
        laborer_amount = activity.laborer_amount,
        professional_minutes = activity.professional_minutes,
        laborer_minutes = activity.laborer_minutes,
        average_labor_cost = activity.average_labor_cost,
        created_by = user_id,
        start_date=activity.start_date,
        deadline_date=activity.deadline_date,
        creation_date = datetime.now(),
        done = False
    )
    db.add(_activity)
    db.commit()
    db.refresh(_activity)
    return _activity


def update_activity_property(db: authenticate_user, activity_id: int, update_data: dict):
    activity: Activity = get_activity_by_id(db=db, activity_id=activity_id)

    for i in update_data:
        if str(i) in ["id", "creation_date", "created_by", "done_date"]:
            return None

    if "done" in update_data:
        if not can_complete_activity(db=db, activity_id=activity_id):
            return None
        else:
            setattr(activity, "done_date", date.today())
            setattr(activity, "done", True)
            update_data.pop("done", None)

    for field, value in update_data.items():
        if hasattr(activity, field):
            setattr(activity, field, value)
        else:
            raise ValueError(f"Field '{field}' does not exist on the Activity model")

    db.commit()
    db.refresh(activity)
    return activity if activity else None