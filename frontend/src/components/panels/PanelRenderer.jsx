import { CrudSection } from "../shared/CrudSection";
import { DataTable } from "../shared/DataTable";
import { EmptyState } from "../shared/EmptyState";
import { MetricsGrid } from "../shared/MetricsGrid";
import { TrainerAttendancePanel } from "./TrainerAttendancePanel";

function buildOptions(data, valueKey, labelKey) {
  return (data || []).map((item) => ({ value: item[valueKey], label: item[labelKey] }));
}

function countByStatus(items, activeValues) {
  return items.filter((item) => activeValues.includes(item.status)).length;
}

function firstRows(items, limit = 10) {
  return (items || []).slice(0, limit);
}

function PanelShell({ meta, children }) {
  return (
    <div className="panel-scroll">
      <div>
        <div className="ptitle">{meta?.title || "Panel"}</div>
        <div className="psub">{meta?.subtitle || "Información integrada desde la base de datos"}</div>
      </div>
      {children}
    </div>
  );
}

function GlobalMetrics({ bootstrap }) {
  return (
    <MetricsGrid
      items={[
        { label: "Campanas", value: bootstrap.campaigns.length, helper: "Registros reales en BD", color: "#1A5FBF" },
        { label: "Usuarios", value: bootstrap.users.length, helper: "Usuarios activos e inactivos", color: "#0D7A5F" },
        { label: "Grupos", value: bootstrap.groups.length, helper: "OPR registrados", color: "#C07A10" },
        { label: "Actividades", value: bootstrap.activities.length, helper: "Actividades configuradas", color: "#C0272D" },
      ]}
    />
  );
}

function UserCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <GlobalMetrics bootstrap={bootstrap} />
      <CrudSection
        title="Usuarios"
        description="Lectura por view y escritura por stored procedures"
        route="/users"
        records={bootstrap.users}
        idKey="user_id"
        refresh={refresh}
        lookupData={{ roles: buildOptions(bootstrap.roles, "role_id", "role_key") }}
        columns={[
          { key: "full_name", label: "Nombre" },
          { key: "email", label: "Correo" },
          { key: "role_key", label: "Rol" },
          { key: "status", label: "Estado" },
        ]}
        fields={[
          { name: "full_name", label: "Nombre completo", type: "text" },
          { name: "email", label: "Correo", type: "text" },
          { name: "role_id", label: "Rol", type: "select", optionsKey: "roles", source: "role_id" },
          { name: "password", label: "Clave", type: "password" },
          { name: "status", label: "Estado", type: "number" },
        ]}
      />
    </PanelShell>
  );
}

function CampaignCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <GlobalMetrics bootstrap={bootstrap} />
      <CrudSection
        title="Campanas"
        description="Cuentas/campañas integradas con MySQL"
        route="/campaigns"
        records={bootstrap.campaigns}
        idKey="campaign_id"
        refresh={refresh}
        columns={[
          { key: "name", label: "Nombre" },
          { key: "cost_center", label: "CECO" },
          { key: "status", label: "Estado" },
          { key: "groups_total", label: "Grupos" },
        ]}
        fields={[
          { name: "name", label: "Nombre", type: "text" },
          { name: "cost_center", label: "CECO", type: "text" },
          { name: "description", label: "Descripcion", type: "textarea" },
          { name: "status", label: "Estado", type: "number" },
        ]}
      />
    </PanelShell>
  );
}

function ActivityCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <MetricsGrid
        items={[
          { label: "Actividades", value: bootstrap.activities.length, helper: "Catalogo real", color: "#1A5FBF" },
          { label: "Tipos", value: bootstrap.activityTypes.length, helper: "Tipos de actividad", color: "#0D7A5F" },
          { label: "Publicos", value: bootstrap.targetAudiences.length, helper: "Publicos objetivo", color: "#C07A10" },
        ]}
      />
      <CrudSection
        title="Actividades"
        description="Actividades formativas"
        route="/activities"
        records={bootstrap.activities}
        idKey="activity_id"
        refresh={refresh}
        lookupData={{
          activityTypes: buildOptions(bootstrap.activityTypes, "activity_type_id", "name"),
          targetAudiences: buildOptions(bootstrap.targetAudiences, "target_audience_id", "name"),
        }}
        columns={[
          { key: "name", label: "Actividad" },
          { key: "activity_type_name", label: "Tipo" },
          { key: "target_audience_name", label: "Publico" },
          { key: "status", label: "Estado" },
        ]}
        fields={[
          { name: "name", label: "Nombre", type: "text" },
          { name: "description", label: "Descripcion", type: "textarea" },
          { name: "activity_type_id", label: "Tipo actividad", type: "select", optionsKey: "activityTypes", source: "activity_type_id" },
          { name: "target_audience_id", label: "Publico objetivo", type: "select", optionsKey: "targetAudiences", source: "target_audience_id" },
          { name: "duration_hours", label: "Duracion horas", type: "number" },
          { name: "status", label: "Estado", type: "number" },
        ]}
      />
    </PanelShell>
  );
}

function GroupManagementPanel({ meta, bootstrap, refresh }) {
  const lookupData = {
    campaigns: buildOptions(bootstrap.campaigns, "campaign_id", "name"),
    users: buildOptions(bootstrap.users, "user_id", "full_name"),
    people: buildOptions(bootstrap.people, "person_id", "full_name"),
  };

  return (
    <PanelShell meta={meta}>
      <MetricsGrid
        items={[
          { label: "Grupos", value: bootstrap.groups.length, helper: "OPR registrados", color: "#1A5FBF" },
          { label: "Personas", value: bootstrap.people.length, helper: "Participantes", color: "#0D7A5F" },
          { label: "Asignaciones", value: bootstrap.groupParticipants.length, helper: "Participantes por grupo", color: "#C07A10" },
          { label: "Formadores", value: bootstrap.groupTrainers.length, helper: "Formadores asignados", color: "#C0272D" },
        ]}
      />
      <CrudSection
        title="Grupos"
        description="Gestion de grupos OPR"
        route="/groups"
        records={bootstrap.groups}
        idKey="group_id"
        refresh={refresh}
        lookupData={lookupData}
        columns={[
          { key: "group_code", label: "Codigo" },
          { key: "name", label: "Nombre" },
          { key: "campaign_name", label: "Campana" },
          { key: "status", label: "Estado" },
        ]}
        fields={[
          { name: "group_code", label: "Codigo OPR", type: "text" },
          { name: "name", label: "Nombre", type: "text" },
          { name: "campaign_id", label: "Campana", type: "select", optionsKey: "campaigns", source: "campaign_id" },
          { name: "start_date", label: "Fecha inicio", type: "date" },
          { name: "end_date", label: "Fecha fin", type: "date" },
          { name: "status", label: "Estado", type: "text" },
        ]}
      />
      <CrudSection
        title="Personas"
        description="Participantes operativos"
        route="/people"
        records={bootstrap.people}
        idKey="person_id"
        refresh={refresh}
        lookupData={lookupData}
        columns={[
          { key: "document_number", label: "Documento" },
          { key: "full_name", label: "Nombre" },
          { key: "campaign_name", label: "Campana" },
          { key: "status", label: "Estado" },
        ]}
        fields={[
          { name: "document_type", label: "Tipo documento", type: "text" },
          { name: "document_number", label: "Numero", type: "text" },
          { name: "first_name", label: "Nombres", type: "text" },
          { name: "last_name", label: "Apellidos", type: "text" },
          { name: "email", label: "Correo", type: "text" },
          { name: "phone", label: "Telefono", type: "text" },
          { name: "hire_date", label: "Fecha ingreso", type: "date" },
          { name: "campaign_id", label: "Campana", type: "select", optionsKey: "campaigns", source: "campaign_id" },
          { name: "hc_id", label: "HC", type: "number" },
          { name: "status", label: "Estado", type: "text" },
        ]}
      />
      <CrudSection
        title="Participantes por grupo"
        description="Asignacion grupo-participante"
        route="/group-participants"
        records={bootstrap.groupParticipants}
        idKey="group_participant_id"
        refresh={refresh}
        lookupData={{ ...lookupData, groups: buildOptions(bootstrap.groups, "group_id", "name") }}
        columns={[
          { key: "group_name", label: "Grupo" },
          { key: "person_name", label: "Participante" },
          { key: "status", label: "Estado" },
        ]}
        fields={[
          { name: "group_id", label: "Grupo", type: "select", optionsKey: "groups", source: "group_id" },
          { name: "person_id", label: "Participante", type: "select", optionsKey: "people", source: "person_id" },
          { name: "assigned_at", label: "Fecha asignacion", type: "datetime-local" },
          { name: "status", label: "Estado", type: "text" },
        ]}
      />
      <CrudSection
        title="Formadores asignados"
        description="Asignacion de formadores o responsables"
        route="/group-trainers"
        records={bootstrap.groupTrainers}
        idKey="group_trainer_id"
        refresh={refresh}
        lookupData={{ ...lookupData, groups: buildOptions(bootstrap.groups, "group_id", "name") }}
        columns={[
          { key: "group_name", label: "Grupo" },
          { key: "user_name", label: "Usuario" },
          { key: "trainer_role", label: "Rol" },
        ]}
        fields={[
          { name: "group_id", label: "Grupo", type: "select", optionsKey: "groups", source: "group_id" },
          { name: "user_id", label: "Usuario", type: "select", optionsKey: "users", source: "user_id" },
          { name: "assigned_at", label: "Fecha asignacion", type: "datetime-local" },
          { name: "trainer_role", label: "Rol en grupo", type: "text" },
        ]}
      />
    </PanelShell>
  );
}

function PlannerCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <MetricsGrid
        items={[
          { label: "MAN", value: bootstrap.mans.length, helper: "Analisis registrados", color: "#1A5FBF" },
          { label: "Planificador", value: bootstrap.planners.length, helper: "Planificadores", color: "#0D7A5F" },
          { label: "Sesiones", value: bootstrap.virtualSessions.length, helper: "Sesiones virtuales", color: "#C07A10" },
        ]}
      />
      <CrudSection
        title="Planificador"
        description="Programacion real de sesiones"
        route="/planners"
        records={bootstrap.planners}
        idKey="planner_id"
        refresh={refresh}
        lookupData={{
          mans: buildOptions(bootstrap.mans, "man_id", "man_code"),
          activities: buildOptions(bootstrap.activities, "activity_id", "name"),
          campaigns: buildOptions(bootstrap.campaigns, "campaign_id", "name"),
          groups: buildOptions(bootstrap.groups, "group_id", "name"),
          users: buildOptions(bootstrap.users, "user_id", "full_name"),
        }}
        columns={[
          { key: "man_code", label: "MAN" },
          { key: "activity_name", label: "Actividad" },
          { key: "group_name", label: "Grupo" },
          { key: "start_at", label: "Inicio" },
        ]}
        fields={[
          { name: "man_id", label: "MAN", type: "select", optionsKey: "mans", source: "man_id" },
          { name: "activity_id", label: "Actividad", type: "select", optionsKey: "activities", source: "activity_id" },
          { name: "campaign_id", label: "Campana", type: "select", optionsKey: "campaigns", source: "campaign_id" },
          { name: "group_id", label: "Grupo", type: "select", optionsKey: "groups", source: "group_id" },
          { name: "start_at", label: "Inicio", type: "datetime-local" },
          { name: "end_at", label: "Fin", type: "datetime-local" },
          { name: "methodology", label: "Metodologia", type: "text" },
          { name: "room", label: "Sala", type: "text" },
          { name: "capacity", label: "Cupo", type: "number" },
          { name: "status", label: "Estado", type: "text" },
          { name: "created_by", label: "Creado por", type: "select", optionsKey: "users", source: "created_by" },
        ]}
      />
      <DataTable
        title="Sesiones virtuales"
        description="Sesiones virtuales ligadas a planificadores"
        columns={[
          { key: "group_name", label: "Grupo" },
          { key: "activity_name", label: "Actividad" },
          { key: "session_status", label: "Estado sesion" },
          { key: "qr_expires_at", label: "Expira QR" },
        ]}
        rows={firstRows(bootstrap.virtualSessions)}
      />
    </PanelShell>
  );
}

function AgendaCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <CrudSection
        title="Agenda"
        description="Agenda operativa y sesiones"
        route="/agenda-events"
        records={bootstrap.agendaEvents}
        idKey="agenda_event_id"
        refresh={refresh}
        lookupData={{
          planners: buildOptions(bootstrap.planners, "planner_id", "activity_name"),
          groups: buildOptions(bootstrap.groups, "group_id", "name"),
          users: buildOptions(bootstrap.users, "user_id", "full_name"),
        }}
        columns={[
          { key: "title", label: "Titulo" },
          { key: "group_name", label: "Grupo" },
          { key: "responsible_name", label: "Responsable" },
          { key: "start_at", label: "Inicio" },
        ]}
        fields={[
          { name: "planner_id", label: "Planificador", type: "select", optionsKey: "planners", source: "planner_id" },
          { name: "group_id", label: "Grupo", type: "select", optionsKey: "groups", source: "group_id" },
          { name: "responsible_user_id", label: "Responsable", type: "select", optionsKey: "users", source: "responsible_user_id" },
          { name: "title", label: "Titulo", type: "text" },
          { name: "description", label: "Descripcion", type: "textarea" },
          { name: "start_at", label: "Inicio", type: "datetime-local" },
          { name: "end_at", label: "Fin", type: "datetime-local" },
          { name: "modality", label: "Modalidad", type: "text" },
          { name: "status", label: "Estado", type: "text" },
        ]}
      />
    </PanelShell>
  );
}

function LibraryCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <CrudSection
        title="Biblioteca de actividades"
        description="Biblioteca de actividades reutilizables"
        route="/library-resources"
        records={bootstrap.libraryResources}
        idKey="library_resource_id"
        refresh={refresh}
        lookupData={{
          activities: buildOptions(bootstrap.activities, "activity_id", "name"),
          users: buildOptions(bootstrap.users, "user_id", "full_name"),
        }}
        columns={[
          { key: "title", label: "Titulo" },
          { key: "category", label: "Categoria" },
          { key: "activity_name", label: "Actividad" },
          { key: "created_by_name", label: "Creado por" },
        ]}
        fields={[
          { name: "activity_id", label: "Actividad", type: "select", optionsKey: "activities", source: "activity_id" },
          { name: "created_by", label: "Creado por", type: "select", optionsKey: "users", source: "created_by" },
          { name: "category", label: "Categoria", type: "text" },
          { name: "title", label: "Titulo", type: "text" },
          { name: "description", label: "Descripcion", type: "textarea" },
          { name: "resource_url", label: "URL recurso", type: "text" },
          { name: "status", label: "Estado", type: "text" },
        ]}
      />
    </PanelShell>
  );
}

function FeedbackCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <CrudSection
        title="Retroalimentaciones"
        description="Retroalimentaciones registradas"
        route="/feedback-records"
        records={bootstrap.feedbackRecords}
        idKey="feedback_id"
        refresh={refresh}
        lookupData={{
          people: buildOptions(bootstrap.people, "person_id", "full_name"),
          users: buildOptions(bootstrap.users, "user_id", "full_name"),
        }}
        columns={[
          { key: "person_name", label: "Participante" },
          { key: "created_by_name", label: "Creado por" },
          { key: "source", label: "Origen" },
          { key: "title", label: "Titulo" },
        ]}
        fields={[
          { name: "person_id", label: "Participante", type: "select", optionsKey: "people", source: "person_id" },
          { name: "created_by", label: "Creado por", type: "select", optionsKey: "users", source: "created_by" },
          { name: "source", label: "Origen", type: "text" },
          { name: "title", label: "Titulo", type: "text" },
          { name: "strengths", label: "Fortalezas", type: "textarea" },
          { name: "opportunities", label: "Oportunidades", type: "textarea" },
          { name: "action_plan", label: "Plan accion", type: "textarea" },
          { name: "status", label: "Estado", type: "text" },
        ]}
      />
    </PanelShell>
  );
}

function CommitmentCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <CrudSection
        title="Compromisos"
        description="Compromisos ligados a retroalimentaciones"
        route="/commitments"
        records={bootstrap.commitments}
        idKey="commitment_id"
        refresh={refresh}
        lookupData={{
          feedback: buildOptions(bootstrap.feedbackRecords, "feedback_id", "title"),
          people: buildOptions(bootstrap.people, "person_id", "full_name"),
          users: buildOptions(bootstrap.users, "user_id", "full_name"),
        }}
        columns={[
          { key: "feedback_title", label: "Retroalimentacion" },
          { key: "person_name", label: "Participante" },
          { key: "responsible_name", label: "Responsable" },
          { key: "status", label: "Estado" },
        ]}
        fields={[
          { name: "feedback_id", label: "Retroalimentacion", type: "select", optionsKey: "feedback", source: "feedback_id" },
          { name: "person_id", label: "Participante", type: "select", optionsKey: "people", source: "person_id" },
          { name: "responsible_user_id", label: "Responsable", type: "select", optionsKey: "users", source: "responsible_user_id" },
          { name: "description", label: "Descripcion", type: "textarea" },
          { name: "commitment_date", label: "Fecha compromiso", type: "date" },
          { name: "due_date", label: "Fecha vencimiento", type: "date" },
          { name: "status", label: "Estado", type: "text" },
        ]}
      />
    </PanelShell>
  );
}

function QualityCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <CrudSection
        title="Monitoreos de calidad"
        description="Monitoreos de calidad"
        route="/quality-monitors"
        records={bootstrap.qualityMonitors}
        idKey="quality_monitor_id"
        refresh={refresh}
        lookupData={{
          people: buildOptions(bootstrap.people, "person_id", "full_name"),
          users: buildOptions(bootstrap.users, "user_id", "full_name"),
        }}
        columns={[
          { key: "person_name", label: "Participante" },
          { key: "analyst_name", label: "Analista" },
          { key: "criteria", label: "Criterio" },
          { key: "score", label: "Puntaje" },
        ]}
        fields={[
          { name: "person_id", label: "Participante", type: "select", optionsKey: "people", source: "person_id" },
          { name: "analyst_user_id", label: "Analista", type: "select", optionsKey: "users", source: "analyst_user_id" },
          { name: "call_id", label: "Call ID", type: "text" },
          { name: "criteria", label: "Criterio", type: "text" },
          { name: "score", label: "Puntaje", type: "number" },
          { name: "finding", label: "Hallazgo", type: "textarea" },
          { name: "recommendation", label: "Recomendacion", type: "textarea" },
          { name: "status", label: "Estado", type: "text" },
        ]}
      />
    </PanelShell>
  );
}

function OjtCrudPanel({ meta, bootstrap, refresh }) {
  return (
    <PanelShell meta={meta}>
      <CrudSection
        title="Seguimiento OJT"
        description="Seguimiento de desempeno OJT"
        route="/ojt-followups"
        records={bootstrap.ojtFollowups}
        idKey="ojt_followup_id"
        refresh={refresh}
        lookupData={{
          people: buildOptions(bootstrap.people, "person_id", "full_name"),
          groups: buildOptions(bootstrap.groups, "group_id", "name"),
        }}
        columns={[
          { key: "person_name", label: "Participante" },
          { key: "group_name", label: "Grupo" },
          { key: "day_number", label: "Dia" },
          { key: "quality_score", label: "Calidad" },
          { key: "csat_score", label: "CSAT" },
        ]}
        fields={[
          { name: "person_id", label: "Participante", type: "select", optionsKey: "people", source: "person_id" },
          { name: "group_id", label: "Grupo", type: "select", optionsKey: "groups", source: "group_id" },
          { name: "day_number", label: "Dia", type: "number" },
          { name: "aht", label: "AHT", type: "text" },
          { name: "quality_score", label: "Calidad", type: "number" },
          { name: "csat_score", label: "CSAT", type: "number" },
          { name: "status", label: "Estado", type: "text" },
          { name: "notes", label: "Observacion", type: "textarea" },
        ]}
      />
    </PanelShell>
  );
}

