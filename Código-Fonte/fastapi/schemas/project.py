from typing import List, Optional
from pydantic import BaseModel
from datetime import date

class ProjectSimplified(BaseModel):
    id: int
    title: str
    start_date: date
    deadline_date: date
    responsible_id: int
    responsible_name: str

    class Config:
        orm_mode = True
        from_attributes=True

class ProjectCreate(BaseModel):
    title: str
    start_date: date
    deadline_date: date
    active: bool
    responsible_id: int
    rain: List[int] = []
    employee: List[int] = []
    activity: List[int] = []

    class Config:
        orm_mode = True
        from_attributes=True

class Project(ProjectCreate):
    title: str
    created_by: int
    creation_date: date
    deactivation_date: Optional[date]
    id: int

class ProjectEdit(BaseModel):
    id: int
    title: str
    start_date: date
    deadline_date: date
    responsible_id: int
    rain: List[int] = []
    employee: List[int] = []
    activity: List[int] = []

    class Config:
        orm_mode = True
        from_attributes=True