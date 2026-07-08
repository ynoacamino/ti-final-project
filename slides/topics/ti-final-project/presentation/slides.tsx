import { Slide } from "@revealjs/react";
import { Badge } from "@/shared/badge";
import { colors as C } from "@/shared/colors";
import { FeatureCard, FeatureCardCompact } from "@/shared/feature-cards";
import { NumberedItem } from "@/shared/numbered-item";
import { PresentationDeck } from "@/shared/presentation-deck";
import { SlideWrap } from "@/shared/slide-wrap";
import { StatCard } from "@/shared/stat-cards";
import { ThanksSlide } from "@/shared/thanks-slide";

const baseUrl = import.meta.env.BASE_URL.replace(/\/$/, "");
const asset = (name: string) => `${baseUrl}/ti-final-project/${name}`;

const IMG_ARCHITECTURE = asset("architecture.png");
const IMG_TECH_STACK = asset("tech_stack.png");
const IMG_THEMATIC_EVOLUTION = asset("thematic_evolution.png");
const IMG_SME_BENEFITS = asset("sme_benefits.png");
const IMG_VERCEL = asset("vercel2.jpg");
const IMG_APP_HOME = asset("app2.jpeg");
const IMG_APP_PRODUCT = asset("app3.jpeg");
const IMG_APP_CART = asset("app4.jpeg");
const IMG_APP_CHECKOUT1 = asset("app5.jpeg");
const IMG_APP_CHECKOUT3 = asset("app7.jpeg");
const IMG_APP_DASHBOARD = asset("app8.jpeg");
const IMG_APP_ORDERS = asset("app9.jpeg");
const IMG_APP_CATALOG = asset("app11.jpeg");

const T = C.teal;

/* ─── IMAGEN CON MARCO CLARO ─── */
function FramedImage({
  src,
  alt,
  caption,
  className = "",
}: {
  src: string;
  alt: string;
  caption?: string;
  className?: string;
}) {
  return (
    <div className="flex flex-col items-center gap-1.5">
      <div className={`overflow-hidden ${className}`}>
        <img
          src={src}
          alt={alt}
          className="object-contain rounded-xl bg-white/95 p-0.5 shadow-md w-full h-full"
        />
      </div>
      {caption && (
        <p className="text-lg text-slate-500 text-center text-pretty">
          {caption}
        </p>
      )}
    </div>
  );
}

