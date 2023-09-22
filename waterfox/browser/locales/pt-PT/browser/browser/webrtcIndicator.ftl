# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - Indicador de partilha
webrtc-indicator-window =
    .title = { -brand-short-name } - Indicador de partilha

## Used as list items in sharing menu

webrtc-item-camera = câmara
webrtc-item-microphone = microfone
webrtc-item-audio-capture = áudio
webrtc-item-application = aplicação
webrtc-item-screen = ecrã
webrtc-item-window = janela
webrtc-item-browser = separador

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Origem desconhecida

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Separadores de partilha de dispositivos
    .accesskey = d

webrtc-sharing-window = Está a partilhar uma janela de outra aplicação
webrtc-sharing-browser-window = Está a partilhar o { -brand-short-name }.
webrtc-sharing-screen = Está a partilhar a totalidade do seu ecrã.
webrtc-stop-sharing-button = Parar de partilhar
webrtc-microphone-unmuted =
    .title = Desligar o microfone
webrtc-microphone-muted =
    .title = Ligar o microfone
webrtc-camera-unmuted =
    .title = Desligar a câmara
webrtc-camera-muted =
    .title = Ligar a câmara
webrtc-minimize =
    .title = Minimizar indicador

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Está a partilhar a sua câmara. Clique para controlar a partilha.
webrtc-microphone-system-menu =
    .label = Está a partilhar o seu microfone. Clique para controlar a partilha.
webrtc-screen-system-menu =
    .label = Está a partilhar uma janela ou ecrã. Clique para controlar a partilha.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = A sua câmara e microfone estão a ser partilhados. Clique para controlar a partilha.
webrtc-indicator-sharing-camera =
    .tooltiptext = A sua câmara está a ser partilhada. Clique para controlar a partilha.
webrtc-indicator-sharing-microphone =
    .tooltiptext = O seu microfone está a ser partilhado. Clique para controlar a partilha.
webrtc-indicator-sharing-application =
    .tooltiptext = Está a ser partilhada uma aplicação. Clique para controlar a partilha.
webrtc-indicator-sharing-screen =
    .tooltiptext = O seu ecrã está a ser partilhado. Clique para controlar a partilha.
webrtc-indicator-sharing-window =
    .tooltiptext = Uma janela está a ser partilhada. Clique para controlar a partilha.
webrtc-indicator-sharing-browser =
    .tooltiptext = Um separador está a ser partilhado. Clique para controlar a partilha.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Controlar partilha
webrtc-indicator-menuitem-control-sharing-on =
    .label = Controlar partilha em “{ $streamTitle }”

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Partilhar câmara com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] A partilhar câmara com { $tabCount } separador
           *[other] A partilhar câmara com { $tabCount } separadores
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = A partilhar microfone com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] A partilhar microfone com { $tabCount } separador
           *[other] A partilhar microfone com { $tabCount }separadores
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = A partilhar uma aplicação com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] A partilhar uma aplicação com { $tabCount } separador
           *[other] A partilhar uma aplicação com { $tabCount } separadores
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = A partilhar ecrã com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] A partilhar ecrã com { $tabCount } separador
           *[other] A partilhar ecrã com { $tabCount } separadores
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = A partilhar uma janela com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] A partilhar uma janela com { $tabCount } separador
           *[other] A partilhar janelas com { $tabCount } separadores
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = A partilhar um separador com “{ $streamTitle }”
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] A partilhar um separador com { $tabCount } separador
           *[other] A partilhar separadores com { $tabCount } separadores
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Permitir que { $origin } ouça o áudio deste separador?
webrtc-allow-share-camera = Permitir que { $origin } utilize a sua câmara?
webrtc-allow-share-microphone = Permitir que { $origin } utilize o seu microfone?
webrtc-allow-share-screen = Permitir que { $origin } veja o seu ecrã?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Permitir que { $origin } utilize outras colunas?
webrtc-allow-share-camera-and-microphone = Permitir que { $origin } utilize a sua câmara e microfone?
webrtc-allow-share-camera-and-audio-capture = Permitir que { $origin } utilize a sua câmara e ouça o áudio deste separador?
webrtc-allow-share-screen-and-microphone = Permitir que { $origin } utilize o seu microfone e veja o seu ecrã?
webrtc-allow-share-screen-and-audio-capture = Permitir que { $origin } ouça o áudio deste separador e veja o seu ecrã?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Permitir que { $origin } dê à { $thirdParty } permissões para ouvir o áudio deste separador?
webrtc-allow-share-camera-unsafe-delegation = Permitir que { $origin } forneça acesso à sua câmara a { $thirdParty }?
webrtc-allow-share-microphone-unsafe-delegation = Permitir que { $origin } forneça acesso ao seu microfone a { $thirdParty }?
webrtc-allow-share-screen-unsafe-delegation = Permitir que { $origin } forneça acesso para ver o seu ecrã a { $thirdParty }?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Permitir que { $origin } forneça acesso a outras colunas a { $thirdParty }?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Permitir que { $origin } forneça acesso à sua câmara e ao seu microfone a { $thirdParty }?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Permitir que { $origin } forneça acesso à sua câmara e ouvir o áudio deste separador a { $thirdParty }?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Permite que { $origin } forneça acesso ao seu microfone e a visualizar o seu ecrã a { $thirdParty }?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Permitir que { $origin } forneça acesso para ouvir o áudio deste separador e a visualizar o seu ecrã a { $thirdParty }?

##

webrtc-share-screen-warning = Apenas partilhe ecrãs com sites em que confia. Partilhar pode permitir que sites enganadores naveguem por si e que roubem os seus dados privados.
webrtc-share-browser-warning = Apenas partilhe o { -brand-short-name } com sites em que confia. Partilhar pode permitir que sites enganadores naveguem por si e que roubem os seus dados privados.

webrtc-share-screen-learn-more = Saber mais
webrtc-pick-window-or-screen = Selecionar janela ou ecrã
webrtc-share-entire-screen = Ecrã completo
webrtc-share-pipe-wire-portal = Utilizar definições do sistema operativo
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Ecrã { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] { $appName } ({ $windowCount } janela)
       *[other] { $appName } ({ $windowCount } janelas)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Permitir
    .accesskey = P
webrtc-action-block =
    .label = Bloquear
    .accesskey = B
webrtc-action-always-block =
    .label = Bloquear sempre
    .accesskey = m
webrtc-action-not-now =
    .label = Agora não
    .accesskey = N

##

webrtc-remember-allow-checkbox = Memorizar esta decisão
webrtc-mute-notifications-checkbox = Silenciar notificações de sites durante a partilha

webrtc-reason-for-no-permanent-allow-screen = O { -brand-short-name } não pode permitir acesso permanente ao seu ecrã.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } não pode permitir acesso permanente ao áudio do separador sem lhe perguntar qual separador partilhar.
webrtc-reason-for-no-permanent-allow-insecure = A sua ligação a este site não é segura. Para lhe proteger, o { -brand-short-name } irá apenas permitir acesso para esta sessão.
