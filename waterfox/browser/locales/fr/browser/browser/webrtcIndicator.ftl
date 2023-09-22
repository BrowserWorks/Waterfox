# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - Indicateur de partage
webrtc-indicator-window =
    .title = { -brand-short-name } - Indicateur de partage

## Used as list items in sharing menu

webrtc-item-camera = caméra
webrtc-item-microphone = microphone
webrtc-item-audio-capture = audio de l’onglet
webrtc-item-application = application
webrtc-item-screen = écran
webrtc-item-window = fenêtre
webrtc-item-browser = onglet

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Source inconnue

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Onglets partageant des périphériques
    .accesskey = d

webrtc-sharing-window = Vous partagez une autre fenêtre d’application.
webrtc-sharing-browser-window = Vous partagez { -brand-short-name }.
webrtc-sharing-screen = Vous partagez tout votre écran.
webrtc-stop-sharing-button = Arrêter le partage
webrtc-microphone-unmuted =
    .title = Désactiver le microphone
webrtc-microphone-muted =
    .title = Activer le microphone
webrtc-camera-unmuted =
    .title = Désactiver la caméra
webrtc-camera-muted =
    .title = Activer la caméra
webrtc-minimize =
    .title = Réduire l’indicateur

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Vous partagez votre caméra. Cliquez pour contrôler le partage.
webrtc-microphone-system-menu =
    .label = Vous partagez votre microphone. Cliquez pour contrôler le partage.
webrtc-screen-system-menu =
    .label = Vous partagez une fenêtre ou un écran. Cliquez pour contrôler le partage.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Votre caméra et votre microphone sont partagés. Cliquer pour contrôler le partage.
webrtc-indicator-sharing-camera =
    .tooltiptext = Votre caméra est partagée. Cliquer pour contrôler le partage.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Votre microphone est partagé. Cliquer pour contrôler le partage.
webrtc-indicator-sharing-application =
    .tooltiptext = Une application est partagée. Cliquer pour contrôler le partage.
webrtc-indicator-sharing-screen =
    .tooltiptext = Votre écran est partagé. Cliquer pour contrôler le partage.
webrtc-indicator-sharing-window =
    .tooltiptext = Une fenêtre est partagée. Cliquer pour contrôler le partage.
webrtc-indicator-sharing-browser =
    .tooltiptext = Un onglet est partagé. Cliquer pour contrôler le partage.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Contrôler le partage
webrtc-indicator-menuitem-control-sharing-on =
    .label = Contrôler le partage avec « { $streamTitle } »

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Caméra partagée avec « { $streamTitle } »
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Caméra partagée avec { $tabCount } onglet
           *[other] Caméra partagée avec { $tabCount } onglets
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Microphone partagé avec « { $streamTitle } »
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Microphone partagé avec { $tabCount } onglet
           *[other] Microphone partagé avec { $tabCount } onglets
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Application partagée avec « { $streamTitle } »
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Application partagée avec { $tabCount } onglet
           *[other] Applications partagées avec { $tabCount } onglets
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Écran partagé avec « { $streamTitle } »
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Écran partagé avec { $tabCount } onglet
           *[other] Écran partagé avec { $tabCount } onglets
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Fenêtre partagée avec « { $streamTitle } »
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Fenêtre partagée avec { $tabCount } onglet
           *[other] Fenêtres partagées avec { $tabCount } onglets
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Onglet partagé avec « { $streamTitle } »
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Onglet partagé avec { $tabCount } onglet
           *[other] Onglets partagés avec { $tabCount } onglets
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Autoriser { $origin } à écouter le son de cet onglet ?
webrtc-allow-share-camera = Autoriser { $origin } à utiliser votre caméra ?
webrtc-allow-share-microphone = Autoriser { $origin } à utiliser votre microphone ?
webrtc-allow-share-screen = Autoriser { $origin } à voir votre écran ?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Autoriser { $origin } à utiliser d’autres haut-parleurs ?
webrtc-allow-share-camera-and-microphone = Autoriser { $origin } à utiliser votre caméra et votre microphone ?
webrtc-allow-share-camera-and-audio-capture = Autoriser { $origin } à utiliser votre caméra et à écouter le son de cet onglet ?
webrtc-allow-share-screen-and-microphone = Autoriser { $origin } à utiliser votre microphone et à voir votre écran ?
webrtc-allow-share-screen-and-audio-capture = Autoriser { $origin } à écouter le son de cet onglet et à voir votre écran ?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Autoriser { $origin } à donner à { $thirdParty } la permission d’écouter le son de cet onglet ?
webrtc-allow-share-camera-unsafe-delegation = Autoriser { $origin } à donner à { $thirdParty } l’accès à votre caméra ?
webrtc-allow-share-microphone-unsafe-delegation = Autoriser { $origin } à donner à { $thirdParty } l’accès à votre microphone ?
webrtc-allow-share-screen-unsafe-delegation = Autoriser { $origin } à donner à { $thirdParty } la permission de voir votre écran ?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Autoriser { $origin } à donner à { $thirdParty } l’accès à d’autres haut-parleurs ?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Autoriser { $origin } à donner à { $thirdParty } l’accès à votre caméra et votre microphone ?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Autoriser { $origin } à donner à { $thirdParty } l’accès à votre caméra et à écouter le son de cet onglet ?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Autoriser { $origin } à donner à { $thirdParty } l’accès à votre microphone et à voir votre écran ?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Autoriser { $origin } à donner à { $thirdParty } la permission d’écouter le son de cet onglet et de voir votre écran ?

##

webrtc-share-screen-warning = Partagez uniquement vos écrans avec les sites auxquels vous faites confiance. Le partage peut permettre à des sites trompeurs de naviguer en votre nom et de dérober des informations.
webrtc-share-browser-warning = Partagez uniquement { -brand-short-name } avec les sites auxquels vous faites confiance. Le partage peut permettre à des sites trompeurs de naviguer en votre nom et de dérober des informations.

webrtc-share-screen-learn-more = En savoir plus
webrtc-pick-window-or-screen = Sélectionnez une fenêtre ou un écran
webrtc-share-entire-screen = Écran entier
webrtc-share-pipe-wire-portal = Utiliser les paramètres du système d’exploitation
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Écran { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] { $appName } ({ $windowCount } fenêtre)
       *[other] { $appName } ({ $windowCount } fenêtres)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Autoriser
    .accesskey = A
webrtc-action-block =
    .label = Bloquer
    .accesskey = B
webrtc-action-always-block =
    .label = Toujours bloquer
    .accesskey = T
webrtc-action-not-now =
    .label = Plus tard
    .accesskey = P

##

webrtc-remember-allow-checkbox = Se souvenir de cette décision
webrtc-mute-notifications-checkbox = Désactiver les notifications du site web lors du partage

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } ne peut pas accorder un accès permanent à votre écran.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } ne peut pas accorder un accès permanent à l’audio d’un onglet sans demander quel onglet partager.
webrtc-reason-for-no-permanent-allow-insecure = La connexion à ce site n’est pas sécurisée. Pour des raisons de sécurité, { -brand-short-name } n’accordera l’accès que pour cette session.
