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
    .data-title-private = { -brand-full-name } (Modus privat)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Modus privat)
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
    .data-title-private = { -brand-full-name } - (Modus privat)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Modus privat)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Mussar infurmaziuns davart la pagina

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Avrir la panela cun il messadi d'installaziun
urlbar-web-notification-anchor =
    .tooltiptext = Definir sche ti vuls retschaiver notificaziuns da la pagina
urlbar-midi-notification-anchor =
    .tooltiptext = Avrir la panela MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Administrar l'utilisaziun da software DRM
urlbar-web-authn-anchor =
    .tooltiptext = Avrir la panela d'autentificaziun web
urlbar-canvas-notification-anchor =
    .tooltiptext = Administrar ils permiss d'extracziun da canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Administrar la cundivisiun dal microfon cun la pagina
urlbar-default-notification-anchor =
    .tooltiptext = Avrir la panela da messadis
urlbar-geolocation-notification-anchor =
    .tooltiptext = Avrir la panela che dumonda la posiziun
urlbar-xr-notification-anchor =
    .tooltiptext = Avrir la panela da permissiuns per la realitad virtuala
urlbar-storage-access-anchor =
    .tooltiptext = Avrir la panela da las permissiuns per la navigaziun
urlbar-translate-notification-anchor =
    .tooltiptext = Translatar questa pagina
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Administrar la cundivisiun da fanestras u dal visur cun la pagina
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Avrir la panela per la memoria offline
urlbar-password-notification-anchor =
    .tooltiptext = Avrir la panela per memorisar pleds-clav
urlbar-translated-notification-anchor =
    .tooltiptext = Administrar la translaziun da la pagina
urlbar-plugins-notification-anchor =
    .tooltiptext = Administrar l'utilisaziun da plug-ins
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Administrar la cundivisiun da la camera/dal microfon cun la pagina
urlbar-autoplay-notification-anchor =
    .tooltiptext = Avrir la panela da reproducziun automatica
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Memorisar datas en la memoria durabla
urlbar-addons-notification-anchor =
    .tooltiptext = Avrir la panela d'installaziun da supplements
urlbar-tip-help-icon =
    .title = Ir per agid
urlbar-search-tips-confirm = Ok, chapì
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tip:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Tippar main e chattar dapli: Tschertga cun { $engineName } directamain en la trav d'adressas.
urlbar-search-tips-redirect-2 = Cumenza tia tschertga en la trav d'adressas per laschar mussar propostas da { $engineName } e propostas ord tia cronologia.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Segnapaginas
urlbar-search-mode-tabs = Tabs
urlbar-search-mode-history = Cronologia

##

urlbar-geolocation-blocked =
    .tooltiptext = Ti has bloccà las infurmaziuns da geolocalisaziun per questa website.
urlbar-xr-blocked =
    .tooltiptext = Ti has bloccà l'access als apparats da realitad virtuala per questa website.
urlbar-web-notifications-blocked =
    .tooltiptext = Ti has bloccà ils messadis da questa website.
urlbar-camera-blocked =
    .tooltiptext = Ti has bloccà tia camera per questa website.
urlbar-microphone-blocked =
    .tooltiptext = Ti has bloccà tes microfon per questa website.
urlbar-screen-blocked =
    .tooltiptext = Ti has bloccà la pussaivladad da questa website da cundivider tes visur.
urlbar-persistent-storage-blocked =
    .tooltiptext = Ti has bloccà la memoria durabla per questa website.
urlbar-popup-blocked =
    .tooltiptext = Ti has bloccà pop-ups per questa website.
urlbar-autoplay-media-blocked =
    .tooltiptext = Ti has bloccà la reproducziun automatica dad elements da multimedia cun tun.
urlbar-canvas-blocked =
    .tooltiptext = Ti has bloccà l'extracziun da datas da canvas per questa website.
urlbar-midi-blocked =
    .tooltiptext = Ti has bloccà l'access a MIDI per questa pagina d'internet.
urlbar-install-blocked =
    .tooltiptext = Ti has bloccà l'installaziun da supplements per questa website.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Modifitgar quest segnapagina ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Agiuntar in segnapagina ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Agiuntar a la trav d'adressas
