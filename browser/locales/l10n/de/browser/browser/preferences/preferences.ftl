# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Websites eine "Do Not Track"-Information senden, dass die eigenen Aktivitäten nicht verfolgt werden sollen
do-not-track-learn-more = Weitere Informationen
do-not-track-option-default-content-blocking-known =
    .label = Nur wenn { -brand-short-name } bekannte Elemente zur Aktivitätenverfolgung blockieren soll
do-not-track-option-always =
    .label = Immer
pref-page-title =
    { PLATFORM() ->
        [windows] Einstellungen
       *[other] Einstellungen
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
            [windows] In Einstellungen suchen
           *[other] In Einstellungen suchen
        }
settings-page-title = Einstellungen
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
    .placeholder = In Einstellungen suchen
managed-notice = Der Browser wird durch Ihre Organisation verwaltet.
category-list =
    .aria-label = Kategorien
pane-general-title = Allgemein
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Startseite
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Suche
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Datenschutz & Sicherheit
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-sync-title3 = Synchronisation
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = { -brand-short-name }-Experimente
category-experimental =
    .tooltiptext = { -brand-short-name }-Experimente
pane-experimental-subtitle = Vorsicht!
pane-experimental-search-results-header = { -brand-short-name } Experimente: Vorsicht!
pane-experimental-description2 = Das Ändern von erweiterten Konfigurationseinstellungen kann sich auf die Leistung und Sicherheit von { -brand-short-name } auswirken.
pane-experimental-reset =
    .label = Standard wiederherstellen
    .accesskey = w
help-button-label = Hilfe für { -brand-short-name }
addons-button-label = Erweiterungen & Themes
focus-search =
    .key = f
close-button =
    .aria-label = Schließen

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } muss neu gestartet werden, um diese Funktion zu aktivieren.
feature-disable-requires-restart = { -brand-short-name } muss neu gestartet werden, um diese Funktion zu deaktivieren.
should-restart-title = { -brand-short-name } neu starten
should-restart-ok = { -brand-short-name } jetzt neu starten
cancel-no-restart-button = Abbrechen
restart-later = Später neu starten

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
extension-controlled-homepage-override = Die Erweiterung "<img data-l10n-name="icon"/> { $name }" verwaltet die Startseite.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Die Erweiterung "<img data-l10n-name="icon"/> { $name }" verwaltet die Startseite neuer Tabs.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Die Erweiterung <img data-l10n-name="icon"/> { $name } kontrolliert diese Einstellung.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Die Erweiterung <img data-l10n-name="icon"/> { $name } kontrolliert diese Einstellung.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Die Erweiterung "<img data-l10n-name="icon"/> { $name }" hat die Standardsuchmaschine festgelegt.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Die Erweiterung <img data-l10n-name="icon"/> { $name } verwaltet die Tab-Umgebungen.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Die Erweiterung <img data-l10n-name="icon"/> { $name } kontrolliert diese Einstellung.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Die Erweiterung "<img data-l10n-name="icon"/> { $name }" kontrolliert, wie { -brand-short-name } mit dem Internet verbindet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Um die Erweiterung zu aktivieren, öffnen Sie das <img data-l10n-name="menu-icon"/> Menü und dann <img data-l10n-name="addons-icon"/> Add-ons.

## Preferences UI Search Results

search-results-header = Suchergebnisse
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Keine Treffer in den Einstellungen für "<span data-l10n-name="query"></span>".
       *[other] Keine Treffer in den Einstellungen für "<span data-l10n-name="query"></span>".
    }
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Keine Treffer in den Einstellungen für "<span data-l10n-name="query"></span>".
search-results-help-link = Benötigen Sie Hilfe? Dann besuchen Sie die <a data-l10n-name="url">Hilfeseite für { -brand-short-name }</a>.

## General Section

startup-header = Start
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Gleichzeitiges Ausführen von { -brand-short-name } und Firefox erlauben
use-firefox-sync = Tipp: Dabei werden getrennte Profile verwendet. Verwenden Sie { -sync-brand-short-name }, um Daten zwischen diesen zu synchronisieren.
get-started-not-logged-in = Bei { -sync-brand-short-name } anmelden…
get-started-configured = { -sync-brand-short-name }-Einstellungen öffnen
always-check-default =
    .label = Immer überprüfen, ob { -brand-short-name } der Standardbrowser ist
    .accesskey = p
is-default = { -brand-short-name } ist derzeit der Standardbrowser
is-not-default = { -brand-short-name } ist nicht Ihr Standardbrowser
set-as-my-default-browser =
    .label = Als Standard festlegen…
    .accesskey = g
startup-restore-previous-session =
    .label = Vorherige Sitzung wiederherstellen
    .accesskey = o
startup-restore-warn-on-quit =
    .label = Beim Beenden des Browsers warnen
disable-extension =
    .label = Erweiterung deaktivieren
tabs-group-header = Tabs
ctrl-tab-recently-used-order =
    .label = Bei Strg+Tab die Tabs nach letzter Nutzung in absteigender Reihenfolge anzeigen
    .accesskey = z
open-new-link-as-tabs =
    .label = Links in Tabs anstatt in neuen Fenstern öffnen
    .accesskey = T
warn-on-close-multiple-tabs =
    .label = Warnen, wenn mehrere Tabs geschlossen werden
    .accesskey = m
warn-on-open-many-tabs =
    .label = Warnen, wenn das gleichzeitige Öffnen mehrerer Tabs { -brand-short-name } verlangsamen könnte
    .accesskey = c
switch-links-to-new-tabs =
    .label = Tabs im Vordergrund öffnen
    .accesskey = V
