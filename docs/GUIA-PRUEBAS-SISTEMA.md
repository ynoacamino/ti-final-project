# 📱 Guía de Pruebas de Sistema y Aceptación · SmartPyME

Esta guía contiene los pasos necesarios para inicializar el sistema de forma local, enlazar el dispositivo móvil (celular real o emulador) y ejecutar las pruebas de aceptación del progreso actual en rediseño de interfaz, dinámicas de roles y pasarela de pago.

---

## 🛠️ Paso 1: Iniciar el Servidor Backend

El servidor backend provee la API REST para autenticación, carrito y pedidos. Sigue estos pasos para levantarlo:

1. Abre una terminal y sitúate en el directorio del backend:
   ```bash
   cd /home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/backend
   ```
2. Instala las dependencias necesarias:
   ```bash
   bun install
   ```
3. Ejecuta el servidor en modo de desarrollo:
   ```bash
   bun run dev
   ```
   *El servidor backend se iniciará de forma predeterminada en `http://localhost:3000` (disponible para consumo en toda la interfaz de red).*

---

## 📶 Paso 2: Conectar el Celular / Emulador con tu Computadora

Para que la aplicación en tu celular se conecte con el servidor local de tu computadora, deben compartir la misma red.

### Opción A: Celular Físico (Recomendado)
1. Conecta tu celular y tu computadora a la **misma red Wi-Fi**.
2. Obtén la dirección IP local de tu computadora ejecutando en una terminal:
   ```bash
   hostname -I
   ```
   *(Por ejemplo, obtendrás: `192.168.1.45`)*
3. **No modifiques el código fuente**. Simplemente abre el archivo de configuración de desarrollo:
   [mobile/config/dev.json](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/config/dev.json)
4. Modifica el valor de `"BASE_URL"` para apuntar a la IP de tu PC:
   ```json
   {
     "BASE_URL": "http://192.168.1.45:3000"
   }
   ```
5. Inicia la aplicación en modo desarrollo apuntando a este archivo:
   ```bash
   flutter run --dart-define-from-file=config/dev.json
   ```
   *(O directamente por línea de comandos sin editar el JSON: `flutter run --dart-define=BASE_URL=http://192.168.1.45:3000`)*
6. Asegúrate de habilitar el tráfico por el puerto 3000 en tu PC:
   ```bash
   sudo ufw allow 3000
   ```

### Opción B: Emulador de Android (Android Studio)
1. El emulador enruta automáticamente el tráfico local a la dirección **`10.0.2.2`** de manera interna.
2. Por defecto, si no especificas ningún parámetro, la app móvil detecta el emulador y se conecta a `http://10.0.2.2:3000`.
3. Puedes iniciar la app normalmente con `flutter run` o forzar la configuración con:
   ```bash
   flutter run --dart-define-from-file=config/dev.json
   ```

---

## 📊 Paso 3: Cuentas de Acceso y Datos de Prueba

Utiliza las siguientes credenciales de prueba configuradas en el seeder de base de datos para simular los diferentes flujos:

### 👥 Credenciales de Acceso

| Rol de Usuario | Correo Electrónico (Email) | Contraseña (Password) | Comportamiento Estético |
| :--- | :--- | :--- | :--- |
| **Cliente / Comprador** | `cliente@gmail.com` | `client123` | Carga el **Tema Claro** (Púrpura, estilo `/will/onboarding-screen`). |
| **Administrador** | `admin@smartpyme.com` | `admin123` | Carga el **Tema Oscuro** (Slate/Blue, estilo `/will/product-creation-form`). |

### 💳 Tarjeta de Crédito de Pruebas (Stripe Sandbox)
Durante el proceso de checkout, digita los siguientes campos en la pasarela segura:

*   **Número de Tarjeta:** `4242 4242 4242 4242`
*   **Fecha de Expiración:** Cualquier fecha futura (ej. `12 / 28`)
*   **CVC:** `123`
*   **Código Postal (ZIP):** `10001` (o cualquiera de 5 dígitos)

## 🧪 Paso 4: Guía de Pruebas de Aceptación (Escenarios)

### 🛒 Escenario A: Flujo del Cliente (Añadir al carrito y Comprar)
1. **Acceso Inicial:** Abre la aplicación. Verás la pantalla de bienvenida. Presiona **Comenzar**.
2. **Autenticación:** Digita el correo `cliente@gmail.com` y la contraseña `client123`. Presiona **Ingresar**.
    *   *Verificación:* La interfaz carga en **Tema Claro** con acentos púrpuras.
