# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Import
export-page-title = Export

## Header

import-start = Import
import-start-title = Importuje nastavení nebo data z aplikace nebo souboru.
import-start-description = Vyberte, odkud chcete importovat. Která data importovat vyberete později.
import-from-app = Import z aplikace
import-file = Importovat ze souboru
import-file-title = Vyberte soubor, ze kterého chcete importovat.
import-file-description = Vyberte pro importování dříve pořízené zálohy profilu, kontaktů nebo kalendářů.
import-address-book-title = Import souboru s kontakty
import-calendar-title = Import souboru s kalendářem
export-profile = Export

## Buttons

button-back = Zpět
button-continue = Pokračovat
button-export = Exportovat
button-finish = Dokončit

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Importovat z jiné instalace aplikace { app-name-thunderbird }
source-thunderbird-description = Importuje nastavení, filtry, zprávy a další data z profilu aplikace { app-name-thunderbird }.
source-seamonkey = Importovat z aplikace { app-name-seamonkey }
source-seamonkey-description = Importuje nastavení, filtry, zprávy a další data z profilu aplikace { app-name-seamonkey }.
source-outlook = Importovat z aplikace { app-name-outlook }
source-outlook-description = Importujte účty, kontakty a zprávy z aplikace { app-name-outlook }.
source-becky = Importovat z aplikace { app-name-becky }
source-becky-description = Importuje kontakty a zprávy z aplikace { app-name-becky }.
source-apple-mail = Importovat z aplikace { app-name-apple-mail }
source-apple-mail-description = Importuje zprávy z aplikace { app-name-apple-mail }.
source-file2 = Importovat ze souboru
source-file-description = Vyberte soubor, ze kterého chcete importovat kontakty a kalendáře, nebo zálohu profilu (soubor ZIP).

## Import from file selections

file-profile2 = Importovat zálohovaný profil
file-profile-description = Vyberte dříve pořízenou zálohu profilu Thunderbirdu (.zip)
file-calendar = Importovat kalendáře
file-calendar-description = Vyberte soubor s exportovanými kalendáři nebo událostmi (.ics)
file-addressbook = Importovat kontakty
file-addressbook-description = Vyberte soubor s exportovanými kontakty nebo složkami kontaktů

## Import from app profile steps

from-app-thunderbird = Importovat z profilu aplikace { app-name-thunderbird }
from-app-seamonkey = Importovat z profilu aplikace { app-name-seamonkey }
from-app-outlook = Importovat z aplikace { app-name-outlook }
from-app-becky = Importovat z aplikace { app-name-becky }
from-app-apple-mail = Importovat z aplikace { app-name-apple-mail }
profiles-pane-title-thunderbird = Importuje nastavení a data z profilu aplikace { app-name-thunderbird }.
profiles-pane-title-seamonkey = Importuje nastavení a data z profilu aplikace { app-name-seamonkey }.
profiles-pane-title-outlook = Importovat data z aplikace { app-name-outlook }.
profiles-pane-title-becky = Importovat data z aplikace { app-name-becky }.
profiles-pane-title-apple-mail = Importovat data z aplikace { app-name-apple-mail }.
profile-source = Importovat z profilu
# $profileName (string) - name of the profile
profile-source-named = Importovat z profilu <strong>„{ $profileName }“</strong>
profile-file-picker-directory = Vyberte složku s profilem
profile-file-picker-archive = Vyberte soubor <strong>ZIP</strong>
profile-file-picker-archive-description = Soubor ZIP musí být menší než 2 GB.
profile-file-picker-archive-title = Vyberte soubor ZIP (menší než 2 GB)
items-pane-title2 = Vyberte, co chcete importovat:
items-pane-directory = Složka:
items-pane-profile-name = Název profilu:
items-pane-checkbox-accounts = Účty a nastavení
items-pane-checkbox-address-books = Kontakty
items-pane-checkbox-calendars = Kalendáře
items-pane-checkbox-mail-messages = E-mailové zprávy
items-pane-override = Všechna stávající nebo shodná data budou přepsána.

## Import from address book file steps

