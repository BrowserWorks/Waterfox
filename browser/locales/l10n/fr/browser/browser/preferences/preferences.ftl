# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Envoyer aux sites web un signal « Ne pas me pister » indiquant que vous ne souhaitez pas être pisté·e
do-not-track-learn-more = En savoir plus
do-not-track-option-default-content-blocking-known =
    .label = Seulement quand { -brand-short-name } est paramétré pour bloquer les traqueurs connus
do-not-track-option-always =
    .label = Toujours
pref-page-title =
    { PLATFORM() ->
        [windows] Options
       *[other] Préférences
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 19em
    .placeholder =
        { PLATFORM() ->
            [windows] Rechercher dans les options
           *[other] Rechercher dans les préférences
        }
settings-page-title = Paramètres
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 19em
    .placeholder = Rechercher dans les paramètres
managed-notice = Votre navigateur est géré par votre organisation.
category-list =
    .aria-label = Catégories
pane-general-title = Général
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Accueil
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Recherche
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Vie privée et sécurité
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-sync-title3 = Synchronisation
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = Expériences de { -brand-short-name }
category-experimental =
    .tooltiptext = Expériences de { -brand-short-name }
pane-experimental-subtitle = Agissez avec précaution
pane-experimental-search-results-header = Expériences de { -brand-short-name } : gardez l’œil ouvert
pane-experimental-description2 = Modifier les paramètres de configuration avancés peut affecter les performances et la sécurité de { -brand-short-name }.
pane-experimental-reset =
    .label = Configuration par défaut
    .accesskey = d
help-button-label = Assistance de { -brand-short-name }
addons-button-label = Extensions et thèmes
focus-search =
    .key = f
close-button =
    .aria-label = Fermer

## Browser Restart Dialog

feature-enable-requires-restart = { -brand-short-name } doit redémarrer pour activer cette fonctionnalité.
feature-disable-requires-restart = { -brand-short-name } doit redémarrer pour désactiver cette fonctionnalité.
should-restart-title = Redémarrer { -brand-short-name }
should-restart-ok = Redémarrer { -brand-short-name } maintenant
cancel-no-restart-button = Annuler
restart-later = Redémarrer plus tard

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = Une extension, <img data-l10n-name="icon"/> { $name }, contrôle votre page d’accueil.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Une extension, <img data-l10n-name="icon"/> { $name }, contrôle la page Nouvel onglet.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Une extension, <img data-l10n-name="icon"/> { $name }, contrôle ce paramètre.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Une extension, <img data-l10n-name="icon"/> { $name }, contrôle ce paramètre.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Une extension, <img data-l10n-name="icon"/> { $name }, a défini votre moteur de recherche par défaut.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Une extension, <img data-l10n-name="icon"/> { $name }, a besoin des onglets conteneurs.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Une extension, <img data-l10n-name="icon"/> { $name }, contrôle ce paramètre.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Une extension, <img data-l10n-name="icon"/> { $name }, contrôle la façon dont { -brand-short-name } se connecte à Internet.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Pour activer l’extension, sélectionnez <img data-l10n-name="addons-icon"/> Modules complémentaires dans le menu <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Résultats de la recherche
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Désolé, il n’y a aucun résultat dans les options pour « <span data-l10n-name="query"></span> ».
       *[other] Désolé, il n’y a aucun résultat dans les préférences pour « <span data-l10n-name="query"></span> ».
    }
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Désolé, il n’y a aucun résultat dans les paramètres pour « <span data-l10n-name="query"></span> ».
search-results-help-link = Besoin d’aide ? Consultez <a data-l10n-name="url">l’assistance de { -brand-short-name }</a>

## General Section

startup-header = Démarrage
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Autoriser { -brand-short-name } et Firefox à s’exécuter en parallèle
use-firefox-sync = Astuce : Des profils distincts sont utilisés. Vous pouvez tirer parti de { -sync-brand-short-name } pour partager vos données entre eux.
get-started-not-logged-in = Se connecter à { -sync-brand-short-name }…
get-started-configured = Ouvrir les préférences de { -sync-brand-short-name }
always-check-default =
    .label = Toujours vérifier que { -brand-short-name } est votre navigateur par défaut
    .accesskey = v
is-default = { -brand-short-name } est votre navigateur par défaut
is-not-default = { -brand-short-name } n’est pas votre navigateur par défaut
set-as-my-default-browser =
    .label = Définir par défaut…
    .accesskey = D
startup-restore-previous-session =
    .label = Restaurer la session précédente
    .accesskey = e
startup-restore-warn-on-quit =
    .label = Prévenir à la fermeture du navigateur
disable-extension =
    .label = Désactiver l’extension
tabs-group-header = Onglets
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab fait défiler vos onglets en les classant selon leur dernière utilisation
    .accesskey = T
open-new-link-as-tabs =
    .label = Ouvrir les liens dans des onglets au lieu de nouvelles fenêtres
    .accesskey = f
warn-on-close-multiple-tabs =
    .label = Avertir lors de la fermeture de plusieurs onglets
    .accesskey = A
warn-on-open-many-tabs =
    .label = Prévenir lors de l’ouverture de multiples onglets d’un ralentissement possible de { -brand-short-name }
    .accesskey = P
