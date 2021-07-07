# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Schließen

preferences-doc-title = Einstellungen

category-list =
    .aria-label = Kategorien

pane-general-title = Allgemein
category-general =
    .tooltiptext = { pane-general-title }

pane-compose-title = Verfassen
category-compose =
    .tooltiptext = Verfassen

pane-privacy-title = Datenschutz & Sicherheit
category-privacy =
    .tooltiptext = Datenschutz & Sicherheit

pane-chat-title = Chat
category-chat =
    .tooltiptext = Chat

pane-calendar-title = Kalender
category-calendar =
    .tooltiptext = Kalender

general-language-and-appearance-header = Sprache & Erscheinungsbild

general-incoming-mail-header = Eingehende E-Mail-Nachrichten

general-files-and-attachment-header = Dateien & Anhänge

general-tags-header = Schlagwörter

general-reading-and-display-header = Lesen & Ansicht

general-updates-header = Updates

general-network-and-diskspace-header = Netzwerk & Speicherplatz

general-indexing-label = Suchindizierung

composition-category-header = Verfassen

composition-attachments-header = Anhänge

composition-spelling-title = Rechtschreibung

compose-html-style-title = HTML-Optionen

composition-addressing-header = Adressieren

privacy-main-header = Datenschutz

privacy-passwords-header = Passwörter

privacy-junk-header = Junk

collection-header = Datenerhebung durch { -brand-short-name } und deren Verwendung

collection-description = Wir lassen Ihnen die Wahl, ob Sie uns Daten senden, und sammeln nur die Daten, welche erforderlich sind, um { -brand-short-name } für jeden anbieten und verbessern zu können. Wir fragen immer um Ihre Erlaubnis, bevor wir persönliche Daten senden.
collection-privacy-notice = Datenschutzhinweis

collection-health-report-telemetry-disabled = Sie gestatten { -vendor-short-name } nicht mehr, technische und Interaktionsdaten zu erfassen. Alle bisherigen Daten werden innerhalb von 30 Tagen gelöscht.
collection-health-report-telemetry-disabled-link = Weitere Informationen

collection-health-report =
    .label = { -brand-short-name } erlauben, Daten zu technischen Details und Interaktionen an { -vendor-short-name } zu senden
    .accesskey = t
collection-health-report-link = Weitere Informationen

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Datenübermittlung ist für diese Build-Konfiguration deaktiviert

collection-backlogged-crash-reports =
    .label = Nicht gesendete Absturzberichte automatisch von { -brand-short-name } senden lassen
    .accesskey = g
collection-backlogged-crash-reports-link = Weitere Informationen

privacy-security-header = Sicherheit

privacy-scam-detection-title = Betrugsversuche

privacy-anti-virus-title = Antivirus

privacy-certificates-title = Zertifikate

chat-pane-header = Chat

chat-status-title = Status

chat-notifications-title = Benachrichtigungen

chat-pane-styling-header = Anzeige

choose-messenger-language-description = Sprache für die Anzeige von Menüs, Mitteilungen und Benachrichtigungen von { -brand-short-name }
manage-messenger-languages-button =
    .label = Alternative Sprachen festlegen…
    .accesskey = S
confirm-messenger-language-change-description = { -brand-short-name } muss neu gestartet werden, um die Änderungen zu übernehmen.
confirm-messenger-language-change-button = Anwenden und neu starten

update-setting-write-failure-title = Fehler beim Speichern der Update-Einstellungen

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } bemerkte einen Fehler und hat diese Änderung nicht gespeichert. Das Setzen dieser Update-Einstellung benötigt Schreibrechte für die unten genannte Datei. Sie oder ein Systemadministrator können das Problem eventuell beheben, indem Sie der Gruppe "Benutzer" vollständige Kontrolle über die Datei gewähren.
    
    Konnte folgende Datei nicht speichern: { $path }

update-in-progress-title = Update wird durchgeführt

update-in-progress-message = Soll { -brand-short-name } mit dem Update fortfahren?

update-in-progress-ok-button = &Verwerfen
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Fortfahren

account-button = Konten-Einstellungen
open-addons-sidebar-button = Erweiterungen und Themes

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Um ein Hauptpasswort zu erstellen, müssen die Anmeldedaten des Windows-Benutzerkontos eingegeben werden. Dies dient dem Schutz Ihrer Zugangsdaten.

# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = Hauptpasswort festlegen

# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k

general-legend = { -brand-short-name }-Startseite

start-page-label =
    .label = Beim Aufrufen von { -brand-short-name } die Startseite anzeigen
    .accesskey = m