import-from-addr-book-file-description = Vyberte formát souboru s kontakty.
addr-book-csv-file = Soubor s hodnotami oddělenými čárkami nebo tabulátory (.csv, .tsv)
addr-book-ldif-file = Soubor LDIF (.ldif)
addr-book-vcard-file = Soubor vCard (.vcf, .vcard)
addr-book-sqlite-file = Soubor databáze SQLite (.sqlite)
addr-book-mab-file = Databáze Mork (.mab)
addr-book-file-picker = Vyberte soubor s kontakty
addr-book-csv-field-map-title = Přiřazení názvů polí
addr-book-csv-field-map-desc = Vyberte pole odpovídající zdrojovým polím, a zrušte výběr polí, která nechcete importovat.
addr-book-directories-title = Vyberte, kam chcete vybraná data importovat
addr-book-directories-pane-source = Zdrojový soubor:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Vytvořit novou složku <strong>„{ $addressBookName }“</strong>
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Importovat vybraná data do složky „{ $addressBookName }“
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = Bude vytvořena nová složka s kontakty s názvem „{ $addressBookName }“.

## Import from calendar file steps

import-from-calendar-file-desc = Vyberte soubor iCalendar (.ics), který chcete importovat.
calendar-items-title = Vyberte, co chcete importovat.
calendar-items-loading = Načítání položek…
calendar-items-filter-input =
    .placeholder = Filtrování položek…
calendar-select-all-items = Vybrat vše
calendar-deselect-all-items = Zrušit výběr
calendar-target-title = Vyberte, kam chcete vybraná data importovat.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Vytvořit nový kalendář <strong>„{ $targetCalendar }“</strong>
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Importovat položku do kalendáře „{ $targetCalendar }“.
        [few] Importovat { $itemCount } položky do kalendáře „{ $targetCalendar }“.
       *[other] Importovat { $itemCount } položek do kalendáře „{ $targetCalendar }“.
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = Bude vytvořen nový kalendář s názvem „{ $targetCalendar }“.

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Probíhá import… …{ $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Probíhá export… { $progressPercent }
progress-pane-finished-desc2 = Dokončeno.
error-pane-title = Chyba
error-message-zip-file-too-big2 = Vybraný soubor ZIP je větší než 2 GB. Nejprve ho prosím rozbalte na disk a poté importujte rozbalený adresář.
error-message-extract-zip-file-failed2 = Soubor ZIP se nepodařilo rozbalit. Rozbalte ho prosím ručně a naimportujte místo něj výslednou složku.
error-message-failed = Import se nepodařilo provést. Podrobnosti mohou být dostupné v chybové konzoli.
error-failed-to-parse-ics-file = V souboru nebylo nalezeno nic k importování.
error-export-failed = Export se nepodařilo provést. Podrobnosti mohou být dostupné v chybové konzoli.
error-message-no-profile = Nebyl nalezen žádný profil.

## <csv-field-map> element

csv-first-row-contains-headers = První řádek obsahuje názvy sloupců
csv-source-field = Zdrojové pole
csv-source-first-record = První záznam
csv-source-second-record = Druhý záznam
csv-target-field = Položka kontaktů

## Export tab

export-profile-title = Vyexportuje účty, zprávy, kontakty a nastavení do souboru ZIP.
export-profile-description = Pokud je váš aktuální profil větší než 2 GB, doporučujeme ho zazálohovat ručně.
export-open-profile-folder = Otevřít složku profilu
export-file-picker2 = Exportovat do souboru ZIP
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Data k importu
summary-pane-start = Spustit import
summary-pane-warning =
    { -brand-product-name.gender ->
        [masculine] Po dokončení importu bude potřeba { -brand-product-name(case: "acc") } restartovat.
        [feminine] Po dokončení importu bude potřeba { -brand-product-name(case: "acc") } restartovat.
        [neuter] Po dokončení importu bude potřeba { -brand-product-name(case: "acc") } restartovat.
       *[other] Po dokončení importu bude potřeba aplikaci { -brand-product-name } restartovat.
    }
summary-pane-start-over = Restart nástroje pro import

## Footer area

footer-help = Potřebujete pomoc?
footer-import-documentation = Nápověda k importování
footer-export-documentation = Nápověda k exportování
footer-support-forum = Fórum podpory

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Postup importu
step-confirm = Potvrdit
# Variables:
# $number (number) - step number
step-count = { $number }
