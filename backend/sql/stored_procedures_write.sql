DELIMITER $$

DROP PROCEDURE IF EXISTS sp_usuario_create $$
CREATE PROCEDURE sp_usuario_create(
    IN p_nombre_completo VARCHAR(150),
    IN p_correo VARCHAR(150),
    IN p_clave_hash VARCHAR(255),
    IN p_id_rol INT,
    IN p_codigo_qr_unico CHAR(36),
    IN p_estado TINYINT(1)
)
BEGIN
    INSERT INTO usuarios (
        nombre_completo, correo, clave_hash, id_rol, codigo_qr_unico, estado
    )
    VALUES (
        p_nombre_completo, p_correo, p_clave_hash, p_id_rol, p_codigo_qr_unico, p_estado
    );

    SELECT * FROM vw_usuarios_detalle WHERE id_usuario = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_usuario_update $$
CREATE PROCEDURE sp_usuario_update(
    IN p_id_usuario INT,
    IN p_nombre_completo VARCHAR(150),
    IN p_correo VARCHAR(150),
    IN p_clave_hash VARCHAR(255),
    IN p_id_rol INT,
    IN p_estado TINYINT(1)
)
BEGIN
    UPDATE usuarios
    SET nombre_completo = p_nombre_completo,
        correo = p_correo,
        clave_hash = COALESCE(NULLIF(p_clave_hash, ''), clave_hash),
        id_rol = p_id_rol,
        estado = p_estado
    WHERE id_usuario = p_id_usuario;

    SELECT * FROM vw_usuarios_detalle WHERE id_usuario = p_id_usuario;
END $$

DROP PROCEDURE IF EXISTS sp_usuario_delete $$
CREATE PROCEDURE sp_usuario_delete(IN p_id_usuario INT)
BEGIN
    DELETE FROM usuario_permisos WHERE id_usuario = p_id_usuario;
    DELETE FROM usuarios WHERE id_usuario = p_id_usuario;
END $$

DROP PROCEDURE IF EXISTS sp_campana_create $$
CREATE PROCEDURE sp_campana_create(
    IN p_nombre VARCHAR(150),
    IN p_ceco VARCHAR(50),
    IN p_descripcion VARCHAR(255),
    IN p_estado TINYINT(1)
)
BEGIN
    INSERT INTO campanas (nombre, ceco, descripcion, estado)
    VALUES (p_nombre, p_ceco, p_descripcion, p_estado);
    SELECT id_campana, nombre, ceco, descripcion, estado
    FROM campanas WHERE id_campana = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_hc_create $$
CREATE PROCEDURE sp_hc_create(
    IN p_codigo_hc VARCHAR(50),
    IN p_descripcion VARCHAR(150),
    IN p_id_campana INT,
    IN p_estado TINYINT(1)
)
BEGIN
    INSERT INTO hc (codigo_hc, descripcion, id_campana, estado)
    VALUES (p_codigo_hc, p_descripcion, p_id_campana, p_estado);
    SELECT id_hc, codigo_hc, descripcion, id_campana, estado
    FROM hc WHERE id_hc = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_tipo_actividad_create $$
CREATE PROCEDURE sp_tipo_actividad_create(
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_estado TINYINT(1)
)
BEGIN
    INSERT INTO tipo_actividad (nombre, descripcion, estado)
    VALUES (p_nombre, p_descripcion, p_estado);
    SELECT id_tipo_actividad, nombre, descripcion, estado
    FROM tipo_actividad WHERE id_tipo_actividad = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_publico_objetivo_create $$
CREATE PROCEDURE sp_publico_objetivo_create(
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255)
)
BEGIN
    INSERT INTO publico_objetivo (nombre, descripcion)
    VALUES (p_nombre, p_descripcion);
    SELECT id_publico_objetivo, nombre, descripcion
    FROM publico_objetivo WHERE id_publico_objetivo = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_motivo_lista_naranja_create $$
CREATE PROCEDURE sp_motivo_lista_naranja_create(
    IN p_nombre VARCHAR(150),
    IN p_descripcion TEXT,
    IN p_estado TINYINT(1)
)
BEGIN
    INSERT INTO motivo_lista_naranja (nombre, descripcion, estado)
    VALUES (p_nombre, p_descripcion, p_estado);
    SELECT id_motivo, nombre, descripcion, estado
    FROM motivo_lista_naranja WHERE id_motivo = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_certificacion_create $$
CREATE PROCEDURE sp_certificacion_create(
    IN p_nombre VARCHAR(150),
    IN p_descripcion TEXT,
    IN p_estado TINYINT(1)
)
BEGIN
    INSERT INTO certificaciones (nombre, descripcion, estado)
    VALUES (p_nombre, p_descripcion, p_estado);
    SELECT id_certificacion, nombre, descripcion, estado
    FROM certificaciones WHERE id_certificacion = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_encuesta_create $$
CREATE PROCEDURE sp_encuesta_create(
    IN p_nombre VARCHAR(150),
    IN p_descripcion TEXT,
    IN p_pregunta1 TEXT,
    IN p_pregunta2 TEXT,
    IN p_pregunta3 TEXT,
    IN p_pregunta4 TEXT,
    IN p_pregunta5 TEXT,
    IN p_pregunta6 TEXT,
    IN p_pregunta7 TEXT,
    IN p_pregunta8 TEXT,
    IN p_pregunta9 TEXT,
    IN p_pregunta10 TEXT,
    IN p_observacion TEXT,
    IN p_estado TINYINT(1)
)
BEGIN
    INSERT INTO encuestas (
        nombre, descripcion, pregunta1, pregunta2, pregunta3, pregunta4, pregunta5,
        pregunta6, pregunta7, pregunta8, pregunta9, pregunta10, observacion, estado
    )
    VALUES (
        p_nombre, p_descripcion, p_pregunta1, p_pregunta2, p_pregunta3, p_pregunta4, p_pregunta5,
        p_pregunta6, p_pregunta7, p_pregunta8, p_pregunta9, p_pregunta10, p_observacion, p_estado
    );

    SELECT
        id_encuesta, nombre, descripcion, pregunta1, pregunta2, pregunta3, pregunta4, pregunta5,
        pregunta6, pregunta7, pregunta8, pregunta9, pregunta10, observacion, estado
    FROM encuestas
    WHERE id_encuesta = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_persona_create $$
