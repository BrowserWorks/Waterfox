# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Importeren
export-page-title = Exporteren

## Header

import-start = Importhulpmiddel
import-start-title = Instellingen of gegevens uit een toepassing of een bestand importeren.
import-start-description = Selecteer de bron waaruit u wilt importeren. U wordt later gevraagd om te kiezen welke gegevens geïmporteerd moeten worden.
import-from-app = Importeren uit toepassing
import-file = Uit een bestand importeren
import-file-title = Selecteer een bestand om de inhoud ervan te importeren.
import-file-description = Kiezen om een eerdere reservekopie van een profiel, adresboeken of agenda’s te importeren.
import-address-book-title = Adresboekbestand importeren
import-calendar-title = Agendabestand importeren
export-profile = Exporteren

## Buttons

button-back = Terug
button-continue = Doorgaan
button-export = Exporteren
button-finish = Voltooien

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Importeren uit een andere { app-name-thunderbird }-installatie
source-thunderbird-description = Instellingen, filters, berichten en andere gegevens uit een { app-name-thunderbird }-profiel importeren.
source-seamonkey = Importeren vanuit een { app-name-seamonkey }-installatie
source-seamonkey-description = Instellingen, filters, berichten en andere gegevens uit een { app-name-seamonkey }-profiel importeren.
source-outlook = Importeren uit { app-name-outlook }
source-outlook-description = Accounts, adresboeken en berichten uit { app-name-outlook } importeren.
source-becky = Importeren uit { app-name-becky }
source-becky-description = Adresboeken en berichten importeren uit { app-name-becky }.
source-apple-mail = Importeren uit { app-name-apple-mail }
source-apple-mail-description = Berichten importeren uit { app-name-apple-mail }.
source-file2 = Uit een bestand importeren
source-file-description = Selecteer een bestand om adresboeken, agenda’s of een reservekopie van een profiel (ZIP-bestand) te importeren.

## Import from file selections

file-profile2 = Reservekopie van profiel importeren
file-profile-description = Selecteer een eerdere reservekopie van een Thunderbird-profiel (.zip)
file-calendar = Agenda’s importeren
file-calendar-description = Selecteer een bestand met geëxporteerde agenda’s of evenementen (.ics)
file-addressbook = Adresboeken importeren
file-addressbook-description = Selecteer een bestand met geëxporteerde adresboeken en contacten

## Import from app profile steps

from-app-thunderbird = Importeren vanuit een { app-name-thunderbird }-profiel
from-app-seamonkey = Importeren vanuit een { app-name-seamonkey }-profiel
from-app-outlook = Importeren uit { app-name-outlook }
from-app-becky = Importeren uit { app-name-becky }
from-app-apple-mail = Importeren uit { app-name-apple-mail }
profiles-pane-title-thunderbird = Instellingen en gegevens importeren uit een { app-name-thunderbird }-profiel.
profiles-pane-title-seamonkey = Instellingen en gegevens importeren uit een { app-name-seamonkey }-profiel.
profiles-pane-title-outlook = Gegevens importeren uit { app-name-outlook }.
profiles-pane-title-becky = Gegevens importeren uit { app-name-becky }.
profiles-pane-title-apple-mail = Berichten importeren uit { app-name-apple-mail }.
profile-source = Uit profiel importeren
# $profileName (string) - name of the profile
profile-source-named = Uit profiel <strong>‘{ $profileName }’</strong> importeren
profile-file-picker-directory = Kies een profielmap
profile-file-picker-archive = Kies een <strong>ZIP</strong>-bestand
profile-file-picker-archive-description = Het ZIP-bestand moet kleiner zijn dan 2 GB.
profile-file-picker-archive-title = Kies een ZIP-bestand (kleiner dan 2GB)
items-pane-title2 = Kies wat u wilt importeren:
items-pane-directory = Map:
items-pane-profile-name = Profielnaam:
items-pane-checkbox-accounts = Accounts en instellingen
items-pane-checkbox-address-books = Adresboeken
items-pane-checkbox-calendars = Agenda’s
items-pane-checkbox-mail-messages = E-mailberichten
items-pane-override = Bestaande of identieke gegevens worden niet overschreven.

