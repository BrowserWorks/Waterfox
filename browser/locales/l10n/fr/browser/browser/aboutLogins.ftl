# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Identifiants et mots de passe

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Emportez vos mots de passe partout
login-app-promo-subtitle = Téléchargez l’application gratuite { -lockwise-brand-name }
login-app-promo-android =
    .alt = Disponible sur Google Play
login-app-promo-apple =
    .alt = Télécharger dans l’App Store
login-filter =
    .placeholder = Rechercher des identifiants
create-login-button = Créer un nouvel identifiant
fxaccounts-sign-in-text = Accédez à vos mots de passe sur vos autres appareils
fxaccounts-sign-in-button = Se connecter à { -sync-brand-short-name }
fxaccounts-sign-in-sync-button = Se connecter pour synchroniser
fxaccounts-avatar-button =
    .title = Gérer le compte

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Ouvrir le menu
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Importer depuis un autre navigateur…
about-logins-menu-menuitem-import-from-a-file = Importer depuis un fichier…
about-logins-menu-menuitem-export-logins = Exporter les identifiants…
about-logins-menu-menuitem-remove-all-logins = Supprimer tous les identifiants…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Options
       *[other] Préférences
    }
about-logins-menu-menuitem-help = Aide
menu-menuitem-android-app = { -lockwise-brand-short-name } pour Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } pour iPhone et iPad

## Login List

login-list =
    .aria-label = Identifiants correspondants à la recherche
login-list-count =
    { $count ->
        [one] { $count } identifiant
       *[other] { $count } identifiants
    }
login-list-sort-label-text = Trier par :
login-list-name-option = Nom (A-Z)
login-list-name-reverse-option = Nom (Z-A)
about-logins-login-list-alerts-option = Alertes
login-list-last-changed-option = Dernière modification
login-list-last-used-option = Dernière utilisation
login-list-intro-title = Aucun identifiant trouvé
login-list-intro-description = Lorsque vous enregistrez un mot de passe dans { -brand-product-name }, il apparaît ici.
about-logins-login-list-empty-search-title = Aucun identifiant trouvé
about-logins-login-list-empty-search-description = Aucun résultat ne correspond à votre recherche.
login-list-item-title-new-login = Nouvel identifiant
login-list-item-subtitle-new-login = Saisissez vos informations de connexion
login-list-item-subtitle-missing-username = (aucun nom d’utilisateur)
about-logins-list-item-breach-icon =
    .title = Site victime d’une fuite de données
about-logins-list-item-vulnerable-password-icon =
    .title = Mot de passe vulnérable

## Introduction screen

