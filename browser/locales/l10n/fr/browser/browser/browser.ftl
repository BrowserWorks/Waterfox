# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Navigation privée)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Navigation privée)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox — (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (Navigation privée)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Navigation privée)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Afficher les informations du site

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Afficher le message d’installation de service
urlbar-web-notification-anchor =
    .tooltiptext = Gérer l’envoi de notifications par le site
urlbar-midi-notification-anchor =
    .tooltiptext = Ouvrir le panneau MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Gérer l’utilisation des logiciels DRM
urlbar-web-authn-anchor =
    .tooltiptext = Ouvrir le panneau d’authentification web
urlbar-canvas-notification-anchor =
    .tooltiptext = Gérer les permissions d’extraction de canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Gérer le partage du microphone avec ce site
urlbar-default-notification-anchor =
    .tooltiptext = Afficher une notification
urlbar-geolocation-notification-anchor =
    .tooltiptext = Afficher la demande de géolocalisation
urlbar-xr-notification-anchor =
    .tooltiptext = Ouvrir le panneau d’autorisations pour la réalité virtuelle
urlbar-storage-access-anchor =
    .tooltiptext = Ouvrir le panneau des permissions relatives à la navigation
urlbar-translate-notification-anchor =
    .tooltiptext = Traduire cette page
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Gérer le partage de fenêtres ou d’écran avec ce site
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Afficher le message concernant le stockage de données hors connexion
urlbar-password-notification-anchor =
    .tooltiptext = Afficher la demande d’enregistrement du mot de passe
urlbar-translated-notification-anchor =
    .tooltiptext = Gérer la traduction de la page
urlbar-plugins-notification-anchor =
    .tooltiptext = Gérer l’utilisation du plugin
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Gérer le partage de la caméra et/ou du microphone avec ce site
urlbar-autoplay-notification-anchor =
    .tooltiptext = Ouvrir le panneau de lecture automatique
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Stocker des données dans le stockage persistant
urlbar-addons-notification-anchor =
    .tooltiptext = Afficher le message d’installation du module complémentaire
urlbar-tip-help-icon =
    .title = Obtenir de l’aide
urlbar-search-tips-confirm = J’ai compris
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Suggestion :

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Écrivez moins, trouvez plus : recherchez avec { $engineName } directement depuis la barre d’adresse.
urlbar-search-tips-redirect-2 = Commencez votre recherche dans la barre d’adresse pour afficher des suggestions depuis { $engineName } et depuis votre historique de navigation.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Sélectionnez ce raccourci pour trouver plus rapidement ce dont vous avez besoin.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Marque-pages
urlbar-search-mode-tabs = Onglets
urlbar-search-mode-history = Historique

##

urlbar-geolocation-blocked =
    .tooltiptext = Vous avez empêché ce site d’accéder à vos données de géolocalisation.
urlbar-xr-blocked =
    .tooltiptext = Vous avez bloqué l’accès aux appareils de réalité virtuelle pour ce site web.
urlbar-web-notifications-blocked =
    .tooltiptext = Vous avez empêché ce site d’envoyer des notifications.
urlbar-camera-blocked =
    .tooltiptext = Vous avez empêché ce site d’accéder à votre caméra.
urlbar-microphone-blocked =
    .tooltiptext = Vous avez empêché ce site d’accéder à votre microphone.
urlbar-screen-blocked =
    .tooltiptext = Vous avez empêché ce site de partager votre écran.
urlbar-persistent-storage-blocked =
    .tooltiptext = Vous avez empêché ce site d’utiliser le stockage persistant.
urlbar-popup-blocked =
    .tooltiptext = Vous avez bloqué des popups pour ce site web.
urlbar-autoplay-media-blocked =
    .tooltiptext = Vous avez empêché ce site de lire automatiquement du contenu multimédia comportant du son.
urlbar-canvas-blocked =
    .tooltiptext = Vous avez empêché ce site d’extraire des informations de canvas.
urlbar-midi-blocked =
    .tooltiptext = Vous avez bloqué l’accès MIDI pour ce site web.
urlbar-install-blocked =
    .tooltiptext = Vous avez bloqué l’installation de modules complémentaires pour ce site web.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Modifier ce marque-page ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Marquer cette page ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Ajouter à la barre d’adresse
