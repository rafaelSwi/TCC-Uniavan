from typing import List, Optional
from pydantic import BaseModel, Field

class LocationCreate(BaseModel):
    enterprise: str
    cep: str
    description: str

class Location(LocationCreate):
    id: int
    deprecated: bool