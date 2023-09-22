# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Importa dati del browser
migration-wizard-selection-list = Seleziona i dati che desideri importare.

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
migration-wizard-migrator-display-name-file-password-csv = Password da file CSV
migration-wizard-migrator-display-name-file-bookmarks = Segnalibri da file HTML
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Importa tutti i dati disponibili
migration-no-selected-data-label = Nessun dato selezionato per l’importazione
migration-selected-data-label = Importa i dati selezionati

##

migration-select-all-option-label = Seleziona tutto
migration-bookmarks-option-label = Segnalibri

# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Preferiti

migration-logins-and-passwords-option-label = Credenziali e password salvate
migration-history-option-label = Cronologia di navigazione
migration-extensions-option-label = Estensioni
migration-form-autofill-option-label = Dati per la compilazione automatica dei moduli
migration-payment-methods-option-label = Metodi di pagamento

migration-cookies-option-label = Cookie
migration-session-option-label = Finestre e schede
migration-otherdata-option-label = Altri dati

migration-passwords-from-file-progress-header = Importazione file di password
migration-passwords-from-file-success-header = Password importate correttamente
migration-passwords-from-file = Verifica delle password nel file
migration-passwords-new = Nuove password
migration-passwords-updated = Password esistenti

migration-passwords-from-file-no-valid-data = Il file non include alcuna informazione valida relativa alle password. Seleziona un altro file.

migration-passwords-from-file-picker-title = Importazione file di password
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] Documento CSV
       *[other] File CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] Documento TSV
       *[other] File TSV
    }

# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] { $newEntries } aggiunta
       *[other] { $newEntries } aggiunte
    }

# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } aggiornata
       *[other] { $updatedEntries } aggiornate
    }

migration-bookmarks-from-file-picker-title = Importazione file di segnalibri
migration-bookmarks-from-file-progress-header = Importazione segnalibri
migration-bookmarks-from-file = Segnalibri
migration-bookmarks-from-file-success-header = Segnalibri importati correttamente

migration-bookmarks-from-file-no-valid-data = Il file non include alcuna informazione relativa ai segnalibri. Seleziona un altro file.

# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
  { PLATFORM() ->
      [macos] Documento HTML
     *[other] File HTML
  }

# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = File JSON

# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } segnalibro
       *[other] { $newEntries } segnalibri
    }

migration-import-button-label = Importa
migration-choose-to-import-from-file-button-label = Importa da file
migration-import-from-file-button-label = Seleziona file
migration-cancel-button-label = Annulla
migration-done-button-label = Fatto
migration-continue-button-label = Continua

migration-wizard-import-browser-no-browsers = Non è stato possibile trovare alcun programma che contenga segnalibri, cronologia o password.
migration-wizard-import-browser-no-resources = Si è verificato un errore. Non è stato possibile importare alcun dato dal profilo del browser.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = segnalibri

# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = preferiti
migration-list-password-label = password
migration-list-history-label = cronologia
migration-list-extensions-label = estensioni
migration-list-autofill-label = dati per la compilazione automatica dei moduli
migration-list-payment-methods-label = metodi di pagamento

##

migration-wizard-progress-header = Importazione dati
migration-wizard-progress-done-header = Importazione dei dati completata correttamente
migration-wizard-progress-done-with-warnings-header = Importazione dei dati completata
migration-wizard-progress-icon-in-progress =
    .aria-label = Importazione in corso…
migration-wizard-progress-icon-completed =
    .aria-label = Completata

migration-safari-password-import-header = Importazione password da Safari
migration-safari-password-import-steps-header = Per importare le password di Safari:
migration-safari-password-import-step1 = In Safari, apri il menu “Safari”, poi seleziona Preferenze > Password
migration-safari-password-import-step2 = Fai clic sul pulsante <img data-l10n-name="safari-icon-3dots"/> e seleziona “Esporta tutte le password…”
migration-safari-password-import-step3 = Salva il file delle password
migration-safari-password-import-step4 = Utilizza “Seleziona file” di seguito per scegliere il file delle password che hai salvato
migration-safari-password-import-skip-button = Salta
migration-safari-password-import-select-button = Seleziona file


# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } segnalibro
       *[other] { $quantity } segnalibri
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
        [one] { $quantity } preferito
       *[other] { $quantity } preferiti
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
        [one] { $quantity } estensione
       *[other] { $quantity } estensioni
    }

# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } di { $quantity } estensioni

migration-wizard-progress-extensions-support-link = Scopri in che modo { -brand-product-name } trova corrispondenze tra le estensioni
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Nessuna estensione corrispondente

migration-wizard-progress-extensions-addons-link = Scopri estensioni per { -brand-short-name }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords = { $quantity } password

# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Dell’ultimo giorno
       *[other] Degli ultimi { $maxAgeInDays } giorni
    }

migration-wizard-progress-success-formdata = Cronologia moduli

# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } metodo di pagamento
       *[other] { $quantity } metodi di pagamento
    }

migration-wizard-safari-permissions-sub-header = Per importare i segnalibri di Safari e la cronologia di navigazione:
migration-wizard-safari-instructions-continue = Seleziona “Continua”
migration-wizard-safari-instructions-folder = Seleziona la cartella Safari nell’elenco e fai clic su “Apri”



