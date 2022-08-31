# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.

# This string is used so that the window has a title in tools that enumerate/look for window
# titles. It is not normally visible anywhere.
webrtc-indicator-title = { -brand-short-name } - Teilen-Hinweis

webrtc-sharing-window = Sie teilen ein Fenster einer anderen Anwendung.
webrtc-sharing-browser-window = Sie teilen { -brand-short-name }.
webrtc-sharing-screen = Sie teilen Ihren gesamten Bildschirm.
webrtc-stop-sharing-button = Freigabe beenden
webrtc-microphone-unmuted =
    .title = Mikrofon deaktivieren
webrtc-microphone-muted =
    .title = Mikrofon aktivieren
webrtc-camera-unmuted =
    .title = Kamera deaktivieren
webrtc-camera-muted =
    .title = Kamera aktivieren
webrtc-minimize =
    .title = Hinweis minimieren

# This string will display as a tooltip on supported systems where we show
# device sharing state in the OS notification area. We do not use these strings
# on macOS, as global menu bar items do not have native tooltips.
webrtc-camera-system-menu =
    .label = Sie teilen Ihre Kamera. Klicken, um Zugriffe zu verwalten.
webrtc-microphone-system-menu =
    .label = Sie teilen Ihr Mikrofon. Klicken, um Zugriffe zu verwalten.
webrtc-screen-system-menu =
    .label = Sie teilen ein Fenster oder einen Bildschirm. Klicken, um Zugriffe zu verwalten.
