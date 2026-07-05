# SmartPyME Backend (DDD + Ports & Adapters)

Este es el backend de la plataforma **SmartPyME**, desarrollado utilizando una arquitectura limpia que combina principios de Diseño Guiado por el Dominio (DDD) y Arquitectura Hexagonal (Puertos y Adaptadores).

El runtime principal es **Bun**, y como base de datos se utiliza **SQLite** administrado mediante **Drizzle ORM**.

---

## 🚀 Requisitos e Instalación

### 1. Clonar e Instalar Dependencias
Instala todas las dependencias del proyecto ejecutando:
```bash
bun install
```

### 2. Configurar Variables de Entorno
Crea un archivo `.env` en la raíz del directorio `backend` con las siguientes variables:
```env
PORT=3000
DATABASE_URL=file:./smartpyme.db
JWT_SECRET=supersecretjwtkey1234567890!
STRIPE_SECRET_KEY=sk_test_mock_keys_or_real_stripe_secret
CLOUDFLARE_R2_BUCKET=smartpyme-uploads
CLOUDFLARE_R2_ACCESS_KEY_ID=mock_access_key
CLOUDFLARE_R2_SECRET_ACCESS_KEY=mock_secret_key
CLOUDFLARE_R2_ENDPOINT=https://mock.r2.endpoint.com
```

### 3. Sincronizar Base de Datos (Drizzle ORM)
Genera y aplica el esquema de la base de datos SQLite local (`smartpyme.db`):
```bash
bun run db:push
```

### 4. Poblar Datos de Prueba (Seed)
Añade datos por defecto al catálogo (categorías, prendas, variantes de stock) y crea el usuario administrador por defecto:
```bash
bun run seed
```

---

## 🛠️ Desarrollo y Comandos Útiles

*   **Levantar Servidor en Modo Observador (Watch):**
    ```bash
    bun run dev
    ```
    El servidor Hono correrá en el puerto `3000` (o el especificado en el `.env`).

*   **Ejecutar Linter (ESLint con reglas JSDoc/TSDoc):**
    ```bash
    bun run lint
    ```
    Este comando valida la calidad de código TypeScript y exige documentación JSDoc correcta en clases y funciones públicas.

*   **Corregir Errores de Estilo Automáticamente:**
    ```bash
    bun run lint --fix
    ```

*   **Formatear Código (Prettier):**
    ```bash
    bun run format
    ```

---

## 🧪 Pruebas Unitarias (Regla Obligatoria Co-located)

> [!IMPORTANT]
> **REGLA DE ESTRUCTURA DE PRUEBAS:**
> Las pruebas para el backend **deben estar obligatoriamente al lado del código fuente original** (co-location) siguiendo principios DDD, y **no** en un directorio `tests` separado en la raíz del proyecto.
> 
> Cada carpeta del Core o Adaptadores que requiera pruebas debe contener su propio directorio `__tests__` con las pruebas unitarias y de caja negra/blanca asociadas.

### Ejemplo de Estructura de Módulo:
```
src/inventory/
├── core/
│   ├── __tests__/
│   │   └── inventory.test.ts  <-- Pruebas colocales al lado de la lógica
│   ├── DecrementStockUseCase.ts
│   ├── StockAlert.ts
│   └── StockMovement.ts
├── ports/
│   ├── in/
│   └── out/
└── adapters/
    └── InventoryController.ts
```

### Ejecutar Pruebas
Para correr el conjunto de pruebas unitarias y de caja con **Vitest**:
```bash
bun run test
```

---

## 🏛️ Estructura Arquitectónica del Backend
El backend se organiza en módulos de dominio autónomos:
*   `citas/` / `auth/`: Control de accesos y seguridad JWT.
*   `catalog/`: Gestión de prendas, categorías y variantes.
*   `cart/`: Carrito de compras de clientes persistido.
*   `orders/`: Gestión del checkout transaccional y pagos con Stripe.
*   `inventory/`: Control de stock, logs de movimientos y alertas de inventario crítico.
*   `dashboard/`: Agregación de analíticas y reportes de facturación.

Dentro de cada módulo se respeta el aislamiento hexagonal:
1.  **Core (Dominio y Casos de Uso):** Lógica pura de negocio libre de dependencias de infraestructura.
2.  **Ports (Puertos):** Interfaces TypeScript claras para la entrada y salida de datos (`in/` y `out/`).
3.  **Adapters (Adaptadores/Infraestructura):** Implementaciones concretas (Drizzle, SQLite, endpoints de Hono, Stripe SDK).

---

## 📦 Despliegue y Preparación para Producción

Para llevar el backend a producción:
1.  **Validación Estática:** Asegúrese de compilar sin errores de tipos TypeScript (`bun run build`) y que el linter y pruebas pasen sin advertencias.
2.  **Variables de Producción:** Configure claves seguras en el archivo de entorno, apuntando a un bucket Cloudflare R2 real y usando llaves de Stripe válidas.
3.  **Base de Datos Relacional:** Para cargas elevadas, reemplace la variable de conexión de SQLite en el cliente de base de datos (`client.ts`) para conectarse a una instancia remota de Turso/LibSQL o PostgreSQL mediante el driver adecuado.

---

## 📝 Lo que falta hacer (Trabajo Futuro)

1.  **Webhooks de Stripe Reales:** Implementar un endpoint dedicado `/api/payments/webhook` para procesar y consolidar eventos asíncronos de pago de Stripe (por ejemplo, reembolsos o disputas) de forma nativa desde la infraestructura de Stripe.
2.  **Llaves de Producción de R2:** Reemplazar las credenciales temporales y mocks del almacenamiento de imágenes de Cloudflare R2 con credenciales reales configuradas con políticas de permisos restringidas para producción.
3.  **Monitoreo y Logger Centralizado:** Redirigir la salida del logger `pino` a un agregador de logs externo (como Datadog o Grafana Loki) para el rastreo y alerta temprana en producción.
