# This Source Code Form is subject to the terms of the Waterfox Public
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
experimental-features-media-jxl =
    .label = Medios: JPEG XL
experimental-features-media-jxl-description = Con esta función activada, { -brand-short-name } admite el formato JPEG XL (JXL). Este es un formato de archivo de imagen mejorado que admite la transición sin perdida de archivos JPEG tradicionales. Consulta el <a data-l10n-name="bugzilla">bug 1539075</a> para obtener más detalles.
# The title of the experiment should be kept in English as it may be referenced
# by various online articles and is technical in nature.
experimental-features-css-constructable-stylesheets =
    .label = CSS: Constructable Stylesheets
experimental-features-css-constructable-stylesheets-description = La adición de un constructor a la interface <a data-l10n-name="mdn-cssstylesheet">CSSStyleSheet</a> así como una variedad de cambios relacionados hace posible crear directamente nuevas hojas de estilo sin tener que agregar la hoja al HTML. Esto hace más fácil crear hojas de estilo reutilizables para usar con <a data-l10n-name="mdn-shadowdom">Shadow DOM</a>. Ver <a data-l10n-name="bugzilla">bug 1520690</a> para más detalles.
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
# WebRTC global mute toggle controls
experimental-features-webrtc-global-mute-toggles =
    .label = Alternar sonido WebRTC globalmente
experimental-features-webrtc-global-mute-toggles-description = Agregar controles al indicador de intercambio global WebRTC que permita a los usuarios interrumpir globalmente la compartición de tu micrófono y cámara.
# JS JIT Warp project
experimental-features-js-warp =
    .label = JavaScript JIT: Warp
experimental-features-js-warp-description = Activar Warp, un proyecto para mejorar el rendimiento y el uso de la memoria de JavaScript.
# Search during IME
experimental-features-ime-search =
    .label = Barra de direcciones: mostrar los resultados durante la composición IME
experimental-features-ime-search-description = Una IME (Input Method Editor) es una herramienta que te permite escribir símbolos complejos, como los que se usan en los idiomas escritos del Índico o Asia oriental, utilizando un teclado estándar. Activar este experimento mantendrá abierto el panel de la barra de direcciones, mostrando resultados de búsqueda y sugerencias, mientras se usa IME para escribir texto. Ten en cuenta que el IME puede mostrar un panel que cubre los resultados de la barra de direcciones, por lo que se recomienda el uso de esta preferencia solo si el IME no usa este tipo de panel.
# Text recognition for images
experimental-features-text-recognition =
    .label = Reconocimiento de texto
experimental-features-text-recognition-description = Habilitar funciones para reconocer texto en imágenes.
experimental-features-accessibility-cache =
    .label = Caché de accesibilidad
experimental-features-accessibility-cache-description = Almacena en caché toda la información de accesibilidad de todos los documentos en el proceso principal { -brand-short-name }. Esto mejora el rendimiento de los lectores de pantalla y otras aplicaciones que usan APIs de accesibilidad.
