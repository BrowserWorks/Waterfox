# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = „Do Not Track” jelzés küldése a webhelyeknek, jelezve, hogy nem szeretné, hogy kövessék
do-not-track-learn-more = További információk
do-not-track-option-default-content-blocking-known =
    .label = Csak akkor, ha a { -brand-short-name } az ismert követők blokkolására van állítva
do-not-track-option-always =
    .label = Mindig
pref-page-title =
    { PLATFORM() ->
        [windows] Beállítások
       *[other] Beállítások
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Keresés a beállításokban
           *[other] Keresés a beállításokban
        }
settings-page-title = Beállítások
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = Keresés a Beállításokban
managed-notice = A böngészőjét a szervezete kezeli.
category-list =
    .aria-label = Kategóriák
pane-general-title = Általános
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Kezdőlap
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Keresés
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Adatvédelem és biztonság
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-sync-title3 = Szinkronizálás
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = { -brand-short-name } kísérletek
category-experimental =
    .tooltiptext = { -brand-short-name } kísérletek
pane-experimental-subtitle = Óvatosan haladjon tovább
pane-experimental-search-results-header = { -brand-short-name }-kísérletek: Óvatosan menjen tovább
pane-experimental-description2 = A speciális beállítások megváltoztatása befolyásolhatja a { -brand-short-name } teljesítményét vagy biztonságát.
pane-experimental-reset =
    .label = Alapértelmezések visszaállítása
    .accesskey = v
help-button-label = { -brand-short-name } támogatás
addons-button-label = Kiegészítők és témák
focus-search =
    .key = f
close-button =
    .aria-label = Bezárás

## Browser Restart Dialog

feature-enable-requires-restart = A funkció bekapcsolásához a { -brand-short-name } újraindítása szükséges.
feature-disable-requires-restart = A funkció kikapcsolásához a { -brand-short-name } újraindítása szükséges.
should-restart-title = { -brand-short-name } újraindítása
should-restart-ok = { -brand-short-name } újraindítása most
cancel-no-restart-button = Mégse
restart-later = Újraindítás később

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = Egy kiegészítő, a(z) <img data-l10n-name="icon"/> { $name }, vezérli a kezdőoldalt.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Egy kiegészítő, a(z) <img data-l10n-name="icon"/> { $name }, vezérli az Új lap oldalt.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Egy kiegészítő, a(z) <img data-l10n-name="icon"/>{ $name }, vezérli ezt a beállítást.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Egy kiegészítő, a(z) <img data-l10n-name="icon"/> { $name } vezérli ezt a beállítást.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Egy kiegészítő, a(z) <img data-l10n-name="icon"/> { $name }, beállította az alapértelmezett keresőszolgáltatást.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = A(z) <img data-l10n-name="icon"/> { $name } kiterjesztéshez szükségesek a konténerlapok.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Egy kiegészítő, a(z) <img data-l10n-name="icon"/>{ $name }, vezérli ezt a beállítást.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = A(z) <img data-l10n-name="icon"/> { $name } kiegészítő vezérli, hogy a { -brand-short-name } hogy kapcsolódik az internethez
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = A kiegészítő engedélyezéséhez ugorjon a <img data-l10n-name="addons-icon"/> Kiegészítőkhöz a <img data-l10n-name="menu-icon"/> menüben.

## Preferences UI Search Results

search-results-header = Találatok
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Elnézését, nincs találat a Beállítások közt erre: „<span data-l10n-name="query"></span>”.
       *[other] Elnézését, nincs találat a Beállítások közt erre: „<span data-l10n-name="query"></span>”.
    }
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Elnézését, nincs találat a Beállítások közt erre: „<span data-l10n-name="query"></span>”.
search-results-help-link = Segítségre van szüksége? Látogasson el ide: <a data-l10n-name="url">{ -brand-short-name } támogatás</a>

## General Section

startup-header = Indítás
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = A { -brand-short-name } és a Firefox futhat egyszerre
use-firefox-sync = Tipp: Ez külön profilokat használ. A { -sync-brand-short-name } segítségével adatokat oszthat meg közöttük.
get-started-not-logged-in = Bejelentkezés a { -sync-brand-short-name }be
get-started-configured = A { -sync-brand-short-name } beállításainak megnyitása
always-check-default =
    .label = Mindig ellenőrizze, hogy a { -brand-short-name }-e az alapértelmezett böngésző
    .accesskey = M
is-default = Jelenleg a { -brand-short-name } az alapértelmezett böngésző.
is-not-default = A { -brand-short-name } nem az alapértelmezett böngésző
set-as-my-default-browser =
    .label = Beállítás alapértelmezettként…
    .accesskey = a
startup-restore-previous-session =
    .label = Előző munkamenet helyreállítása
    .accesskey = h
startup-restore-warn-on-quit =
    .label = Figyelmeztetés, amikor kilép a böngészőből
disable-extension =
    .label = Kiegészítő letiltása
tabs-group-header = Lapok
ctrl-tab-recently-used-order =
    .label = A Ctrl+Tab a legutóbbi használat sorrendjében lépked körbe a lapokon
    .accesskey = T
open-new-link-as-tabs =
    .label = Hivatkozások megnyitása új lapon, az új ablak helyett
    .accesskey = l
warn-on-close-multiple-tabs =
    .label = Figyelmeztetés több lap bezárása előtt
    .accesskey = t
warn-on-open-many-tabs =
    .label = Figyelmeztetés, hogy több lap megnyitása lelassíthatja a { -brand-short-name } programot
    .accesskey = F
