# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Gestionnaire de modules complémentaires
addons-page-title = Gestionnaire de modules complémentaires
search-header =
    .placeholder = Rechercher sur addons.mozilla.org
    .searchbuttonlabel = Rechercher
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Téléchargez des extensions et des thèmes sur <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = Vous n’avez aucun module de ce type installé
list-empty-available-updates =
    .value = Aucune mise à jour trouvée
list-empty-recent-updates =
    .value = Vous n’avez pas mis à jour vos modules complémentaires depuis un certain temps
list-empty-find-updates =
    .label = Vérifier les mises à jour
list-empty-button =
    .label = En apprendre plus sur les modules complémentaires
help-button = Assistance des modules
sidebar-help-button-title =
    .title = Assistance des modules
preferences =
    { PLATFORM() ->
        [windows] Options de { -brand-short-name }
       *[other] Préférences de { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Options de { -brand-short-name }
           *[other] Préférences de { -brand-short-name }
        }
addons-settings-button = Paramètres de { -brand-short-name }
sidebar-settings-button-title =
    .title = Paramètres de { -brand-short-name }
show-unsigned-extensions-button =
    .label = Certaines extensions n’ont pas pu être vérifiées
show-all-extensions-button =
    .label = Afficher toutes les extensions
cmd-show-details =
    .label = Afficher plus d’informations
    .accesskey = A
cmd-find-updates =
    .label = Rechercher des mises à jour
    .accesskey = R
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Options
           *[other] Préférences
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
cmd-enable-theme =
    .label = Appliquer le thème
    .accesskey = A
cmd-disable-theme =
    .label = Enlever le thème
    .accesskey = E
cmd-install-addon =
    .label = Installer
    .accesskey = I
cmd-contribute =
    .label = Contribuer
    .accesskey = C
    .tooltiptext = Contribuer au développement de ce module complémentaire
detail-version =
    .label = Version
detail-last-updated =
    .label = Dernière mise à jour
detail-contributions-description = Le développeur de ce module demande que vous l’aidiez à assurer la poursuite de son développement en lui versant une petite contribution.
detail-contributions-button = Participer
    .title = Participer au développement de ce module complémentaire
    .accesskey = P
detail-update-type =
    .value = Mises à jour automatiques
detail-update-default =
    .label = Par défaut
    .tooltiptext = N’installer les mises à jour automatiquement que s’il s’agit du réglage par défaut
detail-update-automatic =
    .label = Activées
    .tooltiptext = Installer automatiquement les mises à jour
detail-update-manual =
    .label = Désactivées
    .tooltiptext = Ne pas installer automatiquement les mises à jour
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Exécution dans les fenêtres privées
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Non autorisée dans les fenêtres privées
detail-private-disallowed-description2 = Cette extension ne fonctionne pas en navigation privée. <a data-l10n-name="learn-more">En savoir plus</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Nécessite un accès aux fenêtres privées
detail-private-required-description2 = Cette extension a accès à vos activités en ligne pendant la navigation privée. <a data-l10n-name="learn-more">En savoir plus</a>
detail-private-browsing-on =
    .label = Autoriser
    .tooltiptext = Autoriser en navigation privée
detail-private-browsing-off =
    .label = Ne pas autoriser
    .tooltiptext = Ne pas autoriser en navigation privée
detail-home =
    .label = Page d’accueil
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Profil du module
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Vérifier si des mises à jour sont disponibles
    .accesskey = V
    .tooltiptext = Vérifier si des mises à jour sont disponibles pour ce module
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Options
           *[other] Préférences
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Modifier les options de ce module
           *[other] Modifier les préférences de ce module
        }
detail-rating =
    .value = Appréciation
addon-restart-now =
    .label = Redémarrer maintenant
disabled-unsigned-heading =
    .value = Certains modules complémentaires ont été désactivés
disabled-unsigned-description = Les modules complémentaires suivants n’ont pas pu être vérifiés pour leur utilisation dans { -brand-short-name }. Vous pouvez <label data-l10n-name="find-addons">rechercher des modules équivalents</label> ou demander au développeur de les faire vérifier.
disabled-unsigned-learn-more = En savoir plus sur nos efforts pour vous apporter plus de sécurité en ligne.
disabled-unsigned-devinfo = Les développeurs souhaitant faire vérifier leurs modules complémentaires peuvent obtenir davantage d’informations en lisant notre <label data-l10n-name="learn-more">manuel</label>.
plugin-deprecation-description = Quelque chose semble manquer ? Certains plugins ne sont plus pris en charge par { -brand-short-name }. <label data-l10n-name="learn-more">En savoir plus.</label>
legacy-warning-show-legacy = Afficher les extensions obsolètes
legacy-extensions =
    .value = Extensions obsolètes
