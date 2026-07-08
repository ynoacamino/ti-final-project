import { createFileRoute, Link } from "@tanstack/react-router";
import { presentations } from "@/lib/presentations";

export const Route = createFileRoute("/")({
  component: Index,
});

function Index() {
  return (
    <div className="flex min-h-screen flex-col items-center bg-linear-to-br from-slate-50 via-indigo-50 to-slate-50 px-4 py-12 font-sans text-slate-800">
      <header className="mb-12 text-center">
        <h1 className="mb-2 bg-linear-to-r from-indigo-600 to-purple-600 bg-clip-text text-5xl font-extrabold text-transparent">
          Proyecto Final TI · 2026-A
        </h1>
      </header>

      <div className="grid w-full max-w-3xl gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {presentations.map((p) => (
          <Link
            key={p.path}
            to={p.path}
            className="group rounded-xl border border-black/10 bg-white/80 p-6 text-slate-800 no-underline transition-all duration-200 hover:cursor-pointer hover:bg-white hover:ring-1 hover:ring-black/10 shadow-sm"
          >
            <h3 className="mb-2 text-lg font-semibold">{p.title}</h3>
            <p className="text-sm text-slate-500">{p.description}</p>
          </Link>
        ))}
      </div>
    </div>
  );
}
