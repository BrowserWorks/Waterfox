# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Websites eine "Do Not Track"-Information senden, dass die eigenen Aktivitäten nicht verfolgt werden sollen
do-not-track-description2 =
    .label = Websites eine "Do Not Track"-Anfrage senden
    .accesskey = d
do-not-track-learn-more = Weitere Informationen
do-not-track-option-default-content-blocking-known =
    .label = Nur wenn { -brand-short-name } bekannte Elemente zur Aktivitätenverfolgung blockieren soll
do-not-track-option-always =
    .label = Immer
global-privacy-control-description =
    .label = Websites anweisen, meine Daten nicht zu verkaufen oder weiterzugeben
    .accesskey = s
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
##   $name (string) - Name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlling-password-saving = <img data-l10n-name="icon"/> <strong>{ $name }</strong> kontrolliert diese Einstellung.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlling-web-notifications = <img data-l10n-name="icon"/> <strong>{ $name }</strong> kontrolliert diese Einstellung.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlling-privacy-containers = <img data-l10n-name="icon"/> <strong>{ $name }</strong> verwaltet die Tab-Umgebungen.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlling-websites-content-blocking-all-trackers = <img data-l10n-name="icon"/> <strong>{ $name }</strong> kontrolliert diese Einstellung.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlling-proxy-config = <img data-l10n-name ="icon"/> <strong>{ $name }</strong> kontrolliert, wie sich { -brand-short-name } mit dem Internet verbindet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Um die Erweiterung zu aktivieren, öffnen Sie das <img data-l10n-name="menu-icon"/> Menü und dann <img data-l10n-name="addons-icon"/> Add-ons.

## Preferences UI Search Results

search-results-header = Suchergebnisse
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Keine Treffer in den Einstellungen für "<span data-l10n-name="query"></span>".
search-results-help-link = Benötigen Sie Hilfe? Dann besuchen Sie die <a data-l10n-name="url">Hilfeseite für { -brand-short-name }</a>.

## General Section

startup-header = Start
always-check-default =
    .label = Immer überprüfen, ob { -brand-short-name } der Standardbrowser ist
    .accesskey = p
is-default = { -brand-short-name } ist derzeit der Standardbrowser
is-not-default = { -brand-short-name } ist nicht Ihr Standardbrowser
set-as-my-default-browser =
    .label = Als Standard festlegen…
    .accesskey = g
startup-restore-windows-and-tabs =
    .label = Vorherige Fenster und Tabs öffnen
    .accesskey = o
startup-restore-warn-on-quit =
    .label = Beim Beenden des Browsers warnen
disable-extension =
    .label = Erweiterung deaktivieren
preferences-data-migration-header = Browserdaten importieren
preferences-data-migration-description = Lesezeichen, Passwörter, Chronik und Daten für automatisches Ausfüllen in { -brand-short-name } importieren
preferences-data-migration-button =
    .label = Daten importieren
    .accesskey = m
tabs-group-header = Tabs
ctrl-tab-recently-used-order =
    .label = Bei Strg+Tab die Tabs nach letzter Nutzung in absteigender Reihenfolge anzeigen
    .accesskey = z
open-new-link-as-tabs =
    .label = Links in Tabs anstatt in neuen Fenstern öffnen
    .accesskey = T
confirm-on-close-multiple-tabs =
    .label = Bestätigen, bevor mehrere Tabs geschlossen werden
    .accesskey = m
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (string) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Bestätigen, bevor mit { $quitKey } beendet wird
    .accesskey = B
warn-on-open-many-tabs =
    .label = Warnen, wenn das gleichzeitige Öffnen mehrerer Tabs { -brand-short-name } verlangsamen könnte
    .accesskey = c
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

## Variables:
##   $tabCount (number) - Number of tabs

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

##