page-action-manage-extension =
    .label = Administrar il supplement…
page-action-remove-from-urlbar =
    .label = Allontanar da la trav d'adressas
page-action-remove-extension =
    .label = Allontanar l'extensiun

## Auto-hide Context Menu

full-screen-autohide =
    .label = Zuppentar las travs d'utensils
    .accesskey = a
full-screen-exit =
    .label = Interrumper il modus da maletg entir
    .accesskey = I

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Per questa giada, tschertgar cun:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Midar parameters da tschertga
search-one-offs-change-settings-compact-button =
    .tooltiptext = Midar ils parameters per tschertgar
search-one-offs-context-open-new-tab =
    .label = Tschertgar en in nov tab
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = Definir sco maschina da tschertgar da standard
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Definir sco maschina da tschertgar da standard per fanestras privatas
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
    .tooltiptext = Segnapaginas ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Tabs ({ $restrict })
search-one-offs-history =
    .tooltiptext = Cronologia ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Mussar l'editur cun memorisar
    .accesskey = s
bookmark-panel-done-button =
    .label = Terminar
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 30em

## Identity Panel

identity-connection-not-secure = Connexiun betg segirada
identity-connection-secure = Connexiun segirada
identity-connection-internal = Quai è ina pagina segira da { -brand-short-name }.
identity-connection-file = Questa pagina è memorisada sin tes computer.
identity-extension-page = Ina extensiun ha chargià questa pagina.
identity-active-blocked = { -brand-short-name } ha bloccà parts da questa pagina che n'èn betg segiradas.
identity-custom-root = Connexiun verifitgada dad in certificat emess dad post da certificaziun betg renconuschì da Mozilla.
identity-passive-loaded = Parts da questa pagina (p.ex. maletgs) n'èn betg segiradas.
identity-active-loaded = Ti has deactivà la protecziun per questa pagina.
identity-weak-encryption = Questa pagina utilisescha in criptadi flaivel.
identity-insecure-login-forms = Infurmaziuns d'annunzia endatadas sin questa pagina èn eventualmain periclitadas.
identity-permissions =
    .value = Autorisaziuns
identity-permissions-reload-hint = Forsa stos ti chargiar da nov questa pagina per applitgar las midadas.
identity-permissions-empty = Ti n'has betg definì autorisaziuns spezialas per questa pagina.
identity-clear-site-data =
    .label = Stizzar ils cookies e las datas da websites…
identity-connection-not-secure-security-view = Ti n'es betg collià a moda segira cun questa website.
identity-connection-verified = Ti es collià a moda segira cun questa website.
identity-ev-owner-label = Certificat emess per:
identity-description-custom-root = Mozilla na renconuscha betg l'emettur da quest certificat. Eventualmain è el vegnì agiuntà da tes sistem operativ u dad in administratur. <label data-l10n-name="link">Ulteriuras infurmaziuns</label>
identity-remove-cert-exception =
    .label = Allontanar l'excepziun
    .accesskey = r
identity-description-insecure = Tia connexiun cun questa pagina n'è betg privata. Infurmaziuns che ti tramettas (p.ex. pleds-clav, messadis, numers da cartas da credit etc.) pon eventualmain vegnir legidas dad auters.
identity-description-insecure-login-forms = Las datas d'annunzia che ti endateschas sin questa pagina n'èn betg segiradas ed èn eventualmain periclitadas.
identity-description-weak-cipher-intro = Tia connexiun cun questa pagina utilisescha in criptadi flaivel e n'è betg privata.
identity-description-weak-cipher-risk = Autras persunas pon vesair tias infurmaziuns u modifitgar la pagina d'internet.
identity-description-active-blocked = { -brand-short-name } ha bloccà parts da questa pagina che n'èn betg segiradas. <label data-l10n-name="link">Ulteriuras infurmaziuns</label>
identity-description-passive-loaded = Tia connexiun n'è betg privata ed infurmaziuns che ti cundividas cun la pagina pon eventualmain vegnir legidas dad auters.
identity-description-passive-loaded-insecure = Questa website ha cuntegn (p.ex. maletgs) che n'è betg segirà. <label data-l10n-name="link">Ulteriuras infurmaziuns</label>
identity-description-passive-loaded-mixed = Malgrà che { -brand-short-name } ha bloccà parts dal cuntegn, datti anc adina cuntegn da la pagina che n'è betg segirà (p.ex. maletgs). <label data-l10n-name="link">Ulteriuras infurmaziuns</label>
identity-description-active-loaded = Questa website ha cuntegn (p.ex. scripts) che n'è betg segirà e tia connexiun cun ella n'è betg privata.
identity-description-active-loaded-insecure = Infurmaziuns che ti cundividas cun questa pagina (p.ex. pleds-clav, messadis, numers da cartas da credit etc.) pon esser legiblas per auters.
identity-learn-more =
    .value = Ulteriuras infurmaziuns