location-label =
    .value = Adresse:
    .accesskey = r
restore-default-label =
    .label = Standard wiederherstellen
    .accesskey = w

default-search-engine = Standardsuchmaschine
add-search-engine =
    .label = Aus Datei hinzufügen
    .accesskey = D
remove-search-engine =
    .label = Entfernen
    .accesskey = f

minimize-to-tray-label =
    .label = { -brand-short-name } beim Minimieren in die Infoleiste verschieben
    .accesskey = M

new-message-arrival = Wenn neue Nachrichten eintreffen
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Folgende Audiodatei abspielen:
           *[other] Einen Klang abspielen
        }
    .accesskey =
        { PLATFORM() ->
            [macos] F
           *[other] K
        }
mail-play-button =
    .label = Probe hören
    .accesskey = P

change-dock-icon = Einstellungen für Dock-Symbol ändern
app-icon-options =
    .label = Dock-Symbol-Einstellungen…
    .accesskey = D

notification-settings = Benachrichtigungen und Standardton können in der Mitteilungszentrale der Systemeinstellungen deaktiviert werden.

animated-alert-label =
    .label = Eine Benachrichtigung anzeigen
    .accesskey = B
customize-alert-label =
    .label = Anpassen…
    .accesskey = A

biff-use-system-alert =
    .label = Systembenachrichtigung verwenden

tray-icon-unread-label =
    .label = Taskleistensymbol bei ungelesenen Nachrichten anzeigen
    .accesskey = z

tray-icon-unread-description = Bei Verwendung kleiner Taskleistenschaltflächen empfohlen

mail-system-sound-label =
    .label = Systemklang für neue Nachrichten
    .accesskey = y
mail-custom-sound-label =
    .label = Benutzerdefinierter Klang
    .accesskey = e
mail-browse-sound-button =
    .label = Durchsuchen…
    .accesskey = u

enable-gloda-search-label =
    .label = Globale Suche und Nachrichtenindizierung aktivieren
    .accesskey = N

datetime-formatting-legend = Datums- und Uhrzeitformat
language-selector-legend = Sprache

allow-hw-accel =
    .label = Hardwarebeschleunigung verwenden, wenn verfügbar
    .accesskey = H

store-type-label =
    .value = Speichermethode für neue Konten:
    .accesskey = m

mbox-store-label =
    .label = Eine Datei pro Ordner (mbox)
maildir-store-label =
    .label = Eine Datei pro Nachricht (maildir)

scrolling-legend = Bildlauf
autoscroll-label =
    .label = Automatischen Bildlauf aktivieren
    .accesskey = A
smooth-scrolling-label =
    .label = Sanften Bildlauf aktivieren
    .accesskey = f

system-integration-legend = Systemintegration
always-check-default =
    .label = Beim Starten prüfen, ob { -brand-short-name } als Standard-Anwendung registriert ist
    .accesskey = B
check-default-button =
    .label = Jetzt prüfen…
    .accesskey = J

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows-Suche
       *[other] { "" }
    }

search-integration-label =
    .label = { search-engine-name } ermöglichen, Nachrichten zu durchsuchen
    .accesskey = S

config-editor-button =
    .label = Konfiguration bearbeiten…
    .accesskey = K

return-receipts-description = Den Umgang mit Empfangsbestätigungen (MDN) in { -brand-short-name } festlegen:
return-receipts-button =
    .label = Empfangsbestätigungen…
    .accesskey = E

update-app-legend = { -brand-short-name }-Updates

# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Version { $version }

allow-description = { -brand-short-name } erlauben
automatic-updates-label =
    .label = Updates automatisch zu installieren (empfohlen: erhöhte Sicherheit)
    .accesskey = U
check-updates-label =
    .label = Nach Updates zu suchen, aber vor der Installation nachfragen
    .accesskey = N

update-history-button =
    .label = Update-Chronik anzeigen
    .accesskey = C

use-service =
    .label = Einen Hintergrunddienst zum Installieren von Updates verwenden
    .accesskey = H

cross-user-udpate-warning = Diese Einstellung betrifft alle Windows-Konten und { -brand-short-name }-Profile, welche diese Installation von { -brand-short-name } verwenden.

networking-legend = Verbindung
proxy-config-description = Festlegen wie sich { -brand-short-name } mit dem Internet verbindet

network-settings-button =
    .label = Einstellungen…
    .accesskey = E

offline-legend = Offline
offline-settings = Das Verhalten des Offline-Modus konfigurieren

