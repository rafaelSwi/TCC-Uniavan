from encryption.functions import authenticate_user
from schemas.association.activity_employee import ActivityEmployeeCreate
from schemas.association.activity_chunk import ActivityChunkCreate
from schemas.chunk import ChunkActivityStatus, LocationChunkStatusCreate
from crud.chunk import create_location_chunk_status
import models as model


def check_activity_chunk_association_existence(db: authenticate_user, activity_id: int, chunk_id: int):
    result = db.query(model.ActivityChunkAssociation
    ).filter(
        model.ActivityChunkAssociation.activity_id == activity_id
        ).filter(
        model.ActivityChunkAssociation.chunk_id == chunk_id
        ).first()
    return result

def get_activity_chunks(db: authenticate_user, activity_id: int):
    activity_chunks_list = db.query(model.ActivityChunkAssociation).filter(model.ActivityChunkAssociation.activity_id == activity_id).all()
    chunk_list = []
    for i in activity_chunks_list:
        chunk_list.append(db.query(model.Chunk).filter(model.Chunk.id == i.chunk_id).first())
    return chunk_list

def create_activity_chunk_association(db: authenticate_user, association: ActivityChunkCreate):
    if not db.query(model.Chunk).filter(model.Chunk.id == association.chunk_id).first():
        print("We tried to create a activity_chunk association, but the chunk ID doesn't exist.")
        return None
    if not db.query(model.Activity).filter(model.Activity.id == association.activity_id).first():
        print("We tried to create a activity_chunk association, but the activity ID doesn't exist.")
        return None
    _activity_chunk = model.ActivityChunkAssociation(
        activity_id=association.activity_id,
        chunk_id=association.chunk_id,
        deprecated=False,
    )
    db.add(_activity_chunk)
    db.commit()
    db.refresh(_activity_chunk)
    return _activity_chunk

def get_activity_chunks(db: authenticate_user, activity_id: int):
    activity = db.query(model.Activity).filter(model.Activity.id == activity_id).first()
    all_chunks = (
        db.query(model.Chunk)
        .join(model.ActivityChunkAssociation, model.Chunk.id == model.ActivityChunkAssociation.chunk_id)
        .filter(
            model.Chunk.location_id == activity.location_id,
            model.Chunk.deprecated == False, 
            model.ActivityChunkAssociation.activity_id == activity_id,
            model.ActivityChunkAssociation.deprecated == False
        )
        .all()
    )

    formatted_chunks_status = []

    for chunk in all_chunks:
        chunk_status = (
        db.query(model.ActivityChunkStatus)
        .join(model.Chunk, model.ActivityChunkStatus.chunk_id == model.Chunk.id)
        .filter(
            model.ActivityChunkStatus.activity_id == activity_id,
            model.ActivityChunkStatus.chunk_id == chunk.id,
            model.Chunk.deprecated.is_(False)
        )
        .all()
        )

        if not chunk_status:
            _new_chunk_status = LocationChunkStatusCreate(
                activity_id=activity_id,
                chunk_id=chunk.id,
                status=False
            )
            chunk_status = create_location_chunk_status(db=db, association=_new_chunk_status)

        if not isinstance(chunk_status, list):
            chunk_status = [chunk_status]

        for status in chunk_status:
            c = db.query(model.Chunk).filter(model.Chunk.id == status.chunk_id).first()
            _chunk_activity_status = ChunkActivityStatus(
                chunk_id=c.id,
                status_id=status.id,
                location_id=c.location_id,
                activity_id=status.activity_id,
                info_one = c.info_one,
                info_two = c.info_two,
                info_three = c.info_three,
                status = status.status,
                creation_date = status.creation_date,
                done_date = status.done_date,
                mark_done_date = status.mark_done_date,
                mark_done_by = status.mark_done_by
            )
            formatted_chunks_status.append(_chunk_activity_status)

    return formatted_chunks_status