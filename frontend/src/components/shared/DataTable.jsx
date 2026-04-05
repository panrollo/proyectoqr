import { EmptyState } from "./EmptyState";

export function DataTable({ title, description, columns, rows, emptyMessage }) {
  return (
    <div className="card">
      <div className="ch">
        <div className="ct">{title}</div>
      </div>
      {description ? <div className="psub" style={{ marginBottom: "12px" }}>{description}</div> : null}
      {!rows.length ? (
        <EmptyState message={emptyMessage || "No hay información disponible en la base de datos."} />
      ) : (
        <div className="tw">
          <table>
            <thead>
              <tr>
                {columns.map((column) => (
                  <th key={column.key}>{column.label}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {rows.map((row, index) => (
                <tr key={row.id || index}>
                  {columns.map((column) => (
                    <td key={`${row.id || index}-${column.key}`}>{column.render ? column.render(row) : (row[column.key] ?? "—")}</td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
