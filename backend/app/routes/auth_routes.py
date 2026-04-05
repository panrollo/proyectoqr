from fastapi import APIRouter

from app.controllers.auth_controller import login
from app.schemas.auth import LoginRequest

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/login")
def post_login(payload: LoginRequest):
    return login(payload)
