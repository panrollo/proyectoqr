import { useEffect, useMemo, useState } from "react";

import { API_BASE_URL, api } from "../../services/api";
import { DataTable } from "../shared/DataTable";
import { EmptyState } from "../shared/EmptyState";
import { MetricsGrid } from "../shared/MetricsGrid";

function formatDateTime(value) {
  if (!value) return "-";

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return value;
  }

  return new Intl.DateTimeFormat("es-CO", {
    dateStyle: "medium",
    timeStyle: "short",
  }).format(date);
}

function isValidHttpUrl(value) {
  try {
    const parsed = new URL(value);
    return parsed.protocol === "http:" || parsed.protocol === "https:";
  } catch (_error) {
    return false;
  }
}

function resolveInitialSessionId(sessions, selectedSessionId) {
  if (!sessions.length) return "";

  if (selectedSessionId && sessions.some((session) => String(session.virtual_session_id) === String(selectedSessionId))) {
    return String(selectedSessionId);
  }

  return String(sessions[0].virtual_session_id);
}

function QrCard({ qrCode }) {
  return (
    <div className="qr-card">
      <div className="qr-card-head">
        <div>
          <div className="ct">{qrCode.qr_type}</div>
          <div className="small-note">{formatDateTime(qrCode.active_from)} a {formatDateTime(qrCode.expires_at)}</div>
        </div>
        <div className={`b ${qrCode.qr_status === "VIGENTE" ? "gn" : qrCode.qr_status === "PENDIENTE" ? "am" : "rd"}`}>
          {qrCode.qr_status}
        </div>
      </div>
      <div className="qr-image-wrap">
        <img
          className="qr-image"
          src={`${API_BASE_URL}/public/qr/${encodeURIComponent(qrCode.qr_token)}/image`}
          alt={`QR ${qrCode.qr_type}`}
        />
      </div>
      <div className="fg">
        <label className="fl">URL publica</label>
        <input className="fi" readOnly value={qrCode.public_url || ""} />
      </div>
    </div>
  );
}

