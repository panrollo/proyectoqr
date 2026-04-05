DROP VIEW IF EXISTS vw_login_users;
CREATE VIEW vw_login_users AS
SELECT
    u.id_usuario AS user_id,
    u.nombre_completo AS full_name,
    u.correo AS email,
    u.clave_hash AS password_hash,
    u.id_rol AS role_id,
    r.nombre AS role_key,
    u.codigo_qr_unico AS qr_code,
    u.estado AS status,
    u.fecha_creacion AS created_at
FROM usuarios u
INNER JOIN roles r ON r.id_rol = u.id_rol;

DROP VIEW IF EXISTS vw_auth_access;
CREATE VIEW vw_auth_access AS
SELECT
    u.id_usuario AS user_id,
    u.nombre_completo AS full_name,
    u.correo AS email,
    LOWER(TRIM(u.correo)) AS login_identity,
    u.clave_hash AS password_hash,
    u.id_rol AS role_id,
    r.nombre AS role_key,
    u.codigo_qr_unico AS qr_code,
    u.estado AS status,
    u.fecha_creacion AS created_at
FROM usuarios u
INNER JOIN roles r ON r.id_rol = u.id_rol;

DROP VIEW IF EXISTS vw_roles_catalog;
CREATE VIEW vw_roles_catalog AS
SELECT
    id_rol AS role_id,
    nombre AS role_key,
    estado AS status,
    fecha_creacion AS created_at
FROM roles;

DROP VIEW IF EXISTS vw_users;
CREATE VIEW vw_users AS
SELECT
    u.id_usuario AS user_id,
    u.nombre_completo AS full_name,
    u.correo AS email,
    u.id_rol AS role_id,
    r.nombre AS role_key,
    u.codigo_qr_unico AS qr_code,
    u.estado AS status,
    u.fecha_creacion AS created_at
FROM usuarios u
INNER JOIN roles r ON r.id_rol = u.id_rol;

DROP VIEW IF EXISTS vw_campaigns;
CREATE VIEW vw_campaigns AS
SELECT
    c.id_campana AS campaign_id,
    c.nombre AS name,
    c.ceco AS cost_center,
    c.descripcion AS description,
    c.estado AS status,
    c.fecha_creacion AS created_at,
    (
        SELECT COUNT(*)
        FROM opr o
        WHERE o.id_campana = c.id_campana
    ) AS groups_total,
    (
        SELECT COUNT(*)
        FROM personas p
        WHERE p.id_campana = c.id_campana
    ) AS people_total
FROM campanas c;

DROP VIEW IF EXISTS vw_activity_types;
CREATE VIEW vw_activity_types AS
SELECT
    id_tipo_actividad AS activity_type_id,
    nombre AS name,
    descripcion AS description,
    estado AS status,
    fecha_creacion AS created_at
FROM tipo_actividad;

DROP VIEW IF EXISTS vw_target_audiences;
CREATE VIEW vw_target_audiences AS
SELECT
    id_publico_objetivo AS target_audience_id,
    nombre AS name,
    descripcion AS description,
    fecha_creacion AS created_at
FROM publico_objetivo;

DROP VIEW IF EXISTS vw_activities;
CREATE VIEW vw_activities AS
SELECT
    a.id_actividad AS activity_id,
    a.nombre AS name,
    a.descripcion AS description,
    a.id_tipo_actividad AS activity_type_id,
    ta.nombre AS activity_type_name,
    a.id_publico_objetivo AS target_audience_id,
    po.nombre AS target_audience_name,
    a.duracion_horas AS duration_hours,
    a.estado AS status,
    a.fecha_creacion AS created_at
FROM actividades a
INNER JOIN tipo_actividad ta ON ta.id_tipo_actividad = a.id_tipo_actividad
LEFT JOIN publico_objetivo po ON po.id_publico_objetivo = a.id_publico_objetivo;

DROP VIEW IF EXISTS vw_people;
CREATE VIEW vw_people AS
SELECT
    p.id_persona AS person_id,
    p.tipo_documento AS document_type,
    p.numero_documento AS document_number,
    p.nombres AS first_name,
    p.apellidos AS last_name,
    CONCAT(p.nombres, ' ', p.apellidos) AS full_name,
    p.correo AS email,
    p.telefono AS phone,
    p.fecha_ingreso AS hire_date,
    p.id_campana AS campaign_id,
    c.nombre AS campaign_name,
    p.id_hc AS hc_id,
    h.codigo_hc AS hc_code,
    p.codigo_qr_unico AS qr_code,
    p.estado AS status,
    p.fecha_creacion AS created_at
