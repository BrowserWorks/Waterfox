# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Browsergegevens importeren
migration-wizard-selection-list = Selecteer de gegevens die u wilt importeren.
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
migration-wizard-migrator-display-name-chrome-beta = Chrome Beta
migration-wizard-migrator-display-name-chrome-dev = Chrome Dev
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 Secure Browser
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge Legacy
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Wachtwoorden uit CSV-bestand
migration-wizard-migrator-display-name-file-bookmarks = Bladwijzers uit HTML-bestand
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Alle beschikbare gegevens importeren
migration-no-selected-data-label = Geen te importeren gegevens geselecteerd
migration-selected-data-label = Geselecteerde gegevens importeren

##

migration-select-all-option-label = Alles selecteren
migration-bookmarks-option-label = Bladwijzers
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Favorieten
migration-logins-and-passwords-option-label = Opgeslagen aanmeldingen en wachtwoorden
migration-history-option-label = Navigatiegeschiedenis
migration-extensions-option-label = Extensies
migration-form-autofill-option-label = Gegevens voor automatisch invullen van formulieren
migration-payment-methods-option-label = Betalingsmethoden
migration-cookies-option-label = Cookies
migration-session-option-label = Vensters en tabbladen
migration-otherdata-option-label = Andere gegevens
migration-passwords-from-file-progress-header = Wachtwoordenbestand importeren
migration-passwords-from-file-success-header = Wachtwoorden met succes geïmporteerd
migration-passwords-from-file = Bestand wordt gecontroleerd op wachtwoorden
migration-passwords-new = Nieuwe wachtwoorden
migration-passwords-updated = Bestaande wachtwoorden
migration-passwords-from-file-no-valid-data = Het bestand bevat geen geldige wachtwoordgegevens. Kies een ander bestand.
migration-passwords-from-file-picker-title = Wachtwoordenbestand importeren
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV-document
       *[other] CSV-bestand
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] TSV-document
       *[other] TSV-bestand
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] { $newEntries } toegevoegd
       *[other] { $newEntries } toegevoegd
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } bijgewerkt
       *[other] { $updatedEntries } bijgewerkt
    }
migration-bookmarks-from-file-picker-title = Bladwijzerbestand importeren
migration-bookmarks-from-file-progress-header = Bladwijzers importeren
migration-bookmarks-from-file = Bladwijzers
migration-bookmarks-from-file-success-header = Bladwijzers met succes geïmporteerd
migration-bookmarks-from-file-no-valid-data = Het bestand bevat geen bladwijzergegevens. Kies een ander bestand.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] HTML-document
       *[other] HTML-bestand
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = JSON-bestand
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } bladwijzer
       *[other] { $newEntries } bladwijzers
    }
migration-import-button-label = Importeren
migration-choose-to-import-from-file-button-label = Uit bestand importeren
migration-import-from-file-button-label = Bestand selecteren
migration-cancel-button-label = Annuleren
migration-done-button-label = Gereed
migration-continue-button-label = Doorgaan
migration-wizard-import-browser-no-browsers = { -brand-short-name } kan geen programma’s met bladwijzer-, geschiedenis- of wachtwoordgegevens vinden.
migration-wizard-import-browser-no-resources = Er is een fout opgetreden. { -brand-short-name } kan geen uit dat browserprofiel te importeren gegevens vinden.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = bladwijzers
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = favorieten
migration-list-password-label = wachtwoorden
migration-list-history-label = geschiedenis
migration-list-extensions-label = extensies
migration-list-autofill-label = gegevens automatisch invullen
migration-list-payment-methods-label = betalingsmethoden

##

migration-wizard-progress-header = Gegevens importeren
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Gegevens met succes geïmporteerd
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Gegevensimport voltooid
migration-wizard-progress-icon-in-progress =
    .aria-label = Importeren…
migration-wizard-progress-icon-completed =
    .aria-label = Voltooid
migration-safari-password-import-header = Wachtwoorden uit Safari importeren
migration-safari-password-import-steps-header = Safari-wachtwoorden importeren:
migration-safari-password-import-step1 = Open in Safari het menu ‘Safari’ en ga naar Voorkeuren > Wachtwoorden
migration-safari-password-import-step2 = Selecteer de knop <img data-l10n-name="safari-icon-3dots"/> en kies ‘Alle wachtwoorden exporteren’
migration-safari-password-import-step3 = Sla het wachtwoordenbestand op
migration-safari-password-import-step4 = Gebruik ‘Bestand selecteren’ hieronder om het wachtwoordenbestand dat u hebt opgeslagen te kiezen
migration-safari-password-import-skip-button = Overslaan
migration-safari-password-import-select-button = Bestand selecteren
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } bladwijzer
       *[other] { $quantity } bladwijzers
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
        [one] { $quantity } favoriet
       *[other] { $quantity } favorieten
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
        [one] { $quantity } extensie
       *[other] { $quantity } extensies
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } van { $quantity } extensies
migration-wizard-progress-extensions-support-link = Ontdek hoe { -brand-product-name } extensies matcht
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Geen overeenkomende extensies
migration-wizard-progress-extensions-addons-link = Door extensies voor { -brand-short-name } bladeren

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } wachtwoord
       *[other] { $quantity } wachtwoorden
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Van de afgelopen dag
       *[other] Van de afgelopen { $maxAgeInDays } dagen
    }
migration-wizard-progress-success-formdata = Formuliergeschiedenis
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } betalingsmethode
       *[other] { $quantity } betalingsmethoden
    }
migration-wizard-safari-permissions-sub-header = Safari-bladwijzers en navigatiegeschiedenis importeren:
migration-wizard-safari-instructions-continue = Selecteer ‘Doorgaan’
migration-wizard-safari-instructions-folder = Selecteer de map Safari in de lijst en kies ‘Openen’
