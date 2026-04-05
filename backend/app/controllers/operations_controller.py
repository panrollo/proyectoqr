from datetime import datetime

from app.services.procedure_service import execute_write
from app.services.query_service import fetch_all, fetch_one
from app.utils.security import generate_group_code, generate_qr_code


def list_people():
    return fetch_all("people")


def get_person(person_id: int):
    return fetch_one("people", person_id)


def create_person(payload):
    return execute_write(
        "people",
        "create",
        [
            payload.document_type,
            payload.document_number,
            payload.first_name,
            payload.last_name,
            payload.email,
            payload.phone,
            payload.hire_date,
            payload.campaign_id,
            payload.hc_id,
            generate_qr_code(),
            payload.status,
        ],
    )


def update_person(person_id: int, payload):
    return execute_write(
        "people",
        "update",
        [
            person_id,
            payload.document_type,
            payload.document_number,
            payload.first_name,
            payload.last_name,
            payload.email,
            payload.phone,
            payload.hire_date,
            payload.campaign_id,
            payload.hc_id,
            payload.status,
        ],
    )


def delete_person(person_id: int):
    return execute_write("people", "delete", [person_id])


def list_groups():
    return fetch_all("groups")


def get_group(group_id: int):
    return fetch_one("groups", group_id)


def create_group(payload):
    group_code = payload.group_code or generate_group_code()
    return execute_write(
        "groups",
        "create",
        [group_code, payload.name, payload.campaign_id, payload.start_date, payload.end_date, payload.status],
    )


def update_group(group_id: int, payload):
    return execute_write(
        "groups",
        "update",
        [group_id, payload.group_code, payload.name, payload.campaign_id, payload.start_date, payload.end_date, payload.status],
    )


def delete_group(group_id: int):
    return execute_write("groups", "delete", [group_id])


def list_group_participants():
    return fetch_all("group_participants")


def get_group_participant(group_participant_id: int):
    return fetch_one("group_participants", group_participant_id)


def create_group_participant(payload):
    return execute_write(
        "group_participants",
        "create",
        [payload.group_id, payload.person_id, payload.assigned_at or datetime.now(), payload.status],
    )


def update_group_participant(group_participant_id: int, payload):
    return execute_write(
        "group_participants",
        "update",
        [group_participant_id, payload.group_id, payload.person_id, payload.assigned_at or datetime.now(), payload.status],
    )


def delete_group_participant(group_participant_id: int):
    return execute_write("group_participants", "delete", [group_participant_id])


def list_group_trainers():
    return fetch_all("group_trainers")


def get_group_trainer(group_trainer_id: int):
    return fetch_one("group_trainers", group_trainer_id)


def create_group_trainer(payload):
    return execute_write(
        "group_trainers",
        "create",
        [payload.group_id, payload.user_id, payload.assigned_at or datetime.now(), payload.trainer_role],
    )


def update_group_trainer(group_trainer_id: int, payload):
    return execute_write(
        "group_trainers",
        "update",
        [group_trainer_id, payload.group_id, payload.user_id, payload.assigned_at or datetime.now(), payload.trainer_role],
    )


def delete_group_trainer(group_trainer_id: int):
    return execute_write("group_trainers", "delete", [group_trainer_id])


def list_planners():
    return fetch_all("planners")


def get_planner(planner_id: int):
    return fetch_one("planners", planner_id)


def create_planner(payload):
    return execute_write(
        "planners",
        "create",
        [
            payload.man_id,
            payload.activity_id,
            payload.campaign_id,
            payload.group_id,
            payload.start_at,
            payload.end_at,
            payload.methodology,
            payload.room,
            payload.capacity,
            payload.status,
            payload.created_by,
        ],
    )


def update_planner(planner_id: int, payload):
    return execute_write(
        "planners",
        "update",
        [
            planner_id,
            payload.man_id,
            payload.activity_id,
            payload.campaign_id,
            payload.group_id,
            payload.start_at,
            payload.end_at,
            payload.methodology,
            payload.room,
            payload.capacity,
            payload.status,
            payload.created_by,
        ],
    )


def delete_planner(planner_id: int):
    return execute_write("planners", "delete", [planner_id])


def list_agenda_events():
    return fetch_all("agenda_events")


def get_agenda_event(agenda_event_id: int):
    return fetch_one("agenda_events", agenda_event_id)


def create_agenda_event(payload):
    return execute_write(
        "agenda_events",
        "create",
        [
            payload.planner_id,
            payload.group_id,
            payload.responsible_user_id,
            payload.title,
            payload.description,
            payload.start_at,
            payload.end_at,
            payload.modality,
            payload.status,
        ],
    )


def update_agenda_event(agenda_event_id: int, payload):
    return execute_write(
        "agenda_events",
        "update",
        [
            agenda_event_id,
            payload.planner_id,
            payload.group_id,
            payload.responsible_user_id,
            payload.title,
            payload.description,
            payload.start_at,
            payload.end_at,
            payload.modality,
            payload.status,
        ],
    )


def delete_agenda_event(agenda_event_id: int):
    return execute_write("agenda_events", "delete", [agenda_event_id])


def list_library_resources():
    return fetch_all("library_resources")


def get_library_resource(library_resource_id: int):
    return fetch_one("library_resources", library_resource_id)


def create_library_resource(payload):
    return execute_write(
        "library_resources",
        "create",
        [
            payload.activity_id,
            payload.created_by,
            payload.category,
            payload.title,
            payload.description,
            payload.resource_url,
            payload.status,
        ],
    )


def update_library_resource(library_resource_id: int, payload):
    return execute_write(
        "library_resources",
        "update",
        [
            library_resource_id,
            payload.activity_id,
            payload.created_by,
            payload.category,
            payload.title,
            payload.description,
            payload.resource_url,
            payload.status,
        ],
    )


def delete_library_resource(library_resource_id: int):
    return execute_write("library_resources", "delete", [library_resource_id])