switch-links-to-new-tabs =
    .label = Hivatkozás új lapon való megnyitásakor átváltás rá azonnal
    .accesskey = H
switch-to-new-tabs =
    .label = Hivatkozás, kép vagy média új lapon való megnyitásakor átváltás rá azonnal
    .accesskey = H
show-tabs-in-taskbar =
    .label = Lapok előnézetének megjelenítése a Windows tálcán
    .accesskey = L
browser-containers-enabled =
    .label = Konténer lapok engedélyezése
    .accesskey = n
browser-containers-learn-more = További tudnivalók
browser-containers-settings =
    .label = Beállítások…
    .accesskey = B
containers-disable-alert-title = Az összes konténerlap bezárása?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Ha most letiltja a konténerlapokat, akkor { $tabCount } konténerlap bezáródik. Biztosan letiltja a konténerlapokat?
       *[other] Ha most letiltja a konténerlapokat, akkor { $tabCount } konténerlap bezáródik. Biztosan letiltja a konténerlapokat?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } konténerlap bezárása
       *[other] { $tabCount } konténerlap bezárása
    }
containers-disable-alert-cancel-button = Maradjon engedélyezve
containers-remove-alert-title = Eltávolítja ezt a konténert?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Ha most eltávolítja ezt a konténerlapot, akkor { $count } konténerlap bezáródik. Biztosan eltávolítja ezt a konténert?
       *[other] Ha most eltávolítja ezt a konténerlapot, akkor { $count } konténerlap bezáródik. Biztosan eltávolítja ezt a konténert?
    }
containers-remove-ok-button = Konténer eltávolítása
containers-remove-cancel-button = Ne távolítsa el a konténert

## General Section - Language & Appearance

language-and-appearance-header = Nyelv és megjelenés
fonts-and-colors-header = Betűk és színek
default-font = Alapértelmezett betűkészlet
    .accesskey = A
default-font-size = Méret
    .accesskey = M
advanced-fonts =
    .label = Speciális…
    .accesskey = c
colors-settings =
    .label = Színek…
    .accesskey = z
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Nagyítás
preferences-default-zoom = Alapértelmezett nagyítás
    .accesskey = n
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Csak a szöveg nagyítása
    .accesskey = v
language-header = Nyelv
choose-language-description = Az oldalak megjelenítésére előnyben részesített nyelv megadása
choose-button =
    .label = Tallózás…
    .accesskey = T
choose-browser-language-description = Válassza ki a { -brand-short-name }ban megjelenített menük, üzenetek és értesítések nyelvét.
manage-browser-languages-button =
    .label = Alternatívák beállítása…
    .accesskey = A
confirm-browser-language-change-description = A { -brand-short-name } újraindítása a változtatások alkalmazásához
confirm-browser-language-change-button = Alkalmaz és újraindítás
translate-web-pages =
    .label = Webtartalom fordítása
    .accesskey = f
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Fordítás: <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Kivételek…
    .accesskey = K
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Az operációs rendszer beállításainak használata a(z) „{ $localeName }” területi beállításhoz a dátumok, idők, számok és mértékegységek beállításához.
check-user-spelling =
    .label = Helyesírás-ellenőrzés beírás közben
    .accesskey = H

## General Section - Files and Applications

files-and-applications-title = Fájlok és alkalmazások
download-header = Letöltések
download-save-to =
    .label = Fájlok mentése
    .accesskey = m
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Tallózás…
           *[other] Tallózás…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] T
           *[other] T
        }
download-always-ask-where =
    .label = Mindig kérdezzen rá a fájlok letöltési helyére
    .accesskey = r
applications-header = Alkalmazások
applications-description = Válassza ki, hogy a { -brand-short-name } hogyan kezelje az internetről letöltött fájlokat vagy a böngészéskor használt alkalmazásokat.
applications-filter =
    .placeholder = Fájltípusok vagy alkalmazások keresése
applications-type-column =
    .label = Tartalomtípus
    .accesskey = T
applications-action-column =
    .label = Művelet
    .accesskey = M
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } fájl
applications-action-save =
    .label = Fájl mentése
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } használata
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } használata (alapértelmezett)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Használja a macOS alapértelmezett alkalmazását
            [windows] Használja a Windows alapértelmezett alkalmazását
           *[other] Használja a rendszer alapértelmezett alkalmazását
        }
applications-use-other =
    .label = Másik használata…
applications-select-helper = Segédalkalmazás kiválasztása
applications-manage-app =
    .label = Alkalmazás részletei…
applications-always-ask =
    .label = Rákérdezés mindig