switch-to-new-tabs =
    .label = Tabs im Vordergrund öffnen
    .accesskey = V
show-tabs-in-taskbar =
    .label = Tab-Vorschauen in der Windows-Taskleiste anzeigen
    .accesskey = k
browser-containers-enabled =
    .label = Tab-Umgebungen aktivieren
    .accesskey = a
browser-containers-learn-more = Weitere Informationen
browser-containers-settings =
    .label = Einstellungen…
    .accesskey = u
containers-disable-alert-title = Alle Tabs im Umgebungen schließen?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Falls die Funktion "Tab-Umgebungen" jetzt deaktiviert wird, so wird { $tabCount } Tab in einer Umgebung geschlossen. Soll die Funktion "Tab-Umgebungen" wirklich deaktiviert werden?
       *[other] Falls die Funktion "Tab-Umgebungen" jetzt deaktiviert wird, so werden { $tabCount } Tabs in Umgebungen geschlossen. Soll die Funktion "Tab-Umgebungen" wirklich deaktiviert werden?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] { $tabCount } Tab in einer Umgebung schließen
       *[other] { $tabCount } Tabs im Umgebungen schließen
    }
containers-disable-alert-cancel-button = Aktiviert belassen
containers-remove-alert-title = Diese Umgebung löschen?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Wenn diese Umgebung jetzt gelöscht wird, so wird { $count } Tab aus dieser Umgebung geschlossen. Soll diese Umgebung wirklich gelöscht werden?
       *[other] Wenn diese Umgebung jetzt gelöscht wird, so werden { $count } Tab aus dieser Umgebung geschlossen. Soll diese Umgebung wirklich gelöscht werden?
    }
containers-remove-ok-button = Umgebung löschen
containers-remove-cancel-button = Umgebung behalten

## General Section - Language & Appearance

language-and-appearance-header = Sprache und Erscheinungsbild
fonts-and-colors-header = Schriftarten & Farben
default-font = Standard-Schriftart
    .accesskey = S
default-font-size = Größe
    .accesskey = G
advanced-fonts =
    .label = Erweitert…
    .accesskey = E
colors-settings =
    .label = Farben…
    .accesskey = F
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Standard-Zoom
    .accesskey = Z
preferences-default-zoom-value =
    .label = { $percentage } %
preferences-zoom-text-only =
    .label = Nur Text zoomen
    .accesskey = T
language-header = Sprache
choose-language-description = Bevorzugte Sprachen für die Darstellung von Websites wählen
choose-button =
    .label = Wählen…
    .accesskey = W
choose-browser-language-description = Sprache für die Anzeige von Menüs, Mitteilungen und Benachrichtigungen von { -brand-short-name }
manage-browser-languages-button =
    .label = Alternative Sprachen festlegen…
    .accesskey = S
confirm-browser-language-change-description = { -brand-short-name } muss neu gestartet werden, um die Änderungen zu übernehmen.
confirm-browser-language-change-button = Anwenden und neu starten
translate-web-pages =
    .label = Web-Inhalte übersetzen
    .accesskey = z
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Übersetzung mittels <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Ausnahmen…
    .accesskey = u
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Einstellungen des Betriebssystems für "{ $localeName }" verwenden, um Datum, Uhrzeit, Zahlen und Maßeinheiten zu formatieren.
check-user-spelling =
    .label = Rechtschreibung während der Eingabe überprüfen
    .accesskey = R

## General Section - Files and Applications

files-and-applications-title = Dateien und Anwendungen
download-header = Downloads
download-save-to =
    .label = Alle Dateien in folgendem Ordner abspeichern:
    .accesskey = e
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Auswählen…
           *[other] Durchsuchen…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] u
           *[other] D
        }
download-always-ask-where =
    .label = Jedes Mal nachfragen, wo eine Datei gespeichert werden soll
    .accesskey = n
applications-header = Anwendungen
applications-description = Legen Sie fest, wie { -brand-short-name } mit Dateien verfährt, die Sie aus dem Web oder aus Anwendungen, die Sie beim Surfen verwenden, herunterladen.
applications-filter =
    .placeholder = Dateitypen oder Anwendungen suchen
applications-type-column =
    .label = Dateityp
    .accesskey = D
applications-action-column =
    .label = Aktion
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension }-Datei
applications-action-save =
    .label = Datei speichern
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Mit { $app-name } öffnen
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Mit { $app-name } öffnen (Standard)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] macOS-Standardanwendung verwenden
            [windows] Windows-Standardanwendung verwenden
           *[other] System-Standardanwendung verwenden
        }
applications-use-other =
    .label = Andere Anwendung…
applications-select-helper = Hilfsanwendung wählen
applications-manage-app =
    .label = Anwendungsdetails…
applications-always-ask =
    .label = Jedes Mal nachfragen
applications-type-pdf = Portable Document Format (PDF)
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
    .label = { $plugin-name } (in { -brand-short-name }) verwenden
applications-open-inapp =
    .label = In { -brand-short-name } öffnen

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

drm-content-header = Inhalte mit DRM-Kopierschutz
play-drm-content =
    .label = Inhalte mit DRM-Kopierschutz wiedergeben
    .accesskey = D
play-drm-content-learn-more = Weitere Informationen
update-application-title = { -brand-short-name }-Updates
update-application-description = { -brand-short-name } aktuell halten, um höchste Leistung, Stabilität und Sicherheit zu erfahren.
update-application-version = Version { $version } <a data-l10n-name="learn-more">Neue Funktionen und Änderungen</a>
update-history =
    .label = Update-Chronik anzeigen…
    .accesskey = C
