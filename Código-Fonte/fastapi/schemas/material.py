from typing import Optional, List
from pydantic import BaseModel, Field

class MaterialBase(BaseModel):
    name: str = Field(..., max_length=64)
    description: Optional[str] = Field(None, max_length=255)
    average_price: Optional[float] = Field(None, ge=0)
    measure: Optional[str] = Field(None, max_length=32)
    in_stock: bool = True


class MaterialCreate(MaterialBase):
    pass


class MaterialUpdate(BaseModel):
    name: Optional[str] = Field(None, max_length=64)
    description: Optional[str] = Field(None, max_length=255)
    average_price: Optional[float] = Field(None, ge=0)
    measure: Optional[str] = Field(None, max_length=32)
    in_stock: Optional[bool] = None


class Material(MaterialBase):
    id: int

    class Config:
        orm_mode = True
