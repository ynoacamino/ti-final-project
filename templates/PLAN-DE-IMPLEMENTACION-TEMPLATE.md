---
title: "[Título del Proyecto]"
subtitle: "Documento de planificación para el desarrollo del proyecto"
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

**Fecha de inicio:** [Mes Año]

**Módulo:** [Ruta principal del producto]

**Ubicación de código:** [Ruta del repositorio o carpeta principal]

**Stack:** [Tecnologías principales del proyecto]

**Documentos de referencia:** [Documento de alcance] (requisitos) y [Documento de backlog] (tareas técnicas)

- Como la información general debe identificar de forma única al proyecto y su versión.
- Como el stack debe listar únicamente las tecnologías relevantes para este plan.

# Objetivo

Definir el orden de construcción, la estrategia de desarrollo y los criterios de salida por fase para entregar el producto, minimizando retrabajos y maximizando valor temprano.

- Como el plan debe establecer un orden claro de construcción.
- Como el plan debe definir criterios de salida verificables para cada fase.
- Como el plan debe alinearse con los requisitos del documento de alcance y las tareas del backlog.

# Estrategia de implementación

- **Modelo de trabajo:** [incremental por hitos, MVP primero, iteraciones posteriores].
- **Criterio de orden:** [de base a cima — primero dependencias y estructura, después funcionalidades centrales, luego pulido y finalmente lanzamiento].
- **Validación continua:** [cada fase termina con un demo visible y un smoke test].
- **Mitigación temprana de riesgos:** [las decisiones arquitectónicas con mayor riesgo se aplican en las primeras fases].
- **Calidad continua:** [comandos de lint y verificación de tipos después de cada tarea].
- **Trazabilidad:** [cada tarea del plan referencia un ID del backlog].

- Como la estrategia debe definir un modelo de trabajo claro para todo el equipo.
- Como la estrategia debe priorizar la reducción de riesgo en las fases tempranas.
- Como cada tarea del plan debe referenciar su origen en el backlog.

# Fases del proyecto

Detalla cada fase del proyecto con su objetivo, épicas cubiertas, tareas a ejecutar y criterios de salida verificables. Agrega un bloque por cada fase identificada.

## Fase [N] — [Nombre de la fase]

**Objetivo:** [Descripción concreta del resultado esperado al cerrar la fase].

**Épicas cubiertas:** [Códigos de épica].

**Hito BACKLOG:** [Código del hito].

**Tareas:**

- [T-XXX] · [Descripción concreta de la tarea].
- [T-XXX] · [Descripción concreta de la tarea].
- [T-XXX] · [Descripción concreta de la tarea].

**Criterios de salida:**

- Como [condición verificable 1].
- Como [condición verificable 2].
- Como [condición verificable 3].

- Como cada fase debe tener un objetivo claro, medible y entregable.
- Como los criterios de salida deben ser comprobables mediante demo, prueba o revisión.
- Como las fases deben ordenarse respetando dependencias técnicas y de negocio.

# Cronograma estimado

Estima la duración y los entregables visibles de cada fase. La tabla sirve como resumen ejecutivo del plan.

| Fase | Duración    | Horas de desarrollo | Hito BACKLOG | Entregable visible                                       |
| ---- | ----------- | ------------------- | ------------ | -------------------------------------------------------- |
| [1]  | [X-Y días]  | [X-Y h]             | [H1]         | [Descripción breve del entregable]                       |
| **Total** | **[X-Y días]** | **[X-Y h]**     | —            | [Producto final esperado]                                |

**Notas:**

- [Supuesto de velocidad o capacidad del equipo].
- [Notas sobre la secuencia de fases o la flexibilidad del plan].
- [Política de calidad al cierre de cada fase].

- Como el cronograma debe ser realista y considerar la capacidad del equipo.
- Como cada fase debe indicar un entregable visible para validar su avance.

# Recursos necesarios

## Frameworks y librerías

| Tecnología            | Versión objetivo | Estado actual | Uso                                       |
| --------------------- | ---------------- | ------------- | ----------------------------------------- |
| [Tecnología]          | [Versión]        | [Instalado / A instalar] | [Propósito dentro del proyecto] |

## Componentes UI a agregar

- [Nombre del componente] ([propósito]).
- [Nombre del componente] ([propósito]).

## Assets externos

- [Descripción del asset] ([ubicación o fuente]).
- [Descripción del asset] ([ubicación o fuente]).

## Archivos del proyecto a modificar o crear

| Archivo                                              | Tipo   | Cambio                                                  |
| ---------------------------------------------------- | ------ | ------------------------------------------------------- |
| [Ruta del archivo]                                   | [Nuevo / Modificar] | [Descripción del cambio]                          |

- Como cada recurso debe estar claramente asociado a una tarea o fase.
- Como los componentes y librerías nuevas deben justificarse con su propósito concreto.

# Riesgos técnicos

Identifica los principales riesgos técnicos del plan, su impacto, probabilidad y la estrategia de mitigación aplicada en alguna fase concreta.

| ID    | Riesgo                                                                | Impacto | Probabilidad | Mitigación en este plan                                  |
| ----- | --------------------------------------------------------------------- | ------- | ------------ | --------------------------------------------------------- |
| [R-XXX] | [Descripción del riesgo]                                          | [Alto / Medio / Bajo] | [Alta / Media / Baja] | [Acciones concretas asociadas a una fase o tarea] |

- Como cada riesgo debe tener una mitigación concreta asociada a una fase o tarea del plan.
- Como los riesgos críticos deben abordarse en las primeras fases, no al final.

# Criterios de éxito

Enumera las condiciones globales que el proyecto debe cumplir para ser considerado exitoso. Estos criterios se verifican al cierre del proyecto.

- Como debe cumplirse [criterio de funcionalidad].
- Como debe cumplirse [criterio de calidad o rendimiento].
- Como debe cumplirse [criterio de cobertura o entrega].
- Como debe cumplirse [criterio de documentación o despliegue].

- Como cada criterio de éxito debe ser verificable mediante una prueba, demo o métrica concreta.
- Como los criterios de éxito deben cubrir alcance, calidad, rendimiento y entrega.