3. **Exploración:** Ve a la pestaña **Catálogo** y selecciona un producto (por ejemplo, una camisa).
4. **Detalle de Producto:** Revisa los Choice Chips circulares para las tallas (`XS`, `S`, `M`, `L`, `XL`), el selector de colores circulares y la tarjeta de beneficios inferiores.
5. **Selección:** Selecciona una combinación disponible de talla/color, usa el stepper numérico flotante para fijar la cantidad en 2 unidades y presiona **Añadir al Carrito**.
6. **Carrito:** Ve al carrito en la pestaña inferior, comprueba los subtotales y los iconos contrastados de `+` y `-`. Presiona **Continuar Compra**.
7. **Checkout:** Ingresa los datos de entrega en el formulario. En la sección **Método de Pago**, selecciona una de las dos opciones simuladas:
    *   **Opción 1: Tarjeta (Simulado):** Rellena los datos de la tarjeta simulada de Stripe (`4242...`) directamente en la ventana emergente y presiona **Confirmar Pago**. El pedido se confirmará y se marcará de inmediato como `pagado`.
    *   **Opción 2: Pago Manual (Yape / Transferencia):** Verás las instrucciones para yapear al `987 654 321` de *SmartPyME S.A.C.* Confirma el pedido. Se registrará en estado `pendiente`.
8. **Resultado:** Al finalizar, verás la pantalla de **Pedido Confirmado** con tu identificador.

### 📦 Escenario B: Flujo del Administrador (Gestión y Despacho)
1. **Acceso Admin:** Cierra sesión desde el perfil o reinicia la app e ingresa con `admin@smartpyme.com` y `admin123`.
    *   *Verificación:* La interfaz cambiará inmediatamente a **Tema Oscuro** (Tech Slate Blue).
2. **Dashboard:** Observa las métricas de ingresos, gráficos de línea de tiempo y la sección de alertas de stock.
    *   *Verificación de Ganancias:* Si realizaste una compra por **Pago Manual (Yape)**, notarás que las ganancias no habrán subido aún porque el pedido está `pendiente`.
3. **Tracking de Pedidos:** Presiona **Gestionar Envíos y Pedidos** para acceder al listado de órdenes.
4. **Actualización:** Busca el pedido creado en el Escenario A (en estado `pendiente`).
5. **Secuencia de Estados:** Expande el pedido, observa la dirección formateada con calles y referencias, y actualiza secuencialmente su estado presionando en el chip **Marcar como Pagado** (de `PENDIENTE` a `PAGADO`).
6. **Validación de Ganancias:** Regresa al **Dashboard**. Verás que los **Ingresos Totales** se han incrementado instantáneamente con las ganancias del pedido manual validado, reflejándose también en el gráfico de ventas.

---

## 📦 Paso 5: Compilación del APK para Demostración en Clase (Sin cable USB)

Para demostrar la aplicación móvil en tu salón de clases directamente en tu celular físico sin depender del cable USB ni de la computadora de desarrollo:

1. **Asegúrate de que el Backend esté accesible:** Tu backend debe estar ejecutándose en una IP accesible (Wi-Fi local) o desplegado en la nube (ej: Vercel, Railway, Supabase).
2. **Edita el archivo de producción:** Configura la URL del backend en el archivo:
   [mobile/config/prod.json](file:///home/alvaro9rqc/1_Pacha/1-unsa/7_S/ti/ti-final-project/mobile/config/prod.json)
   ```json
   {
     "BASE_URL": "https://tu-backend-produccion.com"
   }
   ```
3. **Genera el APK en modo Release:** En la terminal, dentro de la raíz de la app móvil, compila la aplicación indicando el archivo de variables:
   ```bash
   cd mobile/
   CONFIG_FILE=config/prod.json ./scripts/build.sh
   ```
4. **Localiza el archivo compilado:** Una vez finalizada la compilación, Gradle generará el APK instalable en:
   `mobile/build/app/outputs/flutter-apk/app-release.apk`
5. **Instálalo en tu celular:**
   * Sube el archivo `app-release.apk` a tu cuenta de **Google Drive**, envíatelo por **WhatsApp Web** o compártelo por **Telegram / Bluetooth**.
   * Abre el archivo en tu celular e instálalo (debes dar permiso para instalar aplicaciones desde fuentes desconocidas).
   * ¡Listo! Podrás utilizar y demostrar la app libremente en el aula.
