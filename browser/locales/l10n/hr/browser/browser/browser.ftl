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
    .data-title-private = { -brand-full-name } (Privatno pregledavanje)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privatno pregledavanje)
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
    .data-title-private = { -brand-full-name } - (Privatno pregledavanje)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privatno pregledavanje)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Prikaži informacije o stranici

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Otvori ploču s informacijama o instalaciji
urlbar-web-notification-anchor =
    .tooltiptext = Promijeni postavke primanja obavijesti od ove stranice
urlbar-midi-notification-anchor =
    .tooltiptext = Otvori MIDI okno
urlbar-eme-notification-anchor =
    .tooltiptext = Upravljaj korištenjem DRM softvera
urlbar-web-authn-anchor =
    .tooltiptext = Otvori okno Web autentifikacije
urlbar-canvas-notification-anchor =
    .tooltiptext = Upravljanje dozvolama za izdvajanje platna
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Upravljaj dijeljenjem tvog mikrofona sa stranicom
urlbar-default-notification-anchor =
    .tooltiptext = Otvori ploču s porukama
urlbar-geolocation-notification-anchor =
    .tooltiptext = Otvori ploču sa zahtjevima lokacije
urlbar-xr-notification-anchor =
    .tooltiptext = Otvori ploču dopuštenja za virtualnu stvarnost
urlbar-storage-access-anchor =
    .tooltiptext = Otvori ploču s dozvolama za pregledavanje
urlbar-translate-notification-anchor =
    .tooltiptext = Prevedi ovu stranicu
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Upravljaj dijeljenjem tvojih prozora ili ekrana sa stranicom
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Otvori ploču s informacijama lokalnog spremišta
urlbar-password-notification-anchor =
    .tooltiptext = Otvori ploču s informacijama o spremljenim lozinkama
urlbar-translated-notification-anchor =
    .tooltiptext = Upravljaj prevođenjem stranice
urlbar-plugins-notification-anchor =
    .tooltiptext = Upravljanje korištenjem priključaka
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Upravljaj dijeljenjem tvoje kamere i/ili mikrofona sa stranicom
urlbar-autoplay-notification-anchor =
    .tooltiptext = Otvori ploču za automatsku reprodukciju
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Spremaj podatke u trajno spremište
urlbar-addons-notification-anchor =
    .tooltiptext = Otvori ploču s informacijama o instaliranim dodacima
urlbar-tip-help-icon =
    .title = Potraži pomoć
urlbar-search-tips-confirm = U redu, razumijem
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Savjet:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Tipkaj manje, nađi više: Traži { $engineName } direktno u tvojoj adresnoj traci.
urlbar-search-tips-redirect-2 = Započni pretragu u adresnoj traci za prikaz prijedloga od { $engineName } i tvoju povijest pregledavanja.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Zabilješke
urlbar-search-mode-tabs = Kartice
urlbar-search-mode-history = Povijest

##

urlbar-geolocation-blocked =
    .tooltiptext = Ovoj stranici zabranjen je pristup informacijama o lokaciji.
urlbar-xr-blocked =
    .tooltiptext = Ovoj ste stranici blokirali pristup uređajima za virtualnu stvarnost.
urlbar-web-notifications-blocked =
    .tooltiptext = Ovoj ste stranici zabranili slanje obavijesti.
urlbar-camera-blocked =
    .tooltiptext = Ovoj ste stranici zabranili korištenje kamere.
urlbar-microphone-blocked =
    .tooltiptext = Ovoj ste stranici zabranili korištenje mikrofona.
urlbar-screen-blocked =
    .tooltiptext = Ovoj stranici zabranjeno je dijeljenje tvog zaslona.
urlbar-persistent-storage-blocked =
    .tooltiptext = Ovoj stranici zabranjeno je trajno spremanje podataka.
urlbar-popup-blocked =
    .tooltiptext = Blokirali ste pop-up prozore za ovu web stranicu.
urlbar-autoplay-media-blocked =
    .tooltiptext = Ovoj ste stranici zabranili automatsko reproduciranje medija sa zvukom.
urlbar-canvas-blocked =
    .tooltiptext = Ovoj stranici zabranjeno je izdvajanje podataka platna.