containers-disable-alert-cancel-button = Aktiviert belassen
containers-remove-alert-title = Diese Umgebung löschen?
# Variables:
#   $count (number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Wenn diese Umgebung jetzt gelöscht wird, so wird { $count } Tab aus dieser Umgebung geschlossen. Soll diese Umgebung wirklich gelöscht werden?
       *[other] Wenn diese Umgebung jetzt gelöscht wird, so werden { $count } Tab aus dieser Umgebung geschlossen. Soll diese Umgebung wirklich gelöscht werden?
    }
containers-remove-ok-button = Umgebung löschen
containers-remove-cancel-button = Umgebung behalten

## General Section - Language & Appearance

language-and-appearance-header = Sprache und Erscheinungsbild
preferences-web-appearance-header = Erscheinungsbild von Websites
preferences-web-appearance-description = Einige Websites passen ihr Farbschema basierend auf Ihren Einstellungen an. Wählen Sie aus, welches Farbschema Sie für diese Websites verwenden möchten.
preferences-web-appearance-choice-auto = Automatisch
preferences-web-appearance-choice-light = Hell
preferences-web-appearance-choice-dark = Dunkel
preferences-web-appearance-choice-tooltip-auto =
    .title = Automatisch die Seitenhintergründe und -inhalte auf der Grundlage von Systemeinstellungen und { -brand-short-name }-Theme anpassen
preferences-web-appearance-choice-tooltip-light =
    .title = Ein helles Erscheinungsbild für Hintergründe und Inhalte von Websites verwenden
preferences-web-appearance-choice-tooltip-dark =
    .title = Ein dunkles Erscheinungsbild für Hintergründe und Inhalte von Websites verwenden
preferences-web-appearance-choice-input-auto =
    .aria-description = { preferences-web-appearance-choice-tooltip-auto.title }
preferences-web-appearance-choice-input-light =
    .aria-description = { preferences-web-appearance-choice-tooltip-light.title }
preferences-web-appearance-choice-input-dark =
    .aria-description = { preferences-web-appearance-choice-tooltip-dark.title }
# This can appear when using windows HCM or "Override colors: always" without
# system colors.
preferences-web-appearance-override-warning = Ihre Farbauswahl überschreibt das Erscheinungsbild von Websites. <a data-l10n-name="colors-link">Farben verwalten</a>
# This message contains one link. It can be moved within the sentence as needed
# to adapt to your language, but should not be changed.
preferences-web-appearance-footer = Verwalten Sie { -brand-short-name }-Themes in <a data-l10n-name="themes-link">Erweiterungen & Themes</a>.
preferences-colors-header = Farben
preferences-colors-description = Standardfarben von { -brand-short-name } für Text, Website-Hintergründe und Links überschreiben
preferences-colors-manage-button =
    .label = Farben verwalten…
    .accesskey = F
preferences-fonts-header = Schriftarten
default-font = Standard-Schriftart
    .accesskey = S
default-font-size = Größe
    .accesskey = G
advanced-fonts =
    .label = Erweitert…
    .accesskey = E
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Standard-Zoom
    .accesskey = Z
# Variables:
#   $percentage (number) - Zoom percentage value
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
fx-translate-web-pages = { -translations-brand-name }
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
download-save-where = Alle Dateien in folgendem Ordner abspeichern:
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
# Variables:
#   $type-description (string) - Description of the type (e.g "Portable Document Format")
#   $type (string) - The MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (string) - File extension (e.g .TXT)
#   $type (string) - The MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (string) - Name of a plugin (e.g Adobe Flash)
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

applications-handle-new-file-types-description = Wie soll { -brand-short-name } mit anderen Dateien verfahren?
applications-save-for-new-types =
    .label = Dateien speichern
    .accesskey = s
applications-ask-before-handling =
    .label = Fragen, ob Dateien geöffnet oder gespeichert werden sollen
    .accesskey = F
drm-content-header = Inhalte mit DRM-Kopierschutz
play-drm-content =
    .label = Inhalte mit DRM-Kopierschutz wiedergeben
    .accesskey = D
