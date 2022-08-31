# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.

# This string is used so that the window has a title in tools that enumerate/look for window
# titles. It is not normally visible anywhere.
webrtc-indicator-title = { -brand-short-name } — 分享指示器

webrtc-sharing-window = 您正在分享其他應用程式視窗。
webrtc-sharing-browser-window = 您正在分享 { -brand-short-name }。
webrtc-sharing-screen = 您正在分享整個畫面。
webrtc-stop-sharing-button = 停止分享
webrtc-microphone-unmuted =
    .title = 關閉麥克風
webrtc-microphone-muted =
    .title = 開啟麥克風
webrtc-camera-unmuted =
    .title = 關閉攝影機
webrtc-camera-muted =
    .title = 開啟攝影機
webrtc-minimize =
    .title = 最小化指示器

# This string will display as a tooltip on supported systems where we show
# device sharing state in the OS notification area. We do not use these strings
# on macOS, as global menu bar items do not have native tooltips.
webrtc-camera-system-menu =
    .label = 正在分享您的攝影機。點擊此處來調整要分享的項目。
webrtc-microphone-system-menu =
    .label = 正在分享您的麥克風。點擊此處來調整要分享的項目。
webrtc-screen-system-menu =
    .label = 正在分享您的視窗或畫面。點擊此處來調整要分享的項目。
