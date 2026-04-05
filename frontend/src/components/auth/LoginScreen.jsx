export function LoginScreen({
  logo,
  identifier,
  password,
  loading,
  error,
  onIdentifierChange,
  onPasswordChange,
  onSubmit,
}) {
  function handleKeyDown(event) {
    if (event.key === "Enter" && !loading) {
      onSubmit();
    }
  }

  return (
    <div id="login-screen">
      <div className="lstripe"></div>
      <div className="lbox">
        <div className="llogo">{logo ? <img src={logo} alt="Logo" /> : null}</div>
        <div className="ldiv"></div>
        <div className="ltitle">Acceder a la plataforma</div>
        <div className="lsub">Inicia sesion con tus credenciales registradas en la base de datos.</div>
        {error ? <div className="banner-error">{error}</div> : null}
        <div className="field">
          <label>Usuario o correo</label>
          <input
            type="text"
            value={identifier}
            placeholder="Ingresa tu correo registrado"
            onChange={(event) => onIdentifierChange(event.target.value)}
            onKeyDown={handleKeyDown}
            autoComplete="username"
          />
        </div>
        <div className="field">
          <label>Contrasena</label>
          <input
            type="password"
            value={password}
            placeholder="Ingresa tu contrasena"
            onChange={(event) => onPasswordChange(event.target.value)}
            onKeyDown={handleKeyDown}
            autoComplete="current-password"
          />
        </div>
        <button className="lbtn" onClick={onSubmit} disabled={loading}>
          {loading ? "Validando..." : "Iniciar sesion"}
        </button>
        <div className="lfooter">Autenticacion conectada a MySQL real</div>
      </div>
    </div>
  );
}
