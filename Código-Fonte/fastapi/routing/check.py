from fastapi import APIRouter, Response, Depends
from sqlalchemy.orm import Session
from database import get_db

check_router = APIRouter()


# Check server connectivity
@check_router.get('/ping')
async def _check_ping(db: Session = Depends(get_db)):
    return Response(status_code=200)