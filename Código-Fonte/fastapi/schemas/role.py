from pydantic import BaseModel

class Role(BaseModel):
    id: int
    role_name: str