play-drm-content-learn-more = Weitere Informationen
update-application-title = { -brand-short-name }-Updates
update-application-description = { -brand-short-name } aktuell halten, um höchste Leistung, Stabilität und Sicherheit zu erfahren.
# Variables:
# $version (string) - Waterfox version
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
update-application-suppress-prompts =
    .label = Weniger Update-Benachrichtigungen anzeigen
    .accesskey = B
update-setting-write-failure-title2 = Fehler beim Speichern der Update-Einstellungen
# Variables:
#   $path (string) - Path to the configuration file
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
performance-limit-content-process-blocked-desc = Das Ändern der Anzahl der Inhaltsprozesse ist nur in { -brand-short-name } mit mehreren Prozessen möglich. <a data-l10n-name="learn-more">Wie Sie herausfinden, ob Waterfox mit mehreren Prozessen ausgeführt wird</a>
# Variables:
#   $num (number) - Default value of the `dom.ipc.processCount` pref.
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
browsing-gtk-use-non-overlay-scrollbars =
    .label = Bildlaufleisten immer anzeigen
    .accesskey = B
browsing-use-onscreen-keyboard =
    .label = Bildschirmtastatur falls notwendig anzeigen
    .accesskey = B
browsing-use-cursor-navigation =
    .label = Markieren von Text mit der Tastatur zulassen
    .accesskey = M
browsing-use-full-keyboard-navigation =
    .label = Tab-Taste verwenden, um den Fokus zwischen Formular-Steuerung und Links zu verschieben
    .accesskey = T
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
home-mode-choice-default-fx =
    .label = { -firefox-home-brand-name } (Standard)
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

## Home Section - Waterfox Home Content Customization

home-prefs-content-header2 = { -firefox-home-brand-name }-Inhalte
home-prefs-content-description2 = Wählen Sie, welche Inhalte auf Ihrem { -firefox-home-brand-name }-Bildschirm angezeigt werden sollen.
home-prefs-search-header =
    .label = Internetsuche
home-prefs-shortcuts-header =
    .label = Verknüpfungen
home-prefs-shortcuts-description = Websites, die Sie speichern oder besuchen
home-prefs-shortcuts-by-option-sponsored =
    .label = Gesponserte Verknüpfungen

## Variables:
##  $provider (string) - Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Empfohlen von { $provider }
home-prefs-recommended-by-description-new = Besondere Inhalte ausgewählt von { $provider }, Teil der { -brand-product-name }-Familie

##

home-prefs-recommended-by-learn-more = Wie es funktioniert
home-prefs-recommended-by-option-sponsored-stories =
    .label = Gesponserte Inhalte
home-prefs-recommended-by-option-recent-saves =
    .label = Zuletzt hinzugefügte Einträge anzeigen
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
home-prefs-snippets-description-new = Tipps und Neuigkeiten von { -vendor-short-name } und { -brand-product-name }
# Variables:
#   $num (number) - Number of rows displayed
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
# With this option enabled, on the search results page
# the URL will be replaced by the search terms in the address bar
# when using the current default search engine.
search-show-search-term-option =
    .label = Suchbegriffe statt URL auf der Standard-Suchmaschinen-Ergebnisseite anzeigen
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = In Adressleiste Suchvorschläge vor Einträgen aus der Browser-Chronik anzeigen
search-show-suggestions-private-windows =
    .label = Suchvorschläge in privaten Fenstern anzeigen
suggestions-addressbar-settings-generic2 = Einstellungen für andere Vorschläge in der Adressleiste ändern
search-suggestions-cant-show = Suchvorschläge werden nicht in der Adressleiste angezeigt, weil { -brand-short-name } angewiesen wurde, keine Chronik zu speichern.
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
#   $name (string) - Name of a search engine.
search-keyword-warning-engine = Sie haben ein Schlüsselwort ausgewählt, das bereits von "{ $name }" verwendet wird, bitte wählen Sie ein anderes.
search-keyword-warning-bookmark = Sie haben ein Schlüsselwort ausgewählt, das bereits von einem Lesezeichen verwendet wird, bitte wählen Sie ein anderes.

