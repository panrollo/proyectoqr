SET @frontend_public_url = 'https://TU_DOMINIO_PUBLICO_FRONTEND';

UPDATE sesion_virtual_qr
SET public_url = CONCAT(TRIM(TRAILING '/' FROM @frontend_public_url), '/encuesta-asistencia/', qr_token),
    actualizado_en = NOW()
WHERE qr_token IS NOT NULL
  AND qr_token <> ''
  AND (
      public_url IS NULL
      OR public_url = ''
      OR public_url <> CONCAT(TRIM(TRAILING '/' FROM @frontend_public_url), '/encuesta-asistencia/', qr_token)
  );
