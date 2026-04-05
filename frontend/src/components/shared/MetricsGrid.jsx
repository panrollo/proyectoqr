export function MetricsGrid({ items = [] }) {
  if (!items.length) return null;

  return (
    <div className={items.length >= 4 ? "sr4" : items.length === 3 ? "sr3" : "sr2"}>
      {items.map((item) => (
        <div className="sc" key={item.label}>
          <div className="sc-lbl">{item.label}</div>
          <div className="sc-val" style={item.color ? { color: item.color } : undefined}>{item.value}</div>
          {item.helper ? <div className="sc-sub">{item.helper}</div> : null}
        </div>
      ))}
    </div>
  );
}