## Containers Section

containers-back-button2 =
    .aria-label = Zurück zu den Einstellungen
containers-header = Tab-Umgebungen
containers-add-button =
    .label = Neue Umgebung hinzufügen
    .accesskey = N
containers-new-tab-check =
    .label = Tab-Umgebung für jeden neuen Tab wählen
    .accesskey = w
containers-settings-button =
    .label = Einstellungen
containers-remove-button =
    .label = Löschen

## Waterfox account - Signed out. Note that "Sync" and "Waterfox account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = So haben Sie das Web überall dabei.
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

## Waterfox account - Signed in

sync-profile-picture =
    .tooltiptext = Profilbild ändern
sync-sign-out =
    .label = Abmelden…
    .accesskey = b
sync-manage-account = Konto verwalten
    .accesskey = v

## Variables
## $email (string) - Email used for Waterfox account

sync-signedin-unverified = { $email } wurde noch nicht bestätigt.
sync-signedin-login-failure = Melden Sie sich an, um erneut mit { $email } zu verbinden.

##

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
prefs-sync-turn-on-syncing =
    .label = Synchronisation aktivieren…
    .accesskey = S
prefs-sync-offer-setup-label2 = Synchronisieren Sie Ihre Lesezeichen, Chronik, Tabs, Passwörter, Add-ons und Einstellungen zwischen allen Ihren Geräten.
prefs-sync-now =
    .labelnotsyncing = Jetzt synchronisieren
    .accesskeynotsyncing = J
    .labelsyncing = Wird synchronisiert…
prefs-sync-now-button =
    .label = Jetzt synchronisieren
    .accesskey = J
prefs-syncing-button =
    .label = Wird synchronisiert…

## The list of things currently syncing.

sync-syncing-across-devices-heading = Sie synchronisieren diese Elemente mit allen Ihren verbundenen Geräten:
sync-currently-syncing-bookmarks = Lesezeichen
sync-currently-syncing-history = Chronik
sync-currently-syncing-tabs = Offene Tabs
sync-currently-syncing-logins-passwords = Zugangsdaten und Passwörter
sync-currently-syncing-addresses = Adressen
sync-currently-syncing-creditcards = Kreditkarten
sync-currently-syncing-addons = Add-ons
sync-currently-syncing-settings = Einstellungen
sync-change-options =
    .label = Ändern…
    .accesskey = Ä

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog3 =
    .title = Auswählen, was synchronisiert wird
    .style = min-width: 36em;
    .buttonlabelaccept = Änderungen speichern
    .buttonaccesskeyaccept = s
    .buttonlabelextra2 = Trennen…
    .buttonaccesskeyextra2 = T
sync-choose-dialog-subtitle = Änderungen an der Liste der zu synchronisierenden Elemente werden auf alle Ihre verbundenen Geräte angewendet.
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
    .tooltiptext = Erweiterungen und Themes für Waterfox für Desktops
    .accesskey = A
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

## These strings are shown in a desktop notification after the
## user requests we resend a verification email.

sync-verification-sent-title = Verifizierung gesendet
# Variables:
#   $email (String): Email address of user's Waterfox account.
sync-verification-sent-body = Ein Link zur Verifizierung wurde an { $email } gesendet.
sync-verification-not-sent-title = Verifizierung konnte nicht gesendet werden
sync-verification-not-sent-body = Die E-Mail zur Verifizierung konnte nicht gesendet werden. Bitte versuchen Sie es später erneut.

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
preferences-relay-integration-checkbox =
    .label = { -relay-brand-name }-E-Mail-Masken zum Schutz Ihrer E-Mail-Adresse vorschlagen
