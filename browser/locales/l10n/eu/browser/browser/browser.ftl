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
    .data-title-private = { -brand-full-name } (Nabigatze pribatua)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Nabigatze pribatua)
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
    .data-title-private = { -brand-full-name } - (Nabigatze pribatua)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Nabigatze pribatua)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Ikusi gunearen informazioa

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Ireki instalazio-mezuen panela
urlbar-web-notification-anchor =
    .tooltiptext = Aldatu gunetik jakinarazpenik jaso dezakezun ala ez
urlbar-midi-notification-anchor =
    .tooltiptext = Ireki MIDI panela
urlbar-eme-notification-anchor =
    .tooltiptext = Kudeatu DRM softwarearen erabilpena
urlbar-web-authn-anchor =
    .tooltiptext = Ireki web autentifikazioaren panela
urlbar-canvas-notification-anchor =
    .tooltiptext = Kudeatu canvas-etik erauzteko baimenak
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Kudeatu zure mikrofonoa gunearekin partekatzea
urlbar-default-notification-anchor =
    .tooltiptext = Ireki mezuen panela
urlbar-geolocation-notification-anchor =
    .tooltiptext = Ireki helbide-eskaeren panela
urlbar-xr-notification-anchor =
    .tooltiptext = Ireki errealitate birtualaren baimenen panela
urlbar-storage-access-anchor =
    .tooltiptext = Ireki nabigatze-jardueren baimenen panela
urlbar-translate-notification-anchor =
    .tooltiptext = Itzuli orri hau
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Kudeatu zure leihoak edo pantaila gunearekin partekatzea
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Ireki lineaz kanpoko biltegiratzearen mezuen panela
urlbar-password-notification-anchor =
    .tooltiptext = Ireki pasahitza gordetzeko mezuen panela
urlbar-translated-notification-anchor =
    .tooltiptext = Kudeatu orriaren itzulpena
urlbar-plugins-notification-anchor =
    .tooltiptext = Kudeatu pluginen erabilera
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Kudeatu zure kamera eta/edo mikrofonoa gunearekin partekatzea
urlbar-autoplay-notification-anchor =
    .tooltiptext = Ireki erreprodukzio automatikoaren panela
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Gorde datuak biltegiratze iraunkorrean
urlbar-addons-notification-anchor =
    .tooltiptext = Ireki gehigarrien instalazio-mezuen panela
urlbar-tip-help-icon =
    .title = Lortu laguntza
urlbar-search-tips-confirm = Ados, ulertuta
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Aholkua:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Gutxiago idatzi, gehiago aurkitu: bilatu { $engineName } erabiliz helbide-barratik zuzenean.
urlbar-search-tips-redirect-2 = Hasi zure bilaketa helbide-barran { $engineName } bilatzailearen eta zure nabigazio-historialeko proposamenak ikusteko

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Kokalekuaren informazioa blokeatuta daukazu webgune honetarako.
urlbar-xr-blocked =
    .tooltiptext = Errealitate birtualeko gailuen sarbidea blokeatuta daukazu webgune honetarako.
urlbar-web-notifications-blocked =
    .tooltiptext = Jakinarazpenak blokeatuta dauzkazu webgune honetarako.
urlbar-camera-blocked =
    .tooltiptext = Kamera blokeatuta daukazu webgune honetarako.
urlbar-microphone-blocked =
    .tooltiptext = Mikrofonoa blokeatuta daukazu webgune honetarako.
urlbar-screen-blocked =
    .tooltiptext = Pantaila partekatzea blokeatuta daukazu webgune honetarako.
urlbar-persistent-storage-blocked =
    .tooltiptext = Datuen biltegiratze iraunkorra blokeatuta daukazu webgune honetarako.
urlbar-popup-blocked =
    .tooltiptext = Popup leihoak blokeatuta dauzkazu webgune honetarako.
urlbar-autoplay-media-blocked =
    .tooltiptext = Soinudun multimedia automatikoki erreproduzitzea blokeatuta daukazu gune honetarako.
urlbar-canvas-blocked =
    .tooltiptext = Canvas-eko datuen erauzketa blokeatuta daukazu webgune honetarako.
