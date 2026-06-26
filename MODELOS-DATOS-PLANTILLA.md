````markdown
---
title: "[Título del Proyecto]"
subtitle: "Documento del Modelo de Datos"
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

**Motor de base de datos:** [PostgreSQL / MySQL / SQLite / MongoDB / Otro]

**ORM / Driver:** [Prisma, TypeORM, Sequelize, Drizzle, etc.]

**Documentos relacionados:**

- Documento de Alcance
- Documento de Backlog
- Documento de Planificación

- Como la información general debe identificar de forma única la versión del modelo de datos.
- Como el motor de base de datos debe coincidir con la arquitectura del proyecto.

# Objetivo

Describe la estructura lógica de la información que utilizará el sistema. Este documento define las entidades, atributos, relaciones, restricciones y reglas necesarias para almacenar y consultar los datos del proyecto de forma consistente.

- Como este documento debe servir como referencia para backend, frontend y base de datos.
- Como este documento debe mantener la consistencia del dominio del negocio.
- Como todas las entidades deben derivarse del Documento de Alcance.

# Convenciones

Documenta las convenciones utilizadas para nombrar tablas, colecciones, columnas, índices y claves.

## Convenciones de nombres

- Tablas en singular o plural: [criterio].
- Columnas: [snake_case / camelCase].
- Claves primarias: [id].
- Claves foráneas: [entidad_id].
- Índices: [prefijo o criterio].

- Como todas las entidades deben seguir la misma convención de nombres.
- Como las claves primarias deben identificarse de forma única.
- Como las claves foráneas deben mantener la integridad referencial.

# Modelo conceptual

Describe las entidades principales del dominio y su propósito dentro del sistema.

| Entidad | Descripción |
| -------- | ----------- |
| [Entidad] | [Responsabilidad dentro del dominio] |

- Como cada entidad debe representar un concepto del negocio.
- Como ninguna entidad debe duplicar responsabilidades de otra.

# Entidades

Describe cada entidad de manera individual.

## [Entidad]

**Descripción:**

[Descripción de la entidad.]

### Atributos

| Campo | Tipo | Obligatorio | Descripción |
| ------ | ---- | ----------- | ----------- |
| id | UUID | Sí | Identificador único. |
| [campo] | [tipo] | [Sí/No] | [Descripción] |

### Restricciones

- [Restricción].
- [Restricción].

### Índices

| Nombre | Campos | Tipo |
| ------- | ------- | ---- |
| [IDX-001] | [campo] | [UNIQUE / INDEX] |

### Relaciones

| Entidad | Cardinalidad | Descripción |
| -------- | ------------ | ----------- |
| [Entidad] | 1:1 / 1:N / N:M | [Descripción] |

### Reglas de negocio

- Como [regla].
- Como [regla].
- Como [regla].

- Como todos los atributos obligatorios deben validarse antes de persistirse.
- Como las relaciones deben respetar la integridad del dominio.

# Catálogos

Documenta tablas o colecciones cuyo contenido es relativamente estático.

| Catálogo | Valores principales | Uso |
| --------- | ------------------ | --- |
| [Nombre] | [Valores] | [Descripción] |

- Como los catálogos deben evitar el uso de valores mágicos.
- Como las modificaciones de catálogos deben controlarse mediante migraciones.

# Auditoría

Describe los campos comunes para auditoría de registros.

| Campo | Tipo | Descripción |
| ------ | ---- | ----------- |
| created_at | timestamp | Fecha de creación. |
| updated_at | timestamp | Última modificación. |
| deleted_at | timestamp | Eliminación lógica. |
| created_by | UUID | Usuario creador. |
| updated_by | UUID | Usuario modificador. |

- Como todas las entidades persistentes deben registrar su fecha de creación.
- Como las modificaciones deben quedar registradas cuando aplique.

# Integridad de datos

Documenta las restricciones generales del modelo.

- Claves primarias.
- Claves foráneas.
- Restricciones UNIQUE.
- Restricciones CHECK.
- Eliminación en cascada.
- Eliminación lógica.
- Valores por defecto.

- Como el modelo debe impedir datos inconsistentes.
- Como las restricciones deben implementarse directamente en la base de datos cuando sea posible.

# Diagrama entidad-relación

Representa gráficamente las entidades y sus relaciones. Puede utilizarse Mermaid o plantUML

```PLantUML code
````

<!--imagen del grafico ya renderizado-->

* Como el diagrama debe representar todas las relaciones principales.
* Como cada relación debe coincidir con la implementación física.

# Rendimiento

Documenta las decisiones relacionadas con optimización.

* Índices.

* Consultas frecuentes.

* Campos calculados.

* Particionado.

* Caché.

* Como los índices deben justificarse por consultas frecuentes.

* Como deben evitarse duplicaciones innecesarias de datos.

# Riesgos técnicos

Identifica riesgos relacionados con el modelo de datos.

| ID    | Riesgo        | Impacto | Probabilidad | Mitigación |
| ----- | ------------- | ------- | ------------ | ---------- |
| R-001 | [Descripción] | Alto    | Media        | [Acción]   |

* Como los riesgos de pérdida de información deben mitigarse antes del desarrollo.
* Como los riesgos de rendimiento deben identificarse durante el diseño.

# Criterios de aceptación

Define las condiciones necesarias para considerar aprobado el modelo de datos.

* Como todas las entidades deben derivarse del Documento de Alcance.
* Como todas las relaciones deben estar documentadas.
* Como todas las restricciones deben encontrarse implementadas.
* Como el modelo debe soportar todos los casos de uso definidos.
* Como el diagrama entidad-relación debe corresponder con la implementación.
* Como todas las migraciones deben ejecutarse sin errores.