login-intro-heading = Vous recherchez vos identifiants enregistrés ? Configurez { -sync-brand-short-name }.
about-logins-login-intro-heading-logged-out = Vous recherchez vos identifiants enregistrés ? Configurez { -sync-brand-short-name } ou importez-les.
about-logins-login-intro-heading-logged-out2 = Vous cherchez vos identifiants enregistrés ? Activez la synchronisation ou importez-les.
about-logins-login-intro-heading-logged-in = Aucun identifiant synchronisé trouvé.
login-intro-description = Si vous avez enregistré vos identifiants dans { -brand-product-name } sur un autre appareil, voici comment y accéder ici :
login-intro-instruction-fxa = Connectez-vous ou créez un { -fxaccount-brand-name } sur l’appareil où vos identifiants sont enregistrés.
login-intro-instruction-fxa-settings = Assurez-vous d’avoir coché la case Identifiants dans les paramètres de { -sync-brand-short-name }.
about-logins-intro-instruction-help = Pour obtenir de l’aide, visitez l’<a data-l10n-name="help-link">assistance de { -lockwise-brand-short-name }</a>.
login-intro-instructions-fxa = Connectez-vous ou créez un { -fxaccount-brand-name } sur l’appareil où vos identifiants sont enregistrés.
login-intro-instructions-fxa-settings = Allez dans Paramètres > Synchronisation > Activer la synchronisation… et sélectionnez la case Identifiants et mots de passe.
login-intro-instructions-fxa-help = Pour obtenir de l’aide, visitez l’<a data-l10n-name="help-link">assistance de { -lockwise-brand-short-name }</a>.
about-logins-intro-import = Si vos identifiants sont enregistrés dans un autre navigateur, vous pouvez <a data-l10n-name="import-link">les importer dans { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Si vos identifiants de connexion et mots de passe sont enregistrés en dehors de { -brand-product-name }, vous pouvez <a data-l10n-name="import-browser-link">les importer depuis un autre navigateur</a> ou <a data-l10n-name="import-file-link">depuis un fichier</a>

## Login

login-item-new-login-title = Créer un nouvel identifiant
login-item-edit-button = Modifier
about-logins-login-item-remove-button = Supprimer
login-item-origin-label = Adresse web
login-item-tooltip-message = Assurez-vous que cela correspond à l’adresse exacte du site web où vous vous connectez.
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Nom d’utilisateur
about-logins-login-item-username =
    .placeholder = (aucun nom d’utilisateur)
login-item-copy-username-button-text = Copier
login-item-copied-username-button-text = Copié !
login-item-password-label = Mot de passe
login-item-password-reveal-checkbox =
    .aria-label = Afficher le mot de passe
login-item-copy-password-button-text = Copier
login-item-copied-password-button-text = Copié !
login-item-save-changes-button = Enregistrer les modifications
login-item-save-new-button = Enregistrer
login-item-cancel-button = Annuler
login-item-time-changed = Dernière modification : { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Créé le : { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Dernière utilisation : { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Pour modifier votre identifiant, entrez vos informations de connexion Windows. Cela permet de conserver la sécurité de vos comptes.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = modifier l’identifiant enregistré
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Pour afficher votre mot de passe, entrez vos informations de connexion Windows. Cela permet de conserver la sécurité de vos comptes.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = révéler le mot de passe enregistré
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Pour copier votre mot de passe, entrez vos informations de connexion Windows. Cela contribue à protéger la sécurité de vos comptes.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = copier le mot de passe enregistré

## Master Password notification

master-password-notification-message = Veuillez saisir votre mot de passe principal pour afficher les identifiants et mots de passe enregistrés.
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Pour exporter vos identifiants, entrez vos informations de connexion Windows. Cela contribue à protéger la sécurité de vos comptes.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = exporter les identifiants et mots de passe enregistrés

## Primary Password notification

about-logins-primary-password-notification-message = Veuillez saisir votre mot de passe principal pour afficher les identifiants et mots de passe enregistrés.
master-password-reload-button =
    .label = Connexion
    .accesskey = C

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Vous souhaitez accéder à vos identifiants partout où vous utilisez { -brand-product-name } ? Rendez-vous dans les options de { -sync-brand-short-name } et cochez la case Identifiants.
       *[other] Vous souhaitez accéder à vos identifiants partout où vous utilisez { -brand-product-name } ? Rendez-vous dans les préférences de { -sync-brand-short-name } et cochez la case Identifiants.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Consulter les options de { -sync-brand-short-name }
           *[other] Consulter les préférences de { -sync-brand-short-name }
        }
    .accesskey = C
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Ne plus me demander
    .accesskey = N

## Dialogs

confirmation-dialog-cancel-button = Annuler
confirmation-dialog-dismiss-button =
    .title = Annuler
about-logins-confirm-remove-dialog-title = Supprimer cet identifiant ?
confirm-delete-dialog-message = Cette action est irréversible.
about-logins-confirm-remove-dialog-confirm-button = Supprimer
about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Supprimer
       *[other] Tout supprimer
    }
about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Oui, supprimer cet identifiant
       *[other] Oui, supprimer ces identifiants
    }
about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Supprimer { $count } identifiant ?
       *[other] Supprimer les { $count } identifiants ?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Vous allez supprimer l’identifiant de connexion que vous avez enregistré dans { -brand-short-name } et toute alerte de fuite de données qui apparaît ici. Cette action est irréversible.
       *[other] Vous allez supprimer tous les identifiants de connexion que vous avez enregistrés dans { -brand-short-name } et toute alerte de fuite de données qui apparaît ici. Cette action est irréversible.
    }
about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Supprimer cet identifiant de connexion de tous les appareils ?
       *[other] Supprimer les { $count } identifiants de connexion de tous les appareils ?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Cette action supprimera l’identifiant enregistré pour { -brand-short-name } de tous vos appareils synchronisés à votre { -fxaccount-brand-name }. Cela supprimera également les alertes de fuites de données qui apparaissent ici. Cette action est irréversible.
       *[other] Cette action supprimera tous les identifiants enregistrés pour { -brand-short-name } de tous vos appareils synchronisés à votre { -fxaccount-brand-name }. Cela supprimera également les alertes de fuites de données qui apparaissent ici. Cette action est irréversible.
    }
about-logins-confirm-export-dialog-title = Exporter les identifiants et les mots de passe
about-logins-confirm-export-dialog-message = Vos mots de passe seront enregistrés sous forme de texte lisible (par exemple, « m0t2passeFaible ») ; ainsi toute personne pouvant ouvrir le fichier exporté pourra les consulter.
about-logins-confirm-export-dialog-confirm-button = Exporter…
about-logins-alert-import-title = Importation terminée
about-logins-alert-import-message = Voir la liste détaillée des importations
confirm-discard-changes-dialog-title = Ignorer les modifications non enregistrées ?
confirm-discard-changes-dialog-message = Toutes les modifications non enregistrées seront perdues.
confirm-discard-changes-dialog-confirm-button = Ignorer

## Breach Alert notification

