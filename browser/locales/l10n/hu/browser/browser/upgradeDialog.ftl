# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Köszönjön az új { -brand-short-name }nak
upgrade-dialog-new-subtitle = Arra tervezve, hogy gyorsabban eljusson oda, ahová szeretne
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Kezdje azzal, hogy a <span data-l10n-name="zap">{ -brand-short-name }</span> csak egy kattintásnyira legyen
upgrade-dialog-new-item-menu-title = Korszerűsített eszköztár és menük
upgrade-dialog-new-item-menu-description = Priorizálja a fontos dolgokat, hogy megtalálja amire szüksége van.
upgrade-dialog-new-item-tabs-title = Modern lapok
upgrade-dialog-new-item-tabs-description = Rendezetten tárolja az információkat, támogatja a fókuszt és a rugalmas mozgatást.
upgrade-dialog-new-item-icons-title = Friss ikonok és egyértelműbb üzenetek
upgrade-dialog-new-item-icons-description = Könnyebb érintéssel segít eligazodni.
upgrade-dialog-new-primary-primary-button = A { -brand-short-name } elsődleges böngészővé tétele
    .title = Beállítja a { -brand-short-name }ot alapértelmezett böngészőnek, és rögzíti a tálcára
upgrade-dialog-new-primary-default-button = A { -brand-short-name } alapértelmezett böngészővé tétele
upgrade-dialog-new-primary-pin-button = A { -brand-short-name } rögzítése a tálcára
upgrade-dialog-new-primary-pin-alt-button = Rögzítés a tálcára
upgrade-dialog-new-primary-theme-button = Válasszon témát
upgrade-dialog-new-secondary-button = Most nem
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Rendben, értem!

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] A { -brand-short-name } hozzáadása a Dokkhoz
       *[other] A { -brand-short-name } rögzítése a tálcára
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Érje el könnyedén a legfrissebb { -brand-short-name }ot.
       *[other] Tartsa elérhető közelségben a legfrissebb { -brand-short-name }ot.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Hozzáadás a Dokkhoz
       *[other] Rögzítés a tálcára
    }
upgrade-dialog-pin-secondary-button = Most nem

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = A { -brand-short-name } legyen az alapértelmezett böngészője?
upgrade-dialog-default-subtitle = Szerezzen gyorsaságot, biztonságot és adatvédelmet minden böngészés során.
upgrade-dialog-default-primary-button = Beállítás alapértelmezett böngészőként
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = A { -brand-short-name } alapértelmezetté tétele
upgrade-dialog-default-subtitle-2 = Tegye robotpilótára a sebességet, a biztonságot és az adatvédelmet
upgrade-dialog-default-primary-button-2 = Alapértelmezett böngészővé tétel
upgrade-dialog-default-secondary-button = Most nem

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Induljon tisztán
    egy frissített témával
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Induljon tisztán egy ropogós, új témával
upgrade-dialog-theme-system = Rendszertéma
    .title = Az operációs rendszer témájának követése a gomboknál, menüknél és ablakoknál
upgrade-dialog-theme-light = Világos
    .title = Világos téma használata a gomboknál, menüknél és ablakoknál
upgrade-dialog-theme-dark = Sötét
    .title = Sötét téma használata a gomboknál, menüknél és ablakoknál
upgrade-dialog-theme-alpenglow = Alpesi fény
    .title = Dinamikus, színes téma használata a gomboknál, menüknél és ablakoknál
upgrade-dialog-theme-keep = Előző megtartása
    .title = A { -brand-short-name } frissítése előtt használt téma használata
upgrade-dialog-theme-primary-button = Téma mentése
upgrade-dialog-theme-secondary-button = Most nem
