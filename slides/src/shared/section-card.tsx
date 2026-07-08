import type { ReactNode } from "react";

export function SectionCard({
  title,
  children,
}: {
  title: string;
  children: ReactNode;
}) {
  return (
    <div className="rounded-xl border border-black/10 bg-black/3 p-8">
      <p className="text-xl font-semibold uppercase tracking-[0.15em] text-slate-400 mb-1.5">
        {title}
      </p>
      {children}
    </div>
  );
}