switch-links-to-new-tabs =
    .label = Lors de l’ouverture d’un lien dans un nouvel onglet, basculer vers celui-ci immédiatement
    .accesskey = L
switch-to-new-tabs =
    .label = À l’ouverture d’un lien, d’une image ou d’un média dans un nouvel onglet, basculer vers celui-ci immédiatement
    .accesskey = b
show-tabs-in-taskbar =
    .label = Afficher les aperçus d’onglets dans la barre des tâches de Windows
    .accesskey = c
browser-containers-enabled =
    .label = Activer les onglets conteneurs
    .accesskey = g
browser-containers-learn-more = En savoir plus
browser-containers-settings =
    .label = Paramètres…
    .accesskey = s
containers-disable-alert-title = Fermer tous les onglets conteneurs ?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Si vous désactivez les onglets conteneurs maintenant, { $tabCount } onglet conteneur sera fermé. Voulez-vous vraiment désactiver les onglets conteneurs ?
       *[other] Si vous désactivez les onglets conteneurs maintenant, { $tabCount } onglets conteneurs seront fermés. Voulez-vous vraiment désactiver les onglets conteneurs ?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Fermer { $tabCount } onglet conteneur
       *[other] Fermer { $tabCount } onglets conteneurs
    }
containers-disable-alert-cancel-button = Garder activé
containers-remove-alert-title = Supprimer ce conteneur ?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Si vous supprimez ce conteneur maintenant, { $count } onglet conteneur sera fermé. Voulez-vous vraiment supprimer ce conteneur ?
       *[other] Si vous supprimez ce conteneur maintenant, { $count } onglets conteneurs seront fermés. Voulez-vous vraiment supprimer ce conteneur ?
    }
containers-remove-ok-button = Supprimer ce conteneur
containers-remove-cancel-button = Ne pas supprimer ce conteneur

## General Section - Language & Appearance

language-and-appearance-header = Langue et apparence
fonts-and-colors-header = Polices et couleurs
default-font = Police par défaut
    .accesskey = P
default-font-size = Taille
    .accesskey = T
advanced-fonts =
    .label = Avancé…
    .accesskey = v
colors-settings =
    .label = Couleurs…
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Zoom
preferences-default-zoom = Zoom par défaut
    .accesskey = Z
preferences-default-zoom-value =
    .label = { $percentage } %
preferences-zoom-text-only =
    .label = Agrandir uniquement le texte
    .accesskey = A
language-header = Langue
choose-language-description = Choix de la langue préférée pour l’affichage des pages
choose-button =
    .label = Choisir…
    .accesskey = o
choose-browser-language-description = Choisissez en quelle langue doivent s’afficher les menus, messages et notifications de { -brand-short-name }.
manage-browser-languages-button =
    .label = Choisir des alternatives…
    .accesskey = a
confirm-browser-language-change-description = Redémarrer { -brand-short-name } pour appliquer ces changements
confirm-browser-language-change-button = Appliquer et redémarrer
translate-web-pages =
    .label = Traduire le contenu web
    .accesskey = w
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Traductions fournies par <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Exceptions…
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Utiliser les paramètres de votre système d’exploitation en « { $localeName } » pour formater les dates, les heures, les nombres et les mesures.
check-user-spelling =
    .label = Vérifier l’orthographe pendant la saisie
    .accesskey = V

## General Section - Files and Applications

files-and-applications-title = Fichiers et applications
download-header = Téléchargements
download-save-to =
    .label = Enregistrer les fichiers dans le dossier
    .accesskey = n
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Choisir…
           *[other] Parcourir…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] P
        }
download-always-ask-where =
    .label = Toujours demander où enregistrer les fichiers
    .accesskey = T
applications-header = Applications
applications-description = Définissez le comportement de { -brand-short-name } avec les fichiers que vous téléchargez et les applications que vous utilisez lorsque vous naviguez.
applications-filter =
    .placeholder = Rechercher des types de fichiers ou d’applications
applications-type-column =
    .label = Type de contenu
    .accesskey = T
applications-action-column =
    .label = Action
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = fichier { $extension }
applications-action-save =
    .label = Enregistrer le fichier
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Utiliser { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Utiliser { $app-name } (par défaut)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Utiliser l’application par défaut de macOS
            [windows] Utiliser l’application par défaut de Windows
           *[other] Utiliser l’application par défaut du système
        }
applications-use-other =
    .label = Autre…
applications-select-helper = Choisir une application externe
applications-manage-app =
    .label = Détails de l’application…
applications-always-ask =
    .label = Toujours demander
