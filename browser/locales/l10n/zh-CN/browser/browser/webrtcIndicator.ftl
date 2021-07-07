# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.

# This string is used so that the window has a title in tools that enumerate/look for window
# titles. It is not normally visible anywhere.
webrtc-indicator-title = { -brand-short-name } — 共享指示器

webrtc-sharing-window = 您正在共享其他应用程序窗口。
webrtc-sharing-browser-window = 您正在共享 { -brand-short-name }。
webrtc-sharing-screen = 您正在共享完整屏幕。
webrtc-stop-sharing-button = 停止共享
webrtc-microphone-unmuted =
    .title = 关闭麦克风
webrtc-microphone-muted =
    .title = 打开麦克风
webrtc-camera-unmuted =
    .title = 关闭摄像头
webrtc-camera-muted =
    .title = 打开摄像头
webrtc-minimize =
    .title = 最小化指示器

# This string will display as a tooltip on supported systems where we show
# device sharing state in the OS notification area. We do not use these strings
# on macOS, as global menu bar items do not have native tooltips.
webrtc-camera-system-menu =
    .label = 您正在共享摄像头。点击以控制共享。
webrtc-microphone-system-menu =
    .label = 您正在共享麦克风。点击以控制共享。
webrtc-screen-system-menu =
    .label = 您正在共享窗口或者屏幕。点击以控制共享。
