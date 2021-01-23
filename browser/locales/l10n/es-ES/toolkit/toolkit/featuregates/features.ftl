# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-masonry2 =
    .label = CSS: Masonry Layout
experimental-features-css-masonry-description = Habilita la compatibilidad con la característica CSS Masonry Layout experimental. Consulte <a data-l10n-name="explainer">más detalles</a> para obtener una descripción general de la función. Para enviar comentarios, comente en <a data-l10n-name="w3c-issue">este issue de GitHub </a> o <a data-l10n-name="bug">este bug</a>.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-gpu2 =
    .label = Web API: WebGPU
experimental-features-web-gpu-description2 = Esta nueva API proporciona soporte de bajo nivel para realizar cálculos y renderizado de gráficos usando la <a data-l10n-name="wikipedia">unidad de procesamiento de gráficos (GPU)</a> del ordenador o dispositivo del usuario. La <a data-l10n-name="spec">especificación</a> todavía no es definitiva. Consulte el <a data-l10n-name="bugzilla">bug 1602129</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-avif =
    .label = Media: AVIF
experimental-features-media-avif-description = Con esta función activada, { -brand-short-name } admite el formato de archivo de imagen AV1 (AVIF). Este es un formato de archivo de imagen fija que aprovecha las capacidades de los algoritmos de compresión de video AV1 para reducir el tamaño de la imagen. Consulte el <a data-l10n-name="bugzilla">bug 1443863</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-inputmode =
    .label = Web API: inputmode
# "inputmode" and "contenteditable" are technical terms and shouldn't be translated.
experimental-features-web-api-inputmode-description = Nuestra implementación del atributo global <a data-l10n-name="mdn-inputmode">inputmode</a> se ha actualizado según <a data-l10n-name="whatwg">la especificación WHATWG</a>, pero todavía necesitamos hacer más cambios, como por ejemplo que quede disponible  en contenidos contenteditable. Consulte el <a data-l10n-name="bugzilla">bug 1205133</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-link-preload =
    .label = Web API: <link rel="preload">
# Do not translate "rel", "preload" or "link" here, as they are all HTML spec
# values that do not get translated.
experimental-features-web-api-link-preload-description = El atributo <a data-l10n-name="rel">rel</a> con valor <code>"preload"</code> en un elemento <a data-l10n-name="link">&lt;link&gt;</a> tiene como objetivo ayudar a proporcionar mejoras de rendimiento al permitirle descargar recursos en una etapa más temprana del ciclo de vida de la página, asegurando que estén disponibles antes y que sea menos probable que bloqueen el dibujado de la página. Leer <a data-l10n-name="readmore">“Precargando contenido con <code>rel="preload"</code>”</a> o ver <a data-l10n-name="bugzilla">bug 1583604</a> para más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-focus-visible =
    .label = CSS: Pseudo-class: :focus-visible
experimental-features-css-focus-visible-description = Permite que los estilos de foco se apliquen a elementos como botones y controles de formularios, solo cuando reciben el foco usando el teclado (por ejemplo, al cambiar usando el tabulador entre elementos), y no cuando toman el foco usando un ratón u otro dispositivo. Consulte <a data-l10n-name="bugzilla">bug 1617600</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-web-api-beforeinput =
    .label = Web API: beforeinput Event
# The terms "beforeinput", "input", "textarea", and "contenteditable" are technical terms
# and shouldn't be translated.
experimental-features-web-api-beforeinput-description = El evento global <a data-l10n-name="mdn-beforeinput"> beforeinput </a> se activa en los elementos <a data-l10n-name="mdn-input"> &lt;input&gt;</a> y <a data-l10n-name="mdn-textarea">&lt;textarea&gt;</a>, o en cualquier elemento cuyo atributo <a data-l10n-name="mdn-contenteditable">contenteditable</a> esté activado, inmediatamente antes de que cambie el valor del elemento. El evento permite que las aplicaciones web anulen el comportamiento predeterminado del navegador para la interacción del usuario, por ejemplo, las aplicaciones web pueden cancelar la entrada del usuario solo para caracteres específicos o pueden modificar pegar texto con estilo solo con estilos aprobados.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = La adición de un constructor a la interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> así como una variedad de cambios relacionados hace posible crear directamente nuevas hojas de estilo sin tener que agregar la hoja al HTML. Esto hace más fácil crear hojas de estilo reutilizables para usar con <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Ver <a data-l10n-name="bugzilla">bug 1520690</a> para más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-media-session-api =
    .label = Web API: Media Session API
