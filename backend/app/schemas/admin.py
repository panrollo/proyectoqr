from pydantic import BaseModel, EmailStr


class UserCreate(BaseModel):
    full_name: str
    email: EmailStr
    role_id: int
    password: str
    status: int


class UserUpdate(BaseModel):
    full_name: str
    email: EmailStr
    role_id: int
    password: str | None = None
    status: int


class CampaignCreate(BaseModel):
    name: str
    cost_center: str
    description: str | None = None
    status: int


class CampaignUpdate(CampaignCreate):
    pass


class ActivityCreate(BaseModel):
    name: str
    description: str | None = None
    activity_type_id: int
    target_audience_id: int | None = None
    duration_hours: float | None = None
    status: int


class ActivityUpdate(ActivityCreate):
    pass