/* ─── PORTADA + INTEGRANTES ─── */
function Cover() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Proyecto Final de Tecnología de la Información · 2026-A"
        variant="decorated"
        className="justify-center flex flex-col items-center h-full py-8 text-center"
      >
        <p
          className="text-2xl font-semibold uppercase tracking-[0.25em]"
          style={{ color: T }}
        >
          Transformación Digital y Plataformas Inteligentes
        </p>
        <h1 className="mt-3 text-6xl!">
          Smart<span style={{ color: T }}>PyME</span>
        </h1>
        <p className="mt-2 text-2xl text-slate-500 max-w-3xl text-pretty">
          Un Enfoque Bibliométrico y Propuesta de Prototipo para PYMES del
          Sector Textil
        </p>
        <div className="mt-6">
          <p className="text-xl font-semibold uppercase tracking-[0.2em] text-slate-400">
            Autores
          </p>
          <p className="mt-1.5 text-xl text-slate-600 font-light max-w-4xl text-pretty">
            Choquehuanca Berna William Henderson <br /> Fernandez Huarca Rodrigo
            Alexander <br /> Mestas Zegarra Christian Raul <br /> Noa Camino
            Yenaro Joel
            <br />· Quispe Condori Alvaro Raul
          </p>
          <p className="mt-1 text-lg text-slate-400">
            Universidad Nacional de San Agustín de Arequipa
          </p>
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── MOTIVACIÓN ─── */
function Motivation() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Introducción · El Problema"
        variant="decorated"
        className="justify-center flex flex-col gap-6 w-full mx-auto"
      >
        <div className="flex flex-col items-center">
          <h1 className="text-5xl! text-balance max-w-4xl text-center">
            Las PYMES y la <span style={{ color: T }}>brecha digital</span>
          </h1>
          <p className="mt-2 text-xl text-slate-500 max-w-4xl text-center text-pretty">
            Las PYMES representan el 99% de las empresas a nivel global, pero
            enfrentan bajos niveles de adopción tecnológica y limitaciones
            significativas en la digitalización de sus procesos de negocio.
          </p>
        </div>

        <div className="grid grid-cols-3 gap-3">
          {[
            {
              l: "Recursos limitados",
              d: "Escasez de presupuesto para infraestructura tecnológica e innovación digital.",
            },
            {
              l: "Falta de capacidades",
              d: "Ausencia de personal especializado en tecnología de la información.",
            },
            {
              l: "Resistencia al cambio",
              d: "Cultura organizacional que dificulta la adopción de nuevas herramientas.",
            },
          ].map((i) => (
            <FeatureCard
              key={i.l}
              label={i.l}
              description={i.d}
              color={T}
              variant="decorated"
            />
          ))}
        </div>

        <div className="flex flex-wrap items-center justify-center gap-3">
          <span className="text-xl font-semibold uppercase tracking-[0.15em] text-slate-400">
            Objetivos
          </span>
          {[
            "Análisis bibliométrico",
            "Tecnologías aplicadas",
            "Prototipo funcional",
          ].map((f) => (
            <Badge key={f} label={f} color={T} />
          ))}
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── METODOLOGÍA ─── */
function Methodology() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Metodología Bibliométrica"
        variant="decorated"
        className="w-full flex items-center justify-center"
      >
        <div className="grid grid-cols-2 gap-6 w-full items-center text-left">
          <div className="flex flex-col gap-3">
            <h1 className="text-4xl! font-semibold tracking-tight">
              Enfoque cuantitativo{" "}
              <span style={{ color: T }}>descriptivo y correlacional</span>
            </h1>
            <p className="text-xl text-slate-500 leading-snug">
              Análisis de la literatura publicada entre 2020 y 2026 en seis
              bases de datos científicas internacionales para identificar
              tendencias tecnológicas y la evolución temática de la
              transformación digital en PYMES.
            </p>
            <div className="flex flex-wrap gap-2">
              {[
                "Scopus",
                "Web of Science",
                "IEEE",
                "Springer",
                "ACM",
                "OpenAlex",
              ].map((b) => (
                <Badge key={b} label={b} color={T} />
              ))}
            </div>
          </div>
          <div className="flex flex-col gap-3">
            <NumberedItem
              num="1"
              title="Búsqueda y descarga"
              description="Recopilación de registros bibliográficos con ecuación de búsqueda específica."
              color={T}
            />
            <NumberedItem
              num="2"
              title="Limpieza y depuración"
              description="Eliminación de duplicados y clasificación por año, base de datos, autores y países."
              color={T}
            />
            <NumberedItem
              num="3"
              title="Análisis de tendencias"
              description="Evolución temporal, colaboraciones entre autores y detección de palabras clave emergentes."
              color={T}
            />
          </div>
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── RESULTADOS BIBLIOGRÁFICOS ─── */
function BibliometricResults() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Resultados · Evolución de Publicaciones"
        variant="decorated"
        className="w-full flex flex-col gap-3 justify-center"
      >
        <h1 className="text-4xl! font-semibold tracking-tight text-center">
          Crecimiento sostenido en el período{" "}
          <span style={{ color: T }}>2020-2026</span>
        </h1>
        <div className="grid grid-cols-2 gap-4 self-stretch justify-items-center">
          <FramedImage
            src={IMG_THEMATIC_EVOLUTION}
            alt="Evolución temática de la transformación digital en PYMES: tres fases de 2020 a 2026"
            caption="Evolución temática en tres fases diferenciadas"
            className="w-full"
          />
          <div className="flex flex-col gap-3">
            <div className="grid grid-cols-2 gap-2">
              <StatCard
                value="86"
                label="Publicaciones totales"
                color={T}
                variant="decorated"
              />
              <StatCard
                value="6"
                label="Bases de datos"
                color={T}
                variant="decorated"
              />
              <StatCard
                value="3"
                label="Fases de evolución"
                color={T}
                variant="decorated"
              />
              <StatCard
                value="42%"
                label="OpenAlex (líder)"
                color={T}
                variant="decorated"
              />
            </div>
          </div>
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── TENDENCIAS TECNOLÓGICAS ─── */
function TechTrends() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Resultados · Tendencias Tecnológicas"
        variant="decorated"
        className="justify-center flex flex-col gap-4"
      >
        <h1 className="text-5xl! font-semibold tracking-tight text-center">
          Tecnologías clave para la{" "}
          <span style={{ color: T }}>transformación digital</span>
        </h1>
        <div className="grid grid-cols-3 gap-3">
          {[
            {
              l: "Inteligencia Artificial",
              d: "Analítica predictiva, automatización de procesos y toma de decisiones basada en datos.",
            },
            {
              l: "Computación en la Nube",
              d: "Infraestructura escalable con modelo de pago por uso para organizaciones con recursos limitados.",
            },
            {
              l: "Internet de las Cosas",
              d: "Conexión entre dispositivos físicos y sistemas digitales para monitoreo en tiempo real.",
            },
            {
              l: "Gemelos Digitales",
              d: "Simulación de procesos de negocio antes de su implementación.",
            },
            {
              l: "Plataformas Industriales",
              d: "Ecosistemas integrados de servicios digitales para la transformación.",
            },
            {
              l: "IA Generativa",
              d: "La frontera más reciente de la tendencia tecnológica en PYMES.",
            },
          ].map((i) => (
            <FeatureCardCompact
              key={i.l}
              label={i.l}
              description={i.d}
              color={T}
              variant="decorated"
            />
          ))}
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── EVOLUCIÓN TEMÁTICA ─── */
function ThematicEvolution() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Resultados · Evolución Temática"
        variant="decorated"
        className="w-full flex flex-col gap-3 justify-center"
      >
        <h1 className="text-4xl! font-semibold tracking-tight text-center">
          Tres fases de <span style={{ color: T }}>maduración progresiva</span>
        </h1>
        <div className="grid grid-cols-3 gap-3">
          <div className="rounded-xl border border-black/10 bg-black/3 p-4">
            <p
              className="text-xl font-semibold uppercase tracking-widest mb-2"
              style={{ color: T }}
            >
              Fase 1: 2020-2021
            </p>
            <p className="text-lg font-semibold text-slate-800 mb-1">
              Respuesta reactiva
            </p>
            <p className="text-lg text-slate-500 leading-snug">
              Impacto del COVID-19 y necesidad urgente de digitalización.
              Investigaciones enfocadas en supervivencia y adaptación.
            </p>
          </div>
          <div className="rounded-xl border border-black/10 bg-black/3 p-4">
            <p
              className="text-xl font-semibold uppercase tracking-widest mb-2"
              style={{ color: T }}
            >
              Fase 2: 2022-2023
            </p>
            <p className="text-lg font-semibold text-slate-800 mb-1">
              Consolidación estratégica
            </p>
            <p className="text-lg text-slate-500 leading-snug">
              Emergencia de marcos teóricos como capacidades dinámicas, economía
              circular y modelos de madurez digital.
            </p>
          </div>
          <div className="rounded-xl border border-black/10 bg-black/3 p-4">
            <p
              className="text-xl font-semibold uppercase tracking-widest mb-2"
              style={{ color: T }}
            >
              Fase 3: 2024-2026
            </p>
            <p className="text-lg font-semibold text-slate-800 mb-1">
              Innovación tecnológica
            </p>
            <p className="text-lg text-slate-500 leading-snug">
              Predominio de la inteligencia artificial, resiliencia
              organizacional e integración de múltiples tecnologías emergentes.
            </p>
          </div>
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── PROTOTIPO: CONTEXTO ─── */
function PrototypeContext() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Propuesta · SmartPyME"
        variant="decorated"
        className="justify-center flex flex-col gap-5 items-center"
      >
        <h1 className="text-6xl! font-semibold tracking-tight text-center">
          Plataforma digital para{" "}
          <span style={{ color: T }}>PYMES textiles</span>
        </h1>
        <p className="text-xl text-slate-500 max-w-3xl text-center text-pretty">
          SmartPyME es una plataforma de comercio electrónico modular diseñada
          específicamente para PYMES del sector textil, implementada como
          prototipo funcional con un backend RESTful y una aplicación móvil
          cross-platform.
        </p>
        <div className="grid grid-cols-3 gap-3 self-stretch">
          {[
            {
              l: "Ciclo completo",
              d: "Catálogo de productos hasta confirmación de pedidos con gestión de inventario.",
            },
            {
              l: "Arquitectura modular",
              d: "Hexagonal (Puertos y Adaptadores) con Domain-Driven Design en el backend.",
            },
            {
              l: "Costos reducidos",
              d: "SQLite local, hosting compartido y tecnología Flutter para acceso universal.",
            },
          ].map((i) => (
            <FeatureCard
              key={i.l}
              label={i.l}
              description={i.d}
              color={T}
              variant="decorated"
            />
          ))}
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── ARQUITECTURA DEL SISTEMA ─── */
function SystemArchitecture() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Desarrollo · Arquitectura del Sistema"
        variant="decorated"
        className="w-full flex items-center justify-center"
      >
        <div className="grid grid-cols-2 gap-6 w-full items-center text-left">
          <FramedImage
            src={IMG_ARCHITECTURE}
            alt="Arquitectura del sistema SmartPyME: cliente móvil Flutter, API REST con Bun/Hono, y capa de almacenamiento"
            caption="Arquitectura Hexagonal con DDD y Clean Architecture"
            className="w-full"
          />
          <div className="flex flex-col gap-3">
            <h1 className="text-3xl! font-semibold tracking-tight">
              Backend: <span style={{ color: T }}>Bun + Hono + Drizzle</span>
            </h1>
            <NumberedItem
              num="1"
              title="Runtime Bun"
              description="JavaScript runtime moderno con rendimiento superior a Node.js."
              color={T}
            />
            <NumberedItem
              num="2"
              title="Framework Hono"
              description="Framework web ultrarrápido con soporte para múltiples runtimes."
              color={T}
            />
            <NumberedItem
              num="3"
              title="Drizzle ORM"
              description="ORM tipo-safe sobre SQLite con migraciones y consultas tipadas."
              color={T}
            />
            <NumberedItem
              num="4"
              title="Flutter (Frontend)"
              description="Aplicación cross-platform con Riverpod para gestión de estado."
              color={T}
            />
          </div>
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── STACK TECNOLÓGICO ─── */
function TechStack() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Desarrollo · Stack Tecnológico"
        variant="decorated"
        className="w-full flex items-center justify-center"
      >
        <div className="flex flex-col items-center gap-4 w-full">
          <h1 className="text-4xl! font-semibold tracking-tight text-center">
            Tecnologías modernas pero <span style={{ color: T }}>estables</span>
          </h1>
          <FramedImage
            src={IMG_TECH_STACK}
            alt="Stack tecnológico de SmartPyME: frontend Flutter, backend Bun/Hono, e infraestructura de almacenamiento"
            className="w-full max-w-8xl max-h-[720px]"
          />
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── MÓDULOS DEL BACKEND ─── */
function BackendModules() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Desarrollo · Módulos del Backend"
        variant="decorated"
        className="w-full flex flex-col gap-3 justify-center"
      >
        <h1 className="text-4xl! font-semibold tracking-tight text-center">
          Seis módulos de dominio con{" "}
          <span style={{ color: T }}>puertos y adaptadores</span>
        </h1>
        <div className="grid grid-cols-3 gap-3">
          {[
            {
              l: "Auth",
              d: "Registro, login JWT, roles (admin/cliente) con bcryptjs.",
            },
            {
              l: "Catalog",
              d: "CRUD productos, categorías, variantes e imágenes.",
            },
            {
              l: "Cart",
              d: "Carrito persistente con addItem, updateQty, remove.",
            },
            {
              l: "Orders",
              d: "Checkout, Stripe PaymentIntent, confirmación webhook.",
            },
            {
              l: "Inventory",
              d: "Decremento de stock, alertas umbral=5, auditoría.",
            },
            {
              l: "Dashboard",
              d: "Métricas: ventas totales, ticket promedio, top productos.",
            },
          ].map((i) => (
            <FeatureCardCompact
              key={i.l}
              label={i.l}
              description={i.d}
              color={T}
              variant="decorated"
            />
          ))}
        </div>
        <p className="text-xl text-slate-500 text-center text-pretty">
          13 tablas en la base de datos SQLite · Valores monetarios en céntimos
          enteros · JWT con jose + bcryptjs · Validación con Zod
        </p>
      </SlideWrap>
    </Slide>
  );
}

