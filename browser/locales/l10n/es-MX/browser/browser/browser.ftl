# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - Waterfox
# private - "Waterfox Waterfox (Private Browsing)"
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
# "default" - Waterfox
# "private" - "Waterfox Waterfox — (Private Browsing)"
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
    .aria-label = Ver información de sitio

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Abrir panel de mensaje de instalación
urlbar-web-notification-anchor =
    .tooltiptext = Cambiar si se reciben notificaciones del sitio
urlbar-midi-notification-anchor =
    .tooltiptext = Abrir panel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Administrar uso del software DRM
urlbar-web-authn-anchor =
    .tooltiptext = Abrir panel de autenticación web
urlbar-canvas-notification-anchor =
    .tooltiptext = Administrar permiso de extracción de canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Administrar compartir tu micrófono con el sitio
urlbar-default-notification-anchor =
    .tooltiptext = Abrir panel de mensajes
urlbar-geolocation-notification-anchor =
    .tooltiptext = Abrir panel de solicitud de ubicación
urlbar-xr-notification-anchor =
    .tooltiptext = Abrir el panel de permisos de realidad virtual
urlbar-storage-access-anchor =
    .tooltiptext = Abrir el panel de permisos de actividad de navegación
urlbar-translate-notification-anchor =
    .tooltiptext = Traducir esta página
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Administrar compartir tus ventanas o pantalla con el sitio
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Abrir panel de mensajes de almacenamiento sin conexión
urlbar-password-notification-anchor =
    .tooltiptext = Abrir panel de mensajes de contraseñas guardadas
urlbar-translated-notification-anchor =
    .tooltiptext = Administrar traducción de la página
urlbar-plugins-notification-anchor =
    .tooltiptext = Administrar uso de plugins
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Administrar compartir tu cámara y/o micrófono con el sitio
urlbar-autoplay-notification-anchor =
    .tooltiptext = Abrir panel de reproducción automática
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Almacenar datos en el almacenamiento persistente
urlbar-addons-notification-anchor =
    .tooltiptext = Abrir panel de mensajes de instalación de complementos
urlbar-tip-help-icon =
    .title = Obtener ayuda
urlbar-search-tips-confirm = De acuerdo, lo entiendo
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Consejo:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Escribe menos, encuentra más: busca { $engineName } desde tu barra de direcciones.
urlbar-search-tips-redirect-2 = Inicia tu búsqueda en la barra de direcciones para ver sugerencias de { $engineName } y tu historial de navegación.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Seleccione este acceso directo para encontrar más rápidamente lo que necesite.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Marcadores
urlbar-search-mode-tabs = Pestañas
urlbar-search-mode-history = Historial

##

urlbar-geolocation-blocked =
    .tooltiptext = Está bloqueada tu información de ubicación para este sitio web.
urlbar-xr-blocked =
    .tooltiptext = Bloqueaste el acceso de dispositivos de realidad virtual para este sitio web.
urlbar-web-notifications-blocked =
    .tooltiptext = Están bloqueadas las notificaciones para este sitio web.
urlbar-camera-blocked =
    .tooltiptext = Tu cámara está bloqueada para este sitio web.
urlbar-microphone-blocked =
    .tooltiptext = Tu micrófono está bloqueado para este sitio web.
urlbar-screen-blocked =
    .tooltiptext = Este sitio web está bloqueado para compartir tu pantalla.
urlbar-persistent-storage-blocked =
    .tooltiptext = Has bloqueado el almacenamiento persistente para este sitio.
urlbar-popup-blocked =
    .tooltiptext = Tienes bloqueadas las pop-ups para este sitio web.
urlbar-autoplay-media-blocked =
    .tooltiptext = Bloqueaste la reproducción automática de sonidos multimedia para este sitio web.
urlbar-canvas-blocked =
    .tooltiptext = Has bloqueado la extracción de datos de canvas para este sitio.
urlbar-midi-blocked =
    .tooltiptext = Haz bloqueado el acceso al MIDI para este sitio web.
urlbar-install-blocked =
    .tooltiptext = Has bloqueado la instalación de complementos en este sitio web.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Editar este marcador ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Agregar esta página a marcadores ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension =
    .label = Administrar extensión…
page-action-remove-extension =
    .label = Eliminar extensión

## Auto-hide Context Menu

full-screen-autohide =
    .label = Ocultar barras de herramientas
    .accesskey = O
full-screen-exit =
    .label = Salir del modo pantalla completa
    .accesskey = c

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Esta vez, buscar con:
search-one-offs-change-settings-compact-button =
    .tooltiptext = Cambiar preferencias de búsqueda
search-one-offs-context-open-new-tab =
    .label = Buscar en nueva pestaña
    .accesskey = p
search-one-offs-context-set-as-default =
    .label = Establecer como motor de búsqueda predeterminado
    .accesskey = p