urlbar-midi-blocked =
    .tooltiptext = Blokirali ste MIDI pristup za ovu web stranicu.
urlbar-install-blocked =
    .tooltiptext = Ovoj stranici ste zabranili instalaciju dodataka.
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
    .label = Upravljaj proširenjem …
page-action-remove-from-urlbar =
    .label = Ukloni iz adresne trake
page-action-remove-extension =
    .label = Ukloni porširenje

## Auto-hide Context Menu

full-screen-autohide =
    .label = Sakrij alatne trake
    .accesskey = k
full-screen-exit =
    .label = Izađi iz cjeloekranskog prikaza
    .accesskey = c

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Ovaj put traži pomoću:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Promijeni postavke pretraživača
search-one-offs-change-settings-compact-button =
    .tooltiptext = Promijeni postavke pretraživača
search-one-offs-context-open-new-tab =
    .label = Traži u novoj kartici
    .accesskey = t
search-one-offs-context-set-as-default =
    .label = Postavi kao standardnu tražilicu
    .accesskey = d
search-one-offs-context-set-as-default-private =
    .label = Postavi kao standardnu tražilicu za privatne prozore
    .accesskey = P
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
    .tooltiptext = Kartice ({ $restrict })
search-one-offs-history =
    .tooltiptext = Povijest ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Prikaži uređivač prilikom spremanja
    .accesskey = s
bookmark-panel-done-button =
    .label = Gotovo
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Veza nije sigurna
identity-connection-secure = Veza sigurna
identity-connection-internal = Ovo je sigurna { -brand-short-name } stranica.
identity-connection-file = Ova je stranica spremljena na tvom računalu.
identity-extension-page = Ova stranica je učitana iz dodatka.
identity-active-blocked = { -brand-short-name } je blokirao dijelove ove stranice koji nisu sigurni.
identity-custom-root = Vezu je potvrdio izdavatelj certifikata kojeg Mozilla ne prepoznaje.
identity-passive-loaded = Dijelovi ove stranice nisu sigurni (poput slika).
identity-active-loaded = Zaštita je deaktivirana na ovoj stranici.
identity-weak-encryption = Ova stranica koristi slabo šifriranje.
identity-insecure-login-forms = Prijave na ovoj stranici mogu biti kompromitirane.
identity-permissions =
    .value = Dozvole
identity-permissions-reload-hint = Stranica se možda mora ponovo učitati, kako bi se primijenile promjene.
identity-permissions-empty = Ovoj stranici niste dali nikakva posebna dopuštenja.
identity-clear-site-data =
    .label = Izbriši kolačiće i podatke stranica …
identity-connection-not-secure-security-view = Nisi sigurno povezan/a na ovu stranicu.
identity-connection-verified = Sigurno si povezan/a na ovu stranicu.
identity-ev-owner-label = Certifikat izdan za:
identity-description-custom-root = Mozilla ne prepoznaje ovog izdavatelja certifikata. Možda ga je dodao tvoj operacijski sustav ili administrator. <label data-l10n-name="link">Saznaj više</label>
identity-remove-cert-exception =
    .label = Ukloni iznimku
    .accesskey = U
identity-description-insecure = Tvoja veza s ovom stranicom nije privatna. Informacije koje pošalješ (npr. lozinke, poruke, broj kreditne kartice itd.) može vidjeti treća strana.
identity-description-insecure-login-forms = Pristupni podaci koje unesete na ovoj stranici nisu sigurni i mogu biti kompromitirani.
identity-description-weak-cipher-intro = Tvoja veza s ovom stranicom koristi slabo šifriranje i nije privatna.
identity-description-weak-cipher-risk = Drugi ljudi mogu vidjeti tvoje informacije ili modificirati ponašanje stranice.
identity-description-active-blocked = { -brand-short-name } je blokirao dijelove ove stranice koji nisu sigurni. <label data-l10n-name="link">Saznaj više</label>
identity-description-passive-loaded = Tvoja veza nije privatna i informacije koje dijeliš s ovom stranicom mogu vidjeti drugi.
identity-description-passive-loaded-insecure = Ova stranica ima sadržaj koji nije siguran (npr. slike). <label data-l10n-name="link">Saznaj više</label>
identity-description-passive-loaded-mixed = Iako je { -brand-short-name } blokirao dio sadržaja, još uvijek postoje nesigurni sadržaji na ovoj stranici (poput slika). <label data-l10n-name="link">Saznaj više</label>
identity-description-active-loaded = Ova stranica ima nesiguran sadržaj (poput skripti) i tvoja veza nije privatna.
identity-description-active-loaded-insecure = Informacije koje dijelite s ovom stranicom (npr. lozinke, poruke, broj kreditne kartice itd.) može vidjeti treća strana.
identity-learn-more =
    .value = Saznaj više
