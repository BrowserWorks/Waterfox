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
    .data-title-private = { -brand-full-name } (Privātā pārlūkošana)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privātā pārlūkošana)
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
    .data-title-private = { -brand-full-name } - (Privātā pārlūkošana)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privātā pārlūkošana)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Aplūkot lapas informāciju

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Atvērt instalācijas ziņojumu paneli
urlbar-web-notification-anchor =
    .tooltiptext = Izmainiet vai varat saņemt paziņojumus no šīs lapas
urlbar-midi-notification-anchor =
    .tooltiptext = Atvērt MIDI paneli
urlbar-eme-notification-anchor =
    .tooltiptext = Pārvaldīt DRM programmatūras izmantošanu
urlbar-web-authn-anchor =
    .tooltiptext = Atver autentifikācijas paneli
urlbar-canvas-notification-anchor =
    .tooltiptext = Pārvaldīt audekla izguves atļaujas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Pārvaldiet mikrofona koplietošanu ar šo lapu
urlbar-default-notification-anchor =
    .tooltiptext = Atvērt ziņojumu paneli
urlbar-geolocation-notification-anchor =
    .tooltiptext = Atvērt atrašanās vietu pieprasījumu paneli
urlbar-translate-notification-anchor =
    .tooltiptext = Tulkot šo lapu
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Pārvaldiet loga vai visa ekrāna koplietošanu ar šo lapu
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Atvērt nesaistes datu saglabāšanas ziņojumu paneli
urlbar-password-notification-anchor =
    .tooltiptext = Atvērt paroles saglabāšanas ziņojumu paneli
urlbar-translated-notification-anchor =
    .tooltiptext = Pārvaldīt lapas tulkojumus
urlbar-plugins-notification-anchor =
    .tooltiptext = Pārvaldīt papildinājumu izmantošanu
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Pārvaldiet kameras un/vai mikrofona koplietošanu ar šo lapu
urlbar-autoplay-notification-anchor =
    .tooltiptext = Atvērt automātiskās atskaņošanas paneli
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Glabāt datus pastāvīgajā krātuvē
urlbar-addons-notification-anchor =
    .tooltiptext = Atvērt papildinājumu instalēšanas ziņojumu paneli

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Rakstiet mazāk, atrodiet vairāk: Meklējiet ar { $engineName } adreses joslā.

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Atrašanās vietas informācijas koplietošana ar šo lapu ir bloķēta.
urlbar-web-notifications-blocked =
    .tooltiptext = Paziņojumu saņemšana no šīs lapas ir bloķēta.
urlbar-camera-blocked =
    .tooltiptext = Kameras izmantošana šajā lapā ir bloķēta.
urlbar-microphone-blocked =
    .tooltiptext = Mikrofona izmantošana šajā lapā ir bloķēta.
urlbar-screen-blocked =
    .tooltiptext = Ekrāna koplietošana ar šo lapu ir bloķēta.
urlbar-persistent-storage-blocked =
    .tooltiptext = Datu glabāšana ir bloķēta šajā lapā.
urlbar-popup-blocked =
    .tooltiptext = Uzlecošo logu rādīšana no šīs lapas ir bloķēta.
urlbar-autoplay-media-blocked =
    .tooltiptext = Automātiskā multimēdiju ar skaņu atskaņošana šajā lapā ir bloķēta.
urlbar-canvas-blocked =
    .tooltiptext = Šīs lapas canvas datu ieguve ir bloķēta.
urlbar-midi-blocked =
    .tooltiptext = MIDI izmantošana šajā lapā ir bloķēta.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Rediģēt šo grāmatzīmi ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Saglabāt šo lapu grāmatzīmēs ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Pievienot adreses joslai
page-action-manage-extension =
    .label = Pārvaldīt paplašinājumu…
page-action-remove-from-urlbar =
    .label = Novākt no adreses joslas

## Auto-hide Context Menu

full-screen-autohide =
    .label = Paslēpt rīkjoslas
    .accesskey = P
full-screen-exit =
    .label = Iziet no pilnekrāna režīma
    .accesskey = p

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Mainīt meklēšanas iestatījumus
search-one-offs-change-settings-compact-button =
    .tooltiptext = Mainīt meklēšanas iestatījumus
search-one-offs-context-open-new-tab =
    .label = Meklēt jaunā cilnē
    .accesskey = c
search-one-offs-context-set-as-default =
    .label = Iestatīt par noklusēto meklētāju
    .accesskey = n

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Rādīt redaktoru, saglabājot
    .accesskey = S
