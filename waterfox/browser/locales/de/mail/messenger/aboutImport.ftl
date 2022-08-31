# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Import

export-page-title = Export

## Header

import-start = Importwerkzeug

import-start-title = Einstellungen oder Daten aus einer anderen Anwendung oder Datei importieren

import-start-description = Wählen Sie aus, woher importiert werden soll. Sie können die zu importierenden Daten später auswählen.

import-from-app = Aus Anwendung importieren

import-from-app-desc = Zu importierende Konten, Adressbücher, Kalender und weitere Daten auswählen:

import-address-book = Adressbuchdatei importieren

import-calendar = Kalenderdatei importieren

import-file = Aus Datei importieren

import-file-title = Datei auswählen, deren Inhalt importiert werden soll

import-file-description = Wählen Sie eine vorher erstellte Sicherheitskopie des Profils, Adressbücher oder Kalender.

import-address-book-title = Adressbuchdatei importieren

import-calendar-title = Kalenderdatei importieren

export-profile = Exportieren

## Buttons

button-cancel = Abbrechen

button-back = Zurück

button-continue = Weiter

button-export = Exportieren

button-finish = Beenden

## Import from app steps

app-name-thunderbird = Thunderbird

app-name-seamonkey = SeaMonkey

app-name-outlook = Outlook

app-name-becky = Becky! Internet Mail

app-name-apple-mail = Apple Mail

# Variables:
#   $app (String) - The name of the app to import from
profiles-pane-title = Import aus { $app }

profiles-pane-desc = Speicherort wählen, aus dem importiert werden soll

profile-file-picker-dir = Profilordner wählen

profile-file-picker-zip = .zip-Datei wählen (kleiner als 2GB)

items-pane-title = Wählen Sie die zu importierenden Daten aus

items-pane-source = Import aus folgendem Speicherort:

source-thunderbird = Import aus einer anderen { app-name-thunderbird }-Installation

source-thunderbird-description = Einstellungen, Nachrichtenfilter, Nachrichten und andere Daten aus einem { app-name-thunderbird }-Profil importieren

source-seamonkey = Import aus einer { app-name-seamonkey }-Installation

source-seamonkey-description = Einstellungen, Nachrichtenfilter, Nachrichten und andere Daten aus einem { app-name-seamonkey }-Profil importieren

source-outlook = Import aus { app-name-outlook }

source-outlook-description = Konten, Adressbücher und Nachrichten aus { app-name-outlook } importieren

source-becky = Import aus { app-name-becky }

source-becky-description = Adressbücher und Nachrichten aus { app-name-becky } importieren

source-apple-mail = Import aus { app-name-apple-mail }

source-apple-mail-description = Nachrichten aus { app-name-apple-mail } importieren

source-file2 = Import aus Datei

source-file-description = Wählen Sie eine Datei, um Adressbücher, Kalender oder eine Sicherheitskopie des Profiles zu importieren (.zip-Datei).

## Import from file selections

file-profile2 = Profil aus Sicherheitkopie importieren

file-profile-description = Vorher angelegte Sicherheitskopie eine Thunderbird-Profils auswählen (.zip)

file-calendar = Kalender importieren

file-calendar-description = Datei auswählen, welche Kalender oder Termine enthält (.ics)

file-addressbook = Adressbücher importieren

file-addressbook-description = Datei auswählen, welche Adressbücher und Kontakte enthält

## Import from app profile steps

from-app-thunderbird = Import aus einem { app-name-thunderbird }-Profil

from-app-seamonkey = Import aus einem { app-name-seamonkey }-Profil

from-app-outlook = Import aus { app-name-outlook }

from-app-becky = Import aus { app-name-becky }

from-app-apple-mail = Import aus { app-name-apple-mail }

profiles-pane-title-thunderbird = Einstellungen und Daten aus { app-name-thunderbird }-Profil importieren

profiles-pane-title-seamonkey = Einstellungen und Daten aus { app-name-seamonkey }-Profil importieren

profiles-pane-title-outlook = Daten aus { app-name-outlook } importieren

profiles-pane-title-becky = Daten aus { app-name-becky } importieren

profiles-pane-title-apple-mail = Nachrichten aus { app-name-apple-mail } importieren

profile-source = Aus Profil importieren

# $profileName (string) - name of the profile
profile-source-named = Aus Profil <strong>"{ $profileName }"</strong> importieren

profile-file-picker-directory = Profilordner auswählen

profile-file-picker-archive = <strong>.zip</strong>-Datei auswählen

profile-file-picker-archive-description = Die .zip-Datei muss kleiner als 2GB sein.

profile-file-picker-archive-title = ZIP-Datei auswählen (kleiner als 2GB)

items-pane-title2 = Zu importierende Daten:

items-pane-directory = Ordner:

items-pane-profile-name = Profilname:

items-pane-checkbox-accounts = Konten und Einstellungen

items-pane-checkbox-address-books = Adressbücher

items-pane-checkbox-calendars = Kalender

items-pane-checkbox-mail-messages = E-Mail-Nachrichten

items-pane-override = Bestehende oder identische Daten werden nicht überschrieben.

## Import from address book file steps

import-from-addr-book-file-desc = Zu importierenden Dateityp auswählen:

import-from-addr-book-file-description = Dateiformat des zu importierenden Adressbuchs auswählen

addr-book-csv-file = Komma- oder Tabulator-getrennte Datei (.csv, .tsv)