applications-type-pdf = Portable Document Format (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Utiliser { $plugin-name } (dans { -brand-short-name })
applications-open-inapp =
    .label = Ouvrir dans { -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = Contenu protégé par des composants de gestion des droits numériques (DRM)
play-drm-content =
    .label = Lire le contenu protégé par des DRM
    .accesskey = L
play-drm-content-learn-more = En savoir plus
update-application-title = Mises à jour de { -brand-short-name }
update-application-description = Conservez { -brand-short-name } à jour pour bénéficier des dernières avancées en matière de performances, de stabilité et de sécurité.
update-application-version = Version { $version } <a data-l10n-name="learn-more">Notes de version</a>
update-history =
    .label = Afficher l’historique des mises à jour…
    .accesskey = h
update-application-allow-description = Autoriser { -brand-short-name } à
update-application-auto =
    .label = Installer les mises à jour automatiquement (recommandé)
    .accesskey = I
update-application-check-choose =
    .label = Vérifier l’existence de mises à jour, mais vous laisser décider de leur installation
    .accesskey = C
update-application-manual =
    .label = Ne jamais vérifier les mises à jour (déconseillé)
    .accesskey = N
update-application-background-enabled =
    .label = Quand { -brand-short-name } n’est pas lancé
    .accesskey = Q
update-application-warning-cross-user-setting = Ce paramètre s’appliquera à tous les comptes Windows et profils { -brand-short-name } utilisant cette installation de { -brand-short-name }.
update-application-use-service =
    .label = Utiliser un service en arrière-plan pour installer les mises à jour
    .accesskey = s
update-setting-write-failure-title = Erreur lors de l’enregistrement des préférences de mise à jour
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } a rencontré une erreur et n’a pas enregistré cette modification. Notez que modifier cette préférence de mise à jour nécessite la permission d’écriture pour le fichier ci-dessous. Vous, ou un administrateur système, pouvez peut-être corriger l’erreur en accordant au groupe Users l’accès complet à ce fichier.
    
    Écriture impossible dans le fichier : { $path }
update-setting-write-failure-title2 = Erreur lors de l’enregistrement des paramètres de mise à jour
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } a rencontré une erreur et n’a pas enregistré cette modification. Notez que modifier ce paramètre de mise à jour nécessite la permission d’écriture pour le fichier ci-dessous. Vous, ou un administrateur système, pouvez peut-être corriger l’erreur en accordant au groupe Users l’accès complet à ce fichier.
    
    Écriture impossible dans le fichier : { $path }
update-in-progress-title = Mise à jour en cours
update-in-progress-message = Voulez-vous que { -brand-short-name } continue cette mise à jour ?
update-in-progress-ok-button = &Abandonner
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Continuer

## General Section - Performance

performance-title = Performances
performance-use-recommended-settings-checkbox =
    .label = Utiliser les paramètres de performance recommandés
    .accesskey = U
performance-use-recommended-settings-desc = Ces paramètres sont adaptés à la configuration matérielle de votre ordinateur et à votre système d’exploitation.
performance-settings-learn-more = En savoir plus
performance-allow-hw-accel =
    .label = Utiliser l’accélération graphique matérielle si disponible
    .accesskey = n
performance-limit-content-process-option = Nombre maximum de processus de contenu
    .accesskey = N
performance-limit-content-process-enabled-desc = Davantage de processus de contenu peut améliorer les performances lors de l’utilisation de plusieurs onglets, cependant la consommation de mémoire sera plus importante.
performance-limit-content-process-blocked-desc = Modifier le nombre de processus de contenu est possible uniquement avec la version multiprocessus de { -brand-short-name }. <a data-l10n-name="learn-more">Apprendre à vérifier si le mode multiprocessus est activé</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (par défaut)

## General Section - Browsing

browsing-title = Navigation
browsing-use-autoscroll =
    .label = Utiliser le défilement automatique
    .accesskey = U
browsing-use-smooth-scrolling =
    .label = Utiliser le défilement doux
    .accesskey = s
browsing-use-onscreen-keyboard =
    .label = Afficher un clavier virtuel lorsque nécessaire
    .accesskey = A
browsing-use-cursor-navigation =
    .label = Toujours utiliser les touches de navigation pour se déplacer à l’intérieur d’une page
    .accesskey = T
browsing-search-on-start-typing =
    .label = Lancer la recherche lors de la saisie de texte
    .accesskey = c
browsing-picture-in-picture-toggle-enabled =
    .label = Activer les contrôles pour l’incrustation vidéo
    .accesskey = A
browsing-picture-in-picture-learn-more = En savoir plus
browsing-media-control =
    .label = Contrôler la lecture des médias via le clavier, un casque ou l’interface virtuelle
    .accesskey = C
browsing-media-control-learn-more = En savoir plus
browsing-cfr-recommendations =
    .label = Recommander des extensions en cours de navigation
    .accesskey = R
browsing-cfr-features =
    .label = Recommander des fonctionnalités en cours de navigation
    .accesskey = f
browsing-cfr-recommendations-learn-more = En savoir plus

## General Section - Proxy

network-settings-title = Paramètres réseau
network-proxy-connection-description = Configurer la façon dont { -brand-short-name } se connecte à Internet.
network-proxy-connection-learn-more = En savoir plus
network-proxy-connection-settings =
    .label = Paramètres…
    .accesskey = P

## Home Section

home-new-windows-tabs-header = Nouvelles fenêtres et nouveaux onglets
home-new-windows-tabs-description2 = Choisissez ce qui est affiché lorsque vous ouvrez votre page d’accueil, de nouvelles fenêtres ou de nouveaux onglets.

## Home Section - Home Page Customization

home-homepage-mode-label = Page d’accueil et nouvelles fenêtres
home-newtabs-mode-label = Nouveaux onglets
home-restore-defaults =
    .label = Configuration par défaut
    .accesskey = C
# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Page d’accueil de Firefox (par défaut)
home-mode-choice-custom =
    .label = Adresses web personnalisées…
