# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

# This string is used so that the window has a title in tools that enumerate/look for window
# titles. It is not normally visible anywhere.
webrtc-indicator-title = { -brand-short-name } – Indicatore condivisione

webrtc-indicator-window =
    .title = { -brand-short-name } – Indicatore condivisione

## Used as list items in sharing menu

webrtc-item-camera = fotocamera
webrtc-item-microphone = microfono
webrtc-item-audio-capture = audio scheda
webrtc-item-application = applicazione
webrtc-item-screen = schermo
webrtc-item-window = finestra
webrtc-item-browser = scheda

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Origine sconosciuta

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Schede che condividono dispositivi
    .accesskey = S

webrtc-sharing-window = Stai condividendo la finestra di un’altra applicazione.
webrtc-sharing-browser-window = Stai condividendo { -brand-short-name }.
webrtc-sharing-screen = Stai condividendo l’intero schermo.
webrtc-stop-sharing-button = Interrompi condivisione
webrtc-microphone-unmuted =
    .title = Disattiva microfono
webrtc-microphone-muted =
    .title = Attiva microfono
webrtc-camera-unmuted =
    .title = Disattiva fotocamera
webrtc-camera-muted =
    .title = Attiva fotocamera
webrtc-minimize =
    .title = Riduci a icona l’indicatore

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

# This string will display as a tooltip on supported systems where we show
# device sharing state in the OS notification area. We do not use these strings
# on macOS, as global menu bar items do not have native tooltips.
webrtc-camera-system-menu =
    .label = Stai condividendo la fotocamera. Fai clic per gestire la condivisione.
webrtc-microphone-system-menu =
    .label = Stai condividendo il microfono. Fai clic per gestire la condivisione.
webrtc-screen-system-menu =
    .label = Stai condividendo una finestra o lo schermo. Fai clic per gestire la condivisione.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = La fotocamera e il microfono sono condivisi. Fare clic per gestire la condivisione.
webrtc-indicator-sharing-camera =
    .tooltiptext = La fotocamera è condivisa. Fare clic per gestire la condivisione.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Il microfono è condiviso. Fare clic per gestire la condivisione.
webrtc-indicator-sharing-application =
    .tooltiptext = Un’applicazione è condivisa. Fare clic per gestire la condivisione.
webrtc-indicator-sharing-screen =
    .tooltiptext = Lo schermo è condiviso. Fare clic per gestire la condivisione.
webrtc-indicator-sharing-window =
    .tooltiptext = Una finestra è condivisa. Fare clic per gestire la condivisione.
webrtc-indicator-sharing-browser =
    .tooltiptext = Una scheda è condivisa. Fare clic per gestire la condivisione.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Gestisci condivisione
webrtc-indicator-menuitem-control-sharing-on =
    .label = Gestisci condivisione con “{ $streamTitle }”

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Fotocamera condivisa con “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Fotocamera condivisa con { $tabCount } scheda
           *[other] Fotocamera condivisa con { $tabCount } schede
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Microfono condiviso con “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Microfono condiviso con { $tabCount } scheda
           *[other] Microfono condiviso con { $tabCount } schede
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Applicazione condivisa con “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Applicazione condivisa con { $tabCount } scheda
           *[other] Applicazione condivisa con { $tabCount } schede
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Schermo condiviso con “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Schermo condiviso con { $tabCount } scheda
           *[other] Schermo condiviso con { $tabCount } schede
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Finestra condivisa con “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Finestra condivisa con { $tabCount } scheda
           *[other] Finestra condivisa con { $tabCount } schede
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Scheda condivisa con “{ $streamTitle }”
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Scheda condivisa con { $tabCount } scheda
           *[other] Scheda condivisa con { $tabCount } schede
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Consentire a { $origin } di ascoltare l’audio di questa scheda?
webrtc-allow-share-camera = Consentire a { $origin } di utilizzare la fotocamera?
webrtc-allow-share-microphone = Consentire a { $origin } di utilizzare il microfono?
webrtc-allow-share-screen = Consentire a { $origin } di visualizzare lo schermo?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Consentire a { $origin } di utilizzare altri altoparlanti?
webrtc-allow-share-camera-and-microphone = Consentire a { $origin } di utilizzare la fotocamera e il microfono?
webrtc-allow-share-camera-and-audio-capture = Consentire a { $origin } di utilizzare la fotocamera e ascoltare l’audio di questa scheda?
webrtc-allow-share-screen-and-microphone = Consentire a { $origin } di utilizzare il microfono e visualizzare lo schermo?
webrtc-allow-share-screen-and-audio-capture = Consentire a { $origin } di ascoltare l’audio di questa scheda e visualizzare lo schermo?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Consentire a { $origin } di garantire a { $thirdParty } il permesso di ascoltare l’audio di questa scheda?
webrtc-allow-share-camera-unsafe-delegation = Consentire a { $origin } di garantire a { $thirdParty } il permesso di utilizzare la fotocamera?
webrtc-allow-share-microphone-unsafe-delegation = Consentire a { $origin } di garantire a { $thirdParty } il permesso di utilizzare il microfono?
webrtc-allow-share-screen-unsafe-delegation = Consentire a { $origin } di garantire a { $thirdParty } il permesso di visualizzare lo schermo?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Consentire a { $origin } di garantire a { $thirdParty } accesso ad altri altoparlanti?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Consentire a { $origin } di garantire a { $thirdParty } il permesso di utilizzare la fotocamera e il microfono?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Consentire a { $origin } di garantire a { $thirdParty } il permesso di utilizzare la fotocamera e ascoltare l’audio di questa scheda?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Consentire a { $origin } di garantire a { $thirdParty } il permesso di utilizzare il microfono e visualizzare lo schermo?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Consentire a { $origin } di garantire a { $thirdParty } il permesso di ascoltare l’audio di questa scheda e visualizzare lo schermo?

##

webrtc-share-screen-warning = Condividere lo schermo solo con siti affidabili. La condivisione può consentire a siti ingannevoli di navigare impersonando l’utente e sottrarne i dati personali.
webrtc-share-browser-warning = Condividere { -brand-short-name } solo con siti affidabili. La condivisione può consentire a siti ingannevoli di navigare impersonando l’utente e sottrarne i dati personali.

webrtc-share-screen-learn-more = Ulteriori informazioni
webrtc-pick-window-or-screen = Scegli finestra o schermo
webrtc-share-entire-screen = Schermo intero
webrtc-share-pipe-wire-portal = Usa le impostazioni del sistema operativo
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Schermo { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] { $appName } ({ $windowCount } finestra)
       *[other] { $appName } ({ $windowCount } finestre)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Consenti
    .accesskey = C
webrtc-action-block =
    .label = Blocca
    .accesskey = B
webrtc-action-always-block =
    .label = Blocca sempre
    .accesskey = s
webrtc-action-not-now =
    .label = Non adesso
    .accesskey = N

##

webrtc-remember-allow-checkbox = Ricorda questa scelta
webrtc-mute-notifications-checkbox = Disattiva notifiche dai siti web durante la condivisione

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } non è in grado di consentire accesso in modo permanente allo schermo.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } non è in grado di consentire accesso in modo permanente all’audio della scheda senza chiedere quale scheda condividere.
webrtc-reason-for-no-permanent-allow-insecure = La connessione con il sito non è sicura. Per motivi di sicurezza { -brand-short-name } consentirà l’accesso solo per questa sessione.
