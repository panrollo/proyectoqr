SET NAMES utf8mb4;

SET @today = CURDATE();
SET @now = NOW();

UPDATE roles
SET nombre = 'formador'
WHERE nombre IN ('Formadores', 'Formadores HB', 'FORMADORES', 'formadores');

UPDATE roles
SET nombre = 'lider'
WHERE nombre IN ('Líder F&C', 'Lider F&C', 'Lider FC', 'Lider');

UPDATE roles
SET nombre = 'jefe_fc'
WHERE nombre IN ('Jefe F&C', 'Jefe FC', 'JEFE F&C', 'Jefe de Formacion');

UPDATE roles
SET nombre = 'jefe_ops'
WHERE nombre IN ('Jefe Ops', 'Jefe de Operaciones', 'Jefe Operaciones');

INSERT INTO roles (id_rol, nombre, estado) VALUES
    (1, 'agente', 1),
    (2, 'formador', 1),
    (3, 'analista', 1),
    (4, 'supervisor', 1),
    (5, 'lider', 1),
    (6, 'jefe_fc', 1),
    (7, 'jefe_ops', 1),
    (8, 'admin', 1)
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    estado = VALUES(estado);

INSERT INTO usuarios (
    id_usuario, nombre_completo, correo, clave_hash, id_rol, codigo_qr_unico, estado
) VALUES
    (1001, 'Admin Demo', 'admin@local.test', '$pbkdf2-sha256$29000$KeX8P6d0LuWc0/r/P8f4/w$dSBZL6Z8ugui24cV7o.JNEKFxqp999XwTt/ST5ylALs', 8, '10000000-0000-0000-0000-000000001001', 1),
    (1002, 'Laura Formador', 'formador1@local.test', '$pbkdf2-sha256$29000$ttZ6T6kVwvh/r9UaAyDkvA$LhdulZdTBmeKTDXWCx1LSyOw3d0tI4N2k7gQO5k9y5g', 2, '10000000-0000-0000-0000-000000001002', 1),
    (1003, 'Miguel Formador', 'formador2@local.test', '$pbkdf2-sha256$29000$ttZ6T6kVwvh/r9UaAyDkvA$LhdulZdTBmeKTDXWCx1LSyOw3d0tI4N2k7gQO5k9y5g', 2, '10000000-0000-0000-0000-000000001003', 1),
    (1004, 'Monica Lider', 'lider@local.test', '$pbkdf2-sha256$29000$gpByLmXsXYtR6j1njFHKGQ$sF50yEMEX2ELDldMmFQnc/gD5fKzEVLNLtk4cKGeYyM', 5, '10000000-0000-0000-0000-000000001004', 1),
    (1005, 'Rafael Jefe FC', 'jefe.fc@local.test', '$pbkdf2-sha256$29000$l9Kak9I6p9T6n5MyRiilNA$4KWBoY2.kZ.wuFOpxIVMvtubcgklgEpsGvsQyC5tZf8', 6, '10000000-0000-0000-0000-000000001005', 1),
    (1006, 'Sandra Analista', 'analista@local.test', '$pbkdf2-sha256$29000$2lsrxfg/h/C.l5KyNiakVA$UlWk3BEB09uP9I9JP5YettFDw5V.2FNsjU9Cu595c6M', 3, '10000000-0000-0000-0000-000000001006', 1),
    (1007, 'Diego Supervisor', 'supervisor@local.test', '$pbkdf2-sha256$29000$.d/b./9fi7HW2jvHmJOSEg$dvQzelt23981AZYd4KipVcheIt4C0xdHTRJp/pD4SLA', 4, '10000000-0000-0000-0000-000000001007', 1),
    (1008, 'Hernan Jefe Ops', 'jefe.ops@local.test', '$pbkdf2-sha256$29000$UmpNSSlFKAWAMGbMmRNi7A$e5EsTF04h1SCyZNUkWw/hyVOloYYf1E6cKPOn7kKWu4', 7, '10000000-0000-0000-0000-000000001008', 1),
    (1009, 'Carlos Agente', 'agente@local.test', '$pbkdf2-sha256$29000$8L63lvIeY6wV4nzvvZfSWg$/VgoZCmYyRncLvhXrBuxgXNrF1zECsKl0I7WqFpjEdo', 1, '10000000-0000-0000-0000-000000001009', 1)
ON DUPLICATE KEY UPDATE
    nombre_completo = VALUES(nombre_completo),
    correo = VALUES(correo),
    clave_hash = VALUES(clave_hash),
    id_rol = VALUES(id_rol),
    codigo_qr_unico = VALUES(codigo_qr_unico),
    estado = VALUES(estado);

INSERT INTO campanas (id_campana, nombre, ceco, descripcion, estado) VALUES
    (2001, 'Campana Demo Ventas', 'FC-1001', 'Cuenta demo para onboarding comercial y seguimiento OJT.', 1),
    (2002, 'Campana Demo Soporte', 'FC-2001', 'Cuenta demo para soporte premium y calibraciones.', 1)
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    ceco = VALUES(ceco),
    descripcion = VALUES(descripcion),
    estado = VALUES(estado);

INSERT INTO hc (id_hc, codigo_hc, descripcion, id_campana, estado) VALUES
    (2101, 'HC-VENT-01', 'HC principal de ventas demo.', 2001, 1),
    (2102, 'HC-VENT-02', 'HC de refuerzo comercial demo.', 2001, 1),
    (2103, 'HC-SOP-01', 'HC de soporte premium demo.', 2002, 1)
ON DUPLICATE KEY UPDATE
    codigo_hc = VALUES(codigo_hc),
    descripcion = VALUES(descripcion),
    id_campana = VALUES(id_campana),
    estado = VALUES(estado);

INSERT INTO tipo_actividad (id_tipo_actividad, nombre, descripcion, estado) VALUES
    (2201, 'Formacion inicial', 'Induccion y ramp up de nuevas olas.', 1),
    (2202, 'OJT', 'Seguimiento en piso y coaching operativo.', 1),
    (2203, 'Formacion continua', 'Refuerzos y calibraciones recurrentes.', 1),
    (2204, 'Calidad', 'Sesiones enfocadas en monitoreo y compliance.', 1)
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    descripcion = VALUES(descripcion),
    estado = VALUES(estado);

INSERT INTO publico_objetivo (id_publico_objetivo, nombre, descripcion) VALUES
    (2301, 'Agentes nuevos', 'Colaboradores en curva de aprendizaje inicial.'),
    (2302, 'Agentes activos', 'Colaboradores en operacion estabilizada.'),
    (2303, 'Formadores y lideres', 'Roles staff que participan en calibraciones.')
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    descripcion = VALUES(descripcion);

INSERT INTO motivo_lista_naranja (id_motivo, nombre, descripcion, estado) VALUES
    (2401, 'Inasistencia recurrente', 'Varias novedades de asistencia en el mismo corte.', 1),
    (2402, 'Desempeno bajo', 'Indicadores por debajo del objetivo del grupo.', 1),
    (2403, 'Documentacion incompleta', 'Pendientes en soportes o formalizacion.', 1)
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    descripcion = VALUES(descripcion),
    estado = VALUES(estado);

