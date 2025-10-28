from typing import Optional
from pydantic import BaseModel
from datetime import date

class LocationChunkInfo(BaseModel):
    info_one: str
    info_two: str
    info_three: str
    deprecated: bool

class LocationChunkCreate(BaseModel):
    info_one: str
    info_two: str
    info_three: str
    location_id: int

class LocationChunk(LocationChunkCreate):
    id: int

    class Config:
        orm_mode = True
        from_attributes=True

class LocationChunkStatusCreate(BaseModel):
    activity_id: int
    chunk_id: int
    status: bool

class LocationChunkStatus(LocationChunkStatusCreate):
    id: int
    creation_date: date
    done_date: Optional[date]
    mark_done_date: Optional[date]
    mark_done_by: Optional[int]

    class Config:
        orm_mode = True
        from_attributes=True

class ChunkActivityStatus(BaseModel):
    chunk_id: int
    status_id: int
    location_id: int
    activity_id: int
    info_one: str
    info_two: str
    info_three: str
    status: bool
    creation_date: date
    done_date: Optional[date]
    mark_done_date: Optional[date]
    mark_done_by: Optional[int]