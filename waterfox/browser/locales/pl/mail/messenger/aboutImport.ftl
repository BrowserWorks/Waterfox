# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Importuj
export-page-title = Eksportuj

## Header

import-start = Narzędzie importowania
import-start-title = Importuj ustawienia lub dane z aplikacji lub pliku.
import-start-description = Wybierz źródło, z którego importować. Później będzie można wybrać, które dane zaimportować.
import-from-app = Importuj z aplikacji
import-file = Importuj z pliku
import-file-title = Wybierz plik, aby zaimportować jego zawartość.
import-file-description = Wybierz, aby zaimportować kopię zapasową profilu, książki adresowe lub kalendarze.
import-address-book-title = Importuj plik książki adresowej
import-calendar-title = Importuj plik kalendarza
export-profile = Eksportuj

## Buttons

button-back = Wstecz
button-continue = Kontynuuj
button-export = Eksportuj
button-finish = Zakończ

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Importuj z innej instalacji programu { app-name-thunderbird }
source-thunderbird-description = Importuj ustawienia, filtry, wiadomości i inne dane z profilu programu { app-name-thunderbird }.
source-seamonkey = Importuj z instalacji programu { app-name-seamonkey }
source-seamonkey-description = Importuj ustawienia, filtry, wiadomości i inne dane z profilu programu { app-name-seamonkey }.
source-outlook = Importuj z programu { app-name-outlook }
source-outlook-description = Importuj konta, książki adresowe i wiadomości z programu { app-name-outlook }.
source-becky = Importuj z programu { app-name-becky }
source-becky-description = Importuj książki adresowe i wiadomości z programu { app-name-becky }.
source-apple-mail = Importuj z programu { app-name-apple-mail }
source-apple-mail-description = Importuj wiadomości z programu { app-name-apple-mail }.
source-file2 = Importuj z pliku
source-file-description = Wybierz plik, aby zaimportować książki adresowe, kalendarze lub kopię zapasową profilu (plik ZIP).

## Import from file selections

file-profile2 = Importuj kopię zapasową profilu
file-profile-description = Wybierz wcześniej utworzoną kopię zapasową profilu Thunderbirda (.zip)
file-calendar = Importuj kalendarze
file-calendar-description = Wybierz plik zawierający wyeksportowane kalendarze lub wydarzenia (.ics)
file-addressbook = Importuj książki adresowe
file-addressbook-description = Wybierz plik zawierający wyeksportowane książki adresowe i kontakty

## Import from app profile steps

from-app-thunderbird = Importuj z profilu programu { app-name-thunderbird }
from-app-seamonkey = Importuj z profilu programu { app-name-seamonkey }
from-app-outlook = Importuj z programu { app-name-outlook }
from-app-becky = Importuj z programu { app-name-becky }
from-app-apple-mail = Importuj z programu { app-name-apple-mail }
profiles-pane-title-thunderbird = Importuj ustawienia i dane z profilu programu { app-name-thunderbird }.
profiles-pane-title-seamonkey = Importuj ustawienia i dane z profilu programu { app-name-seamonkey }.
profiles-pane-title-outlook = Importuj dane z programu { app-name-outlook }.
profiles-pane-title-becky = Importuj dane z programu { app-name-becky }.
profiles-pane-title-apple-mail = Importuj wiadomości z programu { app-name-apple-mail }.
profile-source = Importuj z profilu
# $profileName (string) - name of the profile
profile-source-named = Importuj z profilu <strong>„{ $profileName }”</strong>
profile-file-picker-directory = Wybierz folder profilu
profile-file-picker-archive = Wybierz plik <strong>ZIP</strong>
profile-file-picker-archive-description = Plik ZIP musi być mniejszy niż 2 GB.
profile-file-picker-archive-title = Wybierz plik ZIP (mniejszy niż 2 GB)
items-pane-title2 = Wybierz, co zaimportować:
items-pane-directory = Katalog:
items-pane-profile-name = Nazwa profilu:
items-pane-checkbox-accounts = Konta i ustawienia
items-pane-checkbox-address-books = Książki adresowe
items-pane-checkbox-calendars = Kalendarze
items-pane-checkbox-mail-messages = Wiadomości pocztowe
items-pane-override = Istniejące lub identyczne dane nie zostaną zastąpione.

## Import from address book file steps

