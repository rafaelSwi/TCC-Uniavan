from encryption.functions import authenticate_user
from schemas.schedule import ScheduleCreate, ScheduleCompact, Schedule
import models as model

def get_all_schedules(db: authenticate_user, skip:int=0, limit:int=1_500):
    return db.query(model.Schedule).offset(skip).limit(limit).all()

def get_user_schedule(db: authenticate_user, user_id: int):
        user = db.query(model.User).filter(model.User.id == user_id).first()
        if not user:
            raise NoResultFound("User not found")
        schedule = db.query(model.Schedule).filter(model.Schedule.id == user.schedule_id).first()
        if not schedule:
            return []
        if schedule.deprecated:
            return []
        return schedule

def count_users_with_schedule(db: authenticate_user, schedule_id: int) -> int:
    schedule = db.query(model.Schedule).filter(model.Schedule.id == schedule_id, model.Schedule.deprecated == False).first()
    if not schedule:
        raise NoResultFound("Schedule not found")

    user_count = db.query(model.User).filter(model.User.schedule_id == schedule_id).count()

    return user_count

def generate_compact_schedule(db: authenticate_user, schedule: Schedule) -> ScheduleCompact:
    return ScheduleCompact(
        id=schedule.id,
        schedule_name = schedule.schedule_name,
        clock_in = schedule.clock_in,
        break_in = schedule.break_in,
        break_out = schedule.break_out,
        clock_out = schedule.clock_out,
        user_amount = db.query(model.User).filter(model.User.schedule_id == schedule.id).count(),
    )

def get_users_using_schedule(db: authenticate_user, schedule_id: int):
    schedule = db.query(model.Schedule).filter(model.Schedule.id == schedule_id, model.Schedule.deprecated == False).first()
    if not schedule:
        raise NoResultFound("Schedule not found")

    return db.query(model.User).filter(model.User.schedule_id == schedule_id).all()

def get_all_non_deprecated_schedules(db: authenticate_user, skip: int = 0, limit: int = 150):
    return (
        db.query(model.Schedule)
        .filter(model.Schedule.deprecated == False)
        .offset(skip)
        .limit(limit)
        .all()
    )

def get_schedule_by_id(db: authenticate_user, schedule_id: int):
    return db.query(model.Schedule).filter(model.Schedule.id == schedule_id).first()

def mark_schedule_as_deprecated(db: authenticate_user, schedule_id: int):
    _schedule = db.query(model.Schedule).filter(model.Schedule.id == schedule_id).first()
    setattr(_schedule, "deprecated", True)
    db.commit()
    db.refresh(_schedule)
    return _schedule

def replace_schedule(db: authenticate_user, schedule_id: int, new: ScheduleCreate):
    _schedule = db.query(model.Schedule).filter(model.Schedule.id == schedule_id).first()
    if not _schedule:
        raise ValueError(f"Schedule with id {schedule_id} not found")

    _schedule.schedule_name = new.schedule_name
    _schedule.clock_in = new.clock_in
    _schedule.clock_out = new.clock_out
    if not None in [new.break_in, new.break_out]:
        _schedule.break_in = new.break_in if new.break_in is not None else None
        _schedule.break_out = new.break_out if new.break_out is not None else None
    else:
        _schedule.break_in = None
        _schedule.break_out = None

    db.commit()
    db.refresh(_schedule)
    return _schedule

def create_schedule(db: authenticate_user, schedule: ScheduleCreate):
    _schedule = model.Schedule(
        schedule_name = schedule.schedule_name,
        clock_in = schedule.clock_in,
        break_in = schedule.break_in,
        break_out = schedule.break_out,
        clock_out = schedule.clock_out,
        deprecated = False
    )
    db.add(_schedule)
    db.commit()
    db.refresh(_schedule)
    return _schedule