# 📋 Estado de Funcionalidades · SmartPyME

Este documento detalla el estado actual de las funcionalidades del proyecto **SmartPyME** (tanto en el **Backend** como en la aplicación **Móvil**) a fecha del **5 de julio de 2026**.

---

## 🟢 Funcionalidades Terminadas (Completadas)

### 1. Configuración de Entorno y Tooling Base
*   **Monorepo estructurado:** Organización clara en `/backend` y `/mobile`.
*   **Gestión de Dependencias y Scripts:** Configuración de Bun en el backend y dependencias móviles estables (Riverpod 2.5.1, Dio, Stripe, GoRouter).
*   **Linter & Calidad de Código:** 
    *   **Backend:** Configuración de ESLint con validación de sintaxis estricta TSDoc (`tsdoc/syntax`) y obligatoriedad de documentación para miembros públicos (`jsdoc/require-jsdoc`).
    *   **Móvil:** Configuración de `flutter_lints` con la regla de documentación de APIs públicas (`public_member_api_docs`).
*   **Pruebas Unitarias Co-located (DDD):**
    *   **Backend:** Tests unitarios e instrumentación configurada con Vitest localizados junto a la lógica de negocio (31 pruebas exitosas).
    *   **Móvil:** Tests unitarios de controladores y fallas integrados en la estructura de características.

### 2. Autenticación y Autorización
*   **Control de Accesos:** Endpoints para registro e inicio de sesión de clientes y administradores con contraseñas seguras (hashing con `bcrypt` en factor 10).
*   **Seguridad JWT:** Middleware JWT de Hono para proteger endpoints y validar roles específicos (`admin` o `customer`).

### 3. Gestión de Catálogo y Almacenamiento
*   **Gestión de Productos:** Creación, edición y borrado lógico de productos, categorías y variantes (talla, color, SKU y stock) con slugs URL-friendly autogenerados.
*   **Carga de Imágenes:** Integración con Cloudflare R2 y fallback a sistema de archivos local para la carga de imágenes con límite estricto de 5 MB.
*   **Búsqueda y Filtros:** Endpoints públicos paginados con soporte para búsqueda por nombre y filtrado por categoría.

### 4. Carrito de Compras y Checkout
*   **Carrito Persistente:** Soporte para carritos de clientes autenticados e invitados, validando el stock de forma dinámica antes de permitir agregados.
*   **Pasarela de Pago (Stripe Sandbox):** Integración con Stripe en modo test para la creación de un `PaymentIntent` y la obtención de un `clientSecret`.
*   **Confirmación de Pago:** Procesamiento del éxito de pago, decremento atómico de stock (evitando condiciones de carrera) y vaciado automático de carrito.

### 5. Control de Inventario y Pedidos
*   **Logs y Movimientos de Stock:** Registro histórico de cada movimiento (venta, reabastecimiento, cancelación).
*   **Alertas de Stock Bajo:** Generación de alertas cuando el stock baja de 5 unidades.
*   **Reabastecimiento:** Endpoint de reabastecimiento (`/api/inventory/restock`) para incrementar stock de variantes y resolver automáticamente alertas activas.
*   **Secuencia de Pedidos:** Máquina de estados para pedidos (pendiente → pagado → enviado → entregado) con reabastecimiento automático en cancelaciones de pedidos pagados.
*   **Webhooks de Stripe (¡Nuevo!):** Endpoint `/api/payments/webhook` en [OrdersController.ts](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/backend/src/orders/adapters/OrdersController.ts) para verificar firmas Stripe y procesar eventos asíncronos (`payment_intent.succeeded` y `payment_intent.payment_failed`) de manera segura.

