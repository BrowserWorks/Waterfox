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
    .data-title-private = { -brand-full-name } (Navegació privada)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Navegació privada)
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
    .data-title-private = { -brand-full-name } - (Navegació privada)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Navegació privada)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Mostra la informació del lloc

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Obri la subfinestra del missatge d'instal·lació
urlbar-web-notification-anchor =
    .tooltiptext = Canvia l'opció de si es poden rebre notificacions d'este lloc
urlbar-midi-notification-anchor =
    .tooltiptext = Obri la subfinestra MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Gestiona l'ús de programari de DRM
urlbar-web-authn-anchor =
    .tooltiptext = Obri la subfinestra d'autenticació web
urlbar-canvas-notification-anchor =
    .tooltiptext = Gestiona el permís d'extracció de llenç
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Gestiona la compartició del micròfon amb el lloc
urlbar-default-notification-anchor =
    .tooltiptext = Obri la subfinestra del missatge
urlbar-geolocation-notification-anchor =
    .tooltiptext = Obri la subfinestra de la sol·licitud d'ubicació
urlbar-xr-notification-anchor =
    .tooltiptext = Obri el tauler de permisos de realitat virtual
urlbar-storage-access-anchor =
    .tooltiptext = Obri la subfinestra de permisos d'activitat de navegació
urlbar-translate-notification-anchor =
    .tooltiptext = Tradueix esta pàgina
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Gestiona la compartició de finestres o de la pantalla amb el lloc
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Obri la subfinestra del missatge d'emmagatzematge fora de línia
urlbar-password-notification-anchor =
    .tooltiptext = Obri la subfinestra del missatge de guardar la contrasenya
urlbar-translated-notification-anchor =
    .tooltiptext = Gestiona la traducció de pàgines
urlbar-plugins-notification-anchor =
    .tooltiptext = Gestiona l'ús dels complements
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Gestiona la compartició de la càmera o del micròfon amb el lloc
urlbar-autoplay-notification-anchor =
    .tooltiptext = Obri la subfinestra de reproducció automàtica
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Guarda dades en l'emmagatzematge persistent
urlbar-addons-notification-anchor =
    .tooltiptext = Obri la subfinestra del missatge d'instal·lació del complement
urlbar-tip-help-icon =
    .title = Obteniu ajuda
urlbar-search-tips-confirm = Entesos
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Consell:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Escriviu menys i trobeu més: Cerqueu amb { $engineName } directament des de la barra d'adreces.
urlbar-search-tips-redirect-2 = Comenceu la vostra cerca en la barra d'adreces per veure suggeriments de { $engineName } i del vostre historial de navegació.

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Heu blocat la informació d'ubicació per a este lloc web.
urlbar-xr-blocked =
    .tooltiptext = Heu blocat l'accés a dispositius de realitat virtual per a este lloc web.
urlbar-web-notifications-blocked =
    .tooltiptext = Heu blocat les notificacions per a este lloc web.
urlbar-camera-blocked =
    .tooltiptext = Heu blocat la càmera per a este lloc web.
urlbar-microphone-blocked =
    .tooltiptext = Heu blocat el micròfon per a este lloc web.
urlbar-screen-blocked =
    .tooltiptext = Heu blocat la compartició de la pantalla en este lloc web.
urlbar-persistent-storage-blocked =
    .tooltiptext = Heu blocat l'emmagatzematge persistent per a este lloc web.
urlbar-popup-blocked =
    .tooltiptext = Heu blocat les finestres emergents per a este lloc web.
urlbar-autoplay-media-blocked =
    .tooltiptext = Heu blocat la reproducció automàtica de contingut multimèdia amb so per a este lloc web.
urlbar-canvas-blocked =
    .tooltiptext = Heu blocat l'extracció de dades de llenç (canvas) per a este lloc web.
urlbar-midi-blocked =
    .tooltiptext = Heu blocat l'accés MIDI per a este lloc web.
urlbar-install-blocked =
    .tooltiptext = Heu blocat la instal·lació de complements per a este lloc web.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Edita l'adreça d'interés ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Afig la pàgina a les adreces d'interés ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Afig a la barra d'adreces
page-action-manage-extension =
    .label = Gestiona l'extensió…
page-action-remove-from-urlbar =
    .label = Elimina de la barra d'adreces
page-action-remove-extension =
    .label = Elimina l'extensió

## Auto-hide Context Menu

full-screen-autohide =
    .label = Amaga les barres d'eines
    .accesskey = g
full-screen-exit =
    .label = Ix del mode de pantalla completa
    .accesskey = p

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Esta vegada, cerca amb:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Canvia els paràmetres de cerca
search-one-offs-change-settings-compact-button =
    .tooltiptext = Canvia els paràmetres de cerca
search-one-offs-context-open-new-tab =
    .label = Cerca en una pestanya nova
    .accesskey = t
search-one-offs-context-set-as-default =
    .label = Defineix com a motor de cerca per defecte
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Defineix com a motor de cerca per defecte per a les finestres privades
    .accesskey = D

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Mostra l'editor en guardar
    .accesskey = s
bookmark-panel-done-button =
    .label = Fet
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 30em

## Identity Panel

