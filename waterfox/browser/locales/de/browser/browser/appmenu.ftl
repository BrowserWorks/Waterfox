# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = { -brand-shorter-name }-Update wird heruntergeladen
appmenuitem-banner-update-available =
    .label = Update verfügbar – jetzt herunterladen
appmenuitem-banner-update-manual =
    .label = Update verfügbar – jetzt herunterladen
appmenuitem-banner-update-unsupported =
    .label = Update nicht möglich – System nicht kompatibel
appmenuitem-banner-update-restart =
    .label = Update verfügbar – jetzt neu starten
appmenuitem-new-tab =
    .label = Neuer Tab
appmenuitem-new-window =
    .label = ­Neues Fenster
appmenuitem-new-private-window =
    .label = Neues privates Fenster
appmenuitem-history =
    .label = Chronik
appmenuitem-downloads =
    .label = Downloads
appmenuitem-passwords =
    .label = Passwörter
appmenuitem-addons-and-themes =
    .label = Add-ons und Themes
appmenuitem-print =
    .label = Drucken…
appmenuitem-find-in-page =
    .label = In Seite suchen…
appmenuitem-zoom =
    .value = Zoom
appmenuitem-more-tools =
    .label = Weitere Werkzeuge
appmenuitem-help =
    .label = Hilfe
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Beenden
           *[other] Beenden
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Anwendungsmenü öffnen
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Anwendungsmenü schließen
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Einstellungen

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Vergrößern
appmenuitem-zoom-reduce =
    .label = Verkleinern
appmenuitem-fullscreen =
    .label = Vollbild

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Zum Synchronisieren anmelden…
appmenu-remote-tabs-turn-on-sync =
    .label = Synchronisation aktivieren…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Weitere Tabs anzeigen
    .tooltiptext = Mehr Tabs von diesem Gerät anzeigen
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Keine offenen Tabs
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Aktivieren Sie das Synchronisieren von Tabs, um eine Liste der Tabs auf Ihren anderen Geräten zu sehen.
appmenu-remote-tabs-opensettings =
    .label = Einstellungen
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Wollen Sie Ihre Tabs von Ihren anderen Geräten hier angezeigt bekommen?
appmenu-remote-tabs-connectdevice =
    .label = Weiteres Gerät verbinden
appmenu-remote-tabs-welcome = Zeigt eine Liste der Tabs von Ihren anderen Geräten an.
appmenu-remote-tabs-unverified = Ihr Konto muss verifiziert werden.
appmenuitem-fxa-toolbar-sync-now2 = Jetzt synchronisieren
appmenuitem-fxa-sign-in = Bei { -brand-product-name } anmelden
appmenuitem-fxa-manage-account = Konto verwalten
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Zuletzt synchronisiert { $time }
    .label = Zuletzt synchronisiert { $time }
appmenu-fxa-sync-and-save-data2 = Daten synchronisieren und speichern
appmenu-fxa-signed-in-label = Anmelden
appmenu-fxa-setup-sync =
    .label = Synchronisation aktivieren…
appmenuitem-save-page =
    .label = Seite speichern unter…

## What's New panel in App menu.

whatsnew-panel-header = Neue Funktionen und Änderungen
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Über neue Funktionen benachrichtigen
    .accesskey = b

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Leistungsanalyse
    .tooltiptext = Profil für die Leistungsanalyse aufnehmen
profiler-popup-button-recording =
    .label = Leistungsanalyse
    .tooltiptext = Der Profiler nimmt ein Profil auf.
profiler-popup-button-capturing =
    .label = Leistungsanalyse
    .tooltiptext = Der Profiler speichert ein Profil.
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Weitere Informationen anzeigen
profiler-popup-description-title =
    .value = Aufzeichnen, analysieren, teilen
profiler-popup-description = Arbeiten Sie bei Leistungsproblemen zusammen, indem Sie Profile veröffentlichen, die Sie Ihrem Team zur Verfügung stellen.
profiler-popup-learn-more-button =
    .label = Weitere Informationen
profiler-popup-settings =
    .value = Einstellungen
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Einstellungen bearbeiten…
profiler-popup-recording-screen = Aufzeichnung wird durchgeführt…
profiler-popup-start-recording-button =
    .label = Aufzeichnung starten
profiler-popup-discard-button =
    .label = Verwerfen
profiler-popup-capture-button =
    .label = Speichern
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Strg+Umschalt+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Strg+Umschalt+2
    }

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = Empfohlene Voreinstellung für das Debuggen der meisten Web-Apps mit geringem Overhead.
profiler-popup-presets-web-developer-label =
    .label = Web-Entwickler
profiler-popup-presets-firefox-description = Empfohlene Voreinstellung für die Leistungsanalyse von { -brand-shorter-name }.
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }
profiler-popup-presets-graphics-description = Voreinstellung zur Untersuchung von Grafikproblemen in { -brand-shorter-name }.
profiler-popup-presets-graphics-label =
    .label = Grafik
profiler-popup-presets-media-description2 = Voreinstellung für die Untersuchung von Audio- und Videoproblemen in { -brand-shorter-name }.
profiler-popup-presets-media-label =
    .label = Medien
profiler-popup-presets-networking-description = Voreinstellung für die Untersuchung von Problemen mit Netzwerkverbindungen in { -brand-shorter-name }.
profiler-popup-presets-networking-label =
    .label = Netzwerkverbindungen
profiler-popup-presets-power-description = Voreinstellung für die Untersuchung von Problemen beim Energieverbrauch in { -brand-shorter-name }, mit geringem Overhead.
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = Leistung
profiler-popup-presets-custom-label =
    .label = Benutzerdefiniert

## History panel

appmenu-manage-history =
    .label = Chronik verwalten
appmenu-reopen-all-tabs = Alle Tabs wieder öffnen
appmenu-reopen-all-windows = Alle Fenster wieder öffnen
appmenu-restore-session =
    .label = Vorherige Sitzung wiederherstellen
appmenu-clear-history =
    .label = Neueste Chronik löschen…
appmenu-recent-history-subheader = Neueste Chronik
appmenu-recently-closed-tabs =
    .label = Kürzlich geschlossene Tabs
appmenu-recently-closed-windows =
    .label = Kürzlich geschlossene Fenster

## Help panel

appmenu-help-header =
    .title = { -brand-shorter-name }-Hilfe
appmenu-about =
    .label = Über { -brand-shorter-name }
    .accesskey = e
appmenu-get-help =
    .label = Hilfe erhalten
    .accesskey = H
appmenu-help-more-troubleshooting-info =
    .label = Weitere Informationen zur Fehlerbehebung
    .accesskey = W
appmenu-help-report-site-issue =
    .label = Seitenproblem melden…
appmenu-help-share-ideas =
    .label = Ideen und Feedback teilen…
    .accesskey = I

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Fehlerbehebungsmodus…
    .accesskey = F
appmenu-help-exit-troubleshoot-mode =
    .label = Fehlerbehebungsmodus deaktivieren
    .accesskey = F

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Betrügerische Website melden…
    .accesskey = m
appmenu-help-not-deceptive =
    .label = Dies ist keine betrügerische Website…
    .accesskey = g

## More Tools

appmenu-customizetoolbar =
    .label = Symbolleiste anpassen…
appmenu-developer-tools-subheader = Browser-Werkzeuge
appmenu-developer-tools-extensions =
    .label = Erweiterungen für Entwickler
