# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Importer browserdata
migration-wizard-selection-list = Vælg de data, du vil importere.
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
migration-wizard-migrator-display-name-file-password-csv = Adgangskoder fra CSV-fil
migration-wizard-migrator-display-name-file-bookmarks = Bogmærker fra HTML-fil
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Importer alle tilgængelige data
migration-no-selected-data-label = Ingen data valgt til import
migration-selected-data-label = Importer valgte data

##

migration-select-all-option-label = Vælg alle
migration-bookmarks-option-label = Bogmærker
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Favoritter
migration-logins-and-passwords-option-label = Gemte logins og adgangskoder
migration-history-option-label = Browserhistorik
migration-extensions-option-label = Udvidelser
migration-form-autofill-option-label = Data til autofyldning af formularer
migration-payment-methods-option-label = Betalingsmetoder
migration-cookies-option-label = Cookies
migration-session-option-label = Vinduer og faneblade
migration-otherdata-option-label = Andre data
migration-passwords-from-file-progress-header = Importer fil med adgangskoder
migration-passwords-from-file-success-header = Adgangskoder blev importeret
migration-passwords-from-file = Kontrollerer fil for adgangskoder
migration-passwords-new = Nye adgangskoder
migration-passwords-updated = Eksisterende adgangskoder
migration-passwords-from-file-no-valid-data = Filen indeholder ikke gyldige adgangskode-data. Vælg en anden fil.
migration-passwords-from-file-picker-title = Importer fil med adgangskoder
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-fil
       *[other] CSV-fil
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV-dokument
       *[other] TSV-fil
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] { $newEntries } tilføjet
       *[other] { $newEntries } tilføjet
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } opdateret
       *[other] { $updatedEntries } opdateret
    }
migration-bookmarks-from-file-picker-title = Importer bogmærkefil
migration-bookmarks-from-file-progress-header = Importerer bogmærker
migration-bookmarks-from-file = Bogmærker
migration-bookmarks-from-file-success-header = Bogmærker importeret
migration-bookmarks-from-file-no-valid-data = Filen indeholder ikke bogmærke-data. Vælg en anden fil.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] HTML-dokument
       *[other] HTML-fil
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = JSON-fil
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } bogmærke
       *[other] { $newEntries } bogmærker
    }
migration-import-button-label = Importer
migration-choose-to-import-from-file-button-label = Importer fra fil
migration-import-from-file-button-label = Vælg fil
migration-cancel-button-label = Annuller
migration-done-button-label = Færdig
migration-continue-button-label = Fortsæt
migration-wizard-import-browser-no-browsers = { -brand-short-name } kunne ikke finde nogen programmer, der indeholder bogmærker, historik eller adgangskoder.
migration-wizard-import-browser-no-resources = Der opstod en fejl. { -brand-short-name } kan ikke finde nogen data at importere fra den valgte browser-profil.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = bogmærker
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = favoritter
migration-list-password-label = adgangskoder
migration-list-history-label = historik
migration-list-extensions-label = udvidelser
migration-list-autofill-label = autofyldnings-data
migration-list-payment-methods-label = betalingsmetoder

##

migration-wizard-progress-header = Importerer data
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Data blev importeret
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Import af data fuldført
migration-wizard-progress-icon-in-progress =
    .aria-label = Importerer…
migration-wizard-progress-icon-completed =
    .aria-label = Færdig
migration-safari-password-import-header = Importer adgangskoder fra Safari
migration-safari-password-import-steps-header = For at importere adgangskoder fra Safari:
migration-safari-password-import-step1 = Åbn "Safari"-menuen i Safari og gå til Indstillinger > Adgangskoder
migration-safari-password-import-step2 = Klik på knappen <img data-l10n-name="safari-icon-3dots"/> og vælg "Eksporter alle adgangskoder"
migration-safari-password-import-step3 = Gem filen med adgangskoder
migration-safari-password-import-step4 = Brug "Vælg fil" nedenfor for at vælge den gemte fil med adgangskoder
migration-safari-password-import-skip-button = Spring over
migration-safari-password-import-select-button = Vælg fil
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } bogmærke
       *[other] { $quantity } bogmærker
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
        [one] { $quantity } favorit
       *[other] { $quantity } favoritter
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
        [one] { $quantity } udvidelse
       *[other] { $quantity } udvidelser
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } af { $quantity } udvidelser
migration-wizard-progress-extensions-support-link = Læs hvordan { -brand-product-name } matcher udvidelser
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Ingen matchende udvidelser
migration-wizard-progress-extensions-addons-link = Gennemse udvidelser for { -brand-short-name }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } adgangskode
       *[other] { $quantity } adgangskoder
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Fra den seneste dag
       *[other] Fra de seneste { $maxAgeInDays } dage
    }
migration-wizard-progress-success-formdata = Formularhistorik
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } betalingsmetode
       *[other] { $quantity } betalingsmetoder
    }
migration-wizard-safari-permissions-sub-header = For at importere bogmærker og browserhistorik fra Safari:
migration-wizard-safari-instructions-continue = Vælg "Fortsæt"
migration-wizard-safari-instructions-folder = Vælg Safari-mappen på listen og vælg "Åbn"