INSERT INTO certificaciones (id_certificacion, nombre, descripcion, estado) VALUES
    (2501, 'Certificacion onboarding', 'Habilita a operar luego de la formacion inicial.', 1),
    (2502, 'Certificacion calidad base', 'Valida criterios de monitoreo y speech.', 1),
    (2503, 'Certificacion Teams y asistencia', 'Valida el uso del flujo de asistencia virtual.', 1)
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    descripcion = VALUES(descripcion),
    estado = VALUES(estado);

INSERT INTO encuestas (
    id_encuesta, nombre, descripcion, pregunta1, pregunta2, pregunta3, pregunta4, pregunta5,
    pregunta6, pregunta7, pregunta8, pregunta9, pregunta10, observacion, estado
) VALUES
    (
        2601,
        'Encuesta reaccion onboarding',
        'Mide percepcion de utilidad y claridad en formacion inicial.',
        'La sesion cumplio el objetivo?', 'El material fue claro?', 'El formador resolvio dudas?',
        'El ritmo fue adecuado?', 'La actividad fue practica?', 'Entiendes el flujo operativo?',
        'Te sientes listo para pasar a OJT?', 'El uso de Teams fue claro?', 'El QR de asistencia fue sencillo?',
        'Recomendarias esta sesion?', 'Espacio abierto para observaciones.', 1
    ),
    (
        2602,
        'Encuesta seguimiento OJT',
        'Mide satisfaccion con acompanamiento y coaching.',
        'Recibiste feedback util?', 'El supervisor estuvo disponible?', 'Las metas fueron claras?',
        'Las practicas ayudaron?', 'El material de apoyo fue suficiente?', 'El monitoreo fue oportuno?',
        'La curva de aprendizaje avanza?', 'Te sientes mas seguro en la operacion?', 'La agenda fue clara?',
        'Repetirias este acompanamiento?', 'Observaciones del seguimiento.', 1
    )
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    descripcion = VALUES(descripcion),
    pregunta1 = VALUES(pregunta1),
    pregunta2 = VALUES(pregunta2),
    pregunta3 = VALUES(pregunta3),
    pregunta4 = VALUES(pregunta4),
    pregunta5 = VALUES(pregunta5),
    pregunta6 = VALUES(pregunta6),
    pregunta7 = VALUES(pregunta7),
    pregunta8 = VALUES(pregunta8),
    pregunta9 = VALUES(pregunta9),
    pregunta10 = VALUES(pregunta10),
    observacion = VALUES(observacion),
    estado = VALUES(estado);

INSERT INTO personas (
    id_persona, tipo_documento, numero_documento, nombres, apellidos, correo, telefono,
    fecha_ingreso, id_campana, id_hc, codigo_qr_unico, estado
) VALUES
    (3001, 'CC', '1003001', 'Carlos', 'Mendoza', 'agente@local.test', '3001003001', DATE_SUB(@today, INTERVAL 30 DAY), 2001, 2101, '30000000-0000-0000-0000-000000003001', 'ACTIVO'),
    (3002, 'CC', '1003002', 'Paula', 'Rojas', 'paula.rojas.demo@local.test', '3001003002', DATE_SUB(@today, INTERVAL 28 DAY), 2001, 2101, '30000000-0000-0000-0000-000000003002', 'ACTIVO'),
    (3003, 'CC', '1003003', 'Andres', 'Lopez', 'andres.lopez.demo@local.test', '3001003003', DATE_SUB(@today, INTERVAL 26 DAY), 2001, 2101, '30000000-0000-0000-0000-000000003003', 'ACTIVO'),
    (3004, 'CC', '1003004', 'Valentina', 'Gomez', 'valentina.gomez.demo@local.test', '3001003004', DATE_SUB(@today, INTERVAL 24 DAY), 2001, 2102, '30000000-0000-0000-0000-000000003004', 'ACTIVO'),
    (3005, 'CC', '1003005', 'Santiago', 'Perez', 'santiago.perez.demo@local.test', '3001003005', DATE_SUB(@today, INTERVAL 22 DAY), 2001, 2102, '30000000-0000-0000-0000-000000003005', 'ACTIVO'),
    (3006, 'CC', '1003006', 'Laura', 'Diaz', 'laura.diaz.demo@local.test', '3001003006', DATE_SUB(@today, INTERVAL 20 DAY), 2001, 2101, '30000000-0000-0000-0000-000000003006', 'ACTIVO'),
    (3007, 'CC', '1003007', 'Mateo', 'Torres', 'mateo.torres.demo@local.test', '3001003007', DATE_SUB(@today, INTERVAL 18 DAY), 2001, 2101, '30000000-0000-0000-0000-000000003007', 'ACTIVO'),
    (3008, 'CC', '1003008', 'Juliana', 'Castro', 'juliana.castro.demo@local.test', '3001003008', DATE_SUB(@today, INTERVAL 16 DAY), 2001, 2102, '30000000-0000-0000-0000-000000003008', 'ACTIVO'),
    (3009, 'CC', '1003009', 'Nicolas', 'Ramirez', 'nicolas.ramirez.demo@local.test', '3001003009', DATE_SUB(@today, INTERVAL 14 DAY), 2001, 2102, '30000000-0000-0000-0000-000000003009', 'ACTIVO'),
    (3010, 'CC', '1003010', 'Daniela', 'Herrera', 'daniela.herrera.demo@local.test', '3001003010', DATE_SUB(@today, INTERVAL 12 DAY), 2001, NULL, '30000000-0000-0000-0000-000000003010', 'ACTIVO'),
    (3011, 'CC', '1003011', 'Camila', 'Suarez', 'camila.suarez.demo@local.test', '3001003011', DATE_SUB(@today, INTERVAL 20 DAY), 2002, 2103, '30000000-0000-0000-0000-000000003011', 'ACTIVO'),
    (3012, 'CC', '1003012', 'Sebastian', 'Moreno', 'sebastian.moreno.demo@local.test', '3001003012', DATE_SUB(@today, INTERVAL 18 DAY), 2002, 2103, '30000000-0000-0000-0000-000000003012', 'ACTIVO'),
    (3013, 'CC', '1003013', 'Mariana', 'Silva', 'mariana.silva.demo@local.test', '3001003013', DATE_SUB(@today, INTERVAL 16 DAY), 2002, 2103, '30000000-0000-0000-0000-000000003013', 'ACTIVO'),
    (3014, 'CC', '1003014', 'Felipe', 'Navarro', 'felipe.navarro.demo@local.test', '3001003014', DATE_SUB(@today, INTERVAL 14 DAY), 2002, NULL, '30000000-0000-0000-0000-000000003014', 'ACTIVO')
ON DUPLICATE KEY UPDATE
    tipo_documento = VALUES(tipo_documento),
    numero_documento = VALUES(numero_documento),
    nombres = VALUES(nombres),
    apellidos = VALUES(apellidos),
    correo = VALUES(correo),
    telefono = VALUES(telefono),
    fecha_ingreso = VALUES(fecha_ingreso),
    id_campana = VALUES(id_campana),
    id_hc = VALUES(id_hc),
    codigo_qr_unico = VALUES(codigo_qr_unico),
    estado = VALUES(estado);