identity-disable-mixed-content-blocking =
    .label = Za sada isključi zaštitu
    .accesskey = d
identity-enable-mixed-content-blocking =
    .label = Aktiviraj zaštitu
    .accesskey = A
identity-more-info-link-text =
    .label = Više informacija

## Window controls

browser-window-minimize-button =
    .tooltiptext = Smanji
browser-window-maximize-button =
    .tooltiptext = Proširi
browser-window-restore-down-button =
    .tooltiptext = Vrati dolje
browser-window-close-button =
    .tooltiptext = Zatvori

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Kamera za dijeljenje:
    .accesskey = K
popup-select-microphone =
    .value = Mikrofon za dijeljenje:
    .accesskey = M
popup-all-windows-shared = Svi vidljivi prozori na tvom ekranu će se dijeliti.
popup-screen-sharing-not-now =
    .label = Ne sada
    .accesskey = s
popup-screen-sharing-never =
    .label = Ne dozvoli nikada
    .accesskey = N
popup-silence-notifications-checkbox = Deaktiviraj { -brand-short-name } obavijesti tijekom dijeljenja
popup-silence-notifications-checkbox-warning = { -brand-short-name } neće prikazivati obavijesti dok dijeliš.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Dijeliš { -brand-short-name }. Drugi ljudi mogu vidjeti kad se prebaciš na novu karticu.
sharing-warning-screen = Dijeliš svoj cijeli ekran. Drugi ljudi mogu vidjeti kad se prebaciš na novu karticu.
sharing-warning-proceed-to-tab =
    .label = Prijeđi na karticu
sharing-warning-disable-for-session =
    .label = Deaktiviraj zaštitu dijeljenja za ovu sesiju

## DevTools F12 popup

enable-devtools-popup-description = Kako biste koristili F12 prečicu, prvo otvorite DevTools putem izbornika Web Developer.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Traži ili upiši adresu
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Traži ili upiši adresu
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Pretraži web
    .aria-label = Traži pomoću { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Upiši tražene pojmove
    .aria-label = Pretraži { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Upiši tražene pojmove
    .aria-label = Pretraži zabilješke
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Upiši tražene pojmove
    .aria-label = Pretraži povijest
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Upiši tražene pojmove
    .aria-label = Pretraži kartice
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Traži pomoću { $name } ili upiši adresu
urlbar-remote-control-notification-anchor =
    .tooltiptext = Preglednik se kontrolira s udaljene lokacije
urlbar-permissions-granted =
    .tooltiptext = Ovoj stranici odobrene su dodatne dozvole.
urlbar-switch-to-tab =
    .value = Prebaci na karticu:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Dodatak:
urlbar-go-button =
    .tooltiptext = Idi na adresu iz lokacijske trake
urlbar-page-action-button =
    .tooltiptext = Radnje na stranici
urlbar-pocket-button =
    .tooltiptext = Spremi u { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> se sada prikazuje preko cijelog ekrana
fullscreen-warning-no-domain = Ovaj dokument se sada prikazuje preko cijelog ekrana
fullscreen-exit-button = Izađi iz cjeloekranskog prikaza (esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Izađi iz cjeloekranskog prikaza (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> ima kontrolu nad pokazivačem. Pritisnite tipku Esc da biste preuzeli kontrolu.
pointerlock-warning-no-domain = Ovaj dokument ima kontrolu nad pokazivačem. Pritisnite tipku Esc kako biste preuzeli kontrolu.
