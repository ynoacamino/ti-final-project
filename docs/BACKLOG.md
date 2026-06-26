---
title: "SmartPyME"
subtitle: "Documento de Backlog del Producto"
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
  - \setmonofont{DejaVu Sans Mono}

---

# Información general

**Proyecto:** SmartPyME — Plataforma Digital Móvil para PYMES de Comercio Minorista

**Versión:** 1.0.0

**Responsable:** Alvaro Raul Quispe Condori

**Email:** aquispecondo@unsa.edu.pe

**Stack objetivo:**

- Backend: Bun + Hono + Drizzle ORM + Zod + SQLite (libsql) + Stripe SDK (sandbox) + AWS SDK for S3.
- Mobile: Flutter + Riverpod + Dio + Freezed + json_serializable + flutter_stripe.
- Storage: Cloudflare R2 (S3-compatible).
- Pagos: Stripe en modo test.
- Autenticación: JWT con bcrypt.
- Testing: Vitest (unit tests backend).

**Ruta del módulo backend:** `/backend` (API REST expuesta en `http://localhost:3000`).

**Ruta del módulo móvil:** `/mobile` (Flutter app Android/iOS).

**Ubicación del código:** Monorepo en la raíz del proyecto, con `docker-compose.yml` para infraestructura local.

- Como el stack objetivo debe estar claramente definido para evitar decisiones técnicas ambiguas.
- Como la ubicación del código debe indicar la ruta exacta donde reside el módulo principal.
- Como el monorepo debe incluir un README raíz con instrucciones de instalación, configuración y ejecución.

# Objetivo del backlog

Traducir los requisitos del documento `ALCANCE.md` en historias de usuario, épicas y tareas técnicas implementables, priorizadas por valor de negocio y dependencias técnicas, para guiar el desarrollo iterativo del producto en 4 sprints de aproximadamente 1.75 días cada uno (1 semana total).

- Como el backlog debe servir como puente entre el documento de alcance y la implementación.
- Como el backlog debe estar priorizado por valor de negocio y dependencias técnicas.
- Como el backlog debe permitir planificar iteraciones y releases de forma incremental.
- Como el backlog debe estar alineado con las restricciones de tiempo (1 semana) y equipo (1 desarrollador).


# Épicas

| Código | Épica | Trazabilidad alcance |
| ------ | ----- | -------------------- |
| E-001 | Configuración del monorepo y entorno de desarrollo | Setup, RNF-009 |
| E-002 | Autenticación y autorización JWT (admin y cliente) | RF-001, RF-002, RF-003, RN-008, RN-009, RN-010 |
| E-003 | Gestión de categorías, productos y variantes | RF-004, RF-005, RF-006, RN-003, RN-015 |
| E-004 | Carga y gestión de imágenes en Cloudflare R2 | RF-007, RN-007 |
| E-005 | Catálogo público, filtros y búsqueda | RF-008, RF-009 |
| E-006 | Carrito de compras persistente | RF-010, RN-006, RN-011 |
| E-007 | Checkout y procesamiento de pago con Stripe | RF-011, RN-012 |
| E-008 | Gestión de pedidos y flujo de estados | RF-012, RF-013, RN-002 |
| E-009 | Control de inventario y alertas de stock | RF-014, RF-015, RN-001, RN-004, RN-005 |
| E-010 | Dashboard de ventas y analítica | RF-018 |
| E-011 | Aplicación móvil Flutter (cliente y admin) | RF-005, RF-008 a RF-013, RF-018, RNF-004, RNF-006 |
| E-012 | Seed de datos, despliegue local y demo end-to-end | RNF-009, Criterios de aceptación globales |
| E-013 | ~~Chatbot de atención al cliente con IA local~~ | RF-016 (Fuera de alcance v1) |
| E-014 | ~~Gestión de tickets de soporte~~ | RF-017 (Fuera de alcance v1) |

- Como las épicas deben cubrir de forma completa los requisitos del documento de alcance marcados como Must.
- Como cada épica debe tener una trazabilidad explícita hacia el documento de origen.
- Como las épicas E-013 y E-014 quedan explícitamente fuera de la versión 1 por restricciones de tiempo.


# Historias de usuario

## E-001 · Configuración del monorepo y entorno

### HU-001 · Configurar estructura del monorepo y tooling base

**Como:** desarrollador del proyecto

**Quiero:** inicializar el monorepo con la estructura `/backend` y `/mobile`, scripts raíz, README y `.gitignore` unificado

**Para:** tener una base limpia y reproducible para el desarrollo de los dos módulos

**Criterios de aceptación:**

- Como debe existir un `README.md` raíz con instrucciones de instalación y arranque.
- Como deben existir `/backend` (Bun) y `/mobile` (Flutter) como carpetas independientes.
- Como debe existir un `.gitignore` raíz que ignore node_modules, build, .env, .dart_tool, etc.
- Como debe existir un `package.json` raíz con scripts para invocar el backend.

**Prioridad:** Alta

**Épica:** E-001

**Trazabilidad:** RNF-009

**Estimación:** 3 SP

---

### HU-002 · Levantar infraestructura local con Docker Compose

**Como:** desarrollador

**Quiero:** un `docker-compose.yml` que levante MinIO (opcional fallback) y utilidades de desarrollo

**Para:** poder desarrollar contra servicios locales sin depender de credenciales externas en etapas tempranas

**Criterios de aceptación:**

- Como debe existir un `docker-compose.yml` raíz con servicios auxiliares documentados.
- Como debe poder ejecutarse `docker compose up -d` sin errores.
- Como las instrucciones de uso deben estar en el README.

**Prioridad:** Media

**Épica:** E-001

**Trazabilidad:** RNF-009

**Estimación:** 2 SP

---

### HU-003 · Configurar variables de entorno y secretos

**Como:** desarrollador

**Quiero:** archivos `.env.example` para backend y mobile con todas las variables documentadas

**Para:** evitar errores de configuración y mantener las claves fuera del repositorio

**Criterios de aceptación:**

