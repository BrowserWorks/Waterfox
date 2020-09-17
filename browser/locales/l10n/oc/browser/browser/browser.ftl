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
    .data-title-private = { -brand-full-name } (Navegacion privada)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Navegacion privada)
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
    .data-title-private = { -brand-full-name } - (Navegacion privada)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Navegacion privada)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Afichar las informacions sul site internet

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Obrir lo panèl de messatge d’installar
urlbar-web-notification-anchor =
    .tooltiptext = Gerir las notificacions per aqueste site
urlbar-midi-notification-anchor =
    .tooltiptext = Dobrir lo panèl MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Gerir l’utilizacion dels logicials DRM
urlbar-web-authn-anchor =
    .tooltiptext = Dobrir lo panèl d’identificacion
urlbar-canvas-notification-anchor =
    .tooltiptext = Gerir las permission d’extraccion de canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Actualament, partejatz vòstre microfòn amb lo site
urlbar-default-notification-anchor =
    .tooltiptext = Mostrar la notificacion
urlbar-geolocation-notification-anchor =
    .tooltiptext = Mostrar la demanda de geolocalizacion
urlbar-xr-notification-anchor =
    .tooltiptext = Dobrir lo panèl d’autorizasions per la realitat virtuala
urlbar-storage-access-anchor =
    .tooltiptext = Dobrir lo panèl de permissions tocant la navegacion
urlbar-translate-notification-anchor =
    .tooltiptext = Traduire aquesta pagina
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Gerir lo partiment de vòstras fenèstras o d'ecran amb aqueste site
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Mostrar lo messatge sus l'emmagazinatge fòra linha
urlbar-password-notification-anchor =
    .tooltiptext = Mostrar lo messatge per enregistrar lo senhal
urlbar-translated-notification-anchor =
    .tooltiptext = Gerir la traduccion de paginas
urlbar-plugins-notification-anchor =
    .tooltiptext = Gerir l'utilizacion dels moduls complementaris
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Actualament, partejatz vòstra camèra o vòstre microfòn amb aqueste site
urlbar-autoplay-notification-anchor =
    .tooltiptext = Dobrir lo panèl de lectura automatica
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Gardar las donadas dins un emmagazinatge permanent
urlbar-addons-notification-anchor =
    .tooltiptext = Mostrar lo messatge d'installation del modul
urlbar-tip-help-icon =
    .title = Obténer d’ajuda
urlbar-search-tips-confirm = Òc, plan comprés
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Astúcia :

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Escrivètz mens, trobatz mai : cercatz amb { $engineName } dirèctament de la barra d’adreça.
urlbar-search-tips-redirect-2 = Començatz vòstra recèrca dins la barra d’adreça per mostrar las suggestions de { $engineName } e de vòstre istoric de navegacion.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Marcapaginas
urlbar-search-mode-tabs = Onglets
urlbar-search-mode-history = Istoric

##

urlbar-geolocation-blocked =
    .tooltiptext = Avètz blocat la geolocalizacion per aqueste site.
urlbar-xr-blocked =
    .tooltiptext = Avètz blocat l’accès als periferics de realitat virtuala per aqueste site web.
urlbar-web-notifications-blocked =
    .tooltiptext = Avètz blocat las notificacions per aquel site.
urlbar-camera-blocked =
    .tooltiptext = Avètz blocat la camèra per aqueste site.
urlbar-microphone-blocked =
    .tooltiptext = Avètz blocat lo microfòn per aqueste site.
urlbar-screen-blocked =
    .tooltiptext = Avètz empachat aquel site de partejar vòstre ecran.
urlbar-persistent-storage-blocked =
    .tooltiptext = Avètz empachat aquel site de gardar de biais persistent de donadas.
urlbar-popup-blocked =
    .tooltiptext = Avètz blocat la fenèstras surgentas per aqueste site.
urlbar-autoplay-media-blocked =
    .tooltiptext = Avètz blocat la lectura automatica dels mèdias amb son per aqueste site.
urlbar-canvas-blocked =
    .tooltiptext = Avètz empachat aqueste site de traire d’informacions de canvas.