applications-type-pdf = Hordozható dokumentumformátum (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = { $plugin-name } használata ({ -brand-short-name } böngészőben)
applications-open-inapp =
    .label = Megnyitás a { -brand-short-name }ban

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = Digitális jogkezelést (DRM) használó tartalom
play-drm-content =
    .label = DRM-vezérelt tartalom lejátszása
    .accesskey = l
play-drm-content-learn-more = További tudnivalók
update-application-title = { -brand-short-name } frissítések
update-application-description = Tartsa naprakészen a { -brand-short-name }ot a legjobb teljesítmény, stabilitás és biztonság érdekében.
update-application-version = Verzió{ $version } <a data-l10n-name="learn-more">Újdonságok</a>
update-history =
    .label = Frissítési előzmények megjelenítése…
    .accesskey = z
update-application-allow-description = A következők engedélyezése a { -brand-short-name }nak:
update-application-auto =
    .label = Frissítések automatikus telepítése (ajánlott)
    .accesskey = A
update-application-check-choose =
    .label = Frissítések keresése, de a telepítés jóváhagyással történik
    .accesskey = k
update-application-manual =
    .label = Ne legyen frissítve (nem ajánlott)
    .accesskey = N
update-application-background-enabled =
    .label = Ha nem fut a { -brand-short-name }
    .accesskey = H
update-application-warning-cross-user-setting = Ez a beállítás érvényes az összes Windows fiókra és { -brand-short-name } profilra, amely ezt a { -brand-short-name } telepítést használja.
update-application-use-service =
    .label = Háttérben futó szolgáltatás intézze a frissítést
    .accesskey = H
update-setting-write-failure-title = Hiba történt a Frissítési beállításainak mentésekor
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    A { -brand-short-name } hibát észlelt, és nem mentette ezt a változtatást. Ne feledje, hogy ezen frissítési beállítás megadásához írási engedély szükségesen a lenti fájlon. Ön vagy a rendszergazdája megoldhatja a hibát azzal, hogy a Felhasználók csoportnak teljes jogosultságot ad a fájlhoz.
    
    Nem sikerült a fájlba írni: { $path }
update-setting-write-failure-title2 = Hiba történt a Frissítési beállítások mentésekor
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    A { -brand-short-name } hibát észlelt, és nem mentette ezt a változtatást. Ne feledje, hogy ezen frissítési beállítás megadásához írási engedély szükségesen a lenti fájlon. Ön vagy a rendszergazdája megoldhatja a hibát azzal, hogy a Felhasználók csoportnak teljes jogosultságot ad a fájlhoz.
    
    Nem sikerült a fájlba írni: { $path }
update-in-progress-title = Frissítés folyamatban
update-in-progress-message = Szeretné, hogy a { -brand-short-name } folytassa ezt a frissítést?
update-in-progress-ok-button = &Elvetés
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Folytatás

## General Section - Performance

performance-title = Teljesítmény
performance-use-recommended-settings-checkbox =
    .label = Javasolt teljesítménybeállítások használata
    .accesskey = h
performance-use-recommended-settings-desc = Ezek a beállítások a számítógép hardveréhez és operációs rendszeréhez lettek szabva.
performance-settings-learn-more = További tudnivalók
performance-allow-hw-accel =
    .label = Hardveres gyorsítás használata, ha lehetséges
    .accesskey = r
performance-limit-content-process-option = Tartalom folyamatok korlátja
    .accesskey = k
performance-limit-content-process-enabled-desc = A további tartalom folyamatok növelhetik a teljesítményt, ha több lapot használ, de több memóriát is használnak.
performance-limit-content-process-blocked-desc = A tartalom folyamatok számának módosítása csak többfolyamatos { -brand-short-name } esetén lehetséges. <a data-l10n-name="learn-more">Ismerje meg, hogyan lehet ellenőrizni, hogy a többfolyamatos működés engedélyezve van-e</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (alapértelmezett)

## General Section - Browsing

browsing-title = Böngészés
browsing-use-autoscroll =
    .label = Automatikus görgetés
    .accesskey = u
browsing-use-smooth-scrolling =
    .label = Finom görgetés
    .accesskey = F
browsing-use-onscreen-keyboard =
    .label = Érintőbillentyűzet megjelenítése, ha szükséges
    .accesskey = r
browsing-use-cursor-navigation =
    .label = Kurzorbillentyűk használata az oldalon belüli navigációhoz
    .accesskey = c
browsing-search-on-start-typing =
    .label = Szöveg keresése a keresett szó beírásának elkezdésétől
    .accesskey = d
browsing-picture-in-picture-toggle-enabled =
    .label = Engedélyezze a kép a képben videóvezérlést
    .accesskey = E
browsing-picture-in-picture-learn-more = További tudnivalók
browsing-media-control =
    .label = Média vezérlése billentyűzeten, fejhallgatón vagy virtuális felületen keresztül
    .accesskey = v
browsing-media-control-learn-more = További tudnivalók
browsing-cfr-recommendations =
    .label = Kiegészítők ajánlása böngészés közben
    .accesskey = K
browsing-cfr-features =
    .label = Funkciójavaslatok böngészés közben
    .accesskey = F
browsing-cfr-recommendations-learn-more = További tudnivalók

## General Section - Proxy

network-settings-title = Hálózati beállítások
network-proxy-connection-description = Állítsa be, hogy a { -brand-short-name } hogyan kapcsolódik az internethez.
network-proxy-connection-learn-more = További tudnivalók
network-proxy-connection-settings =
    .label = Beállítások…
    .accesskey = B

## Home Section

home-new-windows-tabs-header = Új ablakok és lapok
home-new-windows-tabs-description2 = Válasszon hogy mit lásson, ha megnyitja a kezdőoldalt, vagy egy új ablakot, lapot.

## Home Section - Home Page Customization

home-homepage-mode-label = Kezdőlap és új ablakok
home-newtabs-mode-label = Új lapok
home-restore-defaults =
    .label = Alapértelmezések visszaállítása
    .accesskey = A
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Firefox kezdőlap (alapértelmezett)
home-mode-choice-custom =
    .label = Egyéni URL-ek…
home-mode-choice-blank =
    .label = Üres lap
home-homepage-custom-url =
    .placeholder = Illesszen be egy URL-t…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Aktuális oldal használata
           *[other] Aktuális oldalak használata
        }
    .accesskey = A