FROM personas p
LEFT JOIN campanas c ON c.id_campana = p.id_campana
LEFT JOIN hc h ON h.id_hc = p.id_hc;

DROP VIEW IF EXISTS vw_groups;
CREATE VIEW vw_groups AS
SELECT
    o.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS name,
    o.id_campana AS campaign_id,
    c.nombre AS campaign_name,
    o.fecha_inicio AS start_date,
    o.fecha_fin AS end_date,
    o.estado AS status,
    o.fecha_creacion AS created_at,
    (
        SELECT COUNT(*)
        FROM opr_participantes op
        WHERE op.id_opr = o.id_opr
          AND (op.estado IS NULL OR op.estado <> 'RETIRADO')
    ) AS participants_total,
    (
        SELECT COUNT(*)
        FROM formador_asignado fa
        WHERE fa.id_opr = o.id_opr
    ) AS trainers_total
FROM opr o
LEFT JOIN campanas c ON c.id_campana = o.id_campana;

DROP VIEW IF EXISTS vw_group_participants;
CREATE VIEW vw_group_participants AS
SELECT
    op.id_opr_participante AS group_participant_id,
    op.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    op.id_persona AS person_id,
    CONCAT(p.nombres, ' ', p.apellidos) AS person_name,
    p.numero_documento AS document_number,
    op.fecha_asignacion AS assigned_at,
    op.estado AS status
FROM opr_participantes op
INNER JOIN opr o ON o.id_opr = op.id_opr
INNER JOIN personas p ON p.id_persona = op.id_persona;

DROP VIEW IF EXISTS vw_group_trainers;
CREATE VIEW vw_group_trainers AS
SELECT
    fa.id_formador_asignado AS group_trainer_id,
    fa.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    fa.id_usuario AS user_id,
    u.nombre_completo AS user_name,
    r.nombre AS role_key,
    fa.fecha_asignacion AS assigned_at,
    fa.rol_formador AS trainer_role
FROM formador_asignado fa
INNER JOIN opr o ON o.id_opr = fa.id_opr
INNER JOIN usuarios u ON u.id_usuario = fa.id_usuario
INNER JOIN roles r ON r.id_rol = u.id_rol;

DROP VIEW IF EXISTS vw_mans;
CREATE VIEW vw_mans AS
SELECT
    m.id_man AS man_id,
    m.codigo AS man_code,
    m.fecha_solicitud AS request_date,
    m.id_campana AS campaign_id,
    c.nombre AS campaign_name,
    m.id_actividad AS activity_id,
    a.nombre AS activity_name,
    m.tema_tipologia AS topic,
    m.nombre_del_pensum AS syllabus_name,
    m.objetivo_del_pensum AS syllabus_goal,
    m.estado AS status,
    m.fecha_creacion AS created_at
FROM man m
LEFT JOIN campanas c ON c.id_campana = m.id_campana
INNER JOIN actividades a ON a.id_actividad = m.id_actividad;

DROP VIEW IF EXISTS vw_planners;
CREATE VIEW vw_planners AS
SELECT
    p.id_planificador AS planner_id,
    p.id_man AS man_id,
    m.codigo AS man_code,
    p.id_actividad AS activity_id,
    a.nombre AS activity_name,
    p.id_campana AS campaign_id,
    c.nombre AS campaign_name,
    p.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    p.fecha_inicio AS start_at,
    p.fecha_fin AS end_at,
    p.metodologia AS methodology,
    p.sala AS room,
    p.cupo AS capacity,
    p.estado AS status,
    p.creado_por AS created_by,
    u.nombre_completo AS created_by_name,
    p.fecha_creacion AS created_at
FROM planificador p
INNER JOIN man m ON m.id_man = p.id_man
INNER JOIN actividades a ON a.id_actividad = p.id_actividad
LEFT JOIN campanas c ON c.id_campana = p.id_campana
LEFT JOIN opr o ON o.id_opr = p.id_opr
LEFT JOIN usuarios u ON u.id_usuario = p.creado_por;

