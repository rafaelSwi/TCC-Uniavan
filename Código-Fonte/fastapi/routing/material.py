from encryption.constants import USER_DEPENDENCY
from sqlalchemy.exc import IntegrityError
from fastapi import APIRouter, Depends, Response
from crud.material import create_material, get_material_by_id, get_all_materials
from crud.user import check_permission
from database import get_db
from sqlalchemy.orm import Session
from schemas.material import MaterialCreate
import models as model

material_router = APIRouter()


# Get all materials
@material_router.get('/all')
async def _get_all(user: USER_DEPENDENCY, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        return get_all_materials(db=db)


# Create a new material
@material_router.post('/create')
async def _create(user: USER_DEPENDENCY, request: MaterialCreate, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        create_material(db, material=request)
        return Response(status_code=201)
    else:
        return Response(status_code=403)


# Returns a material based on its ID
@material_router.get('/{material_id}')
async def _get_material_by_id(user: USER_DEPENDENCY, material_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        return get_material_by_id(db=db, material_id=material_id)
    else:
        return Response(status_code=403)