home-mode-choice-blank =
    .label = Page vide
home-homepage-custom-url =
    .placeholder = Coller une adresse…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Page courante
           *[other] Pages courantes
        }
    .accesskey = U
choose-bookmark =
    .label = Marque-page…
    .accesskey = m

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Contenu de la page d’accueil de Firefox
home-prefs-content-description = Choisissez le contenu que vous souhaitez pour la page d’accueil de Firefox.
home-prefs-search-header =
    .label = Recherche web
home-prefs-topsites-header =
    .label = Sites les plus visités
home-prefs-topsites-description = Les sites que vous visitez le plus
home-prefs-topsites-by-option-sponsored =
    .label = Sites populaires sponsorisés
home-prefs-shortcuts-header =
    .label = Raccourcis
home-prefs-shortcuts-description = Sites que vous enregistrez ou visitez
home-prefs-shortcuts-by-option-sponsored =
    .label = Raccourcis sponsorisés

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Recommandations par { $provider }
home-prefs-recommended-by-description-update = Contenu exceptionnel déniché sur le Web par { $provider }
home-prefs-recommended-by-description-new = Contenu exceptionnel sélectionné par { $provider }, membre de la famille { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Mode d’emploi
home-prefs-recommended-by-option-sponsored-stories =
    .label = Articles sponsorisés
home-prefs-highlights-header =
    .label = Éléments-clés
home-prefs-highlights-description = Une sélection de sites que vous avez sauvegardés ou visités
home-prefs-highlights-option-visited-pages =
    .label = Pages visitées
home-prefs-highlights-options-bookmarks =
    .label = Marque-pages
home-prefs-highlights-option-most-recent-download =
    .label = Dernier téléchargement
home-prefs-highlights-option-saved-to-pocket =
    .label = Pages enregistrées dans { -pocket-brand-name }
home-prefs-recent-activity-header =
    .label = Activité récente
home-prefs-recent-activity-description = Une sélection de sites et de contenus récents
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Brèves
home-prefs-snippets-description = Actualité de { -vendor-short-name } et { -brand-product-name }
home-prefs-snippets-description-new = Astuces et actualité de { -vendor-short-name } et { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } ligne
           *[other] { $num } lignes
        }

## Search Section

search-bar-header = Barre de recherche
search-bar-hidden =
    .label = Utiliser la barre d’adresse pour naviguer et effectuer des recherches
search-bar-shown =
    .label = Ajouter la barre de recherche à la barre d’outils
search-engine-default-header = Moteur de recherche par défaut
search-engine-default-desc-2 = Ceci est votre moteur de recherche par défaut dans la barre d’adresse et la barre de recherche. Vous pouvez le changer à tout moment.
search-engine-default-private-desc-2 = Choisissez un autre moteur de recherche par défaut pour les fenêtres de navigation privée
search-separate-default-engine =
    .label = Utiliser ce moteur de recherche dans les fenêtres de navigation privée
    .accesskey = U
search-suggestions-header = Suggestions de recherche
search-suggestions-desc = Choisissez comment apparaîtront les suggestions des moteurs de recherche.
search-suggestions-option =
    .label = Afficher les suggestions de recherche
    .accesskey = A
search-show-suggestions-url-bar-option =
    .label = Afficher les suggestions de recherche parmi les résultats de la barre d’adresse
    .accesskey = c
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Afficher les suggestions de recherche avant l’historique de navigation dans les résultats de la barre d’adresse
search-show-suggestions-private-windows =
    .label = Afficher les suggestions de recherche dans les fenêtres de navigation privée
suggestions-addressbar-settings-generic = Modifier les préférences pour les suggestions de la barre d’adresse
suggestions-addressbar-settings-generic2 = Modifier les paramètres pour les suggestions de la barre d’adresse
search-suggestions-cant-show = Les suggestions de recherche ne seront pas affichées parmi les résultats de la barre d’adresse car vous avez configuré { -brand-short-name } de façon à ce qu’il ne conserve jamais l’historique.
search-one-click-header = Moteurs de recherche accessibles en un clic
search-one-click-header2 = Raccourcis de recherche
search-one-click-desc = Sélectionnez les moteurs de recherche alternatifs qui apparaissent sous la barre d’adresse et la barre de recherche lorsque vous commencez à saisir un mot-clé.
search-choose-engine-column =
    .label = Moteur de recherche
search-choose-keyword-column =
    .label = Mot-clé
search-restore-default =
    .label = Restaurer les moteurs de recherche par défaut
    .accesskey = R
search-remove-engine =
    .label = Supprimer
    .accesskey = S
search-add-engine =
    .label = Ajouter
    .accesskey = A
search-find-more-link = Découvrir d’autres moteurs de recherche
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Doublon de mot-clé
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Vous avez choisi un mot-clé qui est déjà utilisé par « { $name } ». Veuillez en choisir un autre.
search-keyword-warning-bookmark = Vous avez choisi un mot-clé qui est déjà utilisé par un marque-page. Veuillez en choisir un autre.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Retour aux options
           *[other] Retour aux préférences
        }
containers-back-button2 =
    .aria-label = Retour aux paramètres
