from encryption.constants import USER_DEPENDENCY
from sqlalchemy.exc import IntegrityError
from fastapi import APIRouter, Depends, Response
from crud.location import create_location, get_all_locations, is_location_related_with_logged_user, get_location_by_id, mark_location_as_deprecated, get_locations_related_with_logged_user
from crud.user import check_permission
from crud.project import is_user_responsible_for_any_project
from schemas.chunk import LocationChunkInfo, LocationChunkCreate, LocationChunkStatus
from crud.chunk import create_location_chunk, get_chunks_by_location_id, get_chunks_status_by_chunk_id, delete_chunk_by_id
from database import get_db
from sqlalchemy.orm import Session
from schemas.location import LocationCreate
import models as model

location_router = APIRouter()


# Get all locations
@location_router.get('/all')
async def _get_all(user: USER_DEPENDENCY, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        return get_all_locations(db=db)
    else:
        return get_locations_related_with_logged_user(db=db, user=user)


# Create a new location
@location_router.post('/create')
async def _create(user: USER_DEPENDENCY, request: LocationCreate, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        create_location(db, location=request)
        return Response(status_code=201)
    else:
        return Response(status_code=403)


# Returns a location based on its ID
@location_router.get('/{location_id}')
async def _get_location_by_id(user: USER_DEPENDENCY, location_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if is_user_responsible_for_any_project(db=db, user_id=user.get("id")):
                return get_location_by_id(db=db, location_id=location_id)
            if not is_location_related_with_logged_user(db=db, user=user, location_id=location_id):
                return Response(status_code=401)
        try:
            return get_location_by_id(db=db, location_id=location_id)
        except:
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Mark a location as deprecated by using its ID
@location_router.delete('/{location_id}')
async def _mark_location_as_deprecated_by_id(user: USER_DEPENDENCY, location_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        mark_location_as_deprecated(db=db, location_id=location_id)
        return Response(status_code=200)
    else:
        return Response(status_code=403)

# Returns a list of chunks based on its location ID
@location_router.get('/{location_id}/chunks')
async def _get_location_by_id(user: USER_DEPENDENCY, location_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_location_related_with_logged_user(db=db, user=user, location_id=location_id):
                return Response(status_code=401)
        try:
            return get_chunks_by_location_id(db=db, location_id=location_id)
        except:
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Post a new chunk based on a location id
@location_router.post('/{location_id}/chunk')
async def _create_new_chunk_by_location_id(user: USER_DEPENDENCY, location_id: int, request: LocationChunkCreate, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        _location_chunk_create = LocationChunkCreate(
            location_id=location_id,
            info_one=request.info_one,
            info_two=request.info_two,
            info_three=request.info_three,
        )
        return create_location_chunk(db=db, association=_location_chunk_create)
    else:
        return Response(status_code=403)

from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from database import get_db
from models import Chunk, ActivityChunkStatus

router = APIRouter()

@location_router.delete("/chunk/{chunk_id}")
def _delete_chunk(user: USER_DEPENDENCY, chunk_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        delete_chunk_by_id(db=db, chunk_id=chunk_id)