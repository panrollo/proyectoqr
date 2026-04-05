from fastapi import APIRouter, Depends

from app.controllers import qr_controller
from app.controllers import trainer_controller
from app.schemas.qr import BotModerationAction
from app.schemas.trainer import SessionLinkUpdate
from app.utils.auth_guard import require_session

router = APIRouter(prefix="/trainer", tags=["trainer"])


@router.get("/attendance/sessions")
def get_attendance_sessions(session_user: dict = Depends(require_session)):
    return trainer_controller.list_attendance_sessions(session_user)


@router.get("/attendance/sessions/{virtual_session_id}/records")
def get_attendance_records(virtual_session_id: int, session_user: dict = Depends(require_session)):
    return trainer_controller.get_attendance_records(session_user, virtual_session_id)


@router.put("/attendance/sessions/{virtual_session_id}/link")
def put_attendance_link(
    virtual_session_id: int,
    payload: SessionLinkUpdate,
    session_user: dict = Depends(require_session),
):
    return trainer_controller.save_session_link(session_user, virtual_session_id, payload)


@router.get("/attendance/sessions/{virtual_session_id}/expected-people")
def get_expected_people(virtual_session_id: int, session_user: dict = Depends(require_session)):
    return qr_controller.list_expected_people(session_user, virtual_session_id)


@router.get("/attendance/sessions/{virtual_session_id}/qr")
def get_session_qr_codes(virtual_session_id: int, session_user: dict = Depends(require_session)):
    return qr_controller.list_trainer_session_qr_codes(session_user, virtual_session_id)


@router.post("/attendance/sessions/{virtual_session_id}/qr/generate")
def post_session_qr_generate(virtual_session_id: int, session_user: dict = Depends(require_session)):
    return qr_controller.generate_trainer_session_qr_codes(session_user, virtual_session_id)


@router.get("/attendance/sessions/{virtual_session_id}/room-validation")
def get_room_validation(virtual_session_id: int, session_user: dict = Depends(require_session)):
    return qr_controller.list_room_validation(session_user, virtual_session_id)


@router.post("/attendance/sessions/{virtual_session_id}/room-validation/{teams_participant_id}/expel")
def post_room_expel(
    virtual_session_id: int,
    teams_participant_id: str,
    payload: BotModerationAction,
    session_user: dict = Depends(require_session),
):
    return qr_controller.request_room_expel(session_user, virtual_session_id, teams_participant_id, payload)
