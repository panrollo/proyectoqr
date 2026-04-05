from fastapi import APIRouter, Depends

from app.controllers import operations_controller
from app.schemas.operations import (
    AgendaEventCreate,
    AgendaEventUpdate,
    GroupCreate,
    GroupParticipantCreate,
    GroupParticipantUpdate,
    GroupTrainerCreate,
    GroupTrainerUpdate,
    GroupUpdate,
    LibraryResourceCreate,
    LibraryResourceUpdate,
    PersonCreate,
    PersonUpdate,
    PlannerCreate,
    PlannerUpdate,
)
from app.utils.auth_guard import require_session

router = APIRouter(tags=["operations"], dependencies=[Depends(require_session)])


@router.get("/people")
def get_people():
    return operations_controller.list_people()


@router.get("/people/{person_id}")
def get_person(person_id: int):
    return operations_controller.get_person(person_id)


@router.post("/people")
def create_person(payload: PersonCreate):
    return operations_controller.create_person(payload)


@router.put("/people/{person_id}")
def update_person(person_id: int, payload: PersonUpdate):
    return operations_controller.update_person(person_id, payload)


@router.delete("/people/{person_id}")
def delete_person(person_id: int):
    return operations_controller.delete_person(person_id)


@router.get("/groups")
def get_groups():
    return operations_controller.list_groups()


@router.get("/groups/{group_id}")
def get_group(group_id: int):
    return operations_controller.get_group(group_id)


@router.post("/groups")
def create_group(payload: GroupCreate):
    return operations_controller.create_group(payload)


@router.put("/groups/{group_id}")
def update_group(group_id: int, payload: GroupUpdate):
    return operations_controller.update_group(group_id, payload)


@router.delete("/groups/{group_id}")
def delete_group(group_id: int):
    return operations_controller.delete_group(group_id)


@router.get("/group-participants")
def get_group_participants():
    return operations_controller.list_group_participants()


@router.get("/group-participants/{group_participant_id}")
def get_group_participant(group_participant_id: int):
    return operations_controller.get_group_participant(group_participant_id)


@router.post("/group-participants")
def create_group_participant(payload: GroupParticipantCreate):
    return operations_controller.create_group_participant(payload)


@router.put("/group-participants/{group_participant_id}")
def update_group_participant(group_participant_id: int, payload: GroupParticipantUpdate):
    return operations_controller.update_group_participant(group_participant_id, payload)


@router.delete("/group-participants/{group_participant_id}")
def delete_group_participant(group_participant_id: int):
    return operations_controller.delete_group_participant(group_participant_id)


@router.get("/group-trainers")
def get_group_trainers():
    return operations_controller.list_group_trainers()


@router.get("/group-trainers/{group_trainer_id}")
def get_group_trainer(group_trainer_id: int):
    return operations_controller.get_group_trainer(group_trainer_id)


@router.post("/group-trainers")
def create_group_trainer(payload: GroupTrainerCreate):
    return operations_controller.create_group_trainer(payload)


@router.put("/group-trainers/{group_trainer_id}")
def update_group_trainer(group_trainer_id: int, payload: GroupTrainerUpdate):
    return operations_controller.update_group_trainer(group_trainer_id, payload)


@router.delete("/group-trainers/{group_trainer_id}")
def delete_group_trainer(group_trainer_id: int):
    return operations_controller.delete_group_trainer(group_trainer_id)


@router.get("/planners")
def get_planners():
    return operations_controller.list_planners()


@router.get("/planners/{planner_id}")
def get_planner(planner_id: int):
    return operations_controller.get_planner(planner_id)


@router.post("/planners")
def create_planner(payload: PlannerCreate):
    return operations_controller.create_planner(payload)


@router.put("/planners/{planner_id}")
def update_planner(planner_id: int, payload: PlannerUpdate):
    return operations_controller.update_planner(planner_id, payload)


@router.delete("/planners/{planner_id}")
def delete_planner(planner_id: int):
    return operations_controller.delete_planner(planner_id)


@router.get("/agenda-events")
def get_agenda_events():
    return operations_controller.list_agenda_events()


@router.get("/agenda-events/{agenda_event_id}")
def get_agenda_event(agenda_event_id: int):
    return operations_controller.get_agenda_event(agenda_event_id)


@router.post("/agenda-events")
def create_agenda_event(payload: AgendaEventCreate):
    return operations_controller.create_agenda_event(payload)


@router.put("/agenda-events/{agenda_event_id}")
def update_agenda_event(agenda_event_id: int, payload: AgendaEventUpdate):
    return operations_controller.update_agenda_event(agenda_event_id, payload)


@router.delete("/agenda-events/{agenda_event_id}")
def delete_agenda_event(agenda_event_id: int):
    return operations_controller.delete_agenda_event(agenda_event_id)


@router.get("/library-resources")
def get_library_resources():
    return operations_controller.list_library_resources()


@router.get("/library-resources/{library_resource_id}")
def get_library_resource(library_resource_id: int):
    return operations_controller.get_library_resource(library_resource_id)


@router.post("/library-resources")
def create_library_resource(payload: LibraryResourceCreate):
    return operations_controller.create_library_resource(payload)


@router.put("/library-resources/{library_resource_id}")
def update_library_resource(library_resource_id: int, payload: LibraryResourceUpdate):
    return operations_controller.update_library_resource(library_resource_id, payload)


@router.delete("/library-resources/{library_resource_id}")
def delete_library_resource(library_resource_id: int):
    return operations_controller.delete_library_resource(library_resource_id)
