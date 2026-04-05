from app.services.procedure_service import execute_write
from app.services.query_service import fetch_all, fetch_one
from app.utils.security import generate_qr_code, hash_password


def list_users():
    return fetch_all("users")


def get_user(user_id: int):
    return fetch_one("users", user_id)


def create_user(payload):
    return execute_write(
        "users",
        "create",
        [
            payload.full_name,
            payload.email,
            hash_password(payload.password),
            payload.role_id,
            generate_qr_code(),
            payload.status,
        ],
    )


def update_user(user_id: int, payload):
    password_hash = hash_password(payload.password) if payload.password else ""
    return execute_write(
        "users",
        "update",
        [
            user_id,
            payload.full_name,
            payload.email,
            password_hash,
            payload.role_id,
            payload.status,
        ],
    )


def delete_user(user_id: int):
    return execute_write("users", "delete", [user_id])


def list_campaigns():
    return fetch_all("campaigns")


def get_campaign(campaign_id: int):
    return fetch_one("campaigns", campaign_id)


def create_campaign(payload):
    return execute_write(
        "campaigns",
        "create",
        [payload.name, payload.cost_center, payload.description, payload.status],
    )


def update_campaign(campaign_id: int, payload):
    return execute_write(
        "campaigns",
        "update",
        [campaign_id, payload.name, payload.cost_center, payload.description, payload.status],
    )


def delete_campaign(campaign_id: int):
    return execute_write("campaigns", "delete", [campaign_id])


def list_activities():
    return fetch_all("activities")


def get_activity(activity_id: int):
    return fetch_one("activities", activity_id)


def create_activity(payload):
    return execute_write(
        "activities",
        "create",
        [
            payload.name,
            payload.description,
            payload.activity_type_id,
            payload.target_audience_id,
            payload.duration_hours,
            payload.status,
        ],
    )


def update_activity(activity_id: int, payload):
    return execute_write(
        "activities",
        "update",
        [
            activity_id,
            payload.name,
            payload.description,
            payload.activity_type_id,
            payload.target_audience_id,
            payload.duration_hours,
            payload.status,
        ],
    )


def delete_activity(activity_id: int):
    return execute_write("activities", "delete", [activity_id])
