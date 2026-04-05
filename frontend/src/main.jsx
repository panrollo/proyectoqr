import React, { useEffect, useState } from "react";
import ReactDOM from "react-dom/client";

import { LoginScreen } from "./components/auth/LoginScreen";
import { Sidebar } from "./components/layout/Sidebar";
import { TopBar } from "./components/layout/TopBar";
import { PanelRenderer } from "./components/panels/PanelRenderer";
import { PublicQrAttendanceScreen } from "./components/public/PublicQrAttendanceScreen";
import { navigationByRole } from "./config/navigation";
import { api, setApiToken } from "./services/api";
import "./styles/app.css";
import { loadTemplateMetadata } from "./utils/template";

const bootstrapKeys = [
  "roles",
  "users",
  "campaigns",
  "activityTypes",
  "targetAudiences",
  "activities",
  "people",
  "groups",
  "groupParticipants",
  "groupTrainers",
  "mans",
  "planners",
  "agendaEvents",
  "libraryResources",
  "feedbackRecords",
  "commitments",
  "qualityMonitors",
  "ojtFollowups",
  "preShifts",
  "operationResults",
  "virtualSessions",
];

const emptyBootstrap = Object.freeze(
  bootstrapKeys.reduce((accumulator, key) => {
    accumulator[key] = [];
    return accumulator;
  }, {}),
);

function getFirstNavigationItem(sections) {
  return sections?.find((section) => section.items.length)?.items[0] || null;
}

function LoadingPanel({ message }) {
  return (
    <div className="card">
      <div className="ch">
        <div className="ct">Cargando</div>
      </div>
      <div className="psub" style={{ marginBottom: 0 }}>
        {message}
      </div>
    </div>
  );
}

function resolvePublicQrToken() {
  const path = window.location.pathname;
  const publicPrefixes = ["/encuesta-asistencia/", "/qr/"];

  for (const prefix of publicPrefixes) {
    if (path.startsWith(prefix)) {
      return decodeURIComponent(path.slice(prefix.length));
    }
  }

  return "";
}

function App() {
  const publicQrToken = resolvePublicQrToken();
  const [logo, setLogo] = useState("");
  const [panelMetadata, setPanelMetadata] = useState({});
  const [identifier, setIdentifier] = useState("");
  const [password, setPassword] = useState("");
  const [screenError, setScreenError] = useState("");
  const [bootstrapping, setBootstrapping] = useState(true);
  const [loginLoading, setLoginLoading] = useState(false);
  const [dataLoading, setDataLoading] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);
  const [bootstrap, setBootstrap] = useState(emptyBootstrap);
  const [activePanelId, setActivePanelId] = useState("");
  const [currentModule, setCurrentModule] = useState("Inicio");

  const navigationSections = currentUser ? navigationByRole[currentUser.profile_key] || [] : [];

  async function loadBootstrap() {
    setDataLoading(true);
    try {
      const data = await api.get("/bootstrap");
      setBootstrap({
        ...emptyBootstrap,
        ...data,
      });
    } finally {
      setDataLoading(false);
    }
  }

  useEffect(() => {
    let active = true;

    async function initialize() {
      setBootstrapping(true);
      setScreenError("");

      try {
        const template = await loadTemplateMetadata();

        if (!active) return;

        setLogo(template.logo);
        setPanelMetadata(template.panels);
      } catch (error) {
        if (!active) return;
        setScreenError(error.message || "No fue posible iniciar la aplicacion.");
      } finally {
        if (active) {
          setBootstrapping(false);
        }
      }
    }

    initialize();
    return () => {
      active = false;
    };
  }, []);

  async function handleLogin() {
    if (!identifier.trim() || !password.trim()) {
      setScreenError("Debes escribir tu usuario o correo y tu contrasena.");
      return;
    }

    setLoginLoading(true);
    setScreenError("");

    try {
      const response = await api.post("/auth/login", {
        identifier: identifier.trim(),
        password,
      });

      setApiToken(response.token);
      setCurrentUser(response.user);
      await loadBootstrap();

      const sections = navigationByRole[response.user.profile_key] || [];
      const firstItem = getFirstNavigationItem(sections);
      if (firstItem) {
        setActivePanelId(firstItem.panelId);
        setCurrentModule(firstItem.label);
      } else {
        setActivePanelId("");
        setCurrentModule("Inicio");
      }

      setPassword("");
    } catch (error) {
      setApiToken("");
      setScreenError(error.message || "No fue posible iniciar sesion.");
    } finally {
      setLoginLoading(false);
    }
  }

  function handleLogout() {
    setApiToken("");
    setCurrentUser(null);
    setBootstrap(emptyBootstrap);
    setActivePanelId("");
    setCurrentModule("Inicio");
    setIdentifier("");
    setPassword("");
    setScreenError("");
  }

  function handlePanelSelection(item) {
    setActivePanelId(item.panelId);
    setCurrentModule(item.label);
  }

  const currentPanelMeta = panelMetadata[activePanelId] || {
    title: currentModule,
    subtitle: "Informacion integrada desde la base de datos real.",
  };

  if (publicQrToken) {
    return <PublicQrAttendanceScreen logo={logo} qrToken={publicQrToken} />;
  }

  if (!currentUser) {
    return (
      <LoginScreen
        logo={logo}
        identifier={identifier}
        password={password}
        loading={bootstrapping || loginLoading}
        error={screenError}
        onIdentifierChange={setIdentifier}
        onPasswordChange={setPassword}
        onSubmit={handleLogin}
      />
    );
  }

  return (
    <div id="app" className="visible">
      <TopBar logo={logo} currentUser={currentUser} currentModule={currentModule} onLogout={handleLogout} />
      <div className="app-body">
        <Sidebar sections={navigationSections} activePanelId={activePanelId} onSelect={handlePanelSelection} />
        <main className="content">
          {dataLoading ? (
            <LoadingPanel message="Sincronizando informacion desde MySQL..." />
          ) : (
            <div className="role-view on">
              <div className="panel on">
                <PanelRenderer
                  panelId={activePanelId}
                  meta={currentPanelMeta}
                  bootstrap={bootstrap}
                  currentUser={currentUser}
                  refresh={loadBootstrap}
                />
              </div>
            </div>
          )}
        </main>
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