containers-header = Onglets conteneurs
containers-add-button =
    .label = Ajouter un nouveau conteneur
    .accesskey = A
containers-new-tab-check =
    .label = Sélectionner un conteneur pour chaque nouvel onglet
    .accesskey = S
containers-preferences-button =
    .label = Préférences
containers-settings-button =
    .label = Paramètres
containers-remove-button =
    .label = Supprimer

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Emportez votre Web partout avec vous
sync-signedout-description = Synchronisez marque-pages, historique, onglets, mots de passe, modules complémentaires et préférences entre tous vos appareils.
sync-signedout-account-signin2 =
    .label = Se connecter à { -sync-brand-short-name }…
    .accesskey = S
sync-signedout-description2 = Synchronisez marque-pages, historique, onglets, mots de passe, modules complémentaires et paramètres entre tous vos appareils.
sync-signedout-account-signin3 =
    .label = Se connecter pour synchroniser…
    .accesskey = i
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Téléchargez Firefox pour <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> ou <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> afin de synchroniser vos données avec votre appareil mobile.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Changer la photo de profil
sync-sign-out =
    .label = Se déconnecter…
    .accesskey = d
sync-manage-account = Gérer le compte
    .accesskey = G
sync-signedin-unverified = { $email } n’est pas vérifié.
sync-signedin-login-failure = Veuillez vous identifier pour vous reconnecter via { $email }
sync-resend-verification =
    .label = Renvoyer la vérification
    .accesskey = f
sync-remove-account =
    .label = Supprimer le compte
    .accesskey = t
sync-sign-in =
    .label = Connexion
    .accesskey = x

## Sync section - enabling or disabling sync.

prefs-syncing-on = Synchronisation : ACTIVÉE
prefs-syncing-off = Synchronisation : DÉSACTIVÉE
prefs-sync-setup =
    .label = Configurer { -sync-brand-short-name }…
    .accesskey = C
prefs-sync-offer-setup-label = Synchronisez marque-pages, historique, onglets, mots de passe, modules complémentaires et préférences entre tous vos appareils.
prefs-sync-turn-on-syncing =
    .label = Activer la synchronisation…
    .accesskey = s
prefs-sync-offer-setup-label2 = Synchronisez marque-pages, historique, onglets, mots de passe, modules complémentaires et paramètres entre tous vos appareils.
prefs-sync-now =
    .labelnotsyncing = Synchroniser maintenant
    .accesskeynotsyncing = m
    .labelsyncing = Synchronisation…

## The list of things currently syncing.

sync-currently-syncing-heading = Les éléments suivants sont actuellement synchronisés :
sync-currently-syncing-bookmarks = Marque-pages
sync-currently-syncing-history = Historique
sync-currently-syncing-tabs = Onglets ouverts
sync-currently-syncing-logins-passwords = Identifiants et mots de passe
sync-currently-syncing-addresses = Adresses
sync-currently-syncing-creditcards = Cartes bancaires
sync-currently-syncing-addons = Modules complémentaires
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Options
       *[other] Préférences
    }
sync-currently-syncing-settings = Paramètres
sync-change-options =
    .label = Modifier…
    .accesskey = M

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Choisir les éléments à synchroniser
    .style = width: 38em; min-height: 35em;
    .buttonlabelaccept = Enregistrer les modifications
    .buttonaccesskeyaccept = E
    .buttonlabelextra2 = Se déconnecter…
    .buttonaccesskeyextra2 = S
sync-engine-bookmarks =
    .label = Marque-pages
    .accesskey = M
sync-engine-history =
    .label = Historique
    .accesskey = r
sync-engine-tabs =
    .label = Onglets ouverts
    .tooltiptext = Une liste de ce qui est actuellement ouvert sur tous vos appareils synchronisés
    .accesskey = O
sync-engine-logins-passwords =
    .label = Identifiants et mots de passe
    .tooltiptext = Les noms d’utilisateur et mots de passe que vous avez enregistrés
    .accesskey = d
sync-engine-addresses =
    .label = Adresses
    .tooltiptext = Les adresses postales que vous avez enregistrées (uniquement sur ordinateur)
    .accesskey = A
sync-engine-creditcards =
    .label = Cartes bancaires
    .tooltiptext = Noms, numéros et dates d’expiration (uniquement sur ordinateur)
    .accesskey = C
sync-engine-addons =
    .label = Modules complémentaires
    .tooltiptext = Extensions et thèmes pour Firefox sur ordinateur
    .accesskey = u
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Options
           *[other] Préférences
        }
    .tooltiptext = Les paramètres que vous avez modifiés dans les sections Général, Vie privée et Sécurité
    .accesskey = s
sync-engine-settings =
    .label = Paramètres
    .tooltiptext = Les paramètres que vous avez modifiés dans les sections Général, Vie privée et Sécurité
    .accesskey = s

## The device name controls.

sync-device-name-header = Nom de l’appareil
sync-device-name-change =
    .label = Changer le nom de l’appareil…
    .accesskey = h
sync-device-name-cancel =
    .label = Annuler
    .accesskey = A
sync-device-name-save =
    .label = Enregistrer
    .accesskey = E
sync-connect-another-device = Connecter un autre appareil

## Privacy Section

