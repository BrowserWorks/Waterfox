# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Importowanie danych z innych przeglądarek
migration-wizard-selection-list = Wybierz dane do zaimportowania.
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
migration-wizard-migrator-display-name-chromium-360se = 360 Secure
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge w starszej wersji
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Hasła z pliku CSV
migration-wizard-migrator-display-name-file-bookmarks = Zakładki z pliku HTML
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Importowanie wszystkich dostępnych danych
migration-no-selected-data-label = Nie wybrano danych do zaimportowania
migration-selected-data-label = Importowanie wybranych danych

##

migration-select-all-option-label = Wybierz wszystkie
migration-bookmarks-option-label = Zakładki
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Ulubione
migration-logins-and-passwords-option-label = Zachowane dane logowania i hasła
migration-history-option-label = Historia przeglądania
migration-extensions-option-label = Rozszerzenia
migration-form-autofill-option-label = Dane automatycznego wypełniania formularzy
migration-payment-methods-option-label = Metody płatności
migration-cookies-option-label = Ciasteczka
migration-session-option-label = Okna i karty
migration-otherdata-option-label = Inne dane
migration-passwords-from-file-progress-header = Importowanie pliku z hasłami
migration-passwords-from-file-success-header = Pomyślnie zaimportowano hasła
migration-passwords-from-file = Wyszukiwanie haseł w pliku
migration-passwords-new = Nowe hasła
migration-passwords-updated = Istniejące hasła
migration-passwords-from-file-no-valid-data = Plik nie zawiera żadnych prawidłowych danych o hasłach. Wybierz inny.
migration-passwords-from-file-picker-title = Importowanie pliku z hasłami
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] Dokument CSV
       *[other] Plik CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] Dokument TSV
       *[other] Plik TSV
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] Dodano { $newEntries } hasło
        [few] Dodano { $newEntries } hasła
       *[many] Dodano { $newEntries } haseł
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] Uaktualniono { $updatedEntries } hasło
        [few] Uaktualniono { $updatedEntries } hasła
       *[many] Uaktualniono { $updatedEntries } haseł
    }
migration-bookmarks-from-file-picker-title = Importowanie pliku z zakładkami
migration-bookmarks-from-file-progress-header = Importowanie zakładek
migration-bookmarks-from-file = Zakładki
migration-bookmarks-from-file-success-header = Pomyślnie zaimportowano zakładki
migration-bookmarks-from-file-no-valid-data = Plik nie zawiera żadnych danych o zakładkach. Wybierz inny.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] Dokument HTML
       *[other] Plik HTML
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = Plik JSON
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } zakładka
        [few] { $newEntries } zakładki
       *[many] { $newEntries } zakładek
    }
migration-import-button-label = Importuj
migration-choose-to-import-from-file-button-label = Importuj z pliku
migration-import-from-file-button-label = Wybierz plik
migration-cancel-button-label = Anuluj
migration-done-button-label = Gotowe
migration-continue-button-label = Kontynuuj
migration-wizard-import-browser-no-browsers = { -brand-short-name } nie znalazł żadnych programów zawierających zakładki, historię lub hasła.
migration-wizard-import-browser-no-resources = Wystąpił błąd. { -brand-short-name } nie może znaleźć żadnych danych do zaimportowania z tego profilu przeglądarki.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = zakładki
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = ulubione
migration-list-password-label = hasła
migration-list-history-label = historia
migration-list-extensions-label = rozszerzenia
migration-list-autofill-label = dane automatycznego wypełniania formularzy
migration-list-payment-methods-label = metody płatności

##

migration-wizard-progress-header = Importowanie danych
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Pomyślnie zaimportowano dane
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Ukończono importowanie danych
migration-wizard-progress-icon-in-progress =
    .aria-label = Importowanie…
migration-wizard-progress-icon-completed =
    .aria-label = Ukończono
migration-safari-password-import-header = Importowanie haseł z Safari
migration-safari-password-import-steps-header = Aby zaimportować hasła z Safari:
migration-safari-password-import-step1 = W Safari otwórz menu „Safari” i przejdź do „Preferencje” → „Hasła”
migration-safari-password-import-step2 = Kliknij przycisk <img data-l10n-name="safari-icon-3dots"/> i wybierz „Eksportuj wszystkie hasła”
migration-safari-password-import-step3 = Zapisz plik z hasłami
migration-safari-password-import-step4 = Użyj przycisku „Wybierz plik” poniżej, aby wybrać zapisany plik z hasłami
migration-safari-password-import-skip-button = Pomiń
migration-safari-password-import-select-button = Wybierz plik
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } zakładka
        [few] { $quantity } zakładki
       *[many] { $quantity } zakładek
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
        [one] { $quantity } ulubiona
        [few] { $quantity } ulubione
       *[many] { $quantity } ulubionych
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
        [one] { $quantity } rozszerzenie
        [few] { $quantity } rozszerzenia
       *[many] { $quantity } rozszerzeń
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } z { $quantity } rozszerzeń
migration-wizard-progress-extensions-support-link = Więcej informacji o tym, jak { -brand-product-name } dopasowuje rozszerzenia
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Brak pasujących rozszerzeń
migration-wizard-progress-extensions-addons-link = Przeglądaj rozszerzenia dla { -brand-short-name(case: "gen") }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } hasło
        [few] { $quantity } hasła
       *[many] { $quantity } haseł
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Z ostatniego dnia
        [few] Z ostatnich { $maxAgeInDays } dni
       *[many] Z ostatnich { $maxAgeInDays } dni
    }
migration-wizard-progress-success-formdata = Historia formularzy
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } metoda płatności
        [few] { $quantity } metody płatności
       *[many] { $quantity } metod płatności
    }
migration-wizard-safari-permissions-sub-header = Aby zaimportować zakładki i historię przeglądania z Safari:
migration-wizard-safari-instructions-continue = Kliknij „Kontynuuj”
migration-wizard-safari-instructions-folder = Zaznacz folder Safari na liście i kliknij „Otwórz”
