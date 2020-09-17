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
    .data-title-private = { -brand-full-name } (Privát böngészés)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Privát böngészés)
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
    .data-title-private = { -brand-full-name } - (Privát böngészés)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Privát böngészés)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Oldal adatainak megjelenítése

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Telepítési üzenetpanel megnyitása
urlbar-web-notification-anchor =
    .tooltiptext = Módosítsa, hogy kap-e értesítéseket ettől az oldaltól
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI panel megnyitása
urlbar-eme-notification-anchor =
    .tooltiptext = DRM-es szoftver használatának kezelése
urlbar-web-authn-anchor =
    .tooltiptext = Webes hitelesítési panel megnyitása
urlbar-canvas-notification-anchor =
    .tooltiptext = Vászonból kinyerés engedélyének kezelése
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = A mikrofon az oldallal megosztásának kezelése
urlbar-default-notification-anchor =
    .tooltiptext = Üzenetpanel megnyitása
urlbar-geolocation-notification-anchor =
    .tooltiptext = Helymeghatározási kérés panel megnyitása
urlbar-xr-notification-anchor =
    .tooltiptext = A virtuális valóság engedélyek panel megnyitása
urlbar-storage-access-anchor =
    .tooltiptext = Böngészési tevékenység engedélyezési panel megnyitása
urlbar-translate-notification-anchor =
    .tooltiptext = Oldal lefordítása
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Az ablakok vagy képernyő az oldallal megosztásának kezelése
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Kapcsolat nélküli tárolás üzenetpanel megnyitása
urlbar-password-notification-anchor =
    .tooltiptext = Jelszó mentési üzenetpanel megnyitása
urlbar-translated-notification-anchor =
    .tooltiptext = Oldalfordítás kezelése
urlbar-plugins-notification-anchor =
    .tooltiptext = Bővítményhasználat kezelése
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = A kamera és/vagy mikrofon az oldallal megosztásának kezelése
urlbar-autoplay-notification-anchor =
    .tooltiptext = Automatikus lejátszás panel megnyitása
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Adatok tárolása az állandó tárban
urlbar-addons-notification-anchor =
    .tooltiptext = Kiegészítő telepítési üzenetpanel megnyitása
urlbar-tip-help-icon =
    .title = Segítség kérése
urlbar-search-tips-confirm = Rendben, értettem
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Tipp:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Gépeljen kevesebbet, találjon többet: { $engineName } keresés közvetlenül a címsorból.
urlbar-search-tips-redirect-2 = Kezdjen keresni a címsorban, és lássa a { $engineName } javaslatait, valamint a böngészési előzményeit.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Könyvjelzők
urlbar-search-mode-tabs = Lapok
urlbar-search-mode-history = Előzmények

##

urlbar-geolocation-blocked =
    .tooltiptext = Blokkolta a helymeghatározási információkat ezen az oldalon.
urlbar-xr-blocked =
    .tooltiptext = Blokkolta a virtuális valóság eszköz elérését ezen az oldalon.
urlbar-web-notifications-blocked =
    .tooltiptext = Blokkolta az értesítéseket ezen az oldalon.
urlbar-camera-blocked =
    .tooltiptext = Blokkolta a kamerát ezen az oldalon.
urlbar-microphone-blocked =
    .tooltiptext = Blokkolta a mikrofont ezen az oldalon.
urlbar-screen-blocked =
    .tooltiptext = Blokkolta a képernyőmegosztást ezen az oldalon.
urlbar-persistent-storage-blocked =
    .tooltiptext = Blokkolta az állandó adattárolást ezen az oldalon.
urlbar-popup-blocked =
    .tooltiptext = Blokkolta a felugró ablakokat ezen az oldalon.
urlbar-autoplay-media-blocked =
    .tooltiptext = Blokkolta a média automatikus hangos lejátszását ezen az oldalon.
urlbar-canvas-blocked =
    .tooltiptext = Blokkolta a vászonadatok kinyerését ezen az oldalon.
urlbar-midi-blocked =
    .tooltiptext = Blokkolta a MIDI elérést ezen az oldalon.
urlbar-install-blocked =
    .tooltiptext = Blokkolta a kiegészítők telepítését erről az oldalról.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Könyvjelző szerkesztése ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Oldal a könyvjelzők közé ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Hozzáadás a címsávhoz