urlbar-midi-blocked =
    .tooltiptext = MIDI sarbidea blokeatuta daukazu webgune honetarako.
urlbar-install-blocked =
    .tooltiptext = Gehigarrien instalazioa blokeatuta daukazu webgune honetarako.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Editatu laster-marka ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Egin orri honen laster-marka ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Gehitu helbide-barran
page-action-manage-extension =
    .label = Kudeatu hedapena…
page-action-remove-from-urlbar =
    .label = Kendu helbide-barratik
page-action-remove-extension =
    .label = Kendu hedapena

## Auto-hide Context Menu

full-screen-autohide =
    .label = Ezkutatu tresna-barrak
    .accesskey = E
full-screen-exit =
    .label = Irten pantaila osoko ikuspegitik
    .accesskey = p

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Oraingoan, bilatu honekin:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Aldatu bilaketa-ezarpenak
search-one-offs-change-settings-compact-button =
    .tooltiptext = Aldatu bilaketa-ezarpenak
search-one-offs-context-open-new-tab =
    .label = Bilatu fitxa berrian
    .accesskey = f
search-one-offs-context-set-as-default =
    .label = Ezarri bilaketa-motor lehenetsi gisa
    .accesskey = h
search-one-offs-context-set-as-default-private =
    .label = Ezarri leiho pribatuetarako bilaketa-motor lehenetsi gisa
    .accesskey = E

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Erakutsi editorea gordetzean
    .accesskey = E
bookmark-panel-done-button =
    .label = Eginda
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Konexio ez-segurua
identity-connection-secure = Konexio segurua
identity-connection-internal = { -brand-short-name } orri segurua da hau.
identity-connection-file = Orri hau zure ordenagailuan biltegiratuta dago.
identity-extension-page = Orri hau gehigarri batetik kargatu da.
identity-active-blocked = { -brand-short-name }(e)k seguruak ez diren orri honetako zatiak blokeatu ditu.
identity-custom-root = Mozillak onetsi gabeko ziurtagiri-jaulkitzaile batek egiaztatu du konexioa.
identity-passive-loaded = Orri honetako zenbait atal ez dira seguruak (adib. irudiak).
identity-active-loaded = Babesa desgaitu duzu orri honetan.
identity-weak-encryption = Orri honek zifraketa ahula erabiltzen du.
identity-insecure-login-forms = Orri honetan sartutako saio-hasierak arriskuan egon litezke.
identity-permissions =
    .value = Baimenak
identity-permissions-reload-hint = Agian orria berritu beharko duzu aldaketek eragina izan dezaten.
identity-permissions-empty = Ez diozu gune honi baimen berezirik eman.
identity-clear-site-data =
    .label = Garbitu cookieak eta guneetako datuak…
identity-connection-not-secure-security-view = Ez zaude modu seguruan konektatuta gune honetara.
identity-connection-verified = Modu seguruan zaude konektatuta gune honetara.
identity-ev-owner-label = Ziurtagiria honi jaulkia:
identity-description-custom-root = Mozillak ez du ziurtagiri-jaulkitzaile hau ontzat hartzen. Zure sistema eragileak edo administratzaile batek gehitu du agian. <label data-l10n-name="link">Argibide gehiago</label>
identity-remove-cert-exception =
    .label = Kendu salbuespena
    .accesskey = K