urlbar-midi-blocked =
    .tooltiptext = Avètz blocat l’accès MIDI per aqueste site web.
urlbar-install-blocked =
    .tooltiptext = Avètz blocat l’installacion de moduls complementaris per aqueste site.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Modificar aqueste marcapagina ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Marcar aquesta pagina ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Apondre la barra d'adreça
page-action-manage-extension =
    .label = Gerir l’extension…
page-action-remove-from-urlbar =
    .label = Levar de la barra d'adreça
page-action-remove-extension =
    .label = Suprimir l’extension

## Auto-hide Context Menu

full-screen-autohide =
    .label = Amagar las barras d'aisinas
    .accesskey = A
full-screen-exit =
    .label = Quitar lo mòde ecran complet
    .accesskey = Q

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Aqueste còp, recercar amb :
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Paramètres de recèrca
search-one-offs-change-settings-compact-button =
    .tooltiptext = Cambiar los paramètres de recèrca
search-one-offs-context-open-new-tab =
    .label = Recercar dins un onglet novèl
    .accesskey = R
search-one-offs-context-set-as-default =
    .label = Causir coma motor de cerca per defaut
    .accesskey = C
search-one-offs-context-set-as-default-private =
    .label = Definir coma motor de recèrca per defaut en navegacion privada
    .accesskey = p
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
    .tooltiptext = Marcapaginas ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Onglets ({ $restrict })
search-one-offs-history =
    .tooltiptext = Istoric ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Mostrar l’editor en enregistrant
    .accesskey = M
bookmark-panel-done-button =
    .label = Acabar
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 26em

## Identity Panel

identity-connection-not-secure = La connexion pas segura
identity-connection-secure = Connexion segura
identity-connection-internal = Aquò es una pagina segura de { -brand-short-name }.
identity-connection-file = Aquela pagina es enregistrada dins vòstre ordinador.
identity-extension-page = Aquela pagina es estada cargada d’una extension.
identity-active-blocked = { -brand-short-name } a blocat d'elements pas segurs sus aquela pagina.
identity-custom-root = Connexion verificada per un emissor de certificat pas reconegut per Mozilla.
identity-passive-loaded = D'elements de la pagina son pas segurs (coma los imatges).
identity-active-loaded = Avètz desactivat la proteccion sus aquela pagina.
identity-weak-encryption = Aquela pagina utiliza un chiframent flac.
identity-insecure-login-forms = Los identificants marcats sus aquela pagina pòdon far perilh.
identity-permissions =
    .value = Permissions
identity-permissions-reload-hint = Benlèu deuriatz actualizar la pagina per que s'apliquen los cambiaments.
identity-permissions-empty = Avètz pas donat cap de permission espaciala a aquel site.
identity-clear-site-data =
    .label = Escafar los cookies e las donadas de site…
identity-connection-not-secure-security-view = Sètz pas connectat amb seguretat a aquel site.
identity-connection-verified = Sètz connectat amb seguretat a aquel site.
identity-ev-owner-label = Certificat emés per :
identity-description-custom-root = Mozilla reconeis pas aqueste emissor de certificats. Benlèu que foguèt apondut per vòstre sistèma operatiu o per un administrator. <label data-l10n-name="link">Ne saber mai</label>
identity-remove-cert-exception =
    .label = Suprimir l'excepcion
    .accesskey = L