choose-bookmark =
    .label = Könyvjelző használata…
    .accesskey = n

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Firefox kezdőlap tartalma
home-prefs-content-description = Válassza ki milyen tartalmat szeretne a Firefox kezdőlapon.
home-prefs-search-header =
    .label = Webes keresés
home-prefs-topsites-header =
    .label = Népszerű oldalak
home-prefs-topsites-description = A leggyakrabban látogatott oldalak
home-prefs-topsites-by-option-sponsored =
    .label = Szponzorált legjobb oldalak
home-prefs-shortcuts-header =
    .label = Gyorskeresők
home-prefs-shortcuts-description = Mentett vagy felkeresett webhelyek
home-prefs-shortcuts-by-option-sponsored =
    .label = Szponzorált gyorskeresők

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = A(z) { $provider } ajánlásával
home-prefs-recommended-by-description-update = Kivételes tartalom szerte az internetről, a { $provider } válogatásában
home-prefs-recommended-by-description-new = Kivételes tartalmak a { $provider } válogatásában, amely a { -brand-product-name } család része

##

home-prefs-recommended-by-learn-more = Hogyan működik
home-prefs-recommended-by-option-sponsored-stories =
    .label = Szponzorált történetek
home-prefs-highlights-header =
    .label = Kiemelések
home-prefs-highlights-description = Válogatás azon oldalakból, amelyeket elmentett vagy felkeresett
home-prefs-highlights-option-visited-pages =
    .label = Látogatott oldalak
home-prefs-highlights-options-bookmarks =
    .label = Könyvjelzők
home-prefs-highlights-option-most-recent-download =
    .label = Legutóbbi letöltés
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name }be mentett lapok
home-prefs-recent-activity-header =
    .label = Legutóbbi tevékenység
home-prefs-recent-activity-description = Válogatás a legutóbbi webhelyekből és tartalmakból
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Töredékek
home-prefs-snippets-description = Hírek a { -vendor-short-name } és a { -brand-product-name } felől
home-prefs-snippets-description-new = Tippek és hírek a { -vendor-short-name } és a { -brand-product-name } felől
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } sor
           *[other] { $num } sor
        }

## Search Section

search-bar-header = Keresősáv
search-bar-hidden =
    .label = Használja a címsávot a kereséshez és a navigációhoz
search-bar-shown =
    .label = Keresősáv hozzáadása az eszköztárhoz
search-engine-default-header = Alapértelmezett keresőszolgáltatás
search-engine-default-desc-2 = Ez az alapértelmezett keresőszolgáltatás a cím- és keresősávban. Bármikor átválthatja.
search-engine-default-private-desc-2 = Válasszon egy másik keresőszolgáltatást kizárólag a privát ablakokhoz
search-separate-default-engine =
    .label = E keresőszolgáltatás használata a privát ablakokban
    .accesskey = h
search-suggestions-header = Keresési javaslatok
search-suggestions-desc = Válassza ki, hogyan jelenjenek meg a keresőszolgáltatások javaslatai.
search-suggestions-option =
    .label = Keresési javaslatok
    .accesskey = K
search-show-suggestions-url-bar-option =
    .label = Keresési javaslatok megjelenítése a címsáv találataiban
    .accesskey = K
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Keresési javaslatok megjelenítése a böngészési előzmények előtt a címsor találatai között
search-show-suggestions-private-windows =
    .label = Keresési javaslatok megjelenítése a privát ablakokban
suggestions-addressbar-settings-generic = Címsávjavaslatok beállításainak módosítása
suggestions-addressbar-settings-generic2 = Címsávjavaslatok beállításainak módosítása
search-suggestions-cant-show = A keresési javaslatok nem jelennek meg a címsáv találatai között, mert a { -brand-short-name } nem jegyzi meg az előzményeket.
search-one-click-header = Egy kattintásos keresőszolgáltatások
search-one-click-header2 = Keresési gyorsparancsok
search-one-click-desc = Válassza ki a címsáv alatt és a keresősávban gépeléskor megjelenő alternatív keresőszolgáltatatásokat.
search-choose-engine-column =
    .label = Keresőszolgáltatás
search-choose-keyword-column =
    .label = Kulcsszó
search-restore-default =
    .label = Alapértelmezett keresőszolgáltatások visszaállítása
    .accesskey = v
search-remove-engine =
    .label = Eltávolítás
    .accesskey = E
search-add-engine =
    .label = Hozzáadás
    .accesskey = a
search-find-more-link = További keresőszolgáltatások felvétele
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Duplikált kulcsszó
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Olyan kulcsszót választott, amelyet jelenleg „{ $name }” használ. Válasszon másikat.
search-keyword-warning-bookmark = Olyan kulcsszót választott, amelyet jelenleg egy könyvjelző használ. Válasszon másikat.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Vissza a Beállításokhoz
           *[other] Vissza a Beállításokhoz
        }
containers-back-button2 =
    .aria-label = Vissza a Beállításokhoz
containers-header = Konténer lapok
containers-add-button =
    .label = Új konténer hozzáadása
    .accesskey = a
containers-new-tab-check =
    .label = Konténer kiválasztása minden új laphoz
    .accesskey = K
containers-preferences-button =
    .label = Beállítások
containers-settings-button =
    .label = Beállítások
containers-remove-button =
    .label = Eltávolítás

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Vigye magával a webet
sync-signedout-description = Szinkronizálja könyvjelzőit, előzményeit, lapjait, jelszavait, kiegészítőit és beállításait minden eszközén.
sync-signedout-account-signin2 =
    .label = Bejelentkezés a { -sync-brand-short-name }be…
    .accesskey = j
