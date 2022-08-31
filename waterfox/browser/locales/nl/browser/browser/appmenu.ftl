# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = { -brand-shorter-name }-update wordt gedownload
appmenuitem-banner-update-available =
    .label = Update beschikbaar – nu downloaden
appmenuitem-banner-update-manual =
    .label = Update beschikbaar – nu downloaden
appmenuitem-banner-update-unsupported =
    .label = Kan niet bijwerken – systeem niet compatibel
appmenuitem-banner-update-restart =
    .label = Update beschikbaar – nu herstarten
appmenuitem-new-tab =
    .label = Nieuw tabblad
appmenuitem-new-window =
    .label = Nieuw venster
appmenuitem-new-private-window =
    .label = Nieuw privévenster
appmenuitem-history =
    .label = Geschiedenis
appmenuitem-downloads =
    .label = Downloads
appmenuitem-passwords =
    .label = Wachtwoorden
appmenuitem-addons-and-themes =
    .label = Add-ons en thema’s
appmenuitem-print =
    .label = Afdrukken…
appmenuitem-find-in-page =
    .label = Zoeken op pagina…
appmenuitem-zoom =
    .value = Zoomen
appmenuitem-more-tools =
    .label = Meer hulpmiddelen
appmenuitem-help =
    .label = Help
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Afsluiten
           *[other] Afsluiten
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Toepassingsmenu openen
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Toepassingsmenu sluiten
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Instellingen

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Inzoomen
appmenuitem-zoom-reduce =
    .label = Uitzoomen
appmenuitem-fullscreen =
    .label = Volledig scherm

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Aanmelden bij Sync…
appmenu-remote-tabs-turn-on-sync =
    .label = Synchronisatie inschakelen…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Meer tabbladen tonen
    .tooltiptext = Meer tabbladen van dit apparaat tonen
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Geen open tabbladen
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Zet tabbladsynchronisatie aan om een lijst van tabbladen van uw andere apparaten weer te geven.
appmenu-remote-tabs-opensettings =
    .label = Instellingen
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Wilt u hier uw tabbladen van andere apparaten zien?
appmenu-remote-tabs-connectdevice =
    .label = Een ander apparaat verbinden
appmenu-remote-tabs-welcome = Bekijk een lijst met tabbladen van uw overige apparaten.
appmenu-remote-tabs-unverified = Uw account moet worden geverifieerd.
appmenuitem-fxa-toolbar-sync-now2 = Nu synchroniseren
appmenuitem-fxa-sign-in = Aanmelden bij { -brand-product-name }
appmenuitem-fxa-manage-account = Account beheren
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Laatst gesynchroniseerd: { $time }
    .label = Laatst gesynchroniseerd: { $time }
appmenu-fxa-sync-and-save-data2 = Synchroniseren en gegevens opslaan
appmenu-fxa-signed-in-label = Aanmelden
appmenu-fxa-setup-sync =
    .label = Synchronisatie inschakelen…
appmenuitem-save-page =
    .label = Pagina opslaan als…

## What's New panel in App menu.

whatsnew-panel-header = Wat is er nieuw
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Berichten over nieuwe functies
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Profiler
    .tooltiptext = Neem een prestatieprofiel op
profiler-popup-button-recording =
    .label = Profiler
    .tooltiptext = De profiler neemt een profiel op
profiler-popup-button-capturing =
    .label = Profiler
    .tooltiptext = De profiler neemt een profiel op
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Meer informatie onthullen
profiler-popup-description-title =
    .value = Opnemen, analyseren, delen
profiler-popup-description = Werk samen aan prestatieproblemen door profielen te publiceren om met uw team te delen.
profiler-popup-learn-more-button =
    .label = Meer info
profiler-popup-settings =
    .value = Instellingen
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Instellingen bewerken…
profiler-popup-recording-screen = Opnemen…
profiler-popup-start-recording-button =
    .label = Opname starten
profiler-popup-discard-button =
    .label = Verwerpen
profiler-popup-capture-button =
    .label = Vastleggen
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

profiler-popup-presets-web-developer-description = Aanbevolen voorinstelling voor de meeste foutopsporing in web-apps, met lage overhead.
profiler-popup-presets-web-developer-label =
    .label = Webontwikkelaar
profiler-popup-presets-firefox-description = Aanbevolen voorinstelling voor profileringen van { -brand-shorter-name }.
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }
profiler-popup-presets-graphics-description = Voorinstelling voor het onderzoeken van grafische bugs in { -brand-shorter-name }.
profiler-popup-presets-graphics-label =
    .label = Grafisch
profiler-popup-presets-media-description2 = Voorinstelling voor het onderzoeken van audio- en videobugs in { -brand-shorter-name }.
profiler-popup-presets-media-label =
    .label = Media
profiler-popup-presets-networking-description = Voorinstelling voor het onderzoeken van netwerkbugs in { -brand-shorter-name }.
profiler-popup-presets-networking-label =
    .label = Netwerk
profiler-popup-presets-power-description = Voorinstelling voor het onderzoeken van stroomverbruikbugs in { -brand-shorter-name }, met lage overhead.
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = Vermogen
profiler-popup-presets-custom-label =
    .label = Aangepast

## History panel

appmenu-manage-history =
    .label = Geschiedenis beheren
appmenu-reopen-all-tabs = Alle tabbladen opnieuw openen
appmenu-reopen-all-windows = Alle vensters opnieuw openen
appmenu-restore-session =
    .label = Vorige sessie herstellen
appmenu-clear-history =
    .label = Recente geschiedenis wissen…
appmenu-recent-history-subheader = Recente geschiedenis
appmenu-recently-closed-tabs =
    .label = Onlangs gesloten tabbladen
appmenu-recently-closed-windows =
    .label = Onlangs gesloten vensters

## Help panel

appmenu-help-header =
    .title = { -brand-shorter-name } Help
appmenu-about =
    .label = Over { -brand-shorter-name }
    .accesskey = O
appmenu-get-help =
    .label = Hulp verkrijgen
    .accesskey = H
appmenu-help-more-troubleshooting-info =
    .label = Meer probleemoplossingsinformatie
    .accesskey = p
appmenu-help-report-site-issue =
    .label = Websiteprobleem melden…
appmenu-help-share-ideas =
    .label = Ideeën en feedback delen…
    .accesskey = f

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Probleemoplossingsmodus…
    .accesskey = u
appmenu-help-exit-troubleshoot-mode =
    .label = Probleemoplossingsmodus uitschakelen
    .accesskey = m

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Misleidende website rapporteren…
    .accesskey = M
appmenu-help-not-deceptive =
    .label = Dit is geen misleidende website…
    .accesskey = m

## More Tools

appmenu-customizetoolbar =
    .label = Werkbalk aanpassen…
appmenu-developer-tools-subheader = Browserhulpmiddelen
appmenu-developer-tools-extensions =
    .label = Extensies voor ontwikkelaars
