export function FeatureCard({
  label,
  description,
  color,
  variant = "default",
}: {
  label: string;
  description: string;
  color: string;
  variant?: "default" | "decorated";
}) {
  const isDecorated = variant === "decorated";

  return (
    <div
      className="rounded-xl p-4 flex flex-col justify-between relative overflow-hidden"
      style={
        isDecorated
          ? {
              border: `1px solid color-mix(in oklab, ${color} 45%, transparent)`,
              background: `linear-gradient(135deg, color-mix(in oklab, ${color} 8%, #f8fafc) 0%, color-mix(in oklab, ${color} 20%, #f8fafc) 100%)`,
              boxShadow: `0 0 15px color-mix(in oklab, ${color} 18%, transparent), inset 0 0 30px color-mix(in oklab, ${color} 8%, transparent)`,
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
            className="absolute top-0 left-0 right-0 h-px opacity-30"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute top-2 left-2 w-1.5 h-1.5 rounded-full opacity-40"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute top-2 right-2 w-1.5 h-1.5 rounded-full opacity-40"
            style={{ backgroundColor: color }}
          />
        </>
      )}

      <p
        className="text-xl font-semibold uppercase tracking-[0.15em] relative z-10"
        style={{ color }}
      >
        {label}
      </p>
      <p className="text-2xl text-slate-500 relative z-10">{description}</p>
    </div>
  );
}

export function FeatureCardCompact({
  label,
  description,
  color,
  variant = "default",
}: {
  label: string;
  description: string;
  color: string;
  variant?: "default" | "decorated";
}) {
  const isDecorated = variant === "decorated";

  return (
    <div
      className="rounded-xl p-3.5 justify-between flex flex-col items-center relative overflow-hidden"
      style={
        isDecorated
          ? {
              border: `1px solid color-mix(in oklab, ${color} 45%, transparent)`,
              background: `linear-gradient(135deg, color-mix(in oklab, ${color} 8%, #f8fafc) 0%, color-mix(in oklab, ${color} 20%, #f8fafc) 100%)`,
              boxShadow: `0 0 15px color-mix(in oklab, ${color} 18%, transparent), inset 0 0 30px color-mix(in oklab, ${color} 8%, transparent)`,
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
            className="absolute top-0 left-0 w-1 h-1 rounded-full opacity-50"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute top-0 right-0 w-1 h-1 rounded-full opacity-50"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute bottom-0 left-0 w-1 h-1 rounded-full opacity-50"
            style={{ backgroundColor: color }}
          />
          <div
            className="absolute bottom-0 right-0 w-1 h-1 rounded-full opacity-50"
            style={{ backgroundColor: color }}
          />
        </>
      )}

      <p
        className="text-2xl font-semibold uppercase tracking-widest relative z-10"
        style={{ color }}
      >
        {label}
      </p>
      <p className="mt-1 text-xl text-slate-500 leading-snug relative z-10">
        {description}
      </p>
    </div>
  );
}

export function FeatureCardTall({
  label,
  description,
  color,
}: {
  label: string;
  description: string;
  color: string;
}) {
  return (
    <div className="rounded-xl border border-black/10 bg-black/3 p-8 flex flex-col justify-between items-center">
      <p
        className="text-2xl font-semibold uppercase tracking-widest"
        style={{ color }}
      >
        {label}
      </p>
      <p className="mt-1 text-2xl text-slate-500 leading-snug">{description}</p>
    </div>
  );
}

export function FeatureCardCompactSmall({
  label,
  description,
  color,
}: {
  label: string;
  description: string;
  color: string;
}) {
  return (
    <div className="rounded-xl border border-black/10 bg-black/3 p-3 flex flex-col justify-between">
      <p
        className="text-lg font-semibold uppercase tracking-[0.1em]"
        style={{ color }}
      >
        {label}
      </p>
      <p className="mt-0.5 text-lg text-slate-500 leading-snug">
        {description}
      </p>
    </div>
  );
}