relay-integration-learn-more-link = Weitere Informationen
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Zugangsdaten und Passwörter automatisch ausfüllen
    .accesskey = Z
forms-saved-logins =
    .label = Gespeicherte Zugangsdaten…
    .accesskey = G
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
forms-primary-pw-change =
    .label = Hauptpasswort ändern…
    .accesskey = H
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = Früher bekannt als Master-Passwort
forms-primary-pw-fips-title = Sie sind derzeit im FIPS-Modus. FIPS benötigt ein nicht leeres Hauptpasswort.
forms-master-pw-fips-desc = Ändern des Passworts fehlgeschlagen
forms-windows-sso =
    .label = Windows Single Sign-on für Microsoft-, Geschäfts- und Schulkonten erlauben
forms-windows-sso-learn-more-link = Weitere Informationen
forms-windows-sso-desc = Verwalten Sie Konten in Ihren Geräteeinstellungen.

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Um ein Hauptpasswort zu erstellen, müssen die Anmeldedaten des Windows-Benutzerkontos eingegeben werden. Dies dient dem Schutz Ihrer Zugangsdaten.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Hauptpasswort festlegen
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Chronik
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
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
#   $value (number) - Value of the unit (for example: 4.6, 500)
#   $unit (string) - Name of the unit (for example: "bytes", "KB")
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
sitedata-option-block-cross-site-tracking-cookies =
    .label = Cookies zur seitenübergreifenden Aktivitätenverfolgung
sitedata-option-block-cross-site-cookies =
    .label = Cookies zur seitenübergreifenden Aktivitätenverfolgung, dabei andere seitenübergreifende Cookies isolieren
sitedata-option-block-unvisited =
    .label = Cookies von nicht besuchten Websites
sitedata-option-block-all-cross-site-cookies =
    .label = Alle seitenübergreifenden Cookies (einige Websites funktionieren dann eventuell nicht mehr)
sitedata-option-block-all =
    .label = Alle Cookies (einige Websites funktionieren dann nicht mehr)
sitedata-clear =
    .label = Daten entfernen…
    .accesskey = e
sitedata-settings =
    .label = Daten verwalten…
    .accesskey = v
sitedata-cookies-exceptions =
    .label = Ausnahmen verwalten…
    .accesskey = u

## Privacy Section - Cookie Banner Handling

cookie-banner-handling-header = Reduzierung von Cookie-Bannern
cookie-banner-handling-description = { -brand-short-name } versucht, Cookie-Anforderungen über Cookie-Banner auf unterstützten Websites automatisch abzulehnen.
cookie-banner-learn-more = Weitere Informationen
forms-handle-cookie-banners =
    .label = Cookie-Banner reduzieren

## Privacy Section - Address Bar

addressbar-header = Adressleiste
addressbar-suggest = Beim Verwenden der Adressleiste Folgendes vorschlagen:
addressbar-locbar-history-option =
    .label = Einträge aus der Chronik
    .accesskey = C
addressbar-locbar-bookmarks-option =
    .label = Einträge aus den Lesezeichen
    .accesskey = L
addressbar-locbar-clipboard-option =
    .label = Zwischenablage
    .accesskey = Z
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
addressbar-locbar-quickactions-option =
    .label = Schnellaktionen
    .accesskey = S