export function TrainerAttendancePanel({ meta }) {
  const [sessions, setSessions] = useState([]);
  const [selectedSessionId, setSelectedSessionId] = useState("");
  const [selectedSession, setSelectedSession] = useState(null);
  const [records, setRecords] = useState([]);
  const [qrCodes, setQrCodes] = useState([]);
  const [expectedPeople, setExpectedPeople] = useState([]);
  const [roomValidation, setRoomValidation] = useState([]);
  const [joinUrl, setJoinUrl] = useState("");
  const [loadingSessions, setLoadingSessions] = useState(true);
  const [loadingDetails, setLoadingDetails] = useState(false);
  const [savingLink, setSavingLink] = useState(false);
  const [generatingQr, setGeneratingQr] = useState(false);
  const [expellingParticipantId, setExpellingParticipantId] = useState("");
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");

  async function loadSessions(sessionIdToKeep = selectedSessionId) {
    setLoadingSessions(true);
    try {
      const response = await api.get("/trainer/attendance/sessions");
      setSessions(response);
      const nextSessionId = resolveInitialSessionId(response, sessionIdToKeep);
      setSelectedSessionId(nextSessionId);
      return nextSessionId;
    } catch (requestError) {
      setError(requestError.message || "No fue posible consultar las sesiones de asistencia.");
      return "";
    } finally {
      setLoadingSessions(false);
    }
  }

  async function loadSessionDetails(sessionId) {
    if (!sessionId) {
      setSelectedSession(null);
      setRecords([]);
      setQrCodes([]);
      setExpectedPeople([]);
      setRoomValidation([]);
      setJoinUrl("");
      return;
    }

    setLoadingDetails(true);
    setError("");

    try {
      const [recordsResponse, qrResponse, expectedResponse, roomResponse] = await Promise.all([
        api.get(`/trainer/attendance/sessions/${sessionId}/records`),
        api.get(`/trainer/attendance/sessions/${sessionId}/qr`),
        api.get(`/trainer/attendance/sessions/${sessionId}/expected-people`),
        api.get(`/trainer/attendance/sessions/${sessionId}/room-validation`),
      ]);

      setSelectedSession(recordsResponse.session);
      setRecords(recordsResponse.records);
      setJoinUrl(recordsResponse.session?.join_url || "");
      setQrCodes(qrResponse);
      setExpectedPeople(expectedResponse);
      setRoomValidation(roomResponse);
    } catch (requestError) {
      setError(requestError.message || "No fue posible consultar el detalle de la sesion.");
      setSelectedSession(null);
      setRecords([]);
      setQrCodes([]);
      setExpectedPeople([]);
      setRoomValidation([]);
      setJoinUrl("");
    } finally {
      setLoadingDetails(false);
    }
  }

  useEffect(() => {
    async function initialize() {
      setError("");
      await loadSessions("");
    }

    initialize();
  }, []);

  useEffect(() => {
    if (!selectedSessionId) return;
    loadSessionDetails(selectedSessionId);
  }, [selectedSessionId]);

  const metrics = useMemo(() => {
    if (!selectedSession) return [];

    return [
      {
        label: "Sesion",
        value: selectedSession.virtual_session_id,
        helper: selectedSession.activity_name || "Sesion virtual",
        color: "#1A5FBF",
      },
      {
        label: "Grupo",
        value: selectedSession.group_code || "-",
        helper: selectedSession.group_name || "Sin grupo",
        color: "#0D7A5F",
      },
      {
        label: "Asistencia tomada",
        value: selectedSession.attendance_taken_total || 0,
        helper: "Registros QR procesados",
        color: "#C07A10",
      },
      {
        label: "Esperados",
        value: expectedPeople.length || selectedSession.expected_participants_total || 0,
        helper: "Personal autorizado en OPR/HC",
        color: "#C0272D",
      },
    ];
  }, [expectedPeople.length, selectedSession]);

  async function handleSaveLink() {
    const trimmedUrl = joinUrl.trim();

    if (!selectedSessionId) {
      setError("Debes seleccionar una sesion de formacion.");
      return;
    }

    if (!trimmedUrl) {
      setError("Debes ingresar un enlace valido.");
      return;
    }

    if (!isValidHttpUrl(trimmedUrl)) {
      setError("El enlace debe iniciar con http o https y tener un formato valido.");
      return;
    }

    setSavingLink(true);
    setError("");
    setSuccess("");

    try {
      await api.put(`/trainer/attendance/sessions/${selectedSessionId}/link`, {
        join_url: trimmedUrl,
      });

      setSuccess("El enlace de la sesion se guardo correctamente.");
      await loadSessions(selectedSessionId);
      await loadSessionDetails(selectedSessionId);
    } catch (requestError) {
      setError(requestError.message || "No fue posible guardar el enlace de la sesion.");
    } finally {
      setSavingLink(false);
    }
  }

  async function handleGenerateQr() {
    if (!selectedSessionId) {
      setError("Debes seleccionar una sesion para generar los QRs.");
      return;
    }

    setGeneratingQr(true);
    setError("");
    setSuccess("");

    try {
      const response = await api.post(`/trainer/attendance/sessions/${selectedSessionId}/qr/generate`, {});
      setQrCodes(response);
      setSuccess("Los QRs de asistencia y retardo fueron generados nuevamente y ahora apuntan al formulario publico de asistencia.");
    } catch (requestError) {
      setError(requestError.message || "No fue posible generar los QRs de la sesion.");
    } finally {
      setGeneratingQr(false);
    }
  }

  async function handleExpelParticipant(participant) {
    setExpellingParticipantId(participant.teams_participant_id);
    setError("");
    setSuccess("");

    try {
      const response = await api.post(
        `/trainer/attendance/sessions/${selectedSessionId}/room-validation/${participant.teams_participant_id}/expel`,
        {
          detail: `Solicitud desde panel del formador para ${participant.display_name || participant.teams_participant_id}`,
        },
      );
      setSuccess(response.message);
      await loadSessionDetails(selectedSessionId);
    } catch (requestError) {
      setError(requestError.message || "No fue posible registrar la solicitud de expulsion.");
    } finally {
      setExpellingParticipantId("");
    }
  }

  return (
    <div className="panel-scroll">
      <div>
        <div className="ptitle">{meta?.title || "Modulo de asistencia"}</div>
        <div className="psub">
          {meta?.subtitle || "Genera QRs firmados, registra asistencia y valida asistentes reales en sala."}
        </div>
      </div>

      {error ? <div className="banner-error">{error}</div> : null}
      {success ? <div className="al su"><div>{success}</div></div> : null}

      <div className="card">
        <div className="ch">
          <div className="ct">Sesiones asignadas al formador</div>
        </div>
        {loadingSessions ? (
          <div className="psub" style={{ marginBottom: 0 }}>
            Cargando sesiones desde MySQL...
          </div>
        ) : !sessions.length ? (
          <EmptyState message="No hay sesiones virtuales asignadas al formador autenticado." />
        ) : (
          <>
            <div className="form-grid">
              <div className="fg">
                <label className="fl">Formacion especifica</label>
                <select className="fs" value={selectedSessionId} onChange={(event) => setSelectedSessionId(event.target.value)}>
                  {sessions.map((session) => (
                    <option key={session.virtual_session_id} value={session.virtual_session_id}>
                      {session.group_code} - {session.activity_name} - sesion {session.virtual_session_id}
                    </option>
                  ))}
                </select>
              </div>
              <div className="fg">
                <label className="fl">Estado de la sesion</label>
                <input className="fi" value={selectedSession?.session_status || ""} placeholder="Sin estado disponible" readOnly />
              </div>
            </div>
            {selectedSession ? <MetricsGrid items={metrics} /> : null}
          </>
        )}
      </div>

      <div className="card">
        <div className="ch">
          <div className="ct">Enlace de sala y QR firmado</div>
        </div>
        <div className="form-grid">
          <div className="fg">
            <label className="fl">URL de ingreso a la sala</label>
            <input
              className="fi"
              type="url"
              value={joinUrl}
              placeholder="https://..."
              onChange={(event) => setJoinUrl(event.target.value)}
            />
          </div>
          <div className="fg">
            <label className="fl">Inicio de sesion</label>
            <input
              className="fi"
              value={selectedSession?.start_at ? formatDateTime(selectedSession.start_at) : ""}
              placeholder="Sin fecha disponible"
              readOnly
            />
          </div>
        </div>
        <div className="table-actions">
          <button className="btn pri" onClick={handleSaveLink} disabled={!selectedSessionId || savingLink}>
            {savingLink ? "Guardando..." : "Guardar enlace"}
          </button>
          <button className="btn sec" onClick={handleGenerateQr} disabled={!selectedSessionId || generatingQr}>
            {generatingQr ? "Generando..." : "Generar / regenerar QRs"}
          </button>
        </div>
        <div className="small-note">
          El QR de asistencia se abre 5 minutos antes y expira 5 minutos despues del inicio. El QR de retardo opera entre los minutos 15 y 30.
        </div>
      </div>

      <div className="card">
        <div className="ch">
          <div className="ct">QRs de la sesion</div>
        </div>
        {loadingDetails ? (
          <div className="psub" style={{ marginBottom: 0 }}>Sincronizando QRs...</div>
        ) : !qrCodes.length ? (
          <EmptyState message="Esta sesion todavia no tiene QRs firmados. Usa el boton de generacion para crearlos." />
        ) : (
          <div className="qr-grid">
            {qrCodes.map((qrCode) => (
              <QrCard key={qrCode.session_qr_id} qrCode={qrCode} />
            ))}
          </div>
        )}
      </div>

      <DataTable
        title="Personal autorizado / HC"
        description="Fuente de verdad del personal habilitado para la sesion."
        emptyMessage="La sesion no tiene participantes cargados en OPR/HC."
        columns={[
          { key: "full_name", label: "Participante" },
          { key: "document_type", label: "Tipo doc" },
          { key: "document_number", label: "Documento" },
          { key: "campaign_name", label: "Campana" },
          { key: "hc_code", label: "HC" },
          { key: "is_in_hc", label: "HC valido", render: (row) => (row.is_in_hc ? "SI" : "NO") },
        ]}
        rows={loadingDetails ? [] : expectedPeople}
      />

      <DataTable
        title="Participantes con asistencia tomada"
        description={selectedSession ? `Sesion ${selectedSession.virtual_session_id} - ${selectedSession.activity_name}` : ""}
        emptyMessage="Todavia no existen registros de asistencia para la sesion seleccionada."
        columns={[
          { key: "participant_name", label: "Participante" },
          { key: "captured_document_type", label: "Tipo doc" },
          { key: "document_number", label: "Documento" },
          { key: "qr_type", label: "QR" },
          { key: "validation_status", label: "Validacion" },
          { key: "wave_status", label: "Wave" },
          { key: "scanned_at", label: "Fecha registro", render: (row) => formatDateTime(row.scanned_at) },
        ]}
        rows={loadingDetails ? [] : records}
      />

      <DataTable
        title="Validacion de sala / Bot"
        description="Punto de integracion preparado para detectar asistentes no autorizados y registrar solicitudes de expulsion."
        emptyMessage="No hay participantes detectados en sala para la sesion seleccionada."
        columns={[
          { key: "display_name", label: "Display name" },
          { key: "email", label: "Correo" },
          { key: "participation_status", label: "Estado sala" },
          { key: "room_validation_status", label: "Validacion" },
          { key: "expected_person_name", label: "Match HC" },
          {
            key: "action",
            label: "Accion",
            render: (row) =>
              row.room_validation_status === "NO_AUTORIZADO" ? (
                <button
                  className="btn dan sm"
                  onClick={() => handleExpelParticipant(row)}
                  disabled={expellingParticipantId === row.teams_participant_id}
                >
                  {expellingParticipantId === row.teams_participant_id ? "Registrando..." : "Solicitar expulsion"}
                </button>
              ) : (
                "-"
              ),
          },
        ]}
        rows={loadingDetails ? [] : roomValidation}
      />
    </div>
  );
}
