# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - Waterfox
# private - "Waterfox Waterfox (Private Browsing)"
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
# "default" - Waterfox
# "private" - "Waterfox Waterfox — (Private Browsing)"
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
    .tooltiptext = Módosítsa, hogy kaphat-e értesítéseket ettől az oldaltól
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
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Egyéb hangszórók az oldallal történő megosztásának kezelése
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
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Válassza ezt a rövidítést, hogy gyorsabban megtalálja, amire szüksége van.

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

page-action-manage-extension =
    .label = Kiegészítő kezelése…
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

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Ezúttal keressen a következővel:
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
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = „{ $engineName }” hozzáadása
    .tooltiptext = „{ $engineName }” keresőszolgáltatás hozzáadása
    .aria-label = „{ $engineName }” keresőszolgáltatás hozzáadása
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Keresőszolgáltatás hozzáadása

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

bookmarks-add-bookmark = Könyvjelző hozzáadása
bookmarks-edit-bookmark = Könyvjelző szerkesztése
bookmark-panel-cancel =
    .label = Mégse
    .accesskey = M
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Könyvjelző törlése
           *[other] { $count } könyvjelző törlése
        }
    .accesskey = t
bookmark-panel-show-editor-checkbox =
    .label = Szerkesztő megjelenítése mentéskor
    .accesskey = e
bookmark-panel-save-button =
    .label = Mentés
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Oldalinformációk erről: { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = A(z) { $host } kapcsolatának biztonsága
identity-connection-not-secure = A kapcsolat nem biztonságos
identity-connection-secure = A kapcsolat biztonságos
identity-connection-failure = Kapcsolódási hiba
identity-connection-internal = Ez egy biztonságos { -brand-short-name } oldal.
identity-connection-file = Ez az oldal a számítógépén van tárolva.
identity-extension-page = Ez az oldal kiegészítőből lett betöltve.
identity-active-blocked = A { -brand-short-name } blokkolta az oldal néhány nem biztonságos elemét.
identity-custom-root = A kapcsolatot egy olyan tanúsítványkibocsátó igazolta, amelyet a Waterfox nem ismeri fel.
identity-passive-loaded = A weboldal egyes részei nem biztonságosak (például a képek).
identity-active-loaded = Kikapcsolta a védelmet ezen az oldalon.
identity-weak-encryption = Ez az oldal gyenge titkosítást használ.
identity-insecure-login-forms = Az oldalon megadott bejelentkezési adatok nincsenek biztonságban.
identity-https-only-connection-upgraded = (frissítve HTTPS-re)
identity-https-only-label = Csak HTTPS mód
identity-https-only-dropdown-on =
    .label = Be
identity-https-only-dropdown-off =
    .label = Ki
identity-https-only-dropdown-off-temporarily =
    .label = Ideiglenesen ki
identity-https-only-info-turn-on2 = Kapcsolja be a Csak HTTPS módot ezen az oldalon, ha azt akarja, hogy a { -brand-short-name } frissítse a kapcsolatot, ha lehetséges.
identity-https-only-info-turn-off2 = Ha az oldal nem megfelelően működik, lehet ki kell kapcsolnia a Csak HTTPS módot az oldalon, hogy nem biztonságos HTTP-vel töltse újra.
identity-https-only-info-no-upgrade = Nem lehet frissíteni a kapcsolatot HTTP-ről.
identity-permissions-storage-access-header = Webhelyek közötti sütik
identity-permissions-storage-access-hint = Ezek a felek használhatják a webhelyek közötti sütiket és a webhely adatait, amíg Ön ezen a webhelyen tartózkodik.
identity-permissions-storage-access-learn-more = További tudnivalók
identity-permissions-reload-hint = Lehet hogy újra kell töltenie az oldalt a változások érvényesítéséhez.
identity-clear-site-data =
    .label = Sütik és oldaladatok eltávolítása…
identity-connection-not-secure-security-view = Nem biztonságosan kapcsolódik ehhez az oldalhoz.
identity-connection-verified = Biztonságosan kapcsolódik ehhez az oldalhoz.
identity-ev-owner-label = Tanúsítvány kiállítva ennek:
identity-description-custom-root = A Waterfox nem ismeri fel ezt a tanúsítványkibocsátót. Lehet, hogy az operációs rendszer vagy egy rendszergazda adta hozzá. <label data-l10n-name="link">További tudnivalók</label>
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

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = LEJÁTSZÁS
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = NÉMÍTVA
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = AUTOMATIKUS LEJÁTSZÁS BLOKKOLVA
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = KÉP A KÉPBEN

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] LAP NÉMÍTÁSA
        [one] LAP NÉMÍTÁSA
       *[other] { $count } LAP NÉMÍTÁSA
    }
