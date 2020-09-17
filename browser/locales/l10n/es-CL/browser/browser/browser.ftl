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
    .data-title-private = { -brand-full-name } (navegación privada)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (navegación privada)
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
    .data-title-private = { -brand-full-name } - (navegación privada)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (navegación privada)
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
    .tooltiptext = Abrir panel de mensaje de instalación
urlbar-web-notification-anchor =
    .tooltiptext = Cambiar si puedes recibir o no notificaciones del sitio
urlbar-midi-notification-anchor =
    .tooltiptext = Abra panel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Gestionar uso de software DRM
urlbar-web-authn-anchor =
    .tooltiptext = Abrir panel de autenticación web
urlbar-canvas-notification-anchor =
    .tooltiptext = Gestionar permisos de extracción de canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Gestionar compartición de micrófono con el sitio
urlbar-default-notification-anchor =
    .tooltiptext = Abrir panel de mensajes
urlbar-geolocation-notification-anchor =
    .tooltiptext = Abrir panel de solicitud de ubicación
urlbar-xr-notification-anchor =
    .tooltiptext = Abrir el panel de permisos de realidad virtual
urlbar-storage-access-anchor =
    .tooltiptext = Abrir panel de permisos de actividad de navegación
urlbar-translate-notification-anchor =
    .tooltiptext = Traducir esta página
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Gestionar compartición de ventanas o pantalla con el sitio
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Abrir panel de mensaje de almacenamiento sin conexión
urlbar-password-notification-anchor =
    .tooltiptext = Abrir panel de mensaje de almacenamiento de contraseñas
urlbar-translated-notification-anchor =
    .tooltiptext = Gestionar traducción de página
urlbar-plugins-notification-anchor =
    .tooltiptext = Gestionar uso de complemento
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Gestionar compartición de la cámara y/o micrófono con el sitio
urlbar-autoplay-notification-anchor =
    .tooltiptext = Abrir panel de reproducción automática
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Almacenar datos en almacenamiento persistente
urlbar-addons-notification-anchor =
    .tooltiptext = Abrir panel de mensaje de instalación de complemento
urlbar-tip-help-icon =
    .title = Obtener ayuda
urlbar-search-tips-confirm = Ok, ¡ya caché!
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Consejo:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Escribe menos, encuentra más: Busca con { $engineName } directo desde tu barra de direcciones.
urlbar-search-tips-redirect-2 = Empieza tu búsqueda en la barra de direcciones para ver sugerencias sacadas de { $engineName } y de tu historial de navegación.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Marcadores
urlbar-search-mode-tabs = Pestañas
urlbar-search-mode-history = Historial

##

urlbar-geolocation-blocked =
    .tooltiptext = Has bloqueado la información de ubicación para este sitio.
urlbar-xr-blocked =
    .tooltiptext = Has bloqueado el acceso de dispositivos de realidad virtual para este sitio.
urlbar-web-notifications-blocked =
    .tooltiptext = Has bloqueado las notificaciones para este sitio.
urlbar-camera-blocked =
    .tooltiptext = Has bloqueado tu cámara para este sitio.
urlbar-microphone-blocked =
    .tooltiptext = Has bloqueado tu micrófono para este sitio.
urlbar-screen-blocked =
    .tooltiptext = Has bloqueado a este sitio la posibilidad de compartir tu pantalla.
urlbar-persistent-storage-blocked =
    .tooltiptext = Has bloqueado el almacenamiento persistente para este sitio.
urlbar-popup-blocked =
    .tooltiptext = Bloqueaste las ventanas emergentes para este sitio web.
urlbar-autoplay-media-blocked =
    .tooltiptext = Has bloqueado la reproducción automática de medios con sonido para este sitio web.
urlbar-canvas-blocked =
    .tooltiptext = Has bloqueado la extracción de datos de canvas para este sitio.
urlbar-midi-blocked =
    .tooltiptext = Has bloqueado el acceso MIDI para este sitio.
urlbar-install-blocked =
    .tooltiptext = Has bloqueado la instalación de complementos para este sitio.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Editar este marcador ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Guardar esta página  en marcadores ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Añadir a la barra de direcciones
page-action-manage-extension =
    .label = Gestionar extensión…
page-action-remove-from-urlbar =
    .label = Eliminar de la barra de direcciones
page-action-remove-extension =
    .label = Eliminar extensión

## Auto-hide Context Menu

full-screen-autohide =
    .label = Esconder barras de herramientas
    .accesskey = h
full-screen-exit =
    .label = Salir del modo de pantalla completa
    .accesskey = S

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Esta vez, buscar con:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Cambiar ajustes de búsqueda
search-one-offs-change-settings-compact-button =
    .tooltiptext = Cambiar ajustes de búsqueda
search-one-offs-context-open-new-tab =
    .label = Buscar en nueva pestaña
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = Ajustar como motor de búsqueda predeterminado
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Establecer como motor de búsqueda predeterminado para ventanas privadas
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
    .accesskey = S
bookmark-panel-done-button =
    .label = Listo
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Conexión no segura
identity-connection-secure = Conexión segura
identity-connection-internal = Esta es una página segura de { -brand-short-name }.
identity-connection-file = Esta página está almacenada en tu computador.
identity-extension-page = Esta página es cargada desde una extensión.
identity-active-blocked = { -brand-short-name } ha bloqueado partes de esta página que no son seguras.
identity-custom-root = Conexión verificada por un emisor de certificados que no es reconocido por Mozilla.
identity-passive-loaded = Partes de esta página no son seguras (por ejemplo: imágenes).
identity-active-loaded = Has desactivado la protección en esta página.
identity-weak-encryption = Esta página usa un cifrado débil.
identity-insecure-login-forms = Las credenciales ingresadas en esta página pueden verse comprometidas.
identity-permissions =
    .value = Permisos