DROP VIEW IF EXISTS vw_agenda_events;
CREATE VIEW vw_agenda_events AS
SELECT
    ag.id_agenda_evento AS agenda_event_id,
    ag.id_planificador AS planner_id,
    ag.id_opr AS group_id,
    ag.id_responsable AS responsible_user_id,
    ag.titulo AS title,
    ag.descripcion AS description,
    ag.fecha_inicio AS start_at,
    ag.fecha_fin AS end_at,
    ag.modalidad AS modality,
    ag.estado AS status,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    u.nombre_completo AS responsible_name
FROM agenda_eventos ag
LEFT JOIN opr o ON o.id_opr = ag.id_opr
INNER JOIN usuarios u ON u.id_usuario = ag.id_responsable;

DROP VIEW IF EXISTS vw_library_resources;
CREATE VIEW vw_library_resources AS
SELECT
    b.id_biblioteca_actividad AS library_resource_id,
    b.id_actividad AS activity_id,
    a.nombre AS activity_name,
    b.creado_por AS created_by,
    u.nombre_completo AS created_by_name,
    b.categoria AS category,
    b.titulo AS title,
    b.descripcion AS description,
    b.recurso_url AS resource_url,
    b.estado AS status,
    b.fecha_creacion AS created_at
FROM biblioteca_actividades b
LEFT JOIN actividades a ON a.id_actividad = b.id_actividad
INNER JOIN usuarios u ON u.id_usuario = b.creado_por;

DROP VIEW IF EXISTS vw_feedback_records;
CREATE VIEW vw_feedback_records AS
SELECT
    r.id_retroalimentacion AS feedback_id,
    r.id_persona AS person_id,
    CONCAT(p.nombres, ' ', p.apellidos) AS person_name,
    r.creado_por AS created_by,
    u.nombre_completo AS created_by_name,
    ru.nombre AS created_by_role,
    r.origen AS source,
    r.titulo AS title,
    r.fortalezas AS strengths,
    r.oportunidades AS opportunities,
    r.plan_accion AS action_plan,
    r.estado AS status,
    r.fecha_creacion AS created_at
FROM retroalimentaciones r
INNER JOIN personas p ON p.id_persona = r.id_persona
INNER JOIN usuarios u ON u.id_usuario = r.creado_por
INNER JOIN roles ru ON ru.id_rol = u.id_rol;

DROP VIEW IF EXISTS vw_commitments;
CREATE VIEW vw_commitments AS
SELECT
    c.id_compromiso AS commitment_id,
    c.id_retroalimentacion AS feedback_id,
    r.titulo AS feedback_title,
    c.id_persona AS person_id,
    CONCAT(p.nombres, ' ', p.apellidos) AS person_name,
    c.id_usuario_responsable AS responsible_user_id,
    u.nombre_completo AS responsible_name,
    c.descripcion AS description,
    c.fecha_compromiso AS commitment_date,
    c.fecha_vencimiento AS due_date,
    c.estado AS status,
    c.fecha_creacion AS created_at
FROM compromisos c
INNER JOIN retroalimentaciones r ON r.id_retroalimentacion = c.id_retroalimentacion
INNER JOIN personas p ON p.id_persona = c.id_persona
LEFT JOIN usuarios u ON u.id_usuario = c.id_usuario_responsable;

DROP VIEW IF EXISTS vw_quality_monitors;
CREATE VIEW vw_quality_monitors AS
SELECT
    m.id_monitoreo_calidad AS quality_monitor_id,
    m.id_persona AS person_id,
    CONCAT(p.nombres, ' ', p.apellidos) AS person_name,
    m.id_analista AS analyst_user_id,
    u.nombre_completo AS analyst_name,
    m.call_id AS call_id,
    m.criterio AS criteria,
    m.puntaje AS score,
    m.hallazgo AS finding,
    m.recomendacion AS recommendation,
    m.estado AS status,
    m.fecha_creacion AS created_at
FROM monitoreos_calidad m
INNER JOIN personas p ON p.id_persona = m.id_persona
INNER JOIN usuarios u ON u.id_usuario = m.id_analista;

