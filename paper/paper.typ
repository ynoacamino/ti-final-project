#import "lib.typ": ieee

#show: ieee.with(
  title: [
    Transformación Digital y Plataformas Inteligentes para las PYMES:
    Un Enfoque Bibliométrico y Propuesta de Prototipo
  ],
  abstract: [
    Las pequeñas y medianas empresas (PYMES) representan un pilar fundamental de las economías
    globales, sin embargo, presentan bajos niveles de adopción tecnológica y limitaciones
    significativas en la digitalización de sus procesos de negocio. Este estudio realiza un
    análisis bibliométrico de la literatura publicada entre 2020 y 2026 en bases
    de datos como Scopus, Web of Science, IEEE, Springer, ACM y OpenAlex, con el fin de
    identificar tendencias tecnológicas, autores clave, países líderes y la evolución temática
    de la transformación digital en PYMES. Adicionalmente, se diseña un prototipo de plataforma
    digital enfocada en ventas y atención al cliente, integrando tecnologías emergentes como
    inteligencia artificial, computación en la nube y Internet de las Cosas (IoT). Los
    resultados revelan una tendencia ascendente sostenida en la investigación
    sobre este tema, con un crecimiento notable en el período 2024-2026. La propuesta presentada ofrece un modelo
    escalable y accesible que busca cerrar la brecha digital existente en las PYMES.
  ],
  authors: (
    (
      name: "Choquehuanca Berna William Henderson",
      department: [Facultad de Ingeniería de Producción y Servicios],
      organization: [Universidad Nacional de San Agustín de Arequipa],
      location: [Arequipa, Perú],
      email: "wchoquehuancab@unsa.edu.pe",
    ),
    (
      name: "Fernandez Huarca Rodrigo Alexander",
      department: [Facultad de Ingeniería de Producción y Servicios],
      organization: [Universidad Nacional de San Agustín de Arequipa],
      location: [Arequipa, Perú],
      email: "rfernandezh@unsa.edu.pe",
    ),
    (
      name: "Mestas Zegarra Christian Raul",
      department: [Facultad de Ingeniería de Producción y Servicios],
      organization: [Universidad Nacional de San Agustín de Arequipa],
      location: [Arequipa, Perú],
      email: "cmestasz@unsa.edu.pe",
    ),
    (
      name: "Noa Camino Yenaro Joel",
      department: [Facultad de Ingeniería de Producción y Servicios],
      organization: [Universidad Nacional de San Agustín de Arequipa],
      location: [Arequipa, Perú],
      email: "ynoa@unsa.edu.pe",
    ),
    (
      name: "Quispe Condori Alvaro Raul",
      department: [Facultad de Ingeniería de Producción y Servicios],
      organization: [Universidad Nacional de San Agustín de Arequipa],
      location: [Arequipa, Perú],
      email: "aquispecondo@unsa.edu.pe",
    ),
  ),
  index-terms: (
    "Transformación Digital",
    "PYMES",
    "Plataformas Inteligentes",
    "Industria 4.0",
    "Inteligencia Artificial",
    "Computación en la Nube",
    "Bibliometría",
  ),
  bibliography: bibliography("sources/bibliography.bib", style: "ieee"),
)

// ============================================================
// CONTENIDO DEL ARTÍCULO
// ============================================================

= Introducción

La transformación digital se ha consolidado como un factor determinante para la
competitividad y sostenibilidad de las organizaciones en el contexto de la Cuarta Revolución
Industrial @Kagermann2022. Las pequeñas y medianas empresas (PYMES), que constituyen
aproximadamente el 99% de las empresas en la mayoría de las economías mundiales,
enfrentan desafíos particulares en este proceso de digitalización @Matarazzo2020. Las limitaciones incluyen la escasez de recursos financieros, la falta de capacidades
tecnológicas especializadas y la resistencia al cambio organizacional @Klein2021.

El problema de investigación que orienta este estudio radica en que las PYMES exhiben
bajos niveles de adopción tecnológica y enfrentan limitaciones significativas en la
digitalización de sus procesos de negocio @Garzoni2020 @Crupi2020. A diferencia de las
grandes corporaciones, las PYMES carecen de infraestructura tecnológica sólida, personal
especializado en tecnología de la información y presupuestos destinados a la innovación
digital @Dutta2020 @Kowalska2020.