offline-settings-button =
    .label = Offline…
    .accesskey = O

diskspace-legend = Speicherplatz
offline-compact-folder =
    .label = Alle Ordner komprimieren, wenn dies insgesamt mehr Platz spart als
    .accesskey = A

offline-compact-folder-automatically =
    .label = Nachfragen vor jedem Komprimieren
    .accesskey = N
    
compact-folder-size =
    .value = MB

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Es werden bis zu
    .accesskey = U

use-cache-after = MB Speicherplatz als Cache verwendet

##

smart-cache-label =
    .label = Automatisches Cache-Management ausschalten
    .accesskey = M

clear-cache-button =
    .label = Jetzt leeren
    .accesskey = l

fonts-legend = Schriftarten und Farben

default-font-label =
    .value = Standard-Schriftart:
    .accesskey = n

default-size-label =
    .value = Größe:
    .accesskey = G

font-options-button =
    .label = Erweitert…
    .accesskey = E

color-options-button =
    .label = Farben…
    .accesskey = F

display-width-legend = Reintext-Nachrichten

# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Emoticons als Grafiken anzeigen
    .accesskey = m

display-text-label = Beim Anzeigen von zitierten Reintext-Nachrichten:

style-label =
    .value = Stil:
    .accesskey = S

regular-style-item =
    .label = Normal
bold-style-item =
    .label = Fett
italic-style-item =
    .label = Kursiv
bold-italic-style-item =
    .label = Fett kursiv

size-label =
    .value = Größe:
    .accesskey = r

regular-size-item =
    .label = Normal
bigger-size-item =
    .label = Größer
smaller-size-item =
    .label = Kleiner

quoted-text-color =
    .label = Farbe:
    .accesskey = a

search-handler-table =
    .placeholder = Dateitypen und Aktionen suchen

type-column-label = Dateityp

action-column-label = Aktion

save-to-label =
    .label = Dateien speichern unter
    .accesskey = s

choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Auswählen…
           *[other] Durchsuchen…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] w
           *[other] u
        }

always-ask-label =
    .label = Jedes Mal nachfragen, wo gespeichert werden soll
    .accesskey = J


display-tags-text = Schlagwörter können beim Sortieren und Erkennen von Nachrichten helfen.

new-tag-button =
    .label = Hinzufügen…
    .accesskey = H

edit-tag-button =
    .label = Bearbeiten…
    .accesskey = B

delete-tag-button =
    .label = Löschen
    .accesskey = L

auto-mark-as-read =
    .label = Nachrichten automatisch als gelesen markieren
    .accesskey = a

mark-read-no-delay =
    .label = Sofort beim Anzeigen
    .accesskey = S

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Nach dem Anzeigen für
    .accesskey = c

seconds-label = Sekunden

##

open-msg-label =
    .value = Nachricht durch Doppelklick öffnen in:

open-msg-tab =
    .label = Neuem Tab
    .accesskey = T

open-msg-window =
    .label = Neuem Fenster
    .accesskey = N

open-msg-ex-window =
    .label = Vorhandenem Fenster
    .accesskey = V

close-move-delete =
    .label = Nachrichtenfenster/-tab beim Verschieben oder Löschen schließen
    .accesskey = h

display-name-label =
    .value = Anzeigename:

condensed-addresses-label =
    .label = Bei bekannten Kontakten nur den Anzeigenamen zeigen
    .accesskey = B

## Compose Tab

forward-label =
    .value = Nachrichten weiterleiten:
    .accesskey = N

inline-label =
    .label = Eingebunden

as-attachment-label =
    .label = Als Anhang

extension-label =
    .label = Dateinamenserweiterung hinzufügen
    .accesskey = D

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Alle
    .accesskey = A

auto-save-end = Minuten automatisch speichern

##

warn-on-send-accel-key =
    .label = Bestätigen, wenn die Tastenkombination zum Senden einer Nachricht verwendet wird
    .accesskey = B

spellcheck-label =
    .label = Rechtschreibprüfung vor dem Senden
    .accesskey = R

spellcheck-inline-label =
    .label = Sofort-Rechtschreibprüfung aktivieren
    .accesskey = S

language-popup-label =
    .value = Sprache:
    .accesskey = p

download-dictionaries-link = Weitere Wörterbücher herunterladen

font-label =
    .value = Schriftart:
    .accesskey = c

font-size-label =
    .value = Größe:
    .accesskey = G

default-colors-label =
    .label = Standardfarben des Programms verwenden
    .accesskey = P

font-color-label =
    .value = Text:
    .accesskey = T