DROP VIEW IF EXISTS vw_ojt_followups;
CREATE VIEW vw_ojt_followups AS
SELECT
    s.id_ojt_seguimiento AS ojt_followup_id,
    s.id_persona AS person_id,
    CONCAT(p.nombres, ' ', p.apellidos) AS person_name,
    s.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    s.dia AS day_number,
    s.aht AS aht,
    s.calidad AS quality_score,
    s.csat AS csat_score,
    s.estado AS status,
    s.observacion AS notes,
    s.fecha_creacion AS created_at
FROM ojt_seguimientos s
INNER JOIN personas p ON p.id_persona = s.id_persona
INNER JOIN opr o ON o.id_opr = s.id_opr;

DROP VIEW IF EXISTS vw_pre_shifts;
CREATE VIEW vw_pre_shifts AS
SELECT
    pr.id_preturno AS pre_shift_id,
    pr.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    pr.creado_por AS created_by,
    u.nombre_completo AS created_by_name,
    pr.tema AS topic,
    pr.fecha AS scheduled_date,
    pr.preguntas AS question_total,
    pr.nota_promedio AS average_score,
    pr.estado AS status,
    pr.fecha_creacion AS created_at
FROM preturnos pr
INNER JOIN opr o ON o.id_opr = pr.id_opr
INNER JOIN usuarios u ON u.id_usuario = pr.creado_por;

DROP VIEW IF EXISTS vw_operation_results;
CREATE VIEW vw_operation_results AS
SELECT
    ro.id_resultado_operacion AS operation_result_id,
    ro.id_persona AS person_id,
    CONCAT(p.nombres, ' ', p.apellidos) AS person_name,
    ro.modulo AS module_name,
    ro.indicador AS indicator_name,
    ro.valor_inicial AS initial_value,
    ro.valor_final AS final_value,
    ro.tendencia AS trend,
    ro.observacion AS notes,
    ro.fecha_creacion AS created_at
FROM resultado_operacion ro
INNER JOIN personas p ON p.id_persona = ro.id_persona;

DROP VIEW IF EXISTS vw_virtual_sessions;
CREATE VIEW vw_virtual_sessions AS
SELECT
    sv.id_sesion_virtual AS virtual_session_id,
    sv.id_planificador AS planner_id,
    p.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    a.nombre AS activity_name,
    sv.teams_join_url AS join_url,
    sv.qr_token AS qr_token,
    sv.qr_expira_en AS qr_expires_at,
    sv.estado_sesion AS session_status,
    sv.creado_en AS created_at,
    sv.actualizado_en AS updated_at
FROM sesion_virtual sv
INNER JOIN planificador p ON p.id_planificador = sv.id_planificador
LEFT JOIN opr o ON o.id_opr = p.id_opr
INNER JOIN actividades a ON a.id_actividad = p.id_actividad;

DROP VIEW IF EXISTS vw_trainer_attendance_sessions;
CREATE VIEW vw_trainer_attendance_sessions AS
SELECT
    sv.id_sesion_virtual AS virtual_session_id,
    sv.id_planificador AS planner_id,
    p.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    p.id_actividad AS activity_id,
    a.nombre AS activity_name,
    p.fecha_inicio AS start_at,
    p.fecha_fin AS end_at,
    fa.id_usuario AS trainer_user_id,
    u.nombre_completo AS trainer_name,
    fa.rol_formador AS trainer_role,
    sv.teams_join_url AS join_url,
    sv.estado_sesion AS session_status,
    sv.qr_expira_en AS qr_expires_at,
    sv.creado_en AS created_at,
    COUNT(DISTINCT gp.id_opr_participante) AS expected_participants_total,
    COUNT(DISTINCT attendance.id_asistencia_scan) AS attendance_taken_total
FROM sesion_virtual sv
INNER JOIN planificador p ON p.id_planificador = sv.id_planificador
LEFT JOIN opr o ON o.id_opr = p.id_opr
INNER JOIN actividades a ON a.id_actividad = p.id_actividad
INNER JOIN formador_asignado fa ON fa.id_opr = p.id_opr
INNER JOIN usuarios u ON u.id_usuario = fa.id_usuario
LEFT JOIN opr_participantes gp
    ON gp.id_opr = p.id_opr
   AND (gp.estado IS NULL OR gp.estado <> 'RETIRADO')