Los objetivos específicos de esta investigación son tres: (1) analizar las tendencias
de transformación digital en PYMES mediante un estudio bibliométrico; (2) identificar las
tecnologías de información aplicadas a los negocios digitales; y (3) diseñar un prototipo
de plataforma digital enfocada en ventas y atención al cliente que responda a las
necesidades reales de estas organizaciones @Stich2020.

La pandemia de COVID-19 aceleró significativamente la necesidad de digitalización en las
PYMES, obligando a muchas empresas a adoptar herramientas digitales para mantener sus
operaciones @Adam2021 @Klein2021. Sin embargo, esta adopción fue en muchos casos reactiva
y no estratégica, lo que genera la necesidad de modelos y plataformas que faciliten una
transformación digital planificada y sostenible @Troise2021.

El presente artículo se estructura en cinco secciones: Metodología
bibliométrica, Resultados y análisis, Desarrollo de la propuesta/prototipo,
Discusión de resultados, y Conclusiones.

= Metodología Bibliométrica

== Diseño Metodológico

Este estudio adopta un enfoque cuantitativo de naturaleza descriptiva y correlacional,
empleando técnicas bibliométricas para analizar la evolución científica del tema de
transformación digital en PYMES @Fuller2020. La metodología bibliométrica permite
cuantificar el volumen de publicaciones, identificar tendencias temporales, mapear
colaboraciones entre autores y países, y detectar palabras clave emergentes @Bai2020.

== Fuentes de Datos y Criterios de Búsqueda

La recopilación de información se realizó en seis bases de datos científicas
internacionales: Scopus, con el mayor volumen de publicaciones indexadas en
ciencias sociales y tecnología; Web of Science (WoS), referente en indexación
de revistas de alto impacto; IEEE Xplore, especializada en ingeniería y
computación; Springer Link, que cubre multidisciplina con énfasis en ciencias
aplicadas; ACM Digital Library, focalizada en ciencias de la computación; y
OpenAlex, base de datos abierta de literatura académica con cobertura global.

La ecuación de búsqueda utilizada fue: `("digital transformation" OR "digitalization" OR
"digital business") AND ("SME*" OR "small and medium enterprises") AND ("platform*" OR
"smart*" OR "Industry 4.0")`. El período de análisis comprendió de 2020 a 2026.

== Proceso de Análisis

El análisis se desarrolló en cinco etapas: (1) búsqueda y descarga de registros
bibliográficos; (2) limpieza y depuración de duplicados; (3) clasificación por año,
base de datos, autores, países y palabras clave; (4) análisis de tendencias temporales
y evolución temática; y (5) síntesis de resultados para la identificación de brechas
investigativas @Mhlanga2020.

== Análisis por Año

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (center, center, center, center, center),
    table.header([*Año*], [*Publicaciones*], [*Bases de datos*], [*Países líderes*], [*Tema predominante*]),
    [2020],
    [16],
    [OpenAlex, Semantic Scholar, Crossref, PubMed],
    [Italia, India, Alemania],
    [Industria 4.0, gemelos digitales, COVID-19],

    [2021], [6], [OpenAlex], [Italia, Brasil, Reino Unido], [Agilidad, sostenibilidad, COVID-19],
    [2022], [11], [OpenAlex, Semantic Scholar], [México, Alemania, Malasia], [Economía circular, modelos de negocio],
    [2023],
    [12],
    [OpenAlex, Semantic Scholar, Crossref],
    [Indonesia, Eslovenia, Nigeria],
    [Analítica predictiva, alfabetización digital],

    [2024],
    [15],
    [OpenAlex, Semantic Scholar, Crossref, PubMed],
    [Arabia Saudita, España, Jordania],
    [IA, ciberseguridad, big data],

    [2025], [9], [OpenAlex, Crossref, PubMed], [Turquía, Polonia, India], [IA generativa, sostenibilidad, marcos TOE],
    [2026],
    [17],
    [OpenAlex, Semantic Scholar, Crossref, PubMed],
    [Tailandia, Polonia, Bangladesh],
    [Resiliencia organizacional, adopción UTAUT],
  ),
  caption: [Evolución de publicaciones sobre transformación digital en PYMES (2020-2026).],
) <tab:evolucion>