bg-color-label =
    .value = Hintergrund:
    .accesskey = H

restore-html-label =
    .label = Standard wiederherstellen
    .accesskey = w

default-format-label =
    .label = Format "Absatz" anstatt "Normaler Text" verwenden
    .accesskey = F

format-description = Verhalten beim Senden von HTML-Nachrichten:

send-options-label =
    .label = Sendeoptionen…
    .accesskey = o

autocomplete-description = Beim Adressieren von Nachrichten nach passenden Einträgen suchen in:

ab-label =
    .label = Lokale Adressbücher
    .accesskey = L

directories-label =
    .label = LDAP-Verzeichnisserver:
    .accesskey = D

directories-none-label =
    .none = Keine

edit-directories-label =
    .label = Bearbeiten…
    .accesskey = B

email-picker-label =
    .label = Adressen beim Senden automatisch hinzufügen zu:
    .accesskey = A

default-directory-label =
    .value = Standardordner beim Öffnen des Adressbuchs:
    .accesskey = S

default-last-label =
    .none = Zuletzt verwendeter Ordner

attachment-label =
    .label = Auf fehlende Anhänge prüfen
    .accesskey = u

attachment-options-label =
    .label = Schlüsselwörter…
    .accesskey = S

enable-cloud-share =
    .label = Hochladen für Dateien größer als
cloud-share-size =
    .value = MB anbieten

add-cloud-account =
    .label = Hinzufügen…
    .accesskey = H
    .defaultlabel = Hinzufügen…

remove-cloud-account =
    .label = Entfernen
    .accesskey = E

find-cloud-providers =
    .value = Weitere Anbieter finden…

cloud-account-description = Einen Filelink-Speicherdienst hinzufügen


## Privacy Tab

mail-content = E-Mail-Inhalte

remote-content-label =
    .label = Externe Inhalte in Nachrichten erlauben
    .accesskey = x

exceptions-button =
    .label = Ausnahmen…
    .accesskey = A

remote-content-info =
    .value = Erfahren Sie mehr über die Datenschutzaspekte externer Inhalte

web-content = Webinhalte

history-label =
    .label = Besuchte Webseiten und Links merken
    .accesskey = W

cookies-label =
    .label = Cookies von Webseiten akzeptieren
    .accesskey = C

third-party-label =
    .value = Cookies von Drittanbietern akzeptieren:
    .accesskey = k

third-party-always =
    .label = Immer
third-party-never =
    .label = Nie
third-party-visited =
    .label = Nur von besuchten Drittanbietern

keep-label =
    .value = Behalten, bis:
    .accesskey = B

keep-expire =
    .label = sie nicht mehr gültig sind
keep-close =
    .label = { -brand-short-name } geschlossen wird
keep-ask =
    .label = jedes Mal nachfragen

cookies-button =
    .label = Cookies anzeigen…
    .accesskey = o

do-not-track-label =
    .label = Websites eine "Do Not Track"-Mitteilung senden, dass Ihre Online-Aktivitäten nicht verfolgt werden sollen
    .accesskey = D

learn-button =
    .label = Weitere Informationen

passwords-description = { -brand-short-name } kann die Passwörter aller Ihrer Konten speichern.

passwords-button =
    .label = Gespeicherte Passwörter…
    .accesskey = G


primary-password-description = Ein Hauptpasswort schützt alle Ihre Passworte. Es muss einmal pro Sitzung eingegeben werden.

primary-password-label =
    .label = Hauptpasswort verwenden
    .accesskey = v

primary-password-button =
    .label = Hauptpasswort ändern…
    .accesskey = H

forms-primary-pw-fips-title = Sie sind derzeit im FIPS-Modus. FIPS benötigt ein nicht leeres Hauptpasswort.
forms-master-pw-fips-desc = Ändern des Passworts fehlgeschlagen


junk-description = Die folgenden Einstellungen gelten für alle Konten. In den Konten-Einstellungen können zusätzlich für jedes Konto getrennte Einstellungen vorgenommen werden.

junk-label =
    .label = Wenn Nachrichten manuell als Junk markiert werden:
    .accesskey = W

junk-move-label =
    .label = Verschiebe diese in den für Junk bestimmten Ordner des Kontos
    .accesskey = V

junk-delete-label =
    .label = Lösche diese Nachrichten
    .accesskey = L

junk-read-label =
    .label = Junk als gelesen markieren
    .accesskey = J

junk-log-label =
    .label = Junk-Protokoll für selbstlernenden Filter aktivieren
    .accesskey = u

