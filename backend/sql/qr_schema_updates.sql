CREATE TABLE IF NOT EXISTS tipo_documento_catalogo (
    id_tipo_documento_catalogo INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    regex_documento VARCHAR(255) NOT NULL,
    longitud_minima INT NOT NULL DEFAULT 4,
    longitud_maxima INT NOT NULL DEFAULT 30,
    estado TINYINT(1) NOT NULL DEFAULT 1,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO tipo_documento_catalogo (
    codigo, nombre, regex_documento, longitud_minima, longitud_maxima, estado
) VALUES
    ('CC', 'Cedula de ciudadania', '^[0-9]{6,12}$', 6, 12, 1),
    ('CE', 'Cedula de extranjeria', '^[A-Za-z0-9]{6,15}$', 6, 15, 1),
    ('TI', 'Tarjeta de identidad', '^[0-9]{8,11}$', 8, 11, 1),
    ('PASAPORTE', 'Pasaporte', '^[A-Za-z0-9]{5,20}$', 5, 20, 1),
    ('PEP', 'Permiso especial de permanencia', '^[A-Za-z0-9]{6,20}$', 6, 20, 1),
    ('PPT', 'Permiso por proteccion temporal', '^[A-Za-z0-9]{6,20}$', 6, 20, 1),
    ('NIT', 'Numero de identificacion tributaria', '^[0-9]{6,15}$', 6, 15, 1)
ON DUPLICATE KEY UPDATE
    nombre = VALUES(nombre),
    regex_documento = VALUES(regex_documento),
    longitud_minima = VALUES(longitud_minima),
    longitud_maxima = VALUES(longitud_maxima),
    estado = VALUES(estado);

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_apply_qr_schema_updates $$
CREATE PROCEDURE sp_apply_qr_schema_updates()
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'asistencia_scan'
          AND column_name = 'id_sesion_virtual'
    ) THEN
        ALTER TABLE asistencia_scan
            MODIFY COLUMN id_sesion_virtual INT NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'asistencia_scan'
          AND column_name = 'id_sesion_virtual_qr'
    ) THEN
        ALTER TABLE asistencia_scan
            ADD COLUMN id_sesion_virtual_qr INT NULL AFTER id_sesion_virtual;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'asistencia_scan'
          AND column_name = 'qr_token_capturado'
    ) THEN
        ALTER TABLE asistencia_scan
            ADD COLUMN qr_token_capturado VARCHAR(255) NOT NULL AFTER id_sesion_virtual_qr;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'asistencia_scan'
          AND column_name = 'tipo_qr'
    ) THEN
        ALTER TABLE asistencia_scan
            ADD COLUMN tipo_qr VARCHAR(30) NULL AFTER qr_token_capturado;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'asistencia_scan'
          AND column_name = 'tipo_documento_capturado'
    ) THEN
        ALTER TABLE asistencia_scan
            ADD COLUMN tipo_documento_capturado VARCHAR(20) NULL AFTER tipo_qr;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE constraint_schema = DATABASE()
          AND table_name = 'asistencia_scan'
          AND constraint_name = 'fk_asistencia_scan_sesion_qr'
    ) THEN
        ALTER TABLE asistencia_scan
            ADD CONSTRAINT fk_asistencia_scan_sesion_qr
                FOREIGN KEY (id_sesion_virtual_qr) REFERENCES sesion_virtual_qr(id_sesion_virtual_qr)
                ON UPDATE CASCADE
                ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'asistencia_scan'
          AND index_name = 'idx_asistencia_scan_estado'
    ) THEN
        ALTER TABLE asistencia_scan
            ADD KEY idx_asistencia_scan_estado (estado_validacion, fecha_scan);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'asistencia_scan'
          AND index_name = 'idx_asistencia_scan_sesion_qr'
    ) THEN
        ALTER TABLE asistencia_scan
            ADD KEY idx_asistencia_scan_sesion_qr (id_sesion_virtual_qr, fecha_scan);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'asistencia_scan'
          AND index_name = 'idx_asistencia_scan_token'
    ) THEN
        ALTER TABLE asistencia_scan
            ADD KEY idx_asistencia_scan_token (qr_token_capturado);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'wave_formador'
          AND column_name = 'id_sesion_virtual'
    ) THEN
        ALTER TABLE wave_formador
            ADD COLUMN id_sesion_virtual INT NULL AFTER id_wave_formador;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'wave_formador'
          AND column_name = 'estado_asistencia'
    ) THEN
        ALTER TABLE wave_formador
            ADD COLUMN estado_asistencia VARCHAR(20) NOT NULL DEFAULT 'ASISTIO' AFTER asistencia;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'wave_formador'
          AND column_name = 'fecha_registro'
    ) THEN
        ALTER TABLE wave_formador
            ADD COLUMN fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER observacion;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE constraint_schema = DATABASE()
          AND table_name = 'wave_formador'
          AND constraint_name = 'fk_wave_formador_sesion'
    ) THEN
        ALTER TABLE wave_formador
            ADD CONSTRAINT fk_wave_formador_sesion
                FOREIGN KEY (id_sesion_virtual) REFERENCES sesion_virtual(id_sesion_virtual)
                ON UPDATE CASCADE
                ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'wave_formador'
          AND index_name = 'uq_wave_formador_sesion_persona'
    ) THEN
        ALTER TABLE wave_formador
            ADD UNIQUE KEY uq_wave_formador_sesion_persona (id_sesion_virtual, id_persona);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'wave_formador'
          AND index_name = 'idx_wave_formador_estado'
    ) THEN
        ALTER TABLE wave_formador
            ADD KEY idx_wave_formador_estado (estado_asistencia, fecha_registro);
    END IF;
END $$

CALL sp_apply_qr_schema_updates() $$
DROP PROCEDURE IF EXISTS sp_apply_qr_schema_updates $$

DELIMITER ;