function SummaryPanel({ meta, bootstrap, datasets, message }) {
  const tables = datasets.map((dataset) => {
    const rows = bootstrap[dataset.key] || [];
    return (
      <DataTable
        key={dataset.key}
        title={dataset.title}
        description={dataset.description}
        columns={dataset.columns}
        rows={firstRows(rows, dataset.limit || 8)}
      />
    );
  });

  return (
    <PanelShell meta={meta}>
      <GlobalMetrics bootstrap={bootstrap} />
      {message ? <EmptyState message={message} /> : null}
      {tables}
    </PanelShell>
  );
}

export function PanelRenderer({ panelId, meta, bootstrap, currentUser, refresh }) {
  if (panelId === "admin-usuarios") return <UserCrudPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  if (panelId === "admin-cuentas") return <CampaignCrudPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  if (panelId === "formador-asistencia") return <TrainerAttendancePanel meta={meta} currentUser={currentUser} />;
  if (["formador-tablero", "lider-grupos", "jefe_fc-grupos", "jefe_ops-supervisores"].includes(panelId)) {
    return <GroupManagementPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  }
  if (["lider-planificador", "formador-continua", "analista-formaciones", "jefe_fc-continua", "jefe_ops-continua"].includes(panelId)) {
    return <PlannerCrudPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  }
  if (panelId === "formador-agenda") return <AgendaCrudPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  if (panelId === "formador-biblioteca") return <LibraryCrudPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  if (["supervisor-retros", "agente-retroalimentaciones"].includes(panelId)) return <FeedbackCrudPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  if (["supervisor-compromisos", "agente-compromisos"].includes(panelId)) return <CommitmentCrudPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  if (panelId === "analista-ojt") return <QualityCrudPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  if (["formador-ojt", "supervisor-ojt", "lider-ojt", "jefe_ops-ojt"].includes(panelId)) return <OjtCrudPanel meta={meta} bootstrap={bootstrap} refresh={refresh} />;
  if (panelId === "admin-inicio") {
    return (
      <SummaryPanel
        meta={meta}
        bootstrap={bootstrap}
        datasets={[
          { key: "campaigns", title: "Campanas", columns: [{ key: "name", label: "Nombre" }, { key: "cost_center", label: "CECO" }, { key: "status", label: "Estado" }] },
          { key: "users", title: "Usuarios", columns: [{ key: "full_name", label: "Nombre" }, { key: "role_key", label: "Rol" }, { key: "status", label: "Estado" }] },
        ]}
      />
    );
  }
  if (panelId === "admin-impl") {
    return (
      <SummaryPanel
        meta={meta}
        bootstrap={bootstrap}
        datasets={[
          { key: "campaigns", title: "Campanas activas", columns: [{ key: "name", label: "Cuenta" }, { key: "groups_total", label: "Grupos" }, { key: "people_total", label: "Personas" }] },
          { key: "groups", title: "Grupos", columns: [{ key: "name", label: "Grupo" }, { key: "campaign_name", label: "Campana" }, { key: "status", label: "Estado" }] },
        ]}
      />
    );
  }
  if (panelId === "admin-desimpl" || panelId === "admin-repo") {
    return (
      <SummaryPanel
        meta={meta}
        bootstrap={bootstrap}
        datasets={[
          { key: "campaigns", title: "Campanas archivadas", columns: [{ key: "name", label: "Cuenta" }, { key: "status", label: "Estado" }, { key: "groups_total", label: "Grupos" }] },
        ]}
        message="La base actual no tiene un repositorio historico especifico; se muestran campañas registradas."
      />
    );
  }
  if (panelId === "admin-permisos") {
    return (
      <SummaryPanel
        meta={meta}
        bootstrap={bootstrap}
        datasets={[
          { key: "roles", title: "Roles", columns: [{ key: "role_key", label: "Rol" }, { key: "status", label: "Estado" }] },
          { key: "users", title: "Usuarios por rol", columns: [{ key: "full_name", label: "Usuario" }, { key: "role_key", label: "Rol" }] },
        ]}
        message="La base no incluye una matriz consolidada de permisos por rol; se expone el catalogo real de roles y usuarios."
      />
    );
  }
  if (panelId === "admin-log" || panelId === "jefe_fc-log" || panelId === "jefe_fc-auditables") {
    return (
      <PanelShell meta={meta}>
        <EmptyState message="La base actual no contiene una tabla o view de auditoria. Para este panel seria necesario incorporar una bitacora persistente." />
      </PanelShell>
    );
  }
  if (panelId === "analista-k3" || panelId === "agente-calificaciones") {
    return (
      <SummaryPanel
        meta={meta}
        bootstrap={bootstrap}
        datasets={[
          {
            key: "operationResults",
            title: "Resultados de operacion",
            columns: [
              { key: "person_name", label: "Participante" },
              { key: "module_name", label: "Modulo" },
              { key: "indicator_name", label: "Indicador" },
              { key: "final_value", label: "Valor final" },
            ],
          },
        ]}
        message="Los resultados operativos se muestran si existen registros cargados en la base."
      />
    );
  }
  if (panelId.endsWith("-preturnos")) {
    return (
      <SummaryPanel
        meta={meta}
        bootstrap={bootstrap}
        datasets={[
          {
            key: "preShifts",
            title: "Preturnos",
            columns: [
              { key: "scheduled_date", label: "Fecha" },
              { key: "group_name", label: "Grupo" },
              { key: "topic", label: "Tema" },
              { key: "average_score", label: "Promedio" },
            ],
          },
        ]}
      />
    );
  }
  if (panelId.endsWith("-inicio") || panelId.endsWith("-dashboard") || panelId.endsWith("-tablero") || panelId.endsWith("-informe") || panelId.endsWith("-consolidado")) {
    return (
      <SummaryPanel
        meta={meta}
        bootstrap={bootstrap}
        datasets={[
          { key: "groups", title: "Resumen de grupos", columns: [{ key: "name", label: "Grupo" }, { key: "campaign_name", label: "Campana" }, { key: "participants_total", label: "Participantes" }] },
          { key: "planners", title: "Resumen de planificacion", columns: [{ key: "activity_name", label: "Actividad" }, { key: "group_name", label: "Grupo" }, { key: "start_at", label: "Inicio" }] },
        ]}
      />
    );
  }
  if (panelId.endsWith("-inicial")) {
    return (
      <SummaryPanel
        meta={meta}
        bootstrap={bootstrap}
        datasets={[
          { key: "planners", title: "Planificacion de formacion inicial", columns: [{ key: "activity_name", label: "Actividad" }, { key: "group_name", label: "Grupo" }, { key: "start_at", label: "Inicio" }] },
          { key: "virtualSessions", title: "Sesiones virtuales", columns: [{ key: "group_name", label: "Grupo" }, { key: "activity_name", label: "Actividad" }, { key: "session_status", label: "Estado" }] },
        ]}
      />
    );
  }
  if (panelId === "jefe_fc-alertas" || panelId === "lider-retiros" || panelId === "jefe_fc-retiros" || panelId === "jefe_fc-reportes" || panelId === "jefe_ops-actas" || panelId === "lider-slas") {
    return (
      <PanelShell meta={meta}>
        <EmptyState message="La base actual no tiene una fuente específica para este panel. Se requiere una tabla o view adicional para exponer alertas, retiros, actas o SLAs." />
        <DataTable
          title="Datos operativos actuales"
          columns={[
            { key: "name", label: "Grupo" },
            { key: "campaign_name", label: "Campana" },
            { key: "status", label: "Estado" },
          ]}
          rows={firstRows(bootstrap.groups)}
        />
      </PanelShell>
    );
  }

  return (
    <PanelShell meta={meta}>
      <EmptyState message={`El panel ${panelId} no tiene todavia una fuente funcional específica en la base actual.`} />
      <DataTable
        title="Datos disponibles en la base"
        columns={[
          { key: "name", label: "Grupo" },
          { key: "campaign_name", label: "Campana" },
          { key: "status", label: "Estado" },
        ]}
        rows={firstRows(bootstrap.groups)}
      />
    </PanelShell>
  );
}
