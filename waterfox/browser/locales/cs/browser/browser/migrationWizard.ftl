# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Import dat prohlížeče
migration-wizard-selection-list = Vyberte data, která chcete importovat.
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
migration-wizard-selection-option-with-profile = { $sourceBrowser } — { $profileName }

# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-brave = Brave
migration-wizard-migrator-display-name-canary = Chrome Canary
migration-wizard-migrator-display-name-chrome = Chrome
migration-wizard-migrator-display-name-chrome-beta = Chrome Beta
migration-wizard-migrator-display-name-chrome-dev = Chrome Dev
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 Secure Browser
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge Legacy
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Hesla ze souboru CSV
migration-wizard-migrator-display-name-file-bookmarks = Záložky ze souboru HTML
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Importovat všechna dostupná data
migration-no-selected-data-label = Pro import nejsou vybrána žádná data
migration-selected-data-label = Importovat vybraná data

##

migration-select-all-option-label = Vybrat vše
migration-bookmarks-option-label = Záložky
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Oblíbené
migration-logins-and-passwords-option-label = Uložená přihlašovací jména a hesla
migration-history-option-label = Historie prohlížení
migration-extensions-option-label = Rozšíření
migration-form-autofill-option-label = Data pro automatické vyplňování formulářů
migration-payment-methods-option-label = Způsoby platby
migration-cookies-option-label = Cookies
migration-session-option-label = Okna a panely
migration-otherdata-option-label = Ostatní data
migration-passwords-from-file-progress-header = Import souboru s hesly
migration-passwords-from-file-success-header = Import hesel byl úspěšně dokončen
migration-passwords-from-file = Vyhledávají se hesla v souboru
migration-passwords-new = Nová hesla
migration-passwords-updated = Existující hesla
migration-passwords-from-file-no-valid-data = Soubor neobsahuje žádná platná data s přihlašovacími údaji. Vyberte jiný soubor.
migration-passwords-from-file-picker-title = Import souboru s hesly
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Soubor CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] Dokument TSV
       *[other] Soubor TSV
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] { $newEntries } přidané
        [few] { $newEntries } přidané
        [many] { $newEntries } přidaných
       *[other] { $newEntries } přidaných
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } aktualizované
        [few] { $updatedEntries } aktualizované
        [many] { $updatedEntries } aktualizovaných
       *[other] { $updatedEntries } aktualizovaných
    }
migration-bookmarks-from-file-picker-title = Importu souboru záložek
migration-bookmarks-from-file-progress-header = Probíhá import záložek
migration-bookmarks-from-file = Záložky
migration-bookmarks-from-file-success-header = Záložky byly úspěšně naimportovány
migration-bookmarks-from-file-no-valid-data = Soubor neobsahuje žádná data záložek. Vyberte jiný soubor.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] Dokument HTML
       *[other] Soubor HTML
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = Soubor JSON
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } záložka
        [few] { $newEntries } záložky
        [many] { $newEntries } záložek
       *[other] { $newEntries } záložek
    }
migration-import-button-label = Importovat
migration-choose-to-import-from-file-button-label = Importovat ze souboru
migration-import-from-file-button-label = Vybrat soubor
migration-cancel-button-label = Zrušit
migration-done-button-label = Hotovo
migration-continue-button-label = Pokračovat
migration-wizard-import-browser-no-browsers =
    { -brand-short-name.gender ->
        [masculine] { -brand-short-name } nenašel žádné programy, které obsahují záložky, historii nebo přihlašovací údaje.
        [feminine] { -brand-short-name } nenašla žádné programy, které obsahují záložky, historii nebo přihlašovací údaje.
        [neuter] { -brand-short-name } nenašlo žádné programy, které obsahují záložky, historii nebo přihlašovací údaje.
       *[other] Aplikace { -brand-short-name } nenašla žádné programy, které obsahují záložky, historii nebo přihlašovací údaje.
    }
migration-wizard-import-browser-no-resources = Nastala chyba. { -brand-short-name } nemůže najít žádná data k importu z tohoto profilu prohlížeče.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = záložky
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = oblíbené
migration-list-password-label = přihlašovací údaje
migration-list-history-label = historie
migration-list-extensions-label = rozšíření
migration-list-autofill-label = data pro automatické vyplňování
migration-list-payment-methods-label = způsoby platby

##

migration-wizard-progress-header = Import dat
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Import dat byl úspěšně dokončen
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Import dat byl dokončen
migration-wizard-progress-icon-in-progress =
    .aria-label = Probíhá import…
migration-wizard-progress-icon-completed =
    .aria-label = Hotovo
migration-safari-password-import-header = Import hesel ze Safari
migration-safari-password-import-steps-header = Pro importování hesel ze Safari:
migration-safari-password-import-step1 = V Safari otevřete nabídku „Safari“ a přejděte na Nastavení > Hesla
migration-safari-password-import-step2 = Klepněte na tlačítko <img data-l10n-name="safari-icon-3dots"/> a zvolte „Exportovat všechna hesla“
migration-safari-password-import-step3 = Uložte soubor s hesly
migration-safari-password-import-step4 = Klepněte na „Vybrat soubor“ níže a vyberte uložený soubor s hesly
migration-safari-password-import-skip-button = Přeskočit
migration-safari-password-import-select-button = Vybrat soubor
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } záložka
        [few] { $quantity } záložky
        [many] { $quantity } záložek
       *[other] { $quantity } záložek
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
        [one] { $quantity } oblíbený
        [few] { $quantity } oblíbené
        [many] { $quantity } oblíbených
       *[other] { $quantity } oblíbených
    }

## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

# Shown in the migration wizard after importing all matched extensions
# from supported browsers.
#
# Variables:
#   $quantity (Number): the number of successfully imported extensions
migration-wizard-progress-success-extensions = { $quantity } rozšíření
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions =
    { $quantity ->
        [one] { $matched } z { $quantity } rozšíření
        [few] { $matched } ze { $quantity } rozšíření
       *[other] { $matched } z { $quantity } rozšíření
    }
migration-wizard-progress-extensions-support-link = Zjistěte, jak { -brand-product-name } poznává rozšíření
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Žádná rozpoznaná rozšíření
migration-wizard-progress-extensions-addons-link =
    { -brand-short-name.case-status ->
        [with-cases] Prohledávat rozšíření pro { -brand-short-name(case: "acc") }
       *[no-cases] Prohledávat rozšíření pro aplikaci { -brand-short-name }
    }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } heslo
        [few] { $quantity } hesla
        [many] { $quantity } hesel
       *[other] { $quantity } hesel
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Za poslední den
        [few] Za poslední { $maxAgeInDays } dny
        [many] Za posledních { $maxAgeInDays } dní
       *[other] Za posledních { $maxAgeInDays } dní
    }
migration-wizard-progress-success-formdata = Historie formulářů
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } způsob platby
        [few] { $quantity } způsoby platby
        [many] { $quantity } způsobů platby
       *[other] { $quantity } způsobů platby
    }
migration-wizard-safari-permissions-sub-header = Pro importování záložek a historie prohlížení ze Safari:
migration-wizard-safari-instructions-continue = Vyberte „Pokračovat“
migration-wizard-safari-instructions-folder = Vyberte v seznamu složku Safari a zvolte „Otevřít“