update-application-allow-description = { -brand-short-name } erlauben
update-application-auto =
    .label = Updates automatisch zu installieren (empfohlen)
    .accesskey = U
update-application-check-choose =
    .label = Nach Updates zu suchen, aber vor der Installation nachfragen
    .accesskey = N
update-application-manual =
    .label = Nicht nach Updates suchen (nicht empfohlen)
    .accesskey = d
update-application-background-enabled =
    .label = Wenn { -brand-short-name } nicht ausgeführt wird
    .accesskey = W
update-application-warning-cross-user-setting = Diese Einstellung betrifft alle Windows-Konten und { -brand-short-name }-Profile, welche diese Installation von { -brand-short-name } verwenden.
update-application-use-service =
    .label = Einen Hintergrunddienst verwenden, um Updates zu installieren
    .accesskey = g
update-setting-write-failure-title = Fehler beim Speichern der Update-Einstellungen
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } bemerkte einen Fehler und hat diese Änderung nicht gespeichert. Das Setzen dieser Update-Einstellung benötigt Schreibrechte für die unten genannte Datei. Sie oder ein Systemadministrator können das Problem eventuell beheben, indem Sie der Gruppe "Benutzer" vollständige Kontrolle über die Datei gewähren.
    
    Konnte folgende Datei nicht speichern: { $path }
update-setting-write-failure-title2 = Fehler beim Speichern der Update-Einstellungen
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } bemerkte einen Fehler und hat diese Änderung nicht gespeichert. Das Ändern dieser Update-Einstellung benötigt Schreibrechte für die unten genannte Datei. Sie oder ein Systemadministrator können das Problem eventuell beheben, indem Sie der Gruppe "Benutzer" vollständige Kontrolle über die Datei gewähren.
    
    Konnte folgende Datei nicht speichern: { $path }
update-in-progress-title = Update wird durchgeführt
update-in-progress-message = Soll { -brand-short-name } mit dem Update fortfahren?
update-in-progress-ok-button = &Verwerfen
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Fortfahren

## General Section - Performance

performance-title = Leistung
performance-use-recommended-settings-checkbox =
    .label = Empfohlene Leistungseinstellungen verwenden
    .accesskey = E
performance-use-recommended-settings-desc = Diese Einstellungen sind für die Hardware und das Betriebssystem des Computers optimiert.
performance-settings-learn-more = Weitere Informationen
performance-allow-hw-accel =
    .label = Hardwarebeschleunigung verwenden, wenn verfügbar
    .accesskey = v
performance-limit-content-process-option = Maximale Anzahl an Inhaltsprozessen
    .accesskey = M
performance-limit-content-process-enabled-desc = Mehr Inhaltsprozesse verbessern die Leistung bei Verwendung mehrerer Tabs, aber nutzen auch mehr Arbeitsspeicher.
performance-limit-content-process-blocked-desc = Das Ändern der Anzahl der Inhaltsprozesse ist nur in { -brand-short-name } mit mehreren Prozessen möglich. <a data-l10n-name="learn-more">Wie Sie herausfinden, ob Firefox mit mehreren Prozessen ausgeführt wird</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (Standard)

## General Section - Browsing

browsing-title = Surfen
browsing-use-autoscroll =
    .label = Automatischen Bildlauf aktivieren
    .accesskey = A
browsing-use-smooth-scrolling =
    .label = Sanften Bildlauf aktivieren
    .accesskey = S
browsing-use-onscreen-keyboard =
    .label = Bildschirmtastatur falls notwendig anzeigen
    .accesskey = B
browsing-use-cursor-navigation =
    .label = Markieren von Text mit der Tastatur zulassen
    .accesskey = M
browsing-search-on-start-typing =
    .label = Beim Tippen automatisch im Seitentext suchen
    .accesskey = u
browsing-picture-in-picture-toggle-enabled =
    .label = Videosteuerung für Bild-im-Bild (PiP) anzeigen
    .accesskey = V
browsing-picture-in-picture-learn-more = Weitere Informationen
browsing-media-control =
    .label = Medien über Tastatur, Headset oder virtuelle Schnittstelle steuern
    .accesskey = e
browsing-media-control-learn-more = Weitere Informationen
browsing-cfr-recommendations =
    .label = Erweiterungen während des Surfens empfehlen
    .accesskey = h
browsing-cfr-features =
    .label = Funktionen während des Surfens empfehlen
    .accesskey = F
browsing-cfr-recommendations-learn-more = Weitere Informationen

## General Section - Proxy

network-settings-title = Verbindungs-Einstellungen
network-proxy-connection-description = Jetzt festlegen, wie sich { -brand-short-name } mit dem Internet verbindet.
network-proxy-connection-learn-more = Weitere Informationen
network-proxy-connection-settings =
    .label = Einstellungen…
    .accesskey = n

## Home Section

home-new-windows-tabs-header = Neue Fenster und Tabs
home-new-windows-tabs-description2 = Legen Sie fest, was als Startseite sowie in neuen Fenstern und Tabs geöffnet wird.

## Home Section - Home Page Customization

home-homepage-mode-label = Startseite und neue Fenster
home-newtabs-mode-label = Neue Tabs
home-restore-defaults =
    .label = Standard wiederherstellen
    .accesskey = w
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Waterfox-Startseite (Standard)
home-mode-choice-custom =
    .label = Benutzerdefinierte Adressen…
home-mode-choice-blank =
    .label = Leere Seite
home-homepage-custom-url =
    .placeholder = Adresse einfügen…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Aktuelle Seite verwenden
           *[other] Aktuelle Seiten verwenden
        }
    .accesskey = A
