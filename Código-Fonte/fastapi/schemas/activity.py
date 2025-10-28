from typing import List, Optional
from pydantic import BaseModel
from datetime import date

class ActivityCreate(BaseModel):
    description: str
    location_id: int
    professional_amount: int
    laborer_amount: int
    professional_minutes: int
    laborer_minutes: int
    average_labor_cost: int
    restriction: List[int] = []
    employee: List[int] = []
    chunks: List[int] = []
    materials: List[int] = []
    materials_quantity: List[float] = []
    start_date: date
    deadline_date: date
    project_id: Optional[int]
    rain: bool

    class Config:
        orm_mode = True
        from_attributes=True

class ActivityClone(BaseModel):
    description: str
    professional_amount: int
    laborer_amount: int
    professional_minutes: int
    laborer_minutes: int
    average_labor_cost: int
    restriction: List[int] = []
    materials: List[int] = []
    materials_quantity: List[float] = []
    start_date: date
    deadline_date: date
    same_project: bool

    class Config:
        orm_mode = True
        from_attributes=True

class Activity(ActivityCreate):
    created_by: int
    creation_date: date
    done_date: Optional[date]
    done: bool
    id: int