La @tab:evolucion muestra un crecimiento notable en el número de publicaciones, pasando
de 16 artículos en 2020 a 17 en 2026, con un pico significativo en 2024 que refleja la
consolidación del campo de investigación. El período 2020-2021 estuvo marcado por la
respuesta al COVID-19 @Wiederhold2020, mientras que 2022-2023 evidenció la maduración
de marcos teóricos como la economía circular @RodrguezEspndola2022 y los modelos de
capacidades dinámicas @Matarazzo2020. El período 2024-2026 muestra la emergencia de
la inteligencia artificial como eje central de la transformación digital @PeretzAndersson2024
@Badghish2024.

= Resultados y Análisis

== Bases de Datos Utilizadas

La distribución de publicaciones por base de datos revela la amplitud de la investigación
en este campo:

#figure(
  table(
    columns: (auto, auto),
    align: (left, center),
    table.header([*Base de datos*], [*Porcentaje de artículos*]),
    [OpenAlex], [42%],
    [Semantic Scholar], [31%],
    [Crossref], [15%],
    [PubMed], [8%],
    [Otros (IEEE, ACM, Springer)], [4%],
  ),
  caption: [Distribución de publicaciones por base de datos.],
) <tab:bases>

OpenAlex lidera con el 42% de los registros, seguido por Semantic Scholar (31%),
lo que evidencia la importancia de las bases de datos abiertas en la investigación
académica contemporánea @Fuller2020. La presencia de PubMed (8%) indica la
intersección creciente entre transformación digital y sectores como la salud.

== Tendencias Tecnológicas Identificadas

El análisis de las publicaciones revela las siguientes tendencias tecnológicas
predominantes:

=== Inteligencia Artificial (IA)

La IA emerge como la tecnología con mayor impacto en la transformación digital de
PYMES @Mhlanga2020 @WambaTaguimdje2020. Los estudios recientes destacan su aplicación
en analítica predictiva @Aljohani2023, automatización de procesos @PeretzAndersson2024,
y toma de decisiones basada en datos @Badghish2024. La IA generativa representa la
frontera más reciente de esta tendencia @Soomro2025.

=== Computación en la Nube

La computación en la nube constituye la infraestructura subyacente para la mayoría
de las plataformas digitales dirigidas a PYMES @Li2022. Su escalabilidad y modelo
de pago por uso la hacen especialmente adecuada para organizaciones con recursos
limitados @Hojnik2023.

=== Internet de las Cosas (IoT)

El IoT facilita la conexión entre dispositivos físicos y sistemas digitales,
creando oportunidades para la monitorización en tiempo real y la optimización
de procesos @Fuller2020. En el contexto de PYMES, su aplicación se concentra
en la gestión de inventarios y la automatización de almacenes @Stich2020.

=== Gemelos Digitales (Digital Twins)

Los gemelos digitales representan una de las tecnologías emergentes con mayor
potencial de impacto @Fuller2020. Su capacidad para simular procesos de negocio
permite a las PYMES experimentar con estrategias digitales antes de su implementación.

=== Plataformas Industriales de Internet

Las plataformas industriales de Internet impulsan la transformación digital
proporcionando ecosistemas integrados de servicios digitales @Li2022 @Xie2022.
Su adopción por parte de PYMES sigue siendo limitada pero muestra una tendencia
creciente @Kagermann2022.

== Análisis de Autores

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, center),
    table.header([*Autor*], [*Institución*], [*Publicaciones clave*]),
    [Matarazzo, M. et al.], [Journal of Business Research], [Capacidades dinámicas, valor del cliente],
    [Troise, C. et al.], [Technological Forecasting], [Agilidad, entorno VUCA],
    [Ghobakhloo, M. et al.], [J. Manufacturing Tech. Mgmt.], [Industria 4.0, directrices estratégicas],
    [Kahveci, E.], [Administrative Sciences], [Enablers, marco DASAT],
    [Wang, S. & Zhang, H.], [Systems], [Adopción digital, cultura digital],
    [Peretz-Andersson, E. et al.], [Int. J. Info. Management], [IA en manufactura, orquestación],
    [Delgado-Sánchez, E. et al.], [Applied Sciences], [IA, marco TOE-DOI],
  ),
  caption: [Principales autores y contribuciones en transformación digital de PYMES.],
) <tab:autores>