## Import from address book file steps

import-from-addr-book-file-description = Kies het bestandsformaat met uw adresboekgegevens.
addr-book-csv-file = Door komma’s of tabs gescheiden bestand (.csv, .tsv)
addr-book-ldif-file = LDIF-bestand (.ldif)
addr-book-vcard-file = vCard-bestand (.vcf, .vcard)
addr-book-sqlite-file = SQLite-databasebestand (.sqlite)
addr-book-mab-file = Mork-databasebestand (.mab)
addr-book-file-picker = Selecteer een adresboekbestand
addr-book-csv-field-map-title = Veldnamen overeen laten komen
addr-book-csv-field-map-desc = Selecteer adresboekvelden die overeenkomen met de bronvelden. Vink velden uit die u niet wilt importeren.
addr-book-directories-title = Selecteer waar u de gekozen gegevens wilt importeren
addr-book-directories-pane-source = Bronbestand:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Een nieuwe map aanmaken met de naam <strong>‘{ $addressBookName }’</strong>
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = De gekozen gegevens importeren in de map ‘{ $addressBookName }’
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = Er wordt een nieuw adresboek met de naam ‘{ $addressBookName }’ gemaakt.

## Import from calendar file steps

import-from-calendar-file-desc = Selecteer het iCalendar (.ics)-bestand dat u wilt importeren.
calendar-items-title = Selecteer de te importeren items.
calendar-items-loading = Items laden…
calendar-items-filter-input =
    .placeholder = Items filteren…
calendar-select-all-items = Alles selecteren
calendar-deselect-all-items = Alles deselecteren
calendar-target-title = Selecteer waar u de gekozen items wilt importeren.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Een nieuwe agenda maken met de naam <strong>‘{ $targetCalendar }’</strong>
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Eén item importeren in de agenda ‘{ $targetCalendar }’
       *[other] { $itemCount } items importeren in de agenda ‘{ $targetCalendar }’
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = Er wordt een nieuwe agenda gemaakt met de naam ‘{ $targetCalendar }’.

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Importeren… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Exporteren… { $progressPercent }
progress-pane-finished-desc2 = Voltooid.
error-pane-title = Fout
error-message-zip-file-too-big2 = Het geselecteerde ZIP-bestand is groter dan 2 GB. Pak het eerst uit en importeer het vervolgens uit de uitgepakte map.
error-message-extract-zip-file-failed2 = Kan het ZIP-bestand niet uitpakken. Pak het handmatig uit en importeer het vervolgens uit de uitgepakte map.
error-message-failed = Importeren is onverwacht mislukt, meer informatie is mogelijk beschikbaar in de Foutconsole.
error-failed-to-parse-ics-file = Geen te importeren items gevonden in het bestand.
error-export-failed = Exporteren is onverwacht mislukt, meer informatie is mogelijk beschikbaar in de Foutconsole.
error-message-no-profile = Geen profiel gevonden.

## <csv-field-map> element

csv-first-row-contains-headers = Eerste rij bevat veldnamen
csv-source-field = Bronveld
csv-source-first-record = Eerste record
csv-source-second-record = Tweede record
csv-target-field = Adresboekveld

## Export tab

export-profile-title = Accounts, berichten, adresboeken en instellingen naar een ZIP-bestand exporteren.
export-profile-description = Als uw huidige profiel groter is dan 2 GB, raden we u aan er zelf een reservekopie van te maken.
export-open-profile-folder = Profielmap openen
export-file-picker2 = Exporteren naar een ZIP-bestand
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Te importeren gegevens
summary-pane-start = Import starten
summary-pane-warning = { -brand-product-name } moet opnieuw worden gestart wanneer het importeren is voltooid.
summary-pane-start-over = Importeerhulpmiddel herstarten

## Footer area

footer-help = Hulp nodig?
footer-import-documentation = Importdocumentatie
footer-export-documentation = Exportdocumentatie
footer-support-forum = Ondersteuningsforum

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Importstappen
step-confirm = Bevestigen
# Variables:
# $number (number) - step number
step-count = { $number }
