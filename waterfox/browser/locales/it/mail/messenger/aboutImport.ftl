# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Importazione

export-page-title = Esporta

## Header

import-start = Strumento per l’importazione

import-start-title = Importa impostazioni o dati da un’applicazione o da un file.

import-start-description = Seleziona la fonte da cui desideri importare. Successivamente ti verrà chiesto di scegliere quali dati devono essere importati.

import-from-app = Importa da applicazione

import-file = Importa da file

import-file-title = Seleziona un file per importarne il contenuto.

import-file-description = Scegli di importare un profilo di cui è stato eseguito il backup in precedenza, rubriche o calendari.

import-address-book-title = Importazione file della rubrica

import-calendar-title = Importazione file del calendario

export-profile = Esporta

## Buttons

button-back = Indietro

button-continue = Continua

button-export = Esporta

button-finish = Fine

## Import from app steps

app-name-thunderbird = Thunderbird

app-name-seamonkey = SeaMonkey

app-name-outlook = Outlook

app-name-becky = Becky! Internet Mail

app-name-apple-mail = Apple Mail

source-thunderbird = Importa da un’altra installazione di { app-name-thunderbird }

source-thunderbird-description = Importa impostazioni, filtri, messaggi e altri dati da un profilo { app-name-thunderbird }.

source-seamonkey = Importa da un’installazione di { app-name-seamonkey }

source-seamonkey-description = Importa impostazioni, filtri, messaggi e altri dati da un profilo { app-name-seamonkey }.

source-outlook = Importa da { app-name-outlook }

source-outlook-description = Importa account, rubriche e messaggi da { app-name-outlook }.

source-becky = Importa da { app-name-becky }

source-becky-description = Importa rubriche e messaggi da { app-name-becky }.

source-apple-mail = Importa da { app-name-apple-mail }

source-apple-mail-description = Importa messaggi da { app-name-apple-mail }.

source-file2 = Importa da file

source-file-description = Seleziona un file per importare rubriche, calendari o un backup del profilo (file ZIP).

## Import from file selections

file-profile2 = Importa profilo di backup

file-profile-description = Seleziona un profilo Thunderbird di cui è stato eseguito il backup in precedenza (.zip)

file-calendar = Importa calendari

file-calendar-description = Seleziona un file contenente calendari o eventi esportati (.ics)

file-addressbook = Importa rubriche

file-addressbook-description = Seleziona un file contenente rubriche e contatti esportati

## Import from app profile steps

from-app-thunderbird = Importa da un profilo { app-name-thunderbird }

from-app-seamonkey = Importa da un profilo { app-name-seamonkey }

from-app-outlook = Importa da { app-name-outlook }

from-app-becky = Importa da { app-name-becky }

from-app-apple-mail = Importa da { app-name-apple-mail }

profiles-pane-title-thunderbird = Importa impostazioni e dati da un profilo { app-name-thunderbird }.

profiles-pane-title-seamonkey = Importa impostazioni e dati da un profilo { app-name-seamonkey }.

profiles-pane-title-outlook = Importa dati da { app-name-outlook }.

profiles-pane-title-becky = Importa dati da { app-name-becky }.

profiles-pane-title-apple-mail = Importa messaggi da { app-name-apple-mail }.

profile-source = Importa da profilo

# $profileName (string) - name of the profile
profile-source-named = Importa dal profilo <strong>“{ $profileName }”</strong>

profile-file-picker-directory = Scegli una cartella del profilo

profile-file-picker-archive = Scegli un file <strong>ZIP</strong>

profile-file-picker-archive-description = La dimensione del file ZIP deve essere inferiore a 2 GB.

profile-file-picker-archive-title = Scegli un file ZIP (dimensione inferiore a 2 GB)

items-pane-title2 = Scegli che cosa vuoi importare:

items-pane-directory = Directory:

items-pane-profile-name = Nome profilo:

items-pane-checkbox-accounts = Account e impostazioni

items-pane-checkbox-address-books = Rubriche

items-pane-checkbox-calendars = Calendari

items-pane-checkbox-mail-messages = Messaggi di posta

