from sqlalchemy import Column, String, Integer, Time, Date, Boolean, ForeignKey, UniqueConstraint, Enum, Table, Float
from sqlalchemy.orm import relationship, sessionmaker, validates
from schemas.user import UserPublic
from database import Base
import enum


class Location(Base):

    __tablename__ = 'location'
    id = Column(Integer, primary_key=True)
    enterprise = Column(String(length=64))
    cep = Column(String(length=8))
    description = Column(String(length=64))
    deprecated = Column(Boolean(), default=False)

    activity = relationship("Activity", backref=__tablename__)
    chunks = relationship("Chunk", backref=__tablename__)


class Chunk(Base):

    __tablename__ = 'chunk'
    id = Column(Integer, primary_key=True)
    location_id = Column(Integer, ForeignKey("location.id"), nullable=False)
    info_one = Column(String(length=8), nullable=False)
    info_two = Column(String(length=8), nullable=False)
    info_three = Column(String(length=32), nullable=False)
    deprecated = Column(Boolean(), default=False)

    activity_statuses = relationship(
        "ActivityChunkStatus", 
        backref=__tablename__,
        foreign_keys="[ActivityChunkStatus.chunk_id]"
    )


class ActivityChunkStatus(Base):

    __tablename__ = 'activity_chunk_status'
    id = Column(Integer, primary_key=True)
    activity_id = Column(Integer, ForeignKey("activity.id"), nullable=False)
    chunk_id = Column(Integer, ForeignKey("chunk.id"), nullable=False)
    status = Column(Boolean(), default=False)
    creation_date = Column(Date(), nullable=False)
    done_date = Column(Date(), nullable=True)
    mark_done_date = Column(Date(), nullable=True)
    mark_done_by = Column(Integer, ForeignKey("user_account.id"), nullable=True)

    user = relationship("User", backref="marked_chunks", foreign_keys=[mark_done_by])


class Role(Base):

    __tablename__ = 'user_role'
    id = Column(Integer, primary_key=True)
    role_name = Column(String(length=32), nullable=False)

    user = relationship("User", backref=__tablename__)


class Permission(Base):

    __tablename__ = 'user_permission'
    id = Column(Integer, primary_key=True)
    permission_name = Column(String(length=3), nullable=False)

    user = relationship("User", backref=__tablename__)


class Schedule(Base):

    __tablename__ = 'schedule'
    id = Column(Integer, primary_key=True)
    schedule_name = Column(String(length=64), nullable=False)
    clock_in = Column(Time(), nullable=False)
    break_in = Column(Time())
    break_out = Column(Time())
    clock_out = Column(Time(), nullable=False)
    deprecated = Column(Boolean(), default=False, nullable=False)

    user = relationship("User", backref=__tablename__)

    # @validates('break_in', 'break_out')
    # def validate_break_times(self, key, value):
    #     if key == 'break_in':
    #         if value and not self.break_out:
    #             raise ValueError("You must set 'break_out' if 'break_in' is set.")
    #     if key == 'break_out':
    #         if value and not self.break_in:
    #             raise ValueError("You must set 'break_in' if 'break_out' is set.")
    #     return value


class User(Base):

    __tablename__ = 'user_account'
    id = Column(Integer, primary_key=True)
    name = Column(String(length=128), nullable=False)
    cpf = Column(String(length=11), nullable=False, unique=True)
    password_hash = Column(String(length=60), nullable=False)

    role_id = Column(Integer(), ForeignKey("user_role.id"), nullable=False)
    schedule_id = Column(Integer(), ForeignKey("schedule.id"), nullable=False)
    permission_id = Column(Integer(), ForeignKey("user_permission.id"), nullable=False)

    project_responsible = relationship("Project", backref="responsible", foreign_keys="[Project.responsible_id]")
    project_created = relationship("Project", backref="creator", foreign_keys="[Project.created_by]")
    employee = relationship("ProjectEmployeeAssociation", backref=__tablename__)

    chunks = relationship(
        "ActivityChunkStatus",
        backref="marked_by_user",
        foreign_keys="[ActivityChunkStatus.mark_done_by]"
    )

    def toPublic(self) -> UserPublic:
        return UserPublic(
            id=self.id,
            name=self.name,
            cpf=self.cpf,
            role_id=self.role_id,
            schedule_id=self.schedule_id,
            permission_id=self.permission_id
        )


