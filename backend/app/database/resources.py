READ_VIEWS = {
    "auth_access": {
        "view": "vw_auth_access",
        "id": "user_id",
        "order_by": "full_name",
        "filters": ["login_identity", "status"],
    },
    "login_users": {"view": "vw_login_users", "id": "user_id", "order_by": "full_name"},
    "roles": {"view": "vw_roles_catalog", "id": "role_id", "order_by": "role_key"},
    "document_types": {"view": "vw_document_types", "id": "document_type_id", "order_by": "name"},
    "users": {"view": "vw_users", "id": "user_id", "order_by": "full_name"},
    "campaigns": {"view": "vw_campaigns", "id": "campaign_id", "order_by": "created_at DESC"},
    "activity_types": {"view": "vw_activity_types", "id": "activity_type_id", "order_by": "name"},
    "target_audiences": {"view": "vw_target_audiences", "id": "target_audience_id", "order_by": "name"},
    "activities": {"view": "vw_activities", "id": "activity_id", "order_by": "created_at DESC"},
    "people": {"view": "vw_people", "id": "person_id", "order_by": "created_at DESC"},
    "groups": {"view": "vw_groups", "id": "group_id", "order_by": "created_at DESC"},
    "group_participants": {"view": "vw_group_participants", "id": "group_participant_id", "order_by": "assigned_at DESC"},
    "group_trainers": {"view": "vw_group_trainers", "id": "group_trainer_id", "order_by": "assigned_at DESC"},
    "mans": {"view": "vw_mans", "id": "man_id", "order_by": "created_at DESC"},
    "planners": {"view": "vw_planners", "id": "planner_id", "order_by": "start_at DESC"},
    "agenda_events": {"view": "vw_agenda_events", "id": "agenda_event_id", "order_by": "start_at DESC"},
    "library_resources": {"view": "vw_library_resources", "id": "library_resource_id", "order_by": "created_at DESC"},
    "feedback_records": {"view": "vw_feedback_records", "id": "feedback_id", "order_by": "created_at DESC"},
    "commitments": {"view": "vw_commitments", "id": "commitment_id", "order_by": "created_at DESC"},
    "quality_monitors": {"view": "vw_quality_monitors", "id": "quality_monitor_id", "order_by": "created_at DESC"},
    "ojt_followups": {"view": "vw_ojt_followups", "id": "ojt_followup_id", "order_by": "created_at DESC"},
    "pre_shifts": {"view": "vw_pre_shifts", "id": "pre_shift_id", "order_by": "created_at DESC"},
    "operation_results": {"view": "vw_operation_results", "id": "operation_result_id", "order_by": "created_at DESC"},
    "virtual_sessions": {"view": "vw_virtual_sessions", "id": "virtual_session_id", "order_by": "created_at DESC"},
    "trainer_attendance_sessions": {
        "view": "vw_trainer_attendance_sessions",
        "id": "virtual_session_id",
        "order_by": "start_at DESC",
        "filters": ["trainer_user_id", "virtual_session_id"],
    },
    "trainer_attendance_records": {
        "view": "vw_trainer_attendance_records",
        "id": "attendance_record_id",
        "order_by": "scanned_at DESC",
        "filters": ["trainer_user_id", "virtual_session_id"],
    },
    "attendance_qr_records": {
        "view": "vw_attendance_qr_records",
        "id": "attendance_record_id",
        "order_by": "scanned_at DESC",
        "filters": ["attendance_record_id", "virtual_session_id", "person_id"],
    },
    "public_qr_access": {
        "view": "vw_public_qr_access",
        "id": "session_qr_id",
        "order_by": "active_from DESC",
        "filters": ["qr_token", "virtual_session_id", "qr_type"],
    },
    "trainer_session_qr_codes": {
        "view": "vw_trainer_session_qr_codes",
        "id": "session_qr_id",
        "order_by": "active_from ASC",
        "filters": ["trainer_user_id", "virtual_session_id", "qr_type", "qr_token"],
    },
    "session_expected_people": {
        "view": "vw_session_expected_people",
        "id": "group_participant_id",
        "order_by": "full_name",
        "filters": ["virtual_session_id", "document_number", "document_type", "campaign_id", "person_id"],
    },
    "session_room_validation": {
        "view": "vw_session_room_validation",
        "id": "room_participant_id",
        "order_by": "join_time DESC",
        "filters": ["trainer_user_id", "virtual_session_id"],
    },
}


WRITE_PROCEDURES = {
    "users": {
        "create": "sp_usuario_create",
        "update": "sp_usuario_update",
        "delete": "sp_usuario_delete",
    },
    "campaigns": {
        "create": "sp_campana_create",
        "update": "sp_campana_update",
        "delete": "sp_campana_delete",
    },
    "activities": {
        "create": "sp_actividad_create",
        "update": "sp_actividad_update",
        "delete": "sp_actividad_delete",
    },
    "people": {
        "create": "sp_persona_create",
        "update": "sp_persona_update",
        "delete": "sp_persona_delete",
    },
    "groups": {
        "create": "sp_opr_create",
        "update": "sp_opr_update",
        "delete": "sp_opr_delete",
    },
    "group_participants": {
        "create": "sp_opr_participante_create",
        "update": "sp_opr_participante_update",
        "delete": "sp_opr_participante_delete",
    },
    "group_trainers": {
        "create": "sp_formador_asignado_create",
        "update": "sp_formador_asignado_update",
        "delete": "sp_formador_asignado_delete",
    },
    "planners": {
        "create": "sp_planificador_create",
        "update": "sp_planificador_update",
        "delete": "sp_planificador_delete",
    },
    "agenda_events": {
        "create": "sp_agenda_evento_create",
        "update": "sp_agenda_evento_update",
        "delete": "sp_agenda_evento_delete",
    },
    "library_resources": {
        "create": "sp_biblioteca_actividad_create",
        "update": "sp_biblioteca_actividad_update",
        "delete": "sp_biblioteca_actividad_delete",
    },
    "feedback_records": {
        "create": "sp_retroalimentacion_create",
        "update": "sp_retroalimentacion_update",
        "delete": "sp_retroalimentacion_delete",
    },
    "commitments": {
        "create": "sp_compromiso_create",
        "update": "sp_compromiso_update",
        "delete": "sp_compromiso_delete",
    },
    "quality_monitors": {
        "create": "sp_monitoreo_calidad_create",
        "update": "sp_monitoreo_calidad_update",
        "delete": "sp_monitoreo_calidad_delete",
    },
    "ojt_followups": {
        "create": "sp_ojt_seguimiento_create",
        "update": "sp_ojt_seguimiento_update",
        "delete": "sp_ojt_seguimiento_delete",
    },
    "attendance_sessions": {
        "save_link": "sp_sesion_virtual_enlace_guardar",
    },
    "session_qr_codes": {
        "upsert": "sp_sesion_virtual_qr_upsert",
    },
    "public_qr_attendance": {
        "register": "sp_asistencia_qr_registrar",
        "invalid": "sp_asistencia_qr_intento_invalido_registrar",
    },
    "bot_moderation": {
        "log": "sp_teams_moderacion_log_registrar",
    },
}
