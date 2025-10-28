from encryption.constants import USER_DEPENDENCY
from fastapi import APIRouter, Depends, Response
from sqlalchemy.orm import Session
from crud.activity import create_activity, get_activities_associated_with_user_by_id, is_activity_related_with_logged_user, get_activity_by_id, update_activity_property, get_all_activities, create_clone_activity, get_activity_projects, is_user_responsible_for_activity_project
from crud.user import check_permission
from crud.chunk import get_chunks_by_activity_id, create_location_chunk, create_location_chunk_status, generate_activity_status, update_chunk_status_property, get_chunk_status_by_id, get_chunks_status_by_activity_and_chunk_id, get_chunks_by_location_id, able_to_update_chunk_status
from crud.location import get_location_by_id
from crud.project import get_project_by_id, is_user_responsible_for_any_project
from crud.association.project_employee import get_projects_associated_with_logged_user
from crud.association.project_activity import create_project_activity_association
from crud.association.project_rain import create_project_rain_association
from crud.association.activity_restriction import create_activity_restrictions_association, get_activity_restrictions, mark_all_activity_restrictions_as_deprecated, mark_activity_restriction_association_as_deprecated
from crud.association.activity_employee import create_activity_employee_association, get_activity_employees, mark_activity_employee_association_as_deprecated, get_specific_activity_employee_association, mark_all_activity_employees_as_deprecated
from crud.association.activity_material import create_activity_material_association, get_activity_materials
from crud.association.activity_chunk import create_activity_chunk_association, get_activity_chunks
from database import get_db
from schemas.activity import ActivityCreate, ActivityClone, Activity
from schemas.chunk import LocationChunkCreate, LocationChunkStatusCreate, LocationChunk, LocationChunkStatus
from schemas.association.project_rain import ProjectRainCreate
from schemas.association.project_activity import ProjectActivityCreate
from schemas.association.activity_restriction import ActivityRestrictionCreate
from schemas.association.activity_employee import ActivityEmployeeCreate
from schemas.association.activity_material import ActivityMaterialCreate
from schemas.association.activity_chunk import ActivityChunkCreate

activity_router = APIRouter()


