from pydantic import BaseModel

class Permission(BaseModel):
    id: int
    permission_name: str