privacy-header = Vie privée

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Identifiants et mots de passe
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Proposer d’enregistrer les identifiants et les mots de passe pour les sites web
    .accesskey = r
forms-exceptions =
    .label = Exceptions…
    .accesskey = x
forms-generate-passwords =
    .label = Suggérer et créer des mots de passe robustes
    .accesskey = u
forms-breach-alerts =
    .label = Afficher des alertes pour les mots de passe de sites concernés par des fuites de données
    .accesskey = A
forms-breach-alerts-learn-more-link = En savoir plus
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Renseigner automatiquement les identifiants et les mots de passe
    .accesskey = R
forms-saved-logins =
    .label = Identifiants enregistrés…
    .accesskey = I
forms-master-pw-use =
    .label = Utiliser un mot de passe principal
    .accesskey = U
forms-primary-pw-use =
    .label = Utiliser un mot de passe principal
    .accesskey = U
forms-primary-pw-learn-more-link = En savoir plus
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Changer le mot de passe principal…
    .accesskey = C
forms-master-pw-fips-title = Vous êtes actuellement en mode FIPS. Ce mode nécessite un mot de passe principal non vide.
forms-primary-pw-change =
    .label = Changer le mot de passe principal…
    .accesskey = C
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Vous êtes actuellement en mode FIPS. Ce mode nécessite un mot de passe principal non vide.
forms-master-pw-fips-desc = Échec de la modification du mot de passe principal

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Pour créer un mot de passe principal, entrez vos informations de connexion Windows. Cela contribue à protéger la sécurité de vos comptes.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = créer un mot de passe principal
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Pour créer un mot de passe principal, saisissez vos informations de connexion Windows. Cela contribue à protéger la sécurité de vos comptes.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = créer un mot de passe principal
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = Historique
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = Règles de conservation
    .accesskey = R
history-remember-option-all =
    .label = Conserver l’historique
history-remember-option-never =
    .label = Ne jamais conserver l’historique
history-remember-option-custom =
    .label = Utiliser les paramètres personnalisés pour l’historique
history-remember-description = { -brand-short-name } conservera les données de navigation, les téléchargements, les formulaires et l’historique de recherche.
history-dontremember-description = { -brand-short-name } utilisera les mêmes paramètres que pour la navigation privée et ne conservera aucun historique de votre navigation.
history-private-browsing-permanent =
    .label = Toujours utiliser le mode de navigation privée
    .accesskey = i
history-remember-browser-option =
    .label = Conserver l’historique de navigation et des téléchargements
    .accesskey = C
history-remember-search-option =
    .label = Conserver l’historique des recherches et des formulaires
    .accesskey = n
history-clear-on-close-option =
    .label = Vider l’historique lors de la fermeture de { -brand-short-name }
    .accesskey = V
history-clear-on-close-settings =
    .label = Paramètres…
    .accesskey = P
history-clear-button =
    .label = Effacer l’historique…
    .accesskey = h

## Privacy Section - Site Data

sitedata-header = Cookies et données de sites
sitedata-total-size-calculating = Calcul du volume des données de sites et du cache…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Le stockage des cookies, du cache et des données de sites utilise actuellement { $value } { $unit } d’espace disque.
sitedata-learn-more = En savoir plus
sitedata-delete-on-close =
    .label = Supprimer les cookies et les données des sites à la fermeture de { -brand-short-name }
    .accesskey = S
sitedata-delete-on-close-private-browsing = En mode de navigation privée permanent, les cookies et les données de site sont toujours effacés à la fermeture de { -brand-short-name }.
sitedata-allow-cookies-option =
    .label = Accepter les cookies et les données de site
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = Bloquer les cookies et les données de site
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Type de contenu bloqué
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = Traqueurs intersites
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Traqueurs intersites et de réseaux sociaux
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Cookies de pistage intersites (inclut les cookies de réseaux sociaux)
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Cookies intersites (inclut les cookies de réseaux sociaux)
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Traqueurs intersites et de réseaux sociaux, et isoler les cookies restants
sitedata-option-block-unvisited =
    .label = Cookies de sites web non visités
sitedata-option-block-all-third-party =
    .label = Tous les cookies tiers (peut empêcher certains sites de fonctionner)
sitedata-option-block-all =
    .label = Tous les cookies (empêche certains sites de fonctionner)
sitedata-clear =
    .label = Effacer les données…
    .accesskey = E
sitedata-settings =
    .label = Gérer les données…
    .accesskey = G
sitedata-cookies-permissions =
    .label = Gérer les permissions…
    .accesskey = p
sitedata-cookies-exceptions =
    .label = Gérer les exceptions…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = Barre d’adresse
addressbar-suggest = Lors de l’utilisation de la barre d’adresse, afficher des suggestions depuis
addressbar-locbar-history-option =
    .label = L’historique de navigation
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = Les marque-pages
    .accesskey = M
addressbar-locbar-openpage-option =
    .label = Les onglets ouverts
    .accesskey = O
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = Les raccourcis
    .accesskey = R
addressbar-locbar-topsites-option =
    .label = Les sites les plus visités
    .accesskey = v
addressbar-locbar-engines-option =
    .label = Les moteurs de recherche
    .accesskey = r
