from fastapi import APIRouter, Request, Response

from app.controllers import qr_controller
from app.schemas.qr import PublicQrAttendanceSubmit

router = APIRouter(prefix="/public", tags=["public-qr"])


@router.get("/qr/{qr_token}")
def get_public_qr(qr_token: str):
    return qr_controller.get_public_qr_access(qr_token)


@router.get("/attendance/{qr_token}")
def get_public_attendance(qr_token: str):
    return qr_controller.get_public_qr_access(qr_token)


@router.get("/qr/{qr_token}/image")
def get_public_qr_image(qr_token: str):
    return Response(content=qr_controller.render_public_qr_image(qr_token), media_type="image/svg+xml")


@router.get("/attendance/{qr_token}/image")
def get_public_attendance_image(qr_token: str):
    return Response(content=qr_controller.render_public_qr_image(qr_token), media_type="image/svg+xml")


@router.post("/qr/{qr_token}/submit")
def post_public_qr_submit(qr_token: str, payload: PublicQrAttendanceSubmit, request: Request):
    client_ip = request.client.host if request.client else None
    user_agent = request.headers.get("user-agent")
    return qr_controller.submit_public_qr_access(qr_token, payload, client_ip, user_agent)


@router.post("/attendance/{qr_token}/submit")
def post_public_attendance_submit(qr_token: str, payload: PublicQrAttendanceSubmit, request: Request):
    client_ip = request.client.host if request.client else None
    user_agent = request.headers.get("user-agent")
    return qr_controller.submit_public_qr_access(qr_token, payload, client_ip, user_agent)
