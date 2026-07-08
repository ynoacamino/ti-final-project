export function BulletList({
  items,
  color,
  marker = "→",
}: {
  items: { label: string; detail: string }[];
  color: string;
  marker?: string;
}) {
  return (
    <div className="space-y-1">
      {items.map((i) => (
        <div key={i.label} className="flex items-baseline gap-2 text-2xl">
          <span className="font-semibold" style={{ color }}>
            {marker}
          </span>
          <span className="font-semibold text-slate-800">{i.label}</span>
          <span className="text-slate-500">{i.detail}</span>
        </div>
      ))}
    </div>
  );
}
