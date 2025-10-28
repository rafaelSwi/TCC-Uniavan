from pydantic import BaseModel

class ProjectEmployeeCreate(BaseModel):
    project_id: int
    employee_id: int

class ProjectEmployee(ProjectEmployeeCreate):
    id: int
    deprecated: bool

    class Config:
        orm_mode = True
        from_attributes=True