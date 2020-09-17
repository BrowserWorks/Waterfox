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
    .data-title-private = { -brand-full-name } (Zasebno brskanje)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Zasebno brskanje)
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
    .data-title-private = { -brand-full-name } - (Zasebno brskanje)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Zasebno brskanje)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Poglejte podatke o strani

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Odpri ploščo s sporočili o namestitvah
urlbar-web-notification-anchor =
    .tooltiptext = Spremenite, ali lahko prejemate obvestila te strani
urlbar-midi-notification-anchor =
    .tooltiptext = Odpri ploščo MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Upravljajte uporabo programske opreme DRM
urlbar-web-authn-anchor =
    .tooltiptext = Odpri ploščo za spletno overitev
urlbar-canvas-notification-anchor =
    .tooltiptext = Upravljaj z dovoljenji za izločanje platna
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Upravljajte dovoljenje za uporabo mikrofona na tej strani
urlbar-default-notification-anchor =
    .tooltiptext = Odpri ploščo s sporočili
urlbar-geolocation-notification-anchor =
    .tooltiptext = Odpri ploščo z zahtevami za lokacijo
urlbar-xr-notification-anchor =
    .tooltiptext = Odprite ploščo z dovoljenji za navidezno resničnost
urlbar-storage-access-anchor =
    .tooltiptext = Odpri ploščo z dovoljenji za brskanje
urlbar-translate-notification-anchor =
    .tooltiptext = Prevedi stran
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Upravljajte dovoljenje za deljenje oken ali zaslona na tej strani
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Odpri ploščo s sporočili o shrambi brez povezave
urlbar-password-notification-anchor =
    .tooltiptext = Odpri ploščo s sporočili o shranjevanju gesel
urlbar-translated-notification-anchor =
    .tooltiptext = Upravljajte prevod strani
urlbar-plugins-notification-anchor =
    .tooltiptext = Upravljanje uporabe vtičnikov
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Upravljajte dovoljenje za uporabo kamere in/ali mikrofona na tej strani
urlbar-autoplay-notification-anchor =
    .tooltiptext = Odpri ploščo samodejnega predvajanja
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Shrani podatke v trajni shrambi
urlbar-addons-notification-anchor =
    .tooltiptext = Odpri ploščo s sporočili o namestitvah dodatkov
urlbar-tip-help-icon =
    .title = Pomoč
urlbar-search-tips-confirm = Razumem
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Namig:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Tipkajte manj, najdite več: Iščite z iskalnikom { $engineName } iz vrstice z naslovom.
urlbar-search-tips-redirect-2 = Začnite z iskanjem v naslovni vrstici ter spremljajte predloge iskalnika { $engineName } in zgodovine vašega brskanja.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Zaznamki
urlbar-search-mode-tabs = Zavihki
urlbar-search-mode-history = Zgodovina

##

urlbar-geolocation-blocked =
    .tooltiptext = Za to stran ste zavrnili uporabo podatkov o lokaciji.
urlbar-xr-blocked =
    .tooltiptext = Za to stran ste zavrnili dostop do naprav navidezne resničnosti.
urlbar-web-notifications-blocked =
    .tooltiptext = Za to stran ste zavrnili prikaz obvestil.
urlbar-camera-blocked =
    .tooltiptext = Za to stran ste zavrnili uporabo kamere.
urlbar-microphone-blocked =
    .tooltiptext = Za to stran ste zavrnili uporabo mikrofona.
urlbar-screen-blocked =
    .tooltiptext = Za to stran ste zavrnili deljenje zaslona.
urlbar-persistent-storage-blocked =
    .tooltiptext = Za to spletno stran ste zavrnili trajno shrambo.
urlbar-popup-blocked =
    .tooltiptext = Za to stran ste zavrnili pojavna okna.
urlbar-autoplay-media-blocked =
    .tooltiptext = Za to stran ste zavrnili samodejno predvajanje večpredstavnosti z zvokom.
urlbar-canvas-blocked =
    .tooltiptext = Za to stran ste zavrnili izločanje podatkov platna.
urlbar-midi-blocked =
    .tooltiptext = Za to stran ste zavrnili uporabo MIDI.
