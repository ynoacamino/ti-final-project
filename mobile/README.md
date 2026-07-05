# SmartPyME Mobile Client (Flutter)

Este es el cliente móvil de la plataforma **SmartPyME**, desarrollado en **Flutter** utilizando una estructura de arquitectura limpia y gestión de estado reactiva con **Riverpod**.

---

## 🚀 Requisitos e Instalación

### 1. Requisitos Previos
*   Flutter SDK instalado (versión compatible: `^3.12.2` o superior).
*   Dispositivo físico o emulador configurado.

### 2. Instalar Dependencias
Instale los paquetes de pub necesarios ejecutando:
```bash
flutter pub get
```

### 3. Configuración de Red
El cliente se conecta al backend a través del cliente unificado `DioClient`.
*   **Emulador de Android:** Redirecciona automáticamente el loopback de localhost a `http://10.0.2.2:3000` para conectarse al backend de desarrollo.
*   **Simulador de iOS o Dispositivo Físico:** Cambie el host en la inicialización o configuración de red por la IP local de su computadora de desarrollo (por ejemplo: `http://192.168.1.XX:3000`).

---

## 🛠️ Desarrollo y Comandos Útiles

*   **Ejecutar la Aplicación en Modo Debug:**
    ```bash
    flutter run
    ```

*   **Ejecutar el Analizador de Código (Linter):**
    ```bash
    flutter analyze
    ```
    Este comando verifica que no haya advertencias o errores en la estructura del código móvil.

*   **Formatear el Código Fuente:**
    ```bash
    dart format lib/
    ```

---

## 🧪 Pruebas Unitarias (Regla Obligatoria Co-located)

> [!IMPORTANT]
> **REGLA DE ESTRUCTURA DE PRUEBAS:**
> Las pruebas para el cliente móvil **deben estar obligatoriamente al lado del código fuente original** (co-location) siguiendo principios DDD, y **no** en un directorio `test` separado en la raíz del proyecto.
> 
> Cada carpeta de características (Features) que requiera pruebas debe contener su propio subdirectorio `test/` o `__tests__/` con las pruebas unitarias y de widgets asociadas.

### Ejemplo de Estructura de Características:
```
lib/features/auth/
├── domain/
│   ├── entities/
│   └── repositories/
├── data/
│   ├── datasources/
│   └── repositories/
└── presentation/
    ├── providers/
    │   └── __tests__/
    │       └── auth_provider_test.dart  <-- Pruebas colocales al lado del proveedor
    └── pages/
```

### Ejecutar Pruebas
Para correr el conjunto de pruebas unitarias móviles:
```bash
flutter test lib/
```

---

## 🏛️ Estructura Arquitectónica Móvil
La aplicación se organiza en capas según la arquitectura limpia:
1.  **Domain (Dominio):** Entidades de negocio (`Category`, `Product`, `Order`, `Cart`) y contratos de repositorios. Totalmente libre de lógica de UI o librerías externas.
2.  **Data (Datos):** Modelos de deserialización de JSON (DTOs), fuentes de datos remotas (`CatalogRemoteDataSource`) e implementaciones de contratos de repositorios.
3.  **Presentation (Presentación):** Páginas y widgets de interfaz de usuario junto con manejadores de estado (Riverpod StateNotifiers).

---

## 📦 Configuración de Stripe en Producción

Para habilitar pagos con tarjetas reales en producción:
1.  Abra `lib/main.dart`.
2.  Reemplace la llave pública de pruebas de Stripe `Stripe.publishableKey` por su clave de producción real:
    ```dart
    Stripe.publishableKey = "pk_live_your_actual_live_key";
    ```
3.  Asegúrese de compilar la aplicación en modo release para optimizar el bundle de producción:
    ```bash
    flutter build apk --release
    # O para iOS:
    flutter build ipa
    ```

---

## 📝 Lo que falta hacer (Trabajo Futuro)

1.  **Llaveros y Credenciales de Stripe:** Reemplazar las llaves públicas de pruebas (`pk_test_...`) por llaves reales de producción para procesar cargos reales.
2.  **Notificaciones Push:** Integrar Firebase Cloud Messaging (FCM) o OneSignal para notificar a los clientes sobre cambios de estado en sus órdenes en tiempo real.
3.  **Despliegue en Tiendas:** Configurar certificados de producción para Google Play Store (.aab) y Apple App Store (TestFlight/App Store).
4.  **Soporte Multilingüe:** Implementar soporte para múltiples idiomas mediante internacionalización (i18n) de Flutter.
