from encryption.functions import authenticate_user
from schemas.association.activity_material import ActivityMaterialCreate
import models as model


def create_activity_material_association(db: authenticate_user, association: ActivityMaterialCreate):
    if not db.query(model.Activity).filter(model.Activity.id == association.activity_id).first():
        print("We tried to create a activity_material association, but the activity ID doesn't exist.")
        return None
    _activity_material = model.ActivityMaterialAssociation(
        activity_id = association.activity_id,
        material_id = association.material_id,
        quantity = association.quantity
    )
    db.add(_activity_material)
    db.commit()
    db.refresh(_activity_material)
    return _activity_material

def get_activity_materials(db: authenticate_user, activity_id: int):
    return (
        db.query(model.Material)
        .join(model.ActivityMaterialAssociation, model.Material.id == model.ActivityMaterialAssociation.material_id)
        .filter(
            model.ActivityMaterialAssociation.activity_id == activity_id,
        )
        .all()
    )
