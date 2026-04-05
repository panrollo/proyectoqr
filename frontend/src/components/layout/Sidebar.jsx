export function Sidebar({ sections, activePanelId, onSelect }) {
  return (
    <div className="sidebar">
      {sections.map((section) => (
        <div className="sb-sec" key={section.section}>
          <div className="sb-lbl">{section.section}</div>
          {section.items.map((item) => (
            <div
              key={item.panelId}
              className={`nav ${activePanelId === item.panelId ? "on" : ""}`}
              onClick={() => onSelect(item)}
            >
              <span className="nav-ico">{item.icon}</span>
              {item.label}
            </div>
          ))}
        </div>
      ))}
    </div>
  );
}
