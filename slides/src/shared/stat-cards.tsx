export function StatCard({
  value,
  label,
  color,
  variant = "default",
}: {
  value: string;
  label: string;
  color: string;
  variant?: "default" | "decorated";
}) {
  const isDecorated = variant === "decorated";

  return (
    <div
      className="rounded-xl p-2 text-center flex flex-col justify-center relative overflow-hidden"
      style={
        isDecorated
          ? {
              border: `1px solid color-mix(in oklab, ${color} 45%, transparent)`,
              background: `linear-gradient(135deg, color-mix(in oklab, ${color} 8%, #f8fafc) 0%, color-mix(in oklab, ${color} 20%, #f8fafc) 100%)`,
              boxShadow: `0 0 20px color-mix(in oklab, ${color} 22%, transparent), inset 0 0 40px color-mix(in oklab, ${color} 8%, transparent)`,
            }
          : {
              border: "1px solid rgba(0,0,0,0.1)",
              background: "rgba(0,0,0,0.03)",
            }
      }
    >
      {isDecorated && (
        <>
          <div
            className="absolute top-2 left-2 w-2 h-2 rounded-full opacity-40"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute top-2 right-2 w-2 h-2 rounded-full opacity-40"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute bottom-2 left-2 w-2 h-2 rounded-full opacity-40"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute bottom-2 right-2 w-2 h-2 rounded-full opacity-40"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute top-3 left-4 right-4 h-px opacity-20"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute bottom-3 left-4 right-4 h-px opacity-20"
            style={{ backgroundColor: color }}
          />
        </>
      )}

      <p
        className="text-7xl font-bold relative z-10"
        style={
          isDecorated
            ? {
                color,
                textShadow: `0 0 20px ${color}40, 0 0 40px ${color}20`,
              }
            : { color }
        }
      >
        {value}
      </p>
      <p className="mt-1 text-xl font-semibold uppercase tracking-[0.15em] text-slate-400 relative z-10">
        {label}
      </p>
    </div>
  );
}

export function StatCardSmall({
  value,
  label,
  color,
}: {
  value: string;
  label: string;
  color: string;
}) {
  return (
    <div className="rounded-lg border border-black/10 bg-black/3 text-center flex flex-col justify-center">
      <p className="m-3! text-6xl font-bold" style={{ color }}>
        {value}
      </p>
      <p className="m-3! text-xl text-slate-500 leading-snug">{label}</p>
    </div>
  );
}
