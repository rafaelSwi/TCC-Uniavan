from encryption.functions import authenticate_user
from crud.user import get_user_by_id
from schemas.association.activity_employee import ActivityEmployeeCreate
import models as model


def get_specific_activity_employee_association(db: authenticate_user, activity_id: int, employee_id: int):
    result = db.query(model.ActivityEmployeeAssociation
    ).filter(
        model.ActivityEmployeeAssociation.activity_id == activity_id
        ).filter(
        model.ActivityEmployeeAssociation.employee_id == employee_id
        ).first()
    return result

def get_activity_employees(db: authenticate_user, activity_id: int):
    return (
        db.query(model.User)
        .join(model.ActivityEmployeeAssociation, model.User.id == model.ActivityEmployeeAssociation.employee_id)
        .filter(
            model.ActivityEmployeeAssociation.activity_id == activity_id,
            model.ActivityEmployeeAssociation.deprecated == False
        )
        .all()
    )

def mark_activity_employee_association_as_deprecated(db: authenticate_user, id: int, undo: bool):
    _association = db.query(model.ActivityEmployeeAssociation).filter(model.ActivityEmployeeAssociation.id == id).first()
    setattr(_association, "deprecated", True)
    if undo:
        setattr(_association, "deprecated", False)
    db.commit()
    db.refresh(_association)
    return _association

def mark_all_activity_employees_as_deprecated(db: authenticate_user, activity_id: int, undo: bool = False):
    associations = db.query(model.ActivityEmployeeAssociation).filter(
        model.ActivityEmployeeAssociation.activity_id == activity_id
    ).all()

    for association in associations:
        setattr(association, "deprecated", not undo)

    db.commit()

    for association in associations:
        db.refresh(association)

    return associations

def create_activity_employee_association(db: authenticate_user, association: ActivityEmployeeCreate):
    if not get_user_by_id(db=db, user_id=association.employee_id):
        print("We tried to create a activity_employee association, but the employee ID doesn't exist.")
        return None
    _association_check: model.ActivityEmployeeAssociation = get_specific_activity_employee_association(db=db, activity_id=association.activity_id, employee_id=association.employee_id)
    if (_association_check):
        if (_association_check.deprecated):
            return mark_activity_employee_association_as_deprecated(db=db, id=_association_check.id, undo=True)
    _activity_employee = model.ActivityEmployeeAssociation(
        activity_id=association.activity_id,
        employee_id=association.employee_id,
        deprecated=False,
    )
    db.add(_activity_employee)
    db.commit()
    db.refresh(_activity_employee)
    return _activity_employee
