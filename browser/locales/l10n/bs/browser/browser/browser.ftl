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
    .data-title-private = { -brand-full-name } (Privatno surfanje)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privatno surfanje)
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
    .data-title-private = { -brand-full-name } - (Privatno surfanje)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privatno surfanje)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Prikaži informacije stranice

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Otvori panel s instalacijskim porukama
urlbar-web-notification-anchor =
    .tooltiptext = Promijenite da li možete primati obavještenja sa stranice
urlbar-midi-notification-anchor =
    .tooltiptext = Otvori MIDI panel
urlbar-eme-notification-anchor =
    .tooltiptext = Upravljajte upotrebom DRM softvera
urlbar-canvas-notification-anchor =
    .tooltiptext = Upravljanje dozvolama za ekstrakciju canvasa
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Upravljajte dijeljenjem vašeg mikrofona sa stranicom
urlbar-default-notification-anchor =
    .tooltiptext = Otvori panel s porukama
urlbar-geolocation-notification-anchor =
    .tooltiptext = Otvori panel sa zahtjevima lokacije
urlbar-translate-notification-anchor =
    .tooltiptext = Prevedi ovu stranicu
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Upravljajte dijeljenjem vaših prozora ili ekrana sa stranicom
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Otvori panel s porukama offline pohrane
urlbar-password-notification-anchor =
    .tooltiptext = Otvori panel s porukama o spašenim lozinkama
urlbar-translated-notification-anchor =
    .tooltiptext = Upravljajte prijevodom stranica
urlbar-plugins-notification-anchor =
    .tooltiptext = Upravljanje korištenjem plugina
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Upravljajte dijeljenjem vaše kamere i/ili mikrofona sa stranicom
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Pohrani podatke u trajno spremište
urlbar-addons-notification-anchor =
    .tooltiptext = Otvori panel s porukama instalacije add-ona
urlbar-search-tips-confirm = OK, razumijem
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Savjet:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Tipkajte manje, pronađite više: Pretražite { $engineName } izravno iz vaše adresne trake.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Zabilješke
urlbar-search-mode-tabs = Tabovi
urlbar-search-mode-history = Historija

##

urlbar-geolocation-blocked =
    .tooltiptext = Blokirali ste lokacijske informacije za ovu web stranicu.
urlbar-web-notifications-blocked =
    .tooltiptext = Blokirali ste notifikacije za ovu web stranicu.
urlbar-camera-blocked =
    .tooltiptext = Blokirali ste vašu kameru za ovu web stranicu.
urlbar-microphone-blocked =
    .tooltiptext = Blokirali ste vaš mikrofon za ovu web stranicu.
urlbar-screen-blocked =
    .tooltiptext = Blokirali ste dijeljenje vašeg ekrana ovoj web stranici.
urlbar-persistent-storage-blocked =
    .tooltiptext = Blokirali ste trajno spremište za ovu web stranicu.
urlbar-popup-blocked =
    .tooltiptext = Imate blokirane pop-up prozore za ovu web stranicu.
urlbar-canvas-blocked =
    .tooltiptext = Blokirali ste ekstrakciju canvas podataka za ovu web stranicu.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Uredi ovu zabilješku ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Zabilježi ovu stranicu ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Dodaj u adresnu traku
page-action-manage-extension =
    .label = Upravljanje ekstenzijom…
page-action-remove-from-urlbar =
    .label = Ukloni iz adresne trake

## Auto-hide Context Menu

full-screen-autohide =
    .label = Sakrij trake sa alatima
    .accesskey = S
full-screen-exit =
    .label = Prekini prikaz preko cijelog ekrana
    .accesskey = P

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Promijeni postavke pretraživača
search-one-offs-change-settings-compact-button =
    .tooltiptext = Promijeni postavke za pretragu
search-one-offs-context-open-new-tab =
    .label = Traži u novom tabu
    .accesskey = t
search-one-offs-context-set-as-default =
    .label = Postavi kao glavni pretraživač
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
    .tooltiptext = Zabilješke ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Tabovi ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historija ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Prikaži editor prilikom spašavanja
    .accesskey = S