addressbar-suggestions-settings = Einstellungen für Suchvorschläge ändern
addressbar-quickactions-learn-more = Weitere Informationen

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
content-blocking-cross-site-cookies-in-all-windows2 = Seitenübergreifende Cookies in allen Fenstern
content-blocking-cross-site-tracking-cookies = Cookies zur seitenübergreifenden Aktivitätenverfolgung
content-blocking-all-cross-site-cookies-private-windows = Seitenübergreifende Cookies in privaten Fenstern
content-blocking-cross-site-tracking-cookies-plus-isolate = Cookies zur seitenübergreifenden Aktivitätenverfolgung, dabei verbleibende Cookies isolieren
content-blocking-social-media-trackers = Skripte zur Aktivitätenverfolgung durch soziale Netzwerke
content-blocking-all-cookies = Alle Cookies
content-blocking-unvisited-cookies = Cookies von nicht besuchten Websites
content-blocking-all-windows-tracking-content = Inhalte zur Aktivitätenverfolgung in allen Fenstern
content-blocking-all-cross-site-cookies = Alle seitenübergreifenden Cookies
content-blocking-cryptominers = Heimliche Digitalwährungsberechner (Krypto-Miner)
content-blocking-fingerprinters = Identifizierer (Fingerprinter)
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices. And
# the suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-known-and-suspected-fingerprinters = Bekannte und vermutete Identifizierer (Fingerprinter)

# The tcp-rollout strings are no longer used for the rollout but for tcp-by-default in the standard section

# "Contains" here means "isolates", "limits".
content-blocking-etp-standard-tcp-rollout-description = Der vollständige Cookie-Schutz beschränkt Cookies auf die Website, auf der Sie sich befinden, sodass Elemente zur Aktivitätenverfolgung sie nicht verwenden können, um Ihnen Website-übergreifend zu folgen.
content-blocking-etp-standard-tcp-rollout-learn-more = Weitere Informationen
content-blocking-etp-standard-tcp-title = Beinhaltet den vollständigen Cookie-Schutz, unsere leistungsfähigste Datenschutzfunktion aller Zeiten
content-blocking-warning-title = Achtung!
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
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
#
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices.
content-blocking-known-fingerprinters-label =
    .label = Bekannte Identifizierer (Fingerprinter)
    .accesskey = B
# The suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-suspected-fingerprinters-label =
    .label = Vermutete Identifizierer (Fingerprinter)
    .accesskey = V

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
# Short form for "the act of choosing sound output devices and redirecting audio to the chosen devices".
permissions-speaker = Lautsprecherauswahl
permissions-speaker-settings =
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
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = Ausnahmen…
    .accesskey = A
    .searchkeywords = popups
permissions-addon-install-warning =
    .label = Warnen, wenn Websites versuchen, Add-ons zu installieren
    .accesskey = W
permissions-addon-exceptions =
    .label = Ausnahmen…
    .accesskey = A

## Privacy Section - Data Collection

collection-header = Datenerhebung durch { -brand-short-name } und deren Verwendung
collection-header2 = Datenerhebung durch { -brand-short-name } und deren Verwendung
    .searchkeywords = Telemetrie
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
collection-backlogged-crash-reports-with-link = Nicht gesendete Absturzberichte automatisch von { -brand-short-name } senden lassen <a data-l10n-name="crash-reports-link">Weitere Informationen</a>
    .accesskey = g
privacy-segmentation-section-header = Neue Funktionen, die Ihr Surfen verbessern
privacy-segmentation-section-description = Wenn wir Funktionen anbieten, die Ihre Daten verwenden, um Ihnen ein persönlicheres Erlebnis zu bieten:
privacy-segmentation-radio-off =
    .label = { -brand-product-name }-Empfehlungen verwenden
privacy-segmentation-radio-on =
    .label = Detaillierte Informationen anzeigen

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
certs-enable-ocsp =
    .label = Aktuelle Gültigkeit von Zertifikaten durch Anfrage bei OCSP-Server bestätigen lassen
    .accesskey = G
certs-view =
    .label = Zertifikate anzeigen…
    .accesskey = Z
certs-devices =
    .label = Kryptographie-Module…
    .accesskey = K
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

## DoH Section