experimental-features-media-session-api-description = La implementación completa de { -brand-short-name } de Media Session API es actualmente experimental. Esta API se usa para personalizar el manejo de notificaciones relacionadas con los medios, para manejar eventos y datos útiles para presentar una interfaz de usuario para manejar reproducción de medios y para obtener metadatos de los archivos. Ver <a data-l10n-name="bugzilla">bug 1112032</a> para más detalles.
experimental-features-devtools-color-scheme-simulation =
    .label = Herramientas para desarrolladores: simulación de esquemas de color
experimental-features-devtools-color-scheme-simulation-description = Añade una opción para simular diferentes esquemas de color que le permite probar consultas de medios <a data-l10n-name="mdn-preferscolorscheme">@prefers-color-schem </a>. El uso de esta función permite que su hoja de estilo responda si el usuario prefiere una interfaz de usuario clara u oscura. Esto le permite probar su código sin tener que cambiar la configuración de su navegador (o sistema operativo, si el navegador sigue una configuración de esquema de color para todo el sistema). Consulte <a data-l10n-name="bugzilla1">bug 1550804</a> y <a data-l10n-name="bugzilla2">bug 1137699</a> para obtener más detalles.
experimental-features-devtools-execution-context-selector =
    .label = Herramientas de desarrolladores: Selector de contexto de ejecución
experimental-features-devtools-execution-context-selector-description = Esta función muestra un botón en la línea de comando de la consola que le permite cambiar el contexto en el que se ejecutará la expresión que introduzca. Consulte <a data-l10n-name="bugzilla1">bug 1605154</a> y <a data-l10n-name="bugzilla2">bug 1605153</a> para obtener más detalles.
experimental-features-devtools-compatibility-panel =
    .label = Herramientas de desarrolladores: Panel de compatibilidad
experimental-features-devtools-compatibility-panel-description = Un panel lateral para el Inspector de página que muestra información que detalla el estado de compatibilidad entre navegadores de su aplicación. Consulte <a data-l10n-name="bugzilla">bug 1584464</a> para obtener más detalles.
# Do not translate 'SameSite', 'Lax' and 'None'.
experimental-features-cookie-samesite-lax-by-default2 =
    .label = Cookies: SameSite=Lax por defecto
experimental-features-cookie-samesite-lax-by-default2-description = Trate las cookies como "SameSite=Lax" de forma predeterminada si no se especifica el atributo "SameSite". Los desarrolladores deben optar por el statu quo actual de uso sin restricciones al indicar explícitamente "SameSite=None".
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
experimental-features-print-preview-tab-modal-description = Presenta la vista previa de impresión rediseñada y hace que la vista previa de impresión esté disponible en macOS. Esto introduce fallos potenciales y no incluye todas las configuraciones relacionadas con la impresión. Para acceder a todos los ajustes relacionados con la impresión seleccione “Imprimir usando el cuadro de diálogo del sistema…” desde el panel de impresión.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-cookie-samesite-schemeful =
    .label = Cookies: Schemeful SameSite
experimental-features-cookie-samesite-schemeful-description = Tratar las cookies del mismo dominio, pero con diferentes esquemas (por ejemplo, http://example.com y https://example.com) como sitios cruzados en lugar de sitios iguales. Mejora la seguridad, pero potencialmente puede producir fallos.
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support =
    .label = Herramientas de desarrolladores: Depuración de Service Worker
# "Service Worker" is an API name and is usually not translated.
experimental-features-devtools-serviceworker-debugger-support-description = Activa el soporte experimental para Service Workers en el panel del Depurador. Esta función puede ralentizar las Herramientas de desarrolladores y aumentar el consumo de memoria.
# Desktop zooming experiment
experimental-features-graphics-desktop-zooming =
    .label = Gráficos: Zoom suave con los dedos
experimental-features-graphics-desktop-zooming-description = Activa la compatibilidad para un zoom suave en pantallas táctiles y almohadillas táctiles de precisión.