addressbar-suggestions-settings = Modifier les préférences pour les suggestions de recherche

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Protection renforcée contre le pistage
content-blocking-section-top-level-description = Les traqueurs vous suivent en ligne pour collecter des informations sur vos habitudes de navigation et vos centres d’intérêt. { -brand-short-name } bloque un grand nombre de ces traqueurs et de scripts malveillants.
content-blocking-learn-more = En savoir plus
content-blocking-fpi-incompatibility-warning = Vous utilisez l’isolation First-Party (FPI) qui remplace certains paramètres des cookies de { -brand-short-name }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Standard
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = Stricte
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = Personnalisée
    .accesskey = P

##

content-blocking-etp-standard-desc = Équilibré entre protection et performances. Les pages se chargeront normalement.
content-blocking-etp-strict-desc = Protection renforcée, mais certains sites ou contenus peuvent ne pas fonctionner correctement.
content-blocking-etp-custom-desc = Choisissez les traqueurs et les scripts à bloquer.
content-blocking-etp-blocking-desc = { -brand-short-name } bloque les éléments suivants :
content-blocking-private-windows = Contenu utilisé pour le pistage dans les fenêtres de navigation privée
content-blocking-cross-site-cookies-in-all-windows = Cookies intersites dans toutes les fenêtres (inclut les cookies de pistage)
content-blocking-cross-site-tracking-cookies = Cookies de pistage intersites
content-blocking-all-cross-site-cookies-private-windows = Cookies intersites dans les fenêtres de navigation privée
content-blocking-cross-site-tracking-cookies-plus-isolate = Traqueurs intersites, et isoler les cookies restants
content-blocking-social-media-trackers = Traqueurs de réseaux sociaux
content-blocking-all-cookies = Tous les cookies
content-blocking-unvisited-cookies = Cookies de sites non visités
content-blocking-all-windows-tracking-content = Contenu utilisé pour le pistage dans toutes les fenêtres
content-blocking-all-third-party-cookies = Tous les cookies tiers
content-blocking-cryptominers = Mineurs de cryptomonnaies
content-blocking-fingerprinters = Détecteurs d’empreinte numérique
content-blocking-warning-title = Attention !
content-blocking-and-isolating-etp-warning-description = Le blocage des traqueurs et l’isolation des cookies peut avoir une incidence sur les fonctionnalités de certains sites. Actualisez une page avec des traqueurs pour charger tout le contenu.
content-blocking-and-isolating-etp-warning-description-2 = Ce paramètre peut empêcher certains sites web d’afficher du contenu ou de fonctionner correctement. Si un site semble cassé, vous pouvez désactiver la protection contre le pistage pour que ce site puisse charger tout le contenu.
content-blocking-warning-learn-how = Me montrer comment faire
content-blocking-reload-description = Vous devrez actualiser vos onglets pour appliquer ces modifications.
content-blocking-reload-tabs-button =
    .label = Actualiser tous les onglets
    .accesskey = A
content-blocking-tracking-content-label =
    .label = Contenu utilisé pour le pistage
    .accesskey = o
content-blocking-tracking-protection-option-all-windows =
    .label = Dans toutes les fenêtres
    .accesskey = t
content-blocking-option-private =
    .label = Seulement dans les fenêtres de navigation privée
    .accesskey = p
content-blocking-tracking-protection-change-block-list = Changer de liste de blocage
content-blocking-cookies-label =
    .label = Cookies
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = Plus d’informations
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Mineurs de cryptomonnaies
    .accesskey = M
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Détecteurs d’empreinte numérique
    .accesskey = e

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Gérer les exceptions…
    .accesskey = x

## Privacy Section - Permissions

permissions-header = Permissions
permissions-location = Localisation
permissions-location-settings =
    .label = Paramètres…
    .accesskey = a
permissions-xr = Réalité virtuelle
permissions-xr-settings =
    .label = Paramètres…
    .accesskey = t
permissions-camera = Caméra
permissions-camera-settings =
    .label = Paramètres…
    .accesskey = a
permissions-microphone = Microphone
permissions-microphone-settings =
    .label = Paramètres…
    .accesskey = a
permissions-notification = Notifications
permissions-notification-settings =
    .label = Paramètres…
    .accesskey = a
permissions-notification-link = En savoir plus
permissions-notification-pause =
    .label = Arrêter les notifications jusqu’au redémarrage de { -brand-short-name }
    .accesskey = n
permissions-autoplay = Lecture automatique
permissions-autoplay-settings =
    .label = Paramètres…
    .accesskey = a
permissions-block-popups =
    .label = Bloquer les fenêtres popup
    .accesskey = B
permissions-block-popups-exceptions =
    .label = Exceptions…
    .accesskey = E
permissions-addon-install-warning =
    .label = Prévenir lorsque les sites essaient d’installer des modules complémentaires
    .accesskey = P
permissions-addon-exceptions =
    .label = Exceptions…
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = Empêcher les services d’accessibilité d’avoir accès à votre navigateur
    .accesskey = a
permissions-a11y-privacy-link = En savoir plus

## Privacy Section - Data Collection