preferences-doh-header = DNS über HTTPS
preferences-doh-description = Domain Name System (DNS) über HTTPS sendet Ihre Anfrage für einen Domainnamen über eine verschlüsselte Verbindung, wodurch ein sicheres DNS geschaffen wird. Dies erschwert es anderen, zu sehen, welche Website Sie gerade besuchen.
# Variables:
#   $status (string) - The status of the DoH connection
preferences-doh-status = Status: { $status }
# Variables:
#   $name (string) - The name of the DNS over HTTPS resolver. If a custom resolver is used, the name will be the domain of the URL.
preferences-doh-resolver = Anbieter: { $name }
# This is displayed instead of $name in preferences-doh-resolver
# when the DoH URL is not a valid URL
preferences-doh-bad-url = Ungültige Adresse
preferences-doh-steering-status = Lokaler Anbieter wird verwendet
preferences-doh-status-active = Aktiv
preferences-doh-status-disabled = Aus
# Variables:
#   $reason (string) - A string representation of the reason DoH is not active. For example NS_ERROR_UNKNOWN_HOST or TRR_RCODE_FAIL.
preferences-doh-status-not-active = Nicht aktiv ({ $reason })
preferences-doh-group-message = Sicheres DNS aktivieren mit:
preferences-doh-expand-section =
    .tooltiptext = Weitere Informationen
preferences-doh-setting-default =
    .label = Standardschutz
    .accesskey = S
preferences-doh-default-desc = { -brand-short-name } entscheidet, wann sicheres DNS verwendet wird, um Ihre Privatsphäre zu schützen.
preferences-doh-default-detailed-desc-1 = Sicheres DNS in Regionen verwenden, in denen es verfügbar ist
preferences-doh-default-detailed-desc-2 = Ihren Standard-DNS-Resolver verwenden, wenn ein Problem mit dem sicheren DNS-Anbieter auftritt
preferences-doh-default-detailed-desc-3 = Lokalen Anbieter verwenden, wenn möglich
preferences-doh-default-detailed-desc-4 = Deaktivieren, wenn VPN, Jugendschutz oder Unternehmensrichtlinien aktiv sind
preferences-doh-default-detailed-desc-5 = Deaktivieren, wenn ein Netzwerk { -brand-short-name } sagt, dass es kein sicheres DNS verwenden sollte
preferences-doh-setting-enabled =
    .label = Erhöhter Schutz
    .accesskey = E
preferences-doh-enabled-desc = Sie kontrollieren, wann Sie sicheres DNS verwenden, und wählen Ihren Anbieter.
preferences-doh-enabled-detailed-desc-1 = Ausgewählten Anbieter verwenden
preferences-doh-enabled-detailed-desc-2 = Ihren Standard-DNS-Resolver nur verwenden, wenn ein Problem mit sicherem DNS auftritt
preferences-doh-setting-strict =
    .label = Maximaler Schutz
    .accesskey = M
preferences-doh-strict-desc = { -brand-short-name } wird immer sicheres DNS verwenden. Es wird eine Warnung zu einem Sicherheitsrisiko angezeigt, bevor wir Ihr System-DNS verwenden.
preferences-doh-strict-detailed-desc-1 = Nur ausgewählten Anbieter verwenden
preferences-doh-strict-detailed-desc-2 = Immer warnen, wenn kein sicheres DNS verfügbar ist
preferences-doh-strict-detailed-desc-3 = Wenn sicheres DNS nicht verfügbar ist, werden Websites nicht laden oder funktionieren nicht richtig
preferences-doh-setting-off =
    .label = Aus
    .accesskey = A
preferences-doh-off-desc = Ihren Standard-DNS-Resolver verwenden
preferences-doh-checkbox-warn =
    .label = Warnen, wenn ein Drittanbieter sicheres DNS aktiv verhindert
    .accesskey = W
preferences-doh-select-resolver = Anbieter auswählen:
preferences-doh-exceptions-description = { -brand-short-name } verwendet auf diesen Websites kein sicheres DNS
preferences-doh-manage-exceptions =
    .label = Ausnahmen verwalten…
    .accesskey = u

## The following strings are used in the Download section of settings

desktop-folder-name = Desktop
downloads-folder-name = Downloads
choose-download-folder-title = Download-Ordner wählen:
