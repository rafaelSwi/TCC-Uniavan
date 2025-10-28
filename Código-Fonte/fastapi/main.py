from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import engine
from database import Base

from routing.check import check_router
from routing.user import user_router
from routing.activity import activity_router
from routing.project import project_router
from routing.token import auth_router
from routing.location import location_router
from routing.schedule import schedule_router
from routing.material import material_router

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def home():
    return "Teste da Minha API!"

app.include_router(check_router, prefix="/check", tags=["check"])
app.include_router(user_router, prefix="/user", tags=["user"])
app.include_router(activity_router, prefix="/activity", tags=["activity"])
app.include_router(project_router, prefix="/project", tags=["project"])
app.include_router(auth_router, prefix="/auth", tags=["auth"])
app.include_router(location_router, prefix="/location", tags=["location"])
app.include_router(schedule_router, prefix="/schedule", tags=["schedule"])
app.include_router(material_router, prefix="/material", tags=["material"])