from encryption.functions import authenticate_user
from crud.location import get_location_by_id
from crud.activity import get_activity_by_id
from crud.association.activity_restriction import get_activity_restrictions
from schemas.chunk import LocationChunkCreate, LocationChunk, LocationChunkStatus, LocationChunkStatusCreate, ChunkActivityStatus
import models as model
from datetime import datetime

def create_location_chunk(db: authenticate_user, association: LocationChunkCreate):
    if not get_location_by_id(db=db, location_id=association.location_id):
        print("We tried to create a location info chunk, but the Location ID doesn't exist.")
        return None
    _location_chunk = model.Chunk(
        location_id=association.location_id,
        info_one=association.info_one,
        info_two=association.info_two,
        info_three=association.info_three
    )
    db.add(_location_chunk)
    db.commit()
    db.refresh(_location_chunk)
    return _location_chunk

def generate_activity_status(db: authenticate_user, location_chunk_status: LocationChunkStatus) -> ChunkActivityStatus:
    chunk = get_chunk_by_id(db=db, chunk_id=location_chunk_status.chunk_id)
    return ChunkActivityStatus(
        chunk_id=chunk.id,
        status_id=location_chunk_status.id,
        location_id=chunk.location_id,
        activity_id=location_chunk_status.activity_id,
        info_one = chunk.info_one,
        info_two = chunk.info_two,
        info_three = chunk.info_three,
        status = location_chunk_status.status,
        creation_date = location_chunk_status.creation_date,
        done_date = location_chunk_status.done_date,
        mark_done_date = location_chunk_status.mark_done_date,
        mark_done_by = location_chunk_status.mark_done_by
    )

def create_location_chunk_status(db: authenticate_user, association: LocationChunkStatusCreate):
    if not get_activity_by_id(db=db, activity_id=association.activity_id):
        print("We tried to create a location info chunk status, but the activity ID doesn't exist.")
        return None
    if not get_chunk_by_id(db=db, chunk_id=association.chunk_id):
        print("We tried to create a location info chunk status, but the chunk ID doesn't exist.")
        return None
    _location_chunk_status = model.ActivityChunkStatus(
        activity_id=association.activity_id,
        chunk_id=association.chunk_id,
        status=association.status,
        creation_date=datetime.now(),
        done_date=None,
        mark_done_date=None,
        mark_done_by=None,
    )
    db.add(_location_chunk_status)
    db.commit()
    db.refresh(_location_chunk_status)
    return _location_chunk_status

def get_chunk_status_by_id(db: authenticate_user, id: int):
    return db.query(model.ActivityChunkStatus).filter(model.ActivityChunkStatus.id == id).first()

def get_chunks_status_by_chunk_id(db: authenticate_user, chunk_id: int):
    return (
        db.query(model.ActivityChunkStatus)
        .join(model.Chunk, model.ActivityChunkStatus.chunk_id == model.Chunk.id)
        .filter(
            model.ActivityChunkStatus.chunk_id == chunk_id,
            model.Chunk.deprecated.is_(False)
        )
        .all()
    )

def get_chunks_status_by_activity_and_chunk_id(db: authenticate_user, activity_id: int, chunk_id: int):
    return (
        db.query(model.ActivityChunkStatus)
        .join(model.Chunk, model.ActivityChunkStatus.chunk_id == model.Chunk.id)
        .filter(
            model.ActivityChunkStatus.activity_id == activity_id,
            model.ActivityChunkStatus.chunk_id == chunk_id,
            model.Chunk.deprecated.is_(False)
        )
        .all()
    )

def able_to_update_chunk_status(db: authenticate_user, activity_id: int, chunk_id: int) -> bool:

    restrictions = (
        db.query(model.ActivityRestrictionAssociation)
        .filter(model.ActivityRestrictionAssociation.activity_id == activity_id)
        .all()
    )

    for restriction in restrictions:

        chunk_statuses = (
            db.query(model.ActivityChunkStatus)
            .filter(model.ActivityChunkStatus.activity_id == restriction.restriction_id)
            .filter(model.ActivityChunkStatus.chunk_id == chunk_id)
            .all()
        )

        if any(status.status is False for status in chunk_statuses):
            return False

    association_exists = (
        db.query(model.ActivityChunkAssociation)
        .filter(
            model.ActivityChunkAssociation.activity_id == activity_id,
            model.ActivityChunkAssociation.chunk_id == chunk_id,
            model.ActivityChunkAssociation.deprecated.is_(False),
        )
        .first()
    )

    if not association_exists:
        return False

    return True

def get_chunk_by_id(db: authenticate_user, chunk_id: int):
    return db.query(model.Chunk).filter(model.Chunk.id == chunk_id).first()

def get_location_from_chunk_id(db: authenticate_user, chunk_id: int):
    chunk: LocationChunk = get_chunk_by_id(db=db, chunk_id=chunk_id)
    if not chunk:
        return None
    return get_location_by_id(db=db, location_id=chunk.location_id)

def update_chunk_status_property(db: authenticate_user, chunk_status_id: int, update_data: dict):
    chunk_status: ChunkActivityStatus = get_chunk_status_by_id(db=db, id=chunk_status_id)

    for i in update_data:
        if str(i) in ["id", "location_id", "chunk_id"]:
            return None

    for field, value in update_data.items():
        if hasattr(chunk_status, field):
            setattr(chunk_status, field, value)
        else:
            raise ValueError(f"Field '{field}' does not exist on the chunk status model")

    db.commit()
    db.refresh(chunk_status)
    return chunk_status if chunk_status else None

def update_chunk_property(db: authenticate_user, chunk_id: int, update_data: dict):
    chunk: LocationChunk = get_chunk_by_id(db=db, chunk_id=chunk_id)

    for i in update_data:
        if str(i) in ["id", "location_id"]:
            return None

    for field, value in update_data.items():
        if hasattr(chunk, field):
            setattr(chunk, field, value)
        else:
            raise ValueError(f"Field '{field}' does not exist on the Chunk model")

    db.commit()
    db.refresh(chunk)
    return chunk if chunk else None

def get_chunks_by_location_id(db: authenticate_user, location_id: int):
    chunks = (
        db.query(model.Chunk)
        .filter(
            model.Chunk.location_id == location_id,
            model.Chunk.deprecated.is_(False)
        )
        .all()
    )
    return chunks

def get_chunks_by_activity_id(db: authenticate_user, activity_id: int):
    chunks = (
        db.query(model.Chunk)
        .join(model.ActivityChunkStatus, model.ActivityChunkStatus.chunk_id == model.Chunk.id)
        .filter(
            model.ActivityChunkStatus.activity_id == activity_id,
            model.Chunk.deprecated.is_(False)
        )
        .all()
    )
    return chunks

def get_chunk_statuses_by_activity_id(db: authenticate_user, activity_id: int):
    chunk_statuses = (
        db.query(model.ActivityChunkStatus)
        .join(model.Chunk, model.ActivityChunkStatus.chunk_id == model.Chunk.id)
        .filter(
            model.ActivityChunkStatus.activity_id == activity_id,
            model.Chunk.deprecated.is_(False)
        )
        .all()
    )
    return chunk_statuses

def delete_chunk_by_id(db: authenticate_user, chunk_id: int):
    chunk = db.query(model.Chunk).filter(model.Chunk.id == chunk_id).first()
    if not chunk:
        raise HTTPException(status_code=404, detail="Chunk not found")
    setattr(chunk, "deprecated", True)
    db.commit()
    db.refresh(chunk)
    return chunk if chunk else None