- Como debe existir `.env.example` en `/backend` con `DATABASE_URL`, `JWT_SECRET`, `STRIPE_SECRET_KEY`, `R2_*`, `PORT`.
- Como debe existir `.env.example` en `/mobile` con `API_BASE_URL`, `STRIPE_PUBLISHABLE_KEY`.
- Como el archivo real `.env` debe estar en `.gitignore`.
- Como ninguna clave real debe quedar versionada.

**Prioridad:** Alta

**Épica:** E-001

**Trazabilidad:** RNF-002, RNF-009

**Estimación:** 2 SP

---

## E-002 · Autenticación JWT

### HU-004 · Registrar cuenta de administrador

**Como:** dueño de la tienda

**Quiero:** registrarme como administrador con mi correo y contraseña

**Para:** acceder al panel de gestión de la tienda

**Criterios de aceptación:**

- Como debe aceptarse un correo válido con contraseña de al menos 8 caracteres.
- Como debe rechazarse un correo duplicado con código 409.
- Como debe rechazarse una contraseña débil con código 400.
- Como debe persistirse la contraseña con bcrypt (factor 10).
- Como debe devolverse un JWT con rol `admin` y expiración de 7 días.

**Prioridad:** Alta

**Épica:** E-002

**Trazabilidad:** RF-001, RN-008, RN-009

**Estimación:** 5 SP

---

### HU-005 · Iniciar sesión como administrador

**Como:** administrador

**Quiero:** autenticarme con mi correo y contraseña

**Para:** obtener un JWT y acceder a los endpoints protegidos

**Criterios de aceptación:**

- Como debe aceptarse credenciales válidas y devolver un JWT firmado.
- Como debe rechazarse credenciales inválidas con código 401 y mensaje genérico.
- Como el JWT debe incluir `userId` y `role: "admin"` en sus claims.
- Como el token debe expirar en 7 días.

**Prioridad:** Alta

**Épica:** E-002

**Trazabilidad:** RF-002, RN-009

**Estimación:** 3 SP

---

### HU-006 · Registrar e iniciar sesión como cliente

**Como:** cliente

**Quiero:** poder registrarme con mi correo y contraseña o comprar como invitado

**Para:** guardar mi historial de pedidos sin que sea obligatorio registrarme

**Criterios de aceptación:**

- Como debe aceptarse el registro con correo, nombre, teléfono y contraseña.
- Como debe aceptarse el flujo de compra completo sin autenticación.
- Como debe rechazarse un correo de cliente duplicado.
- Como el JWT del cliente debe contener `role: "customer"`.

**Prioridad:** Alta

**Épica:** E-002

**Trazabilidad:** RF-003, RN-010

**Estimación:** 5 SP

---

### HU-007 · Proteger endpoints con middleware JWT y roles

**Como:** sistema

**Quiero:** un middleware que valide el JWT y verifique el rol en cada endpoint protegido

**Para:** aplicar el principio de mínimo privilegio y evitar accesos no autorizados

**Criterios de aceptación:**

- Como debe rechazarse cualquier petición sin token con código 401.
- Como debe rechazarse un token expirado o con firma inválida con código 401.
- Como debe rechazarse el acceso a un endpoint con rol incorrecto con código 403.
- Como un cliente solo debe poder acceder a sus propios recursos.

**Prioridad:** Alta

**Épica:** E-002

**Trazabilidad:** RF-002, RF-003, RN-010, RNF-002

**Estimación:** 5 SP

---

## E-003 · Gestión de catálogo (categorías, productos, variantes)

### HU-008 · Crear, listar, editar y eliminar categorías

**Como:** administrador

**Quiero:** gestionar las categorías de mi catálogo (camisas, jeans, vestidos, accesorios)

**Para:** organizar mis productos y permitir que los clientes filtren por categoría

**Criterios de aceptación:**

- Como debe aceptarse la creación con nombre único.
- Como debe generarse un slug automáticamente a partir del nombre.
- Como debe rechazarse la eliminación si la categoría tiene productos asociados.
- Como debe listarse todas las categorías activas con su total de productos.

**Prioridad:** Alta

**Épica:** E-003

**Trazabilidad:** RF-004, RN-015

**Estimación:** 3 SP

---

### HU-009 · Crear, editar y listar productos del catálogo

**Como:** administrador

**Quiero:** registrar productos con nombre, descripción, precio base, categoría y estado

**Para:** publicar mi catálogo en la app móvil

**Criterios de aceptación:**

- Como debe aceptarse la creación con todos los campos obligatorios.
- Como debe rechazarse un precio menor o igual a 0.
- Como debe generarse un slug único a partir del nombre.
- Como debe poder activarse o desactivarse un producto sin eliminarlo.
- Como debe poder asociarse a una categoría existente.

**Prioridad:** Alta

**Épica:** E-003

**Trazabilidad:** RF-005, RN-003, RN-015

**Estimación:** 5 SP

---

### HU-010 · Gestionar variantes de producto (talla, color, SKU, stock)

**Como:** administrador

**Quiero:** asociar múltiples variantes (talla + color) a un producto con su stock individual

**Para:** ofrecer combinaciones específicas y controlar inventario por variante

**Criterios de aceptación:**

- Como debe aceptarse la creación de variantes con combinaciones únicas por producto.
- Como debe rechazarse la creación de variantes duplicadas (misma talla + color).
- Como debe calcularse el stock total del producto como la suma de sus variantes.
- Como debe poder modificarse el stock de cada variante individualmente.

**Prioridad:** Alta

**Épica:** E-003

**Trazabilidad:** RF-006, RN-001, RN-004

**Estimación:** 8 SP

---

## E-004 · Imágenes en Cloudflare R2

### HU-011 · Subir imagen de producto a Cloudflare R2

**Como:** administrador

**Quiero:** subir imágenes de mis productos al storage R2 y obtener una URL pública

**Para:** mostrar fotos profesionales de los productos en el catálogo

**Criterios de aceptación:**