junk-log-button =
    .label = Protokoll anzeigen…
    .accesskey = P

reset-junk-button =
    .label = Trainingsdaten löschen
    .accesskey = T

phishing-description = { -brand-short-name } kann vor möglichen Betrugsversuchen (Phishing) warnen, indem Nachrichten auf bekannte Techniken untersucht werden, die zu Betrugsversuchen genutzt werden. Es kann jedoch auch zu unberechtigten Verdachten kommen, da die verdächtigen Techniken teilweise auch ohne betrügerische Absichten genutzt werden.

phishing-label =
    .label = Nachrichten auf Betrugsversuche (Phishing) untersuchen
    .accesskey = N

antivirus-description = { -brand-short-name } kann es Antivirus-Software ermöglichen, eingehende Nachrichten zu überprüfen und eventuell in Quarantäne zu stellen (oder zu löschen), bevor diese im Posteingang gespeichert werden. Dies kann bei POP-Konten vor Datenverlust schützen, benötigt aber mehr Zeit.

antivirus-label =
    .label = Antivirus-Software ermöglichen, eingehende Nachrichten unter Quarantäne zu stellen
    .accesskey = A

certificate-description = Wenn eine Website nach dem persönlichen Sicherheitszertifikat verlangt:

certificate-auto =
    .label = Automatisch eins wählen
    .accesskey = A

certificate-ask =
    .label = Jedes Mal fragen
    .accesskey = e

ocsp-label =
    .label = Aktuelle Gültigkeit von Zertifikaten durch Anfrage bei OCSP-Server bestätigen lassen
    .accesskey = G

certificate-button =
    .label = Zertifikate verwalten…
    .accesskey = Z

security-devices-button =
    .label = Kryptographie-Module verwalten…
    .accesskey = K

## Chat Tab

startup-label =
    .value = Beim Start von { -brand-short-name }:
    .accesskey = S

offline-label =
    .label = Chat-Konten nicht verbinden

auto-connect-label =
    .label = Chat-Konten automatisch verbinden

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Kontakte über Untätigkeit informieren nach
    .accesskey = U

idle-time-label = Minuten ohne Aktion am Computer

##

away-message-label =
    .label = und eigenen Status auf Abwesend setzen mit dieser Statusnachricht:
    .accesskey = A

send-typing-label =
    .label = Kontakte bei laufendem Gespräch über Tippen informieren
    .accesskey = T

notification-label = Wenn direkt an Sie gerichtete Nachrichten eintreffen

show-notification-label =
    .label = Eine Benachrichtigung anzeigen
    .accesskey = B

notification-all =
    .label = mit dem Namen des Absenders und einer Vorschau der Nachricht
notification-name =
    .label = nur mit dem Namen des Absenders
notification-empty =
    .label = ohne jegliche Informationen

notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Animiertes Symbol im Dock
           *[other] Blinkendes Symbol in Taskleiste
        }
    .accesskey =
        { PLATFORM() ->
            [macos] m
           *[other] m
        }

chat-play-sound-label =
    .label = Einen Klang abspielen
    .accesskey = K

chat-play-button =
    .label = Probe hören
    .accesskey = P

chat-system-sound-label =
    .label = Systemklang für neue Nachrichten
    .accesskey = y

chat-custom-sound-label =
    .label = Benutzerdefinierter Klang
    .accesskey = e

chat-browse-sound-button =
    .label = Durchsuchen…
    .accesskey = D

theme-label =
    .value = Erscheinungsbild:
    .accesskey = E

style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Sprechblasen
style-dark =
    .label = Dunkel
style-paper =
    .label = Papierseiten
style-simple =
    .label = Einfach

preview-label = Vorschau:
no-preview-label = Keine Vorschau verfügbar
no-preview-description = Dieses Erscheinungsbild ist ungültig oder derzeit nicht verfügbar (z.B. weil Add-on deaktiviert, Thunderbird im Abgesicherten Modus, …).

chat-variant-label =
    .value = Variante:
    .accesskey = V

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = In Einstellungen suchen

## Preferences UI Search Results

search-results-header = Suchergebnisse

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message = { PLATFORM() ->
    [windows] Keine Treffer in den Einstellungen für "<span data-l10n-name="query"></span>".
    *[other] Keine Treffer in den Einstellungen für "<span data-l10n-name="query"></span>".
}

search-results-help-link = Benötigen Sie Hilfe? Dann besuchen Sie die <a data-l10n-name="url">Hilfeseite für { -brand-short-name }</a>.
