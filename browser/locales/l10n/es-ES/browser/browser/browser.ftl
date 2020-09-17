# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Navegación privada)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Navegación privada)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (Navegación privada)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Navegación privada)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Ver información del sitio

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Abrir panel de mensajes de instalación
urlbar-web-notification-anchor =
    .tooltiptext = Cambiar si puede recibir notificaciones del sitio
urlbar-midi-notification-anchor =
    .tooltiptext = Abrir el panel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Administrar uso de software DRM
urlbar-web-authn-anchor =
    .tooltiptext = Abrir el panel de Autenticación web
urlbar-canvas-notification-anchor =
    .tooltiptext = Administrar permisos de extracción de canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Administrar la compartición de su micrófono con el sitio
urlbar-default-notification-anchor =
    .tooltiptext = Abrir panel de mensajes
urlbar-geolocation-notification-anchor =
    .tooltiptext = Abrir panel de peticiones de ubicación
urlbar-xr-notification-anchor =
    .tooltiptext = Abrir el panel de permisos de realidad virtual
urlbar-storage-access-anchor =
    .tooltiptext = Abrir el panel de permisos de actividad de navegación
urlbar-translate-notification-anchor =
    .tooltiptext = Traducir esta página
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Administrar la compartición de sus ventanas o pantalla con el sitio
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Abrir panel de mensajes de almacenamiento sin conexión
urlbar-password-notification-anchor =
    .tooltiptext = Abrir el panel de mensajes de contraseñas
urlbar-translated-notification-anchor =
    .tooltiptext = Administrar traducción de páginas
urlbar-plugins-notification-anchor =
    .tooltiptext = Administrar uso de plugins
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Administrar la compartición de su cámara o micrófono con el sitio
urlbar-autoplay-notification-anchor =
    .tooltiptext = Abrir el panel de reproducción automática
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Guardar datos en almacenamiento persistente
urlbar-addons-notification-anchor =
    .tooltiptext = Abrir el panel de mensajes de instalación de complementos
urlbar-tip-help-icon =
    .title = Obtener ayuda
urlbar-search-tips-confirm = Vale, entendido
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Consejo:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Escriba menos, encuentre más: busque con { $engineName } directamente desde la barra de direcciones.
urlbar-search-tips-redirect-2 = Inicie su búsqueda en la barra de direcciones para ver sugerencias de { $engineName } y su historial de navegación.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Marcadores
urlbar-search-mode-tabs = Pestañas
urlbar-search-mode-history = Historial

##

urlbar-geolocation-blocked =
    .tooltiptext = Ha bloqueado la información de ubicación para este sitio web.
urlbar-xr-blocked =
    .tooltiptext = Ha bloqueado el acceso de dispositivos de realidad virtual para este sitio web.
urlbar-web-notifications-blocked =
    .tooltiptext = Ha bloqueado las notificaciones para este sitio web.
urlbar-camera-blocked =
    .tooltiptext = Ha bloqueado su cámara para este sitio web.
urlbar-microphone-blocked =
    .tooltiptext = Ha bloqueado su micrófono para este sitio web.
urlbar-screen-blocked =
    .tooltiptext = Ha impedido que este sitio web comparta su pantalla.
urlbar-persistent-storage-blocked =
    .tooltiptext = Ha bloqueado el almacenamiento de datos para este sitio web.
urlbar-popup-blocked =
    .tooltiptext = Ha bloqueado las ventanas emergentes en este sitio web.
urlbar-autoplay-media-blocked =
    .tooltiptext = Ha bloqueado la reproducción automática de medios con sonido para este sitio web.
urlbar-canvas-blocked =
    .tooltiptext = Ha bloqueado la extracción de datos de canvas en este sitio web.
urlbar-midi-blocked =
    .tooltiptext = Ha bloqueado el acceso al MIDI para este sitio web.
urlbar-install-blocked =
    .tooltiptext = Ha bloqueado la instalación de complementos para este sitio web.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Editar este marcador ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Añadir esta página a marcadores ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Añadir a la barra de direcciones
page-action-manage-extension =
    .label = Administrar extensión…
page-action-remove-from-urlbar =
    .label = Eliminar de la barra de direcciones
page-action-remove-extension =
    .label = Eliminar extensión

## Auto-hide Context Menu

full-screen-autohide =
    .label = Ocultar barras de herramientas
    .accesskey = H
full-screen-exit =
    .label = Salir del modo pantalla completa
    .accesskey = m

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Esta vez, busque con:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Cambiar configuración de búsqueda
search-one-offs-change-settings-compact-button =
    .tooltiptext = Cambiar configuración de búsqueda
search-one-offs-context-open-new-tab =
    .label = Buscar en una pestaña nueva
    .accesskey = B
search-one-offs-context-set-as-default =
    .label = Establecer como buscador predeterminado
    .accesskey = E
search-one-offs-context-set-as-default-private =
    .label = Establecer como buscador predeterminado para ventanas privadas
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Marcadores ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Pestañas ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historial ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Mostrar editor al guardar
    .accesskey = s
bookmark-panel-done-button =
    .label = Hecho
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Conexión no segura
identity-connection-secure = Conexión segura
identity-connection-internal = Esta es una página segura de { -brand-short-name }.
identity-connection-file = Esta página se guarda en su equipo.
identity-extension-page = Esta página está cargada desde una extensión.
identity-active-blocked = { -brand-short-name } ha bloqueado partes de esta página que no son seguras.
identity-custom-root = Conexión verificada por un emisor de certificados que Mozilla no reconoce.
identity-passive-loaded = Partes de esta página no son seguras (como imágenes).
identity-active-loaded = Tiene la protección desactivada en esta página.
identity-weak-encryption = Esta página usa cifrado débil.
identity-insecure-login-forms = Los inicios de sesión introducidos en esta página podrían verse comprometidos.
identity-permissions =
    .value = Permisos