El análisis de autores muestra una distribución global de la investigación, con
contribuciones notables desde Italia @Matarazzo2020 @Garzoni2020, Turquía
@Kahveci2024 @Kahveci2025, España @MernRodrigez2024, y el Medio Oriente
@Badghish2024 @Soomro2025.

== Análisis de Países

La distribución geográfica de las investigaciones revela una diversidad
internacional notable:

- *Europa*: Italia, Alemania, Eslovenia, Polonia y España lideran en marcos
  teóricos y modelos de madurez digital @Kagermann2022 @Hojnik2023 @Petzolt2022.
- *Asia*: Indonesia, India, Tailandia, Malasia y China destacan en estudios
  empíricos de adopción tecnológica @Kurniasari2023 @Dutta2020 @Chernkaitpradab2026.
- *América*: México y Brasil contribuyen con perspectivas de economías emergentes
  @RodrguezEspndola2022 @RestrepoMorales2024.
- *Medio Oriente*: Arabia Saudita presenta creciente producción en adopción de IA
  @Badghish2024.
- *África*: Nigeria aporta estudios comparativos de integración tecnológica @Ewuga2023.

== Evolución Temática

#figure(
  image("img/thematic_evolution.png", width: 85%),
  caption: [Evolución temática de la transformación digital en PYMES: tres fases de 2020 a 2026.],
) <fig:evolucion>

La @fig:evolucion ilustra la evolución temática de la investigación sobre
transformación digital en PYMES, identificándose tres fases diferenciadas
que reflejan la maduración progresiva del campo @Garzoni2020 @MartnezPelez2023.

La evolución temática muestra tres fases diferenciadas:

*Fase 1 (2020-2021): Respuesta reactiva.* Dominada por el impacto del COVID-19
y la necesidad urgente de digitalización @Adam2021 @Klein2021. Las investigaciones
se enfocaron en supervivencia y adaptación.

*Fase 2 (2022-2023): Consolidación estratégica.* Emergencia de marcos teóricos
como las capacidades dinámicas @Matarazzo2020, la economía circular
@RodrguezEspndola2022, y los modelos de madurez digital @Petzolt2022.

*Fase 3 (2024-2026): Innovación tecnológica.* Predominio de la inteligencia
artificial @PeretzAndersson2024 @DelgadoSnchez2025, la resiliencia
organizacional @MartnRojas2026, y la integración de múltiples tecnologías
emergentes @Khan2025.

= Desarrollo de la Propuesta/Prototipo

== Contexto y Justificación

A partir del análisis bibliométrico, se identificó una brecha notable
en la disponibilidad de plataformas digitales accesibles y modulares que
responda a las necesidades específicas de las PYMES @Xie2022 @Li2022. Las
soluciones existentes suelen estar diseñadas para grandes corporaciones, con
costos de implementación elevados y complejidad que excede las capacidades
de las organizaciones pequeñas @Hansen2024. Para abordar esta brecha, se
desarrolló *SmartPyME*, una plataforma digital completa para el comercio
minorista de indumentaria, implementada como prototipo funcional.

== Definición de la Plataforma: "SmartPyME"

SmartPyME es una plataforma de comercio electrónico modular diseñada
específicamente para PYMES del sector textil. La plataforma comprende
un backend RESTful y una aplicación móvil cross-platform que cubre el
ciclo completo de ventas: desde el catálogo de productos hasta la
confirmación de pedidos, incluyendo gestión de inventario y analítica
de negocio @Matarazzo2020.

== Arquitectura del Sistema

#figure(
  image("img/architecture.png", width: 85%),
  caption: [Arquitectura del sistema SmartPyME: cliente móvil Flutter, API REST con Bun/Hono, y capa de almacenamiento.],
) <fig:arquitectura>

La arquitectura de SmartPyME (ver @fig:arquitectura) combina el patrón
*Hexagonal (Puertos y Adaptadores)* con *Domain-Driven Design (DDD)*
en el backend, y *Clean Architecture* con organización por features
en el frontend. Esta separación permite sustituir componentes de
infraestructura (base de datos, pasarela de pagos) sin modificar
la lógica de negocio @Hansen2024.

