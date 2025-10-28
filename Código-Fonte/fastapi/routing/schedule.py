from encryption.constants import USER_DEPENDENCY
from fastapi import APIRouter, Depends, Response
from sqlalchemy.orm import Session
from crud.schedule import get_all_non_deprecated_schedules, get_schedule_by_id, create_schedule, mark_schedule_as_deprecated, generate_compact_schedule, get_users_using_schedule, replace_schedule
from crud.user import check_permission
from database import get_db
from schemas.schedule import ScheduleCreate, Schedule
from models import User

schedule_router = APIRouter()


# Get all schedules
@schedule_router.get('/all')
async def _get_all(user: USER_DEPENDENCY, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        return get_all_non_deprecated_schedules(db=db)
    else:
        return Response(status_code=403)

# Get all compact schedules
@schedule_router.get('/list')
async def _list_all(user: USER_DEPENDENCY, db: Session = Depends(get_db)):
    _compact_schedules = []
    if check_permission(db=db, user=user, perms=[1, 2]):
        _schedules = get_all_non_deprecated_schedules(db=db)
        for i in _schedules:
            _compact_schedules.append(generate_compact_schedule(db=db, schedule=i))
        return _compact_schedules
    else:
        return Response(status_code=403)

# Returns a schedule based on its ID
@schedule_router.get('/{schedule_id}')
async def _get_schedule_by_id(user: USER_DEPENDENCY, schedule_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        _schedule: Schedule = get_schedule_by_id(db=db, schedule_id=schedule_id)
        return _schedule
    else:
        return Response(status_code=403)

# Return which users are using a specific schedule
@schedule_router.get('/{schedule_id}/users')
async def _get_schedule_users(user: USER_DEPENDENCY, schedule_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        _filtered_users = []
        _users = get_users_using_schedule(db=db, schedule_id=schedule_id)
        for i in _users:
            _filtered_users.append(i.toPublic())
        return _filtered_users
    else:
        return Response(status_code=403)

# Edit (patch) a schedule using ScheduleCreate
@schedule_router.patch('/{schedule_id}')
async def _get_schedule_users(user: USER_DEPENDENCY, schedule_id: int, request: ScheduleCreate, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        return replace_schedule(db=db, schedule_id=schedule_id, new=request)
    else:
        return Response(status_code=403)

# Create a new schedule
@schedule_router.post('/create')
async def _create(user: USER_DEPENDENCY, request: ScheduleCreate, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        create_schedule(db, schedule=request)
        return Response(status_code=201)
    else:
        return Response(status_code=403)

# Mark a schedule as deprecated by using its ID
@schedule_router.delete('/{schedule_id}')
async def _mark_schedule_as_deprecated_by_id(user: USER_DEPENDENCY, schedule_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        mark_schedule_as_deprecated(db=db, schedule_id=schedule_id)
        return Response(status_code=200)
    else:
        return Response(status_code=403)