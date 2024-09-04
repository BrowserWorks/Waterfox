# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# The button for "Waterfox Translations" in the url bar.
urlbar-translations-button =
    .tooltiptext = Traduire cette page
# The button for "Waterfox Translations" in the url bar. Note that here "Beta" should
# not be translated, as it is a reflection of the un-localized BETA icon that is in the
# panel.
urlbar-translations-button2 =
    .tooltiptext = Traduire cette page - Bêta
# Note that here "Beta" should not be translated, as it is a reflection of the
# un-localized BETA icon that is in the panel.
urlbar-translations-button-intro =
    .tooltiptext = Essayez le système de traduction respectueux de la vie privée dans { -brand-shorter-name } - Bêta
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Page translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
urlbar-translations-button-translated =
    .tooltiptext = Page traduite en { $toLanguage }, l’originale est en { $fromLanguage }
urlbar-translations-button-loading =
    .tooltiptext = Traduction en cours
translations-panel-settings-button =
    .aria-label = Gérer les paramètres de traduction
# Text displayed on a language dropdown when the language is in beta
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-displayname-beta =
    .label = { $language } BÊTA

## Options in the Waterfox Translations settings.

translations-panel-settings-manage-languages =
    .label = Gérer les langues
translations-panel-settings-about = À propos des traductions dans { -brand-shorter-name }
translations-panel-settings-about2 =
    .label = À propos des traductions dans { -brand-shorter-name }
# Text displayed for the option to always translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-always-translate-language =
    .label = Toujours traduire les pages en { $language }
translations-panel-settings-always-translate-unknown-language =
    .label = Toujours traduire cette langue
translations-panel-settings-always-offer-translation =
    .label = Toujours proposer de traduire
# Text displayed for the option to never translate a given language
# Variables:
#   $language (string) - The localized display name of the detected language
translations-panel-settings-never-translate-language =
    .label = Ne jamais traduire les pages en { $language }
translations-panel-settings-never-translate-unknown-language =
    .label = Ne jamais traduire cette langue
# Text displayed for the option to never translate this website
translations-panel-settings-never-translate-site =
    .label = Ne jamais traduire ce site

## The translation panel appears from the url bar, and this view is the default
## translation view.

translations-panel-header = Traduire cette page ?
translations-panel-translate-button =
    .label = Traduire
translations-panel-translate-button-loading =
    .label = Veuillez patienter…
translations-panel-translate-cancel =
    .label = Annuler
translations-panel-learn-more-link = En savoir plus
translations-panel-intro-header = Essayez le système de traduction respectueux de la vie privée dans { -brand-shorter-name }
translations-panel-intro-description = Afin de respecter votre vie privée, les traductions ne quittent jamais votre appareil. De nouvelles langues et des améliorations seront bientôt disponibles !
translations-panel-error-translating = Un problème s’est produit lors de la traduction. Veuillez réessayer.
translations-panel-error-load-languages = Impossible de charger les langues
translations-panel-error-load-languages-hint = Vérifiez votre connexion Internet puis réessayez.
translations-panel-error-load-languages-hint-button =
    .label = Réessayer
translations-panel-error-unsupported = Aucune traduction disponible pour cette page
translations-panel-error-dismiss-button =
    .label = J’ai compris
translations-panel-error-change-button =
    .label = Changer la langue source
# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `Sorry, we don't support the language yet: { $language }
#
# Variables:
#   $language (string) - The language of the document.
translations-panel-error-unsupported-hint-known = Désolé, nous ne prenons pas encore en charge cette langue : { $language }
translations-panel-error-unsupported-hint-unknown = Désolé, nous ne prenons pas encore en charge cette langue.

## Each label is followed, on a new line, by a dropdown list of language names.
## If this structure is problematic for your locale, an alternative way is to
## translate them as `Source language:` and `Target language:`

translations-panel-from-label = Langue source :
translations-panel-to-label = Langue cible :

## The translation panel appears from the url bar, and this view is the "restore" view
## that lets a user restore a page to the original language, or translate into another
## language.

# If your language requires declining the language name, a possible solution
# is to adapt the structure of the phrase, or use a support noun, e.g.
# `The page is translated from: { $fromLanguage }. Current target language: { $toLanguage }`
#
# Variables:
#   $fromLanguage (string) - The original language of the document.
#   $toLanguage (string) - The target language of the translation.
translations-panel-revisit-header = Cette page est traduite en { $toLanguage }, l’originale est en { $fromLanguage }
translations-panel-choose-language =
    .label = Choisissez une langue
translations-panel-restore-button =
    .label = Afficher la page d’origine

## Waterfox Translations language management in about:preferences.

translations-manage-header = Traductions
translations-manage-settings-button =
    .label = Paramètres…
    .accesskey = P
translations-manage-description = Télécharger des langues pour traduction hors connexion.
translations-manage-all-language = Toutes les langues
translations-manage-download-button = Télécharger
translations-manage-delete-button = Supprimer
translations-manage-error-download = Un problème est survenu lors du téléchargement des fichiers de langue. Veuillez réessayer.
translations-manage-error-delete = Une erreur s’est produite lors de la suppression des fichiers de langue. Veuillez réessayer.
translations-manage-intro = Définissez vos préférences de langue et de traduction des sites, et gérez l’installation des langues pour la traduction hors connexion.
translations-manage-install-description = Installer des langues pour traduction hors connexion
translations-manage-language-install-button =
    .label = Installer
translations-manage-language-install-all-button =
    .label = Tout installer
    .accesskey = T
translations-manage-language-remove-button =
    .label = Supprimer
translations-manage-language-remove-all-button =
    .label = Tout supprimer
    .accesskey = s
translations-manage-error-install = Un problème est survenu lors de l’installation des fichiers de langue. Veuillez réessayer.
translations-manage-error-remove = Une erreur s’est produite lors de la suppression des fichiers de langue. Veuillez réessayer.
translations-manage-error-list = Impossible d’obtenir la liste des langues disponibles pour la traduction. Actualisez la page pour réessayer.
translations-settings-title =
    .title = Paramètres de traduction
    .style = min-width: 36em
translations-settings-close-key =
    .key = w
translations-settings-always-translate-langs-description = La traduction se fera automatiquement pour les langues suivantes
translations-settings-never-translate-langs-description = Aucune traduction ne sera proposée pour les langues suivantes
translations-settings-never-translate-sites-description = Aucune traduction ne sera proposée pour les sites web suivants
translations-settings-languages-column =
    .label = Langues
translations-settings-remove-language-button =
    .label = Supprimer la langue
    .accesskey = S
translations-settings-remove-all-languages-button =
    .label = Supprimer toutes les langues
    .accesskey = t
translations-settings-sites-column =
    .label = Sites web
translations-settings-remove-site-button =
    .label = Supprimer le site
    .accesskey = u
translations-settings-remove-all-sites-button =
    .label = Supprimer tous les sites
    .accesskey = m
translations-settings-close-dialog =
    .buttonlabelaccept = Fermer
    .buttonaccesskeyaccept = F