INSERT INTO actividades (
    id_actividad, nombre, descripcion, id_tipo_actividad, id_publico_objetivo, duracion_horas, estado
) VALUES
    (4001, 'Induccion corporativa demo', 'Bienvenida, cultura y politicas del servicio.', 2201, 2301, 4.00, 1),
    (4002, 'Speech y protocolo soporte demo', 'Flujo de apertura, validacion y cierre para soporte premium.', 2201, 2301, 3.50, 1),
    (4003, 'Herramientas CRM y tipificacion', 'Navegacion del CRM y codificacion de casos.', 2201, 2301, 2.50, 1),
    (4004, 'Coaching OJT semana 1', 'Refuerzo en piso sobre manejo de llamadas y tiempos.', 2202, 2302, 2.00, 1),
    (4005, 'Gestion de objeciones y cierre', 'Taller de role play para conversion comercial.', 2203, 2302, 2.00, 1),
    (4006, 'Calidad, compliance y documentacion', 'Sesion de control de calidad y hallazgos frecuentes.', 2204, 2302, 1.50, 1)
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    descripcion = VALUES(descripcion),
    id_tipo_actividad = VALUES(id_tipo_actividad),
    id_publico_objetivo = VALUES(id_publico_objetivo),
    duracion_horas = VALUES(duracion_horas),
    estado = VALUES(estado);

INSERT INTO opr (
    id_opr, codigo_opr, nombre, id_campana, fecha_inicio, fecha_fin, estado
) VALUES
    (5001, 'DEMO-OPR-VENTAS-A', 'Wave Ventas 24A', 2001, DATE_SUB(@today, INTERVAL 5 DAY), DATE_ADD(@today, INTERVAL 25 DAY), 'ACTIVO'),
    (5002, 'DEMO-OPR-VENTAS-B', 'Wave Ventas 24B', 2001, DATE_SUB(@today, INTERVAL 2 DAY), DATE_ADD(@today, INTERVAL 28 DAY), 'ACTIVO'),
    (5003, 'DEMO-OPR-SOPORTE-A', 'Wave Soporte 24A', 2002, DATE_SUB(@today, INTERVAL 4 DAY), DATE_ADD(@today, INTERVAL 24 DAY), 'ACTIVO')
ON DUPLICATE KEY UPDATE
    codigo_opr = VALUES(codigo_opr),
    nombre = VALUES(nombre),
    id_campana = VALUES(id_campana),
    fecha_inicio = VALUES(fecha_inicio),
    fecha_fin = VALUES(fecha_fin),
    estado = VALUES(estado);

INSERT INTO opr_participantes (
    id_opr_participante, id_opr, id_persona, fecha_asignacion, estado
) VALUES
    (5101, 5001, 3001, DATE_SUB(@now, INTERVAL 10 DAY), 'ACTIVO'),
    (5102, 5001, 3002, DATE_SUB(@now, INTERVAL 10 DAY), 'ACTIVO'),
    (5103, 5001, 3003, DATE_SUB(@now, INTERVAL 10 DAY), 'ACTIVO'),
    (5104, 5001, 3004, DATE_SUB(@now, INTERVAL 9 DAY), 'ACTIVO'),
    (5105, 5001, 3005, DATE_SUB(@now, INTERVAL 9 DAY), 'ACTIVO'),
    (5106, 5002, 3006, DATE_SUB(@now, INTERVAL 7 DAY), 'ACTIVO'),
    (5107, 5002, 3007, DATE_SUB(@now, INTERVAL 7 DAY), 'ACTIVO'),
    (5108, 5002, 3008, DATE_SUB(@now, INTERVAL 7 DAY), 'ACTIVO'),
    (5109, 5002, 3009, DATE_SUB(@now, INTERVAL 6 DAY), 'ACTIVO'),
    (5110, 5002, 3010, DATE_SUB(@now, INTERVAL 6 DAY), 'ACTIVO'),
    (5111, 5003, 3011, DATE_SUB(@now, INTERVAL 8 DAY), 'ACTIVO'),
    (5112, 5003, 3012, DATE_SUB(@now, INTERVAL 8 DAY), 'ACTIVO'),
    (5113, 5003, 3013, DATE_SUB(@now, INTERVAL 8 DAY), 'ACTIVO'),
    (5114, 5003, 3014, DATE_SUB(@now, INTERVAL 8 DAY), 'ACTIVO')
ON DUPLICATE KEY UPDATE
    id_opr = VALUES(id_opr),
    id_persona = VALUES(id_persona),
    fecha_asignacion = VALUES(fecha_asignacion),
    estado = VALUES(estado);

INSERT INTO formador_asignado (
    id_formador_asignado, id_opr, id_usuario, fecha_asignacion, rol_formador
) VALUES
    (5201, 5001, 1002, DATE_SUB(@now, INTERVAL 10 DAY), 'Formador principal'),
    (5202, 5001, 1003, DATE_SUB(@now, INTERVAL 8 DAY), 'Formador apoyo'),
    (5203, 5002, 1002, DATE_SUB(@now, INTERVAL 7 DAY), 'Formador principal'),
    (5204, 5003, 1003, DATE_SUB(@now, INTERVAL 8 DAY), 'Formador principal')
ON DUPLICATE KEY UPDATE
    id_opr = VALUES(id_opr),
    id_usuario = VALUES(id_usuario),
    fecha_asignacion = VALUES(fecha_asignacion),
    rol_formador = VALUES(rol_formador);

INSERT INTO man (
    id_man, codigo, fecha_solicitud, id_campana, solicitado_por, elaborado_por, tema_tipologia,
    analisis, objetivo_actividad_formativa, causa_raiz_general, objetivo_formacion, metodo_analisis,
    id_tipo_actividad, id_publico_objetivo, otro_tipo_actividad, tipo_formacion, metodologia,
    disponibilidad_sala, fecha_inicio, fecha_fin, sala_asignada, estado, creado_por, id_actividad,
    nombre_del_pensum, objetivo_del_pensum
) VALUES
    (
        6001, 'DEMO-MAN-001', DATE_SUB(@today, INTERVAL 12 DAY), 2001, 'Jefe comercial demo', 'Monica Lider',
        'Induccion comercial ventas', 'Se detecto necesidad de estandarizar onboarding comercial.',
        'Alinear speech, CRM y protocolo comercial.', 'Brecha de adopcion de herramientas en semana 1.',
        'Reducir reprocesos de apertura y tipificacion.', 'Observacion y monitoreo',
        2201, 2301, NULL, 'Inicial', 'Virtual', 'Teams disponible',
        DATE_SUB(@today, INTERVAL 1 DAY), DATE_ADD(@today, INTERVAL 15 DAY), 'Teams Sala 1', 'APROBADO', 1004, 4001,
        'Pensum onboarding comercial', 'Estructurar la curva inicial de aprendizaje comercial.'
    ),
    (
        6002, 'DEMO-MAN-002', DATE_SUB(@today, INTERVAL 11 DAY), 2001, 'Lider de operaciones ventas', 'Monica Lider',
        'Dominio de CRM y tipificacion', 'Persisten errores en trazabilidad del caso.',
        'Asegurar dominio de CRM y codigos operativos.', 'Tipificaciones incompletas y reprocesos.',
        'Subir adherencia al flujo de registro.', 'Analisis de errores',
        2201, 2301, NULL, 'Inicial', 'Virtual', 'Teams disponible',
        @today, DATE_ADD(@today, INTERVAL 20 DAY), 'Teams Sala 2', 'APROBADO', 1004, 4003,
        'Pensum CRM y tipificacion', 'Consolidar uso correcto de herramientas y codigos.'
    ),
    (
        6003, 'DEMO-MAN-003', DATE_SUB(@today, INTERVAL 8 DAY), 2001, 'Supervisor ventas demo', 'Monica Lider',
        'Gestion de objeciones', 'Se requieren refuerzos para conversion de cierre.',
        'Practicar escenarios frecuentes y respuestas efectivas.', 'Baja conversion en cierres y manejo de objeciones.',
        'Mejorar tasa de cierre y seguridad del agente.', 'Calibracion de resultados',
        2203, 2302, NULL, 'Continua', 'Presencial', 'Sala habilitada',
        DATE_ADD(@today, INTERVAL 1 DAY), DATE_ADD(@today, INTERVAL 30 DAY), 'Sala Demo 4', 'APROBADO', 1004, 4005,
        'Pensum objeciones y cierre', 'Refuerzo continuo para ventas consultivas.'
    ),
    (
        6004, 'DEMO-MAN-004', DATE_SUB(@today, INTERVAL 9 DAY), 2002, 'Jefe soporte demo', 'Rafael Jefe FC',
        'Speech soporte premium', 'Se requiere homogeneizar protocolo de atencion en soporte premium.',
        'Alinear speech, validaciones y documentacion.', 'Desviaciones en speech y cumplimiento.',
        'Elevar calidad y compliance del equipo soporte.', 'Monitoreo de llamadas',
        2201, 2301, NULL, 'Inicial', 'Virtual', 'Teams disponible',
        DATE_SUB(@today, INTERVAL 1 DAY), DATE_ADD(@today, INTERVAL 18 DAY), 'Teams Sala Soporte', 'APROBADO', 1005, 4002,
        'Pensum onboarding soporte', 'Asegurar arranque consistente del frente de soporte.'
    )
