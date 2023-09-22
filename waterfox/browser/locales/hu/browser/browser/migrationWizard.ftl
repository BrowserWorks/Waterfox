# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Böngészőadatok importálása
migration-wizard-selection-list = Válassza ki az importálandó adatokat.
# Shown in the new migration wizard's dropdown selector for choosing the browser
# to import from. This variant is shown when the selected browser doesn't support
# user profiles, and so we only show the browser name.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
migration-wizard-selection-option-without-profile = { $sourceBrowser }
# Shown in the new migration wizard's dropdown selector for choosing the browser
# and user profile to import from. This variant is shown when the selected browser
# supports user profiles.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
#  $profileName (String): the name of the user profile to import from.
migration-wizard-selection-option-with-profile = { $sourceBrowser } – { $profileName }

# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-brave = Brave
migration-wizard-migrator-display-name-canary = Chrome Canary
migration-wizard-migrator-display-name-chrome = Chrome
migration-wizard-migrator-display-name-chrome-beta = Chrome béta
migration-wizard-migrator-display-name-chrome-dev = Chrome fejlesztői
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 biztonságos böngésző
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge béta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge Legacy
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Jelszavak egy CSV-fájlból
migration-wizard-migrator-display-name-file-bookmarks = Könyvjelzők HTML-fájlból
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Összes elérhető adat importálása
migration-no-selected-data-label = Nincsenek kiválasztva importálandó adatok
migration-selected-data-label = Kijelölt adatok importálása

##

migration-select-all-option-label = Összes kijelölése
migration-bookmarks-option-label = Könyvjelzők
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Kedvencek
migration-logins-and-passwords-option-label = Mentett bejelentkezések és jelszavak
migration-history-option-label = Böngészési előzmények
migration-extensions-option-label = Kiegészítők
migration-form-autofill-option-label = Adatok automatikus kitöltése
migration-payment-methods-option-label = Fizetési módok
migration-cookies-option-label = Sütik
migration-session-option-label = Ablakok és lapok
migration-otherdata-option-label = További adatok
migration-passwords-from-file-progress-header = Jelszófájl importálása
migration-passwords-from-file-success-header = A jelszavak sikeresen importálva
migration-passwords-from-file = Jelszavak keresése a fájlban
migration-passwords-new = Új jelszavak
migration-passwords-updated = Meglévő jelszavak
migration-passwords-from-file-no-valid-data = A fájl nem tartalmaz érvényes jelszóadatokat. Válasszon másik fájlt.
migration-passwords-from-file-picker-title = Jelszófájl importálása
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokumentum
       *[other] CSV-fájl
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV-dokumentum
       *[other] TSV-fájl
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] { $newEntries } hozzáadva
       *[other] { $newEntries } hozzáadva
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } frissítve
       *[other] { $updatedEntries } frissítve
    }
migration-bookmarks-from-file-picker-title = Könyvjelzőfájl importálása
migration-bookmarks-from-file-progress-header = Könyvjelzők importálása
migration-bookmarks-from-file = Könyvjelzők
migration-bookmarks-from-file-success-header = A könyvjelzők sikeresen importálva
migration-bookmarks-from-file-no-valid-data = A fájl nem tartalmaz érvényes könyvjelzőadatokat. Válasszon másik fájlt.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] HTML-dokumentum
       *[other] HTML-fájl
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = JSON-fájl
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } könyvjelző
       *[other] { $newEntries } könyvjelző
    }
migration-import-button-label = Importálás
migration-choose-to-import-from-file-button-label = Importálás fájlból
migration-import-from-file-button-label = Fájl kiválasztása
migration-cancel-button-label = Mégse
migration-done-button-label = Kész
migration-continue-button-label = Folytatás
migration-wizard-import-browser-no-browsers = A { -brand-short-name } nem talált olyan programot, amely könyvjelzőket, előzményeket vagy jelszóadatokat tartalmazna.
migration-wizard-import-browser-no-resources = Hiba történt. A { -brand-short-name } nem talált importálandó adatot abból a böngészőprofilból.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = könyvjelzők
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = kedvencek
migration-list-password-label = jelszavak
migration-list-history-label = előzmények
migration-list-extensions-label = kiegészítők
migration-list-autofill-label = adatok automatikus kitöltése
migration-list-payment-methods-label = fizetési módok

##

migration-wizard-progress-header = Adatok importálása
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Az adatok sikeresen importálva
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Az adatimportálás befejeződött
migration-wizard-progress-icon-in-progress =
    .aria-label = Importálás…
migration-wizard-progress-icon-completed =
    .aria-label = Kész
migration-safari-password-import-header = Jelszavak importálása a Safariból
migration-safari-password-import-steps-header = A Safari jelszavainak importálásához:
migration-safari-password-import-step1 = A Safariban nyissa meg a „Safari” menüt és ugorjon a Beállítások > Jelszavak menüponthoz
migration-safari-password-import-step2 = Válassza a <img data-l10n-name="safari-icon-3dots"/> gombot, és válassza az „Összes jelszó exportálása” lehetőséget
migration-safari-password-import-step3 = Mentse a jelszavakat tartalmazó fájlt
migration-safari-password-import-step4 = Használja az alábbi „Fájl kiválasztása” lehetőséget a mentett jelszófájl kiválasztásához
migration-safari-password-import-skip-button = Kihagyás
migration-safari-password-import-select-button = Fájl kiválasztása
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } könyvjelző
       *[other] { $quantity } könyvjelző
    }
# Shown in the migration wizard after importing bookmarks from either
# Internet Explorer or Edge.
#
# Use the same terminology if the browser is available in your language.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-favorites =
    { $quantity ->
        [one] { $quantity } kedvenc
       *[other] { $quantity } kedvenc
    }

## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

# Shown in the migration wizard after importing all matched extensions
# from supported browsers.
#
# Variables:
#   $quantity (Number): the number of successfully imported extensions
migration-wizard-progress-success-extensions =
    { $quantity ->
        [one] { $quantity } kiegészítő
       *[other] { $quantity } kiegészítő
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } / { $quantity } kiegészítő
migration-wizard-progress-extensions-support-link = Tudja meg, hogy a { -brand-product-name } hogyan találja meg a megfelelő kiegészítőket
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Nincs megfelelő kiegészítő
migration-wizard-progress-extensions-addons-link = Kiegészítők tallózása a { -brand-short-name }hoz

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } jelszó
       *[other] { $quantity } jelszó
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Az elmúlt napból
       *[other] Az elmúlt { $maxAgeInDays } napból
    }
migration-wizard-progress-success-formdata = Űrlapok előzményei
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } fizetési mód
       *[other] { $quantity } fizetési mód
    }
migration-wizard-safari-permissions-sub-header = A Safari könyvjelzőinek és böngészési előzményeinek importálásához:
migration-wizard-safari-instructions-continue = Válassza a „Folytatás” gombot
migration-wizard-safari-instructions-folder = Válassza ki a Safari mappát a listából, és válassza a „Megnyitás” lehetőséget
