from app.services.procedure_service import execute_write
from app.services.query_service import fetch_all, fetch_one


def list_feedback_records():
    return fetch_all("feedback_records")


def get_feedback_record(feedback_id: int):
    return fetch_one("feedback_records", feedback_id)


def create_feedback_record(payload):
    return execute_write(
        "feedback_records",
        "create",
        [
            payload.person_id,
            payload.created_by,
            payload.source,
            payload.title,
            payload.strengths,
            payload.opportunities,
            payload.action_plan,
            payload.status,
        ],
    )


def update_feedback_record(feedback_id: int, payload):
    return execute_write(
        "feedback_records",
        "update",
        [
            feedback_id,
            payload.person_id,
            payload.created_by,
            payload.source,
            payload.title,
            payload.strengths,
            payload.opportunities,
            payload.action_plan,
            payload.status,
        ],
    )


def delete_feedback_record(feedback_id: int):
    return execute_write("feedback_records", "delete", [feedback_id])


def list_commitments():
    return fetch_all("commitments")


def get_commitment(commitment_id: int):
    return fetch_one("commitments", commitment_id)


def create_commitment(payload):
    return execute_write(
        "commitments",
        "create",
        [
            payload.feedback_id,
            payload.person_id,
            payload.responsible_user_id,
            payload.description,
            payload.commitment_date,
            payload.due_date,
            payload.status,
        ],
    )


def update_commitment(commitment_id: int, payload):
    return execute_write(
        "commitments",
        "update",
        [
            commitment_id,
            payload.feedback_id,
            payload.person_id,
            payload.responsible_user_id,
            payload.description,
            payload.commitment_date,
            payload.due_date,
            payload.status,
        ],
    )


def delete_commitment(commitment_id: int):
    return execute_write("commitments", "delete", [commitment_id])


def list_quality_monitors():
    return fetch_all("quality_monitors")


def get_quality_monitor(quality_monitor_id: int):
    return fetch_one("quality_monitors", quality_monitor_id)


def create_quality_monitor(payload):
    return execute_write(
        "quality_monitors",
        "create",
        [
            payload.person_id,
            payload.analyst_user_id,
            payload.call_id,
            payload.criteria,
            payload.score,
            payload.finding,
            payload.recommendation,
            payload.status,
        ],
    )


def update_quality_monitor(quality_monitor_id: int, payload):
    return execute_write(
        "quality_monitors",
        "update",
        [
            quality_monitor_id,
            payload.person_id,
            payload.analyst_user_id,
            payload.call_id,
            payload.criteria,
            payload.score,
            payload.finding,
            payload.recommendation,
            payload.status,
        ],
    )


def delete_quality_monitor(quality_monitor_id: int):
    return execute_write("quality_monitors", "delete", [quality_monitor_id])


def list_ojt_followups():
    return fetch_all("ojt_followups")


def get_ojt_followup(ojt_followup_id: int):
    return fetch_one("ojt_followups", ojt_followup_id)


def create_ojt_followup(payload):
    return execute_write(
        "ojt_followups",
        "create",
        [
            payload.person_id,
            payload.group_id,
            payload.day_number,
            payload.aht,
            payload.quality_score,
            payload.csat_score,
            payload.status,
            payload.notes,
        ],
    )


def update_ojt_followup(ojt_followup_id: int, payload):
    return execute_write(
        "ojt_followups",
        "update",
        [
            ojt_followup_id,
            payload.person_id,
            payload.group_id,
            payload.day_number,
            payload.aht,
            payload.quality_score,
            payload.csat_score,
            payload.status,
            payload.notes,
        ],
    )


def delete_ojt_followup(ojt_followup_id: int):
    return execute_write("ojt_followups", "delete", [ojt_followup_id])