search-one-offs-context-set-as-default-private =
    .label = Establecer como motor de búsqueda predeterminado en Ventanas Privadas
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Añadir “{ $engineName }”
    .tooltiptext = Añadir buscador “{ $engineName }”
    .aria-label = Añadir buscador “{ $engineName }”
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Agregar motor de búsqueda

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

bookmarks-add-bookmark = Agregar marcador
bookmarks-edit-bookmark = Editar marcador
bookmark-panel-cancel =
    .label = Cancelar
    .accesskey = C
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Borrar Marcador
           *[other] Borrar Marcadores ({ $count })
        }
    .accesskey = R
bookmark-panel-show-editor-checkbox =
    .label = Mostrar editor al guardar
    .accesskey = S
bookmark-panel-save-button =
    .label = Guardar
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Información del sitio { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Seguridad de la conexión para { $host }
identity-connection-not-secure = Conexión no segura
identity-connection-secure = Conexión segura
identity-connection-failure = Fallo de conexión
identity-connection-internal = Esta es un página { -brand-short-name } segura.
identity-connection-file = Esta página está almacenada en tu computadora.
identity-extension-page = Esta página se carga desde una extensión.
identity-active-blocked = { -brand-short-name } bloqueó partes de esta página que no eran seguras.
identity-custom-root = Conexión verificada por un emisor de certificados que Waterfox no reconoce.
identity-passive-loaded = Partes de esta página no son seguras (por ejemplo imágenes).
identity-active-loaded = Has deshabilitado la protección en esta página.
identity-weak-encryption = Esta página usa encriptación débil.
identity-insecure-login-forms = Inicios de sesión ingresados en esta página pueden ser peligrosos.
identity-https-only-connection-upgraded = (actualizado a HTTPS)
identity-https-only-label = Modo solo HTTPS
identity-https-only-dropdown-on =
    .label = Activado
identity-https-only-dropdown-off =
    .label = Desactivado
identity-https-only-dropdown-off-temporarily =
    .label = Desactivado temporalmente
identity-https-only-info-turn-on2 = Activa el modo solo HTTPS para este sitio si quieres que { -brand-short-name } actualice la conexión cuando sea posible.
identity-https-only-info-turn-off2 = Si el sitio no funciona correctamente, es posible que quieras desactivar el modo solo HTTPS para volver a cargarlo usando una conexión HTTP insegura.
identity-https-only-info-no-upgrade = No se puede actualizar la conexión desde HTTP.
identity-permissions-storage-access-header = Cookies entre sitios
identity-permissions-storage-access-hint = Estas partes pueden usar cookies de sitios cruzados y datos del sitio mientras está en este sitio.
identity-permissions-storage-access-learn-more = Saber más
identity-permissions-reload-hint = Puede que tengas que recargar la página para que se apliquen los cambios.
identity-clear-site-data =
    .label = Limpiar cookies y datos del sitio…
identity-connection-not-secure-security-view = No se estableció una conexión segura con este sitio.
identity-connection-verified = Se estableció una conexión segura con este sitio.
identity-ev-owner-label = Certificado emitido a nombre de:
identity-description-custom-root = Waterfox no reconoce a este emisor de certificados. El sistema operativo o algún administrador puede haberlo añadido. <label data-l10n-name="link">Saber más</label>
identity-remove-cert-exception =
    .label = Eliminar excepción
    .accesskey = E
identity-description-insecure = Tu conexión a este sitio no es privada. La información que envíes podría ser vista por otros (contraseñas, mensajes, tarjetas de crédito, etc.).
identity-description-insecure-login-forms = La información del inicio de sesión que ingreses en esta página no está segura y podría verse comprometida.
identity-description-weak-cipher-intro = Tu conexión con este sitio web usa encriptación débil y no es privado.
identity-description-weak-cipher-risk = Otras personas pueden ver tu información o modificar el comportamiento del sitio web.
identity-description-active-blocked = { -brand-short-name } bloqueó partes de esta página que no eran seguras. <label data-l10n-name="link">Saber más</label>
identity-description-passive-loaded = Tu conexión no es privada y la información que compartas con el sitio podría ser vista por otros.
identity-description-passive-loaded-insecure = Este sitio web tiene contenido que no es seguro (por ejemplo imágenes). <label data-l10n-name="link">Saber más</label>
identity-description-passive-loaded-mixed = Aunque { -brand-short-name } bloqueó parte del contenido, aún hay contenido en la página que no es seguro (por ejemplo imágenes). <label data-l10n-name="link">Saber más</label>
identity-description-active-loaded = Este sitio web tiene contenido que no es seguro (tales como scripts) y tu conexión a ellos no es privada.
identity-description-active-loaded-insecure = La información que compartas con este sitio puede ser vista por otros (como contraseñas, mensajes, tarjetas de crédito, etc.).
identity-learn-more =
    .value = Saber más
identity-disable-mixed-content-blocking =
    .label = Protección inhabilitada por ahora
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Habilitar protección
    .accesskey = H
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

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = REPRODUCIENDO
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = SILENCIADO
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = AUTOREPRODUCCIÓN BLOQUEDA
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = PICTURE-IN-PICTURE

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] SILENCIAR PESTAÑA
        [one] SILENCIAR { $count } PESTAÑA
       *[other] SILENCIAR { $count } PESTAÑAS
    }