/* ─── FLUJO DEL CLIENTE ─── */
function ClientFlow() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Frontend · Flujo del Cliente"
        variant="decorated"
        className="w-full flex flex-col gap-1 items-center justify-center"
      >
        <div className="flex flex-col items-center">
          <h1 className="text-4xl! text-balance text-center">
            Experiencia de compra{" "}
            <span className="font-semibold" style={{ color: T }}>
              completa e intuitiva
            </span>
          </h1>
          <p className="text-lg text-slate-500 text-pretty text-center max-w-4xl">
            Flujo completo desde el catálogo hasta la confirmación de pedido con
            checkout de tres pasos.
          </p>
        </div>
        <div className="grid grid-cols-3 gap-3 self-stretch justify-items-center">
          <FramedImage
            src={IMG_APP_HOME}
            alt="Pantalla de inicio del cliente con categorías y productos destacados"
            caption="1. Inicio y catálogo"
            className="w-[220px] max-h-[420px]"
          />
          <FramedImage
            src={IMG_APP_PRODUCT}
            alt="Detalle de producto con selector de talla y cantidad"
            caption="2. Detalle de producto"
            className="w-[220px] max-h-[420px]"
          />
          <FramedImage
            src={IMG_APP_CART}
            alt="Carrito de compras con resumen de costos"
            caption="3. Carrito de compras"
            className="w-[220px] max-h-[420px]"
          />
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── PROCESO DE CHECKOUT ─── */
function CheckoutProcess() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Frontend · Proceso de Checkout"
        variant="decorated"
        className="w-full flex flex-col gap-1 items-center justify-center"
      >
        <div className="flex flex-col items-center">
          <h1 className="text-4xl! text-balance text-center">
            Checkout de{" "}
            <span className="font-semibold" style={{ color: T }}>
              tres pasos
            </span>{" "}
            con progreso visual
          </h1>
          <p className="text-lg text-slate-500 text-pretty text-center max-w-4xl">
            Dirección de envío, resumen del pedido y confirmación de pago
            mediante transferencia Yape/Plin con código QR.
          </p>
        </div>
        <div className="grid grid-cols-2 gap-3 self-stretch justify-items-center">
          <FramedImage
            src={IMG_APP_CHECKOUT1}
            alt="Primer paso del checkout: formulario de dirección de envío"
            caption="Paso 1: Dirección de envío"
            className="w-[280px] max-h-[415px]"
          />
          <FramedImage
            src={IMG_APP_CHECKOUT3}
            alt="Tercer paso del checkout: confirmación de pago con código QR"
            caption="Paso 3: Pago por transferencia"
            className="w-[280px] max-h-[415px]"
          />
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── PANEL DE ADMINISTRACIÓN ─── */
function AdminPanel() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Frontend · Panel de Administración"
        variant="decorated"
        className="w-full flex flex-col gap-1 items-center justify-center"
      >
        <div className="flex flex-col items-center">
          <h1 className="text-4xl! text-balance text-center">
            Dashboard administrativo con{" "}
            <span className="font-semibold" style={{ color: T }}>
              analítica en tiempo real
            </span>
          </h1>
          <p className="text-lg text-slate-500 text-pretty text-center max-w-4xl">
            Tema oscuro diferenciado, métricas de KPI y gestión completa del
            negocio.
          </p>
        </div>
        <div className="grid grid-cols-3 gap-3 self-stretch justify-items-center">
          <FramedImage
            src={IMG_APP_DASHBOARD}
            alt="Dashboard administrativo con tarjetas de KPI y gráfico de ventas"
            caption="Dashboard con métricas"
            className="w-[220px] max-h-[420px]"
          />
          <FramedImage
            src={IMG_APP_ORDERS}
            alt="Gestión de pedidos con estados y detalles expandibles"
            caption="Gestión de pedidos"
            className="w-[220px] max-h-[420px]"
          />
          <FramedImage
            src={IMG_APP_CATALOG}
            alt="Gestión de catálogo con lista de productos"
            caption="Gestión de catálogo"
            className="w-[220px] max-h-[420px]"
          />
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── PAGOS E INVENTARIO ─── */
function PaymentsInventory() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Desarrollo · Pagos e Inventario"
        variant="decorated"
        className="w-full flex items-center justify-center"
      >
        <div className="grid grid-cols-2 gap-6 w-full items-center text-left">
          <div className="flex flex-col gap-3">
            <h1 className="text-3xl! font-semibold tracking-tight">
              Gestión de <span style={{ color: T }}>pagos flexible</span>
            </h1>
            <NumberedItem
              num="1"
              title="Stripe (sandbox)"
              description="PaymentIntents para creación de sesiones de pago con confirmación idempotente."
              color={T}
            />
            <NumberedItem
              num="2"
              title="Yape/Plin"
              description="Transferencia móvil peruana con código QR y validación manual del administrador."
              color={T}
            />
          </div>
          <div className="flex flex-col gap-3">
            <h1 className="text-3xl! font-semibold tracking-tight">
              Inventario con{" "}
              <span style={{ color: T }}>alertas automáticas</span>
            </h1>
            <NumberedItem
              num="1"
              title="Decremento diferido"
              description="Stock se reduce al confirmar el pago, no al crear el checkout."
              color={T}
            />
            <NumberedItem
              num="2"
              title="Auditoría completa"
              description="Cada operación genera registro en stock_movements para seguimiento."
              color={T}
            />
            <NumberedItem
              num="3"
              title="Alertas umbral"
              description="Se activan al caer por debajo de 5 unidades; se resuelven al reponer."
              color={T}
            />
          </div>
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── DESPLIEGUE ─── */
function Deployment() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Despliegue · Producción"
        variant="decorated"
        className="w-full flex items-center justify-center"
      >
        <div className="grid grid-cols-2 gap-6 w-full items-center text-left">
          <FramedImage
            src={IMG_VERCEL}
            alt="Panel de Vercel con despliegue del backend SmartPyME"
            caption="Despliegue en Vercel con escalado automático"
            className="w-full max-w-4xl"
          />
          <div className="flex flex-col gap-3">
            <h1 className="text-3xl! font-semibold tracking-tight">
              Infraestructura <span style={{ color: T }}>serverless</span>
            </h1>
            <NumberedItem
              num="1"
              title="Vercel"
              description="Escalado automático, integración continua con Git y dominios personalizados."
              color={T}
            />
            <NumberedItem
              num="2"
              title="Cloudflare R2"
              description="Almacenamiento de imágenes con fallback a sistema de archivos local."
              color={T}
            />
            <NumberedItem
              num="3"
              title="Costos reducidos"
              description="Hosting compartido + SQLite = infraestructura mínima para PYMES."
              color={T}
            />
          </div>
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── DISCUSIÓN ─── */
function Discussion() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Discusión · Brecha Investigación-Práctica"
        variant="decorated"
        className="w-full flex flex-col gap-3 justify-center"
      >
        <h1 className="text-4xl! font-semibold tracking-tight text-center">
          Cuatro barreras principales para la{" "}
          <span style={{ color: T }}>adopción digital</span>
        </h1>
        <div className="grid grid-cols-2 gap-3">
          {[
            {
              l: "Costos de implementación",
              d: "Soluciones empresariales inasequibles para organizaciones pequeñas.",
            },
            {
              l: "Falta de capacidades digitales",
              d: "Empleados y gerentes sin habilidades tecnológicas especializadas.",
            },
            {
              l: "Resistencia al cambio",
              d: "Cultura organizacional que dificulta la adopción de nuevas herramientas.",
            },
            {
              l: "Ciberseguridad",
              d: "Preocupaciones relacionadas con la protección de datos y privacidad.",
            },
          ].map((i) => (
            <FeatureCardCompact
              key={i.l}
              label={i.l}
              description={i.d}
              color={T}
              variant="decorated"
            />
          ))}
        </div>
        <p className="text-xl text-slate-500 text-center text-pretty">
          SmartPyME aborda estas brechas: SQLite elimina infraestructura
          externa, Flutter ofrece interfaz nativa sin costo adicional, la
          arquitectura hexagonal permite sustituir componentes, y Yape/Plin se
          adapta al ecosistema de pagos peruano.
        </p>
      </SlideWrap>
    </Slide>
  );
}

