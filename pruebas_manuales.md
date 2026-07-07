# Guía de Pruebas Manuales - SmartPyME

Esta guía describe los pasos necesarios para probar manualmente los flujos de negocio principales de la aplicación, abarcando desde la interacción de clientes hasta las tareas administrativas.

---

## 1. Registro de Nuevos Usuarios (Cliente)

Este flujo valida la creación de cuentas mediante credenciales tradicionales.

### Pasos:
1. **Acceso:** Abre la aplicación móvil y dirígete a la pantalla de bienvenida. Presiona **Iniciar Sesión** o **Registrarse**.
2. **Formulario:** Selecciona la pestaña **Registrarse** en el conmutador central.
3. **Datos de Entrada:**
   * **Nombre Completo:** Ingresa un nombre (ej. `Carlos Ríos Mendoza`).
   * **Correo Electrónico:** Digita un correo válido (ej. `carlos.rios@gmail.com`).
   * **Contraseña:** Escribe una contraseña de al menos 6 caracteres (ej. `carlos123`).
   * **Confirmar Contraseña:** Reintroduce la misma contraseña.
4. **Envío:** Presiona el botón **Registrarse**.
5. **Verificación:**
   * La aplicación debe validar las credenciales.
   * Tras el éxito, debe iniciar sesión de forma automática y redirigirte directamente al catálogo principal (`/home`).

---

## 2. Flujo Completo de Compra de Productos (Cliente)

Este flujo valida el proceso completo de selección, adición al carrito, ingreso de dirección, resumen y pago de prendas.

### Pasos:
1. **Selección:** Desde el catálogo, selecciona un producto (ej. *Merino Wool Sweater*).
2. **Opciones:** Selecciona una talla (ej. `M`) y color (ej. `Verde Bosque`) que estén disponibles.
3. **Cantidad:** Incrementa la cantidad a comprar a `2` unidades. Verifica que el botón de cantidad no te permita superar el stock actual del artículo.
4. **Carrito:** Presiona **Añadir al Carrito**. Aparecerá una confirmación visual.
5. **Navegación:** Dirígete a la pestaña **Mi Carrito** en el menú inferior.
6. **Revisión del Carrito:**
   * Valida que aparezcan el nombre, la variante seleccionada, la cantidad y el precio unitario correcto.
   * Verifica los totales en el panel inferior (Subtotal, Envío: S/. 15.00 y Total).
   * Presiona **Proceder al Pago**.
7. **Paso 1 (Dirección):**
   * Completa la dirección (ej. `Av. Larco 1301`), ciudad (`Lima`), distrito (`Miraflores`), y código postal de 5 dígitos (ej. `15074`).
   * Selecciona el país `Perú` usando el buscador interactivo (debe mostrar el icono de bandera 🇵🇪).
   * Presiona **Continuar**. (Los campos de envío quedarán guardados localmente de manera segura).
8. **Paso 2 (Resumen):**
   * Confirma que el desglose muestre el subtotal de artículos, envío de S/. 15.00, desglose indicativo del IGV (18%) e importe total final.
   * Presiona **Ir al Pago**.
9. **Paso 3 (Pago):**
   * **Opción A (Tarjeta):** Introduce los datos simulados:
     * Número: `4242 4242 4242 4242` (verifica el espaciado automático).
     * Titular: `Carlos Ríos Mendoza`.
     * Vencimiento: `12/30` (formato automático con barra `/`).
     * CVV: `123`.
     * Presiona **Pagar S/. [Total]**.
   * **Opción B (Yape / Pago Manual):** Selecciona la pestaña Yape. Transfiere con tu teléfono al número **`925550310`** o escanea el código QR en pantalla. Presiona **Confirmar Compra**.
10. **Confirmación:** Tras confirmarse el pago en el servidor, el carrito se vaciará y serás redirigido a la pantalla de **Pedido Procesado** mostrando el código único del pedido.

---

## 3. Inserción de Productos al Catálogo (Admin)

Ahora se cuenta con una interfaz visual administrativa en la aplicación móvil para crear productos de forma interactiva y con diseño premium. También se puede seguir realizando directamente a través de la API REST del backend.

### Opción A: Interfaz Visual (Recomendada)
1. **Acceso:** Inicia sesión como administrador en la app móvil con las credenciales:
   * **Usuario:** `admin@smartpyme.com`
   * **Contraseña:** `admin123`