LEFT JOIN asistencia_scan attendance ON attendance.id_sesion_virtual = sv.id_sesion_virtual
GROUP BY
    sv.id_sesion_virtual,
    sv.id_planificador,
    p.id_opr,
    o.codigo_opr,
    o.nombre,
    p.id_actividad,
    a.nombre,
    p.fecha_inicio,
    p.fecha_fin,
    fa.id_usuario,
    u.nombre_completo,
    fa.rol_formador,
    sv.teams_join_url,
    sv.estado_sesion,
    sv.qr_expira_en,
    sv.creado_en;

DROP VIEW IF EXISTS vw_trainer_attendance_records;
CREATE VIEW vw_trainer_attendance_records AS
SELECT
    attendance.id_asistencia_scan AS attendance_record_id,
    attendance.id_sesion_virtual AS virtual_session_id,
    attendance.id_sesion_virtual_qr AS session_qr_id,
    qr.tipo_qr AS qr_type,
    attendance.qr_token_capturado AS captured_qr_token,
    attendance.tipo_documento_capturado AS captured_document_type,
    sv.id_planificador AS planner_id,
    p.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    p.id_actividad AS activity_id,
    a.nombre AS activity_name,
    fa.id_usuario AS trainer_user_id,
    attendance.id_persona AS person_id,
    COALESCE(CONCAT(pe.nombres, ' ', pe.apellidos), attendance.nombre_capturado) AS participant_name,
    COALESCE(pe.numero_documento, attendance.cedula_capturada) AS document_number,
    attendance.nombre_capturado AS captured_name,
    attendance.cedula_capturada AS captured_document,
    attendance.id_campana_capturada AS campaign_id,
    c.nombre AS campaign_name,
    attendance.estado_validacion AS validation_status,
    attendance.origen AS source,
    attendance.fecha_scan AS scanned_at,
    attendance.observacion AS notes,
    wf.estado_asistencia AS wave_status,
    wf.fecha_registro AS wave_recorded_at
FROM asistencia_scan attendance
INNER JOIN sesion_virtual sv ON sv.id_sesion_virtual = attendance.id_sesion_virtual
INNER JOIN planificador p ON p.id_planificador = sv.id_planificador
LEFT JOIN opr o ON o.id_opr = p.id_opr
INNER JOIN actividades a ON a.id_actividad = p.id_actividad
INNER JOIN formador_asignado fa ON fa.id_opr = p.id_opr
LEFT JOIN personas pe ON pe.id_persona = attendance.id_persona
LEFT JOIN campanas c ON c.id_campana = attendance.id_campana_capturada
LEFT JOIN sesion_virtual_qr qr ON qr.id_sesion_virtual_qr = attendance.id_sesion_virtual_qr
LEFT JOIN wave_formador wf
    ON wf.id_sesion_virtual = attendance.id_sesion_virtual
   AND wf.id_persona = attendance.id_persona;

DROP VIEW IF EXISTS vw_attendance_qr_records;
CREATE VIEW vw_attendance_qr_records AS
SELECT
    attendance.id_asistencia_scan AS attendance_record_id,
    attendance.id_sesion_virtual AS virtual_session_id,
    attendance.id_sesion_virtual_qr AS session_qr_id,
    qr.tipo_qr AS qr_type,
    attendance.qr_token_capturado AS captured_qr_token,
    attendance.tipo_documento_capturado AS captured_document_type,
    sv.id_planificador AS planner_id,
    p.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    p.id_actividad AS activity_id,
    a.nombre AS activity_name,
    attendance.id_persona AS person_id,
    COALESCE(CONCAT(pe.nombres, ' ', pe.apellidos), attendance.nombre_capturado) AS participant_name,
    COALESCE(pe.numero_documento, attendance.cedula_capturada) AS document_number,
    attendance.nombre_capturado AS captured_name,
    attendance.cedula_capturada AS captured_document,
    attendance.id_campana_capturada AS campaign_id,
    c.nombre AS campaign_name,
    attendance.estado_validacion AS validation_status,
    attendance.origen AS source,
    attendance.fecha_scan AS scanned_at,
    attendance.observacion AS notes,
    wf.estado_asistencia AS wave_status,
    wf.fecha_registro AS wave_recorded_at
