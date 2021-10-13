# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.

# This string is used so that the window has a title in tools that enumerate/look for window
# titles. It is not normally visible anywhere.
webrtc-indicator-title = { -brand-short-name } - Indicateur de partage

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

# This string will display as a tooltip on supported systems where we show
# device sharing state in the OS notification area. We do not use these strings
# on macOS, as global menu bar items do not have native tooltips.
webrtc-camera-system-menu =
    .label = Vous partagez votre caméra. Cliquez pour contrôler le partage.
webrtc-microphone-system-menu =
    .label = Vous partagez votre microphone. Cliquez pour contrôler le partage.
webrtc-screen-system-menu =
    .label = Vous partagez une fenêtre ou un écran. Cliquez pour contrôler le partage.
