# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Habilita la compatibilidad con la función experimental de diseño de mampostería CSS. Consulta la <a data-l10n-name="explainer">explicación</a> para obtener una descripción de alto nivel de la funcionalidad. Para enviar comentarios, comenta en <a data-l10n-name="w3c-issue">este problema de GitHub</a> o en <a data-l10n-name="bug">este error</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Esta nueva API proporciona soporte de bajo nivel para realizar cálculos y renderizado de gráficos usando la <a data-l10n-name="wikipedia">unidad de procesamiento de gráficos (GPU)</a> de la computadora o dispositivo del usuario. La <a data-l10n-name="spec">especificación</a> todavía no es definitiva. Consulta el <a data-l10n-name="bugzilla">bug 1602129</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Con esta función activada, { -brand-short-name } soporta el formato de archivo de imagen AV1 (AVIF). Este es un formato de archivo de imagen fija que aprovecha las capacidades de los algoritmos de compresión de video AV1 para reducir el tamaño de la imagen. Consulta el <a data-l10n-name="bugzilla">bug 1443863</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Nuestra implementación del atributo global <a data-l10n-name="mdn-inputmode">inputmode</a> se ha actualizado según <a data-l10n-name="whatwg">la especificación WHATWG</a>, pero todavía necesitamos hacer más cambios, como por ejemplo que quede disponible en contenidos contenteditable. Consulta el <a data-l10n-name="bugzilla">bug 1205133</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = El atributo <a data-l10n-name="rel">rel</a> con valor <code>"preload"</code> en un elemento <a data-l10n-name="link">&lt;link&gt;</a> está destinado a ayudar a proveer mejoras de rendimiento al permitir descargar recursos de la página previamente, asegurando que estén disponibles antes y de esa forma reduciendo la posibilidad de que bloqueen el dibujo de la página. Lee <a data-l10n-name="readmore">“Precargando contenido con <code>rel="preload"</code>”</a> o consulta el <a data-l10n-name="bugzilla">bug 1583604</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = Permite que los estilos de enfoque se apliquen a elementos como botones y controles de formularios, solo cuando se enfocan usando el teclado (por ejemplo, al cambiar de pestaña entre elementos), y no cuando se enfocan usando un ratón u otro dispositivo. Consulta el <a data-l10n-name="bugzilla">bug 1617600</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = El evento global <a data-l10n-name="mdn-beforeinput">beforeinput</a> se activa en elementos <a data-l10n-name="mdn-input">&lt;input&gt;</a> y <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a>, o cualquier otro elemento cuyo atributo <a data-l10n-name="mdn-contenteditable">contenteditable</a> esté habilitado, inmediatamente antes de que cambie el valor del elemento. El evento permite que las aplicaciones web anulen el comportamiento predeterminado del navegador para la interacción del usuario permitiendo, por ejemplo, que las aplicaciones web puedan cancelar la entrada del usuario solo para caracteres específicos o puedan modificar el pegar texto con estilo permitiendo solo estilos aprobados.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = La adición de un constructor a la interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> así como una variedad de cambios relacionados hace posible crear directamente nuevas hojas de estilo sin tener que agregar la hoja al HTML. Esto hace más fácil crear hojas de estilo reutilizables para usar con <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Ver <a data-l10n-name="bugzilla">bug 1520690</a> para más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = La implementación completa de { -brand-short-name } de Media Session API es actualmente experimental. Esta API se usa para personalizar el manejo de notificaciones relacionadas con los medios, para manejar eventos y datos útiles para presentar una interface de usuario para manejar reproducción de medios y para obtener metadatos de los archivos. Ver <a data-l10n-name="bugzilla">bug 1112032</a> para más detalles.
experimental-features-devtools-color-scheme-simulation =
    .label = Herramientas para desarrolladores: simulación de esquemas de color
experimental-features-devtools-color-scheme-simulation-description = Agrega una opción para simular diferentes esquemas de color que te permiten probar las consultas de medios <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-scheme</a>. El uso de esta función permite que tu hoja de estilo responda si el usuario prefiere una interfaz de usuario clara u oscura. Esto te permite probar el código sin tener que cambiar la configuración del navegador (o sistema operativo, si el navegador sigue una configuración de esquema de color establecida para todo el sistema). Consulta el <a data-l10n-name="bugzilla1">bug 1550804</a> y el <a data-l10n-name="bugzilla2">bug 1137699</a> para obtener más detalles.
experimental-features-devtools-execution-context-selector =
    .label = Herramientas de desarrolladores: Selector de contexto de ejecución
experimental-features-devtools-execution-context-selector-description = Esta función muestra un botón en la línea de comandos de la consola que te permite cambiar el contexto en el que se ejecutará la expresión que ingreses. Consulta el <a data-l10n-name="bugzilla">bug 1605154</a> y el <a data-l10n-name="bugzilla2">bug 1605153</a> para obtener más detalles.
experimental-features-devtools-compatibility-panel =
    .label = Herramientas de desarrollado: Panel de compatibilidad
experimental-features-devtools-compatibility-panel-description = Un panel lateral para el Inspector de página que muestra información detallando el estado de compatibilidad entre navegadores para tu aplicación. Consulta el <a data-l10n-name="bugzilla">bug 1584464</a> para obtener más detalles.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies: SameSite=Lax por defecto
experimental-features-cookie-samesite-lax-by-default2-description = Trata las cookies como "SameSite=Lax" por defecto si no se especifica el atributo "SameSite". Los desarrolladores deben optar por el status quo actual de uso sin restricciones al afirmar explícitamente "SameSite=None".
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-none-requires-secure2 =
    .label = Cookies: SameSite=None requiere un atributo seguro
experimental-features-cookie-samesite-none-requires-secure2-description = Las cookies con el atributo "SameSite=None" requieren el atributo seguro. Esta función requiere "Cookies: SameSite=Lax" por defecto.
# about:home should be kept in English, as it refers to the the URI for
# the internal default home page.
experimental-features-abouthome-startup-cache =
    .label = caché de inicio de about:home
experimental-features-abouthome-startup-cache-description = Caché para el documento inicial about:home que se carga de manera predeterminada al inicio. El propósito del caché es mejorar el rendimiento de inicio.
experimental-features-print-preview-tab-modal =
    .label = Rediseño de la vista previa de impresión
experimental-features-print-preview-tab-modal-description = Presenta la vista previa de impresión rediseñada y hace que la vista previa de impresión esté disponible en macOS. Esto introduce fallos potenciales y no incluye todas las configuraciones relacionadas con la impresión. Para acceder a todos los ajustes relacionados con la impresión selecciona "Imprimir usando el cuadro de diálogo del sistema…" desde el panel de impresión.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Tratar las cookies del mismo dominio, pero con diferentes esquemas (por ejemplo, http://example.com y https://example.com), como de sitios cruzados en lugar del mismo sitio. Mejora la seguridad, pero introduce potencialmente fallos.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Herramientas de desarrollado: Depuración de Service Worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Habilita el soporte experimental para Service Workers en el panel del Depurador. Esta función puede ralentizar las Herramientas de desarrolladores y aumentar el consumo de memoria.
# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Graphics: Smooth Pinch Zoom
experimental-features-graphics-desktop-zooming-description = Habilita el soporte para un hacer zoom con suavidad al pellizcar en las pantallas táctiles y los touch pads de precisión con suavidad.
