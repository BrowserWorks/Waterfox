# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Zugangsdaten und Passwörter

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Nehmen Sie Ihre Passwörter überall mit.
login-app-promo-subtitle = Holen Sie sich die kostenlose { -lockwise-brand-name } App.
login-app-promo-android =
    .alt = Bei Google Play herunterladen
login-app-promo-apple =
    .alt = Laden im App Store
login-filter =
    .placeholder = Zugangsdaten durchsuchen
create-login-button = Zugangsdaten hinzufügen
fxaccounts-sign-in-text = Nutzen Sie Ihre Passwörter auf anderen Geräten
fxaccounts-sign-in-button = Bei { -sync-brand-short-name } anmelden
fxaccounts-sign-in-sync-button = Zum Synchronisieren anmelden
fxaccounts-avatar-button =
    .title = Konto verwalten

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Menü öffnen
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Zugangsdaten importieren aus anderem Browser…
about-logins-menu-menuitem-import-from-a-file = Zugangsdaten importieren aus Datei…
about-logins-menu-menuitem-export-logins = Zugangsdaten exportieren…
about-logins-menu-menuitem-remove-all-logins = Alle Zugangsdaten entfernen…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Einstellungen
       *[other] Einstellungen
    }
about-logins-menu-menuitem-help = Hilfe
menu-menuitem-android-app = { -lockwise-brand-short-name } für Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } für iPhone und iPad

## Login List

login-list =
    .aria-label = Mit Suche übereinstimmende Zugangsdaten
login-list-count =
    { $count ->
        [one] { $count } Zugangsdaten
       *[other] { $count } Zugangsdaten
    }
login-list-sort-label-text = Sortieren nach:
login-list-name-option = Name (A-Z)
login-list-name-reverse-option = Name (Z-A)
about-logins-login-list-alerts-option = Warnungen
login-list-last-changed-option = Zuletzt geändert
login-list-last-used-option = Zuletzt verwendet
login-list-intro-title = Keine Zugangsdaten gefunden
login-list-intro-description = Wenn Sie ein Passwort in { -brand-product-name } speichern, wird es hier angezeigt.
about-logins-login-list-empty-search-title = Keine Zugangsdaten gefunden
about-logins-login-list-empty-search-description = Keine mit der Suche übereinstimmenden Zugangsdaten
login-list-item-title-new-login = Neue Zugangsdaten
login-list-item-subtitle-new-login = Zugangsdaten eingeben
login-list-item-subtitle-missing-username = (kein Benutzername)
about-logins-list-item-breach-icon =
    .title = Website mit Datenleck
about-logins-list-item-vulnerable-password-icon =
    .title = Gefährdetes Passwort

## Introduction screen

login-intro-heading = Suchen Sie Ihre gespeicherten Zugangsdaten? Richten Sie { -sync-brand-short-name } ein.
about-logins-login-intro-heading-logged-out = Suchen Sie Ihre gespeicherten Zugangsdaten? Richten Sie { -sync-brand-short-name } ein oder importieren Sie diese.
about-logins-login-intro-heading-logged-out2 = Suchen Sie Ihre gespeicherten Zugangsdaten? Aktivieren Sie die Synchronisation oder importieren Sie diese.
about-logins-login-intro-heading-logged-in = Keine synchronisierten Zugangsdaten gefunden.
login-intro-description = Wenn Sie Ihre Zugangsdaten in { -brand-product-name } auf einem anderen Gerät gespeichert haben, können Sie diese hier abrufen:
login-intro-instruction-fxa = Auf dem Gerät mit Ihren gespeicherten Zugangsdaten: Erstellen Sie ein { -fxaccount-brand-name } oder melden Sie sich damit an.
login-intro-instruction-fxa-settings = Überprüfen Sie, dass das Kontrollfeld "Zugangsdaten" in den { -sync-brand-short-name }-Einstellungen ausgewählt ist.
about-logins-intro-instruction-help = Weitere Hilfe finden Sie auf der <a data-l10n-name="help-link">Support-Seite für { -lockwise-brand-short-name }</a>.
login-intro-instructions-fxa = Auf dem Gerät mit Ihren gespeicherten Zugangsdaten: Erstellen Sie ein { -fxaccount-brand-name } oder melden Sie sich damit an.
login-intro-instructions-fxa-settings = Gehen Sie zu Einstellungen > Synchronisation > Synchronisation aktivieren… Wählen Sie das Kontrollfeld "Zugangsdaten und Passwörter".
login-intro-instructions-fxa-help = Weitere Hilfe finden Sie auf der <a data-l10n-name="help-link">Hilfeseite für { -lockwise-brand-short-name }</a>.
about-logins-intro-import = Wenn Ihre Zugangsdaten in einem anderen Browser gespeichert sind, können Sie diese in { -lockwise-brand-short-name } <a data-l10n-name="import-link">importieren</a>.
about-logins-intro-import2 = Wenn Ihre Zugangsdaten außerhalb von { -brand-product-name } gespeichert sind, können Sie diese <a data-l10n-name="import-browser-link">aus einem anderen Browser</a> oder <a data-l10n-name="import-file-link">aus einer Datei</a> importieren.

