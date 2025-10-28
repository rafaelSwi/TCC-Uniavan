from typing import Optional
from pydantic import BaseModel
from datetime import time

class ScheduleCreate(BaseModel):
    schedule_name: str
    clock_in: time
    break_in: Optional[time]
    break_out: Optional[time]
    clock_out: time

class Schedule(ScheduleCreate):
    id: int
    deprecated: bool

class ScheduleCompact(BaseModel):
    id: int
    schedule_name: str
    clock_in: time
    break_in: Optional[time]
    break_out: Optional[time]
    clock_out: time
    user_amount: int
    