page-action-manage-extension =
    .label = Gérer l’extension…
page-action-remove-from-urlbar =
    .label = Retirer de la barre d’adresse
page-action-remove-extension =
    .label = Supprimer l’extension

## Page Action menu

# Variables
# $tabCount (integer) - Number of tabs selected
page-action-send-tabs-panel =
    .label =
        { $tabCount ->
            [one] Envoyer l’onglet à un appareil
           *[other] Envoyer { $tabCount } onglets à un appareil
        }
page-action-send-tabs-urlbar =
    .tooltiptext =
        { $tabCount ->
            [one] Envoyer l’onglet à un appareil
           *[other] Envoyer { $tabCount } onglets à un appareil
        }
page-action-copy-url-panel =
    .label = Copier le lien
page-action-copy-url-urlbar =
    .tooltiptext = Copier le lien
page-action-email-link-panel =
    .label = Envoyer par courriel un lien vers la page…
page-action-email-link-urlbar =
    .tooltiptext = Envoyer par courriel un lien vers la page…
page-action-share-url-panel =
    .label = Partager
page-action-share-url-urlbar =
    .tooltiptext = Partager
page-action-share-more-panel =
    .label = Plus…
page-action-send-tab-not-ready =
    .label = Synchronisation des appareils…
# "Pin" is being used as a metaphor for expressing the fact that these tabs
# are "pinned" to the left edge of the tabstrip. Really we just want the
# string to express the idea that this is a lightweight and reversible
# action that keeps your tab where you can reach it easily.
page-action-pin-tab-panel =
    .label = Épingler cet onglet
page-action-pin-tab-urlbar =
    .tooltiptext = Épingler cet onglet
page-action-unpin-tab-panel =
    .label = Désépingler cet onglet
page-action-unpin-tab-urlbar =
    .tooltiptext = Désépingler cet onglet

## Auto-hide Context Menu

full-screen-autohide =
    .label = Masquer les barres d’outils
    .accesskey = M
full-screen-exit =
    .label = Quitter le mode plein écran
    .accesskey = Q

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Pour cette fois-ci, rechercher avec :
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Paramètres de recherche
search-one-offs-change-settings-compact-button =
    .tooltiptext = Modifier les paramètres de recherche
search-one-offs-context-open-new-tab =
    .label = Rechercher dans un nouvel onglet
    .accesskey = R
search-one-offs-context-set-as-default =
    .label = Définir comme moteur de recherche par défaut
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Définir comme moteur de recherche par défaut pour les fenêtres de navigation privée
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Ajouter « { $engineName } »
    .tooltiptext = Ajouter le moteur de recherche « { $engineName } »
    .aria-label = Ajouter le moteur de recherche « { $engineName } »
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Ajouter un moteur de recherche

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Marque-pages ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Onglets ({ $restrict })
search-one-offs-history =
    .tooltiptext = Historique ({ $restrict })

## Bookmark Panel

bookmarks-add-bookmark = Ajouter un marque-page
bookmarks-edit-bookmark = Modifier le marque-page
bookmark-panel-cancel =
    .label = Annuler
    .accesskey = A
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Supprimer le marque-page
           *[other] Supprimer les { $count } marque-pages
        }
    .accesskey = S
bookmark-panel-show-editor-checkbox =
    .label = Afficher l’éditeur lors de l’enregistrement
    .accesskey = A
bookmark-panel-done-button =
    .label = Terminer
