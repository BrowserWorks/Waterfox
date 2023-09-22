# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Importera webbläsardata
migration-wizard-selection-list = Välj den data du vill importera.
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
migration-wizard-migrator-display-name-file-password-csv = Lösenord från CSV-fil
migration-wizard-migrator-display-name-file-bookmarks = Bokmärken från HTML-fil
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Importera all tillgänglig data
migration-no-selected-data-label = Inga data har valts för import
migration-selected-data-label = Importera valda data

##

migration-select-all-option-label = Markera allt
migration-bookmarks-option-label = Bokmärken
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Favoriter
migration-logins-and-passwords-option-label = Sparade inloggningar och lösenord
migration-history-option-label = Webbläsarhistorik
migration-extensions-option-label = Tillägg
migration-form-autofill-option-label = Autofylldata för formulär
migration-payment-methods-option-label = Betalningsmetoder
migration-cookies-option-label = Kakor
migration-session-option-label = Fönster och flikar
migration-otherdata-option-label = Övrig data
migration-passwords-from-file-progress-header = Importera lösenordsfil
migration-passwords-from-file-success-header = Lösenord har importerats
migration-passwords-from-file = Söker efter lösenord i filen
migration-passwords-new = Nya lösenord
migration-passwords-updated = Befintliga lösenord
migration-passwords-from-file-no-valid-data = Filen innehåller inga giltiga lösenordsdata. Välj en annan fil.
migration-passwords-from-file-picker-title = Importera lösenordsfil
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
        [one] { $newEntries } har lagts till
       *[other] { $newEntries } har lagts till
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } har uppdaterats
       *[other] { $updatedEntries } har uppdaterats
    }
migration-bookmarks-from-file-picker-title = Importera bokmärkesfil
migration-bookmarks-from-file-progress-header = Importerar bokmärken
migration-bookmarks-from-file = Bokmärken
migration-bookmarks-from-file-success-header = Bokmärken har importerats
migration-bookmarks-from-file-no-valid-data = Filen innehåller inga bokmärkesdata. Välj en annan fil.
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
        [one] { $newEntries } bokmärke
       *[other] { $newEntries } bokmärken
    }
migration-import-button-label = Importera
migration-choose-to-import-from-file-button-label = Importera från fil
migration-import-from-file-button-label = Välj fil
migration-cancel-button-label = Avbryt
migration-done-button-label = Klar
migration-continue-button-label = Fortsätt
migration-wizard-import-browser-no-browsers = { -brand-short-name } kunde inte hitta några program som innehåller bokmärkes-, historik- eller lösenordsdata.
migration-wizard-import-browser-no-resources = Det uppstod ett problem. { -brand-short-name } kan inte hitta någon data att importera från den webbläsarprofilen.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = bokmärken
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = favoriter
migration-list-password-label = lösenord
migration-list-history-label = historik
migration-list-extensions-label = tillägg
migration-list-autofill-label = autofylldata
migration-list-payment-methods-label = betalningsmetoder

##

migration-wizard-progress-header = Importerar data
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Data importerades framgångsrikt
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Dataimporten är klar
migration-wizard-progress-icon-in-progress =
    .aria-label = Importerar…
migration-wizard-progress-icon-completed =
    .aria-label = Slutförd
migration-safari-password-import-header = Importera lösenord från Safari
migration-safari-password-import-steps-header = Så här importerar du Safari-lösenord:
migration-safari-password-import-step1 = I Safari, öppna "Safari"-menyn och gå till Inställningar > Lösenord
migration-safari-password-import-step2 = Välj knappen <img data-l10n-name="safari-icon-3dots"/> och välj "Exportera alla lösenord"
migration-safari-password-import-step3 = Spara lösenordsfilen
migration-safari-password-import-step4 = Använd "Välj fil" nedan för att välja lösenordsfilen du sparade
migration-safari-password-import-skip-button = Hoppa över
migration-safari-password-import-select-button = Välj fil
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } bokmärke
       *[other] { $quantity } bokmärken
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
       *[other] { $quantity } favoriter
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
        [one] { $quantity } tillägg
       *[other] { $quantity } tillägg
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } av { $quantity } tillägg
migration-wizard-progress-extensions-support-link = Läs om hur { -brand-product-name } matchar tillägg
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Inga matchande tillägg
migration-wizard-progress-extensions-addons-link = Bläddra bland tillägg för { -brand-short-name }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } lösenord
       *[other] { $quantity } lösenord
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Från den senaste dagen
       *[other] Från de senaste { $maxAgeInDays } dagarna
    }
migration-wizard-progress-success-formdata = Formulärhistorik
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } betalningsmetod
       *[other] { $quantity } betalningsmetoder
    }
migration-wizard-safari-permissions-sub-header = Så här importerar du Safari-bokmärken och webbhistorik:
migration-wizard-safari-instructions-continue = Välj "Fortsätt"
migration-wizard-safari-instructions-folder = Välj Safari-mappen i listan och välj "Öppna"
