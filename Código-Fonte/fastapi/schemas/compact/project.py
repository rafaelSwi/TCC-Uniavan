from typing import List
from pydantic import BaseModel
from datetime import date

from schemas.project import Project
from schemas.user import UserPublic
from schemas.activity import Activity

class ProjectCompactView(BaseModel):
    project: Project
    employees: List[UserPublic]
    responsible: UserPublic
    creator: UserPublic
    cost: float

    class Config:
        orm_mode = True
        from_attributes=True