# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - Indicador de compartición
webrtc-indicator-window =
    .title = { -brand-short-name } - Indicador de compartición

## Used as list items in sharing menu

webrtc-item-camera = cámara
webrtc-item-microphone = micrófono
webrtc-item-audio-capture = pestaña de audio
webrtc-item-application = aplicación
webrtc-item-screen = pantalla
webrtc-item-window = ventana
webrtc-item-browser = pestaña

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Origen desconocido

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Dispositivos que comparten pestañas
    .accesskey = d

webrtc-sharing-window = Estás compartiendo otra ventana de aplicación.
webrtc-sharing-browser-window = Estás compartiendo { -brand-short-name }.
webrtc-sharing-screen = Estás compartiendo toda tu pantalla.
webrtc-stop-sharing-button = Dejar de compartir
webrtc-microphone-unmuted =
    .title = Apagar el micrófono
webrtc-microphone-muted =
    .title = Encender el micrófono
webrtc-camera-unmuted =
    .title = Apagar la cámara
webrtc-camera-muted =
    .title = Encender la cámara
webrtc-minimize =
    .title = Minimizar indicador

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Estás compartiendo tu cámara. Haz clic para controlar lo compartido.
webrtc-microphone-system-menu =
    .label = Estás compartiendo tu micrófono. Haz clic para controlar lo compartido.
webrtc-screen-system-menu =
    .label = Estás compartiendo tu ventana o pantalla. Haz clic para controlar lo compartido.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = La cámara y el micrófono están siendo compartidos. Haz clic para controlar el intercambio.
webrtc-indicator-sharing-camera =
    .tooltiptext = La cámara se está compartiendo. Haz clic para controlar el intercambio.
webrtc-indicator-sharing-microphone =
    .tooltiptext = El micrófono se está compartiendo. Haz clic para controlar el intercambio.
webrtc-indicator-sharing-application =
    .tooltiptext = Una aplicación se está compartiendo. Haz clic para controlar la compartición.
webrtc-indicator-sharing-screen =
    .tooltiptext = La pantalla se está compartiendo. Haz clic para controlar el intercambio.
webrtc-indicator-sharing-window =
    .tooltiptext = Una ventana se está compartiendo. Haz clic para controlar el intercambio.
webrtc-indicator-sharing-browser =
    .tooltiptext = Una ventana se está compartiendo. Haz clic para controlar el intercambio.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Controlar el intercambio
webrtc-indicator-menuitem-control-sharing-on =
    .label = Compartiendo control con "{ $streamTitle }"

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Compartiendo cámara con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo cámara con { $tabCount } pestañas
           *[other] Compartiendo cámara con { $tabCount } pestañas
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Compartiendo micrófono con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo micrófono con { $tabCount } pestaña
           *[other] Compartiendo micrófono con { $tabCount } pestañas
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Compartiendo un aplicación con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo una aplicación con { $tabCount } pestaña
           *[other] Compartiendo aplicaciones con { $tabCount } pestañas
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Compartiendo pantalla con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo pantalla con { $tabCount } pestaña
           *[other] Compartiendo pantalla con { $tabCount } pestañas
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Compartiendo ventana con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo ventana con { $tabCount } pestaña
           *[other] Compartiendo ventanas con { $tabCount } pestañas
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Compartiendo una pestaña con "{ $streamTitle }"
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo una pestaña con { $tabCount } pestaña
           *[other] Compartiendo pestañas con { $tabCount } pestañas
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = ¿Permitir a { $origin } escuchar el audio de esta pestaña?
webrtc-allow-share-camera = ¿Permitir que { $origin } use tu cámara?
webrtc-allow-share-microphone = ¿Permitir que { $origin } use tu micrófono?
webrtc-allow-share-screen = ¿Permitir que { $origin } vea tu pantalla?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = ¿Permitir que { $origin } use altavoces alternativos?
webrtc-allow-share-camera-and-microphone = ¿Permitir a { $origin } usar tu cámara y micrófono?
webrtc-allow-share-camera-and-audio-capture = ¿Permitir a { $origin } usar tu cámara y escuchar el audio de esta pestaña?
webrtc-allow-share-screen-and-microphone = ¿Permitir a { $origin } usar tu micrófono y ver tu pantalla?
webrtc-allow-share-screen-and-audio-capture = ¿Permitir a { $origin } escuchar el audio de esta pestaña y ver tu pantalla?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = ¿Permitir a { $origin } dar permiso a { $thirdParty } para escuchar el audio de esta pestaña?
webrtc-allow-share-camera-unsafe-delegation = ¿Permitir a { $origin } dar a { $thirdParty } permiso para acceder a tu cámara?
webrtc-allow-share-microphone-unsafe-delegation = ¿Permitir a { $origin } dar permiso a { $thirdParty } para acceder a tu micrófono?
webrtc-allow-share-screen-unsafe-delegation = ¿Permitir a { $origin } dar permiso a { $thirdParty } para acceder a tu pantalla?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = ¿Permitir que { $origin } de acceso a los altavoces alternativos a { $thirdParty }?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = ¿Permitir a { $origin } dar permiso a { $thirdParty } para acceder a tu cámara y micrófono?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = ¿Permitir a { $origin } dar permiso a { $thirdParty } para acceder a tu cámara y escuchar al audio de esta pestaña?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = ¿Permitir a { $origin } dar permiso a { $thirdParty } para acceder a tu micrófono y ver tu pantalla?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = ¿Permitir a { $origin } dar permiso a { $thirdParty } para escuchar al audio de esta pestaña y ver tu pantalla?

##

webrtc-share-screen-warning = Comparte la pantalla solo con sitios en los que confíes. Compartirla puede permitir a sitios fraudulentos a navegar en tu nombre y robar tus datos privados.
webrtc-share-browser-warning = Comparte { -brand-short-name } solo con sitios con los que confíes. Compartirla puede permitir a sitios fraudulentos navegar en tu nombre y robar tus datos privados.

webrtc-share-screen-learn-more = Saber Más
webrtc-pick-window-or-screen = Seleccionar ventana o pantalla
webrtc-share-entire-screen = Pantalla completa
webrtc-share-pipe-wire-portal = Usar los ajustes del sistema operativo
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Pantalla { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] { $appName } ({ $windowCount } ventana)
       *[other] { $appName } ({ $windowCount } ventanas)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Permitir
    .accesskey = A
webrtc-action-block =
    .label = Bloquear
    .accesskey = B
webrtc-action-always-block =
    .label = Bloquear siempre
    .accesskey = B
webrtc-action-not-now =
    .label = Ahora no
    .accesskey = N

##

webrtc-remember-allow-checkbox = Recordar esta decisión
webrtc-mute-notifications-checkbox = Silenciar las notificaciones de sitios web mientras se comparte

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } no permite que se acceda de manera permanente a tu monitor.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } no permite acceso permanente al audio de tu pestaña sin preguntar cuál audio se va a compartir.
webrtc-reason-for-no-permanent-allow-insecure = La conexión a este sitio no es segura. Por tu seguridad, { -brand-short-name } solo permitirá el acceso por esta razón.
