from datetime import date, datetime

from pydantic import BaseModel, EmailStr


class PersonCreate(BaseModel):
    document_type: str | None = None
    document_number: str
    first_name: str
    last_name: str
    email: EmailStr | None = None
    phone: str | None = None
    hire_date: date | None = None
    campaign_id: int | None = None
    hc_id: int | None = None
    status: str | None = None


class PersonUpdate(PersonCreate):
    pass


class GroupCreate(BaseModel):
    group_code: str | None = None
    name: str
    campaign_id: int | None = None
    start_date: date | None = None
    end_date: date | None = None
    status: str | None = None


class GroupUpdate(GroupCreate):
    group_code: str


class GroupParticipantCreate(BaseModel):
    group_id: int
    person_id: int
    assigned_at: datetime | None = None
    status: str | None = None


class GroupParticipantUpdate(GroupParticipantCreate):
    pass


class GroupTrainerCreate(BaseModel):
    group_id: int
    user_id: int
    assigned_at: datetime | None = None
    trainer_role: str | None = None


class GroupTrainerUpdate(GroupTrainerCreate):
    pass


class PlannerCreate(BaseModel):
    man_id: int
    activity_id: int
    campaign_id: int | None = None
    group_id: int | None = None
    start_at: datetime
    end_at: datetime
    methodology: str | None = None
    room: str | None = None
    capacity: int | None = None
    status: str | None = None
    created_by: int | None = None


class PlannerUpdate(PlannerCreate):
    pass


class AgendaEventCreate(BaseModel):
    planner_id: int | None = None
    group_id: int | None = None
    responsible_user_id: int
    title: str
    description: str | None = None
    start_at: datetime
    end_at: datetime
    modality: str | None = None
    status: str | None = None


class AgendaEventUpdate(AgendaEventCreate):
    pass


class LibraryResourceCreate(BaseModel):
    activity_id: int | None = None
    created_by: int
    category: str
    title: str
    description: str | None = None
    resource_url: str | None = None
    status: str | None = None


class LibraryResourceUpdate(LibraryResourceCreate):
    pass
