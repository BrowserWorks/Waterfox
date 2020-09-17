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
    .aria-label = Amostrar a información d'o puesto

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Ubrir lo panel de mensaches d'instalación
urlbar-web-notification-anchor =
    .tooltiptext = Cambiar a opción de recibir notificacions dende iste puesto
urlbar-midi-notification-anchor =
    .tooltiptext = Ubrir lo panel MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Chestionar l'uso de software de DRM
urlbar-web-authn-anchor =
    .tooltiptext = Ubrir panel d'autenticación web
urlbar-canvas-notification-anchor =
    .tooltiptext = Chestionar lo permiso d'extracción d'o lienzo
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Chestiona a compartición d'o microfono con iste puesto
urlbar-default-notification-anchor =
    .tooltiptext = Ubrir lo panel d'o mensache
urlbar-geolocation-notification-anchor =
    .tooltiptext = Ubrir lo panel de requesta de localización
urlbar-xr-notification-anchor =
    .tooltiptext = Ubrir lo panel de permisos d'a realidat virtual
urlbar-storage-access-anchor =
    .tooltiptext = Ubrir lo panel de permisos de navegación
urlbar-translate-notification-anchor =
    .tooltiptext = Traducir ista pachina
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Chestiona a compartición d'as finestras u a pantalla con iste puesto
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Ubrir lo panel de mensaches d'almagazenamiento difuera de linia
urlbar-password-notification-anchor =
    .tooltiptext = Ubrir lo panel de mensaches d'alzar claus
urlbar-translated-notification-anchor =
    .tooltiptext = Chestionar la traducción de pachinas
urlbar-plugins-notification-anchor =
    .tooltiptext = Chestionar l'uso de plugins
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Chestiona a compartición d'a camera u microfono con iste puesto
urlbar-autoplay-notification-anchor =
    .tooltiptext = Ubrir panel de reproducción automatica
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Alzar los datos en l'almagazenamiento persistent
urlbar-addons-notification-anchor =
    .tooltiptext = Ubrir lo panel de mensaches d'instalación de complementos
urlbar-tip-help-icon =
    .title = Obtener aduya
urlbar-search-tips-confirm = Vale, entendiu!
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Consello:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Escribe menos pa trobar mas cosas: Fe busquedas con { $engineName } dreitament dende la barra d'adrezas.
urlbar-search-tips-redirect-2 = Empecipia la tuya busqueda en a barra d'adrezas pa veyer las sucherencias de { $engineName } y lo tuyo historial de busqueda.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Marcapachinas
urlbar-search-mode-tabs = Pestanyas
urlbar-search-mode-history = Historial

##

urlbar-geolocation-blocked =
    .tooltiptext = Ha blocau la información de localización pa iste puesto web.
urlbar-xr-blocked =
    .tooltiptext = Has blocau l'acceso d'os dispositivos de realidat virtual en este puesto web.
urlbar-web-notifications-blocked =
    .tooltiptext = Ha blocau las notificacions pa iste puesto web.
urlbar-camera-blocked =
    .tooltiptext = Ha blocau la suya camara pa iste puesto web.
urlbar-microphone-blocked =
    .tooltiptext = Ha blocau lo suyo microfono pa iste puesto web.
urlbar-screen-blocked =
    .tooltiptext = Ha blocau la compartición d'a pantalla en iste puesto web.
urlbar-persistent-storage-blocked =
    .tooltiptext = Ha blocau l'almagazenamiento persistent de datos pa iste puesto web.
urlbar-popup-blocked =
    .tooltiptext = Has blocau las finestras emerchents en este puesto web.
urlbar-autoplay-media-blocked =
    .tooltiptext = Has blocau la lectura automatica de contenius multimedia con soniu en este puesto.
urlbar-canvas-blocked =
    .tooltiptext = Has blocau la extracción de datos de lienzo pa este puesto web.
urlbar-midi-blocked =
    .tooltiptext = Tiens blocau l'acceso MIDI en esta web.
urlbar-install-blocked =
    .tooltiptext = Has blocau la instalación de complementos dende este puesto web.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Editar iste marcapachinas ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Marcar ista pachina con o marcapachinas ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Anyader ta la barra d'adrezas
page-action-manage-extension =
    .label = Chestionar la extensión…
page-action-remove-from-urlbar =
    .label = Borrar d'a barra d'adrezas
page-action-remove-extension =
    .label = Borrar extensión

## Auto-hide Context Menu

full-screen-autohide =
    .label = Amagar as barras de ferramientas
    .accesskey = f
full-screen-exit =
    .label = Salir d'o modo pantalla completa
    .accesskey = m

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Esta vegada, mira con:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Cambiar os achustes de busca
search-one-offs-change-settings-compact-button =
    .tooltiptext = Cambiar los achustes de busca
search-one-offs-context-open-new-tab =
    .label = Busca en una pestanya nueva
    .accesskey = t
search-one-offs-context-set-as-default =
    .label = Definir como o motor de busca por defecto
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Definir como motor de busqueda per defecto en finestras privadas
    .accesskey = D
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
    .tooltiptext = Marcapachinas ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Pestanyas ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historial ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Amostrar l'editor mientres se grava
    .accesskey = A
bookmark-panel-done-button =
    .label = Feito
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Connexión insegura
identity-connection-secure = Connexión segura
identity-connection-internal = Ista ye una pachina segura de { -brand-short-name }.
identity-connection-file = Ista pachina s'alza en o suyo ordinadora
identity-extension-page = Esta pachina ye estada cargada dende una extensión.
identity-active-blocked = { -brand-short-name } ha blocau partes d'ista pachina que no son seguras.
identity-custom-root = Connexión verificada per un emisor de certificaus que no ye reconoixiu per Mozilla.
identity-passive-loaded = Bella parte d'ista pachina no ye segura (p. eix. imachens)
identity-active-loaded = Ha desactivau a protección en ista pachina.
identity-weak-encryption = Ista pachina fa servir zifrau feble.
identity-insecure-login-forms = Los datos de dentrada escritos en ista pachina pueden estar compromesos.
identity-permissions =
    .value = Permisos