urlbar-install-blocked =
    .tooltiptext = Za to stran ste zavrnili namestitev dodatkov.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Uredi zaznamek ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Dodaj stran med zaznamke ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Dodaj v naslovno vrstico
page-action-manage-extension =
    .label = Upravljaj razširitev ...
page-action-remove-from-urlbar =
    .label = Odstrani iz naslovne vrstice
page-action-remove-extension =
    .label = Odstrani razširitev

## Auto-hide Context Menu

full-screen-autohide =
    .label = Skrij orodne vrstice
    .accesskey = S
full-screen-exit =
    .label = Izhod iz celozaslonskega načina
    .accesskey = C

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Tokrat išči z iskalnikom:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Spremeni nastavitve iskanja
search-one-offs-change-settings-compact-button =
    .tooltiptext = Spremeni nastavitve iskanja
search-one-offs-context-open-new-tab =
    .label = Išči v novem zavihku
    .accesskey = Z
search-one-offs-context-set-as-default =
    .label = Nastavi kot privzet iskalnik
    .accesskey = P
search-one-offs-context-set-as-default-private =
    .label = Nastavi kot privzeti iskalnik za zasebna okna
    .accesskey = z
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
    .tooltiptext = Zaznamki ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Zavihki ({ $restrict })
search-one-offs-history =
    .tooltiptext = Zgodovina ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Pri shranjevanju prikaži urejevalnik
    .accesskey = j
bookmark-panel-done-button =
    .label = Shrani
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Povezava ni varna
identity-connection-secure = Povezava varna
identity-connection-internal = To je varna stran { -brand-short-name }a.
identity-connection-file = Ta stran je shranjena na vašem računalniku.
identity-extension-page = To stran je naložila razširitev.
identity-active-blocked = { -brand-short-name } je zavrnil dele strani, ki niso varni.
identity-custom-root = Povezavo je preveril izdajatelj digitalnega potrdila, ki ga Mozilla ne prepozna.
identity-passive-loaded = Deli strani niso varni (npr. slike).
identity-active-loaded = Zaščita na tej strani je onemogočena.
identity-weak-encryption = Stran uporablja šibko šifriranje.
identity-insecure-login-forms = Prijave, ki jih vnesete na tej strani, so lahko ogrožene.
identity-permissions =
    .value = Dovoljenja
identity-permissions-reload-hint = Za uveljavitev sprememb boste morda morali ponovno naložiti stran.
identity-permissions-empty = Tej strani niste dodelili posebnih dovoljenj.
identity-clear-site-data =
    .label = Počisti piškotke in podatke te strani …
identity-connection-not-secure-security-view = Niste varno povezani na to stran.
identity-connection-verified = Varno ste povezani na to stran.
identity-ev-owner-label = Potrdilo izdano:
identity-description-custom-root = Mozilla ne prepozna tega izdajatelja digitalnih potrdil. Morda ga je dodal vaš operacijski sistem ali skrbnik. <label data-l10n-name="link">Več o tem</label>
identity-remove-cert-exception =
    .label = Odstrani izjemo
    .accesskey = d
identity-description-insecure = Vaša povezava na to stran ni zasebna. Podatke, ki jih pošiljate (npr. gesla, sporočila in kreditne kartice), si lahko ogledajo tudi druge osebe.
identity-description-insecure-login-forms = Podatki, ki jih vnesete ob prijavi na to stran, niso varni in so lahko ogroženi.
identity-description-weak-cipher-intro = Vaša povezava na to stran uporablja šibko šifriranje in ni zasebna.
identity-description-weak-cipher-risk = Druge osebe lahko vidijo vaše podatke ali spreminjajo obnašanje spletne strani.
identity-description-active-blocked = { -brand-short-name } je zavrnil dele strani, ki niso varni. <label data-l10n-name="link">Več o tem</label>
identity-description-passive-loaded = Vaša povezava ni zasebna, zato lahko podatke, ki jih delite s stranjo, vidijo tudi druge osebe.
identity-description-passive-loaded-insecure = Spletna stran vsebuje elemente, ki niso varni (npr. slike). <label data-l10n-name="link">Več o tem</label>
identity-description-passive-loaded-mixed = Čeprav je { -brand-short-name } zavrnil dele vsebine, nekateri drugi deli še vedno niso varni (npr. slike). <label data-l10n-name="link">Več o tem</label>
identity-description-active-loaded = Spletna stran vsebuje elemente, ki niso varni (npr. skripti) in vaša povezava nanjo ni zasebna.
identity-description-active-loaded-insecure = Podatke, ki jih delite s to stranjo, si lahko ogledajo druge osebe (npr. gesla, sporočila in kreditne kartice).
identity-learn-more =
    .value = Več o tem