choose-bookmark =
    .label = Lesezeichen verwenden…
    .accesskey = L

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Inhalte des Firefox-Startbildschirms
home-prefs-content-description = Wählen Sie, welche Inhalte auf Ihrem Firefox-Startbildschirm angezeigt werden sollen.
home-prefs-search-header =
    .label = Internetsuche
home-prefs-topsites-header =
    .label = Wichtige Seiten
home-prefs-topsites-description = Die von Ihnen am meisten besuchten Websites
home-prefs-topsites-by-option-sponsored =
    .label = Gesponserte wichtige Seiten
home-prefs-shortcuts-header =
    .label = Verknüpfungen
home-prefs-shortcuts-description = Websites, die Sie speichern oder besuchen
home-prefs-shortcuts-by-option-sponsored =
    .label = Gesponserte Verknüpfungen

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Empfohlen von { $provider }
home-prefs-recommended-by-description-update = Besondere Inhalte aus dem ganzen Internet, ausgewählt von { $provider }
home-prefs-recommended-by-description-new = Besondere Inhalte ausgewählt von { $provider }, Teil der { -brand-product-name }-Familie

##

home-prefs-recommended-by-learn-more = Wie es funktioniert
home-prefs-recommended-by-option-sponsored-stories =
    .label = Gesponserte Inhalte
home-prefs-highlights-header =
    .label = Überblick
home-prefs-highlights-description = Eine Auswahl von Websites, die Sie gespeichert oder besucht haben
home-prefs-highlights-option-visited-pages =
    .label = Besuchte Seiten
home-prefs-highlights-options-bookmarks =
    .label = Lesezeichen
home-prefs-highlights-option-most-recent-download =
    .label = Neueste Downloads
home-prefs-highlights-option-saved-to-pocket =
    .label = Bei { -pocket-brand-name } gespeicherte Seiten
home-prefs-recent-activity-header =
    .label = Neueste Aktivität
home-prefs-recent-activity-description = Eine Auswahl kürzlich besuchter Websites und Inhalte
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Kurzinformationen
home-prefs-snippets-description = Neuigkeiten von { -vendor-short-name } und { -brand-product-name }
home-prefs-snippets-description-new = Tipps und Neuigkeiten von { -vendor-short-name } und { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } Zeile
           *[other] { $num } Zeilen
        }

## Search Section

search-bar-header = Suchleiste
search-bar-hidden =
    .label = Adressleiste für Suche und Seitenaufrufe verwenden
search-bar-shown =
    .label = Suchleiste zur Symbolleiste hinzufügen
search-engine-default-header = Standardsuchmaschine
search-engine-default-desc-2 = Das ist Ihre Standardsuchmaschine in der Adress- und Suchleiste. Sie können diese jederzeit ändern.
search-engine-default-private-desc-2 = Wählen Sie eine andere Standardsuchmaschine nur für private Fenster.
search-separate-default-engine =
    .label = Diese Suchmaschine in privaten Fenstern verwenden
    .accesskey = p
search-suggestions-header = Suchvorschläge
search-suggestions-desc = Wählen Sie, wie Suchvorschläge von Suchmaschinen angezeigt werden.
search-suggestions-option =
    .label = Suchvorschläge anzeigen
    .accesskey = S
search-show-suggestions-url-bar-option =
    .label = Suchvorschläge in Adressleiste anzeigen
    .accesskey = v
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = In Adressleiste Suchvorschläge vor Einträgen aus der Browser-Chronik anzeigen
search-show-suggestions-private-windows =
    .label = Suchvorschläge in privaten Fenstern anzeigen
suggestions-addressbar-settings-generic = Einstellungen für andere Vorschläge in der Adressleiste ändern
suggestions-addressbar-settings-generic2 = Einstellungen für andere Vorschläge in der Adressleiste ändern
search-suggestions-cant-show = Suchvorschläge werden nicht in der Adressleiste angezeigt, weil { -brand-short-name } angewiesen wurde, keine Chronik zu speichern.
search-one-click-header = Ein-Klick-Suchmaschinen
search-one-click-header2 = Suchmaschinen-Schlüsselwörter
search-one-click-desc = Wählen Sie die Suchmaschinen, welche unterhalb der Adress- bzw. Suchleiste angezeigt werden, nachdem Sie den Suchbegriff eingegeben haben.
search-choose-engine-column =
    .label = Suchmaschine
search-choose-keyword-column =
    .label = Schlüsselwort
search-restore-default =
    .label = Standardsuchmaschinen wiederherstellen
    .accesskey = w
search-remove-engine =
    .label = Entfernen
    .accesskey = E
search-add-engine =
    .label = Hinzufügen
    .accesskey = H
search-find-more-link = Weitere Suchmaschinen hinzufügen
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Schlüsselwort duplizieren
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Sie haben ein Schlüsselwort ausgewählt, das bereits von "{ $name }" verwendet wird, bitte wählen Sie ein anderes.
search-keyword-warning-bookmark = Sie haben ein Schlüsselwort ausgewählt, das bereits von einem Lesezeichen verwendet wird, bitte wählen Sie ein anderes.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Zurück zu den Einstellungen
           *[other] Zurück zu den Einstellungen
        }
containers-back-button2 =
    .aria-label = Zurück zu den Einstellungen
containers-header = Tab-Umgebungen
containers-add-button =
    .label = Neue Umgebung hinzufügen
    .accesskey = N
containers-new-tab-check =
    .label = Tab-Umgebung für jeden neuen Tab wählen
    .accesskey = w
containers-preferences-button =
    .label = Einstellungen
containers-settings-button =
    .label = Einstellungen