- Como debe aceptarse la carga de imágenes JPG, PNG o WebP.
- Como debe rechazarse imágenes mayores a 5 MB con código 400.
- Como debe devolverse la URL pública del objeto subido.
- Como debe registrarse la imagen asociada al producto con su posición.

**Prioridad:** Alta

**Épica:** E-004

**Trazabilidad:** RF-007, RN-007

**Estimación:** 8 SP

---

### HU-012 · Gestionar múltiples imágenes por producto

**Como:** administrador

**Quiero:** asociar varias imágenes a un mismo producto y definir su orden

**Para:** mostrar una galería completa en la vista de detalle

**Criterios de aceptación:**

- Como debe permitirse la asociación de hasta 5 imágenes por producto.
- Como debe permitirse reordenar las imágenes (campo `position`).
- Como la primera imagen debe usarse como principal en listados.

**Prioridad:** Media

**Épica:** E-004

**Trazabilidad:** RF-007

**Estimación:** 3 SP

---

## E-005 · Catálogo público y búsqueda

### HU-013 · Listar productos del catálogo público con paginación

**Como:** cliente

**Quiero:** ver una lista paginada de productos disponibles

**Para:** explorar el catálogo desde la app móvil

**Criterios de aceptación:**

- Como deben devolverse únicamente productos activos.
- Como la paginación por defecto debe ser de 20 productos por página.
- Como cada item debe incluir nombre, precio mínimo, imagen principal y slug.
- Como debe incluirse el total de páginas en la respuesta.

**Prioridad:** Alta

**Épica:** E-005

**Trazabilidad:** RF-008

**Estimación:** 3 SP

---

### HU-014 · Filtrar por categoría y buscar por nombre

**Como:** cliente

**Quiero:** filtrar productos por categoría y buscar por coincidencia parcial en el nombre

**Para:** encontrar rápidamente lo que necesito

**Criterios de aceptación:**

- Como debe aceptarse el parámetro `category` y filtrar correctamente.
- Como debe aceptarse el parámetro `q` y devolver coincidencias parciales en el nombre.
- Como deben combinarse ambos filtros cuando se envían juntos.

**Prioridad:** Alta

**Épica:** E-005

**Trazabilidad:** RF-008

**Estimación:** 3 SP

---

### HU-015 · Ver detalle completo de un producto

**Como:** cliente

**Quiero:** ver toda la información de un producto (imágenes, descripción, variantes con stock)

**Para:** decidir si lo agrego a mi carrito

**Criterios de aceptación:**

- Como debe incluirse la galería completa de imágenes.
- Como deben incluirse todas las variantes con su talla, color y stock disponible.
- Como debe devolverse 404 si el producto no existe o está inactivo.

**Prioridad:** Alta

**Épica:** E-005

**Trazabilidad:** RF-009

**Estimación:** 3 SP

---

## E-006 · Carrito de compras

### HU-016 · Agregar producto variante al carrito

**Como:** cliente

**Quiero:** agregar un producto (con talla y color seleccionados) a mi carrito

**Para:** acumular productos antes de pagar

**Criterios de aceptación:**

- Como debe aceptarse agregar una variante con cantidad válida.
- Como debe rechazarse agregar más cantidad que el stock disponible.
- Como debe asociarse el carrito al cliente autenticado o a un `session_id` si es invitado.
- Como debe calcularse el subtotal del carrito tras la operación.

**Prioridad:** Alta

**Épica:** E-006

**Trazabilidad:** RF-010, RN-011

**Estimación:** 5 SP

---

### HU-017 · Modificar cantidades y eliminar items del carrito

**Como:** cliente

**Quiero:** ajustar la cantidad de cada item o eliminar productos de mi carrito

**Para:** revisar mi compra antes de pagar

**Criterios de aceptación:**

- Como debe aceptarse la actualización de cantidad con su recálculo automático.
- Como debe aceptarse la eliminación de items individuales.
- Como debe aceptarse el vaciado completo del carrito.
- Como debe rechazarse una cantidad mayor al stock disponible.

**Prioridad:** Alta

**Épica:** E-006

**Trazabilidad:** RF-010, RN-001

**Estimación:** 3 SP

---

## E-007 · Checkout y pago con Stripe

### HU-018 · Iniciar checkout y crear PaymentIntent en Stripe

**Como:** cliente

**Quiero:** confirmar mi carrito y obtener un `client_secret` de Stripe

**Para:** proceder al pago desde la app móvil

**Criterios de aceptación:**

- Como debe rechazarse el checkout si el carrito está vacío con código 400.
- Como debe verificarse la coherencia entre el total del carrito y la suma de items.
- Como debe crearse una orden en estado `pendiente` con el `payment_intent_id`.
- Como debe devolverse el `client_secret` para confirmar el pago desde la app.

**Prioridad:** Alta

**Épica:** E-007

**Trazabilidad:** RF-011, RN-012

**Estimación:** 8 SP

---

### HU-019 · Confirmar pago y actualizar orden a `pagado` (sin webhook)

**Como:** cliente

**Quiero:** introducir los datos de mi tarjeta de prueba y completar el pago

**Para:** finalizar mi compra

**Criterios de aceptación:**

- Como debe aceptarse el pago con tarjeta `4242 4242 4242 4242`.
- Como debe rechazarse el pago con tarjeta `4000 0000 0000 9995` (fondos insuficientes).
- Como al confirmarse el pago, la orden debe pasar a estado `pagado`.
- Como debe decrementarse el stock de las variantes tras la confirmación.
- Como debe vaciarse el carrito del cliente tras el pago exitoso.

**Prioridad:** Alta

**Épica:** E-007

**Trazabilidad:** RF-011, RN-005, RN-006

**Estimación:** 8 SP

---

## E-008 · Gestión de pedidos

### HU-020 · Listar y filtrar pedidos como administrador

**Como:** administrador

**Quiero:** ver todos los pedidos recibidos con filtros por estado y fecha

**Para:** gestionarlos eficientemente

**Criterios de aceptación:**