browser-tab-unmute =
    { $count ->
        [1] LAP VISSZAHANGOSÍTÁSA
        [one] LAP VISSZAHANGOSÍTÁSA
       *[other] { $count } LAP VISSZAHANGOSÍTÁSA
    }
browser-tab-unblock =
    { $count ->
        [1] LAP LEJÁTSZÁSA
        [one] LAP LEJÁTSZÁSA
       *[other] { $count } LAP LEJÁTSZÁSA
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Könyvjelzők importálása…
    .tooltiptext = Könyvjelzők importálása egy másik böngészőből a { -brand-short-name }ba…
bookmarks-toolbar-empty-message = A gyors eléréshez a könyvjelzők ide helyezhetők, a könyvjelzők eszköztárra. <a data-l10n-name="manage-bookmarks">Könyvjelzők kezelése…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Kamera:
    .accesskey = K
popup-select-camera-icon =
    .tooltiptext = Kamera
popup-select-microphone-device =
    .value = Mikrofon:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Mikrofon
popup-select-speaker-icon =
    .tooltiptext = Hangeszközök
popup-all-windows-shared = A képernyő minden látható ablaka meg lesz osztva.
popup-screen-sharing-block =
    .label = Tiltás
    .accesskey = T
popup-screen-sharing-always-block =
    .label = Tiltás mindig
    .accesskey = i
popup-mute-notifications-checkbox = Webhely értesítéseinek elnémítása megosztás közben

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
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = A böngésző távvezérlés alatt áll (ok: { $component })
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

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = { $engine } keresés egy privát ablakban
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Keresés egy privát ablakban
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = { $engine } keresés
urlbar-result-action-sponsored = Szponzorált
urlbar-result-action-switch-tab = Váltás erre a lapra
urlbar-result-action-visit = Keresse fel:
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Nyomja meg a Tabot, hogy a következővel keressen: { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Nyomja meg a Tabot, hogy a következővel keressen: { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Keresés a(z) { $engine } segítségével közvetlenül a címsorból
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Keresés a(z) { $engine } webhelyen közvetlenül a címsorból
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Másolás
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Könyvjelzők keresése
urlbar-result-action-search-history = Előzmények keresése
urlbar-result-action-search-tabs = Lapok keresése

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = { $engine } javaslatok

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

## Subframe crash notification

crashed-subframe-message = <strong>Az oldal egy része összeomlott.</strong> Küldjön egy jelentést a { -brand-product-name } fejlesztőinek, hogy gyorsabban elháríthassák a problémát.
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Az oldal egy része összeomlott. Küldjön egy jelentést a { -brand-product-name } fejlesztőinek, hogy gyorsabban elháríthassák a problémát.
crashed-subframe-learnmore-link =
    .value = További tudnivalók
crashed-subframe-submit =
    .label = Jelentés beküldése
    .accesskey = b

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Könyvjelzők kezelése
bookmarks-recent-bookmarks-panel-subheader = Friss könyvjelzők
bookmarks-toolbar-chevron =
    .tooltiptext = További könyvjelzők megjelenítése
bookmarks-sidebar-content =
    .aria-label = Könyvjelzők
bookmarks-menu-button =
    .label = Könyvjelzők menü
bookmarks-other-bookmarks-menu =
    .label = Más könyvjelzők
bookmarks-mobile-bookmarks-menu =
    .label = Mobil könyvjelzők
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Könyvjelzők oldalsáv elrejtése
           *[other] Könyvjelzők oldalsáv megjelenítése
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Könyvjelző eszköztár elrejtése
           *[other] Könyvjelző eszköztár megjelenítése
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Könyvjelző eszköztár elrejtése
           *[other] Könyvjelző eszköztár megjelenítése
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Könyvjelzők menü eltávolítása az eszköztárról
           *[other] Könyvjelzők menü hozzáadása az eszköztárhoz
        }
bookmarks-search =
    .label = Könyvjelzők keresése
bookmarks-tools =
    .label = Könyvjelzőzési eszközök
bookmarks-bookmark-edit-panel =
    .label = Könyvjelző szerkesztése
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Könyvjelző eszköztár
    .accesskey = K
    .aria-label = Könyvjelzők
bookmarks-toolbar-menu =
    .label = Könyvjelző eszköztár
bookmarks-toolbar-placeholder =
    .title = Könyvjelző eszköztár elemei
bookmarks-toolbar-placeholder-button =
    .label = Könyvjelző eszköztár elemei
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = Jelenlegi lap könyvjelzőzése

## Library Panel items

library-bookmarks-menu =
    .label = Könyvjelzők
library-recent-activity-title =
    .value = Friss tevékenység

## Pocket toolbar button

save-to-pocket-button =
    .label = Mentés a { -pocket-brand-name }be
    .tooltiptext = Mentés a { -pocket-brand-name }be

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Szövegkódolás javítása
    .tooltiptext = A szöveg kódolásának kitalálása az oldal tartalma alapján

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = Kiegészítők és témák
    .tooltiptext = Kiegészítők és témák kezelése ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Beállítások
    .tooltiptext =
        { PLATFORM() ->
            [macos] Beállítások megnyitása ({ $shortcut })
           *[other] Beállítások megnyitása
        }

## More items

more-menu-go-offline =
    .label = Kapcsolat nélküli munka
    .accesskey = p
toolbar-overflow-customize-button =
    .label = Eszköztár testreszabása…
    .accesskey = E
toolbar-button-email-link =
    .label = Hivatkozás küldése
    .tooltiptext = Az oldalra mutató hivatkozás küldése e-mailben
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Oldal mentése
    .tooltiptext = Oldal mentése ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Fájl megnyitása
    .tooltiptext = Fájl megnyitása ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Szinkronizált lapok
    .tooltiptext = Lapok megjelenítése más készülékekről
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Új privát ablak
    .tooltiptext = Új privát ablak megnyitása ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = A weboldal egyes hangjai vagy videói DRM szoftvert használnak, ami korlátozhatja, hogy a { -brand-short-name } ezekkel kapcsolatban mit engedélyezhet Önnek.
eme-notifications-drm-content-playing-manage = Beállítások kezelése
eme-notifications-drm-content-playing-manage-accesskey = k
eme-notifications-drm-content-playing-dismiss = Elvetés
eme-notifications-drm-content-playing-dismiss-accesskey = E

## Password save/update panel

panel-save-update-username = Felhasználónév
panel-save-update-password = Jelszó

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Eltávoltja a következőt: { $name }?
addon-removal-abuse-report-checkbox = A kiegészítő jelentése a { -vendor-short-name } felé

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = Fiók kezelése
remote-tabs-sync-now = Szinkronizálás most

##

# "More" item in macOS share menu
menu-share-more =
    .label = Továbbiak…
ui-tour-info-panel-close =
    .tooltiptext = Bezárás

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Felugró ablakok engedélyezése innen: { $uriHost }
    .accesskey = m
popups-infobar-block =
    .label = Felugró ablakok tiltása innen: { $uriHost }
    .accesskey = m

##

popups-infobar-dont-show-message =
    .label = Ne jelenjen meg ez az üzenet a felugró ablakok blokkolásakor.
    .accesskey = n
edit-popup-settings =
    .label = Felugró ablakok beállításainak kezelése…
    .accesskey = k
picture-in-picture-hide-toggle =
    .label = Kép a képben kapcsoló elrejtése
    .accesskey = r

# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Navigáció
navbar-downloads =
    .label = Letöltések
navbar-overflow =
    .tooltiptext = További eszközök…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Nyomtatás
    .tooltiptext = Oldal kinyomtatása… ({ $shortcut })
navbar-print-tab-modal-disabled =
    .label = Nyomtatás
    .tooltiptext = Oldal kinyomtatása
navbar-home =
    .label = Kezdőlap
    .tooltiptext = { -brand-short-name } kezdőoldal
navbar-library =
    .label = Könyvtár
    .tooltiptext = Előzmények, mentett könyvjelzők megtekintése
navbar-search =
    .title = Keresés
navbar-accessibility-indicator =
    .tooltiptext = Akadálymentesítési funkciók engedélyezve
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Böngészőlapok
tabs-toolbar-new-tab =
    .label = Új lap
tabs-toolbar-list-all-tabs =
    .label = Minden lap felsorolása
    .tooltiptext = Minden lap felsorolása

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Megnyitná az előző lapokat?</strong> Visszaállíthatja az előző munkamenetét a { -brand-short-name } alkalmazásmenüben <img data-l10n-name="icon"/>, az Előzmények alatt.
restore-session-startup-suggestion-button = Mutassa meg hogyan
