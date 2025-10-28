from pydantic import BaseModel

class ActivityChunkCreate(BaseModel):
    activity_id: int
    chunk_id: int

class ActivityChunk(ActivityChunkCreate):
    id: int
    deprecated: bool

    class Config:
        orm_mode = True
        from_attributes=True