page-action-manage-extension =
    .label = Kiegészítő kezelése…
page-action-remove-from-urlbar =
    .label = Eltávolítás a címsávból
page-action-remove-extension =
    .label = Kiegészítő eltávolítása

## Auto-hide Context Menu

full-screen-autohide =
    .label = Eszköztárak elrejtése
    .accesskey = E
full-screen-exit =
    .label = Kilépés a teljes képernyős módból
    .accesskey = K

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Ezúttal keressen a következővel:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Keresési beállítások módosítása
search-one-offs-change-settings-compact-button =
    .tooltiptext = Keresési beállítások módosítása
search-one-offs-context-open-new-tab =
    .label = Keresés új lapon
    .accesskey = r
search-one-offs-context-set-as-default =
    .label = Legyen alapértelmezett keresőszolgáltatás
    .accesskey = L
search-one-offs-context-set-as-default-private =
    .label = Beállítás alapértelmezett keresőszolgáltatásként a privát ablakokban
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
    .tooltiptext = Könyvjelzők ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Lapok ({ $restrict })
search-one-offs-history =
    .tooltiptext = Előzmények ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Szerkesztő megjelenítése mentéskor
    .accesskey = e
bookmark-panel-done-button =
    .label = Kész
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = A kapcsolat nem biztonságos
identity-connection-secure = A kapcsolat biztonságos
identity-connection-internal = Ez egy biztonságos { -brand-short-name } oldal.
identity-connection-file = Ez az oldal a számítógépén van tárolva.
identity-extension-page = Ez az oldal kiegészítőből lett betöltve.
identity-active-blocked = A { -brand-short-name } blokkolta az oldal néhány nem biztonságos elemét.
identity-custom-root = A kapcsolatot egy olyan tanúsítványkibocsátó igazolta, amelyet a Mozilla nem ismeri fel.
identity-passive-loaded = A weboldal egyes részei nem biztonságosak (például a képek).
identity-active-loaded = Kikapcsolta a védelmet ezen az oldalon.
identity-weak-encryption = Ez az oldal gyenge titkosítást használ.
identity-insecure-login-forms = Az oldalon megadott bejelentkezési adatok nincsenek biztonságban.
identity-permissions =
    .value = Engedélyek
identity-permissions-reload-hint = Lehet hogy újra kell töltenie az oldalt a változások érvényesítéséhez.
identity-permissions-empty = Nem adott speciális engedélyeket ennek az oldalnak.
identity-clear-site-data =
    .label = Sütik és oldaladatok eltávolítása…
identity-connection-not-secure-security-view = Nem biztonságosan kapcsolódik ehhez az oldalhoz.
identity-connection-verified = Biztonságosan kapcsolódik ehhez az oldalhoz.
identity-ev-owner-label = Tanúsítvány kiállítva ennek:
identity-description-custom-root = A Mozilla nem ismeri fel ezt a tanúsítványkibocsátót. Lehet, hogy az operációs rendszer vagy egy rendszergazda adta hozzá. <label data-l10n-name="link">További tudnivalók</label>
identity-remove-cert-exception =
    .label = Kivétel eltávolítása
    .accesskey = e
identity-description-insecure = A kapcsolat ehhez az oldalhoz nem biztonságos. Az elküldött információkat mások is láthatják (például a jelszavakat, üzeneteket, bankkártya-adatokat stb.).
identity-description-insecure-login-forms = Az oldalon megadott bejelentkezési adatok nincsenek biztonságban és lehallgathatók lehetnek.
identity-description-weak-cipher-intro = A kapcsolat ehhez a weboldalhoz túl gyenge titkosítást használ, és nem biztonságos.
identity-description-weak-cipher-risk = Mások megjeleníthetik információit, vagy módosíthatják a weboldal viselkedését.
identity-description-active-blocked = A { -brand-short-name } blokkolta az oldal néhány nem biztonságos elemét. <label data-l10n-name="link">További tudnivalók</label>
identity-description-passive-loaded = A kapcsolat nem biztonságos, és az oldalnak elküldött információkat mások is láthatják.
identity-description-passive-loaded-insecure = Ez a weboldal nem biztonságos tartalmakat is tartalmaz (például képek). <label data-l10n-name="link">További tudnivalók</label>
identity-description-passive-loaded-mixed = Bár a { -brand-short-name } blokkolt bizonyos tartalmakat, még mindig szerepel olyan tartalom az oldalon, amely nem biztonságos (például képek). <label data-l10n-name="link">További tudnivalók</label>
identity-description-active-loaded = A weboldal nem biztonságos elemeket (például parancsfájlokat) tartalmaz, és a kapcsolat nem biztonságos.
identity-description-active-loaded-insecure = Az oldalnak elküldött információkat mások is láthatják (például a jelszavakat, üzeneteket, bankkártya-adatokat stb.).
identity-learn-more =
    .value = További tudnivalók
