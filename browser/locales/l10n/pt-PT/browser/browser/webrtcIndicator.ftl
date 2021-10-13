# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.

# This string is used so that the window has a title in tools that enumerate/look for window
# titles. It is not normally visible anywhere.
webrtc-indicator-title = { -brand-short-name } - Indicador de partilha

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

# This string will display as a tooltip on supported systems where we show
# device sharing state in the OS notification area. We do not use these strings
# on macOS, as global menu bar items do not have native tooltips.
webrtc-camera-system-menu =
    .label = Está a partilhar a sua câmara. Clique para controlar a partilha.
webrtc-microphone-system-menu =
    .label = Está a partilhar o seu microfone. Clique para controlar a partilha.
webrtc-screen-system-menu =
    .label = Está a partilhar uma janela ou ecrã. Clique para controlar a partilha.