identity-connection-not-secure = La connexió no és segura
identity-connection-secure = Connexió segura
identity-connection-internal = Esta és una pàgina del { -brand-short-name } segura.
identity-connection-file = Esta pàgina està guardada a l'ordinador.
identity-extension-page = Esta pàgina s'ha carregat des d'una extensió.
identity-active-blocked = El { -brand-short-name } ha blocat parts d'esta pàgina que no són segures.
identity-custom-root = Connexió verificada per un emissor de certificats que no és reconegut per Mozilla.
identity-passive-loaded = Parts d'esta pàgina no són segures (com les imatges).
identity-active-loaded = Heu desactivat la protecció en esta pàgina.
identity-weak-encryption = Esta pàgina utilitza xifratge feble.
identity-insecure-login-forms = Les dades d'inici de sessió que introduïu en esta pàgina podrien estar en risc.
identity-permissions =
    .value = Permisos
identity-permissions-reload-hint = Potser cal que actualitzeu la pàgina per aplicar els canvis.
identity-permissions-empty = No heu donat cap permís especial a este lloc.
identity-clear-site-data =
    .label = Esborra les galetes i dades dels llocs…
identity-connection-not-secure-security-view = No esteu connectat de forma segura a este lloc.
identity-connection-verified = Esteu connectat de forma segura a este lloc.
identity-ev-owner-label = Certificat emés per a:
identity-description-custom-root = Mozilla no reconeix este emissor de certificats. És possible que l'haja afegit el vostre sistema operatiu o un administrador. <label data-l10n-name="link">Més informació</label>
identity-remove-cert-exception =
    .label = Elimina l'excepció
    .accesskey = x
identity-description-insecure = La connexió a este lloc no és privada. La informació que envieu podria ser visualitzada per altres persones (com contrasenyes, missatges, targetes de crèdit, etc.).
identity-description-insecure-login-forms = La informació d'inici de sessió que introduïu en esta pàgina no és segura i podria interceptar-se.
identity-description-weak-cipher-intro = La connexió a este lloc web utilitza un xifratge feble i no és privada.
identity-description-weak-cipher-risk = Altres persones podrien visualitzar la informació o modificar el comportament del lloc web.
identity-description-active-blocked = El { -brand-short-name } ha blocat parts d'esta pàgina que no són segures. <label data-l10n-name="link">Més informació</label>
identity-description-passive-loaded = La connexió no és privada i la informació que compartiu amb el lloc podria ser visualitzada per altres persones.
identity-description-passive-loaded-insecure = Este lloc web inclou contingut que no és segur (com les imatges). <label data-l10n-name="link">Més informació</label>
identity-description-passive-loaded-mixed = Malgrat que el { -brand-short-name } ha blocat parts del contingut, encara hi ha contingut de la pàgina que no és segur (such as images). <label data-l10n-name="link">Més informació</label>
identity-description-active-loaded = Este lloc web inclou contingut que no és segur (com els scripts) i la connexió no és privada.
identity-description-active-loaded-insecure = La informació que compartiu amb este lloc podria ser visualitzada per altres persones (com contrasenyes, missatges, targetes de crèdit, etc.).
identity-learn-more =
    .value = Més informació
identity-disable-mixed-content-blocking =
    .label = Desactiva la protecció esta vegada
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Activa la protecció
    .accesskey = v
identity-more-info-link-text =
    .label = Més informació

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimitza
browser-window-maximize-button =
    .tooltiptext = Maximitza
browser-window-restore-down-button =
    .tooltiptext = Restaura avall
browser-window-close-button =
    .tooltiptext = Tanca

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Càmera per compartir:
    .accesskey = C
popup-select-microphone =
    .value = Micròfon per compartir:
    .accesskey = M
popup-all-windows-shared = Es compartiran totes les finestres visibles de la pantalla.
popup-screen-sharing-not-now =
    .label = Ara no
    .accesskey = A
popup-screen-sharing-never =
    .label = No permetes mai
    .accesskey = N
popup-silence-notifications-checkbox = Desactiva les notificacions del { -brand-short-name } mentre s'estiga compartint
popup-silence-notifications-checkbox-warning = El { -brand-short-name } no mostrarà notificacions mentre estigueu compartint.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Esteu compartint el { -brand-short-name }. Les altres persones poden veure quan canvieu a una pestanya nova.
sharing-warning-screen = Esteu compartint la pantalla sencera. Les altres persones poden veure quan canvieu a una pestanya nova.
sharing-warning-proceed-to-tab =
    .label = Vés a la pestanya
sharing-warning-disable-for-session =
    .label = Desactiva la protecció de compartició durant esta sessió

## DevTools F12 popup

enable-devtools-popup-description = Per a usar la drecera F12, primer obriu DevTools en el menú Desenvolupador web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Escriviu una cerca o adreça
urlbar-placeholder =
    .placeholder = Escriviu una cerca o adreça
urlbar-remote-control-notification-anchor =
    .tooltiptext = El navegador està sota control remot
urlbar-permissions-granted =
    .tooltiptext = Heu donat permisos addicionals a este lloc web.
urlbar-switch-to-tab =
    .value = Canvia a la pestanya:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensió:
urlbar-go-button =
    .tooltiptext = Vés a l'adreça de la barra d'ubicació
urlbar-page-action-button =
    .tooltiptext = Accions de la pàgina
urlbar-pocket-button =
    .tooltiptext = Guarda al { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> està a pantalla completa
fullscreen-warning-no-domain = Este document està a pantalla completa
fullscreen-exit-button = Ix de la pantalla completa (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Ix de la pantalla completa (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> té el control del punter. Premeu Esc per recuperar el control.
pointerlock-warning-no-domain = Este document té el control del punter. Premeu Esc per recuperar el control.
