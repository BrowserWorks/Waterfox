# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = Téléchargement de la mise à jour de { -brand-shorter-name }
appmenuitem-banner-update-available =
    .label = Mise à jour disponible — télécharger maintenant
appmenuitem-banner-update-manual =
    .label = Mise à jour disponible — télécharger maintenant
appmenuitem-banner-update-unsupported =
    .label = Mise à jour impossible — système incompatible
appmenuitem-banner-update-restart =
    .label = Mise à jour disponible — redémarrer maintenant
appmenuitem-new-tab =
    .label = Nouvel onglet
appmenuitem-new-window =
    .label = Nouvelle fenêtre
appmenuitem-new-private-window =
    .label = Nouvelle fenêtre privée
appmenuitem-history =
    .label = Historique
appmenuitem-downloads =
    .label = Téléchargements
appmenuitem-passwords =
    .label = Mots de passe
appmenuitem-addons-and-themes =
    .label = Extensions et thèmes
appmenuitem-print =
    .label = Imprimer…
appmenuitem-find-in-page =
    .label = Rechercher dans la page…
appmenuitem-zoom =
    .value = Zoom
appmenuitem-more-tools =
    .label = Outils supplémentaires
appmenuitem-help =
    .label = Aide
appmenuitem-exit2 =
    .label = Quitter
appmenu-menu-button-closed2 =
    .tooltiptext = Ouvrir le menu de l’application
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Fermer le menu de l’application
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Paramètres

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Zoom avant
appmenuitem-zoom-reduce =
    .label = Zoom arrière
appmenuitem-fullscreen =
    .label = Plein écran

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Se connecter pour synchroniser…
appmenu-remote-tabs-turn-on-sync =
    .label = Activer la synchronisation…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Afficher davantage d’onglets
    .tooltiptext = Afficher plus d’onglets de cet appareil
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Aucun onglet ouvert
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Activez la synchronisation des onglets pour afficher la liste des onglets de vos autres appareils.
appmenu-remote-tabs-opensettings =
    .label = Paramètres
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Vous souhaitez afficher ici les onglets de vos autres appareils ?
appmenu-remote-tabs-connectdevice =
    .label = Connecter un autre appareil
appmenu-remote-tabs-welcome = Afficher la liste des onglets de vos autres appareils.
appmenu-remote-tabs-unverified = Votre compte doit être vérifié.
appmenuitem-fxa-toolbar-sync-now2 = Synchroniser maintenant
appmenuitem-fxa-sign-in = Se connecter à { -brand-product-name }
appmenuitem-fxa-manage-account = Gestion du compte
appmenu-fxa-header2 = { -fxaccount-brand-name(capitalization: "uppercase") }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Dernière synchronisation { $time }
    .label = Dernière synchronisation { $time }
appmenu-fxa-sync-and-save-data2 = Synchroniser et enregistrer les données
appmenu-fxa-signed-in-label = Connexion
appmenu-fxa-setup-sync =
    .label = Activer la synchronisation…
appmenuitem-save-page =
    .label = Enregistrer sous…

## What's New panel in App menu.

whatsnew-panel-header = Nouveautés
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = M’avertir des nouvelles fonctionnalités
    .accesskey = M

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Profileur
    .tooltiptext = Enregistrer un profil de performance
profiler-popup-button-recording =
    .label = Profileur
    .tooltiptext = Enregistrement d’un profil en cours
profiler-popup-button-capturing =
    .label = Profileur
    .tooltiptext = Capture d’un profil en cours
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Afficher plus d’informations
profiler-popup-description-title =
    .value = Enregistrer, analyser, partager
profiler-popup-description = Collaborez sur les problèmes de performance en publiant des profils à partager avec votre équipe.
profiler-popup-learn-more-button =
    .label = En savoir plus
profiler-popup-settings =
    .value = Paramètres
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Modifier les paramètres…
profiler-popup-recording-screen = Enregistrement…
profiler-popup-start-recording-button =
    .label = Commencer l’enregistrement
profiler-popup-discard-button =
    .label = Abandonner
profiler-popup-capture-button =
    .label = Capturer
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Maj+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Maj+2
    }

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = Réglage recommandé pour le débogage de la plupart des applications web, avec une surcharge faible.
profiler-popup-presets-web-developer-label =
    .label = Développement web
profiler-popup-presets-firefox-description = Réglage recommandé pour le profilage de { -brand-shorter-name }.
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }
profiler-popup-presets-graphics-description = Réglage conçu pour examiner les bugs graphiques dans { -brand-shorter-name }.
profiler-popup-presets-graphics-label =
    .label = Accélération graphique
profiler-popup-presets-media-description2 = Réglage conçu pour examiner les bugs audio et vidéo dans { -brand-shorter-name }.
profiler-popup-presets-media-label =
    .label = Multimédia
profiler-popup-presets-networking-description = Réglage conçu pour examiner les bugs réseau dans { -brand-shorter-name }.
profiler-popup-presets-networking-label =
    .label = Réseau
profiler-popup-presets-power-description = Réglage conçu pour examiner les bugs liés à la consommation d’énergie dans { -brand-shorter-name }, avec une surcharge faible.
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = Énergie
profiler-popup-presets-custom-label =
    .label = Personnalisés

## History panel

appmenu-manage-history =
    .label = Gérer l’historique
appmenu-reopen-all-tabs = Rouvrir tous les onglets
appmenu-reopen-all-windows = Rouvrir toutes les fenêtres
appmenu-restore-session =
    .label = Restaurer la session précédente
appmenu-clear-history =
    .label = Effacer l’historique récent…
appmenu-recent-history-subheader = Historique récent
appmenu-recently-closed-tabs =
    .label = Onglets récemment fermés
appmenu-recently-closed-windows =
    .label = Fenêtres récemment fermées

## Help panel

appmenu-help-header =
    .title = Aide de { -brand-shorter-name }
appmenu-about =
    .label = À propos de { -brand-shorter-name }
    .accesskey = p
appmenu-get-help =
    .label = Obtenir de l’aide
    .accesskey = O
appmenu-help-more-troubleshooting-info =
    .label = Plus d’informations de dépannage
    .accesskey = t
appmenu-help-report-site-issue =
    .label = Signaler un problème sur ce site…
appmenu-help-share-ideas =
    .label = Partager des idées et des commentaires…
    .accesskey = P

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Mode de dépannage…
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = Désactiver le mode de dépannage
    .accesskey = m

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Signaler un site trompeur…
    .accesskey = t
appmenu-help-not-deceptive =
    .label = Ce site n’est pas trompeur…
    .accesskey = C

## More Tools

appmenu-customizetoolbar =
    .label = Personnaliser la barre d’outils…
appmenu-developer-tools-subheader = Outils du navigateur
appmenu-developer-tools-extensions =
    .label = Extensions de développement
