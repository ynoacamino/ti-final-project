---
title: "[Título del Proyecto]"
subtitle: "Documento de Alcance del Proyecto"
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

# Introducción

En esta sección se presenta el documento y su propósito general. Describe de manera breve el proyecto, su contexto y la utilidad del propio documento como referencia para las fases posteriores.

- Como este documento debe servir como referencia contractual y funcional para las fases de diseño, implementación, pruebas y aceptación.
- Como este documento debe permitir alinear las expectativas del cliente y del equipo de desarrollo.

## Propósito

Explica el objetivo del documento: definir el alcance, los objetivos y los requisitos del proyecto. Indica a quién va dirigido (equipo de desarrollo, stakeholders, cliente) y cómo se utilizará a lo largo del ciclo de vida del proyecto.

- Como este documento debe definir el alcance, objetivos y requisitos del proyecto.
- Como este documento debe estar dirigido al equipo de desarrollo, stakeholders y cliente.
- Como este documento debe ser la base para las fases de diseño, implementación, pruebas y aceptación.

## Alcance

Describe de forma general qué cubre el proyecto y qué límites principales tiene. Enumera las funcionalidades o características centrales que serán entregadas.

- Como este módulo debe permitir [funcionalidad principal 1].
- Como este módulo debe permitir [funcionalidad principal 2].
- Como este módulo debe permitir [funcionalidad principal 3].

### Incluye

Lista los elementos, funcionalidades, módulos o servicios que forman parte del alcance del proyecto y que serán entregados. Cada viñeta se redacta como una capacidad concreta del producto.

- Como este módulo debe permitir [funcionalidad concreta].
- Como este módulo debe soportar [característica concreta].
- Como este módulo debe integrarse con [servicio o sistema concreto].

### No incluye

Enumera explícitamente lo que queda fuera del alcance para evitar ambigüedades y prevenir solicitudes de cambio no contempladas.

- Como este módulo no debe incluir [funcionalidad excluida].
- Como este módulo no debe integrar [servicio o sistema excluido].
- Como este módulo no debe requerir [componente o capacidad no contemplada].

## Definiciones y acrónimos

Define los términos técnicos, acrónimos y abreviaturas utilizadas a lo largo del documento para asegurar una comprensión común. La tabla se mantiene en orden alfabético.

| Término | Definición                                                   |
| ------- | ------------------------------------------------------------ |
| [Sigla] | [Significado del término en el contexto del proyecto]        |

## Referencias

Lista las normas, estándares, documentaciones oficiales y documentos internos que sustentan las decisiones técnicas o de requisitos del proyecto.

- Como referencia debe incluirse la norma o estándar relevante para el proyecto.
- Como referencia debe incluirse la documentación oficial de la tecnología principal.
- Como referencia debe incluirse la documentación interna del proyecto.


# Descripción general

Brinda una visión panorámica del producto, su contexto en el negocio, los usuarios involucrados, las restricciones que lo delimitan y los supuestos sobre los que se construye la solución.

## Contexto del producto

Describe el entorno en el que se ubica el producto: a qué plataforma pertenece, qué problemática resuelve, qué alternativa reemplaza o complementa y por qué es necesario.

- Como este producto debe estar embebido en [plataforma o sistema].
- Como este producto debe resolver [problemática específica].
- Como este producto debe reemplazar o complementar [solución actual].

## Objetivos del negocio

Enumera los objetivos estratégicos que el producto debe cumplir, redactados de manera concreta y orientados al valor que aporta a la organización o a los usuarios.

- Como este producto debe [objetivo estratégico 1].
- Como este producto debe [objetivo estratégico 2].
- Como este producto debe [objetivo estratégico 3].

## Tipos de usuarios

Identifica los roles o perfiles de usuarios que interactuarán con el producto. Para cada rol se describe brevemente sus necesidades y nivel de acceso.

| Rol           | Descripción                                                           |
| ------------- | --------------------------------------------------------------------- |
| [Nombre del rol] | [Descripción del rol, sus necesidades y permisos]                 |

Si existen múltiples roles con distintos niveles de acceso, se agrega una fila por cada uno y se describen sus diferencias.

- Como debe existir al menos un rol de [tipo de usuario].
- Como debe existir al menos un rol de [tipo de usuario].

## Restricciones