browser-tab-unmute =
    { $count ->
        [1] DEJAR DE SILENCIAR PESTAÑA
        [one] DEJAR DE SILENCIAR { $count } PESTAÑA
       *[other] DEJAR DE SILENCIAR { $count } PESTAÑAS
    }
browser-tab-unblock =
    { $count ->
        [1] REPRODUCIR PESTAÑA
        [one] REPRODUCIR { $count } PESTAÑA
       *[other] REPRODUCIR { $count } PESTAÑAS
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Importar marcadores…
    .tooltiptext = Importar marcadores desde otro navegador a { -brand-short-name }.
bookmarks-toolbar-empty-message = Para un acceso rápido, ubica tus marcadores aquí en la barra de herramientas de marcadores. <a data-l10n-name="manage-bookmarks">Administrar marcadores…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Cámara:
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = Cámara
popup-select-microphone-device =
    .value = Micrófono:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Micrófono
popup-select-speaker-icon =
    .tooltiptext = Altavoces
popup-all-windows-shared = Todas las ventanas visibles en tu pantalla se compartirán.
popup-screen-sharing-block =
    .label = Bloquear
    .accesskey = B
popup-screen-sharing-always-block =
    .label = Bloquear siempre
    .accesskey = B
popup-mute-notifications-checkbox = Silenciar las notificaciones de sitios web mientras se comparte

## WebRTC window or screen share tab switch warning

sharing-warning-window = Estás compartiendo { -brand-short-name }. Otras personas pueden ver cuando pasas a una pestaña nueva.
sharing-warning-screen = Estás compartiendo toda tu pantalla. Otras personas pueden ver cuando cambias a una pestaña nueva.
sharing-warning-proceed-to-tab =
    .label = Ir a la pestaña
sharing-warning-disable-for-session =
    .label = Deshabilitar la protección de uso compartido para esta sesión

## DevTools F12 popup

enable-devtools-popup-description = Para usar el atajo F12, primero abre DevTools a través del menú de Desarrollador Web

## URL Bar

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
    .placeholder = Buscar con { $name } o ingresar una dirección
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = El navegador está bajo control remoto (razón: { $component })
urlbar-permissions-granted =
    .tooltiptext = Concediste permisos adicionales a este sitio web.
urlbar-switch-to-tab =
    .value = Cambiar a la pestaña:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensión:
urlbar-go-button =
    .tooltiptext = Ir a la dirección en la Barra de ubicaciones.
urlbar-page-action-button =
    .tooltiptext = Acciones de la página

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Buscar con { $engine } en una ventana privada
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Buscar en una ventana privada
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Buscar con { $engine }
urlbar-result-action-sponsored = Patrocinado
urlbar-result-action-switch-tab = Cambiar a la pestaña
urlbar-result-action-visit = Visitar
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Presiona Tab para buscar con { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Presione Tab para buscar con { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Buscar con { $engine } directamente desde la barra de direcciones
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Buscar con { $engine } directamente desde la barra de direcciones
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Copiar
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Buscar marcadores
urlbar-result-action-search-history = Buscar Historial
urlbar-result-action-search-tabs = Buscar pestañas

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Sugerencias de { $engine }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> está ahora en pantalla completa
fullscreen-warning-no-domain = Este documento está ahora en pantalla completa
fullscreen-exit-button = Salir de Pantalla Completa (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Salir de Pantalla Completa (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> tiene el control de tu puntero. Presiona Esc para recuperarlo.
pointerlock-warning-no-domain = Este documento tiene el control de tu puntero. Presiona Esc para recuperarlo.

## Subframe crash notification

crashed-subframe-message = <strong>Parte de esta página falló.</strong> Para que { -brand-product-name } sepa sobre este problema y se arregle más rápido, por favor envía un informe.
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Parte de esta página falló. Para que { -brand-product-name } sepa sobre este problema y se arregle más rápido, por favor envía un informe.
crashed-subframe-learnmore-link =
    .value = Saber más
crashed-subframe-submit =
    .label = Enviar informe
    .accesskey = E

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Administrar marcadores
bookmarks-recent-bookmarks-panel-subheader = Marcadores recientes
bookmarks-toolbar-chevron =
    .tooltiptext = Mostrar más marcadores
bookmarks-sidebar-content =
    .aria-label = Marcadores
bookmarks-menu-button =
    .label = Menú Marcadores
bookmarks-other-bookmarks-menu =
    .label = Otros Marcadores
bookmarks-mobile-bookmarks-menu =
    .label = Marcadores móviles
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Ocultar barra lateral de marcadores
           *[other] Ver el panel lateral de marcadores
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Ocultar barra de marcadores
           *[other] Ver la barra de marcadores
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Ocultar Barra de Marcadores
           *[other] Mostrar Barra de Marcadores
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Eliminar menú de marcadores de la barra de herramientas
           *[other] Agregar menú de marcadores a la barra de herramientas
        }
bookmarks-search =
    .label = Buscar Marcadores
bookmarks-tools =
    .label = Herramientas de marcadores
bookmarks-bookmark-edit-panel =
    .label = Modificar este marcador
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Marcadores
    .accesskey = M
    .aria-label = Marcadores
bookmarks-toolbar-menu =
    .label = Marcadores
bookmarks-toolbar-placeholder =
    .title = Elementos de la barra de marcadores
bookmarks-toolbar-placeholder-button =
    .label = Elementos de la barra de marcadores
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = Agregar pestaña actual a Marcadores

## Library Panel items

library-bookmarks-menu =
    .label = Marcadores
library-recent-activity-title =
    .value = Actividad reciente

## Pocket toolbar button

save-to-pocket-button =
    .label = Guardar en { -pocket-brand-name }
    .tooltiptext = Guardar en { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Reparar la codificación de texto
    .tooltiptext = Adivinar la codificación de texto desde el contenido de página

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = Complementos y temas
    .tooltiptext = Administrar complementos y temas ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Ajustes
    .tooltiptext =
        { PLATFORM() ->
            [macos] Abrir ajustes ({ $shortcut })
           *[other] Abrir ajustes
        }

## More items

more-menu-go-offline =
    .label = Trabajar sin conexión
    .accesskey = x
toolbar-overflow-customize-button =
    .label = Personalizar barra de herramientas…
    .accesskey = C
toolbar-button-email-link =
    .label = Enviar enlace
    .tooltiptext = Enviar por correo un enlace a esta página
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Guardar página
    .tooltiptext = Guardar esta página ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Abrir archivo
    .tooltiptext = Abrir archivo ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Pestañas sincronizadas
    .tooltiptext = Mostrar pestañas de otros dispositivos
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Nueva ventana privada
    .tooltiptext = Abrir una nueva ventana de navegación privada ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Algún audio o video en este sitio usa software DRM, que puede limitar lo que { -brand-short-name } te permite hacer con él.
eme-notifications-drm-content-playing-manage = Administrar configuraciones
eme-notifications-drm-content-playing-manage-accesskey = M
eme-notifications-drm-content-playing-dismiss = Descartar
eme-notifications-drm-content-playing-dismiss-accesskey = D

## Password save/update panel

panel-save-update-username = Nombre de usuario
panel-save-update-password = Contraseña

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = ¿Eliminar { $name }?
addon-removal-abuse-report-checkbox = Informar de esta extensión a { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = Administrar cuenta
remote-tabs-sync-now = Sincronizar ahora

##

# "More" item in macOS share menu
menu-share-more =
    .label = Más…
ui-tour-info-panel-close =
    .tooltiptext = Cerrar

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Permitir ventanas emergentes de { $uriHost }
    .accesskey = p
popups-infobar-block =
    .label = Bloquear ventanas emergentes de { $uriHost }
    .accesskey = p

##

popups-infobar-dont-show-message =
    .label = No mostrar este mensaje cuando se bloqueen ventanas emergentes
    .accesskey = D
edit-popup-settings =
    .label = Administrar ajustes de ventanas emergentes…
    .accesskey = A
picture-in-picture-hide-toggle =
    .label = Ocultar interruptor de imagen superpuesta
    .accesskey = H

# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navegación
navbar-downloads =
    .label = Descargas
navbar-overflow =
    .tooltiptext = Más herramientas…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Imprimir
    .tooltiptext = Imprimir esta página… ({ $shortcut })
navbar-print-tab-modal-disabled =
    .label = Imprimir
    .tooltiptext = Imprimir esta página
navbar-home =
    .label = Inicio
    .tooltiptext = Página de inicio de { -brand-short-name }
navbar-library =
    .label = Biblioteca
    .tooltiptext = Ver historial, marcadores guardados y más
navbar-search =
    .title = Buscar
navbar-accessibility-indicator =
    .tooltiptext = Funciones de accesibilidad activadas
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Pestañas del navegador
tabs-toolbar-new-tab =
    .label = Nueva pestaña
tabs-toolbar-list-all-tabs =
    .label = Mostrar todas las pestañas
    .tooltiptext = Mostrar todas las pestañas

## Infobar shown at startup to suggest session-restore

