import { useEffect, useState } from "react";

import { api } from "../../services/api";

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

function buildInitialForm(accessData) {
  return {
    fullName: "",
    documentNumber: "",
    campaignId: accessData?.form?.campaigns?.[0]?.campaign_id ? String(accessData.form.campaigns[0].campaign_id) : "",
  };
}

export function PublicQrAttendanceScreen({ logo, qrToken }) {
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");
  const [accessData, setAccessData] = useState(null);
  const [form, setForm] = useState({
    fullName: "",
    documentNumber: "",
    campaignId: "",
  });

  useEffect(() => {
    let active = true;

    async function loadQrAccess() {
      setLoading(true);
      setError("");

      try {
        const response = await api.get(`/public/attendance/${qrToken}`);
        if (!active) return;

        setAccessData(response);
        setForm(buildInitialForm(response));
      } catch (requestError) {
        if (!active) return;
        setError(requestError.message || "No fue posible validar el QR.");
      } finally {
        if (active) {
          setLoading(false);
        }
      }
    }

    loadQrAccess();
    return () => {
      active = false;
    };
  }, [qrToken]);

  function updateField(fieldName, value) {
    setForm((current) => ({
      ...current,
      [fieldName]: value,
    }));
  }

  async function handleSubmit(event) {
    event.preventDefault();

    if (!form.fullName.trim() || !form.documentNumber.trim() || !form.campaignId) {
      setError("Debes completar nombre completo, cedula y campana.");
      return;
    }

    setSubmitting(true);
    setError("");
    setSuccess("");

    try {
      const response = await api.post(`/public/attendance/${qrToken}/submit`, {
        full_name: form.fullName.trim(),
        document_number: form.documentNumber.trim(),
        campaign_id: Number(form.campaignId),
      });

      setSuccess(response.message || "Asistencia registrada correctamente.");
      setAccessData((current) =>
        current
          ? {
              ...current,
              is_form_enabled: false,
            }
          : current,
      );
    } catch (requestError) {
      setError(requestError.message || "No fue posible registrar la asistencia.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="public-screen">
      <div className="lstripe"></div>
      <div className="public-shell">
        <div className="public-card">
          <div className="llogo">{logo ? <img src={logo} alt="Logo" /> : null}</div>
          <div className="ldiv"></div>
          <div className="ltitle">Encuesta de asistencia por QR</div>
          <div className="lsub">Este formulario registra la asistencia o el retardo segun la ventana horaria configurada para la sesion.</div>

          {loading ? <div className="psub" style={{ marginBottom: 0 }}>Validando QR...</div> : null}
          {error ? <div className="banner-error">{error}</div> : null}
          {success ? <div className="al su"><div>{success}</div></div> : null}

          {accessData ? (
            <>
              <div className="card public-summary">
                <div className="ch">
                  <div className="ct">Sesion</div>
                </div>
                <div className="public-summary-grid">
                  <div>
                    <div className="fl">Actividad</div>
                    <div>{accessData.session.activity_name}</div>
                  </div>
                  <div>
                    <div className="fl">Grupo</div>
                    <div>{accessData.session.group_code} - {accessData.session.group_name}</div>
                  </div>
                  <div>
                    <div className="fl">Campana</div>
                    <div>{accessData.session.campaign_name}</div>
                  </div>
                  <div>
                    <div className="fl">Ventana</div>
                    <div>{accessData.qr.qr_type} · {formatDateTime(accessData.qr.active_from)} a {formatDateTime(accessData.qr.expires_at)}</div>
                  </div>
                </div>
                <div className={`b ${accessData.access_status === "VIGENTE" ? "gn" : accessData.access_status === "PENDIENTE" ? "am" : "rd"}`}>
                  {accessData.access_status}
                </div>
                <div className="small-note" style={{ marginTop: "10px" }}>{accessData.message}</div>
              </div>

              <form className="card" onSubmit={handleSubmit}>
                <div className="ch">
                  <div className="ct">Formulario de asistencia</div>
                </div>
                <div className="form-grid">
                  <div className="fg">
                    <label className="fl">Nombres completos</label>
                    <input
                      className="fi"
                      value={form.fullName}
                      onChange={(event) => updateField("fullName", event.target.value)}
                      disabled={!accessData.is_form_enabled || submitting}
                    />
                  </div>
                  <div className="fg">
                    <label className="fl">Cedula</label>
                    <input
                      className="fi"
                      value={form.documentNumber}
                      onChange={(event) => updateField("documentNumber", event.target.value.replace(/\D/g, ""))}
                      inputMode="numeric"
                      pattern="[0-9]{6,12}"
                      disabled={!accessData.is_form_enabled || submitting}
                    />
                  </div>
                </div>
                <div className="form-grid">
                  <div className="fg">
                    <label className="fl">Campana</label>
                    <select
                      className="fs"
                      value={form.campaignId}
                      onChange={(event) => updateField("campaignId", event.target.value)}
                      disabled={!accessData.is_form_enabled || submitting}
                    >
                      {accessData.form.campaigns.map((item) => (
                        <option key={item.campaign_id} value={item.campaign_id}>
                          {item.campaign_name}
                        </option>
                      ))}
                    </select>
                  </div>
                </div>
                <div className="table-actions">
                  <button className="btn pri" type="submit" disabled={!accessData.is_form_enabled || submitting}>
                    {submitting ? "Registrando..." : "Enviar encuesta de asistencia"}
                  </button>
                </div>
              </form>
            </>
          ) : null}
        </div>
      </div>
    </div>
  );
}
