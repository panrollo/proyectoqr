from app.services.query_service import fetch_all


def get_bootstrap_data():
    return {
        "roles": fetch_all("roles"),
        "users": fetch_all("users"),
        "campaigns": fetch_all("campaigns"),
        "activityTypes": fetch_all("activity_types"),
        "targetAudiences": fetch_all("target_audiences"),
        "activities": fetch_all("activities"),
        "people": fetch_all("people"),
        "groups": fetch_all("groups"),
        "groupParticipants": fetch_all("group_participants"),
        "groupTrainers": fetch_all("group_trainers"),
        "mans": fetch_all("mans"),
        "planners": fetch_all("planners"),
        "agendaEvents": fetch_all("agenda_events"),
        "libraryResources": fetch_all("library_resources"),
        "feedbackRecords": fetch_all("feedback_records"),
        "commitments": fetch_all("commitments"),
        "qualityMonitors": fetch_all("quality_monitors"),
        "ojtFollowups": fetch_all("ojt_followups"),
        "preShifts": fetch_all("pre_shifts"),
        "operationResults": fetch_all("operation_results"),
        "virtualSessions": fetch_all("virtual_sessions"),
    }