## Login

login-item-new-login-title = Neue Zugangsdaten hinzufügen
login-item-edit-button = Bearbeiten
about-logins-login-item-remove-button = Entfernen
login-item-origin-label = Adresse der Website
login-item-tooltip-message = Stellen Sie sicher, dass dies genau mit der Adresse der Website übereinstimmt, auf der Sie sich anmelden.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Benutzername
about-logins-login-item-username =
    .placeholder = (kein Benutzername)
login-item-copy-username-button-text = Kopieren
login-item-copied-username-button-text = Kopiert
login-item-password-label = Passwort
login-item-password-reveal-checkbox =
    .aria-label = Passwort anzeigen
login-item-copy-password-button-text = Kopieren
login-item-copied-password-button-text = Kopiert
login-item-save-changes-button = Änderungen speichern
login-item-save-new-button = Speichern
login-item-cancel-button = Abbrechen
login-item-time-changed = Zuletzt geändert: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Erstellt: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Zuletzt verwendet: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Um die Zugangsdaten zu bearbeiten, müssen die Anmeldedaten des Windows-Benutzerkontos eingegeben werden. Dies dient dem Schutz Ihrer Zugangsdaten.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = gespeicherte Zugangsdaten bearbeiten
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Um das Passwort anzuzeigen, müssen die Anmeldedaten des Windows-Benutzerkontos eingegeben werden. Dies dient dem Schutz Ihrer Zugangsdaten.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = ein gespeichertes Passwort anzeigen
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Um das Passwort zu kopieren, müssen die Anmeldedaten des Windows-Benutzerkontos eingegeben werden. Dies dient dem Schutz Ihrer Zugangsdaten.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = gespeichertes Passwort kopieren

## Master Password notification

master-password-notification-message = Bitte geben Sie Ihr Master-Passwort ein, um gespeicherte Zugangsdaten und Passwörter anzuzeigen.
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Um die Zugangsdaten zu exportieren, müssen die Anmeldedaten des Windows-Benutzerkontos eingegeben werden. Dies dient dem Schutz Ihrer Zugangsdaten.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = gespeicherte Zugangsdaten und Passwörter exportieren

## Primary Password notification

about-logins-primary-password-notification-message = Bitte geben Sie Ihr Hauptpasswort ein, um gespeicherte Zugangsdaten und Passwörter anzuzeigen.
master-password-reload-button =
    .label = Anmelden
    .accesskey = m

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Wollen Sie Ihre Zugangsdaten überall verfügbar haben, wo Sie { -brand-product-name } nutzen? Öffnen Sie die Einstellungen für { -sync-brand-short-name } und wählen Sie das Kontrollfeld "Zugangsdaten" aus.
       *[other] Wollen Sie Ihre Zugangsdaten überall verfügbar haben, wo Sie { -brand-product-name } nutzen? Öffnen Sie die Einstellungen für { -sync-brand-short-name } und wählen Sie das Kontrollfeld "Zugangsdaten" aus.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Einstellungen für { -sync-brand-short-name } öffnen
           *[other] Einstellungen für { -sync-brand-short-name } öffnen
        }
    .accesskey = E
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Nicht mehr nachfragen
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Abbrechen
confirmation-dialog-dismiss-button =
    .title = Abbrechen
about-logins-confirm-remove-dialog-title = Diese Zugangsdaten entfernen?
confirm-delete-dialog-message = Diese Aktion kann nicht rückgängig gemacht werden.
about-logins-confirm-remove-dialog-confirm-button = Entfernen
about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Entfernen
        [one] Entfernen
       *[other] Alle entfernen
    }
