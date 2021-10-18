# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = Atsiunčiamas „{ -brand-shorter-name }“ naujinimas
    .label-update-available = Išleistas naujinimas – atsiųsti dabar
    .label-update-manual = Išleistas naujinimas – atsiųsti dabar
    .label-update-unsupported = Nepavyko atnaujinti – sistema nesuderinama
    .label-update-restart = Išleistas naujinimas – paleisti iš naujo dabar
appmenuitem-protection-dashboard-title = Apsaugos skydelis
appmenuitem-new-tab =
    .label = Nauja kortelė
appmenuitem-new-window =
    .label = Naujas langas
appmenuitem-new-private-window =
    .label = Naujas privataus naršymo langas
appmenuitem-history =
    .label = Žurnalas
appmenuitem-downloads =
    .label = Atsiuntimai
appmenuitem-passwords =
    .label = Slaptažodžiai
appmenuitem-addons-and-themes =
    .label = Priedai ir grafiniai apvalkalai
appmenuitem-print =
    .label = Spausdinti…
appmenuitem-find-in-page =
    .label = Rasti tinklalapyje…
appmenuitem-zoom =
    .value = Mastelis
appmenuitem-more-tools =
    .label = Daugiau priemonių
appmenuitem-help =
    .label = Žinynas
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Išeiti
           *[other] Išeiti
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Atverti programos meniu
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Užverti programos meniu
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Nuostatos

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Padidinti
appmenuitem-zoom-reduce =
    .label = Sumažinti
appmenuitem-fullscreen =
    .label = Visas ekranas

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Prisijungti sinchronizavimui…
appmenu-remote-tabs-turn-on-sync =
    .label = Įjungti sinchronizavimą…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Rodyti daugiau kortelių
    .tooltiptext = Rodyti daugiau kortelių iš šio įrenginio
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Nėra atvirų kortelių
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Įjunkite kortelių sinchronizavimą, norėdami peržiūrėti kituose įrenginiuose esančias korteles.
appmenu-remote-tabs-opensettings =
    .label = Nustatymai
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Norite čia matyti savo korteles iš kitų įrenginių?
appmenu-remote-tabs-connectdevice =
    .label = Susieti kitą įrenginį
appmenu-remote-tabs-welcome = Peržiūrėkite kituose įrenginiuose esančias korteles.
appmenu-remote-tabs-unverified = Jūsų paskyra turi būti patvirtinta.
appmenuitem-fxa-toolbar-sync-now2 = Sinchronizuoti dabar
appmenuitem-fxa-sign-in = Prisijungti prie „{ -brand-product-name }“
appmenuitem-fxa-manage-account = Tvarkyti paskyrą
appmenu-fxa-header2 = „{ -fxaccount-brand-name }“ paskyra
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Paskiausiai sinchronizuota { $time }
    .label = Paskiausiai sinchronizuota { $time }
appmenu-fxa-sync-and-save-data2 = Sinchronizuoti ir įrašyti duomenis
appmenu-fxa-signed-in-label = Prisijungti
appmenu-fxa-setup-sync =
    .label = Įjungti sinchronizavimą…
appmenu-fxa-show-more-tabs = Rodyti daugiau kortelių
appmenuitem-save-page =
    .label = Įrašyti kaip…

## What's New panel in App menu.

whatsnew-panel-header = Kas naujo
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Pranešti apie naujas funkcijas
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Profiliuoklė
    .tooltiptext = Įrašyti našumo profilį
profiler-popup-button-recording =
    .label = Profiliuoklė
    .tooltiptext = Profiliuoklė įrašinėja profilį
profiler-popup-button-capturing =
    .label = Profiliuoklė
    .tooltiptext = Profiliuoklė fiksuoja profilį
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Rodyti daugiau informacijos
profiler-popup-description-title =
    .value = Įrašykite, analizuokite, dalinkitės
profiler-popup-description = Bendraukite spręsdami našumo problemas, paskelbdami profilius pasidalinimui su savo komanda.
profiler-popup-learn-more = Sužinoti daugiau
profiler-popup-learn-more-button =
    .label = Sužinoti daugiau
profiler-popup-settings =
    .value = Nuostatos
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Keisti nuostatas…
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Keisti nuostatas…
profiler-popup-disabled = Profiliuoklė šiuo metu išjungta, greičiausiai dėl atverto privačiojo naršymo lango.
profiler-popup-recording-screen = Įrašinėjama…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Pasirinktinės
profiler-popup-start-recording-button =
    .label = Pradėti įrašinėjimą
profiler-popup-discard-button =
    .label = Atmesti
profiler-popup-capture-button =
    .label = Užfiksuoti
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

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = Rekomenduojamas nustatymas daugelio saityno programų derinimui, su nedidelėmis sąnaudomis.
profiler-popup-presets-web-developer-label =
    .label = Saityno kūrėjams
profiler-popup-presets-firefox-platform-description = Rekomenduojamas nustatymas vidinės „Waterfox“ platformos derinimui.
profiler-popup-presets-firefox-platform-label =
    .label = „Waterfox“ platforma
profiler-popup-presets-firefox-front-end-description = Rekomenduojamas nustatymas vidinio „Waterfox“ „front-end“ derinimui.
profiler-popup-presets-firefox-front-end-label =
    .label = „Waterfox“ front-end
profiler-popup-presets-firefox-graphics-description = Rekomenduojamas nustatymas „Waterfox“ grafinio našumo tyrinėjimui.
profiler-popup-presets-firefox-graphics-label =
    .label = „Waterfox“ grafika
profiler-popup-presets-media-description = Rekomenduojamas nustatymas garso ir vaizdo problemų diagnozavimui.
profiler-popup-presets-media-label =
    .label = Medija
profiler-popup-presets-custom-label =
    .label = Kitas

## History panel

appmenu-manage-history =
    .label = Tvarkyti žurnalą
appmenu-reopen-all-tabs = Įkelti visas korteles
appmenu-reopen-all-windows = Įkelti visus langus
appmenu-restore-session =
    .label = Atkurti paskiausiąjį seansą
appmenu-clear-history =
    .label = Valyti žurnalą…
appmenu-recent-history-subheader = Žurnalas
appmenu-recently-closed-tabs =
    .label = Paskiausiai užvertos kortelės
appmenu-recently-closed-windows =
    .label = Paskiausiai užverti langai

## Help panel

appmenu-help-header =
    .title = „{ -brand-shorter-name }“ žinynas
appmenu-about =
    .label = Apie „{ -brand-shorter-name }“
    .accesskey = A
appmenu-get-help =
    .label = Žinynas ir pagalba
    .accesskey = Ž
appmenu-help-more-troubleshooting-info =
    .label = Daugiau informacijos problemų sprendimui
    .accesskey = p
appmenu-help-report-site-issue =
    .label = Pranešti apie svetainės problemą…
appmenu-help-feedback-page =
    .label = Siųsti atsiliepimą…
    .accesskey = S

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Trikčių šalinimo veiksena…
    .accesskey = v
appmenu-help-exit-troubleshoot-mode =
    .label = Išjungti trikčių šalinimo veikseną
    .accesskey = m

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Pranešti apie apgaulingą svetainę…
    .accesskey = a
appmenu-help-not-deceptive =
    .label = Tai nėra apgaulinga svetainė…
    .accesskey = g

## More Tools

appmenu-customizetoolbar =
    .label = Tvarkyti priemonių juostą…
appmenu-taskmanager =
    .label = Užduočių tvarkytuvė
appmenu-developer-tools-subheader = Naršyklės įrankiai
appmenu-developer-tools-extensions =
    .label = Priedai programuotojams