- Como deben listarse los pedidos con paginación.
- Como debe aceptarse el filtro por estado (`pendiente`, `pagado`, `enviado`, `entregado`).
- Como debe aceptarse el filtro por rango de fechas.
- Como cada item debe incluir el total, datos del cliente y fecha de creación.

**Prioridad:** Alta

**Épica:** E-008

**Trazabilidad:** RF-012

**Estimación:** 5 SP

---

### HU-021 · Cambiar estado de un pedido siguiendo la secuencia

**Como:** administrador

**Quiero:** actualizar el estado de un pedido conforme avanza el flujo logístico

**Para:** mantener informado al cliente sobre su compra

**Criterios de aceptación:**

- Como debe aceptarse el cambio en orden secuencial: pendiente → pagado → enviado → entregado.
- Como debe rechazarse un cambio que rompa la secuencia con código 400.
- Como debe aceptarse la cancelación solo en estado `pendiente` o `pagado`.

**Prioridad:** Alta

**Épica:** E-008

**Trazabilidad:** RF-012, RN-002

**Estimación:** 3 SP

---

### HU-022 · Consultar historial de pedidos como cliente

**Como:** cliente autenticado

**Quiero:** ver mis pedidos anteriores con su estado y detalle

**Para:** hacer seguimiento a mis compras

**Criterios de aceptación:**

- Como deben devolverse únicamente los pedidos del cliente autenticado.
- Como debe incluirse el detalle de cada pedido (items, total, estado).
- Como debe rechazarse cualquier intento de consultar pedidos de otro cliente con código 403.

**Prioridad:** Media

**Épica:** E-008

**Trazabilidad:** RF-013, RN-010

**Estimación:** 3 SP

---

## E-009 · Control de inventario

### HU-023 · Decrementar stock de variantes al confirmar pago

**Como:** sistema

**Quiero:** descontar automáticamente el stock de las variantes cuando se confirma el pago de un pedido

**Para:** mantener la coherencia del inventario

**Criterios de aceptación:**

- Como debe decrementarse el stock de cada variante involucrada en el pedido.
- Como la operación debe ser atómica para evitar condiciones de carrera.
- Como debe rechazarse y revertir si alguna variante no tiene stock suficiente.
- Como el pedido debe marcarse como `fallido` y notificarse al cliente en ese caso.

**Prioridad:** Alta

**Épica:** E-009

**Trazabilidad:** RF-014, RN-001, RN-005

**Estimación:** 5 SP

---

### HU-024 · Ver alertas de stock bajo en el dashboard

**Como:** administrador

**Quiero:** ver alertas automáticas cuando el stock de una variante cae por debajo del umbral

**Para:** reabastecer a tiempo

**Criterios de aceptación:**

- Como debe generarse una alerta cuando el stock caiga por debajo de 5 unidades.
- Como deben listarse las alertas activas en el dashboard.
- Como la alerta debe resolverse automáticamente cuando se reponga el stock.

**Prioridad:** Media

**Épica:** E-009

**Trazabilidad:** RF-015, RN-001

**Estimación:** 3 SP

---

## E-010 · Dashboard de ventas y analítica

### HU-025 · Ver métricas generales de ventas

**Como:** administrador

**Quiero:** ver ventas totales, número de pedidos y ticket promedio en un rango de fechas

**Para:** entender el rendimiento de mi tienda

**Criterios de aceptación:**

- Como deben devolverse las ventas totales en el rango solicitado.
- Como debe devolverse el número de pedidos en estado `pagado` o superior.
- Como debe calcularse el ticket promedio (ventas totales / número de pedidos).
- Como debe aceptarse el filtro por día, semana, mes o rango personalizado.

**Prioridad:** Alta

**Épica:** E-010

**Trazabilidad:** RF-018

**Estimación:** 5 SP

---

### HU-026 · Ver top productos más vendidos y pedidos por estado

**Como:** administrador

**Quiero:** identificar los productos más vendidos y la distribución de pedidos por estado

**Para:** tomar decisiones de inventario y operación

**Criterios de aceptación:**

- Como deben devolverse los top 5 productos más vendidos en el período.
- Como debe graficarse la distribución de pedidos por estado.
- Como debe incluirse la evolución temporal de ventas (ventas por día).

**Prioridad:** Media

**Épica:** E-010

**Trazabilidad:** RF-018

**Estimación:** 5 SP

---

## E-011 · Aplicación móvil Flutter

### HU-027 · Configurar proyecto Flutter con arquitectura limpia y design system

**Como:** desarrollador móvil

**Quiero:** un proyecto Flutter con Riverpod, GoRouter, Freezed y un sistema de diseño base

**Para:** acelerar el desarrollo de pantallas y mantener consistencia visual

**Criterios de aceptación:**

- Como debe existir `/mobile` con Flutter inicializado.
- Como deben configurarse las dependencias: `flutter_riverpod`, `dio`, `freezed`, `go_router`, `cached_network_image`.
- Como debe existir un theme con Material 3 y paleta de colores de SmartPyME.
- Como debe existir un `dio_client` configurado con interceptor de JWT.

**Prioridad:** Alta

**Épica:** E-011

**Trazabilidad:** RNF-006, RNF-007

**Estimación:** 5 SP

---

### HU-028 · Implementar onboarding, login y navegación principal del cliente

**Como:** cliente

**Quiero:** ver una introducción, autenticarme y navegar entre las pantallas principales

**Para:** empezar a usar la app

**Criterios de aceptación:**

- Como deben existir 3 pantallas de onboarding.
- Como deben existir pantallas de login y registro (cliente y admin en rutas distintas).
- Como la navegación principal del cliente debe usar bottom navigation con 4 tabs: Inicio, Catálogo, Carrito, Perfil.
- Como el estado de autenticación debe persistir tras cerrar la app.

**Prioridad:** Alta

**Épica:** E-011

**Trazabilidad:** RNF-004, RNF-006

**Estimación:** 8 SP

---

### HU-029 · Implementar flujo de catálogo y checkout en el cliente

**Como:** cliente

**Quiero:** navegar el catálogo, ver detalle, agregar al carrito y pagar

**Para:** completar una compra end-to-end

