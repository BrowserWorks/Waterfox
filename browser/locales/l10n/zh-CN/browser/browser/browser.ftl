# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } （隐私浏览）
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } （隐私浏览）
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - （隐私浏览）
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - （隐私浏览）
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = 查看网站信息

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = 打开安装消息面板
urlbar-web-notification-anchor =
    .tooltiptext = 更改您是否接收该网站发来的通知
urlbar-midi-notification-anchor =
    .tooltiptext = 打开 MIDI 面板
urlbar-eme-notification-anchor =
    .tooltiptext = 管理 DRM 软件使用
urlbar-web-authn-anchor =
    .tooltiptext = 打开 Web 认证面板
urlbar-canvas-notification-anchor =
    .tooltiptext = 管理画布(canvas)提取权限
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = 管理您是否与该网站共享麦克风
urlbar-default-notification-anchor =
    .tooltiptext = 打开消息面板
urlbar-geolocation-notification-anchor =
    .tooltiptext = 打开位置请求面板
urlbar-xr-notification-anchor =
    .tooltiptext = 打开虚拟现实权限面板
urlbar-storage-access-anchor =
    .tooltiptext = 打开上网活动权限面板
urlbar-translate-notification-anchor =
    .tooltiptext = 翻译此页面
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = 管理您是否与该网站共享窗口或屏幕
urlbar-indexed-db-notification-anchor =
    .tooltiptext = 打开离线存储消息面板
urlbar-password-notification-anchor =
    .tooltiptext = 打开保存密码消息面板
urlbar-translated-notification-anchor =
    .tooltiptext = 管理页面翻译
urlbar-plugins-notification-anchor =
    .tooltiptext = 管理插件使用
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = 管理您是否与该网站共享摄像头和麦克风
urlbar-autoplay-notification-anchor =
    .tooltiptext = 打开自动播放面板
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = 在持久存储中存储数据
urlbar-addons-notification-anchor =
    .tooltiptext = 打开附加组件安装消息面板
urlbar-tip-help-icon =
    .title = 获取帮助
urlbar-search-tips-confirm = 好的，明白了
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = 提示：

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = 输入寥寥，搜遍万千：在地址栏就能用 { $engineName } 搜索。
urlbar-search-tips-redirect-2 = 在地址栏搜索，可以看到 { $engineName } 提供的建议，还有您的相关浏览历史。

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = 书签
urlbar-search-mode-tabs = 标签页
urlbar-search-mode-history = 历史记录

##

urlbar-geolocation-blocked =
    .tooltiptext = 您已阻止此网站获取位置信息。
urlbar-xr-blocked =
    .tooltiptext = 您已阻止此网站使用虚拟现实设备。
urlbar-web-notifications-blocked =
    .tooltiptext = 您已阻止此网站发送通知。
urlbar-camera-blocked =
    .tooltiptext = 您已阻止此网站使用您的摄像头。
urlbar-microphone-blocked =
    .tooltiptext = 您已阻止此网站使用您的麦克风。
urlbar-screen-blocked =
    .tooltiptext = 您已阻止此网站共享您的屏幕。
urlbar-persistent-storage-blocked =
    .tooltiptext = 您已阻止此网站使用持久存储。
urlbar-popup-blocked =
    .tooltiptext = 您已拦截此网站的弹出窗口。
urlbar-autoplay-media-blocked =
    .tooltiptext = 您已阻止此网站自动播放有声媒体内容。
urlbar-canvas-blocked =
    .tooltiptext = 您已禁止此网站获取 Canvas 数据。
urlbar-midi-blocked =
    .tooltiptext = 您已阻止此网站访问 MIDI。
urlbar-install-blocked =
    .tooltiptext = 您已阻止此网站安装附加组件。
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = 编辑此书签 ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = 为此页添加书签 ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = 添加到地址栏
page-action-manage-extension =
    .label = 管理扩展…
page-action-remove-from-urlbar =
    .label = 从地址栏移除
page-action-remove-extension =
    .label = 移除扩展

## Auto-hide Context Menu

full-screen-autohide =
    .label = 隐藏工具栏
    .accesskey = H
full-screen-exit =
    .label = 退出全屏模式
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = 这次要用的搜索引擎：
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = 更改搜索设置
search-one-offs-change-settings-compact-button =
    .tooltiptext = 更改搜索设置
search-one-offs-context-open-new-tab =
    .label = 在新标签页中搜索
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = 设为默认搜索引擎
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = 设为隐私窗口的默认搜索引擎
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName }（{ $alias }）

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = 书签（{ $restrict }）
search-one-offs-tabs =
    .tooltiptext = 标签页（{ $restrict }）
search-one-offs-history =
    .tooltiptext = 历史记录（{ $restrict }）

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = 保存时显示编辑器
    .accesskey = S
bookmark-panel-done-button =
    .label = 完成
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = 不安全连接
identity-connection-secure = 安全连接
identity-connection-internal = 这是安全的 { -brand-short-name } 页面。
identity-connection-file = 此页面存储在您的计算机上。
identity-extension-page = 此页面是扩展页面。
identity-active-blocked = { -brand-short-name } 已拦截此页面上不安全的内容。
identity-custom-root = 连接由 Mozilla 不认可的证书颁发者所验证。
identity-passive-loaded = 此页面上部分内容不安全（例如图像）。
identity-active-loaded = 您在此页面上已禁用保护。
identity-weak-encryption = 此页面使用较弱加密。
identity-insecure-login-forms = 在此网页上输入的登录信息可能会泄露。
identity-permissions =
    .value = 权限