about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Ja, diese Zugangsdaten entfernen
        [one] Ja, diese Zugangsdaten entfernen
       *[other] Ja, diese Zugangsdaten entfernen
    }
about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] { $count } Zugangsdaten entfernen?
       *[other] Alle { $count } Zugangsdaten entfernen?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Dadurch werden die Zugangsdaten, die Sie in { -brand-short-name } gespeichert haben, und alle Warnungen zu Datenlecks, die hier angezeigt werden, entfernt. Sie können diese Aktion nicht rückgängig machen.
        [one] Dadurch werden die Zugangsdaten, die Sie in { -brand-short-name } gespeichert haben, und alle Warnungen zu Datenlecks, die hier angezeigt werden, entfernt. Sie können diese Aktion nicht rückgängig machen.
       *[other] Dadurch werden die Zugangsdaten, die Sie in { -brand-short-name } gespeichert haben, und alle Warnungen zu Datenlecks, die hier angezeigt werden, entfernt. Sie können diese Aktion nicht rückgängig machen.
    }
about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] { $count } Zugangsdaten von allen Geräten entfernen?
       *[other] Alle { $count } Zugangsdaten von allen Geräten entfernen?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Dadurch werden die Zugangsdaten entfernt, die Sie in { -brand-short-name } auf allen Geräten gespeichert haben, die mit Ihrem { -fxaccount-brand-name } synchronisiert sind. Dadurch werden auch die hier angezeigten Warnungen zu Datenlecks entfernt. Sie können diese Aktion nicht rückgängig machen.
        [one] Dadurch werden die Zugangsdaten entfernt, die Sie in { -brand-short-name } auf allen Geräten gespeichert haben, die mit Ihrem { -fxaccount-brand-name } synchronisiert sind. Dadurch werden auch die hier angezeigten Warnungen zu Datenlecks entfernt. Sie können diese Aktion nicht rückgängig machen.
       *[other] Dadurch werden alle Zugangsdaten entfernt, die Sie in { -brand-short-name } auf allen Geräten gespeichert haben, die mit Ihrem { -fxaccount-brand-name } synchronisiert sind. Dadurch werden auch die hier angezeigten Warnungen zu Datenlecks entfernt. Sie können diese Aktion nicht rückgängig machen.
    }
about-logins-confirm-export-dialog-title = Zugangsdaten und Passwörter exportieren
about-logins-confirm-export-dialog-message = Ihre Passwörter werden als lesbarer Text gespeichert (z.B. P@ssw0rt). Dadurch hat jede Person, welche die exportierte Datei öffnen kann, Zugriff auf das unverschlüsselte Passwort.
about-logins-confirm-export-dialog-confirm-button = Exportieren…
about-logins-alert-import-title = Importieren abgeschlossen
about-logins-alert-import-message = Detaillierte Import-Zusammenfassung anzeigen
confirm-discard-changes-dialog-title = Nicht gespeicherte Änderungen verwerfen?
confirm-discard-changes-dialog-message = Alle nicht gespeicherten Änderungen gehen verloren.
confirm-discard-changes-dialog-confirm-button = Verwerfen

## Breach Alert notification