legacy-extensions-description = Ces extensions ne répondent pas aux exigences actuelles de { -brand-short-name }. Elles ont été désactivées. <label data-l10n-name="legacy-learn-more">En savoir plus sur les changements apportés aux modules</label>
private-browsing-description2 =
    { -brand-short-name } modifie le fonctionnement des extensions en navigation privée. Aucune nouvelle extension que vous ajouterez à
    { -brand-short-name } ne s’exécutera par défaut dans une fenêtre privée. Si vous ne le permettez pas dans les paramètres, 
    l’extension ne fonctionnera pas en navigation privée et n’aura pas accès à vos activités en ligne.
    Nous avons apporté cette modification pour que votre navigation privée reste confidentielle.
    <label data-l10n-name="private-browsing-learn-more"> Découvrez comment gérer les paramètres d’extension.</ label>
addon-category-discover = Recommandations
addon-category-discover-title =
    .title = Recommandations
addon-category-extension = Extensions
addon-category-extension-title =
    .title = Extensions
addon-category-theme = Thèmes
addon-category-theme-title =
    .title = Thèmes
addon-category-plugin = Plugins
addon-category-plugin-title =
    .title = Plugins
addon-category-dictionary = Dictionnaires
addon-category-dictionary-title =
    .title = Dictionnaires
addon-category-locale = Langues
addon-category-locale-title =
    .title = Langues
addon-category-available-updates = À mettre à jour
addon-category-available-updates-title =
    .title = À mettre à jour
addon-category-recent-updates = Mis à jour
addon-category-recent-updates-title =
    .title = Mis à jour

## These are global warnings

extensions-warning-safe-mode = Tous les modules complémentaires ont été désactivés par le mode sans échec.
extensions-warning-check-compatibility = La vérification de compatibilité des modules complémentaires est désactivée. Vous avez peut-être des modules complémentaires incompatibles.
extensions-warning-check-compatibility-button = Activer
    .title = Activer la vérification de compatibilité
extensions-warning-update-security = La vérification de mises à jour de sécurité pour les modules complémentaires est désactivée. Vous avez peut-être des modules complémentaires non sûrs.
extensions-warning-update-security-button = Activer
    .title = Activer la vérification de mises à jour de sécurité pour les modules complémentaires

## Strings connected to add-on updates

addon-updates-check-for-updates = Rechercher des mises à jour
    .accesskey = R
addon-updates-view-updates = Afficher les mises à jour récentes
    .accesskey = A

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Mettre à jour les modules automatiquement
    .accesskey = M

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Activer la mise à jour automatique pour tous les modules
    .accesskey = c
addon-updates-reset-updates-to-manual = Désactiver la mise à jour automatique pour tous les modules
    .accesskey = D

## Status messages displayed when updating add-ons

addon-updates-updating = Mise à jour des modules
addon-updates-installed = Vos modules ont été mis à jour.
addon-updates-none-found = Aucune mise à jour disponible
addon-updates-manual-updates-found = Afficher les mises à jour disponibles

## Add-on install/debug strings for page options menu

addon-install-from-file = Installer un module depuis un fichier…
    .accesskey = I
addon-install-from-file-dialog-title = Sélectionner un module à installer
addon-install-from-file-filter-name = Modules complémentaires
addon-open-about-debugging = Déboguer des modules
    .accesskey = b

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Gérer les raccourcis d’extensions
    .accesskey = G
shortcuts-no-addons = Aucune extension n’est activée.
shortcuts-no-commands = Les extensions suivantes ne disposent pas de raccourcis :
shortcuts-input =
    .placeholder = Saisissez un raccourci
shortcuts-browserAction2 = Activer le bouton de la barre d’outils
shortcuts-pageAction = Activer l’action de la page
shortcuts-sidebarAction = Afficher/Masquer le panneau latéral
shortcuts-modifier-mac = Inclure Ctrl, Alt ou ⌘
shortcuts-modifier-other = Inclure Ctrl ou Alt
shortcuts-invalid = Combinaison invalide
shortcuts-letter = Saisissez une lettre
shortcuts-system = Impossible de remplacer un raccourci { -brand-short-name }
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Raccourci en doublon
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } est utilisé comme raccourci dans plusieurs cas. Les raccourcis en doublon peuvent provoquer un comportement imprévisible.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Déjà utilisé par { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] En montrer { $numberToShow } de plus
       *[other] En montrer { $numberToShow } de plus
    }
