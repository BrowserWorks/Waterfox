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
webrtc-item-audio-capture = audio de la pestaña
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
    .label = Pestañas compartiendo dispositivos
    .accesskey = D

webrtc-sharing-window = Está compartiendo otra ventana de aplicación.
webrtc-sharing-browser-window = Está compartiendo { -brand-short-name }.
webrtc-sharing-screen = Está compartiendo toda su pantalla.
webrtc-stop-sharing-button = Dejar de compartir
webrtc-microphone-unmuted =
    .title = Desactivar micrófono
webrtc-microphone-muted =
    .title = Activar micrófono
webrtc-camera-unmuted =
    .title = Desactivar cámara
webrtc-camera-muted =
    .title = Activar cámara
webrtc-minimize =
    .title = Minimizar indicador

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Está compartiendo su cámara. Haga clic para controlar el uso compartido.
webrtc-microphone-system-menu =
    .label = Está compartiendo su micrófono. Haga clic para controlar el uso compartido.
webrtc-screen-system-menu =
    .label = Está compartiendo una ventana o una pantalla. Haga clic para controlar el uso compartido.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Su cámara y micrófono están siendo compartidos. Pulse para controlar la compartición.
webrtc-indicator-sharing-camera =
    .tooltiptext = Su cámara está siendo compartida. Pulse para controlar la compartición.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Su micrófono está siendo compartido. Pulse para controlar la compartición.
webrtc-indicator-sharing-application =
    .tooltiptext = Se está compartiendo una aplicación. Pulse para controlar la compartición.
webrtc-indicator-sharing-screen =
    .tooltiptext = Su pantalla está siendo compartida. Pulse para controlar la compartición.
webrtc-indicator-sharing-window =
    .tooltiptext = Se está compartiendo una ventana. Pulse para controlar la compartición.
webrtc-indicator-sharing-browser =
    .tooltiptext = Se está compartiendo una pestaña. Pulse para controlar la compartición.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Controlar compartición
webrtc-indicator-menuitem-control-sharing-on =
    .label = Controlar compartición en "{ $streamTitle }"

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Compartiendo la cámara con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo la cámara con { $tabCount } pestaña
           *[other] Compartiendo la cámara con { $tabCount } pestañas
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Compartiendo el micrófono con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo el micrófono con { $tabCount } pestaña
           *[other] Compartiendo el micrófono con { $tabCount } pestañas
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = Compartiendo una aplicación con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo una aplicación con { $tabCount } pestaña
           *[other] Compartiendo una aplicación con { $tabCount } pestañas
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Compartiendo la pantalla con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo la pantalla con { $tabCount } pestaña
           *[other] Compartiendo la pantalla con { $tabCount } pestañas
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = Compartiendo una ventana con "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] Compartiendo una ventana con { $tabCount } pestaña
           *[other] Compartiendo una ventana con { $tabCount } pestañas
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
webrtc-allow-share-camera = ¿Permitir a { $origin } usar su cámara?
webrtc-allow-share-microphone = ¿Permitir a { $origin } usar su micrófono?
webrtc-allow-share-screen = ¿Permitir a { $origin } ver su pantalla?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = ¿Permitir a { $origin } usar otros altavoces?
webrtc-allow-share-camera-and-microphone = ¿Permitir a { $origin } usar su cámara y micrófono?
webrtc-allow-share-camera-and-audio-capture = ¿Permitir a { $origin } usar su cámara y escuchar el audio de esta pestaña?
webrtc-allow-share-screen-and-microphone = ¿Permitir a { $origin } usar su micrófono y ver su pantalla?
webrtc-allow-share-screen-and-audio-capture = ¿Permitir a { $origin } escuchar el audio de esta pestaña y ver su pantalla?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = ¿Permitir que { $origin } le dé a { $thirdParty } permiso para escuchar el audio de esta pestaña?
webrtc-allow-share-camera-unsafe-delegation = ¿Permitir que { $origin } le dé a { $thirdParty } acceso a su cámara?
webrtc-allow-share-microphone-unsafe-delegation = ¿Permitir que { $origin } le dé a { $thirdParty } acceso a su micrófono?
webrtc-allow-share-screen-unsafe-delegation = ¿Permitir que { $origin } le dé a { $thirdParty } permiso para ver su pantalla?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = ¿Permitir que { $origin } le dé a { $thirdParty } acceso a otros altavoces?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = ¿Permitir que { $origin } le dé a { $thirdParty } acceso a su cámara y micrófono?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = ¿Permitir que { $origin } le dé a { $thirdParty } acceso a su cámara y escuche el audio de esta pestaña?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = ¿Permitir que { $origin } le dé a { $thirdParty } acceso a su micrófono y vea su pantalla?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = ¿Permitir que { $origin } le dé a { $thirdParty } permiso para escuchar el audio de esta pestaña y ver su pantalla?

##

webrtc-share-screen-warning = Comparta pantallas solo con sitios en los que confíe. Compartir puede permitir a sitios engañosos navegar como si fueran usted y robar sus datos privados.
webrtc-share-browser-warning = Comparta { -brand-short-name } solo con sitios en los que confíe. Compartir puede permitir a sitios engañosos navegar como si fueran usted y robar sus datos privados.

webrtc-share-screen-learn-more = Saber más
webrtc-pick-window-or-screen = Seleccionar ventana o pantalla
webrtc-share-entire-screen = Pantalla completa
webrtc-share-pipe-wire-portal = Utilizar la configuración del sistema operativo
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
    .accesskey = P
webrtc-action-block =
    .label = Bloquear
    .accesskey = B
webrtc-action-always-block =
    .label = Bloquear siempre
    .accesskey = s
webrtc-action-not-now =
    .label = Ahora no
    .accesskey = n

##

webrtc-remember-allow-checkbox = Recordar esta decisión
webrtc-mute-notifications-checkbox = Silenciar notificaciones de la página mientras se comparte

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } no puede conceder acceso permanente a su pantalla.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } no puede permitir acceso permanente al audio de su pestaña sin preguntar qué pestaña compartir.
webrtc-reason-for-no-permanent-allow-insecure = Su conexión a este sitio no es segura. Para protegerle, { -brand-short-name } solo permitirá el acceso en esta sesión.