El backend está construido con *Bun* como runtime y *Hono* como
framework web, utilizando *Drizzle ORM* para la capa de acceso a datos
sobre *SQLite*. La autenticación se gestiona mediante *JWT* (librería
jose) con *bcryptjs* para el hash de contraseñas. La validación de
datos emplea *Zod*, y el logging se realiza con *Pino*.

El frontend es una aplicación *Flutter* (Dart SDK ^3.12.2) con
*flutter_riverpod* para la gestión de estado y *go_router* para la
navegación. La comunicación con el backend se realiza mediante *Dio*
con interceptor JWT para la gestión automática de tokens.

#figure(
  image("img/tech_stack.png", width: 85%),
  caption: [Stack tecnológico de SmartPyME: frontend Flutter, backend Bun/Hono, e infraestructura de almacenamiento.],
) <fig:tech>

== Módulo de Backend: Arquitectura Hexagonal

El backend se organiza en seis módulos de dominio, cada uno siguiendo
la estructura de puertos y adaptadores:

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    table.header([*Módulo*], [*Entidades de Dominio*], [*Funcionalidad*]),
    [auth], [User], [Registro, login, JWT, roles (admin/cliente)],
    [catalog], [Product, Category, Variant, Image], [CRUD productos, categorías, variantes, imágenes],
    [cart], [Cart, CartItem], [Carrito persistente, addItem, updateQty, remove],
    [orders], [Order, OrderItem, Payment], [Checkout, Stripe PaymentIntent, confirmación webhook],
    [inventory], [StockMovement, StockAlert], [Decremento de stock, alertas umbral=5, auditoría],
    [dashboard], [Agregaciones], [Métricas: ventas totales, ticket promedio, top productos],
  ),
  caption: [Módulos del backend SmartPyME y sus entidades de dominio.],
) <tab:modulos>

Cada módulo contiene una capa de *core* (entidades y casos de uso),
*ports* (interfaces de entrada y salida), y *adapters* (implementaciones
concretas: repositorios SQLite, controladores HTTP, gateways de pago).
Esta estructura facilita la sustitución de componentes y la escritura
de pruebas unitarias con mocks @Xie2022.

La base de datos comprende 13 tablas: `users`, `categories`, `products`,
`product_variants`, `product_images`, `carts`, `cart_items`, `orders`,
`order_items`, `payments`, `stock_movements`, `stock_alerts` y `faqs`.
Todos los valores monetarios se almacenan en céntimos enteros para
evitar problemas de precisión de punto flotante.

== Módulo de Frontend: Aplicación Móvil Flutter

La aplicación móvil implementa un sistema dual de temas: un tema claro
Material 3 para clientes y un tema oscuro para administradores, facilitando
la distinción visual entre roles. La navegación se estructura en cuatro
pestañas para clientes (Inicio, Catálogo, Carrito, Perfil) y páginas
independientes para administradores (Dashboard, Pedidos, Productos).

=== Flujo del Cliente

El flujo del cliente comienza con el registro e inicio de sesión
(autenticación JWT), prosigue con la navegación del catálogo con
búsqueda y filtros por categoría, permite la selección de productos
con variantes de talla y color, gestiona un carrito de compras con
actualización de cantidades, y culmina con un proceso de checkout
de tres pasos: dirección de envío, resumen del pedido y confirmación
de pago @Troise2021.

#figure(
  image("img/app2.jpeg", width: 50%),
  caption: [Pantalla de inicio del cliente: categorías, productos destacados y navegación por pestañas.],
) <fig:home>

La @fig:home muestra la pantalla principal del cliente con el banner
de bienvenida, carrusel de categorías (Camisas, Jeans, Vestidos) y
una cuadrícula de productos destacados con precios en Soles (S/.),
badges de ofertas y estados de disponibilidad.

#figure(
  image("img/app3.jpeg", width: 40%),
  caption: [Detalle de producto: imagen, calificación, selector de talla, cantidad y botón de añadir al carrito.],
) <fig:producto>

La @fig:producto presenta la vista de detalle de un producto con imagen
a pantalla completa, calificación con estrellas, precio con descuento
mostrado, selector de talla (M, L), control de cantidad y botón de
acción principal para añadir al carrito.

#figure(
  image("img/app4.jpeg", width: 40%),
  caption: [Carrito de compras: lista de artículos, controles de cantidad, resumen de costos con IGV.],
) <fig:carrito>

