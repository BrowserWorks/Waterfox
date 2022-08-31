# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.

# This string is used so that the window has a title in tools that enumerate/look for window
# titles. It is not normally visible anywhere.
webrtc-indicator-title = { -brand-short-name } — Индикатор общего доступа

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

# This string will display as a tooltip on supported systems where we show
# device sharing state in the OS notification area. We do not use these strings
# on macOS, as global menu bar items do not have native tooltips.
webrtc-camera-system-menu =
    .label = Вы открыли доступ к своей камере. Щёлкните для контроля доступа.
webrtc-microphone-system-menu =
    .label = Вы открыли доступ к своему микрофону. Щёлкните для контроля доступа.
webrtc-screen-system-menu =
    .label = Вы открыли доступ к одному из ваших окон или экрану. Щёлкните для контроля доступа.