/* ─── CONCLUSIONES ─── */
function Conclusions() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Conclusiones"
        variant="decorated"
        className="w-full flex flex-col gap-3 justify-center"
      >
        <h1 className="text-5xl! font-semibold tracking-tight text-center">
          Transformación digital{" "}
          <span style={{ color: T }}>accesible y escalable</span>
        </h1>
        <div className="grid grid-cols-2 gap-4">
          {[
            {
              n: "1",
              l: "Crecimiento sostenido",
              d: "Tendencia ascendente de publicaciones con cambio estructural hacia innovación tecnológica estratégica.",
            },
            {
              n: "2",
              l: "IA como tecnología líder",
              d: "Inteligencia artificial se consolida como eje central, seguida por computación en la nube e IoT.",
            },
            {
              n: "3",
              l: "Interés global",
              d: "Diversidad geográfica con aportes relevantes desde Europa, Asia y América Latina.",
            },
            {
              n: "4",
              l: "Viabilidad técnica",
              d: "SmartPyME demuestra que una plataforma integral es posible con arquitecturas modulares y costos reducidos.",
            },
          ].map((i) => (
            <div
              key={i.n}
              className="rounded-xl border border-black/10 bg-black/3 p-3"
            >
              <div className="flex items-center gap-2">
                <span
                  className="flex size-5 shrink-0 items-center justify-center rounded-full text-base font-semibold"
                  style={{ backgroundColor: `${T}25`, color: T }}
                >
                  {i.n}
                </span>
                <p className="text-xl font-semibold uppercase tracking-widest text-slate-800">
                  {i.l}
                </p>
              </div>
              <p className="mt-0.5 text-xl text-left text-slate-500 leading-snug">
                {i.d}
              </p>
            </div>
          ))}
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── RECOMENDACIONES ─── */
function Recommendations() {
  return (
    <Slide className="h-full">
      <SlideWrap
        color={T}
        tag="Recomendaciones · Futuras Investigaciones"
        variant="decorated"
        className="justify-center flex flex-col gap-4"
      >
        <h1 className="text-5xl! font-semibold tracking-tight text-center">
          Próximos <span style={{ color: T }}>pasos</span>
        </h1>
        <div className="grid grid-cols-2 gap-3">
          {[
            {
              l: "Validación empírica",
              d: "Estudios de caso con PYMES reales del sector textil arequipeño.",
            },
            {
              l: "IA generativa",
              d: "Integración de módulos de atención al cliente con chatbots.",
            },
            {
              l: "Análisis de adopción",
              d: "Estudio de la adopción de la plataforma por parte de comerciantes.",
            },
            {
              l: "Marcos de referencia",
              d: "Medición del impacto económico de la transformación digital en PYMES.",
            },
          ].map((i) => (
            <FeatureCardCompact
              key={i.l}
              label={i.l}
              description={i.d}
              color={T}
              variant="decorated"
            />
          ))}
        </div>
      </SlideWrap>
    </Slide>
  );
}

/* ─── DECK ─── */
export function TIFinalProjectPresentation() {
  return (
    <PresentationDeck config={{ slideNumber: "c/t", transition: "slide" }}>
      <Cover />
      <Motivation />
      <Methodology />
      <BibliometricResults />
      <TechTrends />
      <ThematicEvolution />
      <PrototypeContext />
      <SystemArchitecture />
      <TechStack />
      <BackendModules />
      <ClientFlow />
      <CheckoutProcess />
      <AdminPanel />
      <PaymentsInventory />
      <Deployment />
      <Discussion />
      <Conclusions />
      <Recommendations />
      <ThanksSlide color={T} variant="decorated" />
    </PresentationDeck>
  );
}