containers-remove-button =
    .label = Löschen

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = So haben Sie das Web überall dabei.
sync-signedout-description = Synchronisieren Sie Ihre Lesezeichen, Chronik, Tabs, Passwörter, Add-ons und Einstellungen zwischen allen Ihren Geräten.
sync-signedout-account-signin2 =
    .label = Bei { -sync-brand-short-name } anmelden…
    .accesskey = B
sync-signedout-description2 = Synchronisieren Sie Ihre Lesezeichen, Chronik, Tabs, Passwörter, Add-ons und Einstellungen zwischen allen Ihren Geräten.
sync-signedout-account-signin3 =
    .label = Zum Synchronisieren anmelden…
    .accesskey = S
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Waterfox für <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> oder <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> herunterladen, um mit Ihrem Handy zu synchronisieren.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Profilbild ändern
sync-sign-out =
    .label = Abmelden…
    .accesskey = b
sync-manage-account = Konto verwalten
    .accesskey = v
sync-signedin-unverified = { $email } wurde noch nicht bestätigt.
sync-signedin-login-failure = Melden Sie sich an, um erneut mit { $email } zu verbinden.
sync-resend-verification =
    .label = E-Mail zur Verifizierung erneut senden
    .accesskey = V
sync-remove-account =
    .label = Konto entfernen
    .accesskey = e
sync-sign-in =
    .label = Anmelden
    .accesskey = m

## Sync section - enabling or disabling sync.

prefs-syncing-on = Synchronisation: EIN
prefs-syncing-off = Synchronisation: AUS
prefs-sync-setup =
    .label = { -sync-brand-short-name } einrichten…
    .accesskey = e
prefs-sync-offer-setup-label = Synchronisieren Sie Ihre Lesezeichen, Chronik, Tabs, Passwörter, Add-ons und Einstellungen zwischen allen Ihren Geräten.
prefs-sync-turn-on-syncing =
    .label = Synchronisation aktivieren…
    .accesskey = S
prefs-sync-offer-setup-label2 = Synchronisieren Sie Ihre Lesezeichen, Chronik, Tabs, Passwörter, Add-ons und Einstellungen zwischen allen Ihren Geräten.
prefs-sync-now =
    .labelnotsyncing = Jetzt synchronisieren
    .accesskeynotsyncing = J
    .labelsyncing = Wird synchronisiert…

## The list of things currently syncing.

sync-currently-syncing-heading = Derzeit werden folgende Elemente synchronisiert:
sync-currently-syncing-bookmarks = Lesezeichen
sync-currently-syncing-history = Chronik
sync-currently-syncing-tabs = Offene Tabs
sync-currently-syncing-logins-passwords = Zugangsdaten und Passwörter
sync-currently-syncing-addresses = Adressen
sync-currently-syncing-creditcards = Kreditkarten
sync-currently-syncing-addons = Add-ons
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Einstellungen
       *[other] Einstellungen
    }
sync-currently-syncing-settings = Einstellungen
sync-change-options =
    .label = Ändern…
    .accesskey = Ä

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Auswählen, was synchronisiert wird
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Änderungen speichern
    .buttonaccesskeyaccept = s
    .buttonlabelextra2 = Trennen…
    .buttonaccesskeyextra2 = T
sync-engine-bookmarks =
    .label = Lesezeichen
    .accesskey = L
sync-engine-history =
    .label = Chronik
    .accesskey = C
sync-engine-tabs =
    .label = Offene Tabs
    .tooltiptext = Liste aller offenen Tabs von allen verbundenen Geräten
    .accesskey = T
sync-engine-logins-passwords =
    .label = Zugangsdaten und Passwörter
    .tooltiptext = Gespeicherte Benutzernamen und Passwörter
    .accesskey = Z
sync-engine-addresses =
    .label = Adressen
    .tooltiptext = Gespeicherte postalische Adressen (nur für Desktops)
    .accesskey = d
sync-engine-creditcards =
    .label = Kreditkarten
    .tooltiptext = Namen, Nummern und Gültigkeitsdatum (nur für Desktops)
    .accesskey = K
sync-engine-addons =
    .label = Add-ons
    .tooltiptext = Erweiterungen und Themes für Firefox für Desktops
    .accesskey = A
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Einstellungen
           *[other] Einstellungen
        }
    .tooltiptext = Durch Sie geänderte allgemeine, Datenschutz- und Sicherheitseinstellungen
    .accesskey = E
sync-engine-settings =
    .label = Einstellungen
    .tooltiptext = Durch Sie geänderte allgemeine, Datenschutz- und Sicherheitseinstellungen
    .accesskey = E

## The device name controls.

sync-device-name-header = Gerätename
sync-device-name-change =
    .label = Gerät umbenennen…
    .accesskey = u
sync-device-name-cancel =
    .label = Abbrechen
    .accesskey = b
sync-device-name-save =
    .label = Speichern
    .accesskey = S
sync-connect-another-device = Weiteres Gerät verbinden

## Privacy Section

privacy-header = Browser-Datenschutz

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Zugangsdaten und Passwörter
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Fragen, ob Zugangsdaten und Passwörter für Websites gespeichert werden sollen
    .accesskey = F
forms-exceptions =
    .label = Ausnahmen…
    .accesskey = u
forms-generate-passwords =
    .label = Starke Passwörter erzeugen und vorschlagen
    .accesskey = P
forms-breach-alerts =
    .label = Alarme für Passwörter, deren Websites von einem Datenleck betroffen waren
    .accesskey = A
forms-breach-alerts-learn-more-link = Weitere Informationen
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Zugangsdaten und Passwörter automatisch ausfüllen
    .accesskey = Z
forms-saved-logins =
    .label = Gespeicherte Zugangsdaten…
    .accesskey = G