collection-header = Collecte de données par { -brand-short-name } et utilisation
collection-description = Nous nous efforçons de vous laisser le choix et de recueillir uniquement les informations dont nous avons besoin pour proposer { -brand-short-name } et l’améliorer pour tout le monde. Nous demandons toujours votre permission avant de recevoir des données personnelles.
collection-privacy-notice = Politique de confidentialité
collection-health-report-telemetry-disabled = Vous n’autorisez plus { -vendor-short-name } à capturer des données techniques et d’interaction. Toutes les données passées seront supprimées dans les 30 jours.
collection-health-report-telemetry-disabled-link = En savoir plus
collection-health-report =
    .label = Autoriser { -brand-short-name } à envoyer des données techniques et des données d’interaction à { -vendor-short-name }
    .accesskey = A
collection-health-report-link = En savoir plus
collection-studies =
    .label = Autoriser { -brand-short-name } à installer et à lancer des études
collection-studies-link = Consulter les études de { -brand-short-name }
addon-recommendations =
    .label = Autoriser { -brand-short-name } à effectuer des recommandations personnalisées d’extensions
addon-recommendations-link = En savoir plus
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = L’envoi de données est désactivé pour cette configuration de compilation
collection-backlogged-crash-reports =
    .label = Autoriser { -brand-short-name } à envoyer pour vous les rapports de plantage en attente
    .accesskey = t
collection-backlogged-crash-reports-link = En savoir plus
collection-backlogged-crash-reports-with-link = Autoriser { -brand-short-name } à envoyer des rapports de plantage en attente en votre nom <a data-l10n-name="crash-reports-link">En savoir plus</a>
    .accesskey = v

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Sécurité
security-browsing-protection = Protection contre les contenus trompeurs et les logiciels dangereux
security-enable-safe-browsing =
    .label = Bloquer les contenus dangereux ou trompeurs
    .accesskey = B
security-enable-safe-browsing-link = En savoir plus
security-block-downloads =
    .label = Bloquer les téléchargements dangereux
    .accesskey = D
security-block-uncommon-software =
    .label = Signaler la présence de logiciels indésirables ou peu communs
    .accesskey = n

## Privacy Section - Certificates

certs-header = Certificats
certs-personal-label = Lorsqu’un serveur demande votre certificat personnel
certs-select-auto-option =
    .label = En sélectionner un automatiquement
    .accesskey = E
certs-select-ask-option =
    .label = Vous demander à chaque fois
    .accesskey = V
certs-enable-ocsp =
    .label = Interroger le répondeur OCSP pour confirmer la validité de vos certificats
    .accesskey = I
certs-view =
    .label = Afficher les certificats…
    .accesskey = A
certs-devices =
    .label = Périphériques de sécurité…
    .accesskey = P
space-alert-learn-more-button =
    .label = En savoir plus
    .accesskey = E
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Ouvrir les options
           *[other] Ouvrir les préférences
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } n’a plus assez d’espace disque. Le contenu des sites web pourrait ne pas s’afficher correctement. Vous pouvez effacer les données de sites enregistrées depuis Options > Vie privée et sécurité > Cookies et données de sites.
       *[other] { -brand-short-name } n’a plus assez d’espace disque. Le contenu des sites web pourrait ne pas s’afficher correctement. Vous pouvez effacer les données de sites enregistrées depuis Préférences > Vie privée et sécurité > Cookies et données de sites.
    }
space-alert-under-5gb-ok-button =
    .label = OK
    .accesskey = K
space-alert-under-5gb-message = { -brand-short-name } n’a plus assez d’espace disque. Le contenu des sites web pourrait ne pas s’afficher correctement. Cliquez sur « En savoir plus » pour optimiser l’utilisation de votre disque et ainsi améliorer votre navigation.
space-alert-over-5gb-settings-button =
    .label = Ouvrir les paramètres
    .accesskey = O
space-alert-over-5gb-message2 = <strong>{ -brand-short-name } n’a plus assez d’espace disque.</strong> Le contenu des sites web pourrait ne pas s’afficher correctement. Vous pouvez effacer les données de sites enregistrées depuis Paramètres > Vie privée et sécurité > Cookies et données de sites.
space-alert-under-5gb-message2 = <strong>{ -brand-short-name } n’a plus assez d’espace disque.</strong> Le contenu des sites web pourrait ne pas s’afficher correctement. Cliquez sur « En savoir plus » pour optimiser l’utilisation de votre disque et ainsi améliorer votre navigation.

## Privacy Section - HTTPS-Only

httpsonly-header = Mode HTTPS uniquement
httpsonly-description = HTTPS procure une connexion sûre et chiffrée entre { -brand-short-name } et les sites web sur lesquels vous vous rendez. La plupart des sites web prennent en charge HTTPS. Si le mode HTTPS uniquement est activé, { -brand-short-name } surclassera alors toutes les connexions en HTTPS.
httpsonly-learn-more = En savoir plus
httpsonly-radio-enabled =
    .label = Activer le mode HTTPS uniquement dans toutes les fenêtres
httpsonly-radio-enabled-pbm =
    .label = Activer le mode HTTPS uniquement dans les fenêtres privées seulement
httpsonly-radio-disabled =
    .label = Ne pas activer le mode HTTPS uniquement

## The following strings are used in the Download section of settings

desktop-folder-name = Bureau
downloads-folder-name = Téléchargements
choose-download-folder-title = Choisir le dossier de téléchargement :
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Enregistrer les fichiers dans { $service-name }
