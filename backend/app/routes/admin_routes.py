from fastapi import APIRouter, Depends

from app.controllers import admin_controller
from app.schemas.admin import ActivityCreate, ActivityUpdate, CampaignCreate, CampaignUpdate, UserCreate, UserUpdate
from app.utils.auth_guard import require_session

router = APIRouter(tags=["admin"], dependencies=[Depends(require_session)])


@router.get("/users")
def get_users():
    return admin_controller.list_users()


@router.get("/users/{user_id}")
def get_user(user_id: int):
    return admin_controller.get_user(user_id)


@router.post("/users")
def create_user(payload: UserCreate):
    return admin_controller.create_user(payload)


@router.put("/users/{user_id}")
def update_user(user_id: int, payload: UserUpdate):
    return admin_controller.update_user(user_id, payload)


@router.delete("/users/{user_id}")
def delete_user(user_id: int):
    return admin_controller.delete_user(user_id)


@router.get("/campaigns")
def get_campaigns():
    return admin_controller.list_campaigns()


@router.get("/campaigns/{campaign_id}")
def get_campaign(campaign_id: int):
    return admin_controller.get_campaign(campaign_id)


@router.post("/campaigns")
def create_campaign(payload: CampaignCreate):
    return admin_controller.create_campaign(payload)


@router.put("/campaigns/{campaign_id}")
def update_campaign(campaign_id: int, payload: CampaignUpdate):
    return admin_controller.update_campaign(campaign_id, payload)


@router.delete("/campaigns/{campaign_id}")
def delete_campaign(campaign_id: int):
    return admin_controller.delete_campaign(campaign_id)


@router.get("/activities")
def get_activities():
    return admin_controller.list_activities()


@router.get("/activities/{activity_id}")
def get_activity(activity_id: int):
    return admin_controller.get_activity(activity_id)


@router.post("/activities")
def create_activity(payload: ActivityCreate):
    return admin_controller.create_activity(payload)


@router.put("/activities/{activity_id}")
def update_activity(activity_id: int, payload: ActivityUpdate):
    return admin_controller.update_activity(activity_id, payload)


@router.delete("/activities/{activity_id}")
def delete_activity(activity_id: int):
    return admin_controller.delete_activity(activity_id)