### 6. Rediseño Estético de Interfaces (Móvil Flutter - ¡Nuevo!)
*   **Refactorización Completa de Pantallas según Mockups de `/will`:**
    *   **Cliente - Tema Claro (Purpura/Hueso):** Rediseño total de la pantalla de detalle de producto ([product_detail_page.dart](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/lib/features/catalog/presentation/pages/product_detail_page.dart)) alineado a `will/onboarding-screen` (cabecera con controles flotantes, Choice Chips circulares customizados para tallas/colores, perks card de compras y stepper flotante en barra de acción).
    *   **Administrador - Tema Oscuro (Tech Slate Blue):** Rediseño total del gestor de pedidos ([admin_orders_page.dart](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/lib/features/orders/presentation/pages/admin_orders_page.dart)) basado en `will/product-creation-form` (estadísticas resumidas, iniciales de clientes con colores dinámicos, detalles de compra expandibles y cambio secuencial de estados con chips personalizados).
*   **Doble Sistema de Temas Dinámico:** El cliente móvil cambia dinámicamente de tema en [main.dart](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/lib/main.dart) al detectar el rol del usuario autenticado:
    *   **Rol de Cliente / No autenticado:** Carga el tema claro de Material 3 con primarios purpuras (`0xFF6750A4`) y fondos crema.
    *   **Rol de Administrador:** Carga el tema oscuro moderno de tecnología con primarios indigo (`0xFF818CF8`) y fondos pizarra (`0xFF080D1A`).

### 7. Completo Set de Pruebas Móvil (Flutter - ¡Nuevo!)
*   **Pruebas Unitarias Robustas:**
    *   [auth_provider_test.dart](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/lib/features/auth/presentation/providers/test/auth_provider_test.dart) para el manejo de estados de sesión, inicio/cierre de sesión y errores.
    *   [cart_provider_test.dart](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/lib/features/cart/presentation/providers/test/cart_provider_test.dart) para verificar agregación de variantes, carga inicial y alteración de cantidades del carrito.
    *   [failures_test.dart](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/lib/core/errors/test/failures_test.dart) para validar los tipos de fallas arrojadas por la capa de datos.
*   **Pruebas de Integración y Flujo E2E:**
    *   [app_integration_test.dart](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/lib/core/test/app_integration_test.dart) que simula el flujo de navegación de un usuario real partiendo del Onboarding, ingresando credenciales en Login y validando el renderizado de la pantalla de inicio con los items de la base de datos simulada.
*   **Prueba de Sistemas (Automática & Manual):**
    *   Elaboración de una completa guía paso a paso para el arranque local, configuración de red y datos de prueba para realizar la validación final del software.

---

## 🟡 Funcionalidades Pendientes y Trabajo Futuro

### 1. Variables de Producción y Credenciales Reales
*   **Cloudflare R2:** Reemplazar las credenciales temporales y mocks del bucket de imágenes R2 por credenciales seguras de producción.
*   **Stripe SDK:** Sustituir la llave pública y secreta del sandbox de pruebas (`pk_test_...`, `sk_test_...`) por llaves reales de Stripe en [main.dart](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/lib/main.dart) y en el entorno del backend.
*   **Webhook Secret:** Registrar el `STRIPE_WEBHOOK_SECRET` real devuelto por la consola de Stripe para validar la firma de los eventos en el webhook de producción.

### 2. Infraestructura y Base de Datos
*   **Migración a Base de Datos en Producción:** Migrar del SQLite de desarrollo local (`smartpyme.db`) a una base de datos distribuida en la nube compatible con LibSQL (como Turso) o una instancia PostgreSQL en producción.
*   **Logger Centralizado:** Configurar y enviar las trazas del logger de desarrollo (`pino`) hacia un agregador de logs externo en la nube (como Grafana Loki o Datadog).

### 3. Funcionalidades en el Cliente Móvil
*   **Notificaciones Push:** Integración con Firebase Cloud Messaging (FCM) o OneSignal para informar al cliente cuando el administrador actualice el estado de su pedido (ej. de "pagado" a "enviado").
*   **Internacionalización (i18n):** Implementación de soporte multilingüe (español/inglés) para la interfaz de usuario móvil.
*   **Certificados y Despliegue en Tiendas:** Compilación y firmado de la aplicación en modo release (`.aab` para Google Play y `.ipa` para App Store).
