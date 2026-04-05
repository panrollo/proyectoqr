import { useMemo, useState } from "react";

import { api } from "../../services/api";
import { EmptyState } from "./EmptyState";

function toInputValue(type, value) {
  if (value === null || value === undefined) return "";
  if (type === "date") return String(value).slice(0, 10);
  if (type === "datetime-local") return String(value).slice(0, 16);
  return String(value);
}

function fromInputValue(type, value) {
  if (value === "") return null;
  if (type === "number") return Number(value);
  return value;
}

function buildInitialState(fields, record = null) {
  return fields.reduce((acc, field) => {
    acc[field.name] = record ? toInputValue(field.type, record[field.source || field.name]) : "";
    return acc;
  }, {});
}

export function CrudSection({
  title,
  description,
  route,
  records,
  columns,
  fields,
  idKey,
  lookupData,
  refresh,
}) {
  const [form, setForm] = useState(buildInitialState(fields));
  const [editingId, setEditingId] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState("");

  const optionMaps = useMemo(() => lookupData || {}, [lookupData]);

  function handleChange(name, value) {
    setForm((current) => ({ ...current, [name]: value }));
  }

  function resetForm() {
    setForm(buildInitialState(fields));
    setEditingId(null);
    setError("");
  }

  async function handleSubmit(event) {
    event.preventDefault();
    setSubmitting(true);
    setError("");

    const payload = fields.reduce((acc, field) => {
      acc[field.name] = fromInputValue(field.type, form[field.name]);
      return acc;
    }, {});

    try {
      if (editingId) {
        await api.put(`${route}/${editingId}`, payload);
      } else {
        await api.post(route, payload);
      }
      await refresh();
      resetForm();
    } catch (requestError) {
      setError(requestError.message);
    } finally {
      setSubmitting(false);
    }
  }

  function startEdit(record) {
    setEditingId(record[idKey]);
    setForm(buildInitialState(fields, record));
  }

  async function removeRecord(recordId) {
    if (!window.confirm("¿Deseas ejecutar esta eliminación lógica?")) return;
    try {
      await api.delete(`${route}/${recordId}`);
      await refresh();
      if (editingId === recordId) {
        resetForm();
      }
    } catch (requestError) {
      setError(requestError.message);
    }
  }

  return (
    <div className="card">
      <div className="ch">
        <div className="ct">{title}</div>
      </div>
      {description ? <div className="psub" style={{ marginBottom: "12px" }}>{description}</div> : null}
      {error ? <div className="banner-error">{error}</div> : null}

      <form onSubmit={handleSubmit}>
        <div className="form-grid">
          {fields.map((field) => (
            <div className="fg" key={field.name}>
              <label className="fl">{field.label}</label>
              {field.type === "textarea" ? (
                <textarea className="fta" value={form[field.name] || ""} onChange={(event) => handleChange(field.name, event.target.value)} />
              ) : field.type === "select" ? (
                <select className="fs" value={form[field.name] || ""} onChange={(event) => handleChange(field.name, event.target.value)}>
                  <option value="">Selecciona una opción</option>
                  {(optionMaps[field.optionsKey] || []).map((option) => (
                    <option key={`${field.name}-${option.value}`} value={option.value}>
                      {option.label}
                    </option>
                  ))}
                </select>
              ) : (
                <input
                  className="fi"
                  type={field.type || "text"}
                  value={form[field.name] || ""}
                  onChange={(event) => handleChange(field.name, event.target.value)}
                />
              )}
            </div>
          ))}
        </div>
        <div className="table-actions">
          <button className="btn pri" type="submit" disabled={submitting}>
            {submitting ? "Guardando..." : editingId ? "Actualizar" : "Crear"}
          </button>
          <button className="btn" type="button" onClick={resetForm}>
            Limpiar
          </button>
        </div>
      </form>

      <div className="sep"></div>

      {!records.length ? (
        <EmptyState message="No hay registros disponibles todavía." />
      ) : (
        <div className="tw">
          <table>
            <thead>
              <tr>
                {columns.map((column) => (
                  <th key={column.key}>{column.label}</th>
                ))}
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              {records.map((record) => (
                <tr key={record[idKey]}>
                  {columns.map((column) => (
                    <td key={`${record[idKey]}-${column.key}`}>{column.render ? column.render(record) : (record[column.key] ?? "—")}</td>
                  ))}
                  <td>
                    <div className="table-actions">
                      <button className="btn sm" type="button" onClick={() => startEdit(record)}>Editar</button>
                      <button className="btn sm dan" type="button" onClick={() => removeRecord(record[idKey])}>Eliminar</button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
