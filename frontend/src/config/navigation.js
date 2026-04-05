export const navigationByRole = {
  agente: [
    {
      section: "Mi formacion",
      items: [
        { label: "Inicio", panelId: "agente-inicio", icon: "I" },
        { label: "Formacion inicial", panelId: "agente-inicial", icon: "FI" },
        { label: "Mi OJT", panelId: "agente-ojt", icon: "OJ" },
        { label: "Formaciones continuas", panelId: "agente-continua", icon: "FC" },
        { label: "Preturnos", panelId: "agente-preturnos", icon: "PT" },
      ],
    },
    {
      section: "Mis resultados",
      items: [
        { label: "Mis compromisos", panelId: "agente-compromisos", icon: "MC" },
        { label: "Mis calificaciones", panelId: "agente-calificaciones", icon: "CA" },
        { label: "Retroalimentaciones", panelId: "agente-retroalimentaciones", icon: "RE" },
      ],
    },
  ],
  formador: [
    {
      section: "Mis grupos",
      items: [
        { label: "Inicio", panelId: "formador-inicio", icon: "I" },
        { label: "Formacion inicial", panelId: "formador-inicial", icon: "FI" },
        { label: "OJT activo", panelId: "formador-ojt", icon: "OJ" },
        { label: "Formacion continua", panelId: "formador-continua", icon: "FC" },
        { label: "Preturnos", panelId: "formador-preturnos", icon: "PT" },
        { label: "Modulo de asistencia", panelId: "formador-asistencia", icon: "AS" },
      ],
    },
    {
      section: "Herramientas",
      items: [
        { label: "Evaluaciones y encuestas", panelId: "formador-evaluaciones", icon: "EV" },
        { label: "Agenda", panelId: "formador-agenda", icon: "AG" },
        { label: "Biblioteca de actividades", panelId: "formador-biblioteca", icon: "BI" },
        { label: "Mi grupo-tablero", panelId: "formador-tablero", icon: "TB" },
      ],
    },
  ],
  analista: [
    {
      section: "Calidad",
      items: [
        { label: "Inicio", panelId: "analista-inicio", icon: "I" },
        { label: "OJT - Monitoreos", panelId: "analista-ojt", icon: "OJ" },
        { label: "Aplicabilidad K3", panelId: "analista-k3", icon: "K3" },
        { label: "Formaciones - vista", panelId: "analista-formaciones", icon: "FV" },
      ],
    },
    {
      section: "Reportes",
      items: [
        { label: "Tablero de resultados", panelId: "analista-tablero", icon: "TB" },
        { label: "Mis actividades", panelId: "analista-actividades", icon: "AC" },
      ],
    },
  ],
  supervisor: [
    {
      section: "Mi equipo",
      items: [
        { label: "Inicio", panelId: "supervisor-inicio", icon: "I" },
        { label: "Mi equipo OJT", panelId: "supervisor-ojt", icon: "OJ" },
        { label: "Formaciones programadas", panelId: "supervisor-formaciones", icon: "FP" },
      ],
    },
    {
      section: "Gestion",
      items: [
        { label: "Mis retroalimentaciones", panelId: "supervisor-retros", icon: "RE" },
        { label: "Compromisos de agentes", panelId: "supervisor-compromisos", icon: "MC" },
        { label: "Tablero de resultados", panelId: "supervisor-tablero", icon: "TB" },
      ],
    },
  ],
  lider: [
    {
      section: "Gestion de formacion",
      items: [
        { label: "Inicio", panelId: "lider-inicio", icon: "I" },
        { label: "Grupos activos", panelId: "lider-grupos", icon: "GR" },
        { label: "Formacion inicial", panelId: "lider-inicial", icon: "FI" },
        { label: "OJT", panelId: "lider-ojt", icon: "OJ" },
        { label: "Formacion continua", panelId: "lider-continua", icon: "FC" },
        { label: "Preturnos", panelId: "lider-preturnos", icon: "PT" },
      ],
    },
    {
      section: "Control y seguimiento",
      items: [
        { label: "Retiros", panelId: "lider-retiros", icon: "RT" },
        { label: "Planificador mensual", panelId: "lider-planificador", icon: "PL" },
        { label: "Dashboard KPIs del area", panelId: "lider-dashboard", icon: "KP" },
        { label: "SLAs del area", panelId: "lider-slas", icon: "SL" },
      ],
    },
  ],
  jefe_fc: [
    {
      section: "Vision global",
      items: [
        { label: "Inicio", panelId: "jefe_fc-inicio", icon: "I" },
        { label: "Consolidado cuentas", panelId: "jefe_fc-consolidado", icon: "CO" },
        { label: "Alertas escaladas", panelId: "jefe_fc-alertas", icon: "AL" },
      ],
    },
    {
      section: "Permisos exclusivos",
      items: [
        { label: "Acciones auditables", panelId: "jefe_fc-auditables", icon: "AU" },
        { label: "Log de auditoria", panelId: "jefe_fc-log", icon: "LG" },
        { label: "Reportes transversales", panelId: "jefe_fc-reportes", icon: "RP" },
      ],
    },
    {
      section: "Lider heredado",
      items: [
        { label: "Grupos y OJT", panelId: "jefe_fc-grupos", icon: "GR" },
        { label: "Formacion continua", panelId: "jefe_fc-continua", icon: "FC" },
        { label: "Retiros", panelId: "jefe_fc-retiros", icon: "RT" },
        { label: "Dashboard KPIs", panelId: "jefe_fc-dashboard", icon: "KP" },
      ],
    },
  ],
  jefe_ops: [
    {
      section: "Mi cuenta",
      items: [
        { label: "Inicio", panelId: "jefe_ops-inicio", icon: "I" },
        { label: "Tablero formacion inicial", panelId: "jefe_ops-inicial", icon: "FI" },
        { label: "Tablero OJT", panelId: "jefe_ops-ojt", icon: "OJ" },
        { label: "Tablero formacion continua", panelId: "jefe_ops-continua", icon: "FC" },
      ],
    },
    {
      section: "Acciones",
      items: [
        { label: "Actas por firmar", panelId: "jefe_ops-actas", icon: "AC" },
        { label: "Asignar supervisores", panelId: "jefe_ops-supervisores", icon: "SU" },
        { label: "Informe gerencial", panelId: "jefe_ops-informe", icon: "IG" },
      ],
    },
  ],
  admin: [
    {
      section: "Plataforma",
      items: [
        { label: "Inicio", panelId: "admin-inicio", icon: "I" },
        { label: "Gestion de cuentas", panelId: "admin-cuentas", icon: "GC" },
        { label: "Usuarios y perfiles", panelId: "admin-usuarios", icon: "US" },
        { label: "Implementaciones", panelId: "admin-impl", icon: "IM" },
        { label: "Desimplementaciones", panelId: "admin-desimpl", icon: "DE" },
      ],
    },
    {
      section: "Seguridad y control",
      items: [
        { label: "Log de auditoria", panelId: "admin-log", icon: "LG" },
        { label: "Permisos por rol", panelId: "admin-permisos", icon: "PR" },
        { label: "Repositorio archivo", panelId: "admin-repo", icon: "RA" },
        { label: "Configuracion general", panelId: "admin-config", icon: "CG" },
      ],
    },
  ],
};