identity-permissions-reload-hint = 您可能需要重新载入此页面以应用更改。
identity-permissions-empty = 您尚未授予此站点任何权限。
identity-clear-site-data =
    .label = 清除 Cookie 和网站数据…
identity-connection-not-secure-security-view = 您并未安全地连接至此网站。
identity-connection-verified = 您已安全地连接至此网站。
identity-ev-owner-label = 证书颁发给：
identity-description-custom-root = Mozilla 不认识此证书颁发者。它可能是由您的操作系统或管理员身份添加。 <label data-l10n-name="link">详细了解</label>
identity-remove-cert-exception =
    .label = 移除例外
    .accesskey = R
identity-description-insecure = 您至此网站的连接非私密。您提交的信息可能被其他人看到（例如密码、邮件、信用卡等）。
identity-description-insecure-login-forms = 在此页面输入您的登录信息并不安全，可能会泄露。
identity-description-weak-cipher-intro = 您与此网站的连接使用了较弱的加密，并不私密。
identity-description-weak-cipher-risk = 其他人可能查看您的信息或修改该网站的行为。
identity-description-active-blocked = { -brand-short-name } 已拦截此页面上不安全的内容。 <label data-l10n-name="link">详细了解</label>
identity-description-passive-loaded = 您的连接并不私密，您提供给此网站的信息可能会被其他人看到。
identity-description-passive-loaded-insecure = 此网站包含不安全的内容（例如图像）。 <label data-l10n-name="link">详细了解</label>
identity-description-passive-loaded-mixed = 尽管 { -brand-short-name } 已拦截部分内容，但页面上仍有内容不安全（例如图像）。 <label data-l10n-name="link">详细了解</label>
identity-description-active-loaded = 此网站包含的内容不安全（例如脚本），并且您至它的连接非私密。
identity-description-active-loaded-insecure = 您提供给此网站的信息（例如密码、聊天消息、信用卡等）可能会被其他人看到。
identity-learn-more =
    .value = 详细了解
identity-disable-mixed-content-blocking =
    .label = 暂时解除保护
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = 启用保护
    .accesskey = E
identity-more-info-link-text =
    .label = 更多信息

## Window controls

browser-window-minimize-button =
    .tooltiptext = 最小化
browser-window-maximize-button =
    .tooltiptext = 最大化
browser-window-restore-down-button =
    .tooltiptext = 向下还原
browser-window-close-button =
    .tooltiptext = 关闭

## WebRTC Pop-up notifications

popup-select-camera =
    .value = 共享的摄像头：
    .accesskey = C
popup-select-microphone =
    .value = 共享的麦克风：
    .accesskey = M
popup-all-windows-shared = 您的屏幕上的所有可见窗口都将被共享。
popup-screen-sharing-not-now =
    .label = 暂时不要
    .accesskey = w
popup-screen-sharing-never =
    .label = 永不允许
    .accesskey = N
popup-silence-notifications-checkbox = 共享时，不显示 { -brand-short-name } 的通知
popup-silence-notifications-checkbox-warning = { -brand-short-name } 将不会在共享时显示通知。

## WebRTC window or screen share tab switch warning

sharing-warning-window = 您正在共享 { -brand-short-name }。当切换到新标签页时，其他人可以看到。
sharing-warning-screen = 您正在共享完整屏幕。当切换到新标签页时，其他人可以看到。
sharing-warning-proceed-to-tab =
    .label = 继续前往标签页
sharing-warning-disable-for-session =
    .label = 在本次会话期间禁用共享保护

## DevTools F12 popup

enable-devtools-popup-description = 请通过“Web 开发者”菜单打开开发者工具，才能使用 F12 快捷键。

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = 搜索或输入网址
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = 搜索或输入网址
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = 网上搜索
    .aria-label = 使用 { $name } 搜索
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = 输入搜索词
    .aria-label = 搜索 { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = 输入搜索词
    .aria-label = 搜索书签
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = 输入搜索词
    .aria-label = 搜索历史记录
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = 输入搜索词
    .aria-label = 搜索标签页
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = 使用 { $name } 搜索，或者输入网址
urlbar-remote-control-notification-anchor =
    .tooltiptext = 浏览器正被远程控制
urlbar-permissions-granted =
    .tooltiptext = 您已授予此站点更多权限。
urlbar-switch-to-tab =
    .value = 切换到标签页：
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = 扩展：
urlbar-go-button =
    .tooltiptext = 转到地址栏中指向的网址
urlbar-page-action-button =
    .tooltiptext = 页面动作
urlbar-pocket-button =
    .tooltiptext = 保存到 { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> 已进入全屏模式
fullscreen-warning-no-domain = 此文档已进入全屏模式
fullscreen-exit-button = 退出全屏模式(Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = 退出全屏模式 (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> 已控制您的鼠标指针。按 Esc 键可收回控制权。
pointerlock-warning-no-domain = 此文档已控制您的鼠标指针。按 Esc 键可收回控制权。
