from pydantic import BaseModel

class ActivityMaterialCreate(BaseModel):
    material_id: int
    activity_id: int
    quantity: float

class ActivityMaterial(ActivityMaterialCreate):
    id: int
    deprecated: bool

    class Config:
        orm_mode = True
        from_attributes=True