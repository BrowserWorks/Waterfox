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
    .data-title-private = { -brand-full-name } (Restolando en privao)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Restolando en privao)
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
    .data-title-private = { -brand-full-name } - (Restolando en privao)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Restolando en privao)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Ver información del sitiu

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Abrir panel de mensaxe d'instalación
urlbar-web-notification-anchor =
    .tooltiptext = Cambiar si se reciben notificaciones del sitiu
urlbar-eme-notification-anchor =
    .tooltiptext = Remanar l'usu del software DRM
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Remanar compartir micrófonu col sitiu
urlbar-default-notification-anchor =
    .tooltiptext = Abrir panel de mensaxes
urlbar-geolocation-notification-anchor =
    .tooltiptext = Abrir panel de solicitú de llocalización
urlbar-translate-notification-anchor =
    .tooltiptext = Traducir esta páxina
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Remanar compartir ventanes o pantalla col sitiu
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Abrir panel de mensaxes d'almacenamientu ensin conexón
urlbar-password-notification-anchor =
    .tooltiptext = Abrir panel de mensaxes de contraseñes guardaes
urlbar-translated-notification-anchor =
    .tooltiptext = Remanar la traducción de páxina
urlbar-plugins-notification-anchor =
    .tooltiptext = Remanar usu de plugins
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Remanar compartir cámara y/o micrófonu col sitiu
urlbar-addons-notification-anchor =
    .tooltiptext = Abrir panel de mensaxes d'instalación de complementos

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".


## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Bloquiesti la to información d'allugamientu pa esti sitiu web.
urlbar-web-notifications-blocked =
    .tooltiptext = Bloquiesti los avisos pa esti sitiu web.
urlbar-camera-blocked =
    .tooltiptext = Bloquiesti la to cámara pa esti sitiu web.
urlbar-microphone-blocked =
    .tooltiptext = Bloquiesti'l to micrófonu pa esti sitiu web.
urlbar-screen-blocked =
    .tooltiptext = Bloquiesti la compartición de pantalla pa esti sitiu web.
urlbar-popup-blocked =
    .tooltiptext = Bloquiesti los ventanos emerxentes d'esti sitiu web.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Editar esti marcardor ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Amestar esta páxina a marcadores ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Amestar a la barra de direiciones

## Auto-hide Context Menu

full-screen-autohide =
    .label = Anubrir barres de ferramientes
    .accesskey = A
full-screen-exit =
    .label = Colar del mou pantalla completa
    .accesskey = C

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Camudar axustes de gueta
search-one-offs-change-settings-compact-button =
    .tooltiptext = Camudar preferencies de busca
search-one-offs-context-open-new-tab =
    .label = Guetar en llingüeta nueva
    .accesskey = L
search-one-offs-context-set-as-default =
    .label = Afitar como motor de gueta por defeutu
    .accesskey = A

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-done-button =
    .label = Fecho

## Identity Panel

identity-connection-internal = Esta ye una páxina segura de { -brand-short-name }.
identity-connection-file = Esta páxina ta atroxada nel to ordenador.
identity-extension-page = Esta páxina cargóse dende una estensión.
identity-active-blocked = { -brand-short-name } bloquió partes d'esta páxina que nun son segures.
identity-passive-loaded = Partes d'esta páxina nun son segures (cómo imáxenes).
identity-active-loaded = Deshabilitesti la proteición nesta páxina.
identity-weak-encryption = Esta páxina usa cifráu feble.
identity-insecure-login-forms = Quiciabes se comprometieren los anicios de sesión introducíos nesta páxina.
identity-permissions-reload-hint = Quiciabes precises recargar la páxina p'aplicar les camudancies.
identity-permissions-empty = Nun-y concediesti permisu especial dalu a esti sitiu.
identity-remove-cert-exception =
    .label = Desaniciar esceición
    .accesskey = D
identity-description-insecure = La to conexón a esti sitiu nun ye privada. La información qu'unvies, (como contraseñes, mensaxes, tarxetes de creitu... etc), quiciabes puean vela otros.
identity-description-insecure-login-forms = La información del aniciu de sesión qu'introduzas nesta páxina nun ta segura y pue vese comprometida.
identity-description-weak-cipher-intro = La conexón con esti sitiu web usa cifráu feble y nun ye privada.
identity-description-weak-cipher-risk = Otra xente pue ver la to información o midificar el comportamientu'l sitiu web.
identity-description-active-blocked = { -brand-short-name } bloquió partes d'esta páxina que nun son segures. <label data-l10n-name="link">Deprendi más</label>
identity-description-passive-loaded = La to conexón nun ye privada y la información que compartas col sitiu podríen vela otros.
identity-description-passive-loaded-insecure = Esti sitiu web contién conteníu que nun ye seguru (por exemplu: imáxenes). <label data-l10n-name="link">Deprendi más</label>
identity-description-passive-loaded-mixed = Magar que { -brand-short-name } bloquiare daqué conteníu, entá hai conteníu na páxina que nun ye seguru (como imáxenes). <label data-l10n-name="link">Deprendi más</label>
identity-description-active-loaded = Esti sitiu web contién conteníu que nun ye seguru (como scripts) y la to conexón a ella nun ye privada.
identity-description-active-loaded-insecure = La información que compartas con esti sitiu van poder vela otros (contraseñes, mensaxes, tarxetes de creitu, etc.).
identity-learn-more =
    .value = Deprendi más
identity-disable-mixed-content-blocking =
    .label = Deshabilitar proteición pel momentu
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Habilitar proteición
    .accesskey = A
identity-more-info-link-text =
    .label = Más información

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimizar
browser-window-close-button =
    .tooltiptext = Zarrar

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Cámara pa compartir:
    .accesskey = C
popup-select-microphone =
    .value = Micrófonu pa compartir:
    .accesskey = M
popup-all-windows-shared = Van compartise toles ventanes visibles na to pantalla.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Guetar o introducir direición
urlbar-placeholder =
    .placeholder = Guetar o introducir direición
urlbar-switch-to-tab =
    .value = Camudar a la llingüeta:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Estensión:
urlbar-go-button =
    .tooltiptext = Va a la direición na barra d'allugamientos
urlbar-page-action-button =
    .tooltiptext = Aiciones de la páxina

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ta agora a pantalla completa
fullscreen-warning-no-domain = Agora esti documentu ta a pantalla completa
fullscreen-exit-button = Colar de pantalla completa (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Colar de pantalla completa (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> tien el control del to punteru. Primi Esc pa recuperalu.
pointerlock-warning-no-domain = Esti documentu tien el control del to punteru. Primi Esc pa recuperalu.