ON DUPLICATE KEY UPDATE
    codigo = VALUES(codigo),
    fecha_solicitud = VALUES(fecha_solicitud),
    id_campana = VALUES(id_campana),
    solicitado_por = VALUES(solicitado_por),
    elaborado_por = VALUES(elaborado_por),
    tema_tipologia = VALUES(tema_tipologia),
    analisis = VALUES(analisis),
    objetivo_actividad_formativa = VALUES(objetivo_actividad_formativa),
    causa_raiz_general = VALUES(causa_raiz_general),
    objetivo_formacion = VALUES(objetivo_formacion),
    metodo_analisis = VALUES(metodo_analisis),
    id_tipo_actividad = VALUES(id_tipo_actividad),
    id_publico_objetivo = VALUES(id_publico_objetivo),
    otro_tipo_actividad = VALUES(otro_tipo_actividad),
    tipo_formacion = VALUES(tipo_formacion),
    metodologia = VALUES(metodologia),
    disponibilidad_sala = VALUES(disponibilidad_sala),
    fecha_inicio = VALUES(fecha_inicio),
    fecha_fin = VALUES(fecha_fin),
    sala_asignada = VALUES(sala_asignada),
    estado = VALUES(estado),
    creado_por = VALUES(creado_por),
    id_actividad = VALUES(id_actividad),
    nombre_del_pensum = VALUES(nombre_del_pensum),
    objetivo_del_pensum = VALUES(objetivo_del_pensum);

INSERT INTO pensum (
    id_pensum, id_man, id_actividad_base, nombre_del_pensum, objetivo_del_pensum,
    id_publico_objetivo, duracion_de_la_sesion, unidad_duracion_sesion, estado
) VALUES
    (6101, 6001, 4001, 'Pensum onboarding comercial', 'Ruta de ingreso para ventas.', 2301, 4.00, 'HORAS', 1),
    (6102, 6002, 4003, 'Pensum CRM y tipificacion', 'Uso correcto de herramientas y codigos.', 2301, 2.50, 'HORAS', 1),
    (6103, 6003, 4005, 'Pensum objeciones y cierre', 'Refuerzo continuo de cierre comercial.', 2302, 2.00, 'HORAS', 1),
    (6104, 6004, 4002, 'Pensum onboarding soporte', 'Ruta inicial de speech y documentacion.', 2301, 3.50, 'HORAS', 1)
ON DUPLICATE KEY UPDATE
    id_man = VALUES(id_man),
    id_actividad_base = VALUES(id_actividad_base),
    nombre_del_pensum = VALUES(nombre_del_pensum),
    objetivo_del_pensum = VALUES(objetivo_del_pensum),
    id_publico_objetivo = VALUES(id_publico_objetivo),
    duracion_de_la_sesion = VALUES(duracion_de_la_sesion),
    unidad_duracion_sesion = VALUES(unidad_duracion_sesion),
    estado = VALUES(estado);

INSERT INTO pensum_detalle (
    id_pensum_detalle, id_pensum, dia_de_capacitacion, tema, contenido, top_tipologias,
    duracion, objetivo, descripcion_de_la_actividad, rutas
) VALUES
    (6201, 6101, 'Dia 1', 'Bienvenida y cultura', 'Contexto del negocio, cultura y herramientas base.', 'Apertura|saludo|validacion', 2.00, 'Alinear contexto inicial del agente.', 'Sesion expositiva con casos de ejemplo.', 'Intranet > Induccion > Cultura'),
    (6202, 6101, 'Dia 1', 'Speech comercial', 'Speech de apertura, escucha y cierre comercial.', 'objeciones|sondeo|cierre', 2.00, 'Estandarizar speech y estructura de llamada.', 'Role play guiado con retroalimentacion.', 'Intranet > Comercial > Speech'),
    (6203, 6102, 'Dia 1', 'CRM base', 'Navegacion del CRM, busqueda de cliente y tipificacion.', 'crm|tipificacion|wrapup', 1.50, 'Reducir errores de registro.', 'Demostracion paso a paso en ambiente demo.', 'Intranet > CRM > Guia rapida'),
    (6204, 6102, 'Dia 1', 'Trazabilidad', 'Documentacion del caso y codigos obligatorios.', 'documentacion|observaciones|cierre', 1.00, 'Asegurar trazabilidad completa.', 'Taller practico con casos reales.', 'Intranet > CRM > Trazabilidad'),
    (6205, 6103, 'Dia 1', 'Objeciones frecuentes', 'Manejo de objeciones de precio, tiempo y cobertura.', 'precio|tiempo|cobertura', 1.00, 'Mejorar seguridad del agente en cierre.', 'Role plays por parejas.', 'Biblioteca > Objeciones'),
    (6206, 6103, 'Dia 1', 'Cierre consultivo', 'Tecnicas de cierre y resumen final.', 'cierre|resumen|beneficio', 1.00, 'Incrementar conversion de cierre.', 'Practica con scorecard de observacion.', 'Biblioteca > Cierre consultivo'),
    (6207, 6104, 'Dia 1', 'Speech soporte', 'Validacion, escucha y clasificacion del incidente.', 'validacion|clasificacion|cierre', 2.00, 'Estandarizar la apertura y cierre.', 'Explicacion guiada con checklist.', 'Intranet > Soporte > Speech'),
    (6208, 6104, 'Dia 1', 'Compliance y documentacion', 'Politicas de seguridad y registro correcto del caso.', 'compliance|documentacion|hallazgos', 1.50, 'Disminuir hallazgos de calidad.', 'Analisis de errores frecuentes.', 'Intranet > Soporte > Compliance')
ON DUPLICATE KEY UPDATE
    id_pensum = VALUES(id_pensum),
    dia_de_capacitacion = VALUES(dia_de_capacitacion),
    tema = VALUES(tema),
    contenido = VALUES(contenido),
    top_tipologias = VALUES(top_tipologias),
    duracion = VALUES(duracion),
    objetivo = VALUES(objetivo),
    descripcion_de_la_actividad = VALUES(descripcion_de_la_actividad),
    rutas = VALUES(rutas);

