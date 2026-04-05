function initialsFromName(name = "") {
  return name
    .split(" ")
    .filter(Boolean)
    .slice(0, 2)
    .map((part) => part[0]?.toUpperCase() || "")
    .join("");
}

export function TopBar({ logo, currentUser, currentModule, onLogout }) {
  return (
    <div className="topbar">
      <div className="tb-logo">{logo ? <img src={logo} alt="Logo" /> : null}</div>
      <div className="tb-sep"></div>
      <div className="tb-bc">
        <span>Modulo de Formacion y Desarrollo</span> / <span>{currentModule}</span>
      </div>
      <div className="tb-r">
        <div className="tb-user">
          <div className="tb-av" style={{ background: "#C0272D" }}>{initialsFromName(currentUser?.full_name)}</div>
          <div>
            <div className="tb-nm">{currentUser?.full_name}</div>
            <div className="tb-rl">{currentUser?.role_key}</div>
          </div>
        </div>
        <div className="tb-out" onClick={onLogout}>Salir</div>
      </div>
    </div>
  );
}
