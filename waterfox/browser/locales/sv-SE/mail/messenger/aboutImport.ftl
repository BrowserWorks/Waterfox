# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Importera
export-page-title = Exportera

## Header

import-start = Importverktyg
import-start-title = Importera inställningar eller data från ett program eller en fil.
import-start-description = Välj den källa som du vill importera från. Du kommer senare att bli ombedd att välja vilken data som ska importeras.
import-from-app = Importera från applikation
import-file = Importera från en fil
import-file-title = Välj en fil för att importera dess innehåll.
import-file-description = Välj att importera en tidigare säkerhetskopierad profil, adressböcker eller kalendrar.
import-address-book-title = Importera adressboksfil
import-calendar-title = Importera kalenderfil
export-profile = Exportera

## Buttons

button-back = Tillbaka
button-continue = Fortsätt
button-export = Exportera
button-finish = Slutför

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Importera från en annan { app-name-thunderbird }-installation
source-thunderbird-description = Importera inställningar, filter, meddelanden och annan data från en { app-name-thunderbird }-profil.
source-seamonkey = Importera från en installation av { app-name-seamonkey }
source-seamonkey-description = Importera inställningar, filter, meddelanden och annan data från en { app-name-seamonkey }-profil.
source-outlook = Importera från { app-name-outlook }
source-outlook-description = Importera konton, adressböcker och meddelanden från { app-name-outlook }.
source-becky = Importera från { app-name-becky }
source-becky-description = Importera adressböcker och meddelanden från { app-name-becky }.
source-apple-mail = Importera från { app-name-apple-mail }
source-apple-mail-description = Importera meddelanden från { app-name-apple-mail }.
source-file2 = Importera från en fil
source-file-description = Välj en fil för att importera adressböcker, kalendrar eller en profilsäkerhetskopia (ZIP-fil).

## Import from file selections

file-profile2 = Importera säkerhetskopierad profil
file-profile-description = Välj en tidigare säkerhetskopierad Thunderbird-profil (.zip)
file-calendar = Importera kalendrar
file-calendar-description = Välj en fil som innehåller exporterade kalendrar eller händelser (.ics)
file-addressbook = Importera adressböcker
file-addressbook-description = Välj en fil som innehåller exporterade adressböcker och kontakter

## Import from app profile steps

from-app-thunderbird = Importera från en { app-name-thunderbird }-profil
from-app-seamonkey = Importera från en { app-name-seamonkey }-profil
from-app-outlook = Importera från { app-name-outlook }
from-app-becky = Importera från { app-name-becky }
from-app-apple-mail = Importera från { app-name-apple-mail }
profiles-pane-title-thunderbird = Importera inställningar och data från en { app-name-thunderbird }-profil.
profiles-pane-title-seamonkey = Importera inställningar och data från en { app-name-seamonkey }-profil.
profiles-pane-title-outlook = Importera data från { app-name-outlook }.
profiles-pane-title-becky = Importera data från { app-name-becky }.
profiles-pane-title-apple-mail = Importera meddelanden från { app-name-apple-mail }.
profile-source = Importera från profil
# $profileName (string) - name of the profile
profile-source-named = Importera från profilen <strong>"{ $profileName }"</strong>
profile-file-picker-directory = Välj en profilmapp
profile-file-picker-archive = Välj en <strong>ZIP</strong>-fil
profile-file-picker-archive-description = ZIP-filen måste vara mindre än 2 GB.
profile-file-picker-archive-title = Välj en ZIP-fil (mindre än 2 GB)
items-pane-title2 = Välj vad som ska importeras:
items-pane-directory = Mapp:
items-pane-profile-name = Profilnamn:
items-pane-checkbox-accounts = Konton och inställningar
items-pane-checkbox-address-books = Adressböcker
items-pane-checkbox-calendars = Kalendrar
items-pane-checkbox-mail-messages = E-postmeddelanden
items-pane-override = Eventuella befintliga eller identiska data kommer inte att skrivas över.

## Import from address book file steps

import-from-addr-book-file-description = Välj filformatet som innehåller din adressboksdata.
addr-book-csv-file = Komma eller tabbseparerad fil (.csv, .tsv)
addr-book-ldif-file = LDIF-fil (.ldif)
addr-book-vcard-file = vCard-fil (.vcf, .vcard)
addr-book-sqlite-file = SQLite databasfil (.sqlite)
addr-book-mab-file = Mork databasfil (.mab)
addr-book-file-picker = Välj en adressboksfil
addr-book-csv-field-map-title = Matcha fältnamn
addr-book-csv-field-map-desc = Välj adressboksfält som motsvarar källfälten. Avmarkera fält som du inte vill importera.
addr-book-directories-title = Välj var du vill importera den valda data
addr-book-directories-pane-source = Källfil:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Skapa en ny katalog som heter <strong>"{ $addressBookName }"</strong>
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Importera den valda informationen till katalogen "{ $addressBookName }".
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = En ny adressbok som heter "{ $addressBookName }" kommer att skapas.

## Import from calendar file steps

import-from-calendar-file-desc = Välj iCalendar-filen (.ics) som du vill importera.
calendar-items-title = Välj vilka objekt som ska importeras.
calendar-items-loading = Laddar objekt...
calendar-items-filter-input =
    .placeholder = Filtrera objekt...
calendar-select-all-items = Markera alla
calendar-deselect-all-items = Avmarkera alla
calendar-target-title = Välj var de valda objekten ska importeras.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Skapa en ny kalender som heter <strong>"{ $targetCalendar }"</strong>
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Importera ett objekt till "{ $targetCalendar }"-kalendern
       *[other] Importera { $itemCount } objekt till "{ $targetCalendar }"-kalendern
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = En ny kalender som heter "{ $targetCalendar }" kommer att skapas.

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Importerar… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Exporterar… { $progressPercent }
progress-pane-finished-desc2 = Slutförd.
error-pane-title = Fel
error-message-zip-file-too-big2 = Den valda ZIP-filen är större än 2 GB. Extrahera det först och importera sedan från den extraherade mappen istället.
error-message-extract-zip-file-failed2 = Det gick inte att extrahera ZIP-filen. Extrahera det manuellt och importera sedan från den extraherade mappen istället.
error-message-failed = Importen misslyckades oväntat, mer information kan finnas tillgänglig i felkonsolen.
error-failed-to-parse-ics-file = Inga importerbara objekt hittades i filen.
error-export-failed = Exporten misslyckades oväntat, mer information kan finnas tillgänglig i felkonsolen.
error-message-no-profile = Ingen profil hittades.

## <csv-field-map> element

csv-first-row-contains-headers = Första raden innehåller fältnamn
csv-source-field = Källfält
csv-source-first-record = Första posten
csv-source-second-record = Andra posten
csv-target-field = Adressboksfält

## Export tab

export-profile-title = Exportera konton, meddelanden, adressböcker och inställningar till en ZIP-fil.
export-profile-description = Om din nuvarande profil är större än 2 GB föreslår vi att du säkerhetskopierar den själv.
export-open-profile-folder = Öppna profilmapp
export-file-picker2 = Exportera till en ZIP-fil
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Data som ska importeras
summary-pane-start = Börja import
summary-pane-warning = { -brand-product-name } måste startas om när importen är klar.
summary-pane-start-over = Starta om importverktyget

## Footer area

footer-help = Behöver du hjälp?
footer-import-documentation = Importera dokumentation
footer-export-documentation = Exportera dokumentation
footer-support-forum = Supportforum

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Importsteg
step-confirm = Bekräfta
# Variables:
# $number (number) - step number
step-count = { $number }