identity-permissions-reload-hint = Puede que necesite recargar la página para que se apliquen los cambios.
identity-permissions-empty = No ha concedido ningún permiso especial a este sitio.
identity-clear-site-data =
    .label = Limpiar cookies y datos del sitio…
identity-connection-not-secure-security-view = No está conectado de forma segura a este sitio.
identity-connection-verified = Está conectado de forma segura a este sitio.
identity-ev-owner-label = Certificado emitido a nombre de:
identity-description-custom-root = Mozilla no reconoce al emisor de este certificado. Puede haber sido agregado desde su sistema operativo o por un administrador. <label data-l10n-name="link">Saber más</label>
identity-remove-cert-exception =
    .label = Eliminar excepción
    .accesskey = E
identity-description-insecure = Su conexión a este sitio no es privada. La información que envíe podría ser vista por otros (como contraseñas, mensajes, tarjetas de crédito, etc.).
identity-description-insecure-login-forms = La información de inicio de sesión que ha introducido en esta página no es segura y podría verse comprometida.
identity-description-weak-cipher-intro = Su conexión a este sitio web usa cifrado débil y no es privada.
identity-description-weak-cipher-risk = Otras personas pueden ver su información o modificar el comportamiento del sitio web.
identity-description-active-blocked = { -brand-short-name } ha bloqueado partes de esta página que no son seguras. <label data-l10n-name="link">Saber más</label>
identity-description-passive-loaded = Su conexión no es privada y la información que comparta con el sitio podría ser vista por otros.
identity-description-passive-loaded-insecure = Este sitio web contiene contenido que no es seguro (como imágenes). <label data-l10n-name="link">Saber más</label>
identity-description-passive-loaded-mixed = Aunque { -brand-short-name } ha bloqueado cierto contenido, aún hay contenido en la página que no es seguro (como imágenes). <label data-l10n-name="link">Saber más</label>
identity-description-active-loaded = Este sitio web contiene contenido que no es seguro (tal como scripts) y su conexión no es privada.
identity-description-active-loaded-insecure = La información que comparta con este sitio podría ser vista por otros (como contraseñas, mensajes, tarjetas de crédito, etc.).
identity-learn-more =
    .value = Saber más
identity-disable-mixed-content-blocking =
    .label = Desactivar protección por ahora
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Activar protección
    .accesskey = A
identity-more-info-link-text =
    .label = Más información

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimizar
browser-window-maximize-button =
    .tooltiptext = Maximizar
browser-window-restore-down-button =
    .tooltiptext = Restaurar abajo
browser-window-close-button =
    .tooltiptext = Cerrar

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Cámara para compartir:
    .accesskey = C
popup-select-microphone =
    .value = Micrófono para compartir:
    .accesskey = M
popup-all-windows-shared = Se compartirán todas las ventanas visibles en su pantalla.
popup-screen-sharing-not-now =
    .label = Ahora no
    .accesskey = W
popup-screen-sharing-never =
    .label = Nunca permitir
    .accesskey = N
popup-silence-notifications-checkbox = Desactivar las notificaciones de { -brand-short-name } mientras se comparte
popup-silence-notifications-checkbox-warning = { -brand-short-name } no mostrará notificaciones mientras se está compartiendo.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Está compartiendo { -brand-short-name }. Otras personas pueden ver cuando pasa a una pestaña nueva.
sharing-warning-screen = Está compartiendo su pantalla completa. Otras personas pueden ver cuando pasa a una pestaña nueva.
sharing-warning-proceed-to-tab =
    .label = Ir a la pestaña
sharing-warning-disable-for-session =
    .label = Deshabilitar la protección de compartición para esta sesión

## DevTools F12 popup

enable-devtools-popup-description = Para usar el acceso directo F12, primero abra las herramientas de desarrollo a través del menú Desarrollador web

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Término de búsqueda o dirección
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Término de búsqueda o dirección
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Buscar en la web
    .aria-label = Buscar con { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Introducir términos de búsqueda
    .aria-label = Buscar { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Introducir términos de búsqueda
    .aria-label = Buscar en marcadores
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Introducir términos de búsqueda
    .aria-label = Buscar en el historial
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Introducir términos de búsqueda
    .aria-label = Buscar en las pestañas
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Buscar con { $name } o introducir una dirección
urlbar-remote-control-notification-anchor =
    .tooltiptext = El navegador está bajo control remoto
urlbar-permissions-granted =
    .tooltiptext = Ha concedido permisos adicionales a este sitio web.
urlbar-switch-to-tab =
    .value = Cambiar a la pestaña:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensión:
urlbar-go-button =
    .tooltiptext = Ir a la URL de la barra de direcciones
urlbar-page-action-button =
    .tooltiptext = Acciones con la página
urlbar-pocket-button =
    .tooltiptext = Guardar en { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> está ahora en pantalla completa
fullscreen-warning-no-domain = Este documento está ahora en pantalla completa
fullscreen-exit-button = Salir de pantalla completa (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Salir de pantalla completa (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> tiene el control de su puntero. Pulse Esc para recuperar el control.
pointerlock-warning-no-domain = Este documento tiene el control del puntero. Pulse Esc para recuperar el control.