2. **Navegación:** En tu perfil, haz clic en **Panel Administrativo** y luego en **Gestionar Catálogo de Productos**.
3. **Crear Listing:** Presiona el botón flotante dorado **Crear Producto**.
4. **Formulario:** Completa los campos en las tres pestañas correspondientes:
   * **General Info:** Nombre del producto (ej. `Casaca Cortaviento Premium`), selecciona categoría (ej. `Camisas`), ingresa descripción, precio base (ej. `149.90`), precio comparativo y toggle de impuestos.
   * **Quick Attach Media:** Haz clic en el recuadro punteado de añadir imágenes y selecciona las fotos que deseas asociar al producto.
   * **Variants:** Presiona **Add Variant** e ingresa los detalles de la variante (ej. Talla: `S`, Color: `Negro`, Stock: `15`, Precio Adicional: `0`). Añade las variantes que consideres.
   * **Images Gallery:** Administra las imágenes asociadas.
5. **Publicación:** Presiona **Publish Product**. El producto se creará en el backend y se subirán las imágenes asociadas.
6. **Verificación:** Regresa a la pestaña de catálogo del cliente en la aplicación móvil y verifica que aparezca listado.

### Opción B: Mediante API REST (`curl`)
1. Envía una solicitud `POST` al endpoint `/api/products` incluyendo la cabecera `Authorization: Bearer <ADMIN_TOKEN>` y la estructura JSON del nuevo producto:

```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <ADMIN_TOKEN>" \
  -d '{
    "name": "Casaca Cortaviento Premium",
    "description": "Casaca impermeable ideal para running y ciclismo urbano.",
    "basePrice": 14990,
    "categoryId": "c9b1a5e1-5766-4b74-9a85-873c80619979",
    "variants": [
      {
        "size": "S",
        "color": "Negro",
        "sku": "CAS-CRT-NGR-S",
        "stock": 15,
        "additionalPrice": 0
      },
      {
        "size": "M",
        "color": "Negro",
        "sku": "CAS-CRT-NGR-M",
        "stock": 20,
        "additionalPrice": 1000
      }
    ]
  }'
```

2. **Carga de Imagen (Opcional):** Envía la imagen del producto usando `/api/products/:id/images` con formato `multipart/form-data`.
3. **Verificación:** Refresca la pantalla del catálogo de la aplicación móvil y comprueba que el nuevo producto aparezca listado.

---

## 4. Eliminación de Productos del Catálogo (Admin)

Para eliminar un producto de forma definitiva, ahora se puede hacer directamente desde la aplicación móvil o a través de la base de datos local SQLite backend.

### Opción A: Interfaz Visual (Recomendada)
1. **Navegación:** Ve a **Panel Administrativo** -> **Gestionar Catálogo de Productos**.
2. **Buscar y Eliminar:** Busca el producto en el catálogo (usando la barra de búsqueda). Presiona el icono de papelera (rojo) junto al producto.
3. **Confirmación:** Acepta el cuadro de diálogo para confirmar la eliminación permanente. El producto, sus variantes y sus imágenes asociadas se borrarán de forma segura.
4. **Verificación:** Reinicia o refresca el catálogo en la app móvil y confirma que el artículo ha desaparecido.

### Opción B: Acceso Directo a la DB local (`smartpyme.db`)
1. **Acceso a la DB:** Conéctate a la base de datos usando Drizzle Kit o un explorador de bases de datos SQLite desde la carpeta `/backend`:
   ```bash
   # Opción A: Levantar Drizzle Studio (Entorno visual en navegador)
   bun run db:generate && bun run db:push
   # Opción B: Usar consola sqlite3
   sqlite3 smartpyme.db
   ```
2. **Ejecutar Consultas SQL de Eliminación:**
   Identifica el ID del producto a eliminar a partir de su nombre o slug, y elimina los registros vinculados en orden de claves foráneas:

   ```sql
   -- 1. Buscar ID del producto
   SELECT id FROM products WHERE slug = 'casaca-cortaviento-premium';

   -- Supongamos que el ID obtenido es 'e1a5b9b1-5766-4b74-9a85-873c80619979'
   
   -- 2. Eliminar variantes del producto
   DELETE FROM product_variants WHERE product_id = 'e1a5b9b1-5766-4b74-9a85-873c80619979';

   -- 3. Eliminar imágenes asociadas
   DELETE FROM product_images WHERE product_id = 'e1a5b9b1-5766-4b74-9a85-873c80619979';

   -- 4. Eliminar el producto de la tabla principal
   DELETE FROM products WHERE id = 'e1a5b9b1-5766-4b74-9a85-873c80619979';
   ```

3. **Verificación:** Reinicia o refresca el catálogo en la app móvil y confirma que el artículo ha desaparecido.