sync-signedout-description2 = Szinkronizálja könyvjelzőit, előzményeit, lapjait, jelszavait, kiegészítőit és beállításait minden eszközén.
sync-signedout-account-signin3 =
    .label = Jelentkezzen be a szinkronizáláshoz…
    .accesskey = J
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Töltse le a Firefox for <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> vagy <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> appot a mobileszközével való szinkronizáláshoz.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Profilkép módosítása
sync-sign-out =
    .label = Kijelentkezés…
    .accesskey = K
sync-manage-account = Fiók kezelése
    .accesskey = F
sync-signedin-unverified = A(z)  { $email } cím nincs ellenőrizve.
sync-signedin-login-failure = Jelentkezzen be  { $email } újracsatlakoztatásához
sync-resend-verification =
    .label = Ellenőrző e-mail újraküldése
    .accesskey = k
sync-remove-account =
    .label = Fiók eltávolítása
    .accesskey = t
sync-sign-in =
    .label = Bejelentkezés
    .accesskey = B

## Sync section - enabling or disabling sync.

prefs-syncing-on = Szinkronizálás: BE
prefs-syncing-off = Szinkronizálás: KI
prefs-sync-setup =
    .label = { -sync-brand-short-name } beállítása…
    .accesskey = S
prefs-sync-offer-setup-label = Szinkronizálja könyvjelzőit, előzményeit, lapjait, jelszavait, kiegészítőit és beállításait minden eszközén.
prefs-sync-turn-on-syncing =
    .label = Szinkronizálás bekapcsolása…
    .accesskey = S
prefs-sync-offer-setup-label2 = Szinkronizálja könyvjelzőit, előzményeit, lapjait, jelszavait, kiegészítőit és beállításait minden eszközén.
prefs-sync-now =
    .labelnotsyncing = Szinkronizálás most
    .accesskeynotsyncing = m
    .labelsyncing = Szinkronizálás…

## The list of things currently syncing.

sync-currently-syncing-heading = Jelenleg szinkronizálja ezeket az elemeket:
sync-currently-syncing-bookmarks = Könyvjelzők
sync-currently-syncing-history = Előzmények
sync-currently-syncing-tabs = Nyitott lapok
sync-currently-syncing-logins-passwords = Bejelentkezések és jelszavak
sync-currently-syncing-addresses = Címek
sync-currently-syncing-creditcards = Bankkártyák
sync-currently-syncing-addons = Kiegészítők
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Beállítások
       *[other] Beállítások
    }
sync-currently-syncing-settings = Beállítások
sync-change-options =
    .label = Módosítás…
    .accesskey = M

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Válassza ki, mit szeretne szinkronizálni
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Módosítások mentése
    .buttonaccesskeyaccept = m
    .buttonlabelextra2 = Kapcsolat bontása…
    .buttonaccesskeyextra2 = b
sync-engine-bookmarks =
    .label = Könyvjelzők
    .accesskey = K
sync-engine-history =
    .label = Előzmények
    .accesskey = E
sync-engine-tabs =
    .label = Nyitott lapok
    .tooltiptext = Lista arról, hogy mi van nyitva a szinkronizált eszközökön
    .accesskey = L
sync-engine-logins-passwords =
    .label = Bejelentkezések és jelszavak
    .tooltiptext = Az Ön által mentett bejelentkezések és jelszavak
    .accesskey = j
sync-engine-addresses =
    .label = Címek
    .tooltiptext = Mentett postai címek (csak asztali gépen)
    .accesskey = e
sync-engine-creditcards =
    .label = Bankkártyák
    .tooltiptext = Nevek, számok és lejárati dátumok (csak asztali gépen)
    .accesskey = B
sync-engine-addons =
    .label = Kiegészítők
    .tooltiptext = Kiegészítők és témák az asztali Firefoxhoz
    .accesskey = K
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Beállítások
           *[other] Beállítások
        }
    .tooltiptext = Módosított általános, adatvédelmi és biztonsági beállítások
    .accesskey = B
sync-engine-settings =
    .label = Beállítások
    .tooltiptext = Módosított általános, adatvédelmi és biztonsági beállítások
    .accesskey = k

## The device name controls.

sync-device-name-header = Eszköznév
sync-device-name-change =
    .label = Eszköznév módosítása…
    .accesskey = m
sync-device-name-cancel =
    .label = Mégse
    .accesskey = g
sync-device-name-save =
    .label = Mentés
    .accesskey = M
sync-connect-another-device = Másik eszköz csatlakoztatása

## Privacy Section

privacy-header = Böngésző adatvédelme

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Bejelentkezések és jelszavak
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Felhasználónevek és jelszavak megjegyzésének megkérdezése az oldalakhoz
    .accesskey = k
forms-exceptions =
    .label = Kivételek…
    .accesskey = v
forms-generate-passwords =
    .label = Erős jelszavak javaslata az előállítása
    .accesskey = j
forms-breach-alerts =
    .label = Figyelmeztetések megjelenítése a feltört webhelyek jelszavaival kapcsolatban
    .accesskey = f
forms-breach-alerts-learn-more-link = További tudnivalók
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Bejelentkezések és jelszavak automatikus kitöltése
    .accesskey = i
forms-saved-logins =
    .label = Mentett bejelentkezések…
    .accesskey = t
forms-master-pw-use =
    .label = Mesterjelszó használata
    .accesskey = M