bookmark-panel-save-button =
    .label = Enregistrer
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 34em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Informations pour le site { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Sécurité de la connexion pour { $host }
identity-connection-not-secure = Connexion non sécurisée
identity-connection-secure = Connexion sécurisée
identity-connection-failure = Échec de connexion
identity-connection-internal = Cette page de { -brand-short-name } est sécurisée.
identity-connection-file = Cette page est stockée sur votre ordinateur.
identity-extension-page = Cette page a été chargée depuis une extension.
identity-active-blocked = { -brand-short-name } a bloqué des éléments non sécurisés sur cette page.
identity-custom-root = Connexion vérifiée par un émetteur de certificat non reconnu par Mozilla.
identity-passive-loaded = Des éléments de la page ne sont pas sécurisés (tels que des images).
identity-active-loaded = Vous avez désactivé la protection sur cette page.
identity-weak-encryption = Cette page utilise un faible niveau de chiffrement.
identity-insecure-login-forms = Les identifiants saisis sur cette page pourraient être compromis.
identity-permissions =
    .value = Permissions
identity-https-only-connection-upgraded = (surclassée en HTTPS)
identity-https-only-label = Mode HTTPS uniquement
identity-https-only-dropdown-on =
    .label = Activé
identity-https-only-dropdown-off =
    .label = Désactivé
identity-https-only-dropdown-off-temporarily =
    .label = Désactivé temporairement
identity-https-only-info-turn-on2 = Activez le mode « HTTPS uniquement » pour ce site si vous voulez que { -brand-short-name } sécurise la connexion lorsque c’est possible.
identity-https-only-info-turn-off2 = Si la page ne semble pas fonctionnelle, vous pouvez désactiver le mode « HTTPS uniquement » pour  ce site afin de la recharger en utilisant le protocole non sécurisé HTTP.
identity-https-only-info-no-upgrade = Impossible de sécuriser la connexion.
identity-permissions-storage-access-header = Cookies intersites
identity-permissions-storage-access-hint = Ces organismes peuvent utiliser des cookies intersites et les données du site tant que vous êtes sur ce site.
identity-permissions-storage-access-learn-more = En savoir plus
identity-permissions-reload-hint = Vous devrez peut-être actualiser la page pour que les changements prennent effet.
identity-permissions-empty = Vous n’avez pas accordé de permission particulière à ce site.
identity-clear-site-data =
    .label = Effacer les cookies et les données de sites…
identity-connection-not-secure-security-view = Votre connexion à ce site n’est pas sécurisée.
identity-connection-verified = Votre connexion à ce site est sécurisée.
identity-ev-owner-label = Certificat émis pour :
identity-description-custom-root = Mozilla ne reconnaît pas cet émetteur de certificat. Il a peut-être été ajouté à partir de votre système d’exploitation ou par un administrateur. <label data-l10n-name="link">En savoir plus</label>
identity-remove-cert-exception =
    .label = Supprimer l’exception
    .accesskey = S
identity-description-insecure = Votre connexion à ce site n’est pas privée. Les informations que vous transmettez peuvent être visualisées par d’autres personnes (comme par exemple les mots de passe, les messages, les cartes bancaires, etc.).
identity-description-insecure-login-forms = Les informations d’identification que vous saisissez sur cette page ne sont pas sécurisées et pourraient être compromises.
identity-description-weak-cipher-intro = Votre connexion à ce site web n’est pas privée et utilise un faible niveau de chiffrement.
identity-description-weak-cipher-risk = D’autres personnes peuvent accéder à vos informations ou modifier le comportement du site web.
identity-description-active-blocked = { -brand-short-name } a bloqué des éléments non sécurisés sur cette page. <label data-l10n-name="link">En savoir plus</label>
identity-description-passive-loaded = Votre connexion n’est pas privée et les informations que vous partagez avec ce site peuvent être visualisées par d’autres personnes.
identity-description-passive-loaded-insecure = Ce site web possède du contenu non sécurisé (tel que des images). <label data-l10n-name="link">En savoir plus</label>
identity-description-passive-loaded-mixed = Bien que { -brand-short-name } ait bloqué du contenu, il reste néanmoins des éléments non sécurisés sur la page (tels que des images). <label data-l10n-name="link">En savoir plus</label>
identity-description-active-loaded = Ce site web possède du contenu non sécurisé (tel que des scripts) et la connexion établie n’est pas privée.
identity-description-active-loaded-insecure = Les informations que vous partagez avec ce site peuvent être visualisées par d’autres personnes (comme par exemple les mots de passe, les messages, les cartes bancaires, etc.).
identity-learn-more =
    .value = En savoir plus
identity-disable-mixed-content-blocking =
    .label = Désactiver la protection pour l’instant
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Activer la protection
    .accesskey = A
identity-more-info-link-text =
    .label = Plus d’informations

## Window controls

browser-window-minimize-button =
    .tooltiptext = Réduire
browser-window-maximize-button =
    .tooltiptext = Agrandir
browser-window-restore-down-button =
    .tooltiptext = Restaurer
browser-window-close-button =
    .tooltiptext = Fermer

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = LECTURE EN COURS
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = MUET
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = LECTURE AUTOMATIQUE BLOQUÉE
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = INCRUSTATION VIDÉO

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] COUPER LE SON DE L’ONGLET
        [one] COUPER LE SON DE L’ONGLET
       *[other] COUPER LE SON DE { $count } ONGLETS
    }
