from fastapi import APIRouter, Depends

from app.controllers import monitoring_controller
from app.schemas.monitoring import (
    CommitmentCreate,
    CommitmentUpdate,
    FeedbackCreate,
    FeedbackUpdate,
    OjtFollowupCreate,
    OjtFollowupUpdate,
    QualityMonitorCreate,
    QualityMonitorUpdate,
)
from app.utils.auth_guard import require_session

router = APIRouter(tags=["monitoring"], dependencies=[Depends(require_session)])


@router.get("/feedback-records")
def get_feedback_records():
    return monitoring_controller.list_feedback_records()


@router.get("/feedback-records/{feedback_id}")
def get_feedback_record(feedback_id: int):
    return monitoring_controller.get_feedback_record(feedback_id)


@router.post("/feedback-records")
def create_feedback_record(payload: FeedbackCreate):
    return monitoring_controller.create_feedback_record(payload)


@router.put("/feedback-records/{feedback_id}")
def update_feedback_record(feedback_id: int, payload: FeedbackUpdate):
    return monitoring_controller.update_feedback_record(feedback_id, payload)


@router.delete("/feedback-records/{feedback_id}")
def delete_feedback_record(feedback_id: int):
    return monitoring_controller.delete_feedback_record(feedback_id)


@router.get("/commitments")
def get_commitments():
    return monitoring_controller.list_commitments()


@router.get("/commitments/{commitment_id}")
def get_commitment(commitment_id: int):
    return monitoring_controller.get_commitment(commitment_id)


@router.post("/commitments")
def create_commitment(payload: CommitmentCreate):
    return monitoring_controller.create_commitment(payload)


@router.put("/commitments/{commitment_id}")
def update_commitment(commitment_id: int, payload: CommitmentUpdate):
    return monitoring_controller.update_commitment(commitment_id, payload)


@router.delete("/commitments/{commitment_id}")
def delete_commitment(commitment_id: int):
    return monitoring_controller.delete_commitment(commitment_id)


@router.get("/quality-monitors")
def get_quality_monitors():
    return monitoring_controller.list_quality_monitors()


@router.get("/quality-monitors/{quality_monitor_id}")
def get_quality_monitor(quality_monitor_id: int):
    return monitoring_controller.get_quality_monitor(quality_monitor_id)


@router.post("/quality-monitors")
def create_quality_monitor(payload: QualityMonitorCreate):
    return monitoring_controller.create_quality_monitor(payload)


@router.put("/quality-monitors/{quality_monitor_id}")
def update_quality_monitor(quality_monitor_id: int, payload: QualityMonitorUpdate):
    return monitoring_controller.update_quality_monitor(quality_monitor_id, payload)


@router.delete("/quality-monitors/{quality_monitor_id}")
def delete_quality_monitor(quality_monitor_id: int):
    return monitoring_controller.delete_quality_monitor(quality_monitor_id)


@router.get("/ojt-followups")
def get_ojt_followups():
    return monitoring_controller.list_ojt_followups()


@router.get("/ojt-followups/{ojt_followup_id}")
def get_ojt_followup(ojt_followup_id: int):
    return monitoring_controller.get_ojt_followup(ojt_followup_id)


@router.post("/ojt-followups")
def create_ojt_followup(payload: OjtFollowupCreate):
    return monitoring_controller.create_ojt_followup(payload)


@router.put("/ojt-followups/{ojt_followup_id}")
def update_ojt_followup(ojt_followup_id: int, payload: OjtFollowupUpdate):
    return monitoring_controller.update_ojt_followup(ojt_followup_id, payload)


@router.delete("/ojt-followups/{ojt_followup_id}")
def delete_ojt_followup(ojt_followup_id: int):
    return monitoring_controller.delete_ojt_followup(ojt_followup_id)
