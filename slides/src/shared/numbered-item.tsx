export function NumberedItem({
  num,
  title,
  description,
  color,
}: {
  num: string;
  title: string;
  description: string;
  color: string;
}) {
  return (
    <div className="rounded-xl border border-black/10 bg-black/3 p-3">
      <div className="flex items-center gap-3">
        <span
          className="flex size-6 shrink-0 items-center justify-center rounded-full text-lg font-semibold"
          style={{ backgroundColor: `${color}25`, color }}
        >
          {num}
        </span>
        <p className="m-3! text-2xl font-semibold uppercase tracking-widest text-slate-800">
          {title}
        </p>
      </div>
      <p className="m-3! text-xl text-left text-slate-500 leading-relaxed">
        {description}
      </p>
    </div>
  );
}