INSERT INTO opr_pensum (id_opr_pensum, id_opr, id_pensum, fecha_asignacion) VALUES
    (6301, 5001, 6101, DATE_SUB(@today, INTERVAL 5 DAY)),
    (6302, 5001, 6102, DATE_SUB(@today, INTERVAL 4 DAY)),
    (6303, 5002, 6103, DATE_SUB(@today, INTERVAL 2 DAY)),
    (6304, 5003, 6104, DATE_SUB(@today, INTERVAL 4 DAY))
ON DUPLICATE KEY UPDATE
    id_opr = VALUES(id_opr),
    id_pensum = VALUES(id_pensum),
    fecha_asignacion = VALUES(fecha_asignacion);

INSERT INTO planificador (
    id_planificador, id_man, id_actividad, id_campana, id_opr, fecha_inicio, fecha_fin,
    metodologia, sala, cupo, estado, creado_por, fecha_creacion
) VALUES
    (7001, 6001, 4001, 2001, 5001, DATE_ADD(@now, INTERVAL 2 MINUTE), DATE_ADD(DATE_ADD(@now, INTERVAL 2 MINUTE), INTERVAL 122 MINUTE), 'Virtual', 'Teams Sala 1', 25, 'PROGRAMADO', 1002, DATE_SUB(@now, INTERVAL 1 DAY)),
    (7002, 6002, 4003, 2001, 5001, DATE_ADD(@now, INTERVAL 1 DAY), DATE_ADD(DATE_ADD(@now, INTERVAL 1 DAY), INTERVAL 150 MINUTE), 'Virtual', 'Teams Sala 2', 25, 'PROGRAMADO', 1002, DATE_SUB(@now, INTERVAL 1 DAY)),
    (7003, 6003, 4005, 2001, 5002, DATE_ADD(@now, INTERVAL 2 DAY), DATE_ADD(DATE_ADD(@now, INTERVAL 2 DAY), INTERVAL 120 MINUTE), 'Presencial', 'Sala Demo 4', 20, 'PROGRAMADO', 1002, DATE_SUB(@now, INTERVAL 1 DAY)),
    (7004, 6004, 4002, 2002, 5003, DATE_ADD(@now, INTERVAL 4 MINUTE), DATE_ADD(DATE_ADD(@now, INTERVAL 4 MINUTE), INTERVAL 124 MINUTE), 'Virtual', 'Teams Sala Soporte', 20, 'PROGRAMADO', 1003, DATE_SUB(@now, INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE
    id_man = VALUES(id_man),
    id_actividad = VALUES(id_actividad),
    id_campana = VALUES(id_campana),
    id_opr = VALUES(id_opr),
    fecha_inicio = VALUES(fecha_inicio),
    fecha_fin = VALUES(fecha_fin),
    metodologia = VALUES(metodologia),
    sala = VALUES(sala),
    cupo = VALUES(cupo),
    estado = VALUES(estado),
    creado_por = VALUES(creado_por),
    fecha_creacion = VALUES(fecha_creacion);

INSERT INTO sesion_virtual (
    id_sesion_virtual, id_planificador, teams_meeting_id, teams_call_id, teams_call_state,
    teams_join_url, qr_token, qr_expira_en, estado_sesion, creado_en, actualizado_en
) VALUES
    (7101, 7001, 'meeting-demo-7101', 'call-demo-7101', 'connected', 'https://teams.microsoft.com/l/meetup-join/demo-7101', 'seed-attendance-7101', DATE_ADD(@now, INTERVAL 7 MINUTE), 'ACTIVA', DATE_SUB(@now, INTERVAL 1 HOUR), @now),
    (7102, 7004, 'meeting-demo-7102', 'call-demo-7102', 'connected', 'https://teams.microsoft.com/l/meetup-join/demo-7102', 'seed-attendance-7102', DATE_ADD(@now, INTERVAL 9 MINUTE), 'ACTIVA', DATE_SUB(@now, INTERVAL 1 HOUR), @now)
ON DUPLICATE KEY UPDATE
    id_planificador = VALUES(id_planificador),
    teams_meeting_id = VALUES(teams_meeting_id),
    teams_call_id = VALUES(teams_call_id),
    teams_call_state = VALUES(teams_call_state),
    teams_join_url = VALUES(teams_join_url),
    qr_token = VALUES(qr_token),
    qr_expira_en = VALUES(qr_expira_en),
    estado_sesion = VALUES(estado_sesion),
    creado_en = VALUES(creado_en),
    actualizado_en = VALUES(actualizado_en);

INSERT INTO sesion_virtual_qr (
    id_sesion_virtual_qr, id_sesion_virtual, tipo_qr, qr_token, public_url, activa_desde,
    expira_en, estado, creado_en, actualizado_en
) VALUES
    (7201, 7101, 'ASISTENCIA', 'seed-attendance-7101', 'https://localhost/encuesta-asistencia/seed-attendance-7101', DATE_SUB(DATE_ADD(@now, INTERVAL 2 MINUTE), INTERVAL 5 MINUTE), DATE_ADD(DATE_ADD(@now, INTERVAL 2 MINUTE), INTERVAL 5 MINUTE), 'ACTIVO', @now, @now),
    (7202, 7101, 'RETARDO', 'seed-retardo-7101', 'https://localhost/encuesta-asistencia/seed-retardo-7101', DATE_ADD(DATE_ADD(@now, INTERVAL 2 MINUTE), INTERVAL 15 MINUTE), DATE_ADD(DATE_ADD(@now, INTERVAL 2 MINUTE), INTERVAL 30 MINUTE), 'PROGRAMADO', @now, @now),
    (7203, 7102, 'ASISTENCIA', 'seed-attendance-7102', 'https://localhost/encuesta-asistencia/seed-attendance-7102', DATE_SUB(DATE_ADD(@now, INTERVAL 4 MINUTE), INTERVAL 5 MINUTE), DATE_ADD(DATE_ADD(@now, INTERVAL 4 MINUTE), INTERVAL 5 MINUTE), 'ACTIVO', @now, @now),
    (7204, 7102, 'RETARDO', 'seed-retardo-7102', 'https://localhost/encuesta-asistencia/seed-retardo-7102', DATE_ADD(DATE_ADD(@now, INTERVAL 4 MINUTE), INTERVAL 15 MINUTE), DATE_ADD(DATE_ADD(@now, INTERVAL 4 MINUTE), INTERVAL 30 MINUTE), 'PROGRAMADO', @now, @now)
ON DUPLICATE KEY UPDATE
    id_sesion_virtual = VALUES(id_sesion_virtual),
    tipo_qr = VALUES(tipo_qr),
    qr_token = VALUES(qr_token),
    public_url = VALUES(public_url),
    activa_desde = VALUES(activa_desde),
    expira_en = VALUES(expira_en),
    estado = VALUES(estado),
    creado_en = VALUES(creado_en),
    actualizado_en = VALUES(actualizado_en);

INSERT INTO asistencia_scan (
    id_asistencia_scan, id_sesion_virtual, id_sesion_virtual_qr, qr_token_capturado, tipo_qr,
    tipo_documento_capturado, id_persona, nombre_capturado, cedula_capturada, id_campana_capturada,
    estado_validacion, origen, ip_origen, user_agent, fecha_scan, observacion
) VALUES
    (7301, 7101, 7201, 'seed-attendance-7101', 'ASISTENCIA', 'CC', 3001, 'Carlos Mendoza', '1003001', 2001, 'ASISTIO', 'seed_demo', '127.0.0.1', 'seed-demo', DATE_ADD(@now, INTERVAL 1 MINUTE), 'Registro demo valido de asistencia.'),
    (7302, 7101, 7202, 'seed-retardo-7101', 'RETARDO', 'CC', 3002, 'Paula Rojas', '1003002', 2001, 'RETARDO', 'seed_demo', '127.0.0.1', 'seed-demo', DATE_ADD(@now, INTERVAL 16 MINUTE), 'Registro demo valido de retardo.'),
    (7303, 7101, 7201, 'seed-attendance-7101', 'ASISTENCIA', 'CC', NULL, 'Invitado Externo', '9999999', 2001, 'NO_AUTORIZADO', 'seed_demo', '127.0.0.1', 'seed-demo', DATE_ADD(@now, INTERVAL 2 MINUTE), 'Caso no autorizado para validar vistas.'),
    (7304, 7102, 7203, 'seed-attendance-7102', 'ASISTENCIA', 'CC', 3011, 'Camila Suarez', '1003011', 2002, 'ASISTIO', 'seed_demo', '127.0.0.1', 'seed-demo', DATE_ADD(@now, INTERVAL 3 MINUTE), 'Registro demo valido de asistencia soporte.'),
    (7305, 7102, 7203, 'seed-attendance-7102', 'ASISTENCIA', 'CC', NULL, 'Asistente No Esperado', '8888888', 2002, 'NO_AUTORIZADO', 'seed_demo', '127.0.0.1', 'seed-demo', DATE_ADD(@now, INTERVAL 4 MINUTE), 'Caso inconsistente para validacion de sala.')
ON DUPLICATE KEY UPDATE
    id_sesion_virtual = VALUES(id_sesion_virtual),
    id_sesion_virtual_qr = VALUES(id_sesion_virtual_qr),
    qr_token_capturado = VALUES(qr_token_capturado),
    tipo_qr = VALUES(tipo_qr),
    tipo_documento_capturado = VALUES(tipo_documento_capturado),
    id_persona = VALUES(id_persona),
    nombre_capturado = VALUES(nombre_capturado),
    cedula_capturada = VALUES(cedula_capturada),
    id_campana_capturada = VALUES(id_campana_capturada),
    estado_validacion = VALUES(estado_validacion),
    origen = VALUES(origen),
    ip_origen = VALUES(ip_origen),
    user_agent = VALUES(user_agent),
    fecha_scan = VALUES(fecha_scan),
    observacion = VALUES(observacion);

INSERT INTO wave_formador (
    id_wave_formador, id_sesion_virtual, id_persona, id_opr, id_actividad, fecha,
    asistencia, estado_asistencia, observacion, fecha_registro
) VALUES
    (7401, 7101, 3001, 5001, 4001, DATE(DATE_ADD(@now, INTERVAL 2 MINUTE)), 1, 'ASISTIO', 'Registro demo alineado con QR.', DATE_ADD(@now, INTERVAL 1 MINUTE)),
    (7402, 7101, 3002, 5001, 4001, DATE(DATE_ADD(@now, INTERVAL 2 MINUTE)), 1, 'RETARDO', 'Registro demo de retardo.', DATE_ADD(@now, INTERVAL 16 MINUTE)),
    (7403, 7102, 3011, 5003, 4002, DATE(DATE_ADD(@now, INTERVAL 4 MINUTE)), 1, 'ASISTIO', 'Registro demo soporte.', DATE_ADD(@now, INTERVAL 3 MINUTE))
ON DUPLICATE KEY UPDATE
    id_sesion_virtual = VALUES(id_sesion_virtual),
    id_persona = VALUES(id_persona),
    id_opr = VALUES(id_opr),
    id_actividad = VALUES(id_actividad),
    fecha = VALUES(fecha),
    asistencia = VALUES(asistencia),
    estado_asistencia = VALUES(estado_asistencia),
    observacion = VALUES(observacion),
    fecha_registro = VALUES(fecha_registro);

INSERT INTO asistencia_ia (
    id_asistencia_ia, id_planificador, id_persona, codigo_qr_leido, asistencia_esperada,
    asistencia_marcada_qr, resultado_contraste, observacion_ia, fecha_analisis
) VALUES
    (7501, 7001, 3001, 'seed-attendance-7101', 1, 1, 'COINCIDE', 'La persona asistio dentro de la ventana esperada.', DATE_ADD(@now, INTERVAL 6 MINUTE)),
    (7502, 7001, 3002, 'seed-retardo-7101', 1, 1, 'COINCIDE_CON_RETARDO', 'Ingreso en ventana de retardo pero con trazabilidad valida.', DATE_ADD(@now, INTERVAL 18 MINUTE)),
    (7503, 7001, 3003, NULL, 1, 0, 'NO_ASISTIO', 'No se encontro registro QR durante la sesion.', DATE_ADD(@now, INTERVAL 35 MINUTE)),
    (7504, 7004, 3011, 'seed-attendance-7102', 1, 1, 'COINCIDE', 'Asistencia valida en sesion de soporte.', DATE_ADD(@now, INTERVAL 8 MINUTE))
ON DUPLICATE KEY UPDATE
    id_planificador = VALUES(id_planificador),
    id_persona = VALUES(id_persona),
    codigo_qr_leido = VALUES(codigo_qr_leido),
    asistencia_esperada = VALUES(asistencia_esperada),
    asistencia_marcada_qr = VALUES(asistencia_marcada_qr),
    resultado_contraste = VALUES(resultado_contraste),
    observacion_ia = VALUES(observacion_ia),
    fecha_analisis = VALUES(fecha_analisis);

INSERT INTO lista_naranja (
    id_lista_naranja, id_persona, id_opr, id_motivo, fecha_reporte, nivel_riesgo, observacion, estado
) VALUES
    (7601, 3004, 5001, 2402, DATE_SUB(@today, INTERVAL 1 DAY), 'MEDIO', 'Presenta brecha en conversion y acompanamiento reforzado.', 'ACTIVO'),
    (7602, 3012, 5003, 2401, DATE_SUB(@today, INTERVAL 2 DAY), 'ALTO', 'Reporto novedades de asistencia en dos jornadas consecutivas.', 'ACTIVO')
ON DUPLICATE KEY UPDATE
    id_persona = VALUES(id_persona),
    id_opr = VALUES(id_opr),
    id_motivo = VALUES(id_motivo),
    fecha_reporte = VALUES(fecha_reporte),
    nivel_riesgo = VALUES(nivel_riesgo),
    observacion = VALUES(observacion),
    estado = VALUES(estado);

INSERT INTO persona_certificacion (
    id_persona_certificacion, id_persona, id_certificacion, fecha_certificacion, resultado, puntaje, observacion
) VALUES
    (7701, 3001, 2501, DATE_SUB(@today, INTERVAL 1 DAY), 'APROBADO', 95.00, 'Cumple criterios de salida a operacion.'),
    (7702, 3002, 2501, DATE_SUB(@today, INTERVAL 1 DAY), 'APROBADO', 88.00, 'Aprobado con plan de seguimiento sobre cierres.'),
    (7703, 3011, 2501, DATE_SUB(@today, INTERVAL 1 DAY), 'APROBADO', 92.00, 'Buen dominio del speech de soporte.'),
    (7704, 3012, 2502, DATE_SUB(@today, INTERVAL 1 DAY), 'PENDIENTE', 76.00, 'Pendiente nuevo monitoreo de calidad.')
ON DUPLICATE KEY UPDATE
    id_persona = VALUES(id_persona),
    id_certificacion = VALUES(id_certificacion),
    fecha_certificacion = VALUES(fecha_certificacion),
    resultado = VALUES(resultado),
    puntaje = VALUES(puntaje),
    observacion = VALUES(observacion);

INSERT INTO persona_encuesta (
    id_persona_encuesta, id_persona, id_encuesta, fecha_respuesta, puntaje, observacion
) VALUES
    (7801, 3001, 2601, @today, 4.80, 'Percibe claridad y buena dinamica del onboarding.'),
    (7802, 3002, 2601, @today, 4.20, 'Solicita mas practica sobre objeciones.'),
    (7803, 3011, 2602, @today, 4.60, 'Buen acompanamiento en OJT y soporte.')
ON DUPLICATE KEY UPDATE
    id_persona = VALUES(id_persona),
    id_encuesta = VALUES(id_encuesta),
    fecha_respuesta = VALUES(fecha_respuesta),
    puntaje = VALUES(puntaje),
    observacion = VALUES(observacion);

INSERT INTO persona_encuesta_detalle (
    id_persona_encuesta_detalle, id_persona_encuesta, numero_pregunta, respuesta, puntaje_respuesta
) VALUES
    (7811, 7801, 1, 'Si, cumplio completamente el objetivo.', 5.00),
    (7812, 7801, 2, 'El material fue muy claro y practico.', 4.80),
    (7813, 7802, 1, 'Si, aunque me gustaria mas tiempo de practica.', 4.20),
    (7814, 7802, 3, 'El formador resolvio dudas concretas.', 4.10),
    (7815, 7803, 1, 'Recibi feedback accionable y oportuno.', 4.70),
    (7816, 7803, 8, 'Me siento mas segura en la operacion.', 4.50)
ON DUPLICATE KEY UPDATE
    id_persona_encuesta = VALUES(id_persona_encuesta),
    numero_pregunta = VALUES(numero_pregunta),
    respuesta = VALUES(respuesta),
    puntaje_respuesta = VALUES(puntaje_respuesta);

INSERT INTO retroalimentaciones (
    id_retroalimentacion, id_persona, creado_por, origen, titulo, fortalezas,
    oportunidades, plan_accion, estado, fecha_creacion
) VALUES
    (7901, 3001, 1007, 'OJT', 'Feedback de acompanamiento comercial', 'Buen rapport y validacion inicial.', 'Debe resumir beneficios con mas estructura.', 'Practicar cierre consultivo durante 3 jornadas.', 'ABIERTA', DATE_SUB(@now, INTERVAL 1 DAY)),
    (7902, 3011, 1007, 'MONITOREO', 'Feedback de speech soporte', 'Excelente escucha y clasificacion del caso.', 'Fortalecer documentacion de cierre.', 'Revisar checklist de compliance antes de cerrar.', 'ABIERTA', DATE_SUB(@now, INTERVAL 12 HOUR))
ON DUPLICATE KEY UPDATE
    id_persona = VALUES(id_persona),
    creado_por = VALUES(creado_por),
    origen = VALUES(origen),
    titulo = VALUES(titulo),
    fortalezas = VALUES(fortalezas),
    oportunidades = VALUES(oportunidades),
    plan_accion = VALUES(plan_accion),
    estado = VALUES(estado),
    fecha_creacion = VALUES(fecha_creacion);

INSERT INTO compromisos (
    id_compromiso, id_retroalimentacion, id_persona, id_usuario_responsable, descripcion,
    fecha_compromiso, fecha_vencimiento, estado, fecha_creacion
) VALUES
    (8001, 7901, 3001, 1009, 'Aplicar guion de cierre consultivo en 5 llamadas monitoreadas.', @today, DATE_ADD(@today, INTERVAL 5 DAY), 'VIGENTE', DATE_SUB(@now, INTERVAL 20 HOUR)),
    (8002, 7902, 3011, 1003, 'Asegurar checklist de documentacion antes del wrap up.', @today, DATE_ADD(@today, INTERVAL 4 DAY), 'VIGENTE', DATE_SUB(@now, INTERVAL 10 HOUR))
ON DUPLICATE KEY UPDATE
    id_retroalimentacion = VALUES(id_retroalimentacion),
    id_persona = VALUES(id_persona),
    id_usuario_responsable = VALUES(id_usuario_responsable),
    descripcion = VALUES(descripcion),
    fecha_compromiso = VALUES(fecha_compromiso),
    fecha_vencimiento = VALUES(fecha_vencimiento),
    estado = VALUES(estado),
    fecha_creacion = VALUES(fecha_creacion);

INSERT INTO monitoreos_calidad (
    id_monitoreo_calidad, id_persona, id_analista, call_id, criterio, puntaje,
    hallazgo, recomendacion, estado, fecha_creacion
) VALUES
    (8101, 3001, 1006, 'CALL-8101', 'Apertura y sondeo', 90.00, 'Sondeo correcto con oportunidad menor de cierre.', 'Mantener estructura y reforzar beneficios.', 'CERRADO', DATE_SUB(@now, INTERVAL 2 DAY)),
    (8102, 3011, 1006, 'CALL-8102', 'Compliance y documentacion', 87.00, 'Hallazgo menor en documentacion del cierre.', 'Usar plantilla final antes de terminar la llamada.', 'CERRADO', DATE_SUB(@now, INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE
    id_persona = VALUES(id_persona),
    id_analista = VALUES(id_analista),
    call_id = VALUES(call_id),
    criterio = VALUES(criterio),
    puntaje = VALUES(puntaje),
    hallazgo = VALUES(hallazgo),
    recomendacion = VALUES(recomendacion),
    estado = VALUES(estado),
    fecha_creacion = VALUES(fecha_creacion);

INSERT INTO ojt_seguimientos (
    id_ojt_seguimiento, id_persona, id_opr, dia, aht, calidad, csat, estado, observacion, fecha_creacion
) VALUES
    (8201, 3001, 5001, 1, '590', 91.00, 4.70, 'ACTIVO', 'Buen inicio de curva en ventas.', DATE_SUB(@now, INTERVAL 2 DAY)),
    (8202, 3002, 5001, 2, '610', 88.00, 4.30, 'ACTIVO', 'Requiere refuerzo puntual en objeciones.', DATE_SUB(@now, INTERVAL 1 DAY)),
    (8203, 3011, 5003, 1, '540', 93.00, 4.80, 'ACTIVO', 'Muy buen manejo del speech soporte.', DATE_SUB(@now, INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE
    id_persona = VALUES(id_persona),
    id_opr = VALUES(id_opr),
    dia = VALUES(dia),
    aht = VALUES(aht),
    calidad = VALUES(calidad),
    csat = VALUES(csat),
    estado = VALUES(estado),
    observacion = VALUES(observacion),
    fecha_creacion = VALUES(fecha_creacion);

INSERT INTO preturnos (
    id_preturno, id_opr, creado_por, tema, fecha, preguntas, nota_promedio, estado, fecha_creacion
) VALUES
    (8301, 5001, 1002, 'Repaso speech y CRM antes de ingreso a linea', @today, 5, 4.50, 'ACTIVO', DATE_SUB(@now, INTERVAL 4 HOUR)),
    (8302, 5003, 1003, 'Checklist de validacion y cierre soporte', @today, 4, 4.70, 'ACTIVO', DATE_SUB(@now, INTERVAL 3 HOUR))
ON DUPLICATE KEY UPDATE
    id_opr = VALUES(id_opr),
    creado_por = VALUES(creado_por),
    tema = VALUES(tema),
    fecha = VALUES(fecha),
    preguntas = VALUES(preguntas),
    nota_promedio = VALUES(nota_promedio),
    estado = VALUES(estado),
    fecha_creacion = VALUES(fecha_creacion);

INSERT INTO agenda_eventos (
    id_agenda_evento, id_planificador, id_opr, id_responsable, titulo, descripcion,
    fecha_inicio, fecha_fin, modalidad, estado, fecha_creacion
) VALUES
    (8401, 7001, 5001, 1002, 'Sesion de onboarding comercial', 'Bloque inicial de bienvenida, speech y cultura.', DATE_ADD(@now, INTERVAL 2 MINUTE), DATE_ADD(DATE_ADD(@now, INTERVAL 2 MINUTE), INTERVAL 122 MINUTE), 'Virtual', 'PROGRAMADO', DATE_SUB(@now, INTERVAL 1 DAY)),
    (8402, 7004, 5003, 1003, 'Sesion onboarding soporte premium', 'Bloque inicial de speech y compliance para soporte.', DATE_ADD(@now, INTERVAL 4 MINUTE), DATE_ADD(DATE_ADD(@now, INTERVAL 4 MINUTE), INTERVAL 124 MINUTE), 'Virtual', 'PROGRAMADO', DATE_SUB(@now, INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE
    id_planificador = VALUES(id_planificador),
    id_opr = VALUES(id_opr),
    id_responsable = VALUES(id_responsable),
    titulo = VALUES(titulo),
    descripcion = VALUES(descripcion),
    fecha_inicio = VALUES(fecha_inicio),
    fecha_fin = VALUES(fecha_fin),
    modalidad = VALUES(modalidad),
    estado = VALUES(estado),
    fecha_creacion = VALUES(fecha_creacion);

INSERT INTO biblioteca_actividades (
    id_biblioteca_actividad, id_actividad, creado_por, categoria, titulo, descripcion,
    recurso_url, estado, fecha_creacion
) VALUES
    (8501, 4005, 1002, 'Role play', 'Guia de objeciones y cierre', 'Material reusable para practicas de cierres comerciales.', 'https://demo.local/biblioteca/objeciones-cierre', 'ACTIVO', DATE_SUB(@now, INTERVAL 7 DAY)),
    (8502, 4006, 1003, 'Checklist', 'Matriz de calidad y compliance', 'Checklist reusable para documentacion y hallazgos de soporte.', 'https://demo.local/biblioteca/calidad-compliance', 'ACTIVO', DATE_SUB(@now, INTERVAL 7 DAY))
ON DUPLICATE KEY UPDATE
    id_actividad = VALUES(id_actividad),
    creado_por = VALUES(creado_por),
    categoria = VALUES(categoria),
    titulo = VALUES(titulo),
    descripcion = VALUES(descripcion),
    recurso_url = VALUES(recurso_url),
    estado = VALUES(estado),
    fecha_creacion = VALUES(fecha_creacion);

INSERT INTO resultado_operacion (
    id_resultado_operacion, id_persona, modulo, indicador, valor_inicial, valor_final,
    tendencia, observacion, fecha_creacion
) VALUES
    (8601, 3001, 'Ventas', 'AHT', 650.00, 590.00, 'BAJA', 'Redujo tiempos despues de refuerzo inicial.', DATE_SUB(@now, INTERVAL 2 DAY)),
    (8602, 3002, 'Ventas', 'Calidad', 82.00, 90.00, 'ALZA', 'Mejora clara luego del coaching de objeciones.', DATE_SUB(@now, INTERVAL 1 DAY)),
    (8603, 3011, 'Soporte', 'CSAT', 78.00, 89.00, 'ALZA', 'Sube satisfaccion tras seguimiento de speech.', DATE_SUB(@now, INTERVAL 1 DAY)),
    (8604, 3012, 'Soporte', 'AHT', 720.00, 640.00, 'BAJA', 'Mejora operativa aunque aun requiere control de asistencia.', DATE_SUB(@now, INTERVAL 1 DAY))
ON DUPLICATE KEY UPDATE
    id_persona = VALUES(id_persona),
    modulo = VALUES(modulo),
    indicador = VALUES(indicador),
    valor_inicial = VALUES(valor_inicial),
    valor_final = VALUES(valor_final),
    tendencia = VALUES(tendencia),
    observacion = VALUES(observacion),
    fecha_creacion = VALUES(fecha_creacion);

INSERT INTO teams_participante_live (
    id_teams_participante_live, id_sesion_virtual, teams_participant_id, display_name, email,
    aad_object_id, estado_participacion, fecha_join, fecha_leave, autorizado, razon_validacion
) VALUES
    (8701, 7101, 'teams-7101-3001', 'Carlos Mendoza', 'agente@local.test', 'aad-3001', 'EN_SALA', DATE_ADD(@now, INTERVAL 1 MINUTE), NULL, 1, 'Documento y campaña coinciden con lista esperada.'),
    (8702, 7101, 'teams-7101-externo', 'Invitado Externo', 'externo@demo.test', 'aad-externo', 'EN_SALA', DATE_ADD(@now, INTERVAL 2 MINUTE), NULL, 0, 'No aparece en la lista esperada del grupo.'),
    (8703, 7102, 'teams-7102-3011', 'Camila Suarez', 'camila.suarez.demo@local.test', 'aad-3011', 'EN_SALA', DATE_ADD(@now, INTERVAL 3 MINUTE), NULL, 1, 'Participante autorizado en grupo soporte.')
ON DUPLICATE KEY UPDATE
    id_sesion_virtual = VALUES(id_sesion_virtual),
    teams_participant_id = VALUES(teams_participant_id),
    display_name = VALUES(display_name),
    email = VALUES(email),
    aad_object_id = VALUES(aad_object_id),
    estado_participacion = VALUES(estado_participacion),
    fecha_join = VALUES(fecha_join),
    fecha_leave = VALUES(fecha_leave),
    autorizado = VALUES(autorizado),
    razon_validacion = VALUES(razon_validacion);

INSERT INTO teams_moderacion_log (
    id_teams_moderacion_log, id_sesion_virtual, teams_participant_id, accion, resultado, detalle, fecha_evento
) VALUES
    (8801, 7101, 'teams-7101-externo', 'EXPULSAR_SOLICITADO', 'PENDIENTE_INTEGRACION', 'Caso demo para validar la traza de moderacion mientras no existe integracion automatica con Teams.', DATE_ADD(@now, INTERVAL 3 MINUTE))
ON DUPLICATE KEY UPDATE
    id_sesion_virtual = VALUES(id_sesion_virtual),
    teams_participant_id = VALUES(teams_participant_id),
    accion = VALUES(accion),
    resultado = VALUES(resultado),
    detalle = VALUES(detalle),
    fecha_evento = VALUES(fecha_evento);