**Criterios de aceptación:**

- Como debe existir la pantalla de catálogo con grid de productos y filtros.
- Como debe existir la pantalla de detalle con selector de variante y agregar al carrito.
- Como debe existir la pantalla de carrito con edición de cantidades.
- Como debe existir la pantalla de checkout con el formulario de envío y `flutter_stripe` para el pago.

**Prioridad:** Alta

**Épica:** E-011

**Trazabilidad:** RF-008, RF-009, RF-010, RF-011

**Estimación:** 13 SP

---

### HU-030 · Implementar panel de administración en Flutter

**Como:** administrador

**Quiero:** gestionar productos, pedidos y ver el dashboard desde la app

**Para:** operar la tienda desde mi celular

**Criterios de aceptación:**

- Como debe existir la pantalla de dashboard con métricas clave.
- Como debe existir la lista de pedidos con cambio de estado.
- Como debe existir la lista de productos con creación, edición e imágenes.
- Como el panel admin debe tener su propia bottom navigation: Dashboard, Productos, Pedidos, Tickets.

**Prioridad:** Alta

**Épica:** E-011

**Trazabilidad:** RF-005, RF-012, RF-018

**Estimación:** 13 SP

---

## E-012 · Seed, despliegue y demo

### HU-031 · Crear script de seed con datos de prueba

**Como:** desarrollador

**Quiero:** un script que cargue productos, categorías, imágenes y un admin de ejemplo

**Para:** tener datos realistas para la demo y el desarrollo

**Criterios de aceptación:**

- Como el seed debe crear 1 admin, 4 categorías (Camisas, Jeans, Vestidos, Accesorios) y 12-15 productos.
- Como cada producto debe tener 3-5 variantes con tallas y colores.
- Como las imágenes deben descargarse de URLs públicas de Unsplash.
- Como el script debe ser idempotente (puede ejecutarse múltiples veces).

**Prioridad:** Alta

**Épica:** E-012

**Trazabilidad:** Criterios de aceptación globales

**Estimación:** 5 SP

---

### HU-032 · Preparar demo end-to-end y materiales de sustentación

**Como:** desarrollador

**Quiero:** un guion de demo y los materiales de presentación listos

**Para:** sustentar el proyecto con éxito

**Criterios de aceptación:**

- Como debe existir un README con instrucciones de `git clone` → `docker compose up` → `bun run dev` → `flutter run`.
- Como debe existir un script de demo con los pasos exactos a seguir.
- Como el APK debe estar compilado o el emulador listo para la presentación.

**Prioridad:** Alta

**Épica:** E-012

**Trazabilidad:** Criterios de aceptación globales

**Estimación:** 3 SP

---

# Tareas técnicas

## E-001 · Configuración del monorepo y entorno

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-001 | Inicializar repositorio Git y estructura `/backend` y `/mobile` | E-001 | Setup | Alta | Pendiente |
| T-002 | Crear `package.json` raíz con scripts (`dev`, `build`, `lint`) | E-001 | Setup | Alta | Pendiente |
| T-003 | Configurar `bun` y `tsconfig.json` en `/backend` | E-001 | Setup | Alta | Pendiente |
| T-004 | Crear `docker-compose.yml` con servicios auxiliares | E-001 | Setup | Media | Pendiente |
| T-005 | Crear `.env.example` para backend y mobile | E-001 | Setup | Alta | Pendiente |
| T-006 | Escribir README raíz con instrucciones de instalación | E-001 | Setup | Alta | Pendiente |
| T-007 | Configurar ESLint + Prettier en backend | E-001 | Setup | Media | Pendiente |
| T-008 | Configurar `flutter_lints` en mobile | E-011 | Setup | Media | Pendiente |

## E-002 · Autenticación JWT

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-010 | Diseñar schema Drizzle para `users` y `customers` | E-002 | Datos | Alta | Pendiente |
| T-011 | Crear `AuthService` en domain (interfaces) | E-002 | Backend | Alta | Pendiente |
| T-012 | Implementar `AuthRepository` con Drizzle adapter | E-002 | Backend | Alta | Pendiente |
| T-013 | Crear `RegisterUserUseCase` y `LoginUserUseCase` | E-002 | Backend | Alta | Pendiente |
| T-014 | Implementar middleware JWT de Hono con validación de rol | E-002 | Backend | Alta | Pendiente |
| T-015 | Crear rutas `POST /auth/register` y `POST /auth/login` | E-002 | Backend | Alta | Pendiente |
| T-016 | Validar inputs con Zod en todos los endpoints de auth | E-002 | Backend | Alta | Pendiente |
| T-017 | Tests unitarios de `LoginUserUseCase` y hashing bcrypt | E-002 | QA | Media | Pendiente |

## E-003 · Catálogo (categorías, productos, variantes)

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-020 | Diseñar schemas Drizzle: `categories`, `products`, `product_variants` | E-003 | Datos | Alta | Pendiente |
| T-021 | Crear entidades de dominio y value objects (Price, SKU, Slug) | E-003 | Backend | Alta | Pendiente |
| T-022 | Implementar `CategoryRepository` (Drizzle adapter) | E-003 | Backend | Alta | Pendiente |
| T-023 | Implementar `ProductRepository` con paginación y filtros | E-003 | Backend | Alta | Pendiente |
| T-024 | Crear use cases: `CreateProduct`, `ListProducts`, `UpdateStock` | E-003 | Backend | Alta | Pendiente |
| T-025 | Generar slug automáticamente desde el nombre (sin acentos) | E-003 | Lógica | Alta | Pendiente |
| T-026 | Crear rutas REST: `/categories`, `/products`, `/products/:id` | E-003 | Backend | Alta | Pendiente |
| T-027 | Validar con Zod: precio > 0, combinación única variante | E-003 | Backend | Alta | Pendiente |
| T-028 | Tests unitarios de creación de producto y validación de stock | E-003 | QA | Media | Pendiente |

