# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.

import-page-title = Importálás
export-page-title = Exportálás

## Header

import-start = Importálási eszköz
import-start-title = Beállítások vagy adatok importálása alkalmazásból vagy fájlból.
import-start-description = Válassza ki az importálás forrását. Később meg kell adnia, hogy mely adatokat kell importálni.
import-from-app = Importálás alkalmazásból
import-file = Importálás fájlból
import-file-title = Válasszon egy fájlt a tartalmának importálásához.
import-file-description = Válasszon egy korábban mentett importálandó profilt, címjegyzéket vagy naptárat.
import-address-book-title = Címjegyzékfájl importálása
import-calendar-title = Naptárfájl importálása
export-profile = Exportálás

## Buttons

button-back = Vissza
button-continue = Folytatás
button-export = Exportálás
button-finish = Befejezés

## Import from app steps

app-name-thunderbird = Thunderbird
app-name-seamonkey = SeaMonkey
app-name-outlook = Outlook
app-name-becky = Becky! Internet Mail
app-name-apple-mail = Apple Mail
source-thunderbird = Importálás egy másik { app-name-thunderbird } telepítésből
source-thunderbird-description = Beállítások, szűrők, üzenetek és más adatok importálása egy { app-name-thunderbird }-profilból.
source-seamonkey = Importálás egy { app-name-seamonkey } telepítésből
source-seamonkey-description = Beállítások, szűrők, üzenetek és más adatok importálása egy { app-name-seamonkey }-profilból.
source-outlook = Importálás az { app-name-outlook }ból
source-outlook-description = Fiókok, címjegyzékek és üzenetek importálása az { app-name-outlook }ból.
source-becky = Importálás a { app-name-becky }ből
source-becky-description = Címjegyzékek és üzenetek importálása az { app-name-becky }ből.
source-apple-mail = Importálás az { app-name-apple-mail }ből
source-apple-mail-description = Üzenetek importálása az { app-name-apple-mail }ből.
source-file2 = Importálás fájlból
source-file-description = Válasszon egy fájlt, amelyből címjegyzékeket, naptárakat vagy profilmentéseket (ZIP-fájl) importálna.

## Import from file selections

file-profile2 = Mentett profil importálása
file-profile-description = Válasszon egy korábban mentett Thunderbird-profilt (.zip)
file-calendar = Naptárak importálása
file-calendar-description = Válasszon egy exportált naptárakat vagy eseményeket (.ics) tartalmazó fájlt
file-addressbook = Címjegyzékek importálása
file-addressbook-description = Válasszon egy exportált címjegyzékeket és névjegyeket tartalmazó fájlt

## Import from app profile steps

from-app-thunderbird = Importálás egy { app-name-thunderbird }-profilból
from-app-seamonkey = Importálás egy { app-name-seamonkey }-profilból
from-app-outlook = Importálás az { app-name-outlook }ból
from-app-becky = Importálás a { app-name-becky }ből
from-app-apple-mail = Importálás az { app-name-apple-mail }ből
profiles-pane-title-thunderbird = Beállítások és adatok importálása egy { app-name-thunderbird }-profilból.
profiles-pane-title-seamonkey = Beállítások és adatok importálása egy { app-name-seamonkey }-profilból.
profiles-pane-title-outlook = Adatok importálása az{ app-name-outlook }ból.
profiles-pane-title-becky = Adatok importálása a { app-name-becky }ből.
profiles-pane-title-apple-mail = Üzenetek importálása az { app-name-apple-mail }ből.
profile-source = Importálás profilból
# $profileName (string) - name of the profile
profile-source-named = Importálás a(z) <strong>„{ $profileName }”</strong> profilból
profile-file-picker-directory = Válasszon profilmappát
profile-file-picker-archive = Válasszon egy <strong>ZIP</strong>-fájlt
profile-file-picker-archive-description = A ZIP-fájlnak 2 GB-nál kisebbnek kell lennie.
profile-file-picker-archive-title = Válasszon egy ZIP-fájlt (2 GB-nál kisebbet)
items-pane-title2 = Importálandó adatok kiválasztása:
items-pane-directory = Könyvtár:
items-pane-profile-name = Profilnév:
items-pane-checkbox-accounts = Fiókok és beállítások
items-pane-checkbox-address-books = Címjegyzékek
items-pane-checkbox-calendars = Naptárak
items-pane-checkbox-mail-messages = Levelek
items-pane-override = A meglévő vagy azonos adatok nem kerülnek felülírásra.

## Import from address book file steps

