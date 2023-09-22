# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } — 共享指示器
webrtc-indicator-window =
    .title = { -brand-short-name } — 共享指示器

## Used as list items in sharing menu

webrtc-item-camera = 摄像头
webrtc-item-microphone = 麦克风
webrtc-item-audio-capture = 标签页音频
webrtc-item-application = 应用程序
webrtc-item-screen = 屏幕
webrtc-item-window = 窗口
webrtc-item-browser = 标签页

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = 未知来源

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = 正在共享设备的标签页
    .accesskey = d

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

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = 您正在共享摄像头。点击以控制共享。
webrtc-microphone-system-menu =
    .label = 您正在共享麦克风。点击以控制共享。
webrtc-screen-system-menu =
    .label = 您正在共享窗口或者屏幕。点击以控制共享。

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = 您的摄像头和麦克风目前已被共享。点击这里控制共享。
webrtc-indicator-sharing-camera =
    .tooltiptext = 正在共享您的摄像头。点击此处控制要共享的项目。
webrtc-indicator-sharing-microphone =
    .tooltiptext = 正在共享您的麦克风。点击此处控制要共享的项目。
webrtc-indicator-sharing-application =
    .tooltiptext = 正在共享应用程序。点击此处控制要共享的项目。
webrtc-indicator-sharing-screen =
    .tooltiptext = 正在共享您的屏幕。点击此处控制要共享的项目。
webrtc-indicator-sharing-window =
    .tooltiptext = 正在共享窗口。点击此处控制要共享的项目。
webrtc-indicator-sharing-browser =
    .tooltiptext = 正在共享标签页。点击此处控制要共享的项目。

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = 控制共享状态
webrtc-indicator-menuitem-control-sharing-on =
    .label = 控制在“{ $streamTitle }”的共享

webrtc-indicator-menuitem-sharing-camera-with =
    .label = 正在与“{ $streamTitle }”共享摄像头
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label = 正在允许 { $tabCount } 个标签页访问摄像头

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = 正在与“{ $streamTitle }”共享麦克风
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label = 正在允许 { $tabCount } 个标签页访问麦克风

webrtc-indicator-menuitem-sharing-application-with =
    .label = 正在与“{ $streamTitle }”共享一个应用程序
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label = 正在允许 { $tabCount } 个标签页访问某个应用程序

webrtc-indicator-menuitem-sharing-screen-with =
    .label = 正在与“{ $streamTitle }”共享屏幕
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label = 正在允许 { $tabCount } 个标签页查看屏幕画面

webrtc-indicator-menuitem-sharing-window-with =
    .label = 正在与“{ $streamTitle }”共享窗口
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label = 正在允许 { $tabCount } 个标签页访问窗口

webrtc-indicator-menuitem-sharing-browser-with =
    .label = 正在与“{ $streamTitle }”共享标签页
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label = 正在允许 { $tabCount } 个标签页访问标签页

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = 要允许 { $origin } 听到此标签页的音频吗？
webrtc-allow-share-camera = 要允许 { $origin } 使用您的摄像头吗？
webrtc-allow-share-microphone = 要允许 { $origin } 使用您的麦克风吗？
webrtc-allow-share-screen = 要允许 { $origin } 看到您的屏幕吗？
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = 要允许 { $origin } 使用其他音频输出设备吗？
webrtc-allow-share-camera-and-microphone = 要允许 { $origin } 使用您的摄像头和麦克风吗？
webrtc-allow-share-camera-and-audio-capture = 要允许 { $origin } 使用您的摄像头，并听到此标签页的音频吗？
webrtc-allow-share-screen-and-microphone = 要允许 { $origin } 使用您的麦克风，并看到您的屏幕吗？
webrtc-allow-share-screen-and-audio-capture = 要允许 { $origin } 听到此标签页的音频，并看到您的屏幕吗？

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = 要允许 { $origin } 授权 { $thirdParty } 听到此标签页的音频吗？
webrtc-allow-share-camera-unsafe-delegation = 要允许 { $origin } 授权 { $thirdParty } 使用您的摄像头吗？
webrtc-allow-share-microphone-unsafe-delegation = 要允许 { $origin } 授权 { $thirdParty } 使用您的麦克风吗？
webrtc-allow-share-screen-unsafe-delegation = 要允许 { $origin } 授权 { $thirdParty } 看到您的屏幕吗？
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = 要允许 { $origin } 授权 { $thirdParty } 使用您的其他音频输出设备吗？
webrtc-allow-share-camera-and-microphone-unsafe-delegation = 要允许 { $origin } 授权 { $thirdParty } 使用您的摄像头和麦克风吗？
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = 要允许 { $origin } 授权 { $thirdParty } 使用您的摄像头，并听到此标签页的音频吗？
webrtc-allow-share-screen-and-microphone-unsafe-delegation = 要允许 { $origin } 授权 { $thirdParty } 使用您的麦克风，并看到您的屏幕吗？
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = 要允许 { $origin } 授权 { $thirdParty } 使用听到此标签页的音频，并看到您的屏幕吗？

##

webrtc-share-screen-warning = 请只与您信任的网站共享屏幕。否则诈骗网站将随您一同浏览，并因而能窃取您的隐私数据。
webrtc-share-browser-warning = 请只与您信任的网站共享 { -brand-short-name }。否则诈骗网站将随您一同浏览，并因而能窃取您的隐私数据。

webrtc-share-screen-learn-more = 详细了解
webrtc-pick-window-or-screen = 选择窗口或屏幕
webrtc-share-entire-screen = 整个屏幕
webrtc-share-pipe-wire-portal = 遵循操作系统设置
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = 屏幕 { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application = { $appName }（{ $windowCount } 个窗口）

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = 允许
    .accesskey = A
webrtc-action-block =
    .label = 阻止
    .accesskey = B
webrtc-action-always-block =
    .label = 一律阻止
    .accesskey = w
webrtc-action-not-now =
    .label = 暂时不要
    .accesskey = N

##

webrtc-remember-allow-checkbox = 记住此决定
webrtc-mute-notifications-checkbox = 共享期间不显示网站通知

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } 不能长效允许访问您的屏幕。
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } 无法永久不让您先指定特定标签页，就允许存取任意标签页的音频内容。
webrtc-reason-for-no-permanent-allow-insecure = 您与此网站间的连接并不安全。为了保护您，{ -brand-short-name } 将只允许此次浏览期间的访问。