bookmark-panel-done-button =
    .label = Gatavs
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-internal = Šī ir droša { -brand-short-name } lapa.
identity-connection-file = Šī lapa ir saglabāta jūsu datorā.
identity-extension-page = Šī lapa ir ielādēta no papildinājuma.
identity-active-blocked = { -brand-short-name } bloķēja nedrošo saturu šajā lapā.
identity-passive-loaded = Šīs lapas daļas (piemēram attēli) nav drošas.
identity-active-loaded = Nedrošu elementu aizsardzība ir deaktivēta.
identity-weak-encryption = Šī lapa izmanto vāju šifrēšanu.
identity-insecure-login-forms = Dati, ko ievadīsiet šajā lapā nav aizsargāti un var tikt pārtverti.
identity-permissions-reload-hint = Lai redzētu izmaiņas iespējams būs nepieciešama lapas pārlāde.
identity-permissions-empty = Šai lapai nav piešķirtas nekādas īpašas atļaujas.
identity-clear-site-data =
    .label = Notīrīt sīkdatnes un lapu datus…
identity-remove-cert-exception =
    .label = Attālinātā izpilde
    .accesskey = A
identity-description-insecure = Jūsu savienojums ar šo lapu nav drošs. Lapai nosūtītā informācija (piemēram paroles, ziņojumi vai kredītkartes dati) var būt pieejami citiem.
identity-description-insecure-login-forms = Dati, ko ievadīsiet šajā lapā nav aizsargāti un var tikt pārtverti.
identity-description-weak-cipher-intro = Jūsu savienojums ar šo lapu izmanto vāju šifrēšanu un nav privāts.
identity-description-weak-cipher-risk = Citi cilvēki var aplūkot jūsu informāciju vai modificēt lapas uzvedību.
identity-description-active-blocked = { -brand-short-name } bloķēja nedrošo saturu šajā lapā. <label data-l10n-name="link">Uzzināt vairāk</label>
identity-description-passive-loaded = Jūsu savienojums ar šo lapu nav drošs, lapai nosūtītā informācija var būt pieejami citiem.
identity-description-passive-loaded-insecure = Šīs lapas daļas (piemēram attēli) nav drošas. <label data-l10n-name="link">Uzzināt vairāk</label>
identity-description-passive-loaded-mixed = Lai arī { -brand-short-name } bloķēja nedrošo saturu, lapā joprojām ir saturs, kas nav drošs (piemēram attēli). <label data-l10n-name="link">Uzzināt vairāk</label>
identity-description-active-loaded = Šīs lapas daļas (piemēram attēli vai skripti) nav droši un jūsu savienojums nav privāts.
identity-description-active-loaded-insecure = Lapai nosūtītā informācija (piemēram paroles, ziņojumi vai kredītkartes dati) var būt pieejami citiem.
identity-learn-more =
    .value = Uzzināt vairāk
identity-disable-mixed-content-blocking =
    .label = Pagaidām deaktivēt aizsardzību
    .accesskey = d
identity-enable-mixed-content-blocking =
    .label = Aktivēt aizsardzību
    .accesskey = b
identity-more-info-link-text =
    .label = Sīkāka informācija

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimizēt
browser-window-close-button =
    .tooltiptext = Aizvērt

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Izvēlies kameru:
    .accesskey = k
popup-select-microphone =
    .value = Izvēlies mikrofonu:
    .accesskey = m
popup-all-windows-shared = Visi uz ekrāna redzamie logi tiks koplietoti.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Ieraksti meklējamo tekstu vai mājas lapas adresi
urlbar-placeholder =
    .placeholder = Ieraksti meklējamo tekstu vai mājas lapas adresi
urlbar-remote-control-notification-anchor =
    .tooltiptext = Pārlūks tiek attālināti kontrolēts
urlbar-switch-to-tab =
    .value = Pārslēgties uz cilni:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Paplašinājums:
urlbar-go-button =
    .tooltiptext = Pāriet uz adresi, kas redzama vietas joslā
urlbar-page-action-button =
    .tooltiptext = Lapas darbības

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ir pa visu ekrānu
fullscreen-warning-no-domain = Šis dokuments ir pa visu ekrānu
fullscreen-exit-button = Iziet no pilnā ekrāna (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Iziet no pilnā ekrāna (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> kontrolē kursoru. Nospiediet taustiņu Esc, lai atgūtu kontroli.
pointerlock-warning-no-domain = Šis dokuments kontrolē kursoru. Nospiediet taustiņu Esc, lai atgūtu kontroli.
