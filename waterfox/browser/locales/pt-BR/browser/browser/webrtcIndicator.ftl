# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - Indicador de compartilhamento
webrtc-indicator-window =
    .title = { -brand-short-name } — Indicador de compartilhamento

## Used as list items in sharing menu

webrtc-item-camera = câmera
webrtc-item-microphone = microfone
webrtc-item-audio-capture = áudio da aba
webrtc-item-application = aplicativo
webrtc-item-screen = tela
webrtc-item-window = janela
webrtc-item-browser = aba

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Origem desconhecida

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Abas compartilhadas em dispositivos
    .accesskey = A

webrtc-sharing-window = Você está compartilhando outra janela do aplicativo.
webrtc-sharing-browser-window = Você está compartilhando o { -brand-short-name }.
webrtc-sharing-screen = Você está compartilhando sua tela inteira.
webrtc-stop-sharing-button = Parar de compartilhar
webrtc-microphone-unmuted =
    .title = Desligar microfone
webrtc-microphone-muted =
    .title = Ligar microfone
webrtc-camera-unmuted =
    .title = Desligar câmera
webrtc-camera-muted =
    .title = Ligar câmera
webrtc-minimize =
    .title = Minimizar indicador

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Você está compartilhando sua câmera. Clique para controlar o compartilhamento.
webrtc-microphone-system-menu =
    .label = Você está compartilhando seu microfone. Clique para controlar o compartilhamento.
webrtc-screen-system-menu =
    .label = Você está compartilhando uma janela ou tela. Clique para controlar o compartilhamento.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Sua câmera e seu microfone estão sendo compartilhados. Clique para controlar o compartilhamento.
webrtc-indicator-sharing-camera =
    .tooltiptext = Sua câmera está sendo compartilhada. Clique para controlar o compartilhamento.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Seu microfone está sendo compartilhado. Clique para controlar o compartilhamento.
webrtc-indicator-sharing-application =
    .tooltiptext = Um aplicativo está sendo compartilhado. Clique para controlar o compartilhamento.
webrtc-indicator-sharing-screen =
    .tooltiptext = Sua tela está sendo compartilhada. Clique para controlar o compartilhamento.
webrtc-indicator-sharing-window =
    .tooltiptext = Uma janela está sendo compartilhada. Clique para controlar o compartilhamento.
webrtc-indicator-sharing-browser =
    .tooltiptext = Uma aba está sendo compartilhada. Clique para controlar o compartilhamento.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Controlar compartilhamento
webrtc-indicator-menuitem-control-sharing-on =
    .label = Controlar compartilhamento em “{ $streamTitle }”

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Compartilhando câmera com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartilhando câmera com { $tabCount } aba
           *[other] Compartilhando câmera com { $tabCount } abas
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Compartilhando microfone com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartilhando microfone com { $tabCount } aba
           *[other] Compartilhando microfone com { $tabCount } abas
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Compartilhando um aplicativo com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartilhando um aplicativo com { $tabCount } aba
           *[other] Compartilhando aplicativos com { $tabCount } abas
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Compartilhando tela com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartilhando tela com { $tabCount } aba
           *[other] Compartilhando tela com { $tabCount } abas
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Compartilhando uma janela com “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartilhando uma janela com { $tabCount } aba
           *[other] Compartilhando janelas com { $tabCount } abas
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Compartilhando uma aba com "{ $streamTitle }"
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartilhando uma aba com { $tabCount } aba
           *[other] Compartilhando abas com { $tabCount } abas
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Permitir que { $origin } ouça o áudio desta aba?
webrtc-allow-share-camera = Permitir que { $origin } use sua câmera?
webrtc-allow-share-microphone = Permitir que { $origin } use seu microfone?
webrtc-allow-share-screen = Permitir que { $origin } veja sua tela?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Permitir que { $origin } use outras saídas de áudio?
webrtc-allow-share-camera-and-microphone = Permitir que { $origin } use sua câmera e seu microfone?
webrtc-allow-share-camera-and-audio-capture = Permitir que { $origin } use sua câmera e ouça o áudio desta aba?
webrtc-allow-share-screen-and-microphone = Permitir que { $origin } use seu microfone e veja sua tela?
webrtc-allow-share-screen-and-audio-capture = Permitir que { $origin } ouça o áudio desta aba e veja sua tela?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Permitir que { $origin } dê permissão para { $thirdParty } ouvir áudio desta aba?
webrtc-allow-share-camera-unsafe-delegation = Permitir que { $origin } dê acesso para { $thirdParty } usar sua câmera?
webrtc-allow-share-microphone-unsafe-delegation = Permitir que { $origin } dê acesso para { $thirdParty } usar seu microfone?
webrtc-allow-share-screen-unsafe-delegation = Permitir que { $origin } dê permissão para { $thirdParty } ver sua tela?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Permitir que { $origin } dê acesso para { $thirdParty } usar outras saídas de áudio?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Permitir que { $origin } dê acesso para { $thirdParty } usar sua câmera e seu microfone?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Permitir que { $origin } dê acesso para { $thirdParty } usar sua câmera e ouvir áudio desta aba?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Permitir que { $origin } dê acesso para { $thirdParty } usar seu microfone e ver sua tela?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Permitir que { $origin } dê permissão para { $thirdParty } ouvir áudio desta aba e ver sua tela?

##

webrtc-share-screen-warning = Só compartilhe telas com sites que você confia. Compartilhar pode permitir que sites enganosos naveguem como se fossem você e roubem seus dados privativos.
webrtc-share-browser-warning = Só compartilhe o { -brand-short-name } com sites que você confia. Compartilhar pode permitir que sites enganosos naveguem como se fossem você e roubem seus dados privativos.

webrtc-share-screen-learn-more = Saiba mais
webrtc-pick-window-or-screen = Selecionar janela ou tela
webrtc-share-entire-screen = Tela inteira
webrtc-share-pipe-wire-portal = Usar configurações do sistema operacional
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Tela { $monitorIndex }
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
    .label = Sempre bloquear
    .accesskey = m
webrtc-action-not-now =
    .label = Agora não
    .accesskey = n

##

webrtc-remember-allow-checkbox = Memorizar esta decisão
webrtc-mute-notifications-checkbox = Silenciar notificações de sites durante o compartilhamento

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } não pode permitir acesso permanente a sua tela.
webrtc-reason-for-no-permanent-allow-audio = O { -brand-short-name } não pode permitir acesso permanente ao áudio da sua aba sem perguntar qual aba compartilhar.
webrtc-reason-for-no-permanent-allow-insecure = Sua conexão com este site não é segura. Para te proteger, o { -brand-short-name } só permitirá o acesso nesta sessão.
