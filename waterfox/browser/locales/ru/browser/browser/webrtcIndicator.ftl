# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } — Индикатор общего доступа
webrtc-indicator-window =
    .title = { -brand-short-name } — Индикатор общего доступа

## Used as list items in sharing menu

webrtc-item-camera = камера
webrtc-item-microphone = микрофон
webrtc-item-audio-capture = звук вкладки
webrtc-item-application = приложение
webrtc-item-screen = экран
webrtc-item-window = окно
webrtc-item-browser = вкладка

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Неизвестный источник

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Устройства с доступом ко вкладкам
    .accesskey = у

webrtc-sharing-window = Вы предоставляете доступ к другому окну приложения.
webrtc-sharing-browser-window = Вы предоставляете доступ к { -brand-short-name }.
webrtc-sharing-screen = Вы предоставляете доступ ко всему своему экрану.
webrtc-stop-sharing-button = Закрыть доступ
webrtc-microphone-unmuted =
    .title = Отключить микрофон
webrtc-microphone-muted =
    .title = Включить микрофон
webrtc-camera-unmuted =
    .title = Отключить камеру
webrtc-camera-muted =
    .title = Включить камеру
webrtc-minimize =
    .title = Свернуть индикатор

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Вы открыли доступ к своей камере. Щёлкните для контроля доступа.
webrtc-microphone-system-menu =
    .label = Вы открыли доступ к своему микрофону. Щёлкните для контроля доступа.
webrtc-screen-system-menu =
    .label = Вы открыли доступ к одному из ваших окон или экрану. Щёлкните для контроля доступа.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = К вашей камере и микрофону имеется доступ. Щёлкните для контроля доступа.
webrtc-indicator-sharing-camera =
    .tooltiptext = К вашей камере имеется доступ. Щёлкните для контроля доступа.
webrtc-indicator-sharing-microphone =
    .tooltiptext = К вашему микрофону имеется доступ. Щёлкните для контроля доступа.
webrtc-indicator-sharing-application =
    .tooltiptext = К приложению имеется доступ. Щёлкните для контроля доступа.
webrtc-indicator-sharing-screen =
    .tooltiptext = К вашему экрану имеется доступ. Щёлкните для контроля доступа.
webrtc-indicator-sharing-window =
    .tooltiptext = К окну имеется доступ. Щёлкните для контроля доступа.
webrtc-indicator-sharing-browser =
    .tooltiptext = К вкладке имеется доступ. Щёлкните для контроля доступа.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Контроль доступа
webrtc-indicator-menuitem-control-sharing-on =
    .label = Контроль доступа для «{ $streamTitle }»

webrtc-indicator-menuitem-sharing-camera-with =
    .label = «{ $streamTitle }» имеет доступ к камере
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label =
        { $tabCount ->
            [one] { $tabCount } вкладка имеет доступ к камере
            [few] { $tabCount } вкладки имеют доступ к камере
           *[many] { $tabCount } вкладок имеют доступ к камере
        }

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = «{ $streamTitle }» имеет доступ к микрофону
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label =
        { $tabCount ->
            [one] { $tabCount } вкладка имеет доступ к микрофону
            [few] { $tabCount } вкладки имеют доступ к микрофону
           *[many] { $tabCount } вкладок имеют доступ к микрофону
        }

webrtc-indicator-menuitem-sharing-application-with =
    .label = «{ $streamTitle }» имеет доступ к приложению
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label =
        { $tabCount ->
            [one] { $tabCount } вкладка имеет доступ к приложению
            [few] { $tabCount } вкладки имеют доступ к приложению
           *[many] { $tabCount } вкладок имеют доступ к приложению
        }

webrtc-indicator-menuitem-sharing-screen-with =
    .label = «{ $streamTitle }» имеет доступ к экрану
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label =
        { $tabCount ->
            [one] { $tabCount } вкладка имеет доступ к экрану
            [few] { $tabCount } вкладки имеют доступ к экрану
           *[many] { $tabCount } вкладок имеют доступ к экрану
        }

webrtc-indicator-menuitem-sharing-window-with =
    .label = «{ $streamTitle }» имеет доступ к окну
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label =
        { $tabCount ->
            [one] { $tabCount } вкладка имеет доступ к окну
            [few] { $tabCount } вкладки имеют доступ к окну
           *[many] { $tabCount } вкладок имеют доступ к окну
        }