shortcuts-card-collapse-button = En montrer moins
header-back-button =
    .title = Retour

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Les extensions et les thèmes sont comme des applications pour votre navigateur qui vous permettent de protéger vos mots de passe, télécharger des vidéos, trouver de bonnes affaires, bloquer les publicités gênantes, changer l’apparence de votre navigateur, etc. Ces petits logiciels sont souvent produits par des développeurs tiers. Voici une sélection que { -brand-product-name } <a data-l10n-name="learn-more-trigger">recommande</a> pour une sécurité, des performances et des fonctionnalités poussées.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Certaines de ces recommandations sont personnalisées. Cette sélection se fonde sur d’autres extensions que vous avez installées, les préférences de votre profil et les statistiques d’utilisation.
discopane-notice-learn-more = En savoir plus
privacy-policy = Politique de confidentialité
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = par <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Utilisateurs : { $dailyUsers }
install-extension-button = Ajouter à { -brand-product-name }
install-theme-button = Installer le thème
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Gérer
find-more-addons = Découvrir davantage de modules
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Plus d’options

## Add-on actions

report-addon-button = Signaler
remove-addon-button = Supprimer
# The link will always be shown after the other text.
remove-addon-disabled-button = Suppression impossible <a data-l10n-name="link">Pourquoi ?</a>
disable-addon-button = Désactiver
enable-addon-button = Activer
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Activer
preferences-addon-button =
    { PLATFORM() ->
        [windows] Options
       *[other] Préférences
    }
details-addon-button = Détails
release-notes-addon-button = Notes de version
permissions-addon-button = Permissions
extension-enabled-heading = Activées
extension-disabled-heading = Désactivées
theme-enabled-heading = Activé
theme-disabled-heading = Désactivés
plugin-enabled-heading = Activés
plugin-disabled-heading = Désactivés
dictionary-enabled-heading = Activés
dictionary-disabled-heading = Désactivés
locale-enabled-heading = Activées
locale-disabled-heading = Désactivées
ask-to-activate-button = Demander pour activer
always-activate-button = Toujours activer
never-activate-button = Ne jamais activer
addon-detail-author-label = Auteur
addon-detail-version-label = Version
addon-detail-last-updated-label = Dernière mise à jour
addon-detail-homepage-label = Page d’accueil
addon-detail-rating-label = Appréciation
# Message for add-ons with a staged pending update.
install-postponed-message = Cette extension sera mise à jour au redémarrage de { -brand-short-name }.
install-postponed-button = Mettre à jour maintenant
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Noté { NUMBER($rating, maximumFractionDigits: 1) } sur 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (désactivé)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } critique
       *[other] { $numberOfReviews } critiques
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> a été supprimé.
pending-uninstall-undo-button = Annuler
addon-detail-updates-label = Autoriser les mises à jour automatiques
addon-detail-updates-radio-default = Par défaut
addon-detail-updates-radio-on = Activées
addon-detail-updates-radio-off = Désactivées
addon-detail-update-check-label = Rechercher des mises à jour
install-update-button = Mettre à jour
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Autorisée dans les fenêtres de navigation privée
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Lorsqu’elle est autorisée, l’extension a accès à vos activités en ligne lors d’une navigation privée. <a data-l10n-name="learn-more">En savoir plus</a>
addon-detail-private-browsing-allow = Autoriser
addon-detail-private-browsing-disallow = Ne pas autoriser

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } ne recommande que des extensions conformes à nos normes en matière de sécurité et de performances.
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Mozilla" in the string below because the extensions are built
# by Mozilla and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Extension officielle, réalisée par Mozilla. Elle répond aux normes de sécurité et de performance.
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Après examen, cette extension a été reconnue conforme à nos normes de sécurité et de performance
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Mises à jour disponibles
recent-updates-heading = Mises à jour récentes
release-notes-loading = Chargement…
release-notes-error = Désolé, une erreur s’est produite lors du chargement des notes de version.
addon-permissions-empty = Cette extension ne nécessite aucune autorisation
addon-permissions-required = Autorisations nécessaires pour les fonctionnalités de base :
addon-permissions-optional = Autorisations facultatives pour des fonctionnalités supplémentaires :
addon-permissions-learnmore = En savoir plus à propos des autorisations
recommended-extensions-heading = Extensions recommandées
recommended-themes-heading = Thèmes recommandés
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Vous avez la fibre créative ? <a data-l10n-name="link">Créez votre propre thème avec Firefox Color.</a>

## Page headings

extension-heading = Gestion de vos extensions
theme-heading = Gestion de vos thèmes
plugin-heading = Gestion de vos plugins
dictionary-heading = Gestion de vos dictionnaires
locale-heading = Gestion des langues
updates-heading = Gestion de vos mises à jour
discover-heading = Personnalisez { -brand-short-name }
shortcuts-heading = Gestion des raccourcis d’extensions
default-heading-search-label = Découvrez davantage de modules
addons-heading-search-input =
    .placeholder = Rechercher sur addons.mozilla.org
addon-page-options-button =
    .title = Outils pour tous les modules
