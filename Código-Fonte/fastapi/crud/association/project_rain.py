from encryption.functions import authenticate_user
from crud.activity import get_activity_by_id
from schemas.association.project_rain import ProjectRainCreate
import models as model


def get_project_rain(db: authenticate_user, project_id: int):
    project_rain_list = db.query(model.ProjectRainAssociation).filter(model.ProjectRainAssociation.project_id == project_id).all()
    project_list = []
    for i in project_rain_list:
        project_list.append(get_activity_by_id(db=db, activity_id=i.rain_activity_id))
    return project_list


def check_project_rain_association_existence(db: authenticate_user, project_id: int, rain_id: int):
    result = db.query(model.ProjectRainAssociation
    ).filter(
        model.ProjectRainAssociation.project_id == project_id
        ).filter(
        model.ProjectRainAssociation.rain_activity_id == rain_id
        ).first()
    return result


def create_project_rain_association(db: authenticate_user, association: ProjectRainCreate):
    if not get_activity_by_id(db=db, activity_id=association.rain_activity_id):
        print("We tried to create a project_rain association, but the rain_activity ID doesn't exist.")
        return None
    _project_rain = model.ProjectRainAssociation(
        project_id = association.project_id,
        rain_activity_id = association.rain_activity_id,
        deprecated=False,
    )
    db.add(_project_rain)
    db.commit()
    db.refresh(_project_rain)
    return _project_rain