items-pane-override = Eventuali dati esistenti o identici non verranno sovrascritti.

## Import from address book file steps

import-from-addr-book-file-description = Scegli il formato del file contenente i dati della tua rubrica.

addr-book-csv-file = File con valori delimitati da virgole o tabulazioni (.csv, .tsv)

addr-book-ldif-file = File LDIF (.ldif)

addr-book-vcard-file = File vCard (.vcf, .vcard)

addr-book-sqlite-file = File di database SQLite (.sqlite)

addr-book-mab-file = File di database Mork (.mab)

addr-book-file-picker = Seleziona un file di rubrica

addr-book-csv-field-map-title = Corrispondenza nomi dei campi

addr-book-csv-field-map-desc = Seleziona i campi della rubrica corrispondenti ai campi di origine. Deseleziona i campi che non desideri importare.

addr-book-directories-title = Seleziona dove importare i dati scelti

addr-book-directories-pane-source = File di origine:

# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Crea una nuova directory chiamata <strong>“{ $addressBookName }”</strong>

# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Importa i dati scelti nella directory “{ $addressBookName }”

# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = Verrà creata una nuova rubrica con nome “{ $addressBookName }”.

## Import from calendar file steps

import-from-calendar-file-desc = Seleziona il file iCalendar (.ics) da importare.

calendar-items-title = Seleziona gli elementi da importare.

calendar-items-loading = Caricamento elementi…

calendar-items-filter-input =
    .placeholder = Filtra elementi…

calendar-select-all-items = Seleziona tutto

calendar-deselect-all-items = Deseleziona tutto

calendar-target-title = Seleziona dove importare gli elementi scelti.

# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Crea un nuovo calendario con nome <strong>“{ $targetCalendar }”</strong>

# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Importa un elemento nel calendario “{ $targetCalendar }”
       *[other] Importa { $itemCount } elementi nel calendario “{ $targetCalendar }”
    }

# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = Verrà creato un nuovo calendario con nome “{ $targetCalendar }”.

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Importazione in corso… { $progressPercent }

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Esportazione in corso… { $progressPercent }

progress-pane-finished-desc2 = Completata.

error-pane-title = Errore

error-message-zip-file-too-big2 = Il file ZIP selezionato è più grande di 2 GB. Estrai i file, poi importa dalla cartella estratta.

error-message-extract-zip-file-failed2 = Estrazione del file ZIP non riuscita. Estrarre i file manualmente, quindi importarli dalla cartella estratta.

error-message-failed = Importazione non riuscita per un errore inatteso; potrebbero essere disponibili ulteriori informazioni nella console degli errori.

error-failed-to-parse-ics-file = Non è stato trovato alcun elemento importabile nel file.

error-export-failed = Esportazione non riuscita per un errore inatteso; potrebbero essere disponibili ulteriori informazioni nella console degli errori.

error-message-no-profile = Nessun profilo trovato.

## <csv-field-map> element

csv-first-row-contains-headers = La prima riga contiene i nomi dei campi

csv-source-field = Campo di origine

csv-source-first-record = Primo record

csv-source-second-record = Secondo record

csv-target-field = Campo della rubrica

## Export tab

export-profile-title = Esporta account, messaggi, rubriche e impostazioni in un file ZIP.

export-profile-description = Se la dimensione della cartella del profilo attuale è superiore a 2 GB, ti consigliamo di eseguirne il backup manualmente.

export-open-profile-folder = Apri cartella del profilo

export-file-picker2 = Esporta in un file ZIP

export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Dati da importare

summary-pane-start = Avvia importazione

summary-pane-warning = Sarà necessario riavviare { -brand-product-name } al termine dell’importazione.

summary-pane-start-over = Riavvia lo strumento di importazione

## Footer area

footer-help = Hai bisogno di aiuto?

footer-import-documentation = Documentazione relativa all’importazione

footer-export-documentation = Documentazione relativa all’esportazione

footer-support-forum = Forum di supporto

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Passaggi importazione

step-confirm = Conferma

# Variables:
# $number (number) - step number
step-count = { $number }