import-from-addr-book-file-description = Válassza ki a címjegyzék adatait tartalmazó fájl formátumát.
addr-book-csv-file = Vesszővel vagy tabulátorral elválasztott fájl (.csv, .tsv)
addr-book-ldif-file = LDIF-fájl (.ldif)
addr-book-vcard-file = vCard-fájl (.vcf, .vcard)
addr-book-sqlite-file = SQLite adatbázisfájl (.sqlite)
addr-book-mab-file = Mork adatbázisfájl (.mab)
addr-book-file-picker = Címjegyzékfájl kiválasztása
addr-book-csv-field-map-title = Mezőnevek összerendelése
addr-book-csv-field-map-desc = Válassza ki a forrásmezőknek megfelelő címjegyzékmezőket. Kapcsolja ki azokat a mezőket, melyeket nem akar importálni.
addr-book-directories-title = Válassza ki, hová szeretné importálni a kiválasztott adatokat
addr-book-directories-pane-source = Forrásfájl:
# $addressBookName (string) - name of the new address book that would be created.
addr-book-import-into-new-directory2 = Új könyvtár létrehozása <strong>„{ $addressBookName }”</strong> néven
# $addressBookName (string) - name of the address book to import into
addr-book-summary-title = A kiválasztott adatok importálása a(z) „{ $addressBookName }” könyvtárba
# $addressBookName (string) - name of the address book that will be created.
addr-book-summary-description = Létrejön egy új, „{ $addressBookName }” névű címjegyzék.

## Import from calendar file steps

import-from-calendar-file-desc = Válassza ki az importálandó iCalendar (.ics) fájlt.
calendar-items-title = Válassza ki az importálandó elemeket.
calendar-items-loading = Elemek betöltése…
calendar-items-filter-input =
    .placeholder = Elemek szűrése…
calendar-select-all-items = Összes kiválasztása
calendar-deselect-all-items = Összes kiválasztásának megszüntetése
calendar-target-title = Válassza ki, hová szeretné importálni a kiválasztott elemeket.
# $targetCalendar (string) - name of the new calendar that would be created
calendar-import-into-new-calendar2 = Új naptár létrehozása <strong>„{ $targetCalendar }”</strong> néven
# $itemCount (number) - count of selected items (tasks, events) that will be imported
# $targetCalendar (string) - name of the calendar the items will be imported into
calendar-summary-title =
    { $itemCount ->
        [one] Egy elem importálása a(z) „{ $targetCalendar }” naptárba
       *[other] { $itemCount } elem importálása a(z) „{ $targetCalendar }” naptárba
    }
# $targetCalendar (string) - name of the calendar that will be created
calendar-summary-description = Létrejön egy új, „{ $targetCalendar }” névű naptár.

## Import dialog

# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-importing2 = Importálás… { $progressPercent }
# $progressPercent (string) - percent formatted progress (for example "10%")
progress-pane-exporting2 = Exportálás… { $progressPercent }
progress-pane-finished-desc2 = Kész.
error-pane-title = Hiba
error-message-zip-file-too-big2 = A kiválasztott ZIP-fájl nagyobb, mint 2 GB. Először bontsa ki, majd importálja a kibontott mappából.
error-message-extract-zip-file-failed2 = A ZIP-fájl kibontása sikertelen. Bontsa ki kézzel, majd importálja a kibontott mappából.
error-message-failed = Az importálás váratlanul meghiúsult, további információ lehet elérhető a Hibakonzolban.
error-failed-to-parse-ics-file = Nem található importálható elem a fájlban.
error-export-failed = Az exportálás váratlanul meghiúsult, további információ lehet elérhető a Hibakonzolban.
error-message-no-profile = Nem található profil.

## <csv-field-map> element

csv-first-row-contains-headers = Az első sor mezőneveket tartalmaz
csv-source-field = Forrásmező
csv-source-first-record = Első rekord
csv-source-second-record = Második rekord
csv-target-field = Címjegyzékmező

## Export tab

export-profile-title = Fiókok, levelek, címjegyzékek, beállítások ZIP-fájlba exportálása.
export-profile-description = Ha a jelenlegi profilja nagyobb, mint 2 GB, javasoljuk, hogy saját kezűleg készítsen biztonsági másolatot.
export-open-profile-folder = Profilmappa megnyitása
export-file-picker2 = Exportálás ZIP-fájlba
export-brand-name = { -brand-product-name }

## Summary pane

summary-pane-title = Importálandó adatok
summary-pane-start = Importálás indítása
summary-pane-warning = Az importálás befejezése után újra kell indítani a { -brand-product-name }öt.
summary-pane-start-over = Importálási eszköz újraindítása

## Footer area

footer-help = Segítségre van szüksége?
footer-import-documentation = Importálási dokumentáció
footer-export-documentation = Exportálási dokumentáció
footer-support-forum = Támogatói fórum

## Step navigation on top of the wizard pages

step-list =
    .aria-label = Importálási lépések
step-confirm = Megerősítés
# Variables:
# $number (number) - step number
step-count = { $number }