forms-primary-pw-use =
    .label = Elsődleges jelszó használata
    .accesskey = E
forms-primary-pw-learn-more-link = Tudjon meg többet
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Mesterjelszó megváltoztatása…
    .accesskey = z
forms-master-pw-fips-title = Jelenleg FIPS-módban van. A FIPS-hez kötelező nem üres mesterjelszót megadni.
forms-primary-pw-change =
    .label = Elsődleges jelszó megváltoztatása…
    .accesskey = m
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = Korábban mesterjelszóként ismert
forms-primary-pw-fips-title = Jelenleg FIPS-módban van. A FIPS-hez nem üres elsődleges jelszó szükséges.
forms-master-pw-fips-desc = Sikertelen jelszóváltoztatás

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Mesterjelszó létrehozásához írja be a Windows bejelentkezési hitelesítő adatait. Ez elősegíti a fiókjai biztonságának védelmét.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = mesterjelszót hozzon létre
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Elsődleges jelszó létrehozásához írja be a Windows bejelentkezési hitelesítő adatait. Ez elősegíti a fiókjai biztonságának védelmét.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = elsődleges jelszó létrehozása
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Előzmények
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = A { -brand-short-name }
    .accesskey = A
history-remember-option-all =
    .label = Megjegyzi az előzményeket
history-remember-option-never =
    .label = Nem jegyzi meg az előzményeket
history-remember-option-custom =
    .label = Egyéni beállításokat használ az előzményekhez
history-remember-description = A { -brand-short-name } emlékezni fog a böngészési, letöltési, űrlap és keresési előzményekre.
history-dontremember-description = A { -brand-short-name } ugyanazokat a beállításokat fogja használni, mint a privát böngészés, és nem fogja megjegyezni az internethasználat előzményeit.
history-private-browsing-permanent =
    .label = Mindig a privát böngészési módot használja
    .accesskey = p
history-remember-browser-option =
    .label = Böngészési és letöltési előzmények megőrzése
    .accesskey = b
history-remember-search-option =
    .label = Keresőmezők és űrlapmezők előzményeinek megőrzése
    .accesskey = K
history-clear-on-close-option =
    .label = Előzmények törlése a { -brand-short-name } bezárásakor
    .accesskey = E
history-clear-on-close-settings =
    .label = Beállítások…
    .accesskey = B
history-clear-button =
    .label = Előzmények törlése…
    .accesskey = l

## Privacy Section - Site Data

sitedata-header = Sütik és oldaladatok
sitedata-total-size-calculating = Az oldaladatok és a gyorsítótár méretének kiszámítása…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = A tárolt sütik, oldaladatok és a gyorsítótár jelenleg { $value } { $unit } területet foglalnak el a lemezen.
sitedata-learn-more = További tudnivalók
sitedata-delete-on-close =
    .label = Sütik és oldaladatok törlése a { -brand-short-name } bezárásakor
    .accesskey = S
sitedata-delete-on-close-private-browsing = Állandó privát böngészési módban a sütik és a webhelyadatok mindig törölve lesznek a { -brand-short-name } bezárásakor.
sitedata-allow-cookies-option =
    .label = Sütik és oldaladatok elfogadása
    .accesskey = e
sitedata-disallow-cookies-option =
    .label = Sütik és oldaladatok blokkolása
    .accesskey = b
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Blokkolt típus
    .accesskey = B
sitedata-option-block-cross-site-trackers =
    .label = Weboldalak közti nyomkövetők
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Webhelyek közötti és közösségi média követők
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Webhelyek közötti nyomkövető sütik – köztük a közösségi média sütik
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Webhelyek közötti sütik – köztük a közösségi média sütik
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Webhelyek közötti és közösségimédia-követők, és a fennmaradó sütik elkülönítése
sitedata-option-block-unvisited =
    .label = Nem látogatott webhelyekről származó sütik
sitedata-option-block-all-third-party =
    .label = Minden harmadik féltől származó süti (egyes weboldalak működésképtelenné válhatnak)
sitedata-option-block-all =
    .label = Minden süti (egyes weboldalak működésképtelenné fognak válni)
sitedata-clear =
    .label = Adatok törlése…
    .accesskey = t
sitedata-settings =
    .label = Adatok kezelése…
    .accesskey = A
sitedata-cookies-permissions =
    .label = Engedélyek kezelése…
    .accesskey = E
sitedata-cookies-exceptions =
    .label = Kivételek kezelése…
    .accesskey = K

## Privacy Section - Address Bar

addressbar-header = Címsáv
addressbar-suggest = A címsáv használatakor jelenjen meg
addressbar-locbar-history-option =
    .label = Böngészési előzmények
    .accesskey = e
addressbar-locbar-bookmarks-option =
    .label = Könyvjelzők
    .accesskey = K
addressbar-locbar-openpage-option =
    .label = Nyitott lapok
    .accesskey = N
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Gyorskeresők
    .accesskey = G
addressbar-locbar-topsites-option =
    .label = Kedvenc oldalak
    .accesskey = K
addressbar-locbar-engines-option =
    .label = Keresőszolgáltatások
    .accesskey = K
addressbar-suggestions-settings = Keresőszolgáltatás-javaslatok beállításainak módosítása

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Fokozott követés elleni védelem
content-blocking-section-top-level-description = A nyomkövetők követik Önt online, és információkat gyűjtenek a böngészési szokásairól és érdeklődési köreiről. A { -brand-short-name } számos ilyen követőt és rosszindulatú parancsfájlt blokkol.
content-blocking-learn-more = További tudnivalók
content-blocking-fpi-incompatibility-warning = A First Party Isolation (FPI) funkciót használja, amely felülírja a { -brand-short-name } sütibeállításainak egy részét.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Szokásos
    .accesskey = S