Enumera las limitaciones técnicas, operativas, regulatorias o de negocio que condicionan las decisiones de diseño e implementación.

- Como el proyecto debe limitarse a [restricción técnica u operativa].
- Como el proyecto debe cumplir con [restricción regulatoria o de negocio].
- Como el proyecto debe respetar [plazo, presupuesto o tecnología obligatoria].

## Supuestos y dependencias

Lista los supuestos considerados válidos al momento de redactar el documento y las dependencias externas requeridas para la correcta ejecución del proyecto.

- Como se asume que el usuario dispone de [recurso o capacidad].
- Como se depende de [servicio, sistema o equipo externo].
- Como se asume que [condición previa al inicio del proyecto].


# Requisitos funcionales

Detalla las funcionalidades que el sistema debe proveer. Cada requisito se documenta con un código único, una descripción, una prioridad y criterios de aceptación verificables.

## [Código] [Nombre corto del requisito]

**Descripción:**

Redacta de forma clara y concisa qué debe hacer el sistema. Explica el comportamiento esperado, los actores involucrados y el contexto en el que se aplica.

- Como el sistema debe permitir [acción principal del requisito].
- Como el sistema debe validar [condición o regla aplicable].
- Como el sistema debe responder con [resultado esperado] cuando [evento o acción].

**Prioridad:** [Alta / Media / Baja]

**Criterios de aceptación:**

Lista las condiciones observables y verificables que deben cumplirse para considerar el requisito como implementado. Cada criterio debe ser comprobable mediante una prueba, una revisión o una demostración concreta.

- Como debe aceptarse [entrada válida específica].
- Como debe rechazarse [entrada inválida específica] mostrando un mensaje claro.
- Como debe actualizarse [salida esperada] al modificarse [entrada relacionada].


# Requisitos no funcionales

Documenta los atributos de calidad del sistema: rendimiento, seguridad, disponibilidad, compatibilidad, escalabilidad, usabilidad, mantenibilidad, entre otros. A diferencia de los requisitos funcionales, estos describen cómo se comporta el sistema, no qué hace.

## [Código] [Atributo de calidad]

Describe el requisito no funcional y, cuando aplique, incluye valores cuantitativos o umbrales medibles (tiempos de respuesta, tasas, tamaños máximos, niveles de servicio).

- Como el sistema debe responder en menos de [tiempo] bajo [condición de carga].
- Como el sistema debe soportar al menos [cantidad o tasa] de [operación].
- Como el sistema debe mantener [atributo de calidad medible] durante [condición de uso].


# Modelo de datos

Describe las entidades principales del sistema, sus atributos más relevantes y las relaciones de alto nivel entre ellas. Este apartado sirve como base para el diseño de la base de datos o de las estructuras de datos en memoria.

## Entidades principales

Lista y describe las entidades del dominio. Para cada una se mencionan sus atributos clave y, si aplica, su propósito dentro del sistema.

- **[Entidad 1]:** [Atributo 1], [Atributo 2], [Atributo 3].
- **[Entidad 2]:** [Atributo 1], [Atributo 2], [Atributo 3].
- Como debe existir una entidad que represente [concepto del dominio].


# Integraciones

Documenta los sistemas externos, APIs, servicios o plataformas con los que el producto se integra. Para cada integración se indica su propósito, el responsable y el tipo de interacción.

| Sistema         | Descripción                                                    | Responsable |
| --------------- | -------------------------------------------------------------- | ----------- |
| [Nombre]        | [Propósito y tipo de integración]                              | [Equipo/área] |

Si el producto no integra sistemas externos en esta versión, se indica explícitamente y se reserva este apartado para documentar integraciones futuras.

- Como esta versión no integra sistemas externos.
- Como las integraciones con [sistema externo] quedan para versiones posteriores.


# Reglas de negocio

Documenta las reglas invariantes del dominio que el sistema debe respetar en todo momento. Cada regla tiene un código único y una descripción clara y verificable.

| Código  | Regla                                                                         |
| ------- | ----------------------------------------------------------------------------- |
| [RN-XXX] | [Regla de negocio que el sistema debe cumplir]                              |


# Casos de uso

Lista los casos de uso principales del sistema, identificando el actor que los ejecuta y una breve descripción del flujo o resultado esperado. Esta tabla sirve como resumen de alto nivel; los flujos detallados se desarrollan en documentos anexos si es necesario.