FROM asistencia_scan attendance
INNER JOIN sesion_virtual sv ON sv.id_sesion_virtual = attendance.id_sesion_virtual
INNER JOIN planificador p ON p.id_planificador = sv.id_planificador
LEFT JOIN opr o ON o.id_opr = p.id_opr
INNER JOIN actividades a ON a.id_actividad = p.id_actividad
LEFT JOIN personas pe ON pe.id_persona = attendance.id_persona
LEFT JOIN campanas c ON c.id_campana = attendance.id_campana_capturada
LEFT JOIN sesion_virtual_qr qr ON qr.id_sesion_virtual_qr = attendance.id_sesion_virtual_qr
LEFT JOIN wave_formador wf
    ON wf.id_sesion_virtual = attendance.id_sesion_virtual
   AND wf.id_persona = attendance.id_persona;

DROP VIEW IF EXISTS vw_document_types;
CREATE VIEW vw_document_types AS
SELECT
    id_tipo_documento_catalogo AS document_type_id,
    codigo AS code,
    nombre AS name,
    regex_documento AS regex_pattern,
    longitud_minima AS min_length,
    longitud_maxima AS max_length,
    estado AS status,
    fecha_creacion AS created_at
FROM tipo_documento_catalogo
WHERE estado = 1;

DROP VIEW IF EXISTS vw_public_qr_access;
CREATE VIEW vw_public_qr_access AS
SELECT
    qr.id_sesion_virtual_qr AS session_qr_id,
    qr.id_sesion_virtual AS virtual_session_id,
    sv.id_planificador AS planner_id,
    qr.tipo_qr AS qr_type,
    qr.qr_token AS qr_token,
    qr.public_url AS public_url,
    qr.activa_desde AS active_from,
    qr.expira_en AS expires_at,
    CASE
        WHEN NOW() < qr.activa_desde THEN 'PENDIENTE'
        WHEN NOW() > qr.expira_en THEN 'EXPIRADO'
        ELSE 'VIGENTE'
    END AS qr_status,
    qr.estado AS stored_status,
    p.fecha_inicio AS session_start_at,
    p.fecha_fin AS session_end_at,
    p.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    p.id_actividad AS activity_id,
    a.nombre AS activity_name,
    p.id_campana AS campaign_id,
    c.nombre AS campaign_name,
    sv.estado_sesion AS session_status,
    sv.teams_join_url AS join_url
FROM sesion_virtual_qr qr
INNER JOIN sesion_virtual sv ON sv.id_sesion_virtual = qr.id_sesion_virtual
INNER JOIN planificador p ON p.id_planificador = sv.id_planificador
LEFT JOIN opr o ON o.id_opr = p.id_opr
INNER JOIN actividades a ON a.id_actividad = p.id_actividad
LEFT JOIN campanas c ON c.id_campana = p.id_campana;

DROP VIEW IF EXISTS vw_trainer_session_qr_codes;
CREATE VIEW vw_trainer_session_qr_codes AS
SELECT
    qr.id_sesion_virtual_qr AS session_qr_id,
    qr.id_sesion_virtual AS virtual_session_id,
    sv.id_planificador AS planner_id,
    fa.id_usuario AS trainer_user_id,
    qr.tipo_qr AS qr_type,
    qr.qr_token AS qr_token,
    qr.public_url AS public_url,
    qr.activa_desde AS active_from,
    qr.expira_en AS expires_at,
    CASE
        WHEN NOW() < qr.activa_desde THEN 'PENDIENTE'
        WHEN NOW() > qr.expira_en THEN 'EXPIRADO'
        ELSE 'VIGENTE'
    END AS qr_status,
    p.fecha_inicio AS session_start_at,
    p.fecha_fin AS session_end_at,
    p.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    p.id_actividad AS activity_id,
    a.nombre AS activity_name,
    p.id_campana AS campaign_id,
    c.nombre AS campaign_name
FROM sesion_virtual_qr qr
INNER JOIN sesion_virtual sv ON sv.id_sesion_virtual = qr.id_sesion_virtual
INNER JOIN planificador p ON p.id_planificador = sv.id_planificador
LEFT JOIN opr o ON o.id_opr = p.id_opr
INNER JOIN actividades a ON a.id_actividad = p.id_actividad
LEFT JOIN campanas c ON c.id_campana = p.id_campana
INNER JOIN formador_asignado fa ON fa.id_opr = p.id_opr;