identity-disable-mixed-content-blocking =
    .label = Védelem kikapcsolása most
    .accesskey = k
identity-enable-mixed-content-blocking =
    .label = Védelem bekapcsolása
    .accesskey = b
identity-more-info-link-text =
    .label = További tudnivalók

## Window controls

browser-window-minimize-button =
    .tooltiptext = Kis méret
browser-window-maximize-button =
    .tooltiptext = Maximalizálás
browser-window-restore-down-button =
    .tooltiptext = Előző méret
browser-window-close-button =
    .tooltiptext = Bezárás

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Megosztandó kamera:
    .accesskey = k
popup-select-microphone =
    .value = Megosztandó mikrofon:
    .accesskey = M
popup-all-windows-shared = A képernyő minden látható ablaka meg lesz osztva.
popup-screen-sharing-not-now =
    .label = Most nem
    .accesskey = n
popup-screen-sharing-never =
    .label = Soha ne engedélyezze
    .accesskey = S
popup-silence-notifications-checkbox = A { -brand-short-name } értesítéseinek kikapcsolása megosztás közben
popup-silence-notifications-checkbox-warning = A { -brand-short-name } nem fog értesítéseket megjeleníteni megosztás közben.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Ön megosztja a { -brand-short-name }ot. Mások is láthatják, ha új lapra vált.
sharing-warning-screen = Ön megosztja a teljes képernyőjét. Mások is láthatják, ha új lapra vált.
sharing-warning-proceed-to-tab =
    .label = Tovább a laphoz
sharing-warning-disable-for-session =
    .label = Megosztásvédelem kikapcsolása ebben a munkamenetben

## DevTools F12 popup

enable-devtools-popup-description = Az F12 gyorsbillentyű használatához először nyissa meg fejlesztői eszközöket a Webfejlesztő menüben.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Keresés vagy cím
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Keresés vagy cím
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Keresés a weben
    .aria-label = Keresés a(z) { $name } keresővel
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Adja meg a keresési kifejezéseket
    .aria-label = Keresés a(z) { $name } keresővel
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Adja meg a keresési kifejezéseket
    .aria-label = Könyvjelzők keresése
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Adja meg a keresési kifejezéseket
    .aria-label = Előzmények keresése
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Adja meg a keresési kifejezéseket
    .aria-label = Lapok keresése
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Keressen a(z) { $name } keresővel vagy adjon meg egy címet
urlbar-remote-control-notification-anchor =
    .tooltiptext = A böngészőt távolról irányítják
urlbar-permissions-granted =
    .tooltiptext = További engedélyeket adott ennek az oldalnak.
urlbar-switch-to-tab =
    .value = Váltás erre a lapra:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Kiegészítő:
urlbar-go-button =
    .tooltiptext = Ugrás a címmezőben levő címre
urlbar-page-action-button =
    .tooltiptext = Oldalműveletek
urlbar-pocket-button =
    .tooltiptext = Mentés a { -pocket-brand-name }be

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = A(z) <span data-l10n-name="domain">{ $domain }</span> mostantól teljes képernyős
fullscreen-warning-no-domain = A dokumentum mostantól teljes képernyős
fullscreen-exit-button = Kilépés a teljes képernyőből (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Kilépés a teljes képernyőből (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = A következő irányítja az egérmutatót: <span data-l10n-name="domain">{ $domain }</span> . Nyomja meg az Esc gombot az irányítás visszavételéhez.
pointerlock-warning-no-domain = Ez a dokumentum vezérli az egérmutatóját. Nyomja meg az Esc gombot az irányítás visszavételéhez.