## E-004 · Imágenes en Cloudflare R2

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-030 | Configurar cliente S3 (`@aws-sdk/client-s3`) con endpoint R2 | E-004 | Backend | Alta | Pendiente |
| T-031 | Implementar servicio `StorageService` con métodos `upload`, `delete` | E-004 | Backend | Alta | Pendiente |
| T-032 | Diseñar schema Drizzle para `product_images` | E-004 | Datos | Alta | Pendiente |
| T-033 | Crear ruta `POST /products/:id/images` con multipart | E-004 | Backend | Alta | Pendiente |
| T-034 | Validar formato (JPG/PNG/WebP) y tamaño máximo 5 MB | E-004 | Backend | Alta | Pendiente |
| T-035 | Generar URL pública configurable vía `R2_PUBLIC_URL` | E-004 | Backend | Alta | Pendiente |

## E-005 · Catálogo público

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-040 | Crear endpoint público `GET /catalog/products` con paginación | E-005 | Backend | Alta | Pendiente |
| T-041 | Implementar filtro por categoría y búsqueda por nombre | E-005 | Backend | Alta | Pendiente |
| T-042 | Crear endpoint `GET /catalog/products/:slug` con detalle completo | E-005 | Backend | Alta | Pendiente |
| T-043 | Excluir productos inactivos en endpoints públicos | E-005 | Backend | Alta | Pendiente |
| T-044 | Incluir URL de imagen principal y precio mínimo en listado | E-005 | Backend | Alta | Pendiente |

## E-006 · Carrito de compras

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-050 | Diseñar schemas Drizzle: `carts`, `cart_items` | E-006 | Datos | Alta | Pendiente |
| T-051 | Implementar `CartRepository` con soporte de sesión anónima | E-006 | Backend | Alta | Pendiente |
| T-052 | Use cases: `AddToCart`, `UpdateCartItem`, `RemoveFromCart` | E-006 | Backend | Alta | Pendiente |
| T-053 | Crear rutas: `POST /cart/items`, `PATCH /cart/items/:id`, `DELETE /cart/items/:id` | E-006 | Backend | Alta | Pendiente |
| T-054 | Validar stock disponible al agregar/actualizar items | E-006 | Backend | Alta | Pendiente |
| T-055 | Calcular subtotal y total del carrito en cada operación | E-006 | Lógica | Alta | Pendiente |

## E-007 · Checkout y Stripe

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-060 | Diseñar schemas Drizzle: `orders`, `order_items`, `payments` | E-007 | Datos | Alta | Pendiente |
| T-061 | Configurar SDK de Stripe con `STRIPE_SECRET_KEY` | E-007 | Backend | Alta | Pendiente |
| T-062 | Crear `OrderService` con máquina de estados de pedido | E-007 | Backend | Alta | Pendiente |
| T-063 | Use case `CreateCheckout`: crea orden + PaymentIntent | E-007 | Backend | Alta | Pendiente |
| T-064 | Use case `ConfirmPayment`: actualiza orden a `pagado` + decrementa stock | E-007 | Backend | Alta | Pendiente |
| T-065 | Crear ruta `POST /checkout` que devuelve `client_secret` | E-007 | Backend | Alta | Pendiente |
| T-066 | Crear ruta `POST /payments/confirm` (sin webhook, llamada desde app) | E-007 | Backend | Alta | Pendiente |
| T-067 | Validar coherencia del total antes de crear el PaymentIntent | E-007 | Backend | Alta | Pendiente |
| T-068 | Tests unitarios de `ConfirmPayment` y rollback de stock | E-007 | QA | Alta | Pendiente |

## E-008 · Gestión de pedidos

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-070 | Crear endpoint `GET /orders` con filtros por estado y fecha | E-008 | Backend | Alta | Pendiente |
| T-071 | Crear endpoint `GET /orders/:id` con detalle completo | E-008 | Backend | Alta | Pendiente |
| T-072 | Implementar `PATCH /orders/:id/status` con validación de transición | E-008 | Backend | Alta | Pendiente |
| T-073 | Crear endpoint `GET /customers/me/orders` para historial del cliente | E-008 | Backend | Media | Pendiente |
| T-074 | Middleware que valida que el cliente solo vea sus propios pedidos | E-008 | Backend | Alta | Pendiente |

## E-009 · Control de inventario

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-080 | Crear `StockService` con operación atómica de decremento | E-009 | Backend | Alta | Pendiente |
| T-081 | Diseñar schema `stock_alerts` y `stock_movements` | E-009 | Datos | Media | Pendiente |
| T-082 | Hook post-decremento que genera alerta si stock < 5 | E-009 | Backend | Media | Pendiente |
| T-083 | Crear endpoint `GET /inventory/alerts` para admin | E-009 | Backend | Media | Pendiente |
| T-084 | Tests unitarios de operación atómica con concurrencia | E-009 | QA | Alta | Pendiente |

## E-010 · Dashboard

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-090 | Crear `DashboardService` con queries agregadas | E-010 | Backend | Alta | Pendiente |
| T-091 | Endpoint `GET /dashboard/metrics?from&to` con ventas y ticket promedio | E-010 | Backend | Alta | Pendiente |
| T-092 | Endpoint `GET /dashboard/top-products?from&to` | E-010 | Backend | Media | Pendiente |
| T-093 | Endpoint `GET /dashboard/orders-by-status` | E-010 | Backend | Media | Pendiente |
| T-094 | Endpoint `GET /dashboard/sales-timeline?from&to&granularity` | E-010 | Backend | Media | Pendiente |

