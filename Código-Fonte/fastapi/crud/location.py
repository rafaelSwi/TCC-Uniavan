from encryption.functions import authenticate_user
from crud.activity import get_activities_associated_with_user_by_id
from crud.association.project_employee import get_projects_associated_with_logged_user
from schemas.location import LocationCreate
import models as model

def get_all_locations(db: authenticate_user, skip:int=0, limit:int=1_500):
    return db.query(model.Location).offset(skip).limit(limit).all()

def get_location_by_id(db: authenticate_user, location_id: int):
    return db.query(model.Location).filter(model.Location.id == location_id).first()

def is_location_related_with_logged_user(db: authenticate_user, user, location_id: int) -> bool:
    activities = get_activities_associated_with_user_by_id(db=db, user=user, user_id=user.get('id'))
    association_found: bool = False
    for i in activities:
        if i.location_id == location_id:
            association_found = True
            break
    return association_found

def get_locations_related_with_logged_user(db: authenticate_user, user):
    activities = get_activities_associated_with_user_by_id(db=db, user=user, user_id=user.get('id'))
    location_list = []
    for i in activities:
        location_list.append(db.query(model.Location).filter(model.Location.id == i.location_id).first())
    return location_list

def mark_location_as_deprecated(db: authenticate_user, location_id: int):
    _location = get_location_by_id(db=db, location_id=location_id)
    setattr(_location, "deprecated", True)
    db.commit()
    db.refresh(_location)
    return _location

def create_location(db: authenticate_user, location: LocationCreate):
    _location = model.Location(
        enterprise = location.enterprise,
        cep = location.cep,
        description = location.description,
        deprecated = False
    )
    db.add(_location)
    db.commit()
    db.refresh(_location)
    return _location