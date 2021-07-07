# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = Hämtar uppdatering av { -brand-shorter-name }
    .label-update-available = Uppdatering tillgänglig — hämta nu
    .label-update-manual = Uppdatering tillgänglig — hämta nu
    .label-update-unsupported = Uppdatering misslyckades — systemet är inte kompatibelt
    .label-update-restart = Uppdatering tillgänglig — starta om nu
appmenuitem-protection-dashboard-title = Säkerhetsöversikt
appmenuitem-new-tab =
    .label = Ny flik
appmenuitem-new-window =
    .label = Nytt fönster
appmenuitem-new-private-window =
    .label = Nytt privat fönster
appmenuitem-history =
    .label = Historik
appmenuitem-downloads =
    .label = Filhämtaren
appmenuitem-passwords =
    .label = Lösenord
appmenuitem-addons-and-themes =
    .label = Tillägg och teman
appmenuitem-print =
    .label = Skriv ut…
appmenuitem-find-in-page =
    .label = Hitta på sidan…
appmenuitem-zoom =
    .value = Zoom
appmenuitem-more-tools =
    .label = Fler verktyg
appmenuitem-help =
    .label = Hjälp
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Avsluta
           *[other] Avsluta
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Öppna applikationsmeny
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Stäng applikationsmeny
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Inställningar

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Zooma in
appmenuitem-zoom-reduce =
    .label = Zooma ut
appmenuitem-fullscreen =
    .label = Helskärm

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Logga in för att synkronisera…
appmenu-remote-tabs-turn-on-sync =
    .label = Aktivera synkronisering…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Visa fler flikar
    .tooltiptext = Visa flikar från denna enhet
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Inga öppna flikar
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Slå på fliksynkronisering för att visa en lista med flikar från dina andra enheter.
appmenu-remote-tabs-opensettings =
    .label = Inställningar
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Vill du se dina flikar från andra enheter här?
appmenu-remote-tabs-connectdevice =
    .label = Anslut en annan enhet
appmenu-remote-tabs-welcome = Visa en lista med flikar från dina andra enheter.
appmenu-remote-tabs-unverified = Ditt konto behöver verifieras.
appmenuitem-fxa-toolbar-sync-now2 = Synkronisera nu
appmenuitem-fxa-sign-in = Logga in på { -brand-product-name }
appmenuitem-fxa-manage-account = Hantera konto
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Senast synkroniserad { $time }
    .label = Senast synkroniserad { $time }
appmenu-fxa-sync-and-save-data2 = Synkronisera och spara data
appmenu-fxa-signed-in-label = Logga in
appmenu-fxa-setup-sync =
    .label = Aktivera synkronisering…
appmenu-fxa-show-more-tabs = Visa fler flikar
appmenuitem-save-page =
    .label = Spara sida som…

## What's New panel in App menu.

whatsnew-panel-header = Vad är nytt
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Meddela om nya funktioner
    .accesskey = f

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Profiler
    .tooltiptext = Spela in en prestationsprofil
profiler-popup-button-recording =
    .label = Profilerare
    .tooltiptext = Profileraren spelar in en profil
profiler-popup-button-capturing =
    .label = Profilerare
    .tooltiptext = Profileraren fångar en profil
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Avslöja mer information
profiler-popup-description-title =
    .value = Spela in, analysera, dela
profiler-popup-description = Samarbeta om prestandafrågor genom att publicera profiler för att dela med ditt team.
profiler-popup-learn-more = Läs mer
profiler-popup-learn-more-button =
    .label = Läs mer
profiler-popup-settings =
    .value = Inställningar
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Redigera inställningar…
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Redigera inställningar…
profiler-popup-disabled =
    Profilen är för närvarande inaktiverad, troligtvis på grund av att ett privat webbläsarfönster
    är öppet.
profiler-popup-recording-screen = Spelar in…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Anpassad
profiler-popup-start-recording-button =
    .label = Starta inspelning
profiler-popup-discard-button =
    .label = Släng
profiler-popup-capture-button =
    .label = Fånga
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

profiler-popup-presets-web-developer-description = Rekommenderad förinställning för de flesta webbappfelsökningar, med lite pålägg.
profiler-popup-presets-web-developer-label =
    .label = Webbutvecklare
profiler-popup-presets-firefox-platform-description = Rekommenderad förinställning för intern felsökning av plattformar i Waterfox.
profiler-popup-presets-firefox-platform-label =
    .label = Waterfox - Plattform
profiler-popup-presets-firefox-front-end-description = Rekommenderad förinställning för intern felsökning av front-end i Waterfox.
profiler-popup-presets-firefox-front-end-label =
    .label = Waterfox - Front-End
profiler-popup-presets-firefox-graphics-description = Rekommenderad förinställning för utredning av grafikprestanda i Waterfox.
profiler-popup-presets-firefox-graphics-label =
    .label = Waterfox - Grafik
profiler-popup-presets-media-description = Rekommenderad förinställning för diagnos av ljud- och videoproblem.
profiler-popup-presets-media-label =
    .label = Media
profiler-popup-presets-custom-label =
    .label = Anpassad

## History panel

appmenu-manage-history =
    .label = Hantera historik
appmenu-reopen-all-tabs = Återöppna alla flikar
appmenu-reopen-all-windows = Återöppna alla fönster
appmenu-restore-session =
    .label = Återställ föregående session
appmenu-clear-history =
    .label = Rensa ut tidigare historik…
appmenu-recent-history-subheader = Senaste historik
appmenu-recently-closed-tabs =
    .label = Nyligen stängda flikar
appmenu-recently-closed-windows =
    .label = Nyligen stängda fönster

## Help panel

appmenu-help-header =
    .title = { -brand-shorter-name } Hjälp
appmenu-about =
    .label = Om { -brand-shorter-name }
    .accesskey = O
appmenu-get-help =
    .label = Få hjälp
    .accesskey = h
appmenu-help-more-troubleshooting-info =
    .label = Mer felsökningsinformation
    .accesskey = f
appmenu-help-report-site-issue =
    .label = Rapportera webbplatsproblem…
appmenu-help-feedback-page =
    .label = Skicka in feedback…
    .accesskey = k

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Felsökningsläge…
    .accesskey = F
appmenu-help-exit-troubleshoot-mode =
    .label = Stäng av felsökningsläge
    .accesskey = g

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Rapportera vilseledande webbplats…
    .accesskey = d
appmenu-help-not-deceptive =
    .label = Detta är inte en vilseledande webbplats…
    .accesskey = v

## More Tools

appmenu-customizetoolbar =
    .label = Anpassa verktygsfält…
appmenu-taskmanager =
    .label = Aktivitetshanterare
appmenu-developer-tools-subheader = Webbläsarverktyg
appmenu-developer-tools-extensions =
    .label = Tillägg för utvecklare