## E-011 · App móvil Flutter

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-100 | Crear proyecto Flutter y configurar `pubspec.yaml` | E-011 | Frontend | Alta | Pendiente |
| T-101 | Configurar Riverpod, GoRouter, Dio, Freezed, flutter_stripe | E-011 | Frontend | Alta | Pendiente |
| T-102 | Implementar `DioClient` con interceptor JWT y refresh | E-011 | Frontend | Alta | Pendiente |
| T-103 | Crear theme Material 3 con paleta de SmartPyME | E-011 | Frontend | Alta | Pendiente |
| T-104 | Crear `AuthRepository` y `AuthNotifier` con Riverpod | E-011 | Frontend | Alta | Pendiente |
| T-105 | Pantallas de onboarding y login/registro | E-011 | Frontend | Alta | Pendiente |
| T-106 | Bottom navigation del cliente (4 tabs) | E-011 | Frontend | Alta | Pendiente |
| T-107 | Pantalla de catálogo con grid + filtros + búsqueda | E-011 | Frontend | Alta | Pendiente |
| T-108 | Pantalla de detalle de producto con selector de variante | E-011 | Frontend | Alta | Pendiente |
| T-109 | Pantalla de carrito con edición de cantidades | E-011 | Frontend | Alta | Pendiente |
| T-110 | Pantalla de checkout con formulario de envío | E-011 | Frontend | Alta | Pendiente |
| T-111 | Integrar `flutter_stripe` con `client_secret` del backend | E-011 | Frontend | Alta | Pendiente |
| T-112 | Pantalla de confirmación post-pago con número de pedido | E-011 | Frontend | Alta | Pendiente |
| T-113 | Pantalla de mis pedidos (cliente) | E-011 | Frontend | Media | Pendiente |
| T-114 | Bottom navigation del admin (4 tabs) | E-011 | Frontend | Alta | Pendiente |
| T-115 | Pantalla de dashboard con métricas y gráficos | E-011 | Frontend | Alta | Pendiente |
| T-116 | Pantalla de lista de pedidos del admin con cambio de estado | E-011 | Frontend | Alta | Pendiente |
| T-117 | Pantalla de gestión de productos (CRUD + upload imagen) | E-011 | Frontend | Alta | Pendiente |
| T-118 | Persistir JWT con `flutter_secure_storage` | E-011 | Frontend | Alta | Pendiente |

## E-012 · Seed, despliegue y demo

| ID | Tarea | Épica | Tipo | Prioridad | Estado |
| -- | ----- | ----- | ---- | --------- | ------ |
| T-130 | Crear script `bun run seed` con `db:push` + inserts | E-012 | Datos | Alta | Pendiente |
| T-131 | Seed de admin (`admin@smartpyme.com` / `admin123`) | E-012 | Datos | Alta | Pendiente |
| T-132 | Seed de 4 categorías y 12-15 productos con variantes | E-012 | Datos | Alta | Pendiente |
| T-133 | Descargar imágenes de Unsplash y subirlas a R2 durante el seed | E-012 | Datos | Alta | Pendiente |
| T-134 | Documentar flujo de demo paso a paso en README | E-012 | QA | Alta | Pendiente |
| T-135 | Compilar APK debug o preparar emulador para sustentación | E-012 | Setup | Alta | Pendiente |


# Priorización (MoSCoW)

## Must (imprescindible para v1)

**Historias de usuario:**

- HU-001, HU-003, HU-004, HU-005, HU-006, HU-007 (Setup + Auth completo).
- HU-008, HU-009, HU-010 (CRUD de catálogo).
- HU-011 (Upload de imágenes a R2).
- HU-013, HU-014, HU-015 (Catálogo público).
- HU-016, HU-017 (Carrito).
- HU-018, HU-019 (Checkout y Stripe).
- HU-020, HU-021 (Gestión de pedidos).
- HU-023 (Decremento de stock).
- HU-025 (Métricas generales).
- HU-027, HU-028, HU-029, HU-030 (App móvil: setup, login, flujo cliente, panel admin).
- HU-031, HU-032 (Seed y demo).

**Tareas técnicas:** T-001 a T-003, T-005, T-006, T-010 a T-016, T-020 a T-027, T-030 a T-035, T-040 a T-044, T-050 a T-055, T-060 a T-067, T-070 a T-074, T-080, T-100 a T-118, T-130 a T-135.

## Should (importante, deseable en v1)

- HU-012 (Múltiples imágenes por producto).
- HU-022 (Historial de pedidos del cliente).
- HU-024 (Alertas de stock bajo).
- HU-026 (Top productos y pedidos por estado).
- T-017, T-028, T-068, T-084 (Tests unitarios críticos).
- T-007, T-008 (Linters).

## Could (mejoras, post-v1)

- HU-002 (Docker Compose con MinIO como fallback).
- T-004 (Docker Compose completo).
- T-073 (Endpoint de historial del cliente si el tiempo lo permite).
- T-081 a T-083 (Tabla de alertas y movimientos de stock, se puede hacer más simple).
- T-090 a T-094 (Dashboard backend completo; se puede reducir a métricas básicas).
- Internacionalización de la app.
- Tema dark mode.
- Caché de imágenes persistente.

## Won't (fuera de v1)

- E-013 Chatbot IA local: recortado por tiempo. La HU-016 del documento de alcance queda sin implementar.
- E-014 Tickets de soporte: recortado por tiempo. La HU-017 del documento de alcance queda sin implementar.
- Multi-tenant.
- WebSockets para chat en tiempo real.
- Notificaciones push.
- Sistema de reseñas.
- Programa de fidelización.
- Multi-idioma.
- Integración con operadores logísticos.
- Webhook real de Stripe (se usa confirmación manual desde la app para simplificar).
- Panel de administración web.

- Como cada historia o tarea debe clasificarse en una sola categoría MoSCoW.
- Como la categoría "Must" debe representar el mínimo producto viable de la versión.
- Como las categorías "Should" y "Could" se implementan solo si el tiempo lo permite durante la semana.

## Hitos sugeridos

| Hito | Alcance | Fecha objetivo |
| ---- | ------- | -------------- |
| H1 | Backend funcional con auth + productos + DB operativa + Docker Compose listo | Final Fase 1 (día 2) |
| H2 | Backend completo con carrito, pedidos, Stripe sandbox y seed cargado | Final Fase 2 (día 4) |
| H3 | App cliente Flutter end-to-end: catálogo → carrito → checkout → mis pedidos | Final Fase 3 (día 6) |
| H4 | Panel admin Flutter + dashboard + demo compilada y guion listo | Final Fase 4 (día 7) |

