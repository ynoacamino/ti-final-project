````markdown
---
title: "[Título del Proyecto]"
subtitle: "Documento de Contrato API"
author: "[Nombre del autor]"
date: "[Mes Año]"
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

**Proyecto:** [Nombre del proyecto]

**Versión:** [X.Y.Z]

**Fecha:** [Mes Año]

**Protocolo:** HTTP / HTTPS

**Formato de intercambio:** JSON

**Versión de la API:** v1

**Base URL:** [/api/v1]

**Autenticación:** [JWT, OAuth2, API Key, Ninguna]

**Documentos de referencia:**

- Documento de Alcance
- Documento de Modelo de Datos
- Documento de Planificación

- Como la información general debe identificar de forma única la versión del contrato.
- Como la versión de la API debe mantenerse compatible con el frontend correspondiente.
- Como este documento debe ser la fuente oficial del contrato entre frontend y backend.

# Objetivo

Define el contrato de comunicación entre consumidores y proveedores de la API. Este documento establece las estructuras de datos, reglas de comunicación, endpoints, códigos de respuesta y criterios necesarios para garantizar una integración consistente entre todos los componentes del sistema.

- Como este documento debe permitir el desarrollo independiente del frontend y backend.
- Como todos los contratos deben derivarse de los requisitos funcionales del Documento de Alcance.
- Como cualquier modificación del contrato debe reflejarse primero en este documento antes de implementarse.

# Convenciones

Documenta las reglas generales utilizadas por toda la API.

## Versionado

- Estrategia de versionado.
- Compatibilidad entre versiones.
- Política de deprecación.

## Convención de rutas

- Recursos en plural.
- Uso de sustantivos.
- Verbos HTTP estándar.

```text
GET    /users
POST   /users
GET    /users/{id}
PUT    /users/{id}
PATCH  /users/{id}
DELETE /users/{id}
```

## Convención JSON

- Formato de nombres (camelCase o snake_case).
- Formato de fechas.
- Formato UUID.
- Valores nulos.
- Codificación UTF-8.

- Como todas las rutas deben seguir la misma convención.
- Como todos los objetos JSON deben mantener el mismo formato.
- Como todas las fechas deben utilizar el mismo estándar.

# Seguridad

Describe el mecanismo de autenticación y autorización utilizado por la API.

## Autenticación

- Método.
- Headers requeridos.
- Tiempo de expiración.
- Renovación del token.

## Autorización

| Rol | Permisos |
| ---- | --------- |
| [Rol] | [Descripción] |

- Como todos los endpoints protegidos deben validar autenticación.
- Como los permisos deben verificarse antes de ejecutar cualquier operación.

# Objetos compartidos

Documenta todas las estructuras reutilizadas por la API. Los endpoints deben referenciar estos objetos en lugar de redefinirlos.

## Request DTO

### [NombreRequest]

| Campo | Tipo | Obligatorio | Descripción |
| ------ | ---- | ----------- | ----------- |
| [campo] | [tipo] | [Sí/No] | [Descripción] |

---

## Response DTO

### [NombreResponse]

| Campo | Tipo | Descripción |
| ------ | ---- | ----------- |
| [campo] | [tipo] | [Descripción] |

---

## Objetos comunes

Documenta objetos reutilizados por múltiples endpoints.

### Pagination

| Campo | Tipo | Descripción |
| ------ | ---- | ----------- |
| page | integer | Página actual. |
| pageSize | integer | Cantidad de registros por página. |
| total | integer | Total de registros. |

---

### ErrorResponse

| Campo | Tipo | Descripción |
| ------ | ---- | ----------- |
| success | boolean | Siempre false. |
| code | string | Código interno del error. |
| message | string | Mensaje descriptivo. |

---

## Enumeraciones

### [NombreEnum]

| Valor | Descripción |
| ------ | ----------- |
| [VALOR] | [Descripción] |

- Como todos los DTO utilizados por la API deben documentarse en esta sección.
- Como los endpoints deben reutilizar los DTO existentes.
- Como los cambios incompatibles requieren una nueva versión del contrato.

# Formato estándar

Define el formato común de las respuestas.

## Respuesta exitosa

```json
{
  "success": true,
  "data": {},
  "message": "Operación realizada correctamente."
}
```

