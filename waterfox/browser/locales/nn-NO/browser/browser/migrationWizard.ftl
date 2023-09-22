# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Importer nettlesardata
migration-wizard-selection-list = Vel data du vil importere.
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
migration-wizard-migrator-display-name-chromium-360se = 360 sikker nettlesar
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge Legacy
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Passord frå CSV-fil
migration-wizard-migrator-display-name-file-bookmarks = Bokmerke frå HTML-fil
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Importer alle tilgjengeleg data
migration-no-selected-data-label = Ingen data valde for import
migration-selected-data-label = Importer valde data

##

migration-select-all-option-label = Merk alle
migration-bookmarks-option-label = Bokmerke
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Favorittar
migration-logins-and-passwords-option-label = Lagra innloggingar og passord
migration-history-option-label = Nettlesarhistorikk
migration-extensions-option-label = Utvidingar
migration-form-autofill-option-label = Autofylldata for skjema
migration-payment-methods-option-label = Betalingsmåtar
migration-cookies-option-label = Infokapslar
migration-session-option-label = Vindauge og faner
migration-otherdata-option-label = Andre data
migration-passwords-from-file-progress-header = Importer passordfil
migration-passwords-from-file-success-header = Passord importerte
migration-passwords-from-file = Ser etter passord i fila
migration-passwords-new = Nye passord
migration-passwords-updated = Eksisterande passord
migration-passwords-from-file-no-valid-data = Fila inneheld ingen gyldige passorddata. Vel ei anna fil.
migration-passwords-from-file-picker-title = Importer passordfil
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-dokument
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
        [one] { $newEntries } lagt til
       *[other] { $newEntries } lagt til
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } oppdatert
       *[other] { $updatedEntries } oppdaterte
    }
migration-bookmarks-from-file-picker-title = Importer bokmerkefil
migration-bookmarks-from-file-progress-header = Importerer bokmerke
migration-bookmarks-from-file = Bokmerke
migration-bookmarks-from-file-success-header = Bokmerka vart importerte
migration-bookmarks-from-file-no-valid-data = Fila inneheld ingen bokmerkedata. Vel ei anna fil.
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
        [one] { $newEntries } bokmerke
       *[other] { $newEntries } bokmerke
    }
migration-import-button-label = Importer
migration-choose-to-import-from-file-button-label = Importer frå fil
migration-import-from-file-button-label = Vel fil
migration-cancel-button-label = Avbryt
migration-done-button-label = Ferdig
migration-continue-button-label = Hald fram
migration-wizard-import-browser-no-browsers = { -brand-short-name } klarte ikkje å finne noko program som inneheld bokmerke-, historikk- eller passord-data.
migration-wizard-import-browser-no-resources = Det oppstod eit problem. { -brand-short-name } kan ikkje finne data å importere frå den nettlesarprofilen.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = bokmerke
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = favorittar
migration-list-password-label = passord
migration-list-history-label = historikk
migration-list-extensions-label = Utvidingar
migration-list-autofill-label = autofylldata
migration-list-payment-methods-label = betalingsmåtar

##

migration-wizard-progress-header = Importerer data
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Data vart importert
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Import av data fullført
migration-wizard-progress-icon-in-progress =
    .aria-label = Importerer…
migration-wizard-progress-icon-completed =
    .aria-label = Fullført
migration-safari-password-import-header = Importer passord frå Safari
migration-safari-password-import-steps-header = Slik importerer du Safari-passord:
migration-safari-password-import-step1 = I Safari, opne «Safari»-menyen og gå til Instllingar > Passord
migration-safari-password-import-step2 = Vel knappen <img data-l10n-name="safari-icon-3dots"/> og vel «Eksporter alle passord»
migration-safari-password-import-step3 = Lagre passordfila
migration-safari-password-import-step4 = Bruk «Vel fil» nedanfor for å velje passordfila du lagra
migration-safari-password-import-skip-button = Hopp over
migration-safari-password-import-select-button = Vel fil
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } bokmerke
       *[other] { $quantity } bokmerke
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
        [one] { $quantity } favoritt
       *[other] { $quantity } favorittar
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
        [one] { $quantity } utviding
       *[other] { $quantity } utvidingar
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } av { $quantity } utvidingar
migration-wizard-progress-extensions-support-link = Finn ut korleis { -brand-product-name } samsvarar tillegg
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Ingen matchande utvidingar
migration-wizard-progress-extensions-addons-link = Bla i utvidingar for { -brand-short-name }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } passord
       *[other] { $quantity } passord
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Frå siste dag
       *[other] Frå siste { $maxAgeInDays } dagar
    }
migration-wizard-progress-success-formdata = Skjemahistorikk
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } betalingsmåte
       *[other] { $quantity } betalingsmåtar
    }
migration-wizard-safari-permissions-sub-header = Slik importerer du Safari-bokmerke og netthistorik:
migration-wizard-safari-instructions-continue = Vel «Hald fram»
migration-wizard-safari-instructions-folder = Vel Safari-mappa i lista og vel «Opne»