addr-book-ldif-file = LDIF-Datei (.ldif)

addr-book-vcard-file = vCard-Datei (.vcf, .vcard)

addr-book-sqlite-file = SQLite-Datenbank-Datei (.sqlite)

addr-book-mab-file = Mork-basiertes Adressbuch (.mab)

addr-book-file-picker = Adressbuchdatei auswählen

addr-book-csv-field-map-title = Übereinstimmende Feldnamen erkennen

addr-book-csv-field-map-desc = Weisen Sie den Quellfeldern der Datei die entsprechenden Adressbuchfelder zu. Wählen Sie nicht zu importierende Felder ab.

addr-book-directories-pane-title = Wählen Sie den Ordner aus, in welchen importiert werden soll:

addr-book-directories-title = Zu verwendendes Adressbuch auswählen

addr-book-directories-pane-source = Quelldatei:

addr-book-import-into-new-directory = Neuen Ordner erstellen

## Import from address book file steps

# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Neues Adressbuch mit Namen <strong>"{ $addressBookName }"</strong> erstellen

# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Ausgewählte Daten in "{ $addressBookName }"-Verzeichnis importieren

# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = Es wird ein neues Adressbuch mit dem Namen "{ $addressBookName }" erstellt.

## Import from calendar file steps

import-from-calendar-file-desc = Zu importierende Kalenderdatei (.ics) auswählen

calendar-items-title = Zu importierende Elemente auswählen

calendar-items-loading = Elemente werden geladen…

calendar-items-filter-input =
  .placeholder = Elemente filtern…

calendar-select-all-items = Alle auswählen

calendar-deselect-all-items = Alle abwählen

calendar-import-into-new-calendar = Neuen Kalender erstellen

calendar-target-title = Zu verwendender Kalender

# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Neuen Kalender mit Namen <strong>"{ $targetCalendar }"</strong> erstellen

# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
  { $itemCount ->
    [one] Ein Element in den Kalender "{ $targetCalendar }" importieren
    *[other] { $itemCount } Elemente in den Kalender "{ $targetCalendar }" importieren
  }

# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = Es wird ein Kalender mit dem Namen "{ $targetCalendar }" erstellt.

## Import dialog

progress-pane-importing = Import wird durchgeführt

progress-pane-exporting = Export wird durchgeführt

progress-pane-finished-desc = Abgeschlossen

progress-pane-restart-desc = Neu starten, um den Import abzuschließen.

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Import wird durchgeführt… { $progressPercent }

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Export wird durchgeführt… { $progressPercent }

progress-pane-finished-desc2 = Fertig

error-pane-title = Fehler

error-message-zip-file-too-big = Die ausgewählte .zip-Datei ist größer als 2GB. Entpacken Sie diese erst und importieren Sie anschließend den entpackten Ordner.

error-message-extract-zip-file-failed = Fehler beim Entpacken der .zip-Datei. Entpacken Sie diese erst und importieren Sie anschließend den entpackten Ordner.

error-message-zip-file-too-big2 = Die ausgewählte .zip-Datei ist größer als 2GB. Entpacken Sie diese erst und importieren Sie anschließend den entpackten Ordner.

error-message-extract-zip-file-failed2 = Fehler beim Entpacken der .zip-Datei. Entpacken Sie diese erst und importieren Sie anschließend den entpackten Ordner.

error-message-failed = Der Import schlug unerwartet fehl. Weitere Informationen in der Fehlerkonsole.

error-failed-to-parse-ics-file = Keine importierbaren Einträge in der Kalenderdatei erkannt.

error-export-failed = Der Export schlug unerwartet fehl. Weitere Informationen in der Fehlerkonsole.

error-message-no-profile = Kein Profil erkannt

## <csv-field-map> element

csv-first-row-contains-headers = Erster Eintrag enthält die Feldnamen

csv-source-field = Quellfeld

csv-source-first-record = Erster Eintrag

csv-source-second-record = Zweiter Eintrag

csv-target-field = Adressbuchfeld

## Export tab

export-profile-desc = E-Mail-Konten und -Nachrichten sowie Adressbücher und Einstellungen in eine ZIP-Datei exportieren. Bei Bedarf kann die ZIP-Datei importiert werden, um Ihr Profil wiederherzustellen.

export-profile-desc2 = Falls der Profilordner größer als 2GB ist, wird das manuelle Erstellen der Sicherheitskopie empfohlen.

export-profile-title = Konten, Nachrichten, Adressbücher und Einstellungen in eine .zip-Datei exportieren

export-profile-description = Falls der Profilordner größer als 2GB ist, wird das manuelle Erstellen der Sicherheitskopie empfohlen.

export-open-profile-folder = Profilordner öffnen

export-file-picker = In ZIP-Datei exportieren

export-file-picker2 = In ZIP-Datei exportieren

export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Zu importierende Daten

summary-pane-start = Import starten

summary-pane-warning = { -brand-product-name } muss nach dem Abschluss des Imports neu gestartet werden.

summary-pane-start-over = Importwerkzeug neu starten

## Footer area

footer-help = Hilfe benötigt?

footer-import-documentation = Import-Dokumentation

footer-export-documentation = Export-Dokumentation

footer-support-forum = Hilfeforum

## Step navigation on top of the wizard pages

step-list =
  .aria-label = Importschritte

step-confirm = Bestätigung

# Variables:
# $number (number) - step number
step-count = { $number }
