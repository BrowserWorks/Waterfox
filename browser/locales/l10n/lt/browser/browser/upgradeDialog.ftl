# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Pasisveikinkite su naująja „{ -brand-short-name }“
upgrade-dialog-new-subtitle = Sukurta tam, kad greičiau patektumėte ten kur norite
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Pradžiai padarykite <span data-l10n-name="zap">„{ -brand-short-name }“</span> pasiekiamą vienu paspaudimu
upgrade-dialog-new-item-menu-title = Suprantamesnė priemonių juosta ir meniu
upgrade-dialog-new-item-menu-description = Suteikite prioritetą svarbiems dalykams, kad rastumėte tai, ko reikia.
upgrade-dialog-new-item-tabs-title = Šiuolaikinės kortelės
upgrade-dialog-new-item-tabs-description = Tvarkingai talpina informaciją, išlaikant dėmesį ir lankstų judėjimą.
upgrade-dialog-new-item-icons-title = Naujos piktogramos ir aiškesni pranešimai
upgrade-dialog-new-item-icons-description = Padeda jums susiorientuoti su lengvesniu prisilietimu.
upgrade-dialog-new-primary-primary-button = Paskirti „{ -brand-short-name }“ mano pagrindine naršykle
    .title = Padaro „{ -brand-short-name }“ numatytąja naršykle ir prisega į užduočių juostą
upgrade-dialog-new-primary-default-button = Paskirti „{ -brand-short-name }“ mano pagrindine naršykle
upgrade-dialog-new-primary-pin-button = Įsegti „{ -brand-short-name }“ į užduočių juostą
upgrade-dialog-new-primary-pin-alt-button = Įsegti į užduočių juostą
upgrade-dialog-new-primary-theme-button = Pasirinkite apvalkalą
upgrade-dialog-new-secondary-button = Ne dabar
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Gerai, supratau!

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Palikti „{ -brand-short-name }“ užduočių juostoje
       *[other] Įsegti „{ -brand-short-name }“ į užduočių juostą
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Lengvai pasiekite šviežiausią „{ -brand-short-name }“.
       *[other] Lengvai pasiekite šviežiausią „{ -brand-short-name }“.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Palikti užduočių juostoje
       *[other] Įsegti į užduočių juostą
    }
upgrade-dialog-pin-secondary-button = Ne dabar

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = Paskirti „{ -brand-short-name }“ jūsų pagrindine naršykle?
upgrade-dialog-default-subtitle = Gaukite greitį, saugumą, ir privatumą kiekvieno naršymo metu.
upgrade-dialog-default-primary-button = Skirti numatytąja naršykle
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Paskirti „{ -brand-short-name }“ jūsų pagrindine
upgrade-dialog-default-subtitle-2 = Įjunkite autopilotą greičiui, saugumui, ir privatumui.
upgrade-dialog-default-primary-button-2 = Skirti numatytąja naršykle
upgrade-dialog-default-secondary-button = Ne dabar

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Pradėkite švariai
    su atnaujintu grafiniu apvalkalu
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Pradėkite švariai su atnaujintu grafiniu apvalkalu
upgrade-dialog-theme-system = Sistemos grafinis apvalkalas
    .title = Atsižvelgti į operacinės sistemos grafinį apvalkalą mygtukams, meniu, ir langams.
upgrade-dialog-theme-light = Šviesus
    .title = Naudoti šviesų grafinį apvalkalą mygtukams, meniu, ir langams
upgrade-dialog-theme-dark = Tamsus
    .title = Naudoti tamsų grafinį apvalkalą mygtukams, meniu, ir langams
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Naudoti dinamišką, spalvingą grafinį apvalkalą mygtukams, meniu, ir langams
upgrade-dialog-theme-keep = Palikti ankstesnį
    .title = Naudoti prieš atnaujinant „{ -brand-short-name }“ jūsų įdiegtą grafinį apvalkalą
upgrade-dialog-theme-primary-button = Įrašyti grafinį apvalkalą
upgrade-dialog-theme-secondary-button = Ne dabar