forms-master-pw-use =
    .label = Master-Passwort verwenden
    .accesskey = v
forms-primary-pw-use =
    .label = Hauptpasswort verwenden
    .accesskey = v
forms-primary-pw-learn-more-link = Weitere Informationen
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Master-Passwort ändern…
    .accesskey = M
forms-master-pw-fips-title = Sie sind derzeit im FIPS-Modus. FIPS benötigt ein nicht leeres Master-Passwort.
forms-primary-pw-change =
    .label = Hauptpasswort ändern…
    .accesskey = H
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = Früher bekannt als Master-Passwort
forms-primary-pw-fips-title = Sie sind derzeit im FIPS-Modus. FIPS benötigt ein nicht leeres Hauptpasswort.
forms-master-pw-fips-desc = Ändern des Passworts fehlgeschlagen

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Um ein Master-Passwort zu erstellen, müssen die Anmeldedaten des Windows-Benutzerkontos eingegeben werden. Dies dient dem Schutz Ihrer Zugangsdaten.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = Master-Passwort festlegen
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Um ein Hauptpasswort zu erstellen, müssen die Anmeldedaten des Windows-Benutzerkontos eingegeben werden. Dies dient dem Schutz Ihrer Zugangsdaten.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Hauptpasswort festlegen
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Chronik
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name } wird eine Chronik
    .accesskey = F
history-remember-option-all =
    .label = anlegen
history-remember-option-never =
    .label = niemals anlegen
history-remember-option-custom =
    .label = nach benutzerdefinierten Einstellungen anlegen
history-remember-description = { -brand-short-name } wird die Adressen der besuchten Webseiten, Downloads sowie eingegebene Formular- und Suchdaten speichern.
history-dontremember-description = { -brand-short-name } wird dieselben Einstellungen wie im Privaten Modus verwenden und keinerlei Chronik anlegen, während Sie { -brand-short-name } benutzen.
history-private-browsing-permanent =
    .label = Immer den Privaten Modus verwenden
    .accesskey = M
history-remember-browser-option =
    .label = Besuchte Seiten und Download-Chronik speichern
    .accesskey = w
history-remember-search-option =
    .label = Eingegebene Suchbegriffe und Formulardaten speichern
    .accesskey = S
history-clear-on-close-option =
    .label = Die Chronik löschen, wenn { -brand-short-name } geschlossen wird
    .accesskey = g
history-clear-on-close-settings =
    .label = Einstellungen…
    .accesskey = E
history-clear-button =
    .label = Chronik löschen…
    .accesskey = C

## Privacy Section - Site Data

sitedata-header = Cookies und Website-Daten
sitedata-total-size-calculating = Größe von Website-Daten und Cache wird berechnet…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Die gespeicherten Cookies, Website-Daten und der Cache belegen derzeit { $value } { $unit } Speicherplatz.
sitedata-learn-more = Weitere Informationen
sitedata-delete-on-close =
    .label = Cookies und Website-Daten beim Beenden von { -brand-short-name } löschen
    .accesskey = B
sitedata-delete-on-close-private-browsing = Wenn der Private Modus immer verwendet wird, löscht { -brand-short-name } Cookies und Website-Daten beim Beenden.
sitedata-allow-cookies-option =
    .label = Annehmen von Cookies und Website-Daten
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Blockieren von Cookies und Website-Daten
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Typ blockiert
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Zur seitenübergreifenden Aktivitätenverfolgung
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Zur seitenübergreifenden Aktivitätenverfolgung und von sozialen Netzwerken
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Cookies zur seitenübergreifenden Aktivitätenverfolgung - einschließlich Cookies für soziale Netzwerke
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Seitenübergreifende Cookies - einschließlich Cookies für soziale Netzwerke
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Zur seitenübergreifenden Aktivitätenverfolgung und von sozialen Netzwerken, dabei verbleibende Cookies isolieren
sitedata-option-block-unvisited =
    .label = Cookies von nicht besuchten Websites
sitedata-option-block-all-third-party =
    .label = Alle Cookies von Drittanbietern (einige Websites funktionieren dann eventuell nicht mehr)
sitedata-option-block-all =
    .label = Alle Cookies (einige Websites funktionieren dann nicht mehr)
sitedata-clear =
    .label = Daten entfernen…
    .accesskey = e
sitedata-settings =
    .label = Daten verwalten…
    .accesskey = v
sitedata-cookies-permissions =
    .label = Berechtigungen verwalten…
    .accesskey = B
sitedata-cookies-exceptions =
    .label = Ausnahmen verwalten…
    .accesskey = u

## Privacy Section - Address Bar

addressbar-header = Adressleiste
addressbar-suggest = Beim Verwenden der Adressleiste Folgendes vorschlagen:
addressbar-locbar-history-option =
    .label = Einträge aus der Chronik
    .accesskey = C
addressbar-locbar-bookmarks-option =
    .label = Einträge aus den Lesezeichen
    .accesskey = L
addressbar-locbar-openpage-option =
    .label = Offene Tabs
    .accesskey = O
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Verknüpfungen
    .accesskey = V
addressbar-locbar-topsites-option =
    .label = Wichtige Seiten
    .accesskey = W
addressbar-locbar-engines-option =
    .label = Suchmaschinen
    .accesskey = a
