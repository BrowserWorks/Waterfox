# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Importer des données d’un navigateur
migration-wizard-selection-list = Sélectionnez les données que vous souhaitez importer.
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
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge (anciennes versions)
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Mots de passe depuis un fichier CSV
migration-wizard-migrator-display-name-file-bookmarks = Marque-pages depuis un fichier HTML
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Importer toutes les données disponibles
migration-no-selected-data-label = Aucune donnée sélectionnée pour l’importation
migration-selected-data-label = Importer les données sélectionnées

##

migration-select-all-option-label = Tout sélectionner
migration-bookmarks-option-label = Marque-pages
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Favoris
migration-logins-and-passwords-option-label = Identifiants et mots de passe enregistrés
migration-history-option-label = Historique de navigation
migration-extensions-option-label = Extensions
migration-form-autofill-option-label = Données de remplissage automatique des formulaires
migration-payment-methods-option-label = Moyens de paiement
migration-cookies-option-label = Cookies
migration-session-option-label = Fenêtres et onglets
migration-otherdata-option-label = Autres données
migration-passwords-from-file-progress-header = Importer un fichier de mots de passe
migration-passwords-from-file-success-header = Mots de passe correctement importés
migration-passwords-from-file = Recherche des mots de passe dans le fichier
migration-passwords-new = Nouveaux mots de passe
migration-passwords-updated = Mots de passe existants
migration-passwords-from-file-no-valid-data = Ce fichier ne contient pas de données de mots de passe. Choisissez un autre fichier.
migration-passwords-from-file-picker-title = Importer un fichier de mots de passe
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] Document CSV
       *[other] Fichier CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] Document TSV
       *[other] Fichier TSV
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] { $newEntries } ajouté
       *[other] { $newEntries } ajoutés
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } mis à jour
       *[other] { $updatedEntries } mis à jour
    }
migration-bookmarks-from-file-picker-title = Importer des marque-pages
migration-bookmarks-from-file-progress-header = Importation des marque-pages
migration-bookmarks-from-file = Marque-pages
migration-bookmarks-from-file-success-header = Importation des marque-pages réussie
migration-bookmarks-from-file-no-valid-data = Ce fichier ne contient pas de données de marque-pages. Choisissez un autre fichier.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] Document HTML
       *[other] Fichier HTML
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = Fichier JSON
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } marque-page
       *[other] { $newEntries } marque-pages
    }
migration-import-button-label = Importer
migration-choose-to-import-from-file-button-label = Importer depuis un fichier
migration-import-from-file-button-label = Sélectionner un fichier
migration-cancel-button-label = Annuler
migration-done-button-label = Terminé
migration-continue-button-label = Continuer
migration-wizard-import-browser-no-browsers = { -brand-short-name } n’a trouvé aucun programme contenant des données de marque-pages, d’historique ou de mots de passe.
migration-wizard-import-browser-no-resources = Une erreur est survenue. { -brand-short-name } ne trouve aucune donnée à importer à partir de ce profil de navigateur.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = marque-pages
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = favoris
migration-list-password-label = mots de passe
migration-list-history-label = historique
migration-list-extensions-label = extensions
migration-list-autofill-label = données de remplissage automatique
migration-list-payment-methods-label = moyens de paiement

##

migration-wizard-progress-header = Importation des données
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Données correctement importées
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Importation des données terminée
migration-wizard-progress-icon-in-progress =
    .aria-label = Importation…
migration-wizard-progress-icon-completed =
    .aria-label = Terminé
migration-safari-password-import-header = Importer les mots de passe de Safari
migration-safari-password-import-steps-header = Pour importer les mots de passe de Safari :
migration-safari-password-import-step1 = Dans Safari, ouvrez le menu « Safari » puis allez dans Réglages > Mots de passe
migration-safari-password-import-step2 = Cliquez sur le bouton <img data-l10n-name="safari-icon-3dots"/> et choisissez « Exporter tous les mots de passe »
migration-safari-password-import-step3 = Enregistrez le fichier des mots de passe
migration-safari-password-import-step4 = Utilisez « Sélectionner un fichier » ci-dessous pour choisir le fichier de mots de passe que vous avez enregistré
migration-safari-password-import-skip-button = Passer
migration-safari-password-import-select-button = Sélectionner un fichier
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $amount } marque-page
       *[other] { $quantity } marque-pages
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
        [one] { $quantity } favori
       *[other] { $quantity } favoris
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
        [one] { $quantity } extension
       *[other] { $quantity } extensions
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions =
    { $matched ->
        [one] { $matched } extension sur { $quantity }
       *[other] { $matched } extensions sur { $quantity }
    }
migration-wizard-progress-extensions-support-link = Découvrez comment { -brand-product-name } identifie les extensions
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Aucune extension identifiée
migration-wizard-progress-extensions-addons-link = Parcourir les extensions pour { -brand-short-name }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } mot de passe
       *[other] { $quantity } mots de passe
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] Depuis hier
       *[other] Au cours des { $maxAgeInDays } derniers jours
    }
migration-wizard-progress-success-formdata = Historique des formulaires
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } mode de paiement
       *[other] { $quantity } modes de paiement
    }
migration-wizard-safari-permissions-sub-header = Pour importer les marque-pages et l’historique de navigation de Safari :
migration-wizard-safari-instructions-continue = Sélectionnez « Continuer »
migration-wizard-safari-instructions-folder = Sélectionnez le dossier Safari dans la liste et choisissez « Ouvrir »
