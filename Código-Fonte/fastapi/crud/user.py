from encryption.functions import authenticate_user, get_password_hash
from schemas.user import UserCreate, UserPublic
from typing import List
import models as model

def get_all_users(db: authenticate_user, skip:int=0, limit:int=3_500) -> List[UserPublic]:
    user_list = db.query(model.User).offset(skip).limit(limit).all()
    public_users = []
    for i in user_list:
        public_users.append(i.toPublic())
    return public_users

def get_user_by_id(db: authenticate_user, user_id: int, public: bool = False):
    user = db.query(model.User).filter(model.User.id == user_id).first()
    if public:
        return user if not user else user.toPublic()
    else:
        return user

def get_user_by_cpf(db: authenticate_user, user_cpf: str, public: bool = False):
    user = db.query(model.User).filter(model.User.cpf == user_cpf).first()
    if public:
        return user if not user else user.toPublic()
    else:
        return user

def check_permission(db: authenticate_user, user, perms: [int]) -> bool:
    user: UserPublic = get_user_by_id(db=db, user_id=user.get('id'))
    return True if int(user.permission_id) in perms else False

def create_user(db: authenticate_user, user: UserCreate):
    if (not db.query(model.Schedule).filter(model.Schedule.id == user.schedule_id).first()):
        return None
    _perm_id = 4 if user.permission_id == 1 else user.permission_id
    _user = model.User(
        name=user.name,
        cpf=user.cpf,
        password_hash=get_password_hash(user.password),
        role_id=user.role_id,
        schedule_id=user.schedule_id,
        permission_id=_perm_id
        )
    db.add(_user)
    db.commit()
    db.refresh(_user)
    return _user if not _user else _user.toPublic()

def update_user_property(db: authenticate_user, user_id: int, update_data: dict):
    user: UserPublic = get_user_by_id(db=db, user_id=user_id)

    for i in update_data:
        if str(i) in ["id"]:
            return None

    if "password_hash" in update_data:
        vulnerable_password: str = update_data["password_hash"]
        update_data["password_hash"] = get_password_hash(vulnerable_password)
        del vulnerable_password

    for field, value in update_data.items():
        if hasattr(user, field):
            setattr(user, field, value)
        else:
            raise ValueError(f"Field '{field}' does not exist on the User model")

    db.commit()
    db.refresh(user)
    return user.toPublic() if user else None