CREATE PROCEDURE sp_persona_create(
    IN p_tipo_documento VARCHAR(20),
    IN p_numero_documento VARCHAR(30),
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_correo VARCHAR(150),
    IN p_telefono VARCHAR(30),
    IN p_fecha_ingreso DATE,
    IN p_id_campana INT,
    IN p_id_hc INT,
    IN p_codigo_qr_unico CHAR(36),
    IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO personas (
        tipo_documento, numero_documento, nombres, apellidos, correo, telefono,
        fecha_ingreso, id_campana, id_hc, codigo_qr_unico, estado
    )
    VALUES (
        p_tipo_documento, p_numero_documento, p_nombres, p_apellidos, p_correo, p_telefono,
        p_fecha_ingreso, p_id_campana, p_id_hc, p_codigo_qr_unico, p_estado
    );

    SELECT
        id_persona, tipo_documento, numero_documento, nombres, apellidos, correo, telefono,
        fecha_ingreso, id_campana, id_hc, codigo_qr_unico, estado
    FROM personas
    WHERE id_persona = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_actividad_create $$
CREATE PROCEDURE sp_actividad_create(
    IN p_nombre VARCHAR(200),
    IN p_descripcion TEXT,
    IN p_id_tipo_actividad INT,
    IN p_id_publico_objetivo INT,
    IN p_duracion_horas DECIMAL(5, 2),
    IN p_estado TINYINT(1)
)
BEGIN
    INSERT INTO actividades (
        nombre, descripcion, id_tipo_actividad, id_publico_objetivo, duracion_horas, estado
    )
    VALUES (
        p_nombre, p_descripcion, p_id_tipo_actividad, p_id_publico_objetivo, p_duracion_horas, p_estado
    );

    SELECT
        id_actividad, nombre, descripcion, id_tipo_actividad, id_publico_objetivo, duracion_horas, estado
    FROM actividades
    WHERE id_actividad = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_opr_create $$
CREATE PROCEDURE sp_opr_create(
    IN p_codigo_opr VARCHAR(50),
    IN p_nombre VARCHAR(150),
    IN p_id_campana INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO opr (codigo_opr, nombre, id_campana, fecha_inicio, fecha_fin, estado)
    VALUES (p_codigo_opr, p_nombre, p_id_campana, p_fecha_inicio, p_fecha_fin, p_estado);

    SELECT id_opr, codigo_opr, nombre, id_campana, fecha_inicio, fecha_fin, estado
    FROM opr WHERE id_opr = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_opr_participante_create $$
CREATE PROCEDURE sp_opr_participante_create(
    IN p_id_opr INT,
    IN p_id_persona INT,
    IN p_fecha_asignacion DATETIME,
    IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO opr_participantes (id_opr, id_persona, fecha_asignacion, estado)
    VALUES (p_id_opr, p_id_persona, p_fecha_asignacion, p_estado);

    SELECT id_opr_participante, id_opr, id_persona, fecha_asignacion, estado
    FROM opr_participantes WHERE id_opr_participante = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_formador_asignado_create $$
CREATE PROCEDURE sp_formador_asignado_create(
    IN p_id_opr INT,
    IN p_id_usuario INT,
    IN p_fecha_asignacion DATETIME,
    IN p_rol_formador VARCHAR(100)
)
BEGIN
    INSERT INTO formador_asignado (id_opr, id_usuario, fecha_asignacion, rol_formador)
    VALUES (p_id_opr, p_id_usuario, p_fecha_asignacion, p_rol_formador);

    SELECT id_formador_asignado, id_opr, id_usuario, fecha_asignacion, rol_formador
    FROM formador_asignado WHERE id_formador_asignado = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_man_create $$
CREATE PROCEDURE sp_man_create(
    IN p_codigo VARCHAR(50), IN p_fecha_solicitud DATE, IN p_id_campana INT,
    IN p_solicitado_por VARCHAR(150), IN p_elaborado_por VARCHAR(150), IN p_tema_tipologia VARCHAR(200),
    IN p_analisis TEXT, IN p_objetivo_actividad_formativa TEXT, IN p_causa_raiz_general TEXT,
    IN p_objetivo_formacion TEXT, IN p_metodo_analisis VARCHAR(100), IN p_id_tipo_actividad INT,
    IN p_id_publico_objetivo INT, IN p_otro_tipo_actividad VARCHAR(150), IN p_tipo_formacion VARCHAR(100),
    IN p_metodologia VARCHAR(100), IN p_disponibilidad_sala VARCHAR(100), IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE, IN p_sala_asignada VARCHAR(100), IN p_estado VARCHAR(50), IN p_creado_por INT,
    IN p_id_actividad INT, IN p_nombre_del_pensum VARCHAR(150), IN p_objetivo_del_pensum TEXT
)
BEGIN
    INSERT INTO man (
        codigo, fecha_solicitud, id_campana, solicitado_por, elaborado_por, tema_tipologia,
        analisis, objetivo_actividad_formativa, causa_raiz_general, objetivo_formacion,
        metodo_analisis, id_tipo_actividad, id_publico_objetivo, otro_tipo_actividad,
        tipo_formacion, metodologia, disponibilidad_sala, fecha_inicio, fecha_fin,
        sala_asignada, estado, creado_por, id_actividad, nombre_del_pensum, objetivo_del_pensum
    )
    VALUES (
        p_codigo, p_fecha_solicitud, p_id_campana, p_solicitado_por, p_elaborado_por, p_tema_tipologia,
        p_analisis, p_objetivo_actividad_formativa, p_causa_raiz_general, p_objetivo_formacion,
        p_metodo_analisis, p_id_tipo_actividad, p_id_publico_objetivo, p_otro_tipo_actividad,
        p_tipo_formacion, p_metodologia, p_disponibilidad_sala, p_fecha_inicio, p_fecha_fin,
        p_sala_asignada, p_estado, p_creado_por, p_id_actividad, p_nombre_del_pensum, p_objetivo_del_pensum
    );

    SELECT
        id_man, codigo, fecha_solicitud, id_campana, solicitado_por, elaborado_por, tema_tipologia,
        analisis, objetivo_actividad_formativa, causa_raiz_general, objetivo_formacion, metodo_analisis,
        id_tipo_actividad, id_publico_objetivo, otro_tipo_actividad, tipo_formacion, metodologia,
        disponibilidad_sala, fecha_inicio, fecha_fin, sala_asignada, estado, creado_por,
        id_actividad, nombre_del_pensum, objetivo_del_pensum
    FROM man WHERE id_man = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_planificador_create $$
CREATE PROCEDURE sp_planificador_create(
    IN p_id_man INT, IN p_id_actividad INT, IN p_id_campana INT, IN p_id_opr INT,
    IN p_fecha_inicio DATETIME, IN p_fecha_fin DATETIME, IN p_metodologia VARCHAR(100),
    IN p_sala VARCHAR(100), IN p_cupo INT, IN p_estado VARCHAR(50), IN p_creado_por INT
)
BEGIN
    INSERT INTO planificador (
        id_man, id_actividad, id_campana, id_opr, fecha_inicio, fecha_fin,
        metodologia, sala, cupo, estado, creado_por
    )
    VALUES (
        p_id_man, p_id_actividad, p_id_campana, p_id_opr, p_fecha_inicio, p_fecha_fin,
        p_metodologia, p_sala, p_cupo, p_estado, p_creado_por
    );

    SELECT
        id_planificador, id_man, id_actividad, id_campana, id_opr, fecha_inicio,
        fecha_fin, metodologia, sala, cupo, estado, creado_por
    FROM planificador WHERE id_planificador = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_pensum_create $$
CREATE PROCEDURE sp_pensum_create(
    IN p_id_man INT, IN p_id_actividad_base INT, IN p_nombre_del_pensum VARCHAR(150),
    IN p_objetivo_del_pensum TEXT, IN p_id_publico_objetivo INT,
    IN p_duracion_de_la_sesion DECIMAL(5, 2), IN p_unidad_duracion_sesion VARCHAR(20), IN p_estado TINYINT(1)
)
BEGIN
    INSERT INTO pensum (
        id_man, id_actividad_base, nombre_del_pensum, objetivo_del_pensum,
        id_publico_objetivo, duracion_de_la_sesion, unidad_duracion_sesion, estado
    )
    VALUES (
        p_id_man, p_id_actividad_base, p_nombre_del_pensum, p_objetivo_del_pensum,
        p_id_publico_objetivo, p_duracion_de_la_sesion, p_unidad_duracion_sesion, p_estado
    );

    SELECT
        id_pensum, id_man, id_actividad_base, nombre_del_pensum, objetivo_del_pensum,
        id_publico_objetivo, duracion_de_la_sesion, unidad_duracion_sesion, estado
    FROM pensum WHERE id_pensum = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_pensum_detalle_create $$
CREATE PROCEDURE sp_pensum_detalle_create(
    IN p_id_pensum INT, IN p_dia_de_capacitacion VARCHAR(50), IN p_tema VARCHAR(200),
    IN p_contenido TEXT, IN p_top_tipologias VARCHAR(255), IN p_duracion DECIMAL(5, 2),
    IN p_objetivo TEXT, IN p_descripcion_de_la_actividad TEXT, IN p_rutas TEXT
)
BEGIN
    INSERT INTO pensum_detalle (
        id_pensum, dia_de_capacitacion, tema, contenido, top_tipologias,
        duracion, objetivo, descripcion_de_la_actividad, rutas
    )
    VALUES (
        p_id_pensum, p_dia_de_capacitacion, p_tema, p_contenido, p_top_tipologias,
        p_duracion, p_objetivo, p_descripcion_de_la_actividad, p_rutas
    );

    SELECT
        id_pensum_detalle, id_pensum, dia_de_capacitacion, tema, contenido, top_tipologias,
        duracion, objetivo, descripcion_de_la_actividad, rutas
    FROM pensum_detalle WHERE id_pensum_detalle = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_opr_pensum_create $$
CREATE PROCEDURE sp_opr_pensum_create(
    IN p_id_opr INT, IN p_id_pensum INT, IN p_fecha_asignacion DATE
)
BEGIN
    INSERT INTO opr_pensum (id_opr, id_pensum, fecha_asignacion)
    VALUES (p_id_opr, p_id_pensum, p_fecha_asignacion);
    SELECT id_opr_pensum, id_opr, id_pensum, fecha_asignacion
    FROM opr_pensum WHERE id_opr_pensum = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_wave_formador_create $$
CREATE PROCEDURE sp_wave_formador_create(
    IN p_id_persona INT, IN p_id_opr INT, IN p_id_actividad INT,
    IN p_fecha DATE, IN p_asistencia TINYINT(1), IN p_observacion TEXT
)
BEGIN
    INSERT INTO wave_formador (id_persona, id_opr, id_actividad, fecha, asistencia, observacion)
    VALUES (p_id_persona, p_id_opr, p_id_actividad, p_fecha, p_asistencia, p_observacion);
    SELECT id_wave_formador, id_persona, id_opr, id_actividad, fecha, asistencia, observacion
    FROM wave_formador WHERE id_wave_formador = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_asistencia_qr_marcar $$
CREATE PROCEDURE sp_asistencia_qr_marcar(
    IN p_codigo_qr CHAR(36), IN p_id_opr INT, IN p_id_actividad INT, IN p_fecha DATE, IN p_observacion TEXT
)
BEGIN
    DECLARE v_id_persona INT;
    SELECT id_persona INTO v_id_persona FROM personas WHERE codigo_qr_unico = p_codigo_qr LIMIT 1;
    IF v_id_persona IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'QR no asociado a participante';
    END IF;
    INSERT INTO wave_formador (id_persona, id_opr, id_actividad, fecha, asistencia, observacion)
    VALUES (v_id_persona, p_id_opr, p_id_actividad, p_fecha, 1, p_observacion);
    SELECT id_wave_formador, id_persona, id_opr, id_actividad, fecha, asistencia, observacion
    FROM wave_formador WHERE id_wave_formador = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_asistencia_ia_contrastar $$
CREATE PROCEDURE sp_asistencia_ia_contrastar(IN p_id_planificador INT)
BEGIN
    DECLARE v_id_opr INT;
    DECLARE v_id_actividad INT;
    DECLARE v_fecha DATE;

    SELECT id_opr, id_actividad, DATE(fecha_inicio)
    INTO v_id_opr, v_id_actividad, v_fecha
    FROM planificador
    WHERE id_planificador = p_id_planificador
    LIMIT 1;

    IF v_id_opr IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Planificador sin grupo asociado';
    END IF;

    DELETE FROM asistencia_ia WHERE id_planificador = p_id_planificador;

    INSERT INTO asistencia_ia (
        id_planificador, id_persona, codigo_qr_leido, asistencia_esperada,
        asistencia_marcada_qr, resultado_contraste, observacion_ia, fecha_analisis
    )
    SELECT
        p_id_planificador,
        op.id_persona,
        CASE WHEN wf.id_wave_formador IS NOT NULL THEN pe.codigo_qr_unico ELSE NULL END,
        1,
        CASE WHEN wf.id_wave_formador IS NOT NULL THEN 1 ELSE 0 END,
        CASE WHEN wf.id_wave_formador IS NOT NULL THEN 'ASISTIO' ELSE 'NO_ASISTIO' END,
        'Contraste ejecutado automaticamente',
        NOW()
    FROM opr_participantes op
    INNER JOIN personas pe ON pe.id_persona = op.id_persona
    LEFT JOIN wave_formador wf
        ON wf.id_persona = op.id_persona
       AND wf.id_opr = v_id_opr
       AND wf.id_actividad = v_id_actividad
       AND wf.fecha = v_fecha
       AND wf.asistencia = 1
    WHERE op.id_opr = v_id_opr AND op.estado = 'ACTIVO';

    SELECT id_asistencia_ia, id_persona, resultado_contraste, asistencia_esperada, asistencia_marcada_qr
    FROM asistencia_ia
    WHERE id_planificador = p_id_planificador
    ORDER BY id_asistencia_ia;
END $$

DROP PROCEDURE IF EXISTS sp_lista_naranja_create $$
CREATE PROCEDURE sp_lista_naranja_create(
    IN p_id_persona INT, IN p_id_opr INT, IN p_id_motivo INT, IN p_fecha_reporte DATE,
    IN p_nivel_riesgo VARCHAR(50), IN p_observacion TEXT, IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO lista_naranja (
        id_persona, id_opr, id_motivo, fecha_reporte, nivel_riesgo, observacion, estado
    )
    VALUES (
        p_id_persona, p_id_opr, p_id_motivo, p_fecha_reporte, p_nivel_riesgo, p_observacion, p_estado
    );
    SELECT id_lista_naranja, id_persona, id_opr, id_motivo, fecha_reporte, nivel_riesgo, observacion, estado
    FROM lista_naranja WHERE id_lista_naranja = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_persona_certificacion_create $$
CREATE PROCEDURE sp_persona_certificacion_create(
    IN p_id_persona INT, IN p_id_certificacion INT, IN p_fecha_certificacion DATE,
    IN p_resultado VARCHAR(50), IN p_puntaje DECIMAL(5, 2), IN p_observacion TEXT
)
BEGIN
    INSERT INTO persona_certificacion (
        id_persona, id_certificacion, fecha_certificacion, resultado, puntaje, observacion
    )
    VALUES (
        p_id_persona, p_id_certificacion, p_fecha_certificacion, p_resultado, p_puntaje, p_observacion
    );
    SELECT id_persona_certificacion, id_persona, id_certificacion, fecha_certificacion, resultado, puntaje, observacion
    FROM persona_certificacion WHERE id_persona_certificacion = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_retroalimentacion_create $$
CREATE PROCEDURE sp_retroalimentacion_create(
    IN p_id_persona INT, IN p_creado_por INT, IN p_origen VARCHAR(50), IN p_titulo VARCHAR(150),
    IN p_fortalezas TEXT, IN p_oportunidades TEXT, IN p_plan_accion TEXT, IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO retroalimentaciones (
        id_persona, creado_por, origen, titulo, fortalezas, oportunidades, plan_accion, estado
    )
    VALUES (
        p_id_persona, p_creado_por, p_origen, p_titulo, p_fortalezas, p_oportunidades, p_plan_accion, p_estado
    );
    SELECT id_retroalimentacion, id_persona, creado_por, origen, titulo, fortalezas, oportunidades, plan_accion, estado
    FROM retroalimentaciones WHERE id_retroalimentacion = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_compromiso_create $$
CREATE PROCEDURE sp_compromiso_create(
    IN p_id_retroalimentacion INT, IN p_id_persona INT, IN p_id_usuario_responsable INT,
    IN p_descripcion TEXT, IN p_fecha_compromiso DATE, IN p_fecha_vencimiento DATE, IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO compromisos (
        id_retroalimentacion, id_persona, id_usuario_responsable, descripcion,
        fecha_compromiso, fecha_vencimiento, estado
    )
    VALUES (
        p_id_retroalimentacion, p_id_persona, p_id_usuario_responsable, p_descripcion,
        p_fecha_compromiso, p_fecha_vencimiento, p_estado
    );
    SELECT id_compromiso, id_retroalimentacion, id_persona, id_usuario_responsable, descripcion, fecha_compromiso, fecha_vencimiento, estado
    FROM compromisos WHERE id_compromiso = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_monitoreo_calidad_create $$
CREATE PROCEDURE sp_monitoreo_calidad_create(
    IN p_id_persona INT, IN p_id_analista INT, IN p_call_id VARCHAR(100), IN p_criterio VARCHAR(150),
    IN p_puntaje DECIMAL(5, 2), IN p_hallazgo TEXT, IN p_recomendacion TEXT, IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO monitoreos_calidad (
        id_persona, id_analista, call_id, criterio, puntaje, hallazgo, recomendacion, estado
    )
    VALUES (
        p_id_persona, p_id_analista, p_call_id, p_criterio, p_puntaje, p_hallazgo, p_recomendacion, p_estado
    );
    SELECT id_monitoreo_calidad, id_persona, id_analista, call_id, criterio, puntaje, hallazgo, recomendacion, estado
    FROM monitoreos_calidad WHERE id_monitoreo_calidad = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_ojt_seguimiento_create $$
CREATE PROCEDURE sp_ojt_seguimiento_create(
    IN p_id_persona INT, IN p_id_opr INT, IN p_dia INT, IN p_aht VARCHAR(20),
    IN p_calidad DECIMAL(5, 2), IN p_csat DECIMAL(5, 2), IN p_estado VARCHAR(50), IN p_observacion TEXT
)
BEGIN
    INSERT INTO ojt_seguimientos (id_persona, id_opr, dia, aht, calidad, csat, estado, observacion)
    VALUES (p_id_persona, p_id_opr, p_dia, p_aht, p_calidad, p_csat, p_estado, p_observacion);
    SELECT id_ojt_seguimiento, id_persona, id_opr, dia, aht, calidad, csat, estado, observacion
    FROM ojt_seguimientos WHERE id_ojt_seguimiento = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_preturno_create $$
CREATE PROCEDURE sp_preturno_create(
    IN p_id_opr INT, IN p_creado_por INT, IN p_tema VARCHAR(150),
    IN p_fecha DATE, IN p_preguntas INT, IN p_nota_promedio DECIMAL(5, 2), IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO preturnos (id_opr, creado_por, tema, fecha, preguntas, nota_promedio, estado)
    VALUES (p_id_opr, p_creado_por, p_tema, p_fecha, p_preguntas, p_nota_promedio, p_estado);
    SELECT id_preturno, id_opr, creado_por, tema, fecha, preguntas, nota_promedio, estado
    FROM preturnos WHERE id_preturno = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_agenda_evento_create $$
CREATE PROCEDURE sp_agenda_evento_create(
    IN p_id_planificador INT, IN p_id_opr INT, IN p_id_responsable INT, IN p_titulo VARCHAR(200),
    IN p_descripcion TEXT, IN p_fecha_inicio DATETIME, IN p_fecha_fin DATETIME,
    IN p_modalidad VARCHAR(50), IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO agenda_eventos (
        id_planificador, id_opr, id_responsable, titulo, descripcion,
        fecha_inicio, fecha_fin, modalidad, estado
    )
    VALUES (
        p_id_planificador, p_id_opr, p_id_responsable, p_titulo, p_descripcion,
        p_fecha_inicio, p_fecha_fin, p_modalidad, p_estado
    );
    SELECT id_agenda_evento, id_planificador, id_opr, id_responsable, titulo, descripcion, fecha_inicio, fecha_fin, modalidad, estado
    FROM agenda_eventos WHERE id_agenda_evento = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_biblioteca_actividad_create $$
CREATE PROCEDURE sp_biblioteca_actividad_create(
    IN p_id_actividad INT, IN p_creado_por INT, IN p_categoria VARCHAR(100),
    IN p_titulo VARCHAR(150), IN p_descripcion TEXT, IN p_recurso_url VARCHAR(255), IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO biblioteca_actividades (
        id_actividad, creado_por, categoria, titulo, descripcion, recurso_url, estado
    )
    VALUES (
        p_id_actividad, p_creado_por, p_categoria, p_titulo, p_descripcion, p_recurso_url, p_estado
    );
    SELECT id_biblioteca_actividad, id_actividad, creado_por, categoria, titulo, descripcion, recurso_url, estado
    FROM biblioteca_actividades WHERE id_biblioteca_actividad = LAST_INSERT_ID();
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_rol_listar $$
CREATE PROCEDURE sp_rol_listar()
BEGIN
    SELECT id_rol, nombre, estado, fecha_creacion
    FROM roles
    ORDER BY nombre;
END $$

DROP PROCEDURE IF EXISTS sp_usuario_listar $$
CREATE PROCEDURE sp_usuario_listar()
BEGIN
    SELECT
        u.id_usuario,
        u.nombre_completo,
        u.correo,
        u.id_rol,
        r.nombre AS rol_nombre,
        u.codigo_qr_unico,
        u.estado,
        u.fecha_creacion
    FROM usuarios u
    INNER JOIN roles r ON r.id_rol = u.id_rol
    ORDER BY u.nombre_completo;
END $$

DROP PROCEDURE IF EXISTS sp_usuario_obtener $$
CREATE PROCEDURE sp_usuario_obtener(IN p_id_usuario INT)
BEGIN
    SELECT
        u.id_usuario,
        u.nombre_completo,
        u.correo,
        u.id_rol,
        r.nombre AS rol_nombre,
        u.codigo_qr_unico,
        u.estado,
        u.fecha_creacion
    FROM usuarios u
    INNER JOIN roles r ON r.id_rol = u.id_rol
    WHERE u.id_usuario = p_id_usuario;
END $$

DROP PROCEDURE IF EXISTS sp_usuario_delete $$
CREATE PROCEDURE sp_usuario_delete(IN p_id_usuario INT)
BEGIN
    UPDATE usuarios
    SET estado = 0
    WHERE id_usuario = p_id_usuario;

    SELECT p_id_usuario AS id_usuario, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_campana_listar $$
CREATE PROCEDURE sp_campana_listar()
BEGIN
    SELECT
        c.id_campana,
        c.nombre,
        c.ceco,
        c.descripcion,
        c.estado,
        c.fecha_creacion,
        (
            SELECT COUNT(*)
            FROM opr o
            WHERE o.id_campana = c.id_campana
        ) AS total_grupos,
        (
            SELECT COUNT(*)
            FROM personas p
            WHERE p.id_campana = c.id_campana
        ) AS total_personas
    FROM campanas c
    ORDER BY c.fecha_creacion DESC, c.nombre;
END $$

DROP PROCEDURE IF EXISTS sp_campana_obtener $$
CREATE PROCEDURE sp_campana_obtener(IN p_id_campana INT)
BEGIN
    SELECT
        c.id_campana,
        c.nombre,
        c.ceco,
        c.descripcion,
        c.estado,
        c.fecha_creacion,
        (
            SELECT COUNT(*)
            FROM opr o
            WHERE o.id_campana = c.id_campana
        ) AS total_grupos,
        (
            SELECT COUNT(*)
            FROM personas p
            WHERE p.id_campana = c.id_campana
        ) AS total_personas
    FROM campanas c
    WHERE c.id_campana = p_id_campana;
END $$

DROP PROCEDURE IF EXISTS sp_campana_update $$
CREATE PROCEDURE sp_campana_update(
    IN p_id_campana INT,
    IN p_nombre VARCHAR(150),
    IN p_ceco VARCHAR(50),
    IN p_descripcion VARCHAR(255),
    IN p_estado TINYINT(1)
)
BEGIN
    UPDATE campanas
    SET nombre = p_nombre,
        ceco = p_ceco,
        descripcion = p_descripcion,
        estado = p_estado
    WHERE id_campana = p_id_campana;

    CALL sp_campana_obtener(p_id_campana);
END $$

DROP PROCEDURE IF EXISTS sp_campana_delete $$
CREATE PROCEDURE sp_campana_delete(IN p_id_campana INT)
BEGIN
    UPDATE campanas
    SET estado = 0
    WHERE id_campana = p_id_campana;

    SELECT p_id_campana AS id_campana, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_tipo_actividad_listar $$
CREATE PROCEDURE sp_tipo_actividad_listar()
BEGIN
    SELECT id_tipo_actividad, nombre, descripcion, estado, fecha_creacion
    FROM tipo_actividad
    ORDER BY nombre;
END $$

DROP PROCEDURE IF EXISTS sp_publico_objetivo_listar $$
CREATE PROCEDURE sp_publico_objetivo_listar()
BEGIN
    SELECT id_publico_objetivo, nombre, descripcion, fecha_creacion
    FROM publico_objetivo
    ORDER BY nombre;
END $$

DROP PROCEDURE IF EXISTS sp_actividad_listar $$
CREATE PROCEDURE sp_actividad_listar()
BEGIN
    SELECT
        a.id_actividad,
        a.nombre,
        a.descripcion,
        a.id_tipo_actividad,
        ta.nombre AS tipo_actividad_nombre,
        a.id_publico_objetivo,
        po.nombre AS publico_objetivo_nombre,
        a.duracion_horas,
        a.estado,
        a.fecha_creacion
    FROM actividades a
    INNER JOIN tipo_actividad ta ON ta.id_tipo_actividad = a.id_tipo_actividad
    LEFT JOIN publico_objetivo po ON po.id_publico_objetivo = a.id_publico_objetivo
    ORDER BY a.fecha_creacion DESC, a.nombre;
END $$

DROP PROCEDURE IF EXISTS sp_actividad_obtener $$
CREATE PROCEDURE sp_actividad_obtener(IN p_id_actividad INT)
BEGIN
    SELECT
        a.id_actividad,
        a.nombre,
        a.descripcion,
        a.id_tipo_actividad,
        ta.nombre AS tipo_actividad_nombre,
        a.id_publico_objetivo,
        po.nombre AS publico_objetivo_nombre,
        a.duracion_horas,
        a.estado,
        a.fecha_creacion
    FROM actividades a
    INNER JOIN tipo_actividad ta ON ta.id_tipo_actividad = a.id_tipo_actividad
    LEFT JOIN publico_objetivo po ON po.id_publico_objetivo = a.id_publico_objetivo
    WHERE a.id_actividad = p_id_actividad;
END $$

DROP PROCEDURE IF EXISTS sp_actividad_update $$
CREATE PROCEDURE sp_actividad_update(
    IN p_id_actividad INT,
    IN p_nombre VARCHAR(200),
    IN p_descripcion TEXT,
    IN p_id_tipo_actividad INT,
    IN p_id_publico_objetivo INT,
    IN p_duracion_horas DECIMAL(5, 2),
    IN p_estado TINYINT(1)
)
BEGIN
    UPDATE actividades
    SET nombre = p_nombre,
        descripcion = p_descripcion,
        id_tipo_actividad = p_id_tipo_actividad,
        id_publico_objetivo = p_id_publico_objetivo,
        duracion_horas = p_duracion_horas,
        estado = p_estado
    WHERE id_actividad = p_id_actividad;

    CALL sp_actividad_obtener(p_id_actividad);
END $$

DROP PROCEDURE IF EXISTS sp_actividad_delete $$
CREATE PROCEDURE sp_actividad_delete(IN p_id_actividad INT)
BEGIN
    UPDATE actividades
    SET estado = 0
    WHERE id_actividad = p_id_actividad;

    SELECT p_id_actividad AS id_actividad, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_persona_listar $$
CREATE PROCEDURE sp_persona_listar()
BEGIN
    SELECT
        p.id_persona,
        p.tipo_documento,
        p.numero_documento,
        p.nombres,
        p.apellidos,
        CONCAT(p.nombres, ' ', p.apellidos) AS nombre_completo,
        p.correo,
        p.telefono,
        p.fecha_ingreso,
        p.id_campana,
        c.nombre AS campana_nombre,
        p.id_hc,
        h.codigo_hc,
        p.codigo_qr_unico,
        p.estado,
        p.fecha_creacion
    FROM personas p
    LEFT JOIN campanas c ON c.id_campana = p.id_campana
    LEFT JOIN hc h ON h.id_hc = p.id_hc
    ORDER BY p.fecha_creacion DESC, p.nombres, p.apellidos;
END $$

DROP PROCEDURE IF EXISTS sp_persona_obtener $$
CREATE PROCEDURE sp_persona_obtener(IN p_id_persona INT)
BEGIN
    SELECT
        p.id_persona,
        p.tipo_documento,
        p.numero_documento,
        p.nombres,
        p.apellidos,
        CONCAT(p.nombres, ' ', p.apellidos) AS nombre_completo,
        p.correo,
        p.telefono,
        p.fecha_ingreso,
        p.id_campana,
        c.nombre AS campana_nombre,
        p.id_hc,
        h.codigo_hc,
        p.codigo_qr_unico,
        p.estado,
        p.fecha_creacion
    FROM personas p
    LEFT JOIN campanas c ON c.id_campana = p.id_campana
    LEFT JOIN hc h ON h.id_hc = p.id_hc
    WHERE p.id_persona = p_id_persona;
END $$

DROP PROCEDURE IF EXISTS sp_persona_update $$
CREATE PROCEDURE sp_persona_update(
    IN p_id_persona INT,
    IN p_tipo_documento VARCHAR(20),
    IN p_numero_documento VARCHAR(30),
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_correo VARCHAR(150),
    IN p_telefono VARCHAR(30),
    IN p_fecha_ingreso DATE,
    IN p_id_campana INT,
    IN p_id_hc INT,
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE personas
    SET tipo_documento = p_tipo_documento,
        numero_documento = p_numero_documento,
        nombres = p_nombres,
        apellidos = p_apellidos,
        correo = p_correo,
        telefono = p_telefono,
        fecha_ingreso = p_fecha_ingreso,
        id_campana = p_id_campana,
        id_hc = p_id_hc,
        estado = p_estado
    WHERE id_persona = p_id_persona;

    CALL sp_persona_obtener(p_id_persona);
END $$

DROP PROCEDURE IF EXISTS sp_persona_delete $$
CREATE PROCEDURE sp_persona_delete(IN p_id_persona INT)
BEGIN
    UPDATE personas
    SET estado = 'INACTIVO'
    WHERE id_persona = p_id_persona;

    SELECT p_id_persona AS id_persona, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_opr_listar $$
CREATE PROCEDURE sp_opr_listar()
BEGIN
    SELECT
        o.id_opr,
        o.codigo_opr,
        o.nombre,
        o.id_campana,
        c.nombre AS campana_nombre,
        o.fecha_inicio,
        o.fecha_fin,
        o.estado,
        o.fecha_creacion,
        (
            SELECT COUNT(*)
            FROM opr_participantes op
            WHERE op.id_opr = o.id_opr
              AND (op.estado IS NULL OR op.estado <> 'RETIRADO')
        ) AS total_participantes,
        (
            SELECT COUNT(*)
            FROM formador_asignado fa
            WHERE fa.id_opr = o.id_opr
        ) AS total_formadores
    FROM opr o
    LEFT JOIN campanas c ON c.id_campana = o.id_campana
    ORDER BY o.fecha_creacion DESC, o.nombre;
END $$

DROP PROCEDURE IF EXISTS sp_opr_obtener $$
CREATE PROCEDURE sp_opr_obtener(IN p_id_opr INT)
BEGIN
    SELECT
        o.id_opr,
        o.codigo_opr,
        o.nombre,
        o.id_campana,
        c.nombre AS campana_nombre,
        o.fecha_inicio,
        o.fecha_fin,
        o.estado,
        o.fecha_creacion,
        (
            SELECT COUNT(*)
            FROM opr_participantes op
            WHERE op.id_opr = o.id_opr
              AND (op.estado IS NULL OR op.estado <> 'RETIRADO')
        ) AS total_participantes,
        (
            SELECT COUNT(*)
            FROM formador_asignado fa
            WHERE fa.id_opr = o.id_opr
        ) AS total_formadores
    FROM opr o
    LEFT JOIN campanas c ON c.id_campana = o.id_campana
    WHERE o.id_opr = p_id_opr;
END $$

DROP PROCEDURE IF EXISTS sp_opr_update $$
CREATE PROCEDURE sp_opr_update(
    IN p_id_opr INT,
    IN p_codigo_opr VARCHAR(50),
    IN p_nombre VARCHAR(150),
    IN p_id_campana INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE opr
    SET codigo_opr = p_codigo_opr,
        nombre = p_nombre,
        id_campana = p_id_campana,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin,
        estado = p_estado
    WHERE id_opr = p_id_opr;

    CALL sp_opr_obtener(p_id_opr);
END $$

DROP PROCEDURE IF EXISTS sp_opr_delete $$
CREATE PROCEDURE sp_opr_delete(IN p_id_opr INT)
BEGIN
    UPDATE opr
    SET estado = 'INACTIVO'
    WHERE id_opr = p_id_opr;

    SELECT p_id_opr AS id_opr, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_opr_participante_listar $$
CREATE PROCEDURE sp_opr_participante_listar()
BEGIN
    SELECT
        op.id_opr_participante,
        op.id_opr,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        op.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        p.numero_documento,
        op.fecha_asignacion,
        op.estado
    FROM opr_participantes op
    INNER JOIN opr o ON o.id_opr = op.id_opr
    INNER JOIN personas p ON p.id_persona = op.id_persona
    ORDER BY op.fecha_asignacion DESC;
END $$

DROP PROCEDURE IF EXISTS sp_opr_participante_obtener $$
CREATE PROCEDURE sp_opr_participante_obtener(IN p_id_opr_participante INT)
BEGIN
    SELECT
        op.id_opr_participante,
        op.id_opr,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        op.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        p.numero_documento,
        op.fecha_asignacion,
        op.estado
    FROM opr_participantes op
    INNER JOIN opr o ON o.id_opr = op.id_opr
    INNER JOIN personas p ON p.id_persona = op.id_persona
    WHERE op.id_opr_participante = p_id_opr_participante;
END $$

DROP PROCEDURE IF EXISTS sp_opr_participante_update $$
CREATE PROCEDURE sp_opr_participante_update(
    IN p_id_opr_participante INT,
    IN p_id_opr INT,
    IN p_id_persona INT,
    IN p_fecha_asignacion DATETIME,
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE opr_participantes
    SET id_opr = p_id_opr,
        id_persona = p_id_persona,
        fecha_asignacion = p_fecha_asignacion,
        estado = p_estado
    WHERE id_opr_participante = p_id_opr_participante;

    CALL sp_opr_participante_obtener(p_id_opr_participante);
END $$

DROP PROCEDURE IF EXISTS sp_opr_participante_delete $$
CREATE PROCEDURE sp_opr_participante_delete(IN p_id_opr_participante INT)
BEGIN
    UPDATE opr_participantes
    SET estado = 'RETIRADO'
    WHERE id_opr_participante = p_id_opr_participante;

    SELECT p_id_opr_participante AS id_opr_participante, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_formador_asignado_listar $$
CREATE PROCEDURE sp_formador_asignado_listar()
BEGIN
    SELECT
        fa.id_formador_asignado,
        fa.id_opr,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        fa.id_usuario,
        u.nombre_completo AS usuario_nombre,
        fa.fecha_asignacion,
        fa.rol_formador
    FROM formador_asignado fa
    INNER JOIN opr o ON o.id_opr = fa.id_opr
    INNER JOIN usuarios u ON u.id_usuario = fa.id_usuario
    ORDER BY fa.fecha_asignacion DESC;
END $$

DROP PROCEDURE IF EXISTS sp_formador_asignado_obtener $$
CREATE PROCEDURE sp_formador_asignado_obtener(IN p_id_formador_asignado INT)
BEGIN
    SELECT
        fa.id_formador_asignado,
        fa.id_opr,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        fa.id_usuario,
        u.nombre_completo AS usuario_nombre,
        fa.fecha_asignacion,
        fa.rol_formador
    FROM formador_asignado fa
    INNER JOIN opr o ON o.id_opr = fa.id_opr
    INNER JOIN usuarios u ON u.id_usuario = fa.id_usuario
    WHERE fa.id_formador_asignado = p_id_formador_asignado;
END $$

DROP PROCEDURE IF EXISTS sp_formador_asignado_update $$
CREATE PROCEDURE sp_formador_asignado_update(
    IN p_id_formador_asignado INT,
    IN p_id_opr INT,
    IN p_id_usuario INT,
    IN p_fecha_asignacion DATETIME,
    IN p_rol_formador VARCHAR(100)
)
BEGIN
    UPDATE formador_asignado
    SET id_opr = p_id_opr,
        id_usuario = p_id_usuario,
        fecha_asignacion = p_fecha_asignacion,
        rol_formador = p_rol_formador
    WHERE id_formador_asignado = p_id_formador_asignado;

    CALL sp_formador_asignado_obtener(p_id_formador_asignado);
END $$

DROP PROCEDURE IF EXISTS sp_formador_asignado_delete $$
CREATE PROCEDURE sp_formador_asignado_delete(IN p_id_formador_asignado INT)
BEGIN
    DELETE FROM formador_asignado
    WHERE id_formador_asignado = p_id_formador_asignado;

    SELECT p_id_formador_asignado AS id_formador_asignado, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_man_listar $$
CREATE PROCEDURE sp_man_listar()
BEGIN
    SELECT
        m.id_man,
        m.codigo,
        m.fecha_solicitud,
        m.id_campana,
        c.nombre AS campana_nombre,
        m.id_actividad,
        a.nombre AS actividad_nombre,
        m.nombre_del_pensum,
        m.objetivo_del_pensum,
        m.estado,
        m.fecha_creacion
    FROM man m
    LEFT JOIN campanas c ON c.id_campana = m.id_campana
    INNER JOIN actividades a ON a.id_actividad = m.id_actividad
    ORDER BY m.fecha_creacion DESC, m.codigo;
END $$

DROP PROCEDURE IF EXISTS sp_planificador_listar $$
CREATE PROCEDURE sp_planificador_listar()
BEGIN
    SELECT
        p.id_planificador,
        p.id_man,
        m.codigo AS codigo_man,
        p.id_actividad,
        a.nombre AS actividad_nombre,
        p.id_campana,
        c.nombre AS campana_nombre,
        p.id_opr,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        p.fecha_inicio,
        p.fecha_fin,
        p.metodologia,
        p.sala,
        p.cupo,
        p.estado,
        p.creado_por,
        u.nombre_completo AS creado_por_nombre,
        p.fecha_creacion
    FROM planificador p
    INNER JOIN man m ON m.id_man = p.id_man
    INNER JOIN actividades a ON a.id_actividad = p.id_actividad
    LEFT JOIN campanas c ON c.id_campana = p.id_campana
    LEFT JOIN opr o ON o.id_opr = p.id_opr
    LEFT JOIN usuarios u ON u.id_usuario = p.creado_por
    ORDER BY p.fecha_inicio DESC, p.id_planificador DESC;
END $$

DROP PROCEDURE IF EXISTS sp_planificador_obtener $$
CREATE PROCEDURE sp_planificador_obtener(IN p_id_planificador INT)
BEGIN
    SELECT
        p.id_planificador,
        p.id_man,
        m.codigo AS codigo_man,
        p.id_actividad,
        a.nombre AS actividad_nombre,
        p.id_campana,
        c.nombre AS campana_nombre,
        p.id_opr,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        p.fecha_inicio,
        p.fecha_fin,
        p.metodologia,
        p.sala,
        p.cupo,
        p.estado,
        p.creado_por,
        u.nombre_completo AS creado_por_nombre,
        p.fecha_creacion
    FROM planificador p
    INNER JOIN man m ON m.id_man = p.id_man
    INNER JOIN actividades a ON a.id_actividad = p.id_actividad
    LEFT JOIN campanas c ON c.id_campana = p.id_campana
    LEFT JOIN opr o ON o.id_opr = p.id_opr
    LEFT JOIN usuarios u ON u.id_usuario = p.creado_por
    WHERE p.id_planificador = p_id_planificador;
END $$

DROP PROCEDURE IF EXISTS sp_planificador_update $$
CREATE PROCEDURE sp_planificador_update(
    IN p_id_planificador INT,
    IN p_id_man INT,
    IN p_id_actividad INT,
    IN p_id_campana INT,
    IN p_id_opr INT,
    IN p_fecha_inicio DATETIME,
    IN p_fecha_fin DATETIME,
    IN p_metodologia VARCHAR(100),
    IN p_sala VARCHAR(100),
    IN p_cupo INT,
    IN p_estado VARCHAR(50),
    IN p_creado_por INT
)
BEGIN
    UPDATE planificador
    SET id_man = p_id_man,
        id_actividad = p_id_actividad,
        id_campana = p_id_campana,
        id_opr = p_id_opr,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin,
        metodologia = p_metodologia,
        sala = p_sala,
        cupo = p_cupo,
        estado = p_estado,
        creado_por = p_creado_por
    WHERE id_planificador = p_id_planificador;

    CALL sp_planificador_obtener(p_id_planificador);
END $$

DROP PROCEDURE IF EXISTS sp_planificador_delete $$
CREATE PROCEDURE sp_planificador_delete(IN p_id_planificador INT)
BEGIN
    UPDATE planificador
    SET estado = 'CANCELADO'
    WHERE id_planificador = p_id_planificador;

    SELECT p_id_planificador AS id_planificador, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_agenda_evento_listar $$
CREATE PROCEDURE sp_agenda_evento_listar()
BEGIN
    SELECT
        ag.id_agenda_evento,
        ag.id_planificador,
        ag.id_opr,
        ag.id_responsable,
        ag.titulo,
        ag.descripcion,
        ag.fecha_inicio,
        ag.fecha_fin,
        ag.modalidad,
        ag.estado,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        u.nombre_completo AS responsable_nombre
    FROM agenda_eventos ag
    LEFT JOIN opr o ON o.id_opr = ag.id_opr
    INNER JOIN usuarios u ON u.id_usuario = ag.id_responsable
    ORDER BY ag.fecha_inicio DESC, ag.id_agenda_evento DESC;
END $$

DROP PROCEDURE IF EXISTS sp_agenda_evento_obtener $$
CREATE PROCEDURE sp_agenda_evento_obtener(IN p_id_agenda_evento INT)
BEGIN
    SELECT
        ag.id_agenda_evento,
        ag.id_planificador,
        ag.id_opr,
        ag.id_responsable,
        ag.titulo,
        ag.descripcion,
        ag.fecha_inicio,
        ag.fecha_fin,
        ag.modalidad,
        ag.estado,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        u.nombre_completo AS responsable_nombre
    FROM agenda_eventos ag
    LEFT JOIN opr o ON o.id_opr = ag.id_opr
    INNER JOIN usuarios u ON u.id_usuario = ag.id_responsable
    WHERE ag.id_agenda_evento = p_id_agenda_evento;
END $$

DROP PROCEDURE IF EXISTS sp_agenda_evento_update $$
CREATE PROCEDURE sp_agenda_evento_update(
    IN p_id_agenda_evento INT,
    IN p_id_planificador INT,
    IN p_id_opr INT,
    IN p_id_responsable INT,
    IN p_titulo VARCHAR(200),
    IN p_descripcion TEXT,
    IN p_fecha_inicio DATETIME,
    IN p_fecha_fin DATETIME,
    IN p_modalidad VARCHAR(50),
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE agenda_eventos
    SET id_planificador = p_id_planificador,
        id_opr = p_id_opr,
        id_responsable = p_id_responsable,
        titulo = p_titulo,
        descripcion = p_descripcion,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin,
        modalidad = p_modalidad,
        estado = p_estado
    WHERE id_agenda_evento = p_id_agenda_evento;

    CALL sp_agenda_evento_obtener(p_id_agenda_evento);
END $$

DROP PROCEDURE IF EXISTS sp_agenda_evento_delete $$
CREATE PROCEDURE sp_agenda_evento_delete(IN p_id_agenda_evento INT)
BEGIN
    UPDATE agenda_eventos
    SET estado = 'CANCELADO'
    WHERE id_agenda_evento = p_id_agenda_evento;

    SELECT p_id_agenda_evento AS id_agenda_evento, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_biblioteca_actividad_listar $$
CREATE PROCEDURE sp_biblioteca_actividad_listar()
BEGIN
    SELECT
        b.id_biblioteca_actividad,
        b.id_actividad,
        a.nombre AS actividad_nombre,
        b.creado_por,
        u.nombre_completo AS creado_por_nombre,
        b.categoria,
        b.titulo,
        b.descripcion,
        b.recurso_url,
        b.estado,
        b.fecha_creacion
    FROM biblioteca_actividades b
    LEFT JOIN actividades a ON a.id_actividad = b.id_actividad
    INNER JOIN usuarios u ON u.id_usuario = b.creado_por
    ORDER BY b.fecha_creacion DESC, b.titulo;
END $$

DROP PROCEDURE IF EXISTS sp_biblioteca_actividad_obtener $$
CREATE PROCEDURE sp_biblioteca_actividad_obtener(IN p_id_biblioteca_actividad INT)
BEGIN
    SELECT
        b.id_biblioteca_actividad,
        b.id_actividad,
        a.nombre AS actividad_nombre,
        b.creado_por,
        u.nombre_completo AS creado_por_nombre,
        b.categoria,
        b.titulo,
        b.descripcion,
        b.recurso_url,
        b.estado,
        b.fecha_creacion
    FROM biblioteca_actividades b
    LEFT JOIN actividades a ON a.id_actividad = b.id_actividad
    INNER JOIN usuarios u ON u.id_usuario = b.creado_por
    WHERE b.id_biblioteca_actividad = p_id_biblioteca_actividad;
END $$

DROP PROCEDURE IF EXISTS sp_biblioteca_actividad_update $$
CREATE PROCEDURE sp_biblioteca_actividad_update(
    IN p_id_biblioteca_actividad INT,
    IN p_id_actividad INT,
    IN p_creado_por INT,
    IN p_categoria VARCHAR(100),
    IN p_titulo VARCHAR(150),
    IN p_descripcion TEXT,
    IN p_recurso_url VARCHAR(255),
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE biblioteca_actividades
    SET id_actividad = p_id_actividad,
        creado_por = p_creado_por,
        categoria = p_categoria,
        titulo = p_titulo,
        descripcion = p_descripcion,
        recurso_url = p_recurso_url,
        estado = p_estado
    WHERE id_biblioteca_actividad = p_id_biblioteca_actividad;

    CALL sp_biblioteca_actividad_obtener(p_id_biblioteca_actividad);
END $$

DROP PROCEDURE IF EXISTS sp_biblioteca_actividad_delete $$
CREATE PROCEDURE sp_biblioteca_actividad_delete(IN p_id_biblioteca_actividad INT)
BEGIN
    UPDATE biblioteca_actividades
    SET estado = 'INACTIVO'
    WHERE id_biblioteca_actividad = p_id_biblioteca_actividad;

    SELECT p_id_biblioteca_actividad AS id_biblioteca_actividad, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_retroalimentacion_listar $$
CREATE PROCEDURE sp_retroalimentacion_listar()
BEGIN
    SELECT
        r.id_retroalimentacion,
        r.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        r.creado_por,
        u.nombre_completo AS creado_por_nombre,
        r.origen,
        r.titulo,
        r.fortalezas,
        r.oportunidades,
        r.plan_accion,
        r.estado,
        r.fecha_creacion
    FROM retroalimentaciones r
    INNER JOIN personas p ON p.id_persona = r.id_persona
    INNER JOIN usuarios u ON u.id_usuario = r.creado_por
    ORDER BY r.fecha_creacion DESC, r.id_retroalimentacion DESC;
END $$

DROP PROCEDURE IF EXISTS sp_retroalimentacion_obtener $$
CREATE PROCEDURE sp_retroalimentacion_obtener(IN p_id_retroalimentacion INT)
BEGIN
    SELECT
        r.id_retroalimentacion,
        r.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        r.creado_por,
        u.nombre_completo AS creado_por_nombre,
        r.origen,
        r.titulo,
        r.fortalezas,
        r.oportunidades,
        r.plan_accion,
        r.estado,
        r.fecha_creacion
    FROM retroalimentaciones r
    INNER JOIN personas p ON p.id_persona = r.id_persona
    INNER JOIN usuarios u ON u.id_usuario = r.creado_por
    WHERE r.id_retroalimentacion = p_id_retroalimentacion;
END $$

DROP PROCEDURE IF EXISTS sp_retroalimentacion_update $$
CREATE PROCEDURE sp_retroalimentacion_update(
    IN p_id_retroalimentacion INT,
    IN p_id_persona INT,
    IN p_creado_por INT,
    IN p_origen VARCHAR(50),
    IN p_titulo VARCHAR(150),
    IN p_fortalezas TEXT,
    IN p_oportunidades TEXT,
    IN p_plan_accion TEXT,
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE retroalimentaciones
    SET id_persona = p_id_persona,
        creado_por = p_creado_por,
        origen = p_origen,
        titulo = p_titulo,
        fortalezas = p_fortalezas,
        oportunidades = p_oportunidades,
        plan_accion = p_plan_accion,
        estado = p_estado
    WHERE id_retroalimentacion = p_id_retroalimentacion;

    CALL sp_retroalimentacion_obtener(p_id_retroalimentacion);
END $$

DROP PROCEDURE IF EXISTS sp_retroalimentacion_delete $$
CREATE PROCEDURE sp_retroalimentacion_delete(IN p_id_retroalimentacion INT)
BEGIN
    UPDATE retroalimentaciones
    SET estado = 'ELIMINADA'
    WHERE id_retroalimentacion = p_id_retroalimentacion;

    SELECT p_id_retroalimentacion AS id_retroalimentacion, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_compromiso_listar $$
CREATE PROCEDURE sp_compromiso_listar()
BEGIN
    SELECT
        c.id_compromiso,
        c.id_retroalimentacion,
        r.titulo AS retroalimentacion_titulo,
        c.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        c.id_usuario_responsable,
        u.nombre_completo AS responsable_nombre,
        c.descripcion,
        c.fecha_compromiso,
        c.fecha_vencimiento,
        c.estado,
        c.fecha_creacion
    FROM compromisos c
    INNER JOIN retroalimentaciones r ON r.id_retroalimentacion = c.id_retroalimentacion
    INNER JOIN personas p ON p.id_persona = c.id_persona
    LEFT JOIN usuarios u ON u.id_usuario = c.id_usuario_responsable
    ORDER BY c.fecha_creacion DESC, c.id_compromiso DESC;
END $$

DROP PROCEDURE IF EXISTS sp_compromiso_obtener $$
CREATE PROCEDURE sp_compromiso_obtener(IN p_id_compromiso INT)
BEGIN
    SELECT
        c.id_compromiso,
        c.id_retroalimentacion,
        r.titulo AS retroalimentacion_titulo,
        c.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        c.id_usuario_responsable,
        u.nombre_completo AS responsable_nombre,
        c.descripcion,
        c.fecha_compromiso,
        c.fecha_vencimiento,
        c.estado,
        c.fecha_creacion
    FROM compromisos c
    INNER JOIN retroalimentaciones r ON r.id_retroalimentacion = c.id_retroalimentacion
    INNER JOIN personas p ON p.id_persona = c.id_persona
    LEFT JOIN usuarios u ON u.id_usuario = c.id_usuario_responsable
    WHERE c.id_compromiso = p_id_compromiso;
END $$

DROP PROCEDURE IF EXISTS sp_compromiso_update $$
CREATE PROCEDURE sp_compromiso_update(
    IN p_id_compromiso INT,
    IN p_id_retroalimentacion INT,
    IN p_id_persona INT,
    IN p_id_usuario_responsable INT,
    IN p_descripcion TEXT,
    IN p_fecha_compromiso DATE,
    IN p_fecha_vencimiento DATE,
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE compromisos
    SET id_retroalimentacion = p_id_retroalimentacion,
        id_persona = p_id_persona,
        id_usuario_responsable = p_id_usuario_responsable,
        descripcion = p_descripcion,
        fecha_compromiso = p_fecha_compromiso,
        fecha_vencimiento = p_fecha_vencimiento,
        estado = p_estado
    WHERE id_compromiso = p_id_compromiso;

    CALL sp_compromiso_obtener(p_id_compromiso);
END $$

DROP PROCEDURE IF EXISTS sp_compromiso_delete $$
CREATE PROCEDURE sp_compromiso_delete(IN p_id_compromiso INT)
BEGIN
    UPDATE compromisos
    SET estado = 'ANULADO'
    WHERE id_compromiso = p_id_compromiso;

    SELECT p_id_compromiso AS id_compromiso, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_monitoreo_calidad_listar $$
CREATE PROCEDURE sp_monitoreo_calidad_listar()
BEGIN
    SELECT
        m.id_monitoreo_calidad,
        m.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        m.id_analista,
        u.nombre_completo AS analista_nombre,
        m.call_id,
        m.criterio,
        m.puntaje,
        m.hallazgo,
        m.recomendacion,
        m.estado,
        m.fecha_creacion
    FROM monitoreos_calidad m
    INNER JOIN personas p ON p.id_persona = m.id_persona
    INNER JOIN usuarios u ON u.id_usuario = m.id_analista
    ORDER BY m.fecha_creacion DESC, m.id_monitoreo_calidad DESC;
END $$

DROP PROCEDURE IF EXISTS sp_monitoreo_calidad_obtener $$
CREATE PROCEDURE sp_monitoreo_calidad_obtener(IN p_id_monitoreo_calidad INT)
BEGIN
    SELECT
        m.id_monitoreo_calidad,
        m.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        m.id_analista,
        u.nombre_completo AS analista_nombre,
        m.call_id,
        m.criterio,
        m.puntaje,
        m.hallazgo,
        m.recomendacion,
        m.estado,
        m.fecha_creacion
    FROM monitoreos_calidad m
    INNER JOIN personas p ON p.id_persona = m.id_persona
    INNER JOIN usuarios u ON u.id_usuario = m.id_analista
    WHERE m.id_monitoreo_calidad = p_id_monitoreo_calidad;
END $$

DROP PROCEDURE IF EXISTS sp_monitoreo_calidad_update $$
CREATE PROCEDURE sp_monitoreo_calidad_update(
    IN p_id_monitoreo_calidad INT,
    IN p_id_persona INT,
    IN p_id_analista INT,
    IN p_call_id VARCHAR(100),
    IN p_criterio VARCHAR(150),
    IN p_puntaje DECIMAL(5, 2),
    IN p_hallazgo TEXT,
    IN p_recomendacion TEXT,
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE monitoreos_calidad
    SET id_persona = p_id_persona,
        id_analista = p_id_analista,
        call_id = p_call_id,
        criterio = p_criterio,
        puntaje = p_puntaje,
        hallazgo = p_hallazgo,
        recomendacion = p_recomendacion,
        estado = p_estado
    WHERE id_monitoreo_calidad = p_id_monitoreo_calidad;

    CALL sp_monitoreo_calidad_obtener(p_id_monitoreo_calidad);
END $$

DROP PROCEDURE IF EXISTS sp_monitoreo_calidad_delete $$
CREATE PROCEDURE sp_monitoreo_calidad_delete(IN p_id_monitoreo_calidad INT)
BEGIN
    UPDATE monitoreos_calidad
    SET estado = 'ANULADO'
    WHERE id_monitoreo_calidad = p_id_monitoreo_calidad;

    SELECT p_id_monitoreo_calidad AS id_monitoreo_calidad, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_ojt_seguimiento_listar $$
CREATE PROCEDURE sp_ojt_seguimiento_listar()
BEGIN
    SELECT
        s.id_ojt_seguimiento,
        s.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        s.id_opr,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        s.dia,
        s.aht,
        s.calidad,
        s.csat,
        s.estado,
        s.observacion,
        s.fecha_creacion
    FROM ojt_seguimientos s
    INNER JOIN personas p ON p.id_persona = s.id_persona
    INNER JOIN opr o ON o.id_opr = s.id_opr
    ORDER BY s.fecha_creacion DESC, s.id_ojt_seguimiento DESC;
END $$

DROP PROCEDURE IF EXISTS sp_ojt_seguimiento_obtener $$
CREATE PROCEDURE sp_ojt_seguimiento_obtener(IN p_id_ojt_seguimiento INT)
BEGIN
    SELECT
        s.id_ojt_seguimiento,
        s.id_persona,
        CONCAT(p.nombres, ' ', p.apellidos) AS persona_nombre,
        s.id_opr,
        o.codigo_opr,
        o.nombre AS grupo_nombre,
        s.dia,
        s.aht,
        s.calidad,
        s.csat,
        s.estado,
        s.observacion,
        s.fecha_creacion
    FROM ojt_seguimientos s
    INNER JOIN personas p ON p.id_persona = s.id_persona
    INNER JOIN opr o ON o.id_opr = s.id_opr
    WHERE s.id_ojt_seguimiento = p_id_ojt_seguimiento;
END $$

DROP PROCEDURE IF EXISTS sp_ojt_seguimiento_update $$
CREATE PROCEDURE sp_ojt_seguimiento_update(
    IN p_id_ojt_seguimiento INT,
    IN p_id_persona INT,
    IN p_id_opr INT,
    IN p_dia INT,
    IN p_aht VARCHAR(20),
    IN p_calidad DECIMAL(5, 2),
    IN p_csat DECIMAL(5, 2),
    IN p_estado VARCHAR(50),
    IN p_observacion TEXT
)
BEGIN
    UPDATE ojt_seguimientos
    SET id_persona = p_id_persona,
        id_opr = p_id_opr,
        dia = p_dia,
        aht = p_aht,
        calidad = p_calidad,
        csat = p_csat,
        estado = p_estado,
        observacion = p_observacion
    WHERE id_ojt_seguimiento = p_id_ojt_seguimiento;

    CALL sp_ojt_seguimiento_obtener(p_id_ojt_seguimiento);
END $$

DROP PROCEDURE IF EXISTS sp_ojt_seguimiento_delete $$
CREATE PROCEDURE sp_ojt_seguimiento_delete(IN p_id_ojt_seguimiento INT)
BEGIN
    UPDATE ojt_seguimientos
    SET estado = 'ANULADO'
    WHERE id_ojt_seguimiento = p_id_ojt_seguimiento;

    SELECT p_id_ojt_seguimiento AS id_ojt_seguimiento, ROW_COUNT() AS filas_afectadas;
END $$

DROP PROCEDURE IF EXISTS sp_sesion_virtual_enlace_guardar $$
CREATE PROCEDURE sp_sesion_virtual_enlace_guardar(
    IN p_id_sesion_virtual INT,
    IN p_teams_join_url TEXT
)
BEGIN
    UPDATE sesion_virtual
    SET teams_join_url = p_teams_join_url,
        actualizado_en = NOW()
    WHERE id_sesion_virtual = p_id_sesion_virtual;

    SELECT *
    FROM vw_virtual_sessions
    WHERE virtual_session_id = p_id_sesion_virtual;
END $$

DROP PROCEDURE IF EXISTS sp_sesion_virtual_qr_upsert $$
CREATE PROCEDURE sp_sesion_virtual_qr_upsert(
    IN p_id_sesion_virtual INT,
    IN p_tipo_qr VARCHAR(30),
    IN p_qr_token VARCHAR(255),
    IN p_public_url VARCHAR(500),
    IN p_activa_desde DATETIME,
    IN p_expira_en DATETIME
)
BEGIN
    DECLARE v_estado VARCHAR(30);

    SET v_estado = CASE
        WHEN NOW() < p_activa_desde THEN 'PROGRAMADO'
        WHEN NOW() > p_expira_en THEN 'EXPIRADO'
        ELSE 'ACTIVO'
    END;

    IF EXISTS (
        SELECT 1
        FROM sesion_virtual_qr
        WHERE id_sesion_virtual = p_id_sesion_virtual
          AND tipo_qr = p_tipo_qr
    ) THEN
        UPDATE sesion_virtual_qr
        SET qr_token = p_qr_token,
            public_url = p_public_url,
            activa_desde = p_activa_desde,
            expira_en = p_expira_en,
            estado = v_estado,
            actualizado_en = NOW()
        WHERE id_sesion_virtual = p_id_sesion_virtual
          AND tipo_qr = p_tipo_qr;
    ELSE
        INSERT INTO sesion_virtual_qr (
            id_sesion_virtual, tipo_qr, qr_token, public_url, activa_desde, expira_en, estado
        )
        VALUES (
            p_id_sesion_virtual, p_tipo_qr, p_qr_token, p_public_url, p_activa_desde, p_expira_en, v_estado
        );
    END IF;

    IF UPPER(p_tipo_qr) = 'ASISTENCIA' THEN
        UPDATE sesion_virtual
        SET qr_token = p_qr_token,
            qr_expira_en = p_expira_en,
            actualizado_en = NOW()
        WHERE id_sesion_virtual = p_id_sesion_virtual;
    END IF;

    SELECT *
    FROM vw_trainer_session_qr_codes
    WHERE virtual_session_id = p_id_sesion_virtual
      AND qr_type = p_tipo_qr
    ORDER BY session_qr_id DESC;
END $$

DROP PROCEDURE IF EXISTS sp_asistencia_qr_intento_invalido_registrar $$
CREATE PROCEDURE sp_asistencia_qr_intento_invalido_registrar(
    IN p_id_sesion_virtual INT,
    IN p_id_sesion_virtual_qr INT,
    IN p_qr_token_capturado VARCHAR(255),
    IN p_tipo_qr VARCHAR(30),
    IN p_tipo_documento_capturado VARCHAR(20),
    IN p_nombre_capturado VARCHAR(150),
    IN p_cedula_capturada VARCHAR(30),
    IN p_id_campana_capturada INT,
    IN p_estado_validacion VARCHAR(50),
    IN p_ip_origen VARCHAR(45),
    IN p_user_agent VARCHAR(255),
    IN p_observacion VARCHAR(255)
)
BEGIN
    INSERT INTO asistencia_scan (
        id_sesion_virtual,
        id_sesion_virtual_qr,
        qr_token_capturado,
        tipo_qr,
        tipo_documento_capturado,
        id_persona,
        nombre_capturado,
        cedula_capturada,
        id_campana_capturada,
        estado_validacion,
        origen,
        ip_origen,
        user_agent,
        observacion
    )
    VALUES (
        p_id_sesion_virtual,
        p_id_sesion_virtual_qr,
        p_qr_token_capturado,
        p_tipo_qr,
        p_tipo_documento_capturado,
        NULL,
        p_nombre_capturado,
        p_cedula_capturada,
        p_id_campana_capturada,
        p_estado_validacion,
        'qr_form',
        p_ip_origen,
        p_user_agent,
        p_observacion
    );

    SELECT *
    FROM vw_trainer_attendance_records
    WHERE attendance_record_id = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_asistencia_qr_registrar $$
CREATE PROCEDURE sp_asistencia_qr_registrar(
    IN p_id_sesion_virtual INT,
    IN p_id_sesion_virtual_qr INT,
    IN p_qr_token_capturado VARCHAR(255),
    IN p_tipo_qr VARCHAR(30),
    IN p_tipo_documento_capturado VARCHAR(20),
    IN p_id_persona INT,
    IN p_nombre_capturado VARCHAR(150),
    IN p_cedula_capturada VARCHAR(30),
    IN p_id_campana_capturada INT,
    IN p_ip_origen VARCHAR(45),
    IN p_user_agent VARCHAR(255),
    IN p_observacion VARCHAR(255)
)
BEGIN
    DECLARE v_id_planificador INT;
    DECLARE v_id_opr INT;
    DECLARE v_id_actividad INT;
    DECLARE v_fecha DATE;
    DECLARE v_estado_asistencia VARCHAR(20);
    DECLARE v_estado_existente VARCHAR(20);
    DECLARE v_estado_validacion VARCHAR(50);
    DECLARE v_observacion_final TEXT;

    IF p_id_persona IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La persona autorizada es obligatoria para registrar asistencia.';
    END IF;

    SELECT id_planificador
    INTO v_id_planificador
    FROM sesion_virtual
    WHERE id_sesion_virtual = p_id_sesion_virtual
    LIMIT 1;

    IF v_id_planificador IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sesion virtual indicada no existe.';
    END IF;

    SELECT id_opr, id_actividad, DATE(fecha_inicio)
    INTO v_id_opr, v_id_actividad, v_fecha
    FROM planificador
    WHERE id_planificador = v_id_planificador
    LIMIT 1;

    SET v_estado_asistencia = CASE
        WHEN UPPER(COALESCE(p_tipo_qr, 'ASISTENCIA')) = 'RETARDO' THEN 'RETARDO'
        ELSE 'ASISTIO'
    END;

    SELECT estado_asistencia
    INTO v_estado_existente
    FROM wave_formador
    WHERE id_sesion_virtual = p_id_sesion_virtual
      AND id_persona = p_id_persona
    LIMIT 1;

    IF v_estado_existente = 'ASISTIO' AND v_estado_asistencia = 'RETARDO' THEN
        SET v_estado_validacion = 'DUPLICADO_IGNORADO';
    ELSEIF v_estado_existente = v_estado_asistencia THEN
        SET v_estado_validacion = 'DUPLICADO';
    ELSE
        SET v_estado_validacion = v_estado_asistencia;
    END IF;

    SET v_observacion_final = CONCAT_WS(
        ' | ',
        CONCAT('Registro QR ', v_estado_asistencia),
        NULLIF(p_observacion, '')
    );

    INSERT INTO asistencia_scan (
        id_sesion_virtual,
        id_sesion_virtual_qr,
        qr_token_capturado,
        tipo_qr,
        tipo_documento_capturado,
        id_persona,
        nombre_capturado,
        cedula_capturada,
        id_campana_capturada,
        estado_validacion,
        origen,
        ip_origen,
        user_agent,
        observacion
    )
    VALUES (
        p_id_sesion_virtual,
        p_id_sesion_virtual_qr,
        p_qr_token_capturado,
        p_tipo_qr,
        p_tipo_documento_capturado,
        p_id_persona,
        p_nombre_capturado,
        p_cedula_capturada,
        p_id_campana_capturada,
        v_estado_validacion,
        'qr_form',
        p_ip_origen,
        p_user_agent,
        v_observacion_final
    );

    IF v_estado_validacion IN ('ASISTIO', 'RETARDO') THEN
        INSERT INTO wave_formador (
            id_sesion_virtual,
            id_persona,
            id_opr,
            id_actividad,
            fecha,
            asistencia,
            estado_asistencia,
            observacion
        )
        VALUES (
            p_id_sesion_virtual,
            p_id_persona,
            v_id_opr,
            v_id_actividad,
            v_fecha,
            1,
            v_estado_asistencia,
            v_observacion_final
        )
        ON DUPLICATE KEY UPDATE
            asistencia = 1,
            estado_asistencia = CASE
                WHEN wave_formador.estado_asistencia = 'ASISTIO' THEN 'ASISTIO'
                WHEN VALUES(estado_asistencia) = 'ASISTIO' THEN 'ASISTIO'
                ELSE 'RETARDO'
            END,
            observacion = CONCAT_WS(' | ', NULLIF(wave_formador.observacion, ''), NULLIF(VALUES(observacion), '')),
            fecha_registro = NOW();
    END IF;

    SELECT *
    FROM vw_trainer_attendance_records
    WHERE attendance_record_id = LAST_INSERT_ID();
END $$

DROP PROCEDURE IF EXISTS sp_teams_moderacion_log_registrar $$
CREATE PROCEDURE sp_teams_moderacion_log_registrar(
    IN p_id_sesion_virtual INT,
    IN p_teams_participant_id VARCHAR(150),
    IN p_accion VARCHAR(50),
    IN p_resultado VARCHAR(50),
    IN p_detalle TEXT
)
BEGIN
    INSERT INTO teams_moderacion_log (
        id_sesion_virtual,
        teams_participant_id,
        accion,
        resultado,
        detalle
    )
    VALUES (
        p_id_sesion_virtual,
        p_teams_participant_id,
        p_accion,
        p_resultado,
        p_detalle
    );

    SELECT
        id_teams_moderacion_log,
        id_sesion_virtual,
        teams_participant_id,
        accion,
        resultado,
        detalle,
        fecha_evento
    FROM teams_moderacion_log
    WHERE id_teams_moderacion_log = LAST_INSERT_ID();
END $$

DELIMITER ;