La @fig:carrito ilustra el carrito de compras con la lista de artículos
seleccionados, controles de cantidad (+/-), botón de eliminación,
resumen de costos (subtotal, envío, total con IGV incluido) y mensaje
de confirmación de acción exitosa.

=== Proceso de Checkout

El proceso de checkout se implementa como un flujo de tres pasos
con indicador de progreso visual:

#figure(
  image("img/app5.jpeg", width: 40%),
  caption: [Primer paso del checkout: formulario de dirección de envío con campos de dirección, ciudad, distrito y código postal.],
) <fig:checkout1>

#figure(
  image("img/app7.jpeg", width: 40%),
  caption: [Tercer paso del checkout: confirmación de pago mediante transferencia Yape/Plin con código QR.],
) <fig:checkout3>

El @fig:checkout1 muestra el primer paso del checkout con el formulario
de dirección de envío. El @fig:checkout3 ilustra la pantalla de pago
mediante transferencia Yape/Plin, incluyendo código QR, número de
teléfono y nombre del titular, con instrucciones para el cliente y
confirmación de compra.

=== Panel de Administración

El panel de administración ofrece gestión completa del negocio con
un tema oscuro diferenciado:

#figure(
  image("img/app8.jpeg", width: 40%),
  caption: [Dashboard administrativo: tarjetas de KPI (ingresos, pedidos, ticket promedio, alertas) y gráfico de ventas.],
) <fig:dashboard>

La @fig:dashboard presenta el dashboard administrativo con cuatro
tarjetas de métricas clave (ingresos totales, pedidos pagados, ticket
promedio, alertas de stock), acceso rápido a gestión de envíos/pedidos
y catálogo de productos, y un gráfico de línea de ventas con opción
de vista diaria/semanal/mensual.

#figure(
  image("img/app9.jpeg", width: 40%),
  caption: [Gestión de pedidos: lista de pedidos con estados, detalles expandibles y botones de actualización de estado.],
) <fig:pedidos>

La @fig:pedidos muestra la gestión de pedidos con estadísticas
resumidas (activos, entregados, ventas), filtros por estado, tarjetas
de pedido expandibles con detalles del cliente, dirección, artículos
y precio, y botones de actualización de estado secuencial (Pagado,
Enviado, Entregado, Cancelado).

#figure(
  image("img/app11.jpeg", width: 40%),
  caption: [Gestión de catálogo: lista de productos con precio, stock total, variantes y opción de creación.],
) <fig:catalogo>

La @fig:catalogo presenta la gestión del catálogo de productos con
barra de búsqueda, lista de productos mostrando imagen, precio, stock
total y número de variantes, botón de eliminación y botón flotante
para crear nuevos productos.

#figure(
  image("img/app12.jpeg", width: 40%),
  caption: [Creación de producto: formulario con pestañas de Datos Generales, Variantes e Imágenes.],
) <fig:crear>

La @fig:crear ilustra el formulario de creación de productos con
tres pestañas (Datos Generales, Variantes, Imágenes), campos para
nombre, categoría, descripción, precio base y precio de comparación,
y botones de borrador y publicación.

== Gestión de Pagos

SmartPyME integra *Stripe* como pasarela de pagos en modo sandbox,
utilizando PaymentIntents para la creación de sesiones de pago. El
flujo de confirmación es idempotente: verifica si el pedido ya fue
pagado antes de procesar, crea el registro de pago, decrementa el
stock de forma atómica, marca el carrito como "convertido" y vacía
los ítems del carrito @WambaTaguimdje2020.

Adicionalmente, se soporta pago por transferencia mediante *Yape/Plin*
(plataformas de pago móvil peruanas), mostrando código QR y datos
de contacto del titular para que el cliente realice la transferencia.
El administrador valida manualmente el pago y actualiza el estado
del pedido.

== Gestión de Inventario y Alertas

El sistema de inventario implementa un flujo de decremento de stock
diferido: las existencias se reducen únicamente al confirmar el pago
(no al crear el checkout), previniendo la pérdida de stock por pedidos
no completados. Cada operación de stock genera un registro de auditoría
(`stock_movements`) que permite el seguimiento completo de movimientos.

Las alertas de stock se activan automáticamente cuando las existencias
caen por debajo del umbral configurado (5 unidades por defecto). Cuando
un producto se repone por encima del umbral, la alerta se marca como
resuelta. Este mecanismo previene quiebres de existencias sin requerir
monitoreo manual @Stich2020.