webrtc-indicator-menuitem-sharing-browser-with =
    .label = «{ $streamTitle }» имеет доступ к вкладке
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label =
        { $tabCount ->
            [one] { $tabCount } вкладка имеет доступ к вкладке
            [few] { $tabCount } вкладки имеют доступ к вкладкам
           *[many] { $tabCount } вкладок имеют доступ к вкладкам
        }

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Разрешить { $origin } прослушивать звук этой вкладки?
webrtc-allow-share-camera = Разрешить { $origin } использовать вашу камеру?
webrtc-allow-share-microphone = Разрешить { $origin } использовать ваш микрофон?
webrtc-allow-share-screen = Разрешить { $origin } видеть ваш экран?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Разрешить { $origin } использовать другие динамики?
webrtc-allow-share-camera-and-microphone = Разрешить { $origin } использовать ваши камеру и микрофон?
webrtc-allow-share-camera-and-audio-capture = Разрешить { $origin } использовать вашу камеру и прослушивать звук этой вкладки?
webrtc-allow-share-screen-and-microphone = Разрешить { $origin } использовать ваш микрофон и видеть ваш экран?
webrtc-allow-share-screen-and-audio-capture = Разрешить { $origin } прослушивать звук этой вкладки и видеть ваш экран?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Разрешить { $origin } предоставить { $thirdParty } доступ к прослушиванию звука этой вкладки?
webrtc-allow-share-camera-unsafe-delegation = Разрешить { $origin } предоставить { $thirdParty } доступ к вашей камере?
webrtc-allow-share-microphone-unsafe-delegation = Разрешить { $origin } предоставить { $thirdParty } доступ к вашему микрофону?
webrtc-allow-share-screen-unsafe-delegation = Разрешить { $origin } предоставить { $thirdParty } доступ на просмотр вашего экрана?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Разрешить { $origin } предоставить { $thirdParty } доступ к другим динамикам?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Разрешить { $origin } предоставить { $thirdParty } доступ к вашим камере и микрофону?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Разрешить { $origin } предоставить { $thirdParty } доступ к вашей камере и прослушиванию звука этой вкладки?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Разрешить { $origin } предоставить { $thirdParty } доступ к вашему микрофону и просмотру вашего экрана?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Разрешить { $origin } предоставить { $thirdParty } доступ к прослушиванию звука этой вкладки и просмотру вашего экрана?

##

webrtc-share-screen-warning = Предоставляйте доступ к экрану только тем сайтам, которым доверяете. Предоставление доступа может позволить поддельным сайтам использовать Интернет от вашего имени и украсть ваши личные данные.
webrtc-share-browser-warning = Предоставляйте доступ к { -brand-short-name } только тем сайтам, которым доверяете. Предоставление доступа может позволить поддельным сайтам использовать Интернет от вашего имени и украсть ваши личные данные.

webrtc-share-screen-learn-more = Подробнее
webrtc-pick-window-or-screen = Выберите окно или экран
webrtc-share-entire-screen = Во весь экран
webrtc-share-pipe-wire-portal = Использовать настройки операционной системы
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Экран { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application =
    { $windowCount ->
        [one] { $appName } ({ $windowCount } окно)
        [few] { $appName } ({ $windowCount } окна)
       *[many] { $appName } ({ $windowCount } окон)
    }

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Разрешить
    .accesskey = Р
webrtc-action-block =
    .label = Блокировать
    .accesskey = л
webrtc-action-always-block =
    .label = Всегда блокировать
    .accesskey = е
webrtc-action-not-now =
    .label = Не сейчас
    .accesskey = е

##

webrtc-remember-allow-checkbox = Запомнить это решение
webrtc-mute-notifications-checkbox = Отключить уведомления веб-сайтов при предоставлении доступа

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } не может предоставить постоянный доступ к вашему экрану.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } не может предоставить постоянный доступ к звуку вашей вкладки без конкретного запроса.
webrtc-reason-for-no-permanent-allow-insecure = Ваше соединение с этим сайтом не защищено. Чтобы защитить вас, { -brand-short-name } разрешит доступ только до конца текущей сессии.