class Activity(Base):

    __tablename__ = 'activity'
    id = Column(Integer, primary_key=True)
    description = Column(String(length=256), nullable=False)
    location_id = Column(Integer(), ForeignKey("location.id"), nullable=False)
    professional_amount = Column(Integer(), nullable=False)
    laborer_amount = Column(Integer(), nullable=False)
    professional_minutes = Column(Integer(), nullable=False)
    laborer_minutes = Column(Integer(), nullable=False)
    average_labor_cost = Column(Integer(), nullable=False)
    done = Column(Boolean(), default=False)
    created_by = Column(Integer(), ForeignKey("user_account.id"), nullable=False)
    creation_date = Column(Date(), nullable=False)
    start_date = Column(Date(), nullable=False)
    deadline_date = Column(Date(), nullable=False)
    done_date = Column(Date(), nullable=True)

    restriction = relationship(
        "ActivityRestrictionAssociation", 
        backref=__tablename__,
        foreign_keys="[ActivityRestrictionAssociation.activity_id]"
    )
    project = relationship("Project", secondary="project_activity", backref=__tablename__)
    rain = relationship("ProjectRainAssociation", backref=__tablename__)

    chunks = relationship(
        "ActivityChunkStatus",
        backref="activity",
        foreign_keys="[ActivityChunkStatus.activity_id]"
    )

    employees = relationship("User", secondary="activity_employee", backref="activities")
    material = relationship("ActivityMaterialAssociation", back_populates="activity")


class Material(Base):
    __tablename__ = "material"

    id = Column(Integer, primary_key=True)
    name = Column(String(length=64), nullable=False, unique=True)
    description = Column(String(length=255), nullable=True)
    average_price = Column(Float, nullable=True)
    measure = Column(String(length=32), nullable=True)
    in_stock = Column(Boolean, default=True)

    activity = relationship("ActivityMaterialAssociation", back_populates="material")


class ActivityMaterialAssociation(Base):
    __tablename__ = "activity_material"

    id = Column(Integer, primary_key=True)
    activity_id = Column(Integer, ForeignKey("activity.id"), nullable=False)
    material_id = Column(Integer, ForeignKey("material.id"), nullable=False)
    quantity = Column(Float, nullable=True)

    activity = relationship("Activity", back_populates="material")
    material = relationship("Material", back_populates="activity")

class ActivityRestrictionAssociation(Base):

    __tablename__ = 'activity_restriction'
    id = Column(Integer, primary_key=True)
    activity_id = Column(Integer(), ForeignKey("activity.id"), nullable=False)
    restriction_id = Column(Integer(), ForeignKey("activity.id"), nullable=False)
    deprecated = Column(Boolean(), default=False)


class Project(Base):

    __tablename__ = 'project'
    id = Column(Integer, primary_key=True)
    title = Column(String(length=64), nullable=False)
    start_date = Column(Date(), nullable=False)
    deadline_date = Column(Date(), nullable=False)
    active = Column(Boolean(), default=False)
    responsible_id = Column(Integer(), ForeignKey("user_account.id"), nullable=False)
    created_by = Column(Integer(), ForeignKey("user_account.id"), nullable=False)
    creation_date = Column(Date(), nullable=False)
    deactivation_date = Column(Date())

    employee = relationship("ProjectEmployeeAssociation", backref=__tablename__)
    rain = relationship("ProjectRainAssociation", backref=__tablename__)


class ProjectEmployeeAssociation(Base):

    __tablename__ = 'project_employee'
    id = Column(Integer, primary_key=True)
    project_id = Column(Integer(), ForeignKey("project.id"), nullable=False)
    employee_id = Column(Integer(), ForeignKey("user_account.id"), nullable=False)
    deprecated = Column(Boolean(), default=False)


class ActivityEmployeeAssociation(Base):
    
    __tablename__ = 'activity_employee'
    id = Column(Integer, primary_key=True)
    activity_id = Column(Integer(), ForeignKey("activity.id"), nullable=False)
    employee_id = Column(Integer(), ForeignKey("user_account.id"), nullable=False)
    deprecated = Column(Boolean(), default=False)

    __table_args__ = (UniqueConstraint('activity_id', 'employee_id', name='_activity_employee_uc'),)


class ActivityChunkAssociation(Base):
    
    __tablename__ = 'activity_chunk'
    id = Column(Integer, primary_key=True)
    activity_id = Column(Integer(), ForeignKey("activity.id"), nullable=False)
    chunk_id = Column(Integer(), ForeignKey("chunk.id"), nullable=False)
    deprecated = Column(Boolean(), default=False)

    __table_args__ = (UniqueConstraint('activity_id', 'chunk_id', name='_activity_chunk_uc'),)


class ProjectRainAssociation(Base):

    __tablename__ = 'project_rain'
    id = Column(Integer, primary_key=True)
    project_id = Column(Integer(), ForeignKey("project.id"), nullable=False)
    rain_activity_id = Column(Integer(), ForeignKey("activity.id"), nullable=False)
    deprecated = Column(Boolean(), default=False)


class ProjectActivityAssociation(Base):

    __tablename__ = 'project_activity'
    id = Column(Integer, primary_key=True)
    project_id = Column(Integer(), ForeignKey("project.id"), nullable=False)
    activity_id = Column(Integer(), ForeignKey("activity.id"), nullable=False)
    deprecated = Column(Boolean(), default=False)