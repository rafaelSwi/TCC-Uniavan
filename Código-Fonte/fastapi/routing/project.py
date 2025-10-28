from encryption.constants import USER_DEPENDENCY
from fastapi import HTTPException
from datetime import date
from fastapi import APIRouter, Depends, Response
from crud.project import create_project, get_active_projects_sorted_by_deadline, get_project_compact_by_id, edit_project, get_projects_associated_with_user_by_id, get_project_by_id
from crud.user import check_permission, get_user_by_id
from crud.association.project_rain import create_project_rain_association, get_project_rain
from crud.association.project_activity import create_project_activity_association, get_activities_by_project_id
from crud.association.project_employee import create_project_employee_association, get_projects_associated_with_logged_user, is_project_related_with_logged_user
from database import get_db
from sqlalchemy.orm import Session
from schemas.activity import Activity
from schemas.user import UserPublic
import models as model
from schemas.project import ProjectCreate, Project, ProjectEdit
from schemas.association.project_rain import ProjectRainCreate
from schemas.association.project_employee import ProjectEmployeeCreate
from schemas.association.project_activity import ProjectActivityCreate
from schemas.compact.project import ProjectCompactView

project_router = APIRouter()


# Returns a list of projects closer to expiring
@project_router.get('/deadline')
async def _get_projects_associated_with_logged_user(user: USER_DEPENDENCY, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        try:
            return get_active_projects_sorted_by_deadline(db=db)
        except Exception as e:
            print(f"error: {e}")
            return Response(status_code=500)
    else:
        return get_projects_associated_with_user_by_id(db=db, user=user, user_id=user.get('id'))


# Returns a list of projects associated with the logged user
@project_router.get('/list')
async def _get_projects_associated_with_logged_user(user: USER_DEPENDENCY, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        try:
            return get_projects_associated_with_user_by_id(db=db, user=user, user_id=user.get('id'))
        except:
            return Response(status_code=500)
    else:
        return Response(status_code=403)


# Create a new project
@project_router.post('/create')
async def _create(user: USER_DEPENDENCY, request: ProjectCreate, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        _project = create_project(db=db, user=user, project=request)
        for employee in request.employee:
            _project_employee = ProjectEmployeeCreate(
                project_id=_project.id,
                employee_id=employee
            )
            create_project_employee_association(db=db, association=_project_employee)
        for rain in request.rain:
            _project_rain = ProjectRainCreate(
                project_id=_project.id,
                rain_activity_id=rain
            )
            create_project_rain_association(db=db, association=_project_rain)
        for activity in request.activity:
            _project_activity = ProjectActivityCreate(
                project_id=_project.id,
                activity_id=activity 
            )
            create_project_activity_association(db=db, association=_project_activity)
        return Response(status_code=201)
    else:
        return Response(status_code=403)


# Edit a project
@project_router.patch('/{project_id}')
async def _edit_project(user: USER_DEPENDENCY, project_id: int, request: ProjectEdit, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        try:
            if check_permission(db=db, user=user, perms=[3]):
                _project: model.Project = get_project_by_id(db=db, project_id=project_id)
                if not (_project.responsible_id == user.get("id")):
                    return Response(status_code=403)
            edit_project(db=db, user=user, project_edit=request)
            return Response(status_code=200)
        except Exception as e:
            print(f"Error: {e}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Returns which services should be done in case of rain on the day of the project
@project_router.get('/{project_id}/rain')
async def _get_project_rains_by_id(user: USER_DEPENDENCY, project_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_project_related_with_logged_user(db=db, user=user, project_id=project_id):
                return Response(status_code=401)
        try:
            return get_project_rain(db=db, project_id=project_id)
        except:
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Returns which activities are linked to the project
@project_router.get('/{project_id}/activity')
async def _get_project_activities_by_id(user: USER_DEPENDENCY, project_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_project_related_with_logged_user(db=db, user=user, project_id=project_id):
                return Response(status_code=401)
        try:
            return get_activities_by_project_id(db=db, project_id=project_id)
        except:
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Returns a compact view of a Project, the responsible, the creator, and the main activity
@project_router.get('/{project_id}/compact')
async def _get_compact_project_by_id(user: USER_DEPENDENCY, project_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_project_related_with_logged_user(db=db, user=user, project_id=project_id):
                return Response(status_code=401)
        try:
            return get_project_compact_by_id(db=db, project_id=project_id)
        except Exception as ex:
            print(f"Error: {ex}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)


@project_router.patch('/{project_id}/finish')
async def _finish_project(user: USER_DEPENDENCY, project_id: int, db: Session = Depends(get_db)):
    has_high_permission = check_permission(db=db, user=user, perms=[1, 2])
    _project: model.Project = get_project_by_id(db=db, project_id=project_id)

    if not _project:
        raise HTTPException(status_code=404, detail="Projeto não encontrado")

    if not has_high_permission and _project.responsible_id != user.get("id"):
        raise HTTPException(status_code=403, detail="Você não tem permissão para finalizar este projeto")

    activities = (
        db.query(model.Activity)
        .join(model.ProjectActivityAssociation, model.ProjectActivityAssociation.activity_id == model.Activity.id)
        .filter(model.ProjectActivityAssociation.project_id == project_id)
        .all()
    )

    if not all(a.done for a in activities):
        raise HTTPException(
            status_code=400,
            detail="Unable to complete project: There are unfinished activities."
        )

    _project.active = False
    _project.deactivation_date = date.today()
    db.commit()

    return {"message": "Project completed successfully"}