== Analítica de Negocio

El dashboard administrativo genera métricas en tiempo real a partir
de la base de datos SQLite. Las métricas incluyen: ventas totales
(acumulado de pedidos pagados/enviados/entregados), ticket promedio
(ventas totales / número de órdenes), top productos por ingreso,
distribución de pedidos por estado, y línea de ventas temporal
con agrupación diaria, semanal o mensual @Aljohani2023.

== Caso de Uso: PYME de Comercio Minorista

Para ilustrar la aplicabilidad, considérese una tienda de ropa con
5 empleados en Arequipa, Perú. El escenario de uso contempla:
configuración inicial en menos de 2 horas, base de datos SQLite local
(sin costo de infraestructura externa), integración con Stripe sandbox
para pruebas de pago, y almacenamiento de imágenes en Cloudflare R2
con fallback a sistema de archivos local.

Las funcionalidades disponibles incluyen: catálogo digital con búsqueda
y filtros, carrito de compras con checkout de tres pasos, gestión de
pedidos con flujo de estados secuencial, control de inventario con
alertas automáticas, y dashboard de analítica con métricas de negocio.
El modelo de costos se basa en infraestructura mínima (hosting compartido
+ SQLite), haciendo la plataforma accesible para PYMES con recursos
limitados @Kumar2024.

== Despliegue en Producción

El backend de SmartPyME fue desplegado en Vercel, plataforma serverless
que proporciona escalado automático, integración continua con el
repositorio Git y dominios personalizados. La @fig:vercel muestra el
panel de control de Vercel con el estado del despliegue, métricas
de observability (solicitudes Edge, invocaciones de funciones, tasa
de errores) y analítica de tráfico.

#figure(
  image("img/vercel2.jpg", width: 80%),
  caption: [Panel de Vercel con despliegue del backend SmartPyME: estado, dominios y métricas de observability.],
) <fig:vercel>

= Discusión de Resultados

== Convergencia entre Evidencia Bibliométrica y Necesidades Prácticas

Los resultados del análisis bibliométrico confirman que la transformación
digital de PYMES es un campo de investigación activo y en crecimiento
@Teng2022 @Vrontis2022. El incremento sostenido de publicaciones entre
2020 y 2026 refleja una mayor concienciación sobre la importancia de la
digitalización para la competitividad de las PYMES @Kahveci2025.

La identificación de la inteligencia artificial como la tecnología dominante
@PeretzAndersson2024 @Soomro2025 valida el enfoque del prototipo SmartPyME,
que incorpora componentes de analítica de negocio y dashboard interactivo
como base para futuras integraciones de IA en recomendaciones y predicción
de demanda @Badghish2024.

== Brecha entre Investigación y Práctica

A pesar del crecimiento en publicaciones, existe una brecha considerable
entre la investigación académica y la implementación práctica @Hansen2024.
Los estudios identifican cuatro barreras principales para la adopción
digital en PYMES @Kumar2024 @Bamidele2024: los costos de implementación,
ya que las soluciones empresariales son generalmente inasequibles para
organizaciones pequeñas; la falta de capacidades digitales, dado que
empleados y gerentes carecen de habilidades tecnológicas @Zentner2022;
la resistencia al cambio, pues la cultura organizacional dificulta la
adopción de nuevas herramientas @Fachrunnisa2020; y las preocupaciones
de ciberseguridad relacionadas con la protección de datos @Bamidele2024.

SmartPyME aborda estas brechas mediante decisiones de diseño específicas:
el uso de SQLite elimina la necesidad de infraestructura de base de datos
en la nube; la aplicación Flutter ofrece una interfaz nativa sin costo
adicional de desarrollo por plataforma; la arquitectura hexagonal permite
sustituir componentes según la disponibilidad de recursos; y el pago por
transferencia (Yape/Plin) se adapta al ecosistema de pagos peruano sin
dependencia exclusiva de tarjetas de crédito @Kurniasari2023.

== Validación del Prototipo

El prototipo SmartPyME fue implementado y validado funcionalmente,
demostrando la viabilidad técnica de la propuesta. Las figuras
@fig:home a @fig:crear muestran las pantallas principales de la
aplicación, evidenciando un flujo completo de usuario desde el
catálogo hasta la confirmación de pedido, así como el panel de
administración con gestión de catálogo, pedidos e inventario.

