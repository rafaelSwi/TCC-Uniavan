from encryption.constants import USER_DEPENDENCY
from fastapi import APIRouter, Depends, Response
from sqlalchemy.orm import Session
from encryption.functions import get_password_hash
from crud.user import create_user, get_all_users, check_permission, get_user_by_id, get_user_by_cpf, update_user_property
from crud.project import get_projects_associated_with_user_by_id, is_user_responsible_for_any_project
from schemas.user import UserPublic
from database import get_db
from schemas.user import UserCreate
from models import User

user_router = APIRouter()

# Get all users
@user_router.get('/all')
async def _get_all(user: USER_DEPENDENCY, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_user_responsible_for_any_project(db=db, user_id=user.get("id")):
                return Response(status_code=403)
        return get_all_users(db=db)
    else:
        return Response(status_code=403)


# Create a new user
@user_router.post('/create')
async def _create(user: USER_DEPENDENCY, request: UserCreate, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1]):
        create_user(db, user=request)
        return Response(status_code=201)
    else:
        return Response(status_code=403)
 
 
 # Create a first user without any authentication needed
@user_router.post('/rise')
async def _rise(request: UserCreate, db: Session = Depends(get_db)):
    if len(db.query(User).limit(3).all()) == 0:
        create_user(db, user=request)
        return Response(status_code=201)
    else:
        return Response(status_code=410)


# Returns a user based on its ID
@user_router.get('/id/{user_id}')
async def _get_user_by_id(user: USER_DEPENDENCY, user_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        return get_user_by_id(db=db, user_id=user_id)
    else:
        return Response(status_code=403)


# Returns a user based on its CPF (Cadastro de Pessoa Fisica)
@user_router.get('/cpf/{user_cpf}')
async def _get_user_by_id(user: USER_DEPENDENCY, user_cpf: str, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        return get_user_by_cpf(db=db, user_cpf=user_cpf)
    else:
        return Response(status_code=403)

# Update specific user properties based on its ID
@user_router.patch('/id/{user_id}')
def _update_user_property(user: USER_DEPENDENCY, user_id: int, update_data: dict, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1]):
        try:
            if not get_user_by_id(db=db, user_id=user_id):
                return Response(status_code=404) 
            return update_user_property(db=db, user_id=user_id, update_data=update_data)
        except Exception as e:
            print(f"error: {e}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Returns a list of projects closer to expiring
@user_router.get('/id/{user_id}/deadline')
async def _get_projects_associated_with_user_by_id(user: USER_DEPENDENCY, user_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]) or user_id == user.get('id'):
        try:
            return get_projects_associated_with_user_by_id(db=db, user=user, user_id=user_id)
        except Exception as e:
            print(f"error: {e}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)