identity-description-insecure = La vòstra connexion a aquel site es pas privada. Las informacions qu'enviatz pòdon èsser vistas per d’autres (coma per exemple los senhals, los messatges, las cartas de crèdit, etc.).
identity-description-insecure-login-forms = Las informacions d’identificacion que marcatz sus aquela pagina son pas seguras e pòdon far perilh.
identity-description-weak-cipher-intro = Vòstra connexion a aquel site web utiliza un chiframent flac e es pas privada.
identity-description-weak-cipher-risk = D’autres pòdon accedir a vòstras informacions o modificar lo compòrtament del site web.
identity-description-active-blocked = { -brand-short-name } a blocat d'elements pas segurs sus aquela pagina. <label data-l10n-name="link">Ne saber mai</label>
identity-description-passive-loaded = Vòstra connexion es pas privada e las informacions que partejatz amb aquel site pòdon èsser vistas per d’autres.
identity-description-passive-loaded-insecure = Aquel site ten de contenguts pas segurs (coma d'imatges). <label data-l10n-name="link">Ne saber mai</label>
identity-description-passive-loaded-mixed = Pasmens se { -brand-short-name } a blocat de contengut, demòra d'elements pas segurs sus la pagina (coma d'imatges). <label data-l10n-name="link">Ne saber mai</label>
identity-description-active-loaded = Aquel site web ten de contengut non segurs (coma d'scripts) e la connexion establida es pas privada.
identity-description-active-loaded-insecure = Las informacions que partejatz amb aquel site pòdon èsser vistas per d’autres (coma par exemple los senhals, los messatges, las cartas de crèdit, etc.).
identity-learn-more =
    .value = Ne saber mai
identity-disable-mixed-content-blocking =
    .label = Desactivar la proteccion per ara
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Activar la proteccion
    .accesskey = A
identity-more-info-link-text =
    .label = Mai d’informacions

## Window controls

browser-window-minimize-button =
    .tooltiptext = Reduire
browser-window-maximize-button =
    .tooltiptext = Maximizar
browser-window-restore-down-button =
    .tooltiptext = Restaurar
browser-window-close-button =
    .tooltiptext = Tampar

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Camèra de partejar :
    .accesskey = C
popup-select-microphone =
    .value = Microfòn de partejar :
    .accesskey = M
popup-all-windows-shared = L'ensemble de las fenèstras visiblas sus vòstre ecran seràn partejadas.
popup-screen-sharing-not-now =
    .label = Pas ara
    .accesskey = P
popup-screen-sharing-never =
    .label = Autorizar pas jamai
    .accesskey = p
popup-silence-notifications-checkbox = Desactivar las notificacions de { -brand-short-name } pendent lo partatge
popup-silence-notifications-checkbox-warning = { -brand-short-name } mostrarà pas de notificacions pendent lo partatge.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Partejatz { -brand-short-name }. Qualqu’un mai pòt veire quand cambiatz d’onglet.
sharing-warning-screen = Sètz a partejar vòstre ecran. D’autras personas pòdon vire quand cambiatz d’onglet.
sharing-warning-proceed-to-tab =
    .label = Passar a l’onglet
sharing-warning-disable-for-session =
    .label = Desactivar lo partiment per aquesta session

## DevTools F12 popup

enable-devtools-popup-description = Per utilizar l’acorchi F12, dobrissètz d’en primièr lo panèl d’aisinas de desvolopament via lo menú Desvolopaire Web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Picar un tèrme de recercar o una adreça
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Picar un tèrme de recercar o una adreça
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Recèrca sul web
    .aria-label = Recercar amb { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Picatz un tèrme de recèrca
    .aria-label = Recercar sus { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Picatz un tèrme de recèrca
    .aria-label = Recercar pels marcapaginas
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Picatz un tèrme de recèrca
    .aria-label = Recercar per l’istoric
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Picatz un tèrme de recèrca
    .aria-label = Recercar pels onglets
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Recercar amb { $name } o picar una adreça
urlbar-remote-control-notification-anchor =
    .tooltiptext = Lo navegador es contrarotlat a distància
urlbar-permissions-granted =
    .tooltiptext = Avètz donat de permissions suplementàrias a aquel site.
urlbar-switch-to-tab =
    .value = Anar a l'onglet :
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extension :
urlbar-go-button =
    .tooltiptext = Anar a la pagina indicada dins la barra d'adreça
urlbar-page-action-button =
    .tooltiptext = Accions de la pagina
urlbar-pocket-button =
    .tooltiptext = Enregistrar dins { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> es en ecran complet
fullscreen-warning-no-domain = Ara, aqueste document es en ecran complet
fullscreen-exit-button = Sortir del mòde ecran complet (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Sortir del mòde ecran complet (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> a lo contra-ròtle sus la vòstra mirga. Quichatz sus Esc per tornar recuperar lo contra-ròtle.
pointerlock-warning-no-domain = Aqueste document a lo contraròtle sul vòstre gredon. Quichatz Esc per tornar prendre lo contra-ròtle.
