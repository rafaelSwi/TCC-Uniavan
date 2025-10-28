from pydantic import BaseModel

class ProjectActivityCreate(BaseModel):
    project_id: int
    activity_id: int

class ProjectActivity(ProjectActivityCreate):
    id: int
    deprecated: bool

    class Config:
        orm_mode = True
        from_attributes=True