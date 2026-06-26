---
title: "SmartPyME"
subtitle: "Documento de Plan de Implementación"
author: "Alvaro Raul Quispe Condori"
email: "aquispecondo@unsa.edu.pe"
date: "Junio 2026"
version: "1.0.0"
lang: es

toc: true
numbersections: true

fontsize: 12pt
mainfont: "Times New Roman"
monofont: "DejaVu Sans Mono"
geometry: margin=2.5cm
linestretch: 1.5

colorlinks: true
linkcolor: blue

header-includes:
  - \usepackage{setspace}
  - \usepackage{parskip}
  - \setlength{\parindent}{0pt}
  - \usepackage{fontspec}
  - \setmonofont{DejaVu Sans Mono"

---

# Información general

**Proyecto:** SmartPyME — Plataforma Digital Móvil para PYMES de Comercio Minorista.

**Versión:** 1.0.0.

**Periodo de ejecución:** 27 de junio – 6 de julio de 2026 (10 días calendario, 7 de desarrollo + 3 de buffer). Sustentación entre el 7 y el 10 de julio de 2026.

**Responsable:** Alvaro Raul Quispe Condori (`aquispecondo@unsa.edu.pe`).

**Modalidad de trabajo:** Individual, 100% autónomo, sin colaboradores ni equipo de QA externo.

**Entorno de desarrollo:** Linux Pop!_OS 24. La demo final se ejecutará en emulador Android o en navegador mediante `flutter run -d chrome` como respaldo.

**Ubicación del código:** Monorepo en la raíz del proyecto, con dos módulos principales:

- `/backend` — API REST en Bun + Hono + Drizzle + Zod + SQLite (libsql), expuesta en `http://localhost:3000`.
- `/mobile` — Aplicación Flutter (Android/iOS) que consume la API.

**Stack tecnológico:**

- **Backend:** Bun, Hono, Drizzle ORM, drizzle-kit, `@libsql/client` (SQLite), Zod, `jose` (JWT), `bcrypt`, Stripe SDK (sandbox), `@aws-sdk/client-s3` (Cloudflare R2), `pino` (logs), `dotenv`, `vitest`, TypeScript, ESLint, Prettier.
- **Mobile:** Flutter 3.16+, Dart 3.2+, `flutter_riverpod`, `riverpod_annotation`, `dio`, `freezed`, `json_serializable`, `build_runner`, `go_router`, `flutter_stripe`, `cached_network_image`, `image_picker`, `flutter_secure_storage`, `intl`, `fl_chart`, `flutter_lints`.
- **Persistencia y servicios externos:** SQLite (archivo local `smartpyme.db`), Cloudflare R2 (storage de imágenes), Stripe (pagos en modo test), Pen (moneda PEN, zona horaria UTC-5).

**Infraestructura de soporte:** `docker-compose.yml` raíz con MinIO como fallback opcional del storage (categorizado como Should en el backlog). Sin CI/CD ni despliegue remoto: todas las verificaciones se ejecutan localmente con `bun run dev` y `flutter run`.

**Documentos de referencia:**

- `ARTICULO.md` — Artículo bibliométrico que sustenta la propuesta.
- `ALCANCE.md` — Documento de alcance del proyecto (requisitos y criterios de aceptación).
- `BACKLOG.md` — Backlog con 14 épicas, 32 historias de usuario y ~120 tareas técnicas.
- `MODELOS-DATOS.md` — Modelo de datos con 13 entidades y DDL de Drizzle.
- `API.md` — Contrato de la API REST con 40 endpoints documentados.
- `PRUEBAS-PLANTILLA.md` — Plantilla de estrategia de pruebas (referencia futura, no desarrollada en este plan).

- Como la información general debe identificar de forma única al proyecto, su versión, su responsable y su ventana de tiempo.
- Como el stack debe listar únicamente las tecnologías relevantes para la ejecución del plan.
- Como la ubicación del código debe indicar la ruta exacta donde reside cada módulo.


# Objetivo

Definir el orden de construcción, la estrategia de desarrollo y los criterios de salida verificables para cada fase del MVP de SmartPyME, de modo que el producto se entregue íntegro en 4 hitosincrementales (H1–H4) dentro de la ventana 27 de junio – 6 de julio de 2026, con 3 días de buffer final para absorber contingencias y preparar la sustentación.

- Como el plan debe establecer un orden claro de construcción, priorizando las dependencias técnicas y de negocio.
- Como el plan debe definir criterios de salida verificables para cada fase, comprobables mediante demo, prueba o revisión.
- Como el plan debe alinearse con los requisitos de `ALCANCE.md` y las tareas del `BACKLOG.md`.
- Como el plan debe contemplar el trabajo de un único desarrollador autónomo, por lo que cada decisión debe optimizar la productividad individual y reducir el retrabajo.


# Estrategia de implementación

- **Modelo de trabajo:** incremental por hitos, MVP primero, iteraciones posteriores. Se entregan cuatro hitos verificables (H1, H2, H3, H4) más un periodo de buffer.
- **Criterio de orden:** de base a cima. Primero dependencias y estructura (monorepo, auth, modelo de datos, CRUD de catálogo); después funcionalidades centrales (carrito, checkout, pedidos, inventario, dashboard); luego el cliente móvil end-to-end; finalmente el panel de administración y la demo.
- **Validación continua:** cada fase cierra con un demo interno del hito correspondiente y un smoke test de los endpoints o pantallas críticas. El cierre se documenta con un valor Sí/No en la tabla de hitos.
- **Mitigación temprana de riesgos:** las decisiones arquitectónicas con mayor riesgo (decremento atómico de stock, integración con Stripe sin webhook real, gestión de imágenes en R2) se aplican en las Fases 1 y 2, no al final del cronograma.
- **Calidad continua:** validación con Zod en todos los endpoints del backend, modelos inmutables con Freezed en Flutter, `flutter_lints` y ESLint ejecutados después de cada tarea de tamaño medio o grande. La estrategia de QA detallada se delega a `PRUEBAS-PLANTILLA.md` como anexo futuro.
- **Trazabilidad:** cada tarea del plan referencia explícitamente el código de épica (E-XXX) y de historia de usuario (HU-XXX) del `BACKLOG.md`, de modo que sea posible navegar del plan al requisito original.
- **Sin ceremonias ágiles formales:** al ser un trabajo individual, no se realizan dailies, plannings ni retrospectivas estructuradas. El seguimiento se limita a la verificación Sí/No de cada hito y a notas de cierre en el `CHANGELOG` del repositorio.
- **Sin CI ni despliegue remoto:** todas las verificaciones se ejecutan localmente (`bun run dev`, `flutter run`, `bun run seed`). La demo se realiza en la misma máquina del desarrollador.

- Como la estrategia debe definir un modelo de trabajo claro y realista para un equipo de una persona.
- Como la estrategia debe priorizar la reducción de riesgo en las fases tempranas, especialmente en lo referente a stock, pagos y storage.
- Como cada tarea del plan debe referenciar su origen en el backlog mediante códigos E-XXX y HU-XXX.
- Como el plan debe ser austero en overhead: sin reuniones, sin reportes intermedios a terceros, sin pipelines automatizados.


# Fases del proyecto

El proyecto se divide en cuatro fases de desarrollo más un periodo de buffer. Las fases 1 y 2 cierran con un backend funcional y sembrado; las fases 3 y 4 cierran con la app móvil completa y la demo lista. La sustentación se realiza entre el 7 y el 10 de julio de 2026.


## Fase 1 — Base del backend, autenticación, catálogo e imágenes

**Objetivo:** Disponer de un backend operativo, autenticado y con gestión completa de catálogo e imágenes, de modo que el cliente móvil y el panel de administración puedan consumir los recursos desde la Fase 2 en adelante.

**Periodo:** 27–28 de junio de 2026 (días 1–2).

**Épicas cubiertas:** E-001, E-002, E-003, E-004.

**Hito BACKLOG:** H1.

**Tareas:**

- **[E-001 / HU-001, HU-002, HU-003]** Inicializar el repositorio Git desde cero, crear la estructura `/backend` y `/mobile`, escribir el `README.md` raíz, el `.gitignore` raíz, el `package.json` raíz con scripts `dev`, `build`, `lint`, y el `docker-compose.yml` con MinIO como servicio auxiliar opcional.
- **[E-001]** Configurar `bun`, `tsconfig.json`, ESLint y Prettier en `/backend`; crear `.env.example` con `DATABASE_URL`, `JWT_SECRET`, `STRIPE_SECRET_KEY`, `R2_*` y `PORT`.
- **[E-002 / HU-004, HU-005, HU-006, HU-007]** Diseñar los schemas Drizzle para `users` y `customers`. Implementar el `AuthService`, `AuthRepository`, los casos de uso `RegisterUserUseCase` y `LoginUserUseCase`, y el middleware JWT de Hono con validación de rol (`admin` / `customer`).
- **[E-002]** Crear las rutas `POST /api/auth/register` y `POST /api/auth/login`, validar todos los inputs con Zod, hashear contraseñas con `bcrypt` factor 10 y firmar el JWT con expiración de 7 días.
- **[E-003 / HU-008, HU-009, HU-010]** Diseñar los schemas Drizzle de `categories`, `products` y `product_variants`; generar los slugs automáticamente desde el nombre (sin acentos, minúsculas, guiones).
- **[E-003]** Implementar `CategoryRepository` y `ProductRepository` con paginación y filtros, los casos de uso `CreateProduct`, `ListProducts` y `UpdateStock`, y las rutas REST `/api/categories`, `/api/products`, `/api/products/:id` con validación de precio mayor a 0 y combinación única de variante.
- **[E-004 / HU-011, HU-012]** Configurar el cliente S3 con `@aws-sdk/client-s3` apuntando a Cloudflare R2, implementar el `StorageService` con métodos `upload` y `delete`, diseñar el schema Drizzle de `product_images` y crear la ruta `POST /api/products/:id/images` con soporte `multipart/form-data`, validación de formato (JPG, PNG, WebP) y tamaño máximo de 5 MB.
- **[E-001]** Crear el endpoint `GET /api/health` y servir Swagger UI en `/api/docs` desde la especificación OpenAPI.

**Criterios de salida:**

- Como el repositorio está clonado, el `README.md` documenta la instalación y la ejecución local, y `docker compose up -d` levanta MinIO sin errores.
- Como `POST /api/auth/register` y `POST /api/auth/login` devuelven códigos 201 y 200 respectivamente con un JWT válido, y rechazan credenciales inválidas con 401.
- Como el CRUD de categorías, productos y variantes funciona mediante los endpoints de administración y la validación con Zod bloquea precios ≤ 0 y combinaciones duplicadas.
- Como la carga de imágenes en Cloudflare R2 devuelve la URL pública, rechaza formatos distintos a JPG/PNG/WebP y rechaza archivos mayores a 5 MB.
- Como el hito **H1** se marca como **Sí** en la tabla de hitos, con nota breve en el `CHANGELOG`.


## Fase 2 — Carrito, checkout, pedidos, inventario y dashboard (backend)

**Objetivo:** Completar el backend con el flujo de venta end-to-end (carrito → checkout → pago → pedido → inventario) y con los endpoints del dashboard, de modo que la app móvil solo tenga que consumir y renderizar la información.

**Periodo:** 29–30 de junio de 2026 (días 3–4).

**Épicas cubiertas:** E-005, E-006, E-007, E-008, E-009, E-010 y parcialmente E-012 (script de seed).

**Hito BACKLOG:** H2.

**Tareas:**

- **[E-005 / HU-013, HU-014, HU-015]** Crear los endpoints públicos `GET /api/catalog/products` con paginación, `GET /api/catalog/products/:slug` con detalle completo, y los filtros por categoría y búsqueda por nombre. Excluir productos inactivos y devolver `404` cuando un slug no exista.
- **[E-006 / HU-016, HU-017]** Diseñar los schemas Drizzle de `carts` y `cart_items`, implementar `CartRepository` con soporte de sesión anónima (`session_id`), los casos de uso `AddToCart`, `UpdateCartItem` y `RemoveFromCart`, y las rutas `POST /api/cart/items`, `PATCH /api/cart/items/:id`, `DELETE /api/cart/items/:id` con validación de stock.
- **[E-007 / HU-018, HU-019]** Diseñar los schemas Drizzle de `orders`, `order_items` y `payments`. Configurar el SDK de Stripe con `STRIPE_SECRET_KEY` (cuenta creada por Alvaro en esta fase), crear el `OrderService` con la máquina de estados del pedido y los casos de uso `CreateCheckout` (crea orden + PaymentIntent) y `ConfirmPayment` (consulta el estado en Stripe, marca la orden como `pagado` y decrementa el stock atómicamente).
- **[E-007]** Crear las rutas `POST /api/checkout` (devuelve `client_secret`) y `POST /api/payments/confirm` (sin webhook, llamada directa desde la app tras `flutter_stripe`).
- **[E-008 / HU-020, HU-021, HU-022]** Crear los endpoints `GET /api/orders`, `GET /api/orders/:id`, `PATCH /api/orders/:id/status` (con validación de la transición secuencial `pendiente → pagado → enviado → entregad` y cancelación solo en `pendiente` o `pagado`) y `GET /api/customers/me/orders` con middleware que valide la propiedad del recurso.
- **[E-009 / HU-023, HU-024]** Implementar el `StockService` con operación atómica de decremento mediante `BEGIN IMMEDIATE` y registro en `stock_movements`. Diseñar el schema de `stock_alerts` y crear el endpoint `GET /api/inventory/alerts` que liste las alertas activas con stock por debajo del umbral (5 unidades por defecto).
- **[E-010 / HU-025, HU-026]** Crear el `DashboardService` con queries agregadas y los endpoints `GET /api/dashboard/metrics`, `GET /api/dashboard/top-products`, `GET /api/dashboard/orders-by-status` y `GET /api/dashboard/sales-timeline` con soporte para granularidad diaria, semanal o mensual.
- **[E-012 / HU-031]** Crear el script `bun run seed` (idempotente) que cargue 1 administrador (`admin@smartpyme.com`), 4 categorías (Camisas, Jeans, Vestidos, Accesorios) y 12–15 productos con 3–5 variantes cada uno, descargando imágenes de Unsplash y subiéndolas a R2.

**Criterios de salida:**

- Como el catálogo público responde correctamente a filtros por categoría y búsqueda por nombre, y oculta productos inactivos.
- Como el flujo de carrito calcula subtotal y total en cada operación, y rechaza cantidades mayores al stock disponible.
- Como `POST /api/checkout` rechaza carritos vacíos con 422, valida la coherencia del total y devuelve un `client_secret` válido de Stripe.
- Como `POST /api/payments/confirm` actualiza la orden a `pagado`, decrementa el stock de cada variante con un registro en `stock_movements` y vacía el carrito del cliente.
- Como el dashboard devuelve ventas totales, ticket promedio, top 5 productos y pedidos por estado en un rango de fechas.
- Como el seed `bun run seed` se ejecuta sin errores y deja la base de datos lista para la demo.
- Como el hito **H2** se marca como **Sí** en la tabla de hitos.


## Fase 3 — Aplicación móvil Flutter: cliente end-to-end

**Objetivo:** Disponer de una aplicación móvil funcional con el flujo completo del cliente (onboarding → login → catálogo → carrito → checkout → mis pedidos), de modo que la sustentación pueda mostrar una compra real de extremo a extremo.

**Periodo:** 1–2 de julio de 2026 (días 5–6).

**Épicas cubiertas:** E-011 (componentes del cliente) y parcialmente E-012 (preparación del emulador).

**Hito BACKLOG:** H3.

**Tareas:**

- **[E-011 / HU-027]** Crear el proyecto Flutter en `/mobile`, configurar `pubspec.yaml` con `flutter_riverpod`, `dio`, `freezed`, `go_router`, `cached_network_image`, `flutter_stripe`, `flutter_secure_storage`, `intl`, `fl_chart` e `image_picker`. Crear el theme Material 3 con la paleta de SmartPyME y un `DioClient` con interceptor JWT.
- **[E-011 / HU-028]** Implementar las 3 pantallas de onboarding, las pantallas de login y registro (cliente y admin en rutas distintas), la bottom navigation del cliente con 4 pestañas (Inicio, Catálogo, Carrito, Perfil) y la persistencia del JWT con `flutter_secure_storage`.
- **[E-011 / HU-029]** Implementar la pantalla de catálogo con grid de productos, filtros por categoría y barra de búsqueda; la pantalla de detalle con selector de variante (talla y color) y stock visible; la pantalla de carrito con edición de cantidades; la pantalla de checkout con formulario de envío en JSON; la integración con `flutter_stripe` usando el `client_secret` del backend; y la pantalla de confirmación post-pago con el número de pedido.
- **[E-011 / HU-029]** Implementar la pantalla de "Mis pedidos" del cliente autenticado, consumiendo `GET /api/customers/me/orders`.

**Criterios de salida:**

- Como la app compila sin errores en `flutter run -d chrome` y en el emulador Android de Pop!_OS 24.
- Como un usuario puede completar el flujo `catálogo → carrito → checkout → pago de prueba con tarjeta 4242 4242 4242 4242 → confirmación` sin bloqueos.
- Como un usuario autenticado puede consultar su historial de pedidos y ver el detalle de cada uno.
- Como el JWT persiste tras cerrar y reabrir la aplicación.
- Como el hito **H3** se marca como **Sí** en la tabla de hitos.


## Fase 4 — Panel de administración Flutter, demo y materiales de sustentación

**Objetivo:** Cerrar el producto con el panel de administración, dejar el guion de demo, el `README` final y la APK debug compilada, de modo que la sustentación se sustente en una pieza presentable y reproducible.

**Periodo:** 3 de julio de 2026 (día 7).

**Épicas cubiertas:** E-011 (componentes del admin) y E-012 (cierre).

**Hito BACKLOG:** H4.

**Tareas:**

- **[E-011 / HU-030]** Crear la bottom navigation del administrador con 4 pestañas (Dashboard, Productos, Pedidos, Tickets — esta última puede quedar como placeholder en v1).
- **[E-011 / HU-030]** Implementar la pantalla de dashboard con métricas clave (`fl_chart` para la serie temporal y el top de productos), la lista de pedidos con filtros por estado y cambio de estado, y la pantalla de gestión de productos con creación rápida, edición y carga de imágenes desde galería o cámara (`image_picker`).
- **[E-012 / HU-032]** Escribir el guion de demo paso a paso en el `README.md` raíz: `git clone` → `docker compose up -d` → `bun install` → `bun run db:push` → `bun run seed` → `bun run dev` → `flutter pub get` → `flutter run`.
- **[E-012]** Compilar la APK debug con `flutter build apk --debug` o preparar el comando `flutter run -d chrome` como respaldo. Verificar que el APK abre, se autentica con el usuario del seed y muestra el dashboard con datos reales.

**Criterios de salida:**

- Como el panel admin permite ver el dashboard con métricas reales del seed, cambiar el estado de un pedido a `enviado` y crear un producto nuevo con imagen subida a R2.
- Como el `README.md` raíz contiene el guion de demo, las instrucciones de instalación, las variables de entorno requeridas y los casos de uso cubiertos.
- Como la APK debug está compilada o el comando `flutter run -d chrome` está validado y documentado como respaldo.
- Como el hito **H4** se marca como **Sí** en la tabla de hitos.


## Periodo de buffer (días 8–10)

**Periodo:** 4–6 de julio de 2026.

**Objetivo:** Absorber cualquier retraso de las fases anteriores, aplicar polish, corregir defectos descubiertos durante la integración y preparar la sustentación.

**Tareas opcionales (solo si el buffer queda libre):**

- Completar las historias clasificadas como Should en el backlog (múltiples imágenes por producto, historial completo del cliente, alertas de stock bajo en UI, top productos en dashboard).
- Ejecutar una pasada de `flutter_lints`, ESLint, Prettier y `tsc --noEmit` para limpiar warnings.
- Documentar el procedimiento de instalación y de seed en un video corto (no obligatorio, opcional).
- Preparar 2–3 diapositivas de apoyo (no obligatorias, dado que la sustentación es solo demo en vivo + Q&A).

- Como cada fase debe tener un objetivo claro, medible y entregable.
- Como los criterios de salida deben ser comprobables mediante demo, prueba o revisión del repositorio.
- Como las fases deben ordenarse respetando dependencias técnicas y de negocio, de modo que ninguna fase dependa de un insumo de una fase posterior.


# Cronograma estimado

La siguiente tabla resume las cuatro fases, su duración y los entregables visibles que validan el avance. Los días 8–10 funcionan como buffer absorbente de contingencias; la sustentación se realiza entre el 7 y el 10 de julio.

| Fase | Duración     | Hito BACKLOG | Entregable visible                                                                                       |
| ---- | ------------ | ------------ | -------------------------------------------------------------------------------------------------------- |
| 1    | 27–28 jun (2 días) | H1           | Backend operativo con auth JWT, CRUD de catálogo, upload de imágenes a R2, Swagger UI, seed disponible. |
| 2    | 29–30 jun (2 días) | H2           | Flujo end-to-end backend: carrito, checkout, pago, pedido, inventario, dashboard, seed cargado.          |
| 3    | 1–2 jul (2 días)   | H3           | App Flutter cliente funcional: onboarding, catálogo, carrito, checkout con Stripe, mis pedidos.         |
| 4    | 3 jul (1 día)      | H4           | Panel admin Flutter, dashboard con métricas, APK debug compilada, guion de demo y `README` final.        |
| **Total desarrollo** | **7 días** | **H1–H4** | MVP completo listo para sustentación.                                                                     |
| Buffer   | 4–6 jul (3 días)   | —            | Polish, correcciones, preparación de la sustentación.                                                     |
| Sustentación | 7–10 jul       | —            | Demo en vivo (15–20 min) + Q&A ante jurado de la UNSA.                                                    |

**Tabla de hitos (Sí/No por fase):**

| Hito | Descripción                                                              | Cumplido |
| ---- | ------------------------------------------------------------------------ | -------- |
| H1   | Backend con auth + productos + DB operativa + Docker Compose listo       | Sí / No  |
| H2   | Backend completo con carrito, pedidos, Stripe sandbox y seed cargado     | Sí / No  |
| H3   | App cliente Flutter end-to-end: catálogo → carrito → checkout → mis pedidos | Sí / No  |
| H4   | Panel admin Flutter + dashboard + demo compilada y guion listo           | Sí / No  |

**Notas:**

- Como la jornada de trabajo se ajusta a las necesidades de cada fase ("las necesarias para cumplir con las fases/fechas"), no se fija un número de horas diario: el criterio de éxito es el cumplimiento del hito al cierre de la fase, no las horas acumuladas.
- Como el orden de las fases es estricto: la Fase 2 no puede iniciar si la Fase 1 no cerró su H1; la Fase 3 no puede iniciar si la Fase 2 no cerró su H2; la Fase 4 no puede iniciar si la Fase 3 no cerró su H3.
- Como los días 8–10 (buffer) no agregan features nuevas: solo absorben retrasos, permiten polish y dejan margen para preparar la sustentación. Si una fase se atrasa, los features clasificados como Should o Could en el backlog se difieren o se recortan antes que las fases de demo.
- Como la política de calidad al cierre de cada fase es: smoke test manual de los endpoints o pantallas del hito + verificación de los criterios de salida + nota breve en el `CHANGELOG`.

- Como el cronograma debe ser realista y considerar la capacidad individual del desarrollador.
- Como cada fase debe indicar un entregable visible para validar su avance sin ambigüedad.
- Como los hitos deben poder verificarse con un Sí/No al cierre de cada fase, sin necesidad de reuniones.


# Recursos necesarios

## Frameworks y librerías

### Backend (Bun)

| Tecnología                  | Versión objetivo  | Estado actual | Uso dentro del proyecto                                                  |
| --------------------------- | ----------------- | ------------- | ------------------------------------------------------------------------ |
| `bun`                       | 1.x               | A instalar    | Runtime y gestor de paquetes del backend.                                |
| `hono`                      | ^4.x              | A instalar    | Framework web minimalista sobre Bun para definir las rutas REST.         |
| `drizzle-orm`               | ^0.30+            | A instalar    | ORM type-safe para acceder a SQLite.                                     |
| `drizzle-kit`               | ^0.20+            | A instalar    | CLI para generar y ejecutar migraciones versionadas.                    |
| `@libsql/client`            | ^0.10+            | A instalar    | Driver de SQLite/libsql.                                                 |
| `zod`                       | ^3.22+            | A instalar    | Validación de esquemas en todos los endpoints.                           |
| `bcrypt`                    | ^5.x              | A instalar    | Hashing de contraseñas con factor de costo 10.                           |
| `jose`                      | ^5.x              | A instalar    | Firma y verificación de tokens JWT (edge-friendly).                      |
| `stripe`                    | ^14+              | A instalar    | SDK oficial de Stripe en modo test.                                      |
| `@aws-sdk/client-s3`        | ^3.x              | A instalar    | Cliente S3 para subir y eliminar objetos en Cloudflare R2.              |
| `dotenv`                    | ^16+              | A instalar    | Carga de variables de entorno desde `.env`.                             |
| `pino` + `pino-pretty`      | ^8+ / ^10+        | A instalar    | Logger estructurado de peticiones, errores y eventos de negocio.         |
| `vitest`                    | ^1+               | A instalar    | Framework de tests unitarios para piezas críticas.                       |
| `typescript`                | ^5+               | A instalar    | Tipado estático en el backend.                                           |
| `eslint` + `prettier`       | últimas estables  | A instalar    | Lint y formateo de código.                                               |

### Mobile (Flutter)

| Tecnología                | Versión objetivo  | Estado actual | Uso dentro del proyecto                                                  |
| ------------------------- | ----------------- | ------------- | ------------------------------------------------------------------------ |
| `flutter`                 | ^3.16+            | A instalar    | SDK base de la aplicación móvil.                                         |
| `dart`                    | ^3.2+             | Incluido      | Lenguaje de programación.                                               |
| `flutter_riverpod`        | ^2.5+             | A instalar    | State management declarativo.                                           |
| `riverpod_annotation`     | ^2.3+             | A instalar    | Generador de providers.                                                 |
| `dio`                     | ^5+               | A instalar    | Cliente HTTP con interceptor de JWT.                                     |
| `freezed`                 | ^2.5+             | A instalar    | Modelos de datos inmutables.                                             |
| `freezed_annotation`      | ^2.4+             | A instalar    | Anotaciones para `freezed`.                                              |
| `json_serializable`       | ^6.7+             | A instalar    | Serialización JSON a partir de modelos.                                  |
| `json_annotation`         | ^4.8+             | A instalar    | Anotaciones para `json_serializable`.                                    |
| `build_runner`            | ^2.4+             | A instalar    | Code generation para Freezed y Riverpod.                                 |
| `go_router`               | ^14+              | A instalar    | Routing declarativo con soporte de rutas protegidas.                     |
| `flutter_stripe`          | ^11+              | A instalar    | SDK de Stripe para Payment Sheet en Flutter.                             |
| `cached_network_image`    | ^3.3+             | A instalar    | Caché de imágenes de producto.                                          |
| `image_picker`            | ^1+               | A instalar    | Selección de imágenes desde galería o cámara.                           |
| `flutter_secure_storage`  | ^9+               | A instalar    | Almacenamiento cifrado del JWT.                                          |
| `intl`                    | ^0.19+            | A instalar    | Formateo de fechas y moneda (PEN).                                       |
| `fl_chart`                | ^0.68+            | A instalar    | Gráficos del dashboard administrativo.                                  |
| `flutter_lints`           | ^3+               | A instalar    | Reglas de lint para Dart/Flutter.                                        |

## Componentes UI a agregar

- **`SplashScreen` + `OnboardingCarousel`** (3 pantallas de presentación de SmartPyME).
- **`AuthScreens`** (login y registro con tabs separados para cliente y administrador).
- **`CatalogGrid`** (grid de `ProductListItem` con `cached_network_image`, badge de stock y precio mínimo).
- **`ProductDetailScreen`** (galería de imágenes, selector de variante, stepper de cantidad, botón "Agregar al carrito").
- **`CartScreen`** (lista editable de `CartItem` con swipe-to-delete y resumen de subtotal/total).
- **`CheckoutScreen`** (formulario de `ShippingAddress` + integración con `flutter_stripe`).
- **`OrderConfirmationScreen`** (resumen del pedido con número de orden y CTA para seguir comprando).
- **`OrderHistoryScreen`** (lista de pedidos del cliente con estado y total).
- **`AdminDashboardScreen`** (tarjetas de métricas + serie temporal con `fl_chart` + top 5 productos).
- **`AdminOrdersScreen`** (lista de pedidos con filtros por estado y diálogo de cambio de estado).
- **`AdminProductsScreen`** (CRUD de productos con `image_picker` y formulario en tabs).
- **`ChatbotFab`** (placeholder en v1, queda como FAB deshabilitado en el cliente).

## Assets externos

- **Imágenes de productos para el seed:** obtenidas de Unsplash (libre de derechos), categorías de ropa, moda y accesorios, organizadas en 4 grupos (Camisas, Jeans, Vestidos, Accesorios). Descargadas por el script `bun run seed` y subidas a Cloudflare R2 durante el seed.
- **Logo de SmartPyME:** diseño propio o tipografía `Inter` o `Plus Jakarta Sans` para el wordmark, sin coste.
- **Iconografía:** `Material Symbols` (gratuitos) o `lucide-react` (gratuitos).
- **Credenciales de Cloudflare R2:** provistas al desarrollador al inicio del proyecto; necesarias para `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_BUCKET`, `R2_PUBLIC_URL`.
- **Credenciales de Stripe (test):** cuenta creada por el desarrollador durante la Fase 1, con `STRIPE_SECRET_KEY` (`sk_test_…`) y `STRIPE_PUBLISHABLE_KEY` (`pk_test_…`).

## Archivos del proyecto a crear o modificar

| Archivo / carpeta                              | Tipo   | Cambio                                                                          |
| ---------------------------------------------- | ------ | ------------------------------------------------------------------------------- |
| `README.md` (raíz)                             | Nuevo  | Instrucciones de instalación, configuración, ejecución y demo.                  |
| `package.json` (raíz)                          | Nuevo  | Scripts `dev`, `build`, `lint`, `seed`, `db:push`, `db:reset`.                  |
| `docker-compose.yml`                           | Nuevo  | Servicio MinIO como fallback opcional del storage R2.                          |
| `.gitignore` (raíz)                            | Nuevo  | Excluye `node_modules`, `build`, `.env`, `.dart_tool`, `*.db`, entre otros.     |
| `.env.example` (`/backend`)                    | Nuevo  | Documenta `DATABASE_URL`, `JWT_SECRET`, `STRIPE_*`, `R2_*`, `PORT`.            |
| `.env.example` (`/mobile`)                     | Nuevo  | Documenta `API_BASE_URL` y `STRIPE_PUBLISHABLE_KEY`.                            |
| `/backend/src/index.ts`                        | Nuevo  | Bootstrap del servidor Hono, registro de middlewares globales.                  |
| `/backend/src/db/schema.ts`                    | Nuevo  | Schemas Drizzle de las 13 entidades.                                            |
| `/backend/src/routes/auth.ts`                  | Nuevo  | Endpoints de registro, login y `/auth/me`.                                      |
| `/backend/src/routes/categories.ts`            | Nuevo  | CRUD de categorías (admin).                                                     |
| `/backend/src/routes/products.ts`              | Nuevo  | CRUD de productos y variantes (admin).                                          |
| `/backend/src/routes/images.ts`                | Nuevo  | Upload y eliminación de imágenes en R2.                                         |
| `/backend/src/routes/catalog.ts`               | Nuevo  | Endpoints públicos del catálogo.                                                |
| `/backend/src/routes/cart.ts`                  | Nuevo  | Endpoints del carrito (con soporte guest).                                      |
| `/backend/src/routes/checkout.ts`              | Nuevo  | `POST /api/checkout`.                                                           |
| `/backend/src/routes/payments.ts`              | Nuevo  | `POST /api/payments/confirm`.                                                   |
| `/backend/src/routes/orders.ts`                | Nuevo  | Listado, detalle y cambio de estado.                                            |
| `/backend/src/routes/inventory.ts`             | Nuevo  | Alertas y movimientos de stock.                                                 |
| `/backend/src/routes/dashboard.ts`             | Nuevo  | Métricas, top productos, pedidos por estado, serie temporal.                    |
| `/backend/src/services/stripe.service.ts`      | Nuevo  | Creación de PaymentIntents y consulta de estado.                                |
| `/backend/src/services/storage.service.ts`      | Nuevo  | Cliente S3 contra Cloudflare R2.                                                |
| `/backend/src/services/stock.service.ts`        | Nuevo  | Decremento atómico y registro de movimientos.                                   |
| `/backend/src/middleware/auth.ts`              | Nuevo  | Validación de JWT y roles.                                                      |
| `/backend/src/openapi/registry.ts`             | Nuevo  | Registro `@hono/zod-openapi` para Swagger UI en `/api/docs`.                    |
| `/backend/scripts/seed.ts`                     | Nuevo  | Seed idempotente (admin + 4 categorías + 12–15 productos + imágenes).           |
| `/mobile/pubspec.yaml`                         | Nuevo  | Dependencias Flutter del proyecto.                                              |
| `/mobile/lib/main.dart`                        | Nuevo  | Bootstrap de la app, providers globales y router.                               |
| `/mobile/lib/core/theme/app_theme.dart`        | Nuevo  | Theme Material 3 con paleta de SmartPyME.                                       |
| `/mobile/lib/core/network/dio_client.dart`     | Nuevo  | Cliente Dio con interceptor JWT.                                                |
| `/mobile/lib/features/auth/`                   | Nuevo  | Onboarding, login, registro, persistencia de sesión.                            |
| `/mobile/lib/features/catalog/`                | Nuevo  | Listado, filtros, búsqueda, detalle de producto.                                |
| `/mobile/lib/features/cart/`                   | Nuevo  | Carrito, edición de cantidades, checkout, integración con `flutter_stripe`.     |
| `/mobile/lib/features/orders/`                 | Nuevo  | Confirmación post-pago e historial del cliente.                                  |
| `/mobile/lib/features/admin/dashboard/`        | Nuevo  | Dashboard con métricas y gráficos.                                              |
| `/mobile/lib/features/admin/orders/`           | Nuevo  | Lista de pedidos y cambio de estado.                                            |
| `/mobile/lib/features/admin/products/`         | Nuevo  | CRUD de productos y carga de imágenes.                                          |
| `CHANGELOG.md`                                 | Nuevo  | Notas de cierre de cada hito.                                                   |

- Como cada recurso debe estar claramente asociado a una tarea, fase o épica del plan.
- Como los componentes y librerías nuevas deben justificarse con su propósito concreto dentro del MVP.
- Como los archivos nuevos deben crearse siguiendo las convenciones del stack (TypeScript estricto, Dart con Freezed, schemas Drizzle).


# Riesgos técnicos

Se mantienen los 8 riesgos identificados en el `BACKLOG.md` (R-001 a R-008), sin ampliación. Cada riesgo se aborda en una fase concreta del plan.

| ID     | Riesgo                                                                                                                  | Impacto | Probabilidad | Mitigación en este plan                                                                                                                |
| ------ | ----------------------------------------------------------------------------------------------------------------------- | ------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| R-001  | Stripe en sandbox sin webhook real puede fallar por el timing entre la confirmación del SDK y el estado de la orden.     | Alto    | Media        | Implementar `POST /api/payments/confirm` que consulta `stripe.paymentIntents.retrieve(id)` antes de actualizar la orden (Fase 2).       |
| R-002  | Cloudflare R2 requiere credenciales válidas; si fallan no se cargan imágenes.                                            | Alto    | Media        | Validar las credenciales al inicio de la Fase 1 con un health check. Si fallan, degradar a MinIO local con `docker-compose`.           |
| R-003  | Tiempo insuficiente para implementar el panel admin Flutter con la misma calidad que el cliente.                        | Alto    | Alta         | Priorizar el flujo del cliente en la Fase 3. El panel admin se reduce en la Fase 4 a lista de pedidos con cambio de estado + creación rápida de productos. |
| R-004  | Errores en migraciones Drizzle que rompan el seed o el desarrollo.                                                       | Alto    | Baja         | Usar `drizzle-kit generate` para migraciones versionadas, mantener un script `db:reset` y probar siempre con `db:reset && seed`.        |
| R-005  | Build de APK Flutter puede fallar en Linux por dependencias nativas (Stripe, secure storage).                            | Medio   | Media        | Compilar y probar con antelación en la Fase 4. Tener como respaldo `flutter run -d chrome` para la demo en el navegador.               |
| R-006  | Burnout o bloqueo del desarrollador único durante la semana.                                                              | Alto    | Media        | Tratar los días 4–6 jul (buffer) como colchón absorbente. Si una fase se atrasa, no se recorta el alcance: se desplaza al buffer.       |
| R-007  | Inconsistencias en el manejo de stock bajo concurrencia (race conditions).                                                | Alto    | Baja         | Implementar el decremento de stock como transacción SQLite con `BEGIN IMMEDIATE` y registro en `stock_movements` (Fase 2).               |
| R-008  | Errores en el formateo de moneda, fechas o zona horaria entre backend y Flutter.                                         | Bajo    | Media        | Usar `intl` en Flutter, formatear en backend con ISO 8601 y UNIX timestamp en milisegundos. Definir PEN y UTC-5 en ambos lados.        |

- Como cada riesgo debe tener una mitigación concreta, ejecutable y asociada a una fase o tarea del plan.
- Como los riesgos críticos (R-001, R-002, R-003, R-006, R-007) deben abordarse en las primeras fases, no al final del cronograma.


# Criterios de éxito

Los criterios de éxito del proyecto se toman del documento de alcance (`ALCANCE.md`) y se reformulan ligeramente para reflejar el recorte del chatbot (E-013 y E-014 quedan fuera de v1).

- Como el usuario administrador debe poder completar el flujo de alta de tienda y primer producto en menos de 2 horas.
- Como el cliente debe poder navegar el catálogo, agregar al carrito y completar un pago de prueba con tarjeta `4242 4242 4242 4242` de forma exitosa.
- Como el sistema debe gestionar el ciclo completo de un pedido: alta, pago, preparación, envío y entrega.
- Como la demo en vivo del flujo del cliente debe completarse sin bloqueos, con todos los pasos verificables en menos de 5 minutos. (Sustituye al criterio del chatbot, recortado en v1.)
- Como debe entregarse el código fuente completo en un repositorio Git con `README` de instalación.
- Como debe entregarse la aplicación móvil compilada y funcional en un emulador Android o en navegador mediante `flutter run -d chrome`.
- Como debe entregarse una demo en vivo que cubra al menos 5 casos de uso principales: registro de admin, alta de producto, navegación de catálogo, compra con Stripe y consulta de mis pedidos.
- Como debe entregarse este documento de plan de implementación firmado por el equipo (en este caso, por el único responsable).
- Como debe entregarse una sustentación técnica de 15–20 minutos ante el jurado académico de la UNSA, con demo en vivo y sesión de preguntas, entre el 7 y el 10 de julio de 2026.

- Como cada criterio de éxito debe ser verificable mediante una prueba, demo o métrica concreta.
- Como los criterios de éxito deben cubrir alcance, calidad, rendimiento y entrega, y deben poder demostrarse durante la sustentación.


# Anexo A — Supuestos del plan

- Como se asume que el desarrollador tiene experiencia previa con TypeScript, Dart, Flutter, SQL y consumo de APIs REST, de modo que no se incluye tiempo de capacitación en el cronograma.
- Como se asume que el catálogo inicial de productos (12–15 productos con sus variantes e imágenes) se proporciona en forma de URLs de Unsplash, sin necesidad de sesiones de fotografía.
- Como se asume que la cuenta de Cloudflare R2 y sus credenciales se entregan al inicio del proyecto, y que la cuenta de Stripe (test) se crea en la Fase 1.
- Como se asume que el equipo cuenta con conexión a internet estable para acceder a Stripe, R2, GitHub y descarga de dependencias.
- Como se asume que el dispositivo o emulador en Pop!_OS 24 cumple los requisitos mínimos de Flutter (Android 8+ o navegador Chrome actualizado).
- Como se asume que no se requieren aprobaciones externas (cliente real, comité de ética, etc.) para el deploy local o para el uso de las APIs en modo test.


# Anexo B — Estrategia de QA y pruebas

La estrategia detallada de QA (unit tests, integration tests, E2E y métricas de cobertura) se desarrolla en un documento independiente basado en `PRUEBAS-PLANTILLA.md`, que se considera un anexo futuro de este plan y no se desarrolla en esta versión. En el presente plan se aplican únicamente las siguientes prácticas de calidad continua, ya mencionadas en la estrategia:

- Validación con Zod en todos los inputs de la API.
- Modelos inmutables con Freezed en Flutter.
- `flutter_lints` y ESLint ejecutados después de cada tarea de tamaño medio o grande.
- Smoke test manual de los endpoints o pantallas críticas al cierre de cada fase.
- Tests unitarios con Vitest solo en piezas críticas: hashing bcrypt, decremento atómico de stock y máquina de estados de pedido.


# Anexo C — Glosario mínimo

| Término | Definición                                                                                  |
| ------- | ------------------------------------------------------------------------------------------- |
| MVP     | Minimum Viable Product. Producto mínimo viable.                                             |
| SP      | Story Point. Unidad relativa de estimación de esfuerzo.                                     |
| JWT     | JSON Web Token. Estándar de tokens firmado para autenticación.                             |
| RNF     | Requisito No Funcional. Restricción de calidad, rendimiento o seguridad.                   |
| RN      | Regla de Negocio. Restricción del dominio que el sistema debe respetar.                    |
| Buffer  | Periodo sin nuevas features destinado a absorber contingencias y aplicar polish.           |
| Hito    | Punto de control verificable al cierre de una fase.                                         |
