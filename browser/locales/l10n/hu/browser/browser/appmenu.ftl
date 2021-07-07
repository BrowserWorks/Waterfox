# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = { -brand-shorter-name }-frissítés letöltése
    .label-update-available = Frissítés érhető el – letöltés most
    .label-update-manual = Frissítés érhető el – letöltés most
    .label-update-unsupported = Nem lehet frissíteni – a rendszer nem kompatibilis
    .label-update-restart = Frissítés érhető el – újraindítás most
appmenuitem-protection-dashboard-title = Védelmi vezérlőpult
appmenuitem-customize-mode =
    .label = Testreszabás…

## Zoom Controls

appmenuitem-new-tab =
    .label = Új lap
appmenuitem-new-window =
    .label = Új ablak
appmenuitem-new-private-window =
    .label = Új privát ablak
appmenuitem-passwords =
    .label = Jelszavak
appmenuitem-addons-and-themes =
    .label = Kiegészítők és témák
appmenuitem-find-in-page =
    .label = Keresés az oldalon…
appmenuitem-more-tools =
    .label = További eszközök
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Kilépés
           *[other] Kilépés
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Alkalmazásmenü megnyitása
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Alkalmazásmenü bezárása
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Beállítások

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Nagyítás
appmenuitem-zoom-reduce =
    .label = Kicsinyítés
appmenuitem-fullscreen =
    .label = Teljes képernyő

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = Szinkronizálás
appmenu-remote-tabs-sign-into-sync =
    .label = Jelentkezzen be a Syncbe…
appmenu-remote-tabs-turn-on-sync =
    .label = Szinkronizálás bekapcsolása…
appmenuitem-fxa-toolbar-sync-now2 = Szinkronizálás most
appmenuitem-fxa-manage-account = Fiók kezelése
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Utoljára szinkronizálva: { $time }
    .label = Utoljára szinkronizálva: { $time }
appmenu-fxa-sync-and-save-data2 = Adatok szinkronizálása és mentése
appmenu-fxa-signed-in-label = Bejelentkezés
appmenu-fxa-setup-sync =
    .label = Szinkronizálás bekapcsolása…
appmenu-fxa-show-more-tabs = Több lap megjelenítése
appmenuitem-save-page =
    .label = Oldal mentése…

## What's New panel in App menu.

whatsnew-panel-header = Újdonságok
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Értesítés az új funkciókról
    .accesskey = f

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = További információk felfedése
profiler-popup-description-title =
    .value = Felvétel, elemzés, megosztás
profiler-popup-description = Dolgozzon együtt a teljesítményproblémák kijavításán azáltal, hogy profilokat oszt meg a csapatával.
profiler-popup-learn-more = További tudnivalók
profiler-popup-settings =
    .value = Beállítások
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Beállítások szerkesztése…
profiler-popup-disabled =
    A profilozó jelenleg le van tiltva, valószínűleg azért, mert nyitva van egy privát
    böngészési ablak.
profiler-popup-recording-screen = Felvétel…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Egyéni
profiler-popup-start-recording-button =
    .label = Felvétel indítása
profiler-popup-discard-button =
    .label = Elvetés
profiler-popup-capture-button =
    .label = Rögzítés
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## History panel

appmenu-manage-history =
    .label = Előzmények kezelése
appmenu-reopen-all-tabs = Összes lap újranyitása
appmenu-reopen-all-windows = Összes ablak újranyitása
appmenu-restore-session =
    .label = Előző munkamenet helyreállítása
appmenu-clear-history =
    .label = Előzmények törlése…
appmenu-recent-history-subheader = Közelmúltbeli előzmények
appmenu-recently-closed-tabs =
    .label = Nemrég bezárt lapok
appmenu-recently-closed-windows =
    .label = Nemrég bezárt ablakok

## Help panel

appmenu-help-header =
    .title = { -brand-shorter-name } súgó
appmenu-about =
    .label = A { -brand-shorter-name } névjegye
    .accesskey = A
appmenu-get-help =
    .label = Segítség kérése
    .accesskey = S
appmenu-help-more-troubleshooting-info =
    .label = Több hibakeresési információ
    .accesskey = T
appmenu-help-report-site-issue =
    .label = Hibás webhely bejelentése…
appmenu-help-feedback-page =
    .label = Visszajelzés beküldése…
    .accesskey = V

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Hibaelhárítási mód…
    .accesskey = m
appmenu-help-exit-troubleshoot-mode =
    .label = Hibakeresési mód kikapcsolása
    .accesskey = m

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Félrevezető oldal jelentése…
    .accesskey = F
appmenu-help-not-deceptive =
    .label = Ez nem félrevezető oldal…
    .accesskey = n

## More Tools

appmenu-customizetoolbar =
    .label = Eszköztár testreszabása…
appmenu-taskmanager =
    .label = Feladatkezelő
appmenu-developer-tools-subheader = Böngészőeszközök
appmenu-developer-tools-extensions =
    .label = Kiegészítők fejlesztőknek
