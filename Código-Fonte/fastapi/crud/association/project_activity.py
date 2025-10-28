from encryption.functions import authenticate_user
from schemas.association.project_activity import ProjectActivityCreate
import models as model


def get_projects_associated_with_activities(db: authenticate_user, user):
    user_id = user.get('id')
    
    project_activity_list = db.query(model.ProjectActivityAssociation).filter(model.Activity.created_by == user_id).all()
    
    project_list = []
    for association in project_activity_list:
        project = db.query(model.Project).filter(model.Project.id == association.project_id).first()
        if project:
            project_list.append(project)
    
    del project_activity_list
    return project_list


def get_activities_by_project_id(db, project_id: int):
    project_activity_associations = db.query(model.ProjectActivityAssociation).filter(
        model.ProjectActivityAssociation.project_id == project_id
    ).all()
    
    activity_list = []
    
    for association in project_activity_associations:
        activity = db.query(model.Activity).filter(model.Activity.id == association.activity_id).first()
        if activity:
            activity_list.append(activity)
    
    return activity_list


def check_project_activity_association_existence(db: authenticate_user, project_id: int, activity_id: int):
    result = db.query(model.ProjectActivityAssociation
    ).filter(
        model.ProjectActivityAssociation.project_id == project_id
        ).filter(
        model.ProjectActivityAssociation.activity_id == activity_id
        ).first()
    return result


def create_project_activity_association(db: authenticate_user, association: ProjectActivityCreate):

    if not db.query(model.Activity).filter(model.Activity.id == association.activity_id).first():
        print("We tried to create a project_activity association, but the activity ID doesn't exist.")
        return None
    if not db.query(model.Project).filter(model.Project.id == association.project_id).first():
        print("We tried to create a project_activity association, but the project ID doesn't exist.")
        return None

    _project_activity = model.ProjectActivityAssociation(
        project_id=association.project_id,
        activity_id=association.activity_id,
        deprecated=False,
    )
    db.add(_project_activity)
    db.commit()
    db.refresh(_project_activity)
    return _project_activity