identity-permissions-reload-hint = Talment haiga de recargar la pachina pa que s'apliquen los cambios.
identity-permissions-empty = No ha dau garra permiso especial ta iste puesto.
identity-clear-site-data =
    .label = Borrar cookies y datos d'o puesto…
identity-connection-not-secure-security-view = No yes connectau de traza segura a este puesto:
identity-connection-verified = Yes connectau de traza segura a este puesto:
identity-ev-owner-label = Certificau emitiu a:
identity-description-custom-root = Mozila no reconoix este emisor de certificaus. Talment te l'haiga anyadiu lo tuyo sistema operativo u bell administrador. <label data-l10n-name="link">Saber-ne mas</label>
identity-remove-cert-exception =
    .label = Eliminar la excepción
    .accesskey = x
identity-description-insecure = A connexión ta iste puesto no ye privada. A información que ninvia podría estar visualizada por atras personas (como claus, mensaches, tarchetas de credito, etc.).
identity-description-insecure-login-forms = A información d'inicio de sesión que introduz en ista pachina no ye segura y podría interceptar-se.
identity-description-weak-cipher-intro = A suya connexión ta ista web fa servir un zifrau feble y no ye privada.
identity-description-weak-cipher-risk = Atras personas podrían visualizar la información u modificar lo comportamiento d'o puesto
identity-description-active-blocked = { -brand-short-name } ha blocau partes d'ista pachina que no son seguras. <label data-l10n-name="link">Saber-ne mas</label>
identity-description-passive-loaded = A connexión no ye privada y a información que comparte con o puesto podría estar visualizada por atras personas.
identity-description-passive-loaded-insecure = Iste puesto web inclui contenius que no son seguros (p. eix. imachens). <label data-l10n-name="link">Saber-ne mas</label>
identity-description-passive-loaded-mixed = Tot y que { -brand-short-name } ha blocau bell conteniu, encara queda conteniu no seguro en a pachina (p.eix. imachens). <label data-l10n-name="link">Saber-ne mas</label>
identity-description-active-loaded = Iste puesto web tien contenius que no son seguros (p. eix. scripts) y a suya connexión no ye privada.
identity-description-active-loaded-insecure = A información que comparte con iste puesto podría estar vista por atros (como claus, mensaches, tarchetas de credito, etc.).
identity-learn-more =
    .value = Saber-ne mas
identity-disable-mixed-content-blocking =
    .label = Desactivar a protección por agora
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Activar a protección
    .accesskey = v
identity-more-info-link-text =
    .label = Mas información

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimizar
browser-window-maximize-button =
    .tooltiptext = Maximizar
browser-window-restore-down-button =
    .tooltiptext = Restaurar
browser-window-close-button =
    .tooltiptext = Zarrar

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Camara ta compartir:
    .accesskey = C
popup-select-microphone =
    .value = Microfono ta compartir:
    .accesskey = M
popup-all-windows-shared = Se compartirán todas as finestras visibles en a suya pantalla.
popup-screen-sharing-not-now =
    .label = No pas agora
    .accesskey = g
popup-screen-sharing-never =
    .label = No permitir nunca
    .accesskey = N
popup-silence-notifications-checkbox = Desactivar notificacions de { -brand-short-name } mientras se comparte
popup-silence-notifications-checkbox-warning = { -brand-short-name } no amostrará notificacions mientres compartes.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Yes compartindo { -brand-short-name }. Atras personas pueden veyer quán te mueves ta una nueva pestanya.
sharing-warning-screen = Yes compartindo tota la pantalla. Atras personas pueden veyer quan cambias ta unatra pestanya.
sharing-warning-proceed-to-tab =
    .label = Pasar a la pestanya
sharing-warning-disable-for-session =
    .label = Desactivar la protección de compartición pa esta sesión

## DevTools F12 popup

enable-devtools-popup-description = Pa emplegar l'alcorce F12, ubre en primeras DevTools per medio d'o menú de desenvolvedor web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Termen a mirar u adreza
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Termen a mirar u adreza
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Mirar en o Web
    .aria-label = Mirar con { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Escribe los termens de busqueda
    .aria-label = Mirar { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Escribe los termens de busqueda
    .aria-label = Buscar marcapachinas
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Escribe los termens de busqueda
    .aria-label = Historial de busqueda
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Escribe los termens de busqueda
    .aria-label = Pestanyas de busqueda
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Mirar con { $name } u escribir una adreza
urlbar-remote-control-notification-anchor =
    .tooltiptext = Lo navegador ye controlau a distancia
urlbar-permissions-granted =
    .tooltiptext = Has dau permisos adicionals a este web.
urlbar-switch-to-tab =
    .value = Ir ta la pestanya:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensión:
urlbar-go-button =
    .tooltiptext = Ir ta la URL d'a barra d'adrezas
urlbar-page-action-button =
    .tooltiptext = Accions de pachina
urlbar-pocket-button =
    .tooltiptext = Alzar en { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ye a pantalla completa
fullscreen-warning-no-domain = Iste documento ye a pantalla completa
fullscreen-exit-button = Salir d'a pantalla completa (esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Salir d'a pantalla completa (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> tien lo control d'o puntero. Prete Esc pa recuperar-ne lo control
pointerlock-warning-no-domain = Iste documento tien lo control d'o puntero. Prete Esc pa recuperar-ne lo control.
