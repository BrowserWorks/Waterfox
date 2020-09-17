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
# "private" - "Mozilla Firefox - (Private Browsing)"
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

## Auto-hide Context Menu

full-screen-autohide =
    .label = Masquer les barres d’outils
    .accesskey = M
full-screen-exit =
    .label = Quitter le mode plein écran
    .accesskey = Q

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
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

bookmark-panel-show-editor-checkbox =
    .label = Afficher l’éditeur lors de l’enregistrement
    .accesskey = A
bookmark-panel-done-button =
    .label = Terminer
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 34em

## Identity Panel

identity-connection-not-secure = Connexion non sécurisée
identity-connection-secure = Connexion sécurisée
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

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Caméra à partager :
    .accesskey = C
popup-select-microphone =
    .value = Microphone à partager :
    .accesskey = M
popup-all-windows-shared = L’ensemble des fenêtres visibles sur votre écran seront partagées.
popup-screen-sharing-not-now =
    .label = Plus tard
    .accesskey = P
popup-screen-sharing-never =
    .label = Ne jamais autoriser
    .accesskey = N
popup-silence-notifications-checkbox = Désactiver les notifications de { -brand-short-name } pendant le partage
popup-silence-notifications-checkbox-warning = { -brand-short-name } n’affichera pas de notifications pendant le partage.

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
