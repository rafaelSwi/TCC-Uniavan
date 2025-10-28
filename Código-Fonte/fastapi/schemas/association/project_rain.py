from pydantic import BaseModel

class ProjectRainCreate(BaseModel):
    project_id: int
    rain_activity_id: int

class ProjectRain(ProjectRainCreate):
    id: int
    deprecated: bool

    class Config:
        orm_mode = True
        from_attributes=True