# Create a new activity
@activity_router.post('/create')
async def _create(user: USER_DEPENDENCY, request: ActivityCreate, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        if not get_location_by_id(db=db, location_id=request.location_id):
            return Response(status_code=409)
        _activity = create_activity(db=db, user=user, activity=request)
        for restriction in request.restriction:
            _activity_restriction = ActivityRestrictionCreate(
                activity_id=_activity.id,
                restriction_id=restriction
            )
            create_activity_restrictions_association(db=db, association=_activity_restriction)
        for employee in request.employee:
            _activity_employee = ActivityEmployeeCreate(
                activity_id=_activity.id,
                employee_id=employee
            )
            create_activity_employee_association(db=db, association=_activity_employee)
        for material in request.materials:
            for materials_quantity in request.materials_quantity:
                _activity_material = ActivityMaterialCreate(
                    activity_id=_activity.id,
                    material_id=material,
                    quantity=materials_quantity
                )
                create_activity_material_association(db=db, association=_activity_material)
        for chunk in request.chunks:
            _activity_chunk = ActivityChunkCreate(
                activity_id=_activity.id,
                chunk_id=chunk
            )
            create_activity_chunk_association(db=db, association=_activity_chunk)

        if (request.project_id != None):
            if (request.rain == False):
                _project_activity = ProjectActivityCreate(
                    project_id=request.project_id,
                    activity_id=_activity.id
                )
                create_project_activity_association(db=db, association=_project_activity)
            else:
                _rain = ProjectRainCreate(
                    project_id=request.project_id,
                    rain_activity_id=_activity.id
                )
                create_project_rain_association(db=db, association=_rain)

        return Response(status_code=201)
    else:
        return Response(status_code=403)

# Clone an existing activity
@activity_router.post('/{activity_id}/clone')
async def _clone(user: USER_DEPENDENCY, request: ActivityClone, activity_id: int, db: Session = Depends(get_db)):
    base_activity: Activity = get_activity_by_id(db=db, activity_id=activity_id)
    if check_permission(db=db, user=user, perms=[1, 2]):
        if not get_location_by_id(db=db, location_id=base_activity.location_id):
            return Response(status_code=409)
        
        base_activity_employees = get_activity_employees(db=db, activity_id=activity_id)
        base_activity_chunks = get_activity_chunks(db=db, activity_id=activity_id)

        _activity = create_clone_activity(db=db, user=user, activity=request, location_id=base_activity.location_id)

        if (request.same_project):
            _activity_projects = get_activity_projects(db=db, activity_id=activity_id)
            for _project in _activity_projects:
                _project_activity = ProjectActivityCreate(
                    project_id=_project.id,
                    activity_id=_activity.id
                )
                create_project_activity_association(db=db, association=_project_activity)

        for restriction in request.restriction:
            _activity_restriction = ActivityRestrictionCreate(
                activity_id=_activity.id,
                restriction_id=restriction
            )
            create_activity_restrictions_association(db=db, association=_activity_restriction)
        for employee in base_activity_employees:
            _activity_employee = ActivityEmployeeCreate(
                activity_id=_activity.id,
                employee_id=employee.id
            )
            create_activity_employee_association(db=db, association=_activity_employee)
        for material in request.materials:
            for materials_quantity in request.materials_quantity:
                _activity_material = ActivityMaterialCreate(
                    activity_id=_activity.id,
                    material_id=material,
                    quantity=materials_quantity
                )
                create_activity_material_association(db=db, association=_activity_material)
        for chunk in base_activity_chunks:
            _activity_chunk = ActivityChunkCreate(
                activity_id=_activity.id,
                chunk_id=chunk.chunk_id
            )
            create_activity_chunk_association(db=db, association=_activity_chunk)
        return Response(status_code=201)
    else:
        return Response(status_code=403)


# Returns a list of activities associated with the logged user
@activity_router.get('/list')
async def _get_activities_associated_with_logged_user(user: USER_DEPENDENCY, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        try:
            return get_activities_associated_with_user_by_id(db=db, user=user, user_id=user.get('id'))
        except:
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Returns a list of activities associated with a specific user
@activity_router.get('/user/id/{user_id}/list')
async def _get_activities_associated_with_specific_user(user: USER_DEPENDENCY, user_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]) or user.get('id') == user_id:
        try:
            return get_activities_associated_with_user_by_id(db=db, user=user, user_id=user_id)
        except Exception as ex:
            print(f"Error: {ex}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)


# Returns a list of all activities
@activity_router.get('/all')
async def _get_all_activities(user: USER_DEPENDENCY, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        try:
            if check_permission(db=db, user=user, perms=[3]):
                if not is_user_responsible_for_any_project(db=db, user_id=user.get("id")):
                    return get_activities_associated_with_user_by_id(db=db, user=user, user_id=user.get('id'))
            return get_all_activities(db=db)
        except:
            return Response(status_code=500)
    else:
        return get_activities_associated_with_user_by_id(db=db, user=user, user_id=user.get('id'))


# Returns a activity based on its ID
@activity_router.get('/{activity_id}')
async def _get_location_by_id(user: USER_DEPENDENCY, activity_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_activity_related_with_logged_user(db=db, user=user, activity_id=activity_id):
                return Response(status_code=401)
        try:
            return get_activity_by_id(db=db, activity_id=activity_id)
        except:
            return Response(status_code=500)
    else:
        return Response(status_code=403)


# Update specific activity properties based on its ID
@activity_router.patch('/{activity_id}')
def _update_activity_property(user: USER_DEPENDENCY, activity_id: int, update_data: dict, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        try:
            if check_permission(db=db, user=user, perms=[3]):
                if not is_user_responsible_for_activity_project(db=db, activity_id=activity_id, user_id=user.get("id")):
                    return Response(status_code=403)
            if not get_activity_by_id(db=db, activity_id=activity_id):
                return Response(status_code=404) 
            response_data = update_activity_property(db=db, activity_id=activity_id, update_data=update_data)
            if not response_data:
                return Response(status_code=409)
            else:
                return response_data
        except Exception as e:
            print(f"error: {e}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)


# Returns restrictions of a activity based on its ID
@activity_router.get('/{activity_id}/restrictions')
async def _get_location_by_id(user: USER_DEPENDENCY, activity_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_activity_related_with_logged_user(db=db, user=user, activity_id=activity_id):
                return Response(status_code=401)
        try:
            return get_activity_restrictions(db=db, activity_id=activity_id)
        except Exception as ew:
            print(f"e: {ew}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Returns maerials of a activity based on its ID
@activity_router.get('/{activity_id}/materials')
async def _get_materials_by_id(user: USER_DEPENDENCY, activity_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_activity_related_with_logged_user(db=db, user=user, activity_id=activity_id):
                return Response(status_code=401)
        try:
            return get_activity_materials(db=db, activity_id=activity_id)
        except Exception as ew:
            print(f"e: {ew}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Returns employees of a activity based on its ID
@activity_router.get('/{activity_id}/employees')
async def _get_activity_employees_by_activity_id(user: USER_DEPENDENCY, activity_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_activity_related_with_logged_user(db=db, user=user, activity_id=activity_id):
                return Response(status_code=401)
        try:
            return get_activity_employees(db=db, activity_id=activity_id)
        except Exception as ew:
            print(f"e: {ew}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Returns materials of a activity based on its ID
@activity_router.get('/{activity_id}/materials')
async def _get_activity_materials_by_activity_id(user: USER_DEPENDENCY, activity_id: int, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        if check_permission(db=db, user=user, perms=[3]):
            if not is_activity_related_with_logged_user(db=db, user=user, activity_id=activity_id):
                return Response(status_code=401)
        try:
            return get_activity_materials(db=db, activity_id=activity_id)
        except Exception as ew:
            print(f"e: {ew}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Updates employees associated with an activity
@activity_router.patch('/{activity_id}/employees')
def _update_activity_employees(user: USER_DEPENDENCY, activity_id: int, new_ids: list[int], db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        try:
            if check_permission(db=db, user=user, perms=[3]):
                if not is_user_responsible_for_activity_project(db=db, activity_id=activity_id, user_id=user.get("id")):
                    return Response(status_code=403)
            if not get_activity_by_id(db=db, activity_id=activity_id):
                return Response(status_code=404)
            mark_all_activity_employees_as_deprecated(db=db, activity_id=activity_id)
            for _id in new_ids:
                _activity_employee = ActivityEmployeeCreate(
                    activity_id=activity_id,
                    employee_id=_id
                )
                create_activity_employee_association(db=db, association=_activity_employee)
        except Exception as e:
            print(f"error: {e}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Update restrictions for an activity
@activity_router.patch('/{activity_id}/restrictions')
def _update_activity_restrictions(user: USER_DEPENDENCY, activity_id: int, new_ids: list[int], db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        try:
            if check_permission(db=db, user=user, perms=[3]):
                if not is_user_responsible_for_activity_project(db=db, activity_id=activity_id, user_id=user.get("id")):
                    return Response(status_code=403)
            if not get_activity_by_id(db=db, activity_id=activity_id):
                return Response(status_code=404)
            mark_all_activity_restrictions_as_deprecated(db=db, activity_id=activity_id)
            for _id in new_ids:
                _activity_restriction = ActivityRestrictionCreate(
                    activity_id=activity_id,
                    restriction_id=_id
                )
                create_activity_restrictions_association(db=db, association=_activity_restriction)
        except Exception as e:
            print(f"error: {e}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)

# Returns a list of chunks based on its activity ID, creates status if missing
@activity_router.get('/{activity_id}/chunks')
async def _get_activity_chunks(user: USER_DEPENDENCY, activity_id: int, db: Session = Depends(get_db)):
    if not check_permission(db=db, user=user, perms=[1, 2, 3]):
        return Response(status_code=403)
    if check_permission(db=db, user=user, perms=[3]):
        if not is_activity_related_with_logged_user(db=db, user=user, activity_id=activity_id):
            return Response(status_code=401)
    try:
        return get_activity_chunks(db=db, activity_id=activity_id)
    except Exception as ex:
        print(f"Error: {ex}")
        return Response(status_code=500)

# Post a new chunk associated with a activity
@activity_router.post('/{activity_id}/chunk')
async def _create_chunk(user: USER_DEPENDENCY, activity_id: int, request: LocationChunkCreate, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2]):
        try:
            chunk: LocationChunk = create_location_chunk(db=db, association=request)
            if not chunk:
                return None
            _location_chunk_status = LocationChunkStatusCreate(
                activity_id = activity_id,
                chunk_id = chunk.id,
                status = False,
            )
            create_location_chunk_status(db=db, association=_location_chunk_status)
            _activity_chunk = ActivityChunkCreate(
                activity_id = activity_id,
                chunk_id = chunk.id
            )
            return create_activity_chunk_association(db=db, association=_activity_chunk)
        except Exception as ew:
            print(f"e: {ew}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)


# Update specific activity chunk status based on its ID
@activity_router.patch('/{activity_id}/chunk/{chunk_status_id}')
def _update_activity_chunk_property(user: USER_DEPENDENCY, activity_id: int, chunk_status_id: int, update_data: dict, db: Session = Depends(get_db)):
    if check_permission(db=db, user=user, perms=[1, 2, 3]):
        try:
            chunk_status: LocationChunkStatus = get_chunk_status_by_id(db=db, id=chunk_status_id)
            if not get_activity_by_id(db=db, activity_id=activity_id):
                return Response(status_code=404)
            if "status" in update_data:
                allowed: Bool = False
                if (update_data["status"] == False):
                    allowed = True
                else:
                    allowed: bool = able_to_update_chunk_status(db=db, activity_id=activity_id, chunk_id=chunk_status.chunk_id)
                if allowed:
                    if not (get_activity_by_id(db=db, activity_id=activity_id).done):
                        response_data = update_chunk_status_property(db=db, chunk_status_id=chunk_status.id, update_data=update_data)
                    else:
                        return Response(status_code=409, content="Activity already marked as done")
                else:
                    return Response(status_code=409, content="Restricted by incomplete activities in the same location chunk")
        except Exception as e:
            print(f"Error: {e}")
            return Response(status_code=500)
    else:
        return Response(status_code=403)