- Como cada hito debe representar un incremento verificable del producto.
- Como los hitos deben ordenarse de forma lógica respetando dependencias técnicas.


# Dependencias

## Librerías nuevas

### Backend (Bun)

- `hono` (`^4.x` — framework web minimalista sobre Bun).
- `drizzle-orm` (`^0.30+` — ORM type-safe).
- `drizzle-kit` (`^0.20+` — CLI para migraciones).
- `@libsql/client` (`^0.10+` — driver SQLite/libsql).
- `zod` (`^3.22+` — validación de esquemas).
- `bcrypt` (`^5.x` — hashing de contraseñas).
- `jose` (`^5.x` — JWT moderno, edge-friendly).
- `stripe` (`^14+` — SDK oficial de Stripe).
- `@aws-sdk/client-s3` (`^3.x` — cliente S3 para Cloudflare R2).
- `dotenv` (`^16+` — carga de variables de entorno).
- `pino` (`^8+` — logger estructurado).
- `pino-pretty` (`^10+` — formateador de logs en dev).
- `vitest` (`^1+` — framework de tests unitarios).

### Mobile (Flutter)

- `flutter_riverpod` (`^2.5+` — state management).
- `riverpod_annotation` (`^2.3+` — generador de providers).
- `dio` (`^5+` — cliente HTTP).
- `freezed` (`^2.5+` — modelos inmutables).
- `freezed_annotation` (`^2.4+`).
- `json_serializable` (`^6.7+`).
- `json_annotation` (`^4.8+`).
- `build_runner` (`^2.4+` — code generation).
- `go_router` (`^14+` — routing declarativo).
- `flutter_stripe` (`^11+` — SDK Flutter de Stripe).
- `cached_network_image` (`^3.3+` — caché de imágenes).
- `image_picker` (`^1+` — selección de imágenes desde galería/cámara).
- `flutter_secure_storage` (`^9+` — almacenamiento seguro del JWT).
- `intl` (`^0.19+` — formateo de fechas y moneda).
- `fl_chart` (`^0.68+` — gráficos para el dashboard).

## Librerías existentes reutilizadas

- `typescript` (`^5+` — tipado estático en backend).
- `bun-types` (tipos oficiales de Bun).
- `flutter` (`^3.16+` — SDK base).
- `dart` (`^3.2+`).

## Externas (servicios requeridos en alcance)

- **Cloudflare R2:** almacenamiento de imágenes. Requiere `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_BUCKET`, `R2_PUBLIC_URL`. Tier gratuito de 10 GB/mes.
- **Stripe (sandbox):** procesamiento de pagos. Requiere `STRIPE_SECRET_KEY` y `STRIPE_PUBLISHABLE_KEY` de test (empiezan por `sk_test_` y `pk_test_`).

## Externas (no agregar en v1)

- Firebase (se evalúa en versiones futuras si se requiere autenticación social).
- Google Gemini API (para el chatbot que queda fuera de v1).
- SendGrid / Resend (para emails transaccionales).
- Servicios de logística (Skydropx, Envia, etc.).

## Assets

- **Imágenes de productos:** obtenidas de [Unsplash](https://unsplash.com) (libre de derechos) para el seed. Categorías: ropa, moda, accesorios.
- **Logo de SmartPyME:** diseño propio o tipografía `Inter` / `Plus Jakarta Sans` para el wordmark.
- **Iconografía:** `lucide-react` o `Material Symbols` (gratuitos).

- Como cada dependencia nueva debe justificarse con su propósito concreto.
- Como las dependencias externas deben clasificarse claramente como "en alcance" o "fuera de alcance".
- Como las claves de servicios externos nunca deben versionarse en `.git`.


# Riesgos

| ID | Riesgo | Impacto | Probabilidad | Mitigación |
| -- | ------ | ------- | ------------ | ---------- |
| R-001 | Stripe en sandbox sin webhook real puede fallar por timing entre la confirmación del SDK y el estado de la orden | Alto | Media | Implementar `POST /payments/confirm` que consulta directamente a Stripe el estado del PaymentIntent antes de actualizar la orden. Documentar el flujo manual como respaldo. |
| R-002 | Cloudflare R2 requiere credenciales válidas; si fallan no se cargan imágenes | Alto | Media | Validar credenciales al inicio con un script de health check. Si fallan, degradar a imágenes placeholder servidas desde el backend. |
| R-003 | Tiempo insuficiente para implementar panel admin Flutter con la misma calidad que el cliente | Alto | Alta | Priorizar el flujo del cliente (catálogo → carrito → pago). El panel admin se reduce a: lista de pedidos con cambio de estado + lista de productos con creación rápida. |
| R-004 | Errores en migraciones Drizzle que rompan el seed o el desarrollo | Alto | Baja | Usar `drizzle-kit generate` para migraciones versionadas, mantener un script `db:reset` que elimine y recree la DB. Probar siempre con seed reset. |
| R-005 | Build de APK Flutter puede fallar en Linux por dependencias nativas (Stripe, secure storage) | Medio | Media | Compilar y probar con suficiente anticipación. Tener como backup la demo en navegador web (`flutter run -d chrome`) o en emulador Android local. |
| R-006 | Burnout o bloqueo del desarrollador único durante la semana | Alto | Media | Planificar la Fase 4 como buffer (solo polish, no features nuevas). Si una fase se atrasa, las Should/Could se recortan primero. |
| R-007 | Inconsistencias en el manejo de stock bajo concurrencia (race conditions) | Alto | Baja | Implementar la operación de decremento como transacción SQLite con `BEGIN IMMEDIATE`. Tests unitarios que simulan concurrencia. |
| R-008 | Errores en el formateo de moneda, fechas o zona horaria entre backend y Flutter | Bajo | Media | Usar `intl` en Flutter y formatear en el backend con ISO 8601. Definir zona horaria única (UTC en backend, local en app). |

- Como cada riesgo debe tener una mitigación concreta y ejecutable.
- Como los riesgos deben revisarse al inicio de cada fase del proyecto.