identity-disable-mixed-content-blocking =
    .label = Onemogoči zaščito za zdaj
    .accesskey = N
identity-enable-mixed-content-blocking =
    .label = Omogoči zaščito
    .accesskey = O
identity-more-info-link-text =
    .label = Več informacij

## Window controls

browser-window-minimize-button =
    .tooltiptext = Skrči
browser-window-maximize-button =
    .tooltiptext = Povečaj
browser-window-restore-down-button =
    .tooltiptext = Obnovi navzdol
browser-window-close-button =
    .tooltiptext = Zapri

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Uporabi kamero:
    .accesskey = K
popup-select-microphone =
    .value = Uporabi mikrofon:
    .accesskey = M
popup-all-windows-shared = Vsa vidna okna na vašem zaslonu bodo v skupni rabi.
popup-screen-sharing-not-now =
    .label = Ne zdaj
    .accesskey = n
popup-screen-sharing-never =
    .label = Nikoli ne dovoli
    .accesskey = N
popup-silence-notifications-checkbox = Onemogočite obvestila { -brand-short-name }a med deljenjem
popup-silence-notifications-checkbox-warning = { -brand-short-name } med deljenjem ne bo prikazoval obvestil.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Delite { -brand-short-name }. Drugi ljudje lahko vidijo, ko preklopite na nov zavihek.
sharing-warning-screen = Delite celoten zaslon. Drugi ljudje lahko vidijo, ko preklopite na nov zavihek.
sharing-warning-proceed-to-tab =
    .label = Nadaljuj na zavihek
sharing-warning-disable-for-session =
    .label = Onemogoči deljenje zaščite za to sejo

## DevTools F12 popup

enable-devtools-popup-description = Za uporabo bližnjice F12 prvič odprite razvojna orodja iz menija Spletni razvoj.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Iskanje ali naslov strani
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Iskanje ali naslov strani
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Išči po spletu
    .aria-label = Išči z iskalnikom { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Vnesite iskalni niz
    .aria-label = Iskanje v { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Vnesite iskalni niz
    .aria-label = Iskanje po zaznamkih
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Vnesite iskalni niz
    .aria-label = Iskanje po zgodovini
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Vnesite iskalni niz
    .aria-label = Iskanje po zavihkih
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Iščite z iskalnikom { $name } ali vnesite naslov
urlbar-remote-control-notification-anchor =
    .tooltiptext = Brskalnik je pod daljinskim upravljanjem
urlbar-permissions-granted =
    .tooltiptext = Tej strani ste dodelili dodatna dovoljenja.
urlbar-switch-to-tab =
    .value = Preklopi na zavihek:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Razširitev:
urlbar-go-button =
    .tooltiptext = Odpri mesto v vrstici z naslovom
urlbar-page-action-button =
    .tooltiptext = Dejanja strani
urlbar-pocket-button =
    .tooltiptext = Shrani v { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = Stran <span data-l10n-name="domain">{ $domain }</span> je zdaj prikazana čez celoten zaslon
fullscreen-warning-no-domain = Ta dokument je zdaj prikazan čez celoten zaslon
fullscreen-exit-button = Izhod iz celozaslonskega načina (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Izhod iz celozaslonskega načina (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ima nadzor nad vašim kazalcem. Pritisnite Esc za ponovni prevzem nadzora.
pointerlock-warning-no-domain = Ta dokument ima nadzor nad vašim kazalcem. Pritisnite Esc za ponovni prevzem nadzora.
