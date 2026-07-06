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

Dado que no se dispone de una interfaz visual administrativa en la aplicación móvil para crear productos, esta tarea se realiza directamente a través de la API REST del backend.

### Requisitos:
* Obtener el Token JWT de administrador tras iniciar sesión como tal.

### Pasos usando `curl`:
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

Para dar de baja o eliminar un producto de forma definitiva, se debe operar directamente sobre la base de datos SQLite local del backend (`smartpyme.db`) al no contar con un endpoint DELETE público.

### Pasos:
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