enhanced-tracking-protection-setting-strict =
    .label = Szigorú
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Egyéni
    .accesskey = E

##

content-blocking-etp-standard-desc = Kiegyensúlyozott védelem és teljesítmény. Az oldalak normálisan fognak betölteni.
content-blocking-etp-strict-desc = Erősebb védelem, de egyes webhelyek és tartalmak hibásan működhetnek.
content-blocking-etp-custom-desc = Válassza ki a blokkolni kívánt nyomkövetőket és parancsfájlokat.
content-blocking-etp-blocking-desc = A { -brand-short-name } blokkolja a következőket:
content-blocking-private-windows = Követés elleni védelem a privát ablakokban
content-blocking-cross-site-cookies-in-all-windows = Webhelyek közötti sütik az összes ablakban (nyomkövető sütiket is beleértve)
content-blocking-cross-site-tracking-cookies = Webhelyek közötti nyomkövető sütik
content-blocking-all-cross-site-cookies-private-windows = Webhelyek közötti sütik a privát ablakokban
content-blocking-cross-site-tracking-cookies-plus-isolate = Webhelyek közötti követők, és a fennmaradó sütik elkülönítése
content-blocking-social-media-trackers = Közösségimédia-követők
content-blocking-all-cookies = Minden süti
content-blocking-unvisited-cookies = Sütik a nem látogatott oldalakról
content-blocking-all-windows-tracking-content = Tartalomkövetés az összes ablakban
content-blocking-all-third-party-cookies = Összes harmadik féltől származó süti
content-blocking-cryptominers = Kriptobányászok
content-blocking-fingerprinters = Ujjlenyomat-készítők
content-blocking-warning-title = Figyelem!
content-blocking-and-isolating-etp-warning-description = A nyomkövetők blokkolása és a sütik elkülönítése befolyásolhatja az egyes webhelyek működését. Töltse újra az oldalt a nyomkövetőkkel, hogy betöltse az összes tartalmat.
content-blocking-and-isolating-etp-warning-description-2 = A beállítás azt eredményezheti, hogy egyes webhelyek nem megfelelően jelennek meg vagy működnek. Ha egy oldal hibásnak tűnik, akkor az összes tartalom betöltéséhez kikapcsolhatja a követés elleni védelmet.
content-blocking-warning-learn-how = Tudja meg, hogyan
content-blocking-reload-description = A módosítások alkalmazásához frissítenie kell a lapokat.
content-blocking-reload-tabs-button =
    .label = Összes lap frissítése
    .accesskey = R
content-blocking-tracking-content-label =
    .label = Nyomkövető tartalom
    .accesskey = k
content-blocking-tracking-protection-option-all-windows =
    .label = Minden ablakban
    .accesskey = M
content-blocking-option-private =
    .label = Csak privát ablakokban
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Blokkolási lista módosítása
content-blocking-cookies-label =
    .label = Sütik
    .accesskey = S
content-blocking-expand-section =
    .tooltiptext = További információk
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Kriptobányászok
    .accesskey = i
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Ujjlenyomat-készítők
    .accesskey = U

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Kivételek kezelése…
    .accesskey = K

## Privacy Section - Permissions

permissions-header = Engedélyek
permissions-location = Hely
permissions-location-settings =
    .label = Beállítások…
    .accesskey = B
permissions-xr = Virtuális valóság
permissions-xr-settings =
    .label = Beállítások…
    .accesskey = B
permissions-camera = Kamera
permissions-camera-settings =
    .label = Beállítások…
    .accesskey = B
permissions-microphone = Mikrofon
permissions-microphone-settings =
    .label = Beállítások…
    .accesskey = B
permissions-notification = Értesítések
permissions-notification-settings =
    .label = Beállítások…
    .accesskey = B
permissions-notification-link = További tudnivalók
permissions-notification-pause =
    .label = Értesítések kikapcsolása a { -brand-short-name } újraindulásáig
    .accesskey = e
permissions-autoplay = Automatikus lejátszás
permissions-autoplay-settings =
    .label = Beállítások…
    .accesskey = B
permissions-block-popups =
    .label = Felugró ablakok tiltása
    .accesskey = F
permissions-block-popups-exceptions =
    .label = Kivételek…
    .accesskey = K
permissions-addon-install-warning =
    .label = Figyelmeztetés kiegészítők telepítése előtt
    .accesskey = F
permissions-addon-exceptions =
    .label = Kivételek…
    .accesskey = K
permissions-a11y-privacy-checkbox =
    .label = Az akadálymentesítési szolgáltatások ne férjenek hozzá a böngészőhöz
    .accesskey = a
permissions-a11y-privacy-link = További tudnivalók

## Privacy Section - Data Collection

collection-header = { -brand-short-name } adatgyűjtés és felhasználás
collection-description = Arra törekszünk, hogy választást biztosítsunk, és csak azt gyűjtsük, amire szükségünk a van a { -brand-short-name } fejlesztéséhez, mindenki számára. Mindig engedélyt kérünk, mielőtt személyes információkat fogadunk.
collection-privacy-notice = Adatvédelmi nyilatkozat
collection-health-report-telemetry-disabled = Már nem engedélyezi, hogy a { -vendor-short-name } műszaki és interakciós adatokat rögzítsen. A múltbeli adatai 30 napon belül törölve lesznek.
collection-health-report-telemetry-disabled-link = További tudnivalók
collection-health-report =
    .label = Engedélyezés, hogy a { -brand-short-name } műszaki és interakciós adatokat küldjön a { -vendor-short-name } számára
    .accesskey = E