bookmark-panel-done-button =
    .label = Gotovo
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Veza nije sigurna
identity-connection-secure = Sigurna veza
identity-connection-internal = Ovo je sigurna { -brand-short-name } stranica.
identity-connection-file = Ova stranica je pohranjena na vaš računar.
identity-extension-page = Ova stranica je učitana iz ekstenzije.
identity-active-blocked = { -brand-short-name } je blokirao dijelove ove stranice koji nisu sigurni.
identity-passive-loaded = Dijelovi ove stranice nisu sigurni (poput slika).
identity-active-loaded = Onemogućili ste zaštitu na ovoj stranici.
identity-weak-encryption = Ova stranica koristi slabu enkripciju.
identity-insecure-login-forms = Prijave unešene na ovoj stranici mogle bi biti kompromitovane.
identity-permissions-reload-hint = Možda ćete morati ponovo učitati stranicu radi primjene izmjena.
identity-permissions-empty = Ovoj stranici niste dodijelili nikakve posebne dozvole.
identity-remove-cert-exception =
    .label = Ukloni izuzetak
    .accesskey = U
identity-description-insecure = Vaša konekcija na ovu stranicu nije privatna. Informacije koje pošaljete vidljive su drugima (poput lozinki, poruka, kreditnih kartica, itd.).
identity-description-insecure-login-forms = Informacije za prijavu koje unesete na ovoj stranici nisu sigurne i mogle bi biti kompromitovane.
identity-description-weak-cipher-intro = Vaša konekcija na ovu web stranicu koristi slabu enkripciju i nije privatna.
identity-description-weak-cipher-risk = Drugi ljudi mogu vidjeti vaše informacije ili modifikovati ponašanje web stranice.
identity-description-active-blocked = { -brand-short-name } je blokirao dijelove ove stranice koji nisu sigurni. <label data-l10n-name="link">Saznajte više</label>
identity-description-passive-loaded = Vaša konekcija nije privatna, a informacije koje dijelite sa stranicom mogu vidjeti drugi.
identity-description-passive-loaded-insecure = Ova stranica sadrži nesiguran sadržaj (poput slika). <label data-l10n-name="link">Saznajte više</label>
identity-description-passive-loaded-mixed = Iako je { -brand-short-name } blokirao dio sadržaja, i dalje postoji sadržaj na stranici koji nije siguran (poput slika). <label data-l10n-name="link">Saznajte više</label>
identity-description-active-loaded = Ova web stranica sadrži nesiguran sadržaj (poput skripti) te vaša konekcija na nju nije privatna.
identity-description-active-loaded-insecure = Informacije koje dijelite sa ovom stranicom mogu vidjeti drugi (poput lozinki, poruka, kreditnih kartica, itd.).
identity-learn-more =
    .value = Saznajte više
identity-disable-mixed-content-blocking =
    .label = Onemogući zaštitu za sada
    .accesskey = d
identity-enable-mixed-content-blocking =
    .label = Omogući zaštitu
    .accesskey = O
identity-more-info-link-text =
    .label = Više informacija

## Window controls

browser-window-minimize-button =
    .tooltiptext = Minimiziraj
browser-window-close-button =
    .tooltiptext = Zatvori

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera za podijeliti:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon za podijeliti:
    .accesskey = M
popup-all-windows-shared = Svi vidljivi prozori na vašem ekranu će biti podijeljeni.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Unesite termin za pretragu ili adresu
urlbar-placeholder =
    .placeholder = Unesite termin za pretragu ili adresu
urlbar-remote-control-notification-anchor =
    .tooltiptext = Browser je pod udaljenom kontrolom
urlbar-permissions-granted =
    .tooltiptext = Ovoj stranici ste dodijelili dodatne dozvole.
urlbar-switch-to-tab =
    .value = Prebaci se na tab:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Proširenje:
urlbar-go-button =
    .tooltiptext = Idi na adresu upisanu u adresnoj traci
urlbar-page-action-button =
    .tooltiptext = Akcije stranice

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> je sad preko cijelog ekrana
fullscreen-warning-no-domain = Ovaj dokument je prikazan preko cijelog ekrana
fullscreen-exit-button = Izađite iz cijelog ekrana (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Izađite iz cijelog ekrana (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ima kontrolu nad vašim pointerom. Pritisnite Esc da povratite kontrolu.
pointerlock-warning-no-domain = Ovaj dokument ima kontrolu nad vašim pointerom. Pritisnite Esc da povratite kontrolu.