addressbar-suggestions-settings = Einstellungen für Suchvorschläge ändern

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Verbesserter Schutz vor Aktivitätenverfolgung
content-blocking-section-top-level-description = Skripte zur Aktivitätenverfolgung folgen Ihnen und sammeln Informationen über Ihre Internet-Gewohnheiten und Interessen. { -brand-short-name } blockiert viele dieser Skripte zur Aktivitätenverfolgung und andere böswillige Skripte.
content-blocking-learn-more = Weitere Informationen
content-blocking-fpi-incompatibility-warning = Sie verwenden First Party Isolation (FPI), was einige der Cookie-Einstellungen von { -brand-short-name } überschreibt.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = S
enhanced-tracking-protection-setting-strict =
    .label = Streng
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Benutzerdefiniert
    .accesskey = B

##

content-blocking-etp-standard-desc = Ausgewogen zwischen Schutz und Leistung. Seiten laden normal.
content-blocking-etp-strict-desc = Stärkerer Schutz, einige Websites oder mancher Inhalt funktioniert eventuell nicht.
content-blocking-etp-custom-desc = Wählen Sie, welche Art von Skripten zur Aktivitätenverfolgung und sonstige Inhalte blockiert werden.
content-blocking-etp-blocking-desc = { -brand-short-name } blockiert Folgendes:
content-blocking-private-windows = Inhalte zur Aktivitätenverfolgung in privaten Fenstern
content-blocking-cross-site-cookies-in-all-windows = Seitenübergreifende Cookies in allen Fenstern (einschließlich Cookies zur Aktivitätenverfolgung)
content-blocking-cross-site-tracking-cookies = Cookies zur seitenübergreifenden Aktivitätenverfolgung
content-blocking-all-cross-site-cookies-private-windows = Seitenübergreifende Cookies in privaten Fenstern
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookies zur seitenübergreifenden Aktivitätenverfolgung, dabei verbleibende Cookies isolieren
content-blocking-social-media-trackers = Skripte zur Aktivitätenverfolgung durch soziale Netzwerke
content-blocking-all-cookies = Alle Cookies
content-blocking-unvisited-cookies = Cookies von nicht besuchten Websites
content-blocking-all-windows-tracking-content = Inhalte zur Aktivitätenverfolgung in allen Fenstern
content-blocking-all-third-party-cookies = Alle Cookies von Drittanbietern
content-blocking-cryptominers = Heimliche Digitalwährungsberechner (Krypto-Miner)
content-blocking-fingerprinters = Identifizierer (Fingerprinter)
content-blocking-warning-title = Achtung!
content-blocking-and-isolating-etp-warning-description = Das Blockieren von Skripten zur Aktivitätenverfolgung und das Isolieren von Cookies kann Auswirkungen auf das Funktionieren einiger Websites haben. Laden Sie eine Seite einschließlich Skripten zur Aktivitätenverfolgung neu, damit der komplette Inhalt geladen wird.
content-blocking-and-isolating-etp-warning-description-2 = Diese Einstellung kann dazu führen, dass einige Websites nicht korrekt Inhalte anzeigen oder funktionieren. Wenn eine Website defekt zu sein scheint, können Sie den Schutz vor Aktivitätenverfolgung für diese Website deaktivieren, um alle Inhalte zu laden.
content-blocking-warning-learn-how = Weitere Informationen
content-blocking-reload-description = Um die Änderungen anzuwenden, müssen alle Tabs neu geladen werden.
content-blocking-reload-tabs-button =
    .label = Alle Tabs neu laden
    .accesskey = T
content-blocking-tracking-content-label =
    .label = Inhalte zur Aktivitätenverfolgung
    .accesskey = n
content-blocking-tracking-protection-option-all-windows =
    .label = In allen Fenstern
    .accesskey = a
content-blocking-option-private =
    .label = Nur in privaten Fenstern
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Blockierliste ändern
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Weitere Informationen
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Heimliche Digitalwährungsberechner (Krypto-Miner)
    .accesskey = w
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Identifizierer (Fingerprinter)
    .accesskey = d

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Ausnahmen verwalten…
    .accesskey = v

## Privacy Section - Permissions

permissions-header = Berechtigungen
permissions-location = Standort
permissions-location-settings =
    .label = Einstellungen…
    .accesskey = E
permissions-xr = Virtuelle Realität
permissions-xr-settings =
    .label = Einstellungen…
    .accesskey = E
permissions-camera = Kamera
permissions-camera-settings =
    .label = Einstellungen…
    .accesskey = E
permissions-microphone = Mikrofon
permissions-microphone-settings =
    .label = Einstellungen…
    .accesskey = E
permissions-notification = Benachrichtigungen
permissions-notification-settings =
    .label = Einstellungen…
    .accesskey = E
permissions-notification-link = Weitere Informationen
permissions-notification-pause =
    .label = Benachrichtigungen bis zum Neustart von { -brand-short-name } deaktivieren
    .accesskey = n
permissions-autoplay = Automatische Wiedergabe
permissions-autoplay-settings =
    .label = Einstellungen…
    .accesskey = E
permissions-block-popups =
    .label = Pop-up-Fenster blockieren
    .accesskey = P
permissions-block-popups-exceptions =
    .label = Ausnahmen…
    .accesskey = A
permissions-addon-install-warning =
    .label = Warnen, wenn Websites versuchen, Add-ons zu installieren
    .accesskey = W
permissions-addon-exceptions =
    .label = Ausnahmen…
    .accesskey = A
permissions-a11y-privacy-checkbox =
    .label = Externen Anwendungen den Zugriff auf den Dienst für Barrierefreiheit in Firefox verweigern
    .accesskey = B
permissions-a11y-privacy-link = Weitere Informationen

## Privacy Section - Data Collection