import-from-addr-book-file-description = Wybierz format pliku zawierającego dane książki adresowej.
addr-book-csv-file = Plik z wartościami rozdzielonymi przecinkami lub tabulatorami (.csv, .tsv)
addr-book-ldif-file = Plik LDIF (.ldif)
addr-book-vcard-file = Plik vCard (.vcf, .vcard)
addr-book-sqlite-file = Plik bazy danych SQLite (.sqlite)
addr-book-mab-file = Plik bazy danych Mork (.mab)
addr-book-file-picker = Wybierz plik książki adresowej
addr-book-csv-field-map-title = Dopasuj nazwy pól
addr-book-csv-field-map-desc = Wybierz pola książki adresowej odpowiadające polom źródłowym. Odznacz pola, które nie mają być importowane.
addr-book-directories-title = Wybierz, gdzie zaimportować wybrane dane
addr-book-directories-pane-source = Plik źródłowy:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Utwórz nowy katalog o nazwie <strong>„{ $addressBookName }”</strong>
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = Importuj wybrane dane do katalogu „{ $addressBookName }”
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = Zostanie utworzona nowa książka adresowa o nazwie „{ $addressBookName }”.

## Import from calendar file steps

import-from-calendar-file-desc = Wybierz plik iCalendar (.ics) do zaimportowania.
calendar-items-title = Wybierz elementy do zaimportowania.
calendar-items-loading = Wczytywanie elementów…
calendar-items-filter-input =
    .placeholder = Filtruj elementy…
calendar-select-all-items = Zaznacz wszystko
calendar-deselect-all-items = Odznacz wszystko
calendar-target-title = Wybierz, gdzie zaimportować wybrane elementy.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Utwórz nowy kalendarz o nazwie <strong>„{ $targetCalendar }”</strong>
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Importuj jeden element do kalendarza „{ $targetCalendar }”
        [few] Importuj { $itemCount } elementy do kalendarza „{ $targetCalendar }”
       *[many] Importuj { $itemCount } elementów do kalendarza „{ $targetCalendar }”
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = Zostanie utworzony nowy kalendarz o nazwie „{ $targetCalendar }”.

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Importowanie… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Eksportowanie… { $progressPercent }
progress-pane-finished-desc2 = Ukończono.
error-pane-title = Błąd
error-message-zip-file-too-big2 = Wybrany plik ZIP jest większy niż 2 GB. Najpierw go rozpakuj, a następnie zaimportuj z rozpakowanego folderu.
error-message-extract-zip-file-failed2 = Rozpakowanie pliku ZIP się nie powiodło. Rozpakuj go ręcznie, a następnie zaimportuj z rozpakowanego folderu.
error-message-failed = Import nieoczekiwanie się nie powiódł. Więcej informacji może być dostępnych w konsoli błędów.
error-failed-to-parse-ics-file = W pliku nie znaleziono elementów możliwych do zaimportowania.
error-export-failed = Eksport nieoczekiwanie się nie powiódł. Więcej informacji może być dostępnych w konsoli błędów.
error-message-no-profile = Nie odnaleziono profilu.

## <csv-field-map> element

csv-first-row-contains-headers = Pierwszy wiersz zawiera nazwy pól
csv-source-field = Pole źródłowe
csv-source-first-record = Pierwszy rekord
csv-source-second-record = Drugi rekord
csv-target-field = Pole książki adresowej

## Export tab

export-profile-title = Eksportuj konta, wiadomości, książki adresowe i ustawienia do pliku ZIP.
export-profile-description = Jeśli obecny profil jest większy niż 2 GB, sugerujemy samodzielne utworzenie kopii zapasowej.
export-open-profile-folder = Otwórz folder profilu
export-file-picker2 = Eksportuj do pliku ZIP
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Dane do zaimportowania
summary-pane-start = Rozpocznij import
summary-pane-warning = { -brand-product-name } będzie musiał zostać ponownie uruchomiony po ukończeniu importowania.
summary-pane-start-over = Uruchom ponownie narzędzie importowania

## Footer area

footer-help = Potrzebujesz pomocy?
footer-import-documentation = Dokumentacja importowania
footer-export-documentation = Dokumentacja eksportowania
footer-support-forum = Forum pomocy

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Kroki importowania
step-confirm = Potwierdź
# Variables:
# $number (number) - step number
step-count = { $number }