## Respuesta con error

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Descripción del error."
  }
}
```

- Como todas las respuestas deben mantener la misma estructura.
- Como los errores deben ser claros y consistentes.

# Endpoints

Documenta cada endpoint utilizando los objetos compartidos definidos anteriormente.

---

## [API-001] [Nombre del endpoint]

**Descripción**

[Descripción funcional.]

**Método**

GET | POST | PUT | PATCH | DELETE

**Ruta**

```text
/api/v1/[recurso]
```

**Autenticación**

Sí / No

**Roles permitidos**

- [Rol]

### Parámetros de ruta

| Nombre | Tipo | Obligatorio | Descripción |
| -------- | ---- | ----------- | ----------- |
| id | UUID | Sí | Identificador del recurso. |

### Parámetros Query

| Nombre | Tipo | Obligatorio | Descripción |
| -------- | ---- | ----------- | ----------- |
| page | integer | No | Número de página. |

### Encabezados

| Header | Obligatorio | Descripción |
| -------- | ----------- | ----------- |
| Authorization | Sí | Token JWT. |

### Request

**DTO**

```text
[NombreRequest]
```

### Response

**DTO**

```text
[NombreResponse]
```

### Códigos HTTP

| Código | Descripción |
| -------- | ----------- |
| 200 | Operación exitosa. |
| 201 | Recurso creado. |
| 204 | Sin contenido. |
| 400 | Solicitud inválida. |
| 401 | No autenticado. |
| 403 | Acceso denegado. |
| 404 | Recurso inexistente. |
| 409 | Conflicto. |
| 422 | Error de negocio. |
| 500 | Error interno. |

### Reglas del endpoint

- Como deben validarse todas las entradas antes de procesarlas.
- Como únicamente los roles autorizados pueden consumir este endpoint.
- Como la respuesta debe cumplir el formato estándar definido.

# Códigos de error

Documenta los códigos internos utilizados por la API.

| Código | HTTP | Descripción |
| -------- | ---- | ----------- |
| INVALID_DATA | 400 | Datos inválidos. |
| NOT_FOUND | 404 | Recurso inexistente. |
| UNAUTHORIZED | 401 | Usuario no autenticado. |
| FORBIDDEN | 403 | Sin permisos. |
| CONFLICT | 409 | Conflicto de información. |
| INTERNAL_ERROR | 500 | Error interno del servidor. |

- Como todos los errores deben utilizar un código interno único.
- Como el frontend debe poder identificar el error únicamente mediante el código.

# Versionado

Describe la estrategia de evolución del contrato.

- Compatibilidad.
- Deprecación.
- Nuevas versiones.
- Eliminación de versiones antiguas.

- Como los cambios incompatibles deben generar una nueva versión.
- Como las versiones anteriores deben mantenerse durante el periodo definido por el proyecto.

# Historial de cambios

Documenta la evolución del contrato.

| Versión | Fecha | Cambio |
| -------- | ----- | ------ |
| v1 | [Fecha] | Contrato inicial. |

- Como toda modificación del contrato debe registrarse.
- Como frontend y backend deben utilizar la misma versión del contrato.

# Riesgos técnicos

Identifica los riesgos asociados al contrato.

| ID | Riesgo | Impacto | Probabilidad | Mitigación |
| -- | ------- | -------- | ------------ | ---------- |
| API-001 | [Descripción] | Alto | Media | [Acción] |

- Como los cambios incompatibles deben detectarse antes del desarrollo.
- Como los riesgos de seguridad deben mitigarse antes del despliegue.

# Criterios de aceptación

Enumera las condiciones globales para considerar aprobado el contrato API.

- Como todos los endpoints definidos en el Documento de Alcance deben encontrarse documentados.
- Como todos los DTO utilizados por la API deben estar definidos en este documento.
- Como todos los códigos HTTP y errores posibles deben encontrarse documentados.
- Como el frontend debe poder desarrollar la integración únicamente utilizando este documento.
- Como el backend debe implementar exactamente el contrato definido.
- Como cualquier modificación del contrato debe actualizar este documento antes de implementarse.
- Como el contrato debe mantenerse sincronizado con el Modelo de Datos cuando existan cambios estructurales.
````
