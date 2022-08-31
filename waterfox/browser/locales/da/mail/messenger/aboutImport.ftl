# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Importer
export-page-title = Eksporter

## Header

import-start = Importværktøj
import-start-title = Importer indstillinger eller data fra et program eller en fil.
import-start-description = Vælg den kilde, du vil importere fra. Du vil senere blive bedt om at vælge, hvilke data der skal importeres.
import-from-app = Importer fra program
import-file = Importer fra en fil
import-file-title = Vælg en fil for at importere dens indhold.
import-file-description = Vælg at importere en tidligere sikkerhedskopieret profil, adressebøger eller kalendere.
import-address-book-title = Importer adressebogsfil
import-calendar-title = Importer kalenderfil
export-profile = Eksporter

## Buttons

button-back = Tilbage
button-continue = Fortsæt
button-export = Eksporter
button-finish = Afslut

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Importer fra en anden { app-name-thunderbird }-installation
source-thunderbird-description = Importer indstillinger, filtre, meddelelser og andre data fra en { app-name-thunderbird }-profil.
source-seamonkey = Importer fra en { app-name-seamonkey }-installation
source-seamonkey-description = Importer indstillinger, filtre, meddelelser og andre data fra en { app-name-seamonkey }-profil.
source-outlook = Importer fra { app-name-outlook }
source-outlook-description = Importer konti, adressebøger og meddelelser fra { app-name-outlook }.
source-becky = Importer fra { app-name-becky }
source-becky-description = Importer adressebøger og meddelelser fra { app-name-becky }.
source-apple-mail = Importer fra { app-name-apple-mail }
source-apple-mail-description = Importer meddelelser fra { app-name-apple-mail }.
source-file2 = Importer fra en fil
source-file-description = Vælg en fil for at importere adressebøger, kalendere eller en sikkerhedskopieret profil (ZIP-fil).

## Import from file selections

file-profile2 = Importer sikkerhedskopieret profil
file-profile-description = Vælg en tidligere sikkerhedskopieret Thunderbird-profil (.zip)
file-calendar = Importer kalendere
file-calendar-description = Vælg en fil, der indeholder eksporterede kalendere eller begivenheder (.ics)
file-addressbook = Importer adressebøger
file-addressbook-description = Vælg en fil, der indeholder eksporterede adressebøger og kontakter

## Import from app profile steps

from-app-thunderbird = Importer fra en { app-name-thunderbird }-profil
from-app-seamonkey = Importer fra en { app-name-seamonkey }-profil
from-app-outlook = Importer fra { app-name-outlook }
from-app-becky = Importer fra { app-name-becky }
from-app-apple-mail = Importer fra { app-name-apple-mail }
profiles-pane-title-thunderbird = Importer indstillinger og data fra en { app-name-thunderbird }-profil.
profiles-pane-title-seamonkey = Importer indstillinger og data fra en { app-name-seamonkey }-profil.
profiles-pane-title-outlook = Importer data fra { app-name-outlook }.
profiles-pane-title-becky = Importer data fra { app-name-becky }.
profiles-pane-title-apple-mail = Importer meddelelser fra { app-name-apple-mail }.
profile-source = Importer fra profil
# $profileName (string) - name of the profile
profile-source-named = Importer fra profilen <strong>"{ $profileName }"</strong>
profile-file-picker-directory = Vælg en profilmappe
profile-file-picker-archive = Vælg en <strong>ZIP-komprimeret</strong> fil
profile-file-picker-archive-description = Den ZIP-komprimerede fil skal være mindre end 2GB.
profile-file-picker-archive-title = Vælg en ZIP-komprimeret fil (mindre end 2GB)
items-pane-title2 = Vælg, hvad der skal importeres:
items-pane-directory = Mappe:
items-pane-profile-name = Profilnavn:
items-pane-checkbox-accounts = Konti og indstillinger
items-pane-checkbox-address-books = Adressebøger
items-pane-checkbox-calendars = Kalendere
items-pane-checkbox-mail-messages = Mailmeddelelser
items-pane-override = Eksisterende eller identiske data vil ikke blive overskrevet.