about-logins-breach-alert-title = Datenleck einer Website
breach-alert-text = Passwörter dieser Website wurden veröffentlicht oder gestohlen, seit Sie Ihre Zugangsdaten zuletzt aktualisiert haben. Ändern Sie Ihr Passwort, um Ihr Konto zu schützen.
about-logins-breach-alert-date = Das Datenleck wurde am { DATETIME($date, day: "numeric", month: "long", year: "numeric") } registriert.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = { $hostname } aufrufen
about-logins-breach-alert-learn-more-link = Weitere Informationen

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Gefährdetes Passwort
about-logins-vulnerable-alert-text2 = Dieses Passwort wurde auch für Zugangsdaten für eine andere Website verwendet und es ist wahrscheinlich von einem Datenleck dieser Website betroffen. Das Verwenden des gleichen Passworts gefährdet alle Benutzerkonten auf Websites mit dem gleichen Passwort.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = { $hostname } aufrufen
about-logins-vulnerable-alert-learn-more-link = Weitere Informationen

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Ein Eintrag für { $loginTitle } mit diesem Benutzernamen ist bereits vorhanden. <a data-l10n-name="duplicate-link">Bestehenden Eintrag aufrufen?</a>
# This is a generic error message.
about-logins-error-message-default = Beim Versuch, dieses Passwort zu speichern, ist ein Fehler aufgetreten.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Zugangsdaten in Datei exportieren
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = zugangsdaten.csv
about-logins-export-file-picker-export-button = Exportieren
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-Dokument
       *[other] CSV-Datei
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Zugangsdaten aus Datei importieren
about-logins-import-file-picker-import-button = Importieren
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-Dokument
       *[other] CSV-Datei
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV-Dokument
       *[other] TSV-Datei
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Importieren abgeschlossen
about-logins-import-dialog-items-added =
    { $count ->
        [one] <span>Neue Zugangsdaten hinzugefügt:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Neue Zugangsdaten hinzugefügt:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-modified =
    { $count ->
        [one] <span>Bestehende Zugangsdaten aktualisiert:</span> <span data-l10n-name="count">{ $count }</span>
       *[other] <span>Bestehende Zugangsdaten aktualisiert:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-no-change =
    { $count ->
        [one] <span>Doppelte Zugangsdaten gefunden:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(nicht importiert)</span>
       *[other] <span>Doppelte Zugangsdaten gefunden:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(nicht importiert)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
        [one] <span>Fehler:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(nicht importiert)</span>
       *[other] <span>Fehler:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(nicht importiert)</span>
    }
about-logins-import-dialog-done = Fertig
about-logins-import-dialog-error-title = Fehler beim Import
about-logins-import-dialog-error-conflicting-values-title = Mehrere widersprüchliche Werte für Zugangsdaten
about-logins-import-dialog-error-conflicting-values-description = Zum Beispiel: mehrere Benutzernamen, Passwörter, Website-Adressen usw. für dieselben Zugangsdaten.
about-logins-import-dialog-error-file-format-title = Dateiformatproblem
about-logins-import-dialog-error-file-format-description = Falsche oder fehlende Spaltenüberschriften. Bitte stellen Sie sicher, dass die Datei Spalten für Benutzername, Passwort und Website-Adresse enthält.
about-logins-import-dialog-error-file-permission-title = Datei konnte nicht gelesen werden
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } hat keine Berechtigung zum Lesen der Datei. Versuchen Sie, die Dateiberechtigungen zu ändern.
about-logins-import-dialog-error-unable-to-read-title = Datei konnte nicht verarbeitet werden
about-logins-import-dialog-error-unable-to-read-description = Stellen Sie sicher, dass eine CSV- oder TSV-Datei ausgewählt ist.
about-logins-import-dialog-error-no-logins-imported = Es wurden keine Zugangsdaten importiert
about-logins-import-dialog-error-learn-more = Weitere Informationen
about-logins-import-dialog-error-try-again = Erneut versuchen…
about-logins-import-dialog-error-try-import-again = Import erneut versuchen…
about-logins-import-dialog-error-cancel = Abbrechen
about-logins-import-report-title = Import-Zusammenfassung
about-logins-import-report-description = Zugangsdaten und Passwörter wurden in { -brand-short-name } importiert.
#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Zeile { $number }
about-logins-import-report-row-description-no-change = Duplikat: Exakte Übereinstimmung mit bestehenden Zugangsdaten
about-logins-import-report-row-description-modified = Bestehende Zugangsdaten aktualisiert
about-logins-import-report-row-description-added = Neue Zugangsdaten hinzugefügt
about-logins-import-report-row-description-error = Fehler: Fehlendes Feld

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Fehler: Mehrere Werte für { $field }
about-logins-import-report-row-description-error-missing-field = Fehler: { $field } fehlt

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Neue Zugangsdaten hinzugefügt</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Neue Zugangsdaten hinzugefügt</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Bestehende Zugangsdaten aktualisiert</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Bestehende Zugangsdaten aktualisiert</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Doppelte Zugangsdaten</div> <div data-l10n-name="not-imported">(nicht importiert)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Doppelte Zugangsdaten</div> <div data-l10n-name="not-imported">(nicht importiert)</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Fehler</div> <div data-l10n-name="not-imported">(nicht importiert)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">Fehler</div> <div data-l10n-name="not-imported">(nicht importiert)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Import-Zusammenfassungsbericht