about-logins-breach-alert-title = Fuite de site web
breach-alert-text = Les mots de passe de ce site ont été divulgués ou volés après la dernière modification de vos informations de connexion. Changez votre mot de passe pour protéger votre compte.
about-logins-breach-alert-date = Cette fuite de données s’est produite le { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Accéder à { $hostname }
about-logins-breach-alert-learn-more-link = En savoir plus

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Mot de passe vulnérable
about-logins-vulnerable-alert-text2 = Ce mot de passe a déjà été utilisé pour un compte probablement compromis par une fuite de données. Réutiliser des informations d’identification met tous vos comptes en danger. Vous devriez changer immédiatement ce mot de passe.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Accéder à { $hostname }
about-logins-vulnerable-alert-learn-more-link = En savoir plus

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Un nom d’utilisateur ou d’utilisatrice pour { $loginTitle } existe déjà. <a data-l10n-name="duplicate-link">Accéder à l’entrée existante ?</a>
# This is a generic error message.
about-logins-error-message-default = Une erreur s’est produite en essayant d’enregistrer ce mot de passe.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Exporter le fichier des identifiants
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = identifiants.csv
about-logins-export-file-picker-export-button = Exporter
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Document CSV
       *[other] Fichier CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Importer un fichier d’identifiants
about-logins-import-file-picker-import-button = Importer
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Document CSV
       *[other] Fichier CSV
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Document TSV
       *[other] Fichier TSV
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Importation terminée
about-logins-import-dialog-items-added =
    { $count ->
       *[other] <span>Nouveaux identifiants ajoutés :</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-modified =
    { $count ->
       *[other] <span>Identifiants existants mis à jour :</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-no-change =
    { $count ->
        [1] <span>Identifiants en double trouvés :</span> <span data-l10n-name="count">{ $count }</span><span data-l10n-name="meta">(non importé)</span>
       *[other] <span>Identifiants en double trouvés :</span> <span data-l10n-name="count">{ $count }</span><span data-l10n-name="meta">(non importés)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
        [1] <span>Erreurs :</span> <span data-l10n-name="count">{ $count }</span><span data-l10n-name="meta">(non importée)</span>
       *[other] <span>Erreurs :</span> <span data-l10n-name="count">{ $count }</span><span data-l10n-name="meta">(non importées)</span>
    }
about-logins-import-dialog-done = Terminé
about-logins-import-dialog-error-title = Erreur d’importation
about-logins-import-dialog-error-conflicting-values-title = Plusieurs valeurs en conflit pour un seul identifiant
about-logins-import-dialog-error-conflicting-values-description = Par exemple : plusieurs noms d’utilisateur, mots de passe, URL, etc. pour un seul identifiant.
about-logins-import-dialog-error-file-format-title = Problème de format de fichier
about-logins-import-dialog-error-file-format-description = En-têtes de colonne incorrects ou manquants. Assurez-vous que le fichier contient des colonnes pour le nom d’utilisateur, le mot de passe et l’URL.
about-logins-import-dialog-error-file-permission-title = Impossible de lire le fichier
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } n’a pas la permission de lire le fichier. Essayez de modifier les permissions du fichier.
about-logins-import-dialog-error-unable-to-read-title = Impossible d’analyser le fichier
about-logins-import-dialog-error-unable-to-read-description = Assurez-vous d’avoir sélectionné un fichier CSV ou TSV.
about-logins-import-dialog-error-no-logins-imported = Aucun identifiant n’a été importé
about-logins-import-dialog-error-learn-more = En savoir plus
about-logins-import-dialog-error-try-again = Réessayer…
about-logins-import-dialog-error-try-import-again = Réessayer d’importer…
about-logins-import-dialog-error-cancel = Annuler
about-logins-import-report-title = Résumé de l’importation
about-logins-import-report-description = Identifiants et mots de passe importés dans { -brand-short-name }.
#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Ligne { $number }
about-logins-import-report-row-description-no-change = Doublon : correspondance exacte avec un identifiant existant
about-logins-import-report-row-description-modified = Identifiant existant mis à jour
about-logins-import-report-row-description-added = Nouvel identifiant ajouté
about-logins-import-report-row-description-error = Erreur : champ manquant

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Erreur : plusieurs valeurs pour { $field }
about-logins-import-report-row-description-error-missing-field = Erreur : « { $field } » est manquant

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nouvel identifiant ajouté</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">nouveaux identifiants ajoutés</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">identifiant existant mis à jour</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">identifiants existants mis à jour</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">identifiant en double</div> <div data-l10n-name="not-imported">(non importé)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">identifiants en double</div> <div data-l10n-name="not-imported">(non importés)</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">erreur</div> <div data-l10n-name="not-imported">(non importée)</div>
       *[other] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">erreurs</div> <div data-l10n-name="not-imported">(non importées)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Rapport récapitulatif d’importation