## Import from address book file steps

import-from-addr-book-file-description = Vælg det filformat, der indeholder dine adressebogsdata.
addr-book-csv-file = Komma- eller tabulatorsepareret fil (.csv, .tsv)
addr-book-ldif-file = LDIF-fil (.ldif)
addr-book-vcard-file = vCard-fil (.vcf, .vcard)
addr-book-sqlite-file = SQLite-databasefil (.sqlite)
addr-book-mab-file = Mork-databasefil (.mab)
addr-book-file-picker = Vælg en adressebogsfil
addr-book-csv-field-map-title = Match feltnavne
addr-book-csv-field-map-desc = Vælg adressebogsfelter, der svarer til kildefelterne. Fjern fluebenene ud for felter, du ikke vil importere.
addr-book-directories-title = Vælg, hvor de valgte data skal importeres til
addr-book-directories-pane-source = Kildefil:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Opret en ny mappe med navnet <strong>"{ $addressBookName }"</strong>
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Importer de valgte data til mappen <strong>"{ $addressBookName }"</strong>
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = En ny adressebog med navnet "{ $addressBookName }" vil blive oprettet.

## Import from calendar file steps

import-from-calendar-file-desc = Vælg den iCalendar (.ics)-fil, du ønsker at importere.
calendar-items-title = Vælg hvilke elementer, der skal importeres.
calendar-items-loading = Indlæser elementer…
calendar-items-filter-input =
    .placeholder = Filtrer elementer...
calendar-select-all-items = Vælg alle
calendar-deselect-all-items = Fravælg alle
calendar-target-title = Vælg, hvor de valgte elementer skal importeres til.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Opret en ny kalender med navnet <strong>"{ $targetCalendar }"</strong>
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Importer et element til kalenderen "{ $targetCalendar }"
       *[other] Importer { $itemCount } elementer til kalenderen "{ $targetCalendar }"
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = En ny kalender med navnet "{ $targetCalendar }" vil blive oprettet.

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Importerer… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Eksporterer… { $progressPercent }
progress-pane-finished-desc2 = Fuldført.
error-pane-title = Fejl
error-message-zip-file-too-big2 = Den valgte ZIP-komprimerede fil er større end 2GB. Udpak først filen, og importer derefter fra den udpakkede mappe i stedet.
error-message-extract-zip-file-failed2 = Kunne ikke udpakke den ZIP-komprimerede fil. Udpak filen manuelt, og importer derefter fra den udpakkede mappe i stedet.
error-message-failed = Importen mislykkedes uventet. Flere oplysninger er muligvis tilgængelige i fejlkonsollen.
error-failed-to-parse-ics-file = Fandt ingen elementer at importere i filen.
error-export-failed = Eksporten mislykkedes uventet. Flere oplysninger er muligvis tilgængelige i fejlkonsollen.
error-message-no-profile = Ingen profil fundet.

## <csv-field-map> element

csv-first-row-contains-headers = Første række indeholder feltnavne
csv-source-field = Kildefelt
csv-source-first-record = Første post
csv-source-second-record = Anden post
csv-target-field = Adressebogsfelt

## Export tab

export-profile-title = Eksporter konti, meddelelser, adressebøger og indstillinger til en ZIP-komprimeret fil.
export-profile-description = Hvis din nuværende profil er større end 2GB, foreslår vi, at du selv tager en sikkerhedskopi af den.
export-open-profile-folder = Åbn profilmappen
export-file-picker2 = Eksporter til en ZIP-komprimeret fil
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Data der skal importeres
summary-pane-start = Start import
summary-pane-warning = { -brand-product-name } skal genstartes, når importen er fuldført.
summary-pane-start-over = Genstart importværktøjet

## Footer area

footer-help = Har du brug for hjælp?
footer-import-documentation = Dokumentation om import
footer-export-documentation = Dokumentation om eksport
footer-support-forum = Supportforum

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Import-trin
step-confirm = Bekræft
# Variables:
# $number (number) - step number
step-count = { $number }
