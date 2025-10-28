from encryption.functions import authenticate_user
from schemas.association.activity_restriction import ActivityRestrictionCreate
import models as model


def get_specific_activity_restriction_association(db: authenticate_user, activity_id: int, restriction_id: int):
    result = db.query(model.ActivityRestrictionAssociation
    ).filter(
        model.ActivityRestrictionAssociation.activity_id == activity_id
        ).filter(
        model.ActivityRestrictionAssociation.restriction_id == restriction_id
        ).first()
    return result

def get_activity_by_id(db: authenticate_user, activity_id: int):
    return db.query(model.Activity).filter(model.Activity.id == activity_id).first()

def get_activity_restrictions(db: authenticate_user, activity_id: int):
    activity_restrictions_list = db.query(model.ActivityRestrictionAssociation).filter(
        model.ActivityRestrictionAssociation.activity_id == activity_id,
        model.ActivityRestrictionAssociation.deprecated == False
    ).all()

    activities_list = [
        db.query(model.Activity).filter(model.Activity.id == i.restriction_id).first()
        for i in activity_restrictions_list
        if not i.deprecated 
    ]

    return activities_list

def mark_activity_restriction_association_as_deprecated(db: authenticate_user, id: int, undo: bool):
    _association = db.query(model.ActivityRestrictionAssociation).filter(model.ActivityRestrictionAssociation.id == id).first()
    setattr(_association, "deprecated", True)
    if undo:
        setattr(_association, "deprecated", False)
    db.commit()
    db.refresh(_association)
    return _association

def mark_all_activity_restrictions_as_deprecated(db: authenticate_user, activity_id: int, undo: bool = False):
    associations = db.query(model.ActivityRestrictionAssociation).filter(
        model.ActivityRestrictionAssociation.activity_id == activity_id
    ).all()

    for association in associations:
        setattr(association, "deprecated", not undo)

    db.commit()

    for association in associations:
        db.refresh(association)

    return associations

def create_activity_restrictions_association(db: authenticate_user, association: ActivityRestrictionCreate):
    if not get_activity_by_id(db=db, activity_id=association.restriction_id):
        print("We tried to create a activity_restriction association, but the restriction ID doesn't exist.")
        return None
    _association_check: model.ActivityRestrictionAssociation = get_specific_activity_restriction_association(db=db, activity_id=association.activity_id, restriction_id=association.restriction_id)
    if (_association_check):
        if (_association_check.deprecated):
            return mark_activity_restriction_association_as_deprecated(db=db, id=_association_check.id, undo=True)
    _activity_restriction = model.ActivityRestrictionAssociation(
        activity_id=association.activity_id,
        restriction_id=association.restriction_id,
        deprecated=False,
    )
    db.add(_activity_restriction)
    db.commit()
    db.refresh(_activity_restriction)
    return _activity_restriction
