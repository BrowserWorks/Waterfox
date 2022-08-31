# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = Lastar ned { -brand-shorter-name }-oppdatering
appmenuitem-banner-update-available =
    .label = Oppdatering tilgjengeleg — last ned no
appmenuitem-banner-update-manual =
    .label = Oppdatering tilgjengeleg — last ned no
appmenuitem-banner-update-unsupported =
    .label = Kan ikkje oppdatere — systemet er inkompatibelt
appmenuitem-banner-update-restart =
    .label = Oppdatering tilgjengeleg — start på nytt
appmenuitem-new-tab =
    .label = Ny fane
appmenuitem-new-window =
    .label = Nytt vindauge
appmenuitem-new-private-window =
    .label = Nytt privat vindauge
appmenuitem-history =
    .label = Historikk
appmenuitem-downloads =
    .label = Nedlastingar
appmenuitem-passwords =
    .label = Passord
appmenuitem-addons-and-themes =
    .label = Tillegg og tema
appmenuitem-print =
    .label = Skriv ut…
appmenuitem-find-in-page =
    .label = Finn på sida…
appmenuitem-zoom =
    .value = Skalering
appmenuitem-more-tools =
    .label = Fleire verktøy
appmenuitem-help =
    .label = Hjelp
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Avslutt
           *[other] Avslutt
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Opne program-meny
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Lat att program-meny
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Innstillingar

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Forstørre
appmenuitem-zoom-reduce =
    .label = Forminske
appmenuitem-fullscreen =
    .label = Fullskjerm

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Logg inn for å synkronisere…
appmenu-remote-tabs-turn-on-sync =
    .label = Slå på Sync…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Vis fleire faner
    .tooltiptext = Vis fleire faner frå denne eininga
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Ingen opne faner
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Slå på fane-synkronisering for å sjå ei liste over faner frå dei andre einingane dine.
appmenu-remote-tabs-opensettings =
    .label = Innstillingar
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Vil du sjå faner frå dei andre einingane dine her?
appmenu-remote-tabs-connectdevice =
    .label = Kople til ei anna eining
appmenu-remote-tabs-welcome = Vis ei liste over faner frå dei andre einingane dine.
appmenu-remote-tabs-unverified = Kontoen din må stadfestast.
appmenuitem-fxa-toolbar-sync-now2 = Synkroniser no
appmenuitem-fxa-sign-in = Logg inn på { -brand-product-name }
appmenuitem-fxa-manage-account = Handsam kontoen
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Sist synkronisert { $time }
    .label = Sist synkronisert { $time }
appmenu-fxa-sync-and-save-data2 = Synkroniser og lagre data
appmenu-fxa-signed-in-label = Logg inn
appmenu-fxa-setup-sync =
    .label = Slå på synkronisering…
appmenuitem-save-page =
    .label = Lagre sida som…

## What's New panel in App menu.

whatsnew-panel-header = Kva er nytt
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Varsle om nye funksjonar
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Profilering
    .tooltiptext = Ta opp ein ytingsprofil
profiler-popup-button-recording =
    .label = Profilerar
    .tooltiptext = Profileraren registrerer ein profil
profiler-popup-button-capturing =
    .label = Profilerar
    .tooltiptext = Profileraren tar opp ein profil
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Vis meir informasjon
profiler-popup-description-title =
    .value = Registrer, analyser, del
profiler-popup-description = Samarbeid om ytingsproblem ved å publisere profilar for å dele med teamet ditt.
profiler-popup-learn-more-button =
    .label = Les meir
profiler-popup-settings =
    .value = Innstillingar
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Rediger innstillingar …
profiler-popup-recording-screen = Registrerer…
profiler-popup-start-recording-button =
    .label = Start registrering
profiler-popup-discard-button =
    .label = Forkast
profiler-popup-capture-button =
    .label = Fang
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

profiler-popup-presets-web-developer-description = Tilrådd førehandsinnstilling for dei fleste feilsøkingar i nettappar, med lite tillegg.
profiler-popup-presets-web-developer-label =
    .label = Nettsideutvikling
profiler-popup-presets-firefox-description = Tilrådd førehandsinnstilling for profilering { -brand-shorter-name }.
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }
profiler-popup-presets-graphics-description = Førehandsinnstilt for å undersøke grafikk-problem i { -brand-shorter-name }.
profiler-popup-presets-graphics-label =
    .label = Grafikk
profiler-popup-presets-media-description2 = Førehandsinnstilt for å undersøke lyd- og videoproblem i { -brand-shorter-name }.
profiler-popup-presets-media-label =
    .label = Media
profiler-popup-presets-networking-description = Førehandsinnstilt for å undersøke nettverksfeil i { -brand-shorter-name }.
profiler-popup-presets-networking-label =
    .label = Nettverk
profiler-popup-presets-power-description = Førehandsinnstilt til å undersøke straumforbruksfeil i { -brand-shorter-name }, med låg overhead.
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = Energi
profiler-popup-presets-custom-label =
    .label = Tilpassa

## History panel

appmenu-manage-history =
    .label = Handsam historikk
appmenu-reopen-all-tabs = Opne alle faner på nytt
appmenu-reopen-all-windows = Opne alle vindauge på nytt
appmenu-restore-session =
    .label = Bygg oppatt siste programøkt
appmenu-clear-history =
    .label = Tøm nyleg historikk…
appmenu-recent-history-subheader = Nyleg historikk
appmenu-recently-closed-tabs =
    .label = Nyleg attlatne faner
appmenu-recently-closed-windows =
    .label = Nyleg attlatne vindauge

## Help panel

appmenu-help-header =
    .title = { -brand-shorter-name }-hjelp
appmenu-about =
    .label = Om { -brand-shorter-name }
    .accesskey = O
appmenu-get-help =
    .label = Få hjelp
    .accesskey = F
appmenu-help-more-troubleshooting-info =
    .label = Meir feilsøkingsinformasjon
    .accesskey = M
appmenu-help-report-site-issue =
    .label = Rapporter problem med nettstad…
appmenu-help-share-ideas =
    .label = Del idear og tilbakemeldingar...
    .accesskey = D

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Feilsøkingsmodus…
    .accesskey = F
appmenu-help-exit-troubleshoot-mode =
    .label = Slå av feilsøkingsmodus
    .accesskey = S

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Rapporter villeiande nettstad…
    .accesskey = R
appmenu-help-not-deceptive =
    .label = Dette er ikkje ein villeiande nettstad…
    .accesskey = d

## More Tools

appmenu-customizetoolbar =
    .label = Tilpass verktøylinje…
appmenu-developer-tools-subheader = Nettlesarverktøy
appmenu-developer-tools-extensions =
    .label = Extensions for Developers