collection-health-report-link = További tudnivalók
collection-studies =
    .label = Engedélyezés, hogy a { -brand-short-name } tanulmányokat telepítsen és futtasson
collection-studies-link = { -brand-short-name } tanulmányok megtekintése
addon-recommendations =
    .label = Engedélyezés, hogy a { -brand-short-name } személyre szabott kiegészítő ajánlásokat tegyen
addon-recommendations-link = További tudnivalók
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Az adatjelentést letiltották ehhez a binárishoz
collection-backlogged-crash-reports =
    .label = A { -brand-short-name } a háttérben küldhet összeomlási jelentéseket az Ön nevében
    .accesskey = j
collection-backlogged-crash-reports-link = További tudnivalók
collection-backlogged-crash-reports-with-link = Engedélyezés, hogy a { -brand-short-name } elküldje az elmaradt összeomlás-jelentéseket az Ön nevében <a data-l10n-name="crash-reports-link">További tudnivalók</a>
    .accesskey = o

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Biztonság
security-browsing-protection = Félrevezető tartalom és veszélyes szoftver elleni védelem
security-enable-safe-browsing =
    .label = Veszélyes és félrevezető tartalom blokkolása
    .accesskey = V
security-enable-safe-browsing-link = További tudnivalók
security-block-downloads =
    .label = Veszélyes letöltések blokkolása
    .accesskey = b
security-block-uncommon-software =
    .label = Figyelmeztetés a nem kívánatos és szokatlan szoftverekre
    .accesskey = F

## Privacy Section - Certificates

certs-header = Tanúsítványok
certs-personal-label = Ha a kiszolgáló elkéri a személyes tanúsítványt
certs-select-auto-option =
    .label = Automatikus választás
    .accesskey = A
certs-select-ask-option =
    .label = Megerősítés minden alkalommal
    .accesskey = M
certs-enable-ocsp =
    .label = Az OCSP válaszoló kiszolgálók lekérdezése a tanúsítványok érvényességének megerősítéséhez
    .accesskey = C
certs-view =
    .label = Tanúsítványok megtekintése…
    .accesskey = T
certs-devices =
    .label = Adatvédelmi eszközök…
    .accesskey = e
space-alert-learn-more-button =
    .label = További tudnivalók
    .accesskey = T
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Beállítások megnyitása
           *[other] Beállítások megnyitása
        }
    .accesskey =
        { PLATFORM() ->
            [windows] m
           *[other] m
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] A { -brand-short-name } kezd kifogyni a lemezhelyből. A weboldalak tartalma nem feltétlenül jelenik meg helyesen. Az oldalak tárolt adatait a Beállítások > Adatvédelem és biztonság > Sütik és oldaladatok alatt törölheti.
       *[other] A { -brand-short-name } kezd kifogyni a lemezhelyből. A weboldalak tartalma nem feltétlenül jelenik meg helyesen. Az oldalak tárolt adatait a Beállítások > Adatvédelem és biztonság > Sütik és oldaladatok alatt törölheti.
    }
space-alert-under-5gb-ok-button =
    .label = Rendben, értem
    .accesskey = R
space-alert-under-5gb-message = A { -brand-short-name } kezd kifogyni a lemezhelyből. A weboldalak tartalma nem feltétlenül jelenik meg helyesen. A lemezhasználat optimalizálásával a böngészés simábbá tehető, olvassa el a „További tudnivalókat”.
space-alert-over-5gb-settings-button =
    .label = Beállítások megnyitása
    .accesskey = m
space-alert-over-5gb-message2 = <strong>A { -brand-short-name } kezd kifogyni a lemezhelyből.</strong> A weboldalak tartalma nem feltétlenül jelenik meg helyesen. Az oldalak tárolt adatait a Beállítások > Adatvédelem és biztonság > Sütik és oldaladatok alatt törölheti.
space-alert-under-5gb-message2 = <strong>A { -brand-short-name } kezd kifogyni a lemezhelyből.</strong> A weboldalak tartalma nem feltétlenül jelenik meg helyesen. A lemezhasználat optimalizálásával a böngészés simábbá tehető, olvassa el a „További tudnivalókat”.

## Privacy Section - HTTPS-Only

httpsonly-header = Csak HTTPS mód
httpsonly-description = A HTTPS biztonságos, titkosított kapcsolatot biztosít a { -brand-short-name } és a meglátogatott webhelyek között. A legtöbb webhely támogatja a HTTPS-t, és ha a Csak HTTPS mód engedélyezve van, akkor a { -brand-short-name } HTTPS-re frissíti az összes kapcsolatot.
httpsonly-learn-more = További tudnivalók
httpsonly-radio-enabled =
    .label = A Csak HTTPS mód engedélyezése az összes ablakban
httpsonly-radio-enabled-pbm =
    .label = A Csak HTTPS mód engedélyezése csak privát ablakokban
httpsonly-radio-disabled =
    .label = Ne engedélyezze a Csak HTTPS módot

## The following strings are used in the Download section of settings

desktop-folder-name = Asztal
downloads-folder-name = Letöltések
choose-download-folder-title = Letöltési mappa kiválasztása:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Fájlok mentése ide: { $service-name }
