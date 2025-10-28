from encryption.functions import authenticate_user
from schemas.material import MaterialCreate
import models as model

def get_all_materials(db: authenticate_user, skip:int=0, limit:int=1_500):
    return db.query(model.Material).offset(skip).limit(limit).all()

def get_material_by_id(db: authenticate_user, material_id: int):
    return db.query(model.Material).filter(model.Material.id == material_id).first()

def create_material(db: authenticate_user, material: MaterialCreate):
    _material = model.Material(
        name=material.name,
        description=material.description,
        average_price=material.average_price,
        measure=material.measure,
        in_stock=material.in_stock
    )
    db.add(_material)
    db.commit()
    db.refresh(_material)
    return _material