DROP VIEW IF EXISTS vw_session_expected_people;
CREATE VIEW vw_session_expected_people AS
SELECT
    sv.id_sesion_virtual AS virtual_session_id,
    p.id_planificador AS planner_id,
    p.id_opr AS group_id,
    p.id_campana AS campaign_id,
    c.nombre AS campaign_name,
    op.id_opr_participante AS group_participant_id,
    pe.id_persona AS person_id,
    UPPER(COALESCE(pe.tipo_documento, '')) AS document_type,
    pe.numero_documento AS document_number,
    CONCAT(pe.nombres, ' ', pe.apellidos) AS full_name,
    pe.nombres AS first_name,
    pe.apellidos AS last_name,
    LOWER(TRIM(pe.correo)) AS email,
    pe.id_hc AS hc_id,
    h.codigo_hc AS hc_code,
    CASE WHEN pe.id_hc IS NULL THEN 0 ELSE 1 END AS is_in_hc,
    CASE WHEN op.estado IS NULL OR UPPER(op.estado) = 'ACTIVO' THEN 1 ELSE 0 END AS is_active
FROM sesion_virtual sv
INNER JOIN planificador p ON p.id_planificador = sv.id_planificador
LEFT JOIN campanas c ON c.id_campana = p.id_campana
INNER JOIN opr_participantes op ON op.id_opr = p.id_opr
INNER JOIN personas pe ON pe.id_persona = op.id_persona
LEFT JOIN hc h ON h.id_hc = pe.id_hc;

DROP VIEW IF EXISTS vw_session_room_validation;
CREATE VIEW vw_session_room_validation AS
SELECT
    live.id_teams_participante_live AS room_participant_id,
    live.id_sesion_virtual AS virtual_session_id,
    sv.id_planificador AS planner_id,
    p.id_opr AS group_id,
    o.codigo_opr AS group_code,
    o.nombre AS group_name,
    p.id_actividad AS activity_id,
    a.nombre AS activity_name,
    fa.id_usuario AS trainer_user_id,
    live.teams_participant_id AS teams_participant_id,
    live.display_name AS display_name,
    LOWER(TRIM(live.email)) AS email,
    live.estado_participacion AS participation_status,
    live.fecha_join AS join_time,
    live.fecha_leave AS leave_time,
    live.autorizado AS live_authorized_flag,
    live.razon_validacion AS live_validation_reason,
    expected.person_id AS expected_person_id,
    expected.full_name AS expected_person_name,
    expected.document_number AS expected_document_number,
    expected.hc_code AS expected_hc_code,
    attendance.estado_validacion AS attendance_validation_status,
    CASE
        WHEN expected.person_id IS NOT NULL THEN 'AUTORIZADO_EN_LISTA'
        WHEN attendance.id_asistencia_scan IS NOT NULL THEN 'REGISTRADO_SIN_MATCH_DIRECTO'
        ELSE 'NO_AUTORIZADO'
    END AS room_validation_status
FROM teams_participante_live live
INNER JOIN sesion_virtual sv ON sv.id_sesion_virtual = live.id_sesion_virtual
INNER JOIN planificador p ON p.id_planificador = sv.id_planificador
LEFT JOIN opr o ON o.id_opr = p.id_opr
INNER JOIN actividades a ON a.id_actividad = p.id_actividad
INNER JOIN formador_asignado fa ON fa.id_opr = p.id_opr
LEFT JOIN vw_session_expected_people expected
    ON expected.virtual_session_id = live.id_sesion_virtual
   AND (
        (live.email IS NOT NULL AND expected.email IS NOT NULL AND LOWER(TRIM(live.email)) = expected.email)
        OR (live.display_name IS NOT NULL AND LOWER(TRIM(live.display_name)) = LOWER(TRIM(expected.full_name)))
   )
LEFT JOIN (
    SELECT
        id_sesion_virtual,
        id_persona,
        MAX(id_asistencia_scan) AS latest_attendance_record_id
    FROM asistencia_scan
    WHERE id_persona IS NOT NULL
    GROUP BY id_sesion_virtual, id_persona
) latest_attendance
    ON latest_attendance.id_sesion_virtual = live.id_sesion_virtual
   AND latest_attendance.id_persona = expected.person_id
LEFT JOIN asistencia_scan attendance ON attendance.id_asistencia_scan = latest_attendance.latest_attendance_record_id;