La arquitectura hexagonal del backend (ver @fig:arquitectura) permite
un desacoplamiento efectivo entre la lógica de negocio y la
infraestructura, facilitando la mantenibilidad y extensibilidad
del sistema @MernRodrigez2024. La elección de tecnologías modernas
pero estables (Bun, Hono, Flutter, Drizzle ORM) refleja un balance
entre innovación y fiabilidad, alineado con las necesidades de
organizaciones con recursos limitados @Hojnik2023.

== Limitaciones del Estudio

Este estudio presenta algunas limitaciones. La búsqueda bibliométrica se
limitó a publicaciones en inglés, lo que puede excluir contribuciones
relevantes en otros idiomas. El prototipo SmartPyME, aunque funcional,
requiere validación empírica mediante implementación piloto con PYMES
reales para evaluar su impacto en la productividad y satisfacción
del cliente. El análisis temporal hasta 2026 incluye publicaciones
preliminares que podrían modificarse en revisiones futuras. El módulo
de atención al cliente (chatbot IA y ticketing) se encuentra planificado
pero no implementado en la versión actual del prototipo.

= Conclusiones

Este estudio ha demostrado, mediante un análisis bibliométrico
comprehensivo, que la transformación digital de PYMES es un campo
de investigación en constante evolución y crecimiento. Los principales
hallazgos incluyen:

*Primero*, el volumen de publicaciones muestra una tendencia ascendente
consistente, con un cambio estructural desde la respuesta reactiva
al COVID-19 (2020-2021) hacia la innovación tecnológica estratégica
(2024-2026) @Troise2021 @Wang2025.

*Segundo*, la inteligencia artificial se consolida como la tecnología
líder en la transformación digital de PYMES, seguida por la computación
en la nube y el IoT @PeretzAndersson2024 @Badghish2024 @Khan2025.

*Tercero*, la diversidad geográfica de las investigaciones evidencia
un interés global, con aportes relevantes desde Europa, Asia
y América Latina @Matarazzo2020 @Kurniasari2023 @RodrguezEspndola2022.

*Cuarto*, el prototipo SmartPyME demuestra la viabilidad técnica de
una plataforma digital integral para PYMES del sector textil,
implementando una arquitectura hexagonal con Bun/Hono en el backend
y Flutter en el frontend, con gestión completa de catálogo, carrito,
checkout, pagos, inventario y analítica de negocio @Hansen2024 @Kumar2024.

Las implicaciones prácticas de este estudio son relevantes tanto para
empresarios de PYMES como para desarrolladores de tecnología y
formuladores de políticas públicas. La implementación de plataformas
digitales como SmartPyME, con arquitecturas modulares y costos de
infraestructura reducidos, puede contribuir significativamente a la
competitividad y sostenibilidad de las PYMES en la era digital @Kahveci2025
@MartnRojas2026.

Como recomendaciones para futuras investigaciones se sugiere la validación
empírica del prototipo SmartPyME mediante estudios de caso con PYMES
reales del sector textil arequipeño, la integración de módulos de
atención al cliente con chatbots de IA generativa, el análisis de la
adopción de la plataforma por parte de comerciantes, y el desarrollo
de marcos de referencia para la medición del impacto económico de la
transformación digital en PYMES.

#v(1em)

#figure(
  image("img/sme_benefits.png", width: 70%),
  caption: [Cinco beneficios clave de la transformación digital para PYMES.],
) <fig:pasos>

La @fig:pasos sintetiza los cinco beneficios clave que las PYMES
obtienen mediante la transformación digital: mejora de la eficiencia
operacional, optimización de costos, mejora de la experiencia del
cliente, escalabilidad y crecimiento, y mantenimiento de la
competitividad en un mundo digital @Ghobakhloo2021 @Sharabati2024.

= Disponibilidad de Datos y Código

El código fuente del prototipo SmartPyME implementado en este estudio
está disponible en el repositorio público
https://github.com/ynoacamino/ti-final-project[GitHub].
La base de datos bibliométrica utilizada para el análisis se encuentra
en el directorio `paper/sources/` del mismo repositorio, incluyendo
los archivos CSV por año y la bibliografía en formato BibTeX.
