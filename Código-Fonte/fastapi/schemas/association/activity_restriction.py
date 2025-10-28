from pydantic import BaseModel

class ActivityRestrictionCreate(BaseModel):
    activity_id: int
    restriction_id: int

class ActivityRestriction(ActivityRestrictionCreate):
    id: int
    deprecated: bool

    class Config:
        orm_mode = True
        from_attributes=True