browser-tab-unmute =
    { $count ->
        [1] RÉACTIVER LE SON DE L’ONGLET
        [one] RÉACTIVER LE SON DE L’ONGLET
       *[other] RÉACTIVER LE SON DE { $count } ONGLETS
    }
browser-tab-unblock =
    { $count ->
        [1] LANCER LA LECTURE DE L’ONGLET
        [one] LANCER LA LECTURE DE L’ONGLET
       *[other] LANCER LA LECTURE DE { $count } ONGLETS
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Importer les marque-pages…
    .tooltiptext = Importer les marque-pages d’un autre navigateur dans { -brand-short-name }.
bookmarks-toolbar-empty-message = Pour un accès rapide, placez vos marque-pages ici, sur la barre personnelle. <a data-l10n-name="manage-bookmarks">Gérer vos marque-pages…</a>

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Caméra à partager :
    .accesskey = C
popup-select-microphone =
    .value = Microphone à partager :
    .accesskey = M
popup-select-camera-device =
    .value = Caméra :
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = Caméra
popup-select-microphone-device =
    .value = Microphone :
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Microphone
popup-select-speaker-icon =
    .tooltiptext = Haut-parleurs
popup-all-windows-shared = L’ensemble des fenêtres visibles sur votre écran seront partagées.
popup-screen-sharing-not-now =
    .label = Plus tard
    .accesskey = P
popup-screen-sharing-never =
    .label = Ne jamais autoriser
    .accesskey = N
popup-silence-notifications-checkbox = Désactiver les notifications de { -brand-short-name } pendant le partage
popup-silence-notifications-checkbox-warning = { -brand-short-name } n’affichera pas de notifications pendant le partage.
popup-screen-sharing-block =
    .label = Bloquer
    .accesskey = B
popup-screen-sharing-always-block =
    .label = Toujours bloquer
    .accesskey = T
popup-mute-notifications-checkbox = Désactiver les notifications du site web lors du partage

## WebRTC window or screen share tab switch warning

sharing-warning-window = Vous partagez { -brand-short-name }. D’autres personnes peuvent voir lorsque vous changez d’onglet.
sharing-warning-screen = Vous partagez votre écran. D’autres personnes peuvent voir quand vous changez d’onglet.
sharing-warning-proceed-to-tab =
    .label = Passer à l’onglet
sharing-warning-disable-for-session =
    .label = Désactiver la protection de partage pour cette session

## DevTools F12 popup

enable-devtools-popup-description = Pour utiliser le raccourci F12, ouvrez d’abord les outils de développement via le menu Développement web.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Saisir un terme à rechercher ou une adresse
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Saisir un terme à rechercher ou une adresse
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Rechercher sur le Web
    .aria-label = Rechercher avec { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Saisissez les termes à rechercher
    .aria-label = Rechercher sur { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Saisissez les termes à rechercher
    .aria-label = Rechercher dans les marque-pages
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Saisissez les termes à rechercher
    .aria-label = Rechercher dans l’historique
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Saisissez les termes à rechercher
    .aria-label = Rechercher dans les onglets
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Rechercher avec { $name } ou saisir une adresse
urlbar-remote-control-notification-anchor =
    .tooltiptext = Le navigateur est contrôlé à distance
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Le navigateur est sous contrôle à distance (raison : { $component })
urlbar-permissions-granted =
    .tooltiptext = Vous avez accordé des permissions supplémentaires à ce site web.
urlbar-switch-to-tab =
    .value = Aller à l’onglet :
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Extension :
urlbar-go-button =
    .tooltiptext = Se rendre à la page indiquée dans la barre d’adresse
urlbar-page-action-button =
    .tooltiptext = Actions pour la page
urlbar-pocket-button =
    .tooltiptext = Enregistrer dans { -pocket-brand-name }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Rechercher avec { $engine } dans une fenêtre de navigation privée
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Rechercher dans une fenêtre de navigation privée
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Rechercher avec { $engine }
urlbar-result-action-sponsored = Sponsorisé
urlbar-result-action-switch-tab = Aller à l’onglet
urlbar-result-action-visit = Consulter
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Appuyez sur Tab pour rechercher sur { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Appuyez sur Tab pour rechercher sur { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Rechercher avec { $engine } directement depuis la barre d’adresse
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Recherche { $engine } directement depuis la barre d’adresse
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Copier
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Rechercher dans les marque-pages
urlbar-result-action-search-history = Rechercher dans l’historique
urlbar-result-action-search-tabs = Rechercher dans les onglets

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> est désormais en plein écran
fullscreen-warning-no-domain = Ce document est désormais en plein écran
fullscreen-exit-button = Quitter le mode plein écran (Échap)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Quitter le mode plein écran (« esc »)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> contrôle votre pointeur. Appuyez sur Échap pour reprendre le contrôle.
pointerlock-warning-no-domain = Ce document contrôle votre pointeur. Appuyez sur Échap pour reprendre le contrôle.

## Subframe crash notification

crashed-subframe-message = <strong>Une partie de cette page a planté.</strong> Pour informer { -brand-product-name } de ce problème et le résoudre plus rapidement, veuillez envoyer un rapport.
crashed-subframe-learnmore-link =
    .value = En savoir plus
crashed-subframe-submit =
    .label = Envoyer un rapport
    .accesskey = r

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Organiser les marque-pages
bookmarks-recent-bookmarks-panel-subheader = Marque-pages récents
bookmarks-toolbar-chevron =
    .tooltiptext = Afficher plus de marque-pages
bookmarks-sidebar-content =
    .aria-label = Marque-pages
bookmarks-menu-button =
    .label = Menu des marque-pages
bookmarks-other-bookmarks-menu =
    .label = Autres marque-pages
bookmarks-mobile-bookmarks-menu =
    .label = Marque-pages des appareils mobiles
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Masquer le panneau des marque-pages
           *[other] Afficher le panneau des marque-pages
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Masquer la barre personnelle
           *[other] Afficher la barre personnelle
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Masquer la barre personnelle
           *[other] Afficher la barre personnelle
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Retirer le menu de la barre personnelle
           *[other] Ajouter le menu à la barre d’outils
        }
bookmarks-search =
    .label = Rechercher dans les marque-pages
bookmarks-tools =
    .label = Outils de marque-pages
bookmarks-bookmark-edit-panel =
    .label = Modifier ce marque-page
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Barre personnelle
    .accesskey = B
    .aria-label = Marque-pages
bookmarks-toolbar-menu =
    .label = Barre personnelle
bookmarks-toolbar-placeholder =
    .title = Éléments de la barre personnelle
bookmarks-toolbar-placeholder-button =
    .label = Éléments de la barre personnelle
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = Marquer l’onglet courant

## Library Panel items

library-bookmarks-menu =
    .label = Marque-pages
library-recent-activity-title =
    .value = Activité récente

## Pocket toolbar button

save-to-pocket-button =
    .label = Enregistrer dans { -pocket-brand-name }
    .tooltiptext = Enregistrer dans { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Réparer l’encodage du texte
    .tooltiptext = Détermine l’encodage correct du texte depuis le contenu de la page

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = Extensions et thèmes
    .tooltiptext = Gérer vos extensions et thèmes ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Paramètres
    .tooltiptext =
        { PLATFORM() ->
            [macos] Ouvrir les paramètres ({ $shortcut })
           *[other] Ouvrir les paramètres
        }

## More items

more-menu-go-offline =
    .label = Travailler hors connexion
    .accesskey = x

## EME notification panel

eme-notifications-drm-content-playing = De l’audio ou de la vidéo sur ce site utilise des DRM, ce qui peut limiter les actions que vous permet { -brand-short-name } sur ces éléments.
eme-notifications-drm-content-playing-manage = Gérer les paramètres
eme-notifications-drm-content-playing-manage-accesskey = m
eme-notifications-drm-content-playing-dismiss = Ignorer
eme-notifications-drm-content-playing-dismiss-accesskey = n

## Password save/update panel

panel-save-update-username = Nom d’utilisateur
panel-save-update-password = Mot de passe

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Supprimer { $name } ?
addon-removal-abuse-report-checkbox = Signaler cette extension à { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = Gestion du compte
remote-tabs-sync-now = Synchroniser maintenant
