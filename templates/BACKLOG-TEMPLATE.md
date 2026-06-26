---
title: "[Título del Proyecto]"
subtitle: "Documento de Backlog del Producto"
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

**Responsable:** [Nombre del responsable]

**Stack objetivo:** [Tecnologías principales del proyecto]

**Ruta del módulo:** [Ruta principal de acceso al producto]

**Ubicación del código:** [Ruta del repositorio o carpeta principal]

- Como el stack objetivo debe estar claramente definido para evitar decisiones técnicas ambiguas.
- Como la ubicación del código debe indicar la ruta exacta donde reside el módulo principal.

# Objetivo del backlog

Traducir los requisitos del documento de alcance en historias de usuario, épicas y tareas técnicas implementables, priorizadas por valor de negocio y dependencias técnicas, para guiar el desarrollo iterativo del producto.

- Como el backlog debe servir como puente entre el documento de alcance y la implementación.
- Como el backlog debe estar priorizado por valor de negocio y dependencias técnicas.
- Como el backlog debe permitir planificar iteraciones y releases de forma incremental.

# Épicas

Lista las épicas que agrupan el trabajo en unidades funcionales de alto nivel. Cada épica se referencia con los requisitos, casos de uso o reglas de negocio del documento de alcance.

| Código  | Épica                                          | Trazabilidad alcance              |
| ------- | ---------------------------------------------- | --------------------------------- |
| [E-XXX] | [Nombre descriptivo de la épica]               | [Códigos de RF, CU, RN asociados] |

- Como las épicas deben cubrir de forma completa los requisitos del documento de alcance.
- Como cada épica debe tener una trazabilidad explícita hacia el documento de origen.

# Historias de usuario

Detalla las historias de usuario en formato "Como / Quiero / Para", con criterios de aceptación verificables, prioridad, épica asociada y trazabilidad al documento de alcance.

## [HU-XXX] · [Título de la historia]

**Como:** [rol o tipo de usuario]

**Quiero:** [acción o capacidad que el usuario desea]

**Para:** [beneficio o motivo de la necesidad]

**Criterios de aceptación:**

- Como [condición observable 1].
- Como [condición observable 2].
- Como [condición observable 3].

**Prioridad:** [Alta / Media / Baja]

**Épica:** [Códigos de épica]

**Trazabilidad:** [Códigos de RF, CU, RN asociados]

- Como cada historia debe redactarse en formato "Como / Quiero / Para".
- Como cada historia debe tener al menos un criterio de aceptación verificable.
- Como cada historia debe referenciar al menos una épica y un requisito de origen.

# Tareas técnicas

Lista las tareas técnicas concretas necesarias para implementar las historias de usuario. Cada tarea incluye su épica, tipo, prioridad y estado.

| ID     | Tarea                                                                 | Épica     | Tipo      | Prioridad | Estado     |
| ------ | --------------------------------------------------------------------- | --------- | --------- | --------- | ---------- |
| [T-XXX] | [Descripción concreta de la tarea]                                 | [E-XXX]   | [Setup / Frontend / Backend / Lógica / Datos / QA] | [Alta / Media / Baja] | [Pendiente / En curso / Hecho] |

- Como cada tarea debe ser lo suficientemente pequeña para completarse en una iteración corta.
- Como cada tarea debe referenciar la épica o historia que contribuye a implementar.
- Como cada tarea debe tener un estado actualizado que refleje su avance real.

# Priorización (MoSCoW)

Clasifica las historias y tareas según el método MoSCoW para identificar qué es imprescindible, importante, deseable o queda fuera de la versión actual.

**Must (imprescindible para v1):**

- [HU-XXX], [HU-XXX], [HU-XXX].
- [T-XXX], [T-XXX], [T-XXX].

**Should (importante, deseable en v1):**

- [HU-XXX], [HU-XXX].
- [T-XXX], [T-XXX].

**Could (mejoras, post-v1):**

- [HU-XXX] o [T-XXX] con su justificación breve.

**Won't (fuera de v1, ya en alcance):**

- [Funcionalidad o capacidad explícitamente fuera de esta versión].

- Como cada historia o tarea debe clasificarse en una sola categoría MoSCoW.
- Como la categoría "Must" debe representar el mínimo producto viable de la versión.

## Hitos sugeridos

Propone una secuencia de hitos que agrupan tareas en entregables verificables. Cada hito debe representar un incremento funcional concreto.

| Hito   | Alcance                                                                                  |
| ------ | ---------------------------------------------------------------------------------------- |
| [H1]   | [Descripción breve del entregable y tareas agrupadas]                                    |

- Como cada hito debe representar un incremento verificable del producto.
- Como los hitos deben ordenarse de forma lógica respetando dependencias técnicas.

# Dependencias

Documenta las dependencias necesarias para ejecutar el proyecto: librerías nuevas, librerías existentes, dependencias externas y assets.

## Librerías nuevas

- [Nombre de la librería] ([versión o rango de versiones] — [propósito]).
- [Nombre de la librería] ([versión o rango de versiones] — [propósito]).

## Librerías existentes reutilizadas

- [Nombre del componente o utilidad] ([propósito dentro del proyecto]).
- [Nombre del componente o utilidad] ([propósito dentro del proyecto]).

## Externas (no agregar en v1)

- [Sistema, servicio o librería] se reserva para versiones posteriores.

## Assets

- [Descripción del asset] ([ubicación o fuente]).
- [Descripción del asset] ([ubicación o fuente]).

- Como cada dependencia nueva debe justificarse con su propósito concreto.
- Como las dependencias externas deben clasificarse claramente como "en alcance" o "fuera de alcance".

# Riesgos

Identifica los principales riesgos del backlog y su impacto, probabilidad y estrategia de mitigación. La tabla se mantiene priorizada por impacto y probabilidad.

| ID    | Riesgo                                                                | Impacto | Probabilidad | Mitigación                                                                                |
| ----- | --------------------------------------------------------------------- | ------- | ------------ | ----------------------------------------------------------------------------------------- |
| [R-XXX] | [Descripción del riesgo]                                          | [Alto / Medio / Bajo] | [Alta / Media / Baja] | [Acciones concretas para reducir probabilidad o impacto] |

- Como cada riesgo debe tener una mitigación concreta y ejecutable.
- Como los riesgos deben revisarse al inicio de cada iteración o sprint.