collection-header = Datenerhebung durch { -brand-short-name } und deren Verwendung
collection-description = Wir lassen Ihnen die Wahl, ob Sie uns Daten senden, und sammeln nur die Daten, welche erforderlich sind, um { -brand-short-name } für jeden anbieten und verbessern zu können. Wir fragen immer um Ihre Erlaubnis, bevor wir persönliche Daten senden.
collection-privacy-notice = Datenschutzhinweis
collection-health-report-telemetry-disabled = Sie gestatten { -vendor-short-name } nicht mehr, technische und Interaktionsdaten zu erfassen. Alle bisherigen Daten werden innerhalb von 30 Tagen gelöscht.
collection-health-report-telemetry-disabled-link = Weitere Informationen
collection-health-report =
    .label = { -brand-short-name } erlauben, Daten zu technischen Details und Interaktionen an { -vendor-short-name } zu senden
    .accesskey = t
collection-health-report-link = Weitere Informationen
collection-studies =
    .label = { -brand-short-name } das Installieren und Durchführen von Studien erlauben
collection-studies-link = { -brand-short-name }-Studien ansehen
addon-recommendations =
    .label = Personalisierte Erweiterungsempfehlungen durch { -brand-short-name } erlauben
addon-recommendations-link = Weitere Informationen
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datenübermittlung ist für diese Build-Konfiguration deaktiviert
collection-backlogged-crash-reports =
    .label = Nicht gesendete Absturzberichte automatisch von { -brand-short-name } senden lassen
    .accesskey = g
collection-backlogged-crash-reports-link = Weitere Informationen
collection-backlogged-crash-reports-with-link = Nicht gesendete Absturzberichte automatisch von { -brand-short-name } senden lassen <a data-l10n-name="crash-reports-link">Weitere Informationen</a>
    .accesskey = g

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Sicherheit
security-browsing-protection = Schutz vor betrügerischen Inhalten und gefährlicher Software
security-enable-safe-browsing =
    .label = Gefährliche und betrügerische Inhalte blockieren
    .accesskey = b
security-enable-safe-browsing-link = Weitere Informationen
security-block-downloads =
    .label = Gefährliche Downloads blockieren
    .accesskey = D
security-block-uncommon-software =
    .label = Vor unerwünschter und ungewöhnlicher Software warnen
    .accesskey = S

## Privacy Section - Certificates

certs-header = Zertifikate
certs-personal-label = Wenn eine Website nach dem persönlichen Sicherheitszertifikat verlangt
certs-select-auto-option =
    .label = Automatisch eins wählen
    .accesskey = w
certs-select-ask-option =
    .label = Jedes Mal fragen
    .accesskey = J
certs-enable-ocsp =
    .label = Aktuelle Gültigkeit von Zertifikaten durch Anfrage bei OCSP-Server bestätigen lassen
    .accesskey = G
certs-view =
    .label = Zertifikate anzeigen…
    .accesskey = Z
certs-devices =
    .label = Kryptographie-Module…
    .accesskey = K
space-alert-learn-more-button =
    .label = Weitere Informationen
    .accesskey = W
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Einstellungen öffnen
           *[other] Einstellungen öffnen
        }
    .accesskey =
        { PLATFORM() ->
            [windows] E
           *[other] E
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } hat nur noch wenig Speicherplatz zur Verfügung. Webinhalte werden eventuell nicht richtig angezeigt. Sie können gespeicherte Daten im Menü Einstellungen > Datenschutz & Sicherheit > Cookies und Website-Daten löschen.
       *[other] { -brand-short-name } verfügt über nur noch wenig freien Speicherplatz. Website-Inhalte werden vielleicht nicht richtig angezeigt. Sie können gespeicherte Daten im Menü Einstellungen > Datenschutz & Sicherheit > Cookies und Website-Daten löschen.
    }
space-alert-under-5gb-ok-button =
    .label = OK
    .accesskey = O
space-alert-under-5gb-message = { -brand-short-name } verfügt über nur noch wenig freien Speicherplatz. Website-Inhalte werden vielleicht nicht richtig angezeigt. Besuchen Sie "Weitere Informationen", um die Speichernutzung für ein besseres Weberlebnis zu optimieren.
space-alert-over-5gb-settings-button =
    .label = Einstellungen öffnen
    .accesskey = E
space-alert-over-5gb-message2 = <strong>{ -brand-short-name } verfügt über nur noch wenig freien Speicherplatz.</strong> Website-Inhalte werden vielleicht nicht richtig angezeigt. Sie können gespeicherte Daten im Menü Einstellungen > Datenschutz & Sicherheit > Cookies und Website-Daten löschen.
space-alert-under-5gb-message2 = <strong>{ -brand-short-name } verfügt über nur noch wenig freien Speicherplatz.</strong> Website-Inhalte werden vielleicht nicht richtig angezeigt. Besuchen Sie "Weitere Informationen", um die Speichernutzung für ein besseres Weberlebnis zu optimieren.

## Privacy Section - HTTPS-Only

httpsonly-header = Nur-HTTPS-Modus
httpsonly-description = HTTPS bietet eine sichere, verschlüsselte Verbindung zwischen { -brand-short-name } und den von Ihnen besuchten Websites. Die meisten Websites unterstützen HTTPS und wenn der Nur-HTTPS-Modus aktiviert ist, wird { -brand-short-name } alle Verbindungen zu HTTPS aufrüsten.
httpsonly-learn-more = Weitere Informationen
httpsonly-radio-enabled =
    .label = Nur-HTTPS-Modus in allen Fenstern aktivieren
httpsonly-radio-enabled-pbm =
    .label = Nur-HTTPS-Modus nur in privaten Fenstern aktivieren
httpsonly-radio-disabled =
    .label = Nur-HTTPS-Modus nicht aktivieren

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Downloads
choose-download-folder-title = Download-Ordner wählen:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Speichert Dateien in { $service-name }