identity-description-insecure = Gune honetarako zure konexioa ez da pribatua. Bidaltzen duzun informazioa besteek ikus lezakete (adibidez pasahitzak, mezuak, kreditu-txartelak, etab.).
identity-description-insecure-login-forms = Orri honetan sartzen duzun saio-hasiera informazioa ez da segurua eta arriskuan egon liteke.
identity-description-weak-cipher-intro = Gune honetarako zure konexioak zifraketa ahula erabiltzen du eta ez da pribatua.
identity-description-weak-cipher-risk = Besteek zure informazioa ikusi edo webgunearen portaera alda lezakete.
identity-description-active-blocked = { -brand-short-name }(e)k seguruak ez diren orri honetako atalak blokeatu ditu. <label data-l10n-name="link">Argibide gehiago</label>
identity-description-passive-loaded = Zure konexioa ez da pribatua eta gunearekin partekatzen duzun informazioa besteek ikus lezakete.
identity-description-passive-loaded-insecure = Webgune honek segurua ez den edukia du (adib. irudiak). <label data-l10n-name="link">Argibide gehiago</label>
identity-description-passive-loaded-mixed = { -brand-short-name }(e)k zenbait eduki blokeatu arren, oraindik ere segurua ez den edukia du orriak (adib. irudiak). <label data-l10n-name="link">Argibide gehiago</label>
identity-description-active-loaded = Wegune honek segurua ez den edukia dauka (adibidez script-ak) eta zure konexioa ez da pribatua.
identity-description-active-loaded-insecure = Gune honekin partekatzen duzun informazioa besteek ikus lezakete (adibidez pasahitzak, mezuak, kreditu txartelak, etab.).
identity-learn-more =
    .value = Argibide gehiago
identity-disable-mixed-content-blocking =
    .label = Desgaitu babesa momentuz
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Gaitu babesa
    .accesskey = G
identity-more-info-link-text =
    .label = Informazio gehiago

## Window controls

browser-window-minimize-button =
    .tooltiptext = Txikitu
browser-window-maximize-button =
    .tooltiptext = Maximizatu
browser-window-restore-down-button =
    .tooltiptext = Leheneratu txikira
browser-window-close-button =
    .tooltiptext = Itxi

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Partekatzeko kamera:
    .accesskey = k
popup-select-microphone =
    .value = Partekatzeko mikrofonoa:
    .accesskey = m
popup-all-windows-shared = Zure pantailan ikusgai dauden leiho guztiak partekatuko dira.
popup-screen-sharing-not-now =
    .label = Une honetan ez
    .accesskey = z
popup-screen-sharing-never =
    .label = Inoiz ez baimendu
    .accesskey = n
popup-silence-notifications-checkbox = Partekatu bitartean, desgaitu { -brand-short-name }(r)en jakinarazpenak
popup-silence-notifications-checkbox-warning = { -brand-short-name }(e)k ez du jakinarazpenik bistaratuko partekatzen ari zaren bitartean.

## WebRTC window or screen share tab switch warning

sharing-warning-window = { -brand-short-name } partekatzen ari zara. Fitxaz aldatzen duzunean, besteek ere ikus dezakete.
sharing-warning-screen = Zure pantaila osoa partekatzen ari zara. Fitxaz aldatzen duzunean, besteek ere ikus dezakete.
sharing-warning-proceed-to-tab =
    .label = Jarraitu fitxara
sharing-warning-disable-for-session =
    .label = Desgaitu partekatze-babesa saio honetarako

## DevTools F12 popup

enable-devtools-popup-description = F12 lasterbidea erabiltzeko, ireki lehenik garatzaile-tresnak 'Web garapena' menutik.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Idatzi bilaketa edo helbidea
urlbar-placeholder =
    .placeholder = Idatzi bilaketa edo helbidea
urlbar-remote-control-notification-anchor =
    .tooltiptext = Nabigatzailea urruneko agintepean dago
urlbar-permissions-granted =
    .tooltiptext = Baimen bereziak eman dizkiozu webgune honi.
urlbar-switch-to-tab =
    .value = Aldatu fitxara:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Hedapena:
urlbar-go-button =
    .tooltiptext = Joan kokapen-barrako helbidera
urlbar-page-action-button =
    .tooltiptext = Orri-ekintzak
urlbar-pocket-button =
    .tooltiptext = Gorde { -pocket-brand-name }-en

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> pantaila osoan dago orain
fullscreen-warning-no-domain = Dokumentua pantaila osoan dago orain
fullscreen-exit-button = Irten pantaila osotik (Esk)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Irten pantaila osotik (esk)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> (e)k zure erakuslearen kontrola dauka. Kontrola berreskuratzeko, sakatu eskape tekla.
pointerlock-warning-no-domain = Dokumentu honek zure erakuslearen kontrola dauka. Kontrola berreskuratzeko, sakatu eskape tekla.
