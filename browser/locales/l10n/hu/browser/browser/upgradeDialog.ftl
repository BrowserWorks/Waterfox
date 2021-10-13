# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Köszönjön az új { -brand-short-name }nak
upgrade-dialog-new-subtitle = Arra tervezve, hogy gyorsabban eljusson oda, ahová szeretne
upgrade-dialog-new-item-menu-title = Korszerűsített eszköztár és menük
upgrade-dialog-new-item-menu-description = Priorizálja a fontos dolgokat, hogy megtalálja amire szüksége van.
upgrade-dialog-new-item-tabs-title = Modern lapok
upgrade-dialog-new-item-tabs-description = Rendezetten tárolja az információkat, támogatja a fókuszt és a rugalmas mozgatást.
upgrade-dialog-new-item-icons-title = Friss ikonok és egyértelműbb üzenetek
upgrade-dialog-new-item-icons-description = Könnyebb érintéssel segít eligazodni.
upgrade-dialog-new-primary-default-button = A { -brand-short-name } alapértelmezett böngészővé tétele
upgrade-dialog-new-primary-theme-button = Válasszon témát
upgrade-dialog-new-secondary-button = Most nem
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Rendben, értem!

## Pin Waterfox screen
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
upgrade-dialog-default-title-2 = A { -brand-short-name } alapértelmezetté tétele
upgrade-dialog-default-subtitle-2 = Tegye robotpilótára a sebességet, a biztonságot és az adatvédelmet
upgrade-dialog-default-primary-button-2 = Alapértelmezett böngészővé tétel
upgrade-dialog-default-secondary-button = Most nem

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Induljon tisztán egy ropogós, új témával
upgrade-dialog-theme-system = Rendszertéma
    .title = Az operációs rendszer témájának követése a gomboknál, menüknél és ablakoknál

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = Az élet színesben
upgrade-dialog-start-subtitle = Élénk új színvilágok. Korlátozott ideig elérhető.
upgrade-dialog-start-primary-button = Fedezze fel a színvilágokat
upgrade-dialog-start-secondary-button = Most nem

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Válassza ki a palettáját
upgrade-dialog-colorway-home-checkbox = Váltson a temázott háttérrel rendelkező Waterfox kezdőoldalra
upgrade-dialog-colorway-primary-button = Színvilág mentése
upgrade-dialog-colorway-secondary-button = Előző téma megtartása
upgrade-dialog-colorway-theme-tooltip =
    .title = Alapértelmezett témák felfedezése
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Fedezze fel a(z) { $colorwayName } színvilágokat
upgrade-dialog-colorway-default-theme = Alapértelmezett
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Automatikus
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
upgrade-dialog-colorway-variation-soft = Puha
    .title = Ezen színvilág használata
upgrade-dialog-colorway-variation-balanced = Kiegyensúlyozott
    .title = Ezen színvilág használata
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Élénk
    .title = Ezen színvilág használata

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Köszönjük, hogy minket választott
upgrade-dialog-thankyou-subtitle = A { -brand-short-name } egy független böngésző, melyet egy nonprofit szervezet támogat. Együtt biztonságosabbá, egészségesebbé és privátabbá tesszük a világhálót.
upgrade-dialog-thankyou-primary-button = Böngészés megkezdése
