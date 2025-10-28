from typing import List
from pydantic import BaseModel
import models as model

class UserPublic(BaseModel):
    id: int
    name: str
    cpf: str
    role_id: int
    schedule_id: int
    permission_id: int

    def toModel(self):
        return model.User(
            id=self.id,
            name=self.name,
            cpf=self.cpf,
            password_hash='',
            role_id=self.role_id,
            schedule_id=self.schedule_id,
            permission_id=self.permission_id
        )

    class Config:
        orm_mode = True
        from_attributes=True

class UserBase(UserPublic):
    password_hash: str

class UserCreate(BaseModel):
    name: str
    cpf: str
    password: str
    role_id: int
    permission_id: int
    schedule_id: int

    class Config:
        orm_mode = True
        from_attributes=True

class User(UserBase):
    id: int
    project: List[int] = [] 
    employee: List[int] = []

    class Config:
        orm_mode = True
        from_attributes=True