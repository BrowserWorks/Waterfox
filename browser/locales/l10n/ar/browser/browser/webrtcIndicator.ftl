# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.

# This string is used so that the window has a title in tools that enumerate/look for window
# titles. It is not normally visible anywhere.
webrtc-indicator-title = { -brand-short-name } - علامة المشاركة

webrtc-sharing-window = تُشارك الآن نافذة تطبيق أخرى.
webrtc-sharing-browser-window = تُشارك الآن { -brand-short-name }.
webrtc-sharing-screen = تُشارك الآن شاشتك كاملةً.
webrtc-stop-sharing-button = أوقِف المشاركة
webrtc-microphone-unmuted =
    .title = أوقِف الميكروفون
webrtc-microphone-muted =
    .title = شغّل الميكروفون
webrtc-camera-unmuted =
    .title = أوقِف الكمرة
webrtc-camera-muted =
    .title = شغّل الكمرة
webrtc-minimize =
    .title = مؤشّر التصغير

# This string will display as a tooltip on supported systems where we show
# device sharing state in the OS notification area. We do not use these strings
# on macOS, as global menu bar items do not have native tooltips.
webrtc-camera-system-menu =
    .label = تشارك الكمرة. انقر للتحكم في المشاركة.
webrtc-microphone-system-menu =
    .label = تشارك الميكروفون. انقر للتحكم في المشاركة.
webrtc-screen-system-menu =
    .label = تشارك إحدى النوافذ أو إحدى الشاشات. انقر للتحكم في المشاركة.