identity-permissions-reload-hint = Puede que tengas que recargar la página para que los cambios se apliquen.
identity-permissions-empty = No has dado permisos especiales a este sitio.
identity-clear-site-data =
    .label = Limpiar cookies y datos del sitio…
identity-connection-not-secure-security-view = No estás conectado de forma segura a este sitio.
identity-connection-verified = Está conectado de forma segura a este sitio.
identity-ev-owner-label = Certificado emitido para:
identity-description-custom-root = Mozilla no reconoce al emisor de este certificado. Puede haber sido agregado desde tu sistema operativo o por un administrador. <label data-l10n-name="link">Aprender más</label>
identity-remove-cert-exception =
    .label = Eliminar excepción
    .accesskey = R
identity-description-insecure = Tu conexión a este sitio no es privada. La información que envíes puede ser vista por otros (por ejemplo: contraseñas, mensajes, tarjetas de crédito, etc.).
identity-description-insecure-login-forms = La información de conexión que ingreses en este sitio no va segura y puede verse comprometida.
identity-description-weak-cipher-intro = Tu conexión a este sitio web usa un cifrado débil y no es privada.
identity-description-weak-cipher-risk = Otras personas pueden ver tu información o modificar el comportamiento del sitio web.
identity-description-active-blocked = { -brand-short-name } ha bloqueado partes de esta página que no son seguras. <label data-l10n-name="link">Aprender más</label>
identity-description-passive-loaded = Tu conexión no es privada y la información que compartas con el sitio puede ser vista por otros.
identity-description-passive-loaded-insecure = Este sitio web contiene contenido que no es seguro (por ejemplo: imágenes). <label data-l10n-name="link">Aprender más</label>
identity-description-passive-loaded-mixed = Aunque { -brand-short-name } ha bloqueado parte del contenido, aún hay contenido en la página que no es seguro (por ejemplo: imágenes). <label data-l10n-name="link">Aprender más</label>
identity-description-active-loaded = Este sitio contiene contenido que no es seguro (por ejemplo: scripts) y tu conexión a éste no es privada.
identity-description-active-loaded-insecure = La información que compartas con este sitio puede ser vista por otros (por ejemplo: contraseñas, mensajes, tarjetas de crédito, etc.).
identity-learn-more =
    .value = Aprender más
identity-disable-mixed-content-blocking =
    .label = Desactivar protección por ahora
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Activar protección
    .accesskey = E
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
    .value = Cámara a compartir:
    .accesskey = C
popup-select-microphone =
    .value = Micrófono a compartir:
    .accesskey = M
popup-all-windows-shared = Todas las ventanas visibles en tu pantalla serán compartidas.
popup-screen-sharing-not-now =
    .label = Ahora no
    .accesskey = w
popup-screen-sharing-never =
    .label = Nunca permitir
    .accesskey = N
popup-silence-notifications-checkbox = Desactivar las notificaciones de { -brand-short-name } mientras se comparte
popup-silence-notifications-checkbox-warning = { -brand-short-name } no mostrará notificaciones mientras se está compartiendo.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Estás compartiendo { -brand-short-name }. Otras personas pueden ver cuando cambias a una pestaña nueva.
sharing-warning-screen = Estás compartiendo tu pantalla completa. Otras personas pueden ver cuando cambias a una pestaña nueva.
sharing-warning-proceed-to-tab =
    .label = Ve a la pestaña
sharing-warning-disable-for-session =
    .label = Desactivar la protección de compatir durante esta sesión

## DevTools F12 popup

enable-devtools-popup-description = Para usar el acceso directo F12, primero abre las herramientas de desarrollo a través del menú Desarrollador web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Buscar o ingresar dirección
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Buscar o ingresar dirección
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Buscar en la Web
    .aria-label = Buscar con { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Ingresa los términos de búsqueda
    .aria-label = Buscar en { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Ingresa los términos de búsqueda
    .aria-label = Buscar en marcadores
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Ingresa los términos de búsqueda
    .aria-label = Buscar en el historial
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Ingresa los términos de búsqueda
    .aria-label = Buscar en las pestañas
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Busca con { $name } o ingresa una dirección
urlbar-remote-control-notification-anchor =
    .tooltiptext = El navegador está bajo control remoto
urlbar-permissions-granted =
    .tooltiptext = Has dado permisos adicionales a este sitio.
urlbar-switch-to-tab =
    .value = Cambiar a pestaña:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensión:
urlbar-go-button =
    .tooltiptext = Ir a la dirección en la barra de direcciones
urlbar-page-action-button =
    .tooltiptext = Acciones de la página
urlbar-pocket-button =
    .tooltiptext = Guardar en { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> está ahora a pantalla completa
fullscreen-warning-no-domain = Este documento está ahora a pantalla completa
fullscreen-exit-button = Salir de pantalla completa (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Salir de pantalla completa (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> tiene el control de tu puntero. Presiona Esc para recuperarlo.
pointerlock-warning-no-domain = Este documento tiene el control de tu puntero. Presiona  Esc para recuperarlo.