identity-disable-mixed-content-blocking =
    .label = Deactivar per quella giada la protecziun
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Activar la protecziun
    .accesskey = A
identity-more-info-link-text =
    .label = Mussar detagls

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimar
browser-window-maximize-button =
    .tooltiptext = Maximar
browser-window-restore-down-button =
    .tooltiptext = Restaurar
browser-window-close-button =
    .tooltiptext = Serrar

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Camera per cundivider:
    .accesskey = C
popup-select-microphone =
    .value = Microfon per cundivider:
    .accesskey = M
popup-all-windows-shared = Tut las fanestras visiblas sin tes visur vegnan cundivididas.
popup-screen-sharing-not-now =
    .label = Betg ussa
    .accesskey = g
popup-screen-sharing-never =
    .label = Mai permetter
    .accesskey = M
popup-silence-notifications-checkbox = Deactivar las communicaziuns da { -brand-short-name } durant la cundivisiun
popup-silence-notifications-checkbox-warning = { -brand-short-name } na mussa naginas communicaziuns durant la cundivisiun dal visur.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Ti cundividas { -brand-short-name }. Autras persunas vesan sche ti midas ad in auter tab.
sharing-warning-screen = Ti cundividas tes entir visur. Autras persunas vesan sche ti midas ad in auter tab.
sharing-warning-proceed-to-tab =
    .label = Cuntinuar al tab
sharing-warning-disable-for-session =
    .label = Deactivar la protecziun da cundivisiun per questa sesida

## DevTools F12 popup

enable-devtools-popup-description = Per utilisar la scursanida F12, l'emprim avrir ils utensils per sviluppaders via il menu Sviluppaders dal web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Tschertgar u endatar in'adressa
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Tschertgar u endatar in'adressa
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Tschertgar en il web
    .aria-label = Tschertgar cun { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Endatar terms da tschertga
    .aria-label = Tschertgar tar { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Endatar terms da tschertga
    .aria-label = Tschertgar en ils segnapaginas
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Endatar terms da tschertga
    .aria-label = Tschertgar en la cronologia
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Endatar terms da tschertga
    .aria-label = Tschertgar tabs
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Tschertgar cun { $name } u endatar in'adressa
urlbar-remote-control-notification-anchor =
    .tooltiptext = Il navigatur vegn controllà a distanza
urlbar-permissions-granted =
    .tooltiptext = Ti has concedì dretgs supplementars a questa pagina.
urlbar-switch-to-tab =
    .value = Midar al tab:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extensiun:
urlbar-go-button =
    .tooltiptext = Chargiar l'adressa endatada en la trav d'adressas
urlbar-page-action-button =
    .tooltiptext = Acziuns da pagina
urlbar-pocket-button =
    .tooltiptext = Memorisar en { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> è ussa en il modus da maletg entir
fullscreen-warning-no-domain = Quest document è ussa en il modus da maletg entir
fullscreen-exit-button = Bandunar il modus da maletg entir (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Bandunar il modus da maletg entir (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> controllescha il punctader. Smatga ESC per reacquistar la controlla.
pointerlock-warning-no-domain = Quest document controllescha il punctader. Smatga ESC per reacquistar la controlla.