| Código  | Nombre                       | Actor principal | Descripción                                                 |
| ------- | ---------------------------- | --------------- | ----------------------------------------------------------- |
| [CU-XXX] | [Nombre del caso de uso]   | [Actor]        | [Descripción breve del flujo y resultado esperado]         |


# Criterios de aceptación del proyecto

Enumera las condiciones globales que el producto completo debe satisfacer para ser considerado aceptado por el cliente o los stakeholders. Estos criterios se verifican al cierre del proyecto mediante pruebas de aceptación.

- Como el usuario debe poder [acción global verificable].
- Como el sistema debe [comportamiento global esperado] bajo [condición].
- Como debe entregarse [documentación o entregable requerido].


# Riesgos

Identifica los principales riesgos del proyecto, su impacto, probabilidad y la estrategia de mitigación propuesta. La tabla se mantiene priorizada por impacto y probabilidad.

| Riesgo                                                     | Impacto | Probabilidad | Mitigación                                                                              |
| ---------------------------------------------------------- | ------- | ------------ | ---------------------------------------------------------------------------------------- |
| [Descripción del riesgo]                                   | [Alto / Medio / Bajo] | [Alta / Media / Baja] | [Acciones concretas para reducir probabilidad o impacto]            |


# Anexos

En esta sección se incluye información complementaria que apoya la comprensión del documento: fórmulas, diagramas, limitaciones, formatos soportados, glosarios visuales u otra información técnica relevante.

## Fórmulas o cálculos relevantes

Si el sistema realiza cálculos internos (cotizaciones, conversiones, métricas), se documentan aquí las fórmulas o algoritmos principales. Se usan bloques de código para mantener el formato y se acompañan con notas que expliquen las variables.

```text
[variable_resultado] = [operación sobre variables de entrada]
```

- Como debe documentarse si la fórmula puede evolucionar.
- Como deben indicarse los valores configurables y dónde se almacenan.
- Como debe explicarse el significado de cada variable de la fórmula.

## Arquitectura propuesta

Incluye un diagrama de alto nivel que muestre los componentes principales del sistema y el flujo de datos o de control entre ellos. Se puede usar bloques de texto, mermaid o imágenes.

```text
[Componente origen]
   |
   v
[Componente intermedio]
   |
   v
[Componente destino]
```

- Como el diagrama debe mostrar el flujo principal de información.
- Como el diagrama debe identificar los componentes clave del sistema.
- Como el diagrama debe incluir las dependencias externas relevantes.

## Fuera de alcance (No requerido)

Refuerza el listado de elementos explícitamente excluidos del alcance. Sirve como recordatorio para evitar ambigüedades y para fundamentar el rechazo de solicitudes no contempladas.

En esta versión no se implementará:

- [Funcionalidad o integración no incluida].
- [Funcionalidad o integración no incluida].
- [Funcionalidad o integración no incluida].

## Limitaciones conocidas

Documenta las limitaciones técnicas o de diseño que el usuario debe conocer: variables no consideradas, aproximaciones utilizadas, escenarios no soportados. Esto gestiona expectativas sobre la precisión o el alcance real de la solución.

- Como [variable o factor] no se considera en el cálculo.
- Como [comportamiento] es solo una aproximación y no una simulación exacta.
- Como [escenario] no está soportado en esta versión.

## Formatos soportados

Si el sistema procesa archivos, datos o protocolos específicos, se listan aquí los formatos aceptados, los previstos a futuro y cualquier nota relevante sobre su tratamiento.

| Formato | Soporte | Manejador o parser      | Notas                                              |
| ------- | ------- | ----------------------- | -------------------------------------------------- |
| [Extensión] | [Sí / Futuro] | [Nombre del parser] | [Notas de uso o limitaciones]                |

## Glosario visual

Describe la distribución de los elementos en la interfaz de usuario: paneles, secciones, jerarquías y principales áreas de interacción. Esto facilita la alineación entre diseño, desarrollo y stakeholder.

- **[Área de la interfaz]:** [Descripción de su contenido y función].
- **[Área de la interfaz]:** [Descripción de su contenido y función].
- Como cada panel debe tener una responsabilidad clara y diferenciada.
