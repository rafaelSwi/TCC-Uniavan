from pydantic import BaseModel

class ActivityEmployeeCreate(BaseModel):
    activity_id: int
    employee_id: int

class ActivityEmployee(ActivityEmployeeCreate):
    id: int
    deprecated: bool

    class Config:
        orm_mode = True
        from_attributes=True