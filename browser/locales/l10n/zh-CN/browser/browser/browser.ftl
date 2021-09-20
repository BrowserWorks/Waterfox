# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Waterfox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } （隐私浏览）
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — { -brand-full-name } （隐私浏览）
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Waterfox"
# "private" - "Mozilla Firefox — (Private Browsing)"
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
    .data-title-private = { -brand-full-name } —（隐私浏览）
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } —（隐私浏览）
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
    .tooltiptext = 管理 Canvas 获取权限
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

urlbar-search-tips-onboard = 输入寥寥，搜遍万千：在地址栏就能用 { $engineName } 搜索。
urlbar-search-tips-redirect-2 = 在地址栏搜索，可以看到 { $engineName } 提供的建议，还有您的相关浏览历史。
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = 一键直达，高效搜索。

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

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = 本次搜索使用：
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
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = 添加“{ $engineName }”
    .tooltiptext = 添加搜索引擎“{ $engineName }”
    .aria-label = 添加搜索引擎“{ $engineName }”
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = 添加搜索引擎

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

bookmarks-add-bookmark = 新建书签
bookmarks-edit-bookmark = 编辑书签
bookmark-panel-cancel =
    .label = 取消
    .accesskey = C
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label = 移除 { $count } 个书签
    .accesskey = R
bookmark-panel-show-editor-checkbox =
    .label = 保存时显示编辑器
    .accesskey = S
bookmark-panel-done-button =
    .label = 完成
bookmark-panel-save-button =
    .label = 保存
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = 网站信息：{ $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = 连接安全性：{ $host }
identity-connection-not-secure = 不安全连接
identity-connection-secure = 安全连接
identity-connection-failure = 连接失败
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
identity-https-only-connection-upgraded = （升级为 HTTPS）
identity-https-only-label = HTTPS-Only 模式
identity-https-only-dropdown-on =
    .label = 开启
identity-https-only-dropdown-off =
    .label = 关闭
identity-https-only-dropdown-off-temporarily =
    .label = 暂时关闭
identity-https-only-info-turn-on2 = 若想要 { -brand-short-name } 尽可能升级为安全连接，请对此网站开启 HTTPS-Only 模式。
identity-https-only-info-turn-off2 = 若页面看起来不正常，则可能需要对此网站关闭 HTTPS-Only 模式，使用不安全的 HTTP 重新载入。
identity-https-only-info-no-upgrade = 无法将网站连接从 HTTP 升级。
identity-permissions-storage-access-header = 跨网站 Cookie
identity-permissions-storage-access-hint = 当您在此网站上时，以下各方可以使用跨网站 Cookie 和网站数据。
identity-permissions-storage-access-learn-more = 详细了解
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

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = 播放声音中
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = 静音
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = 已阻止自动播放
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = 画中画

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] 静音标签页
       *[other] 静音 { $count } 个标签页
    }
browser-tab-unmute =
    { $count ->
        [1] 取消静音标签页
       *[other] 取消静音 { $count } 个标签页
    }
browser-tab-unblock =
    { $count ->
        [1] 播放标签页
       *[other] 播放 { $count } 个标签页
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = 导入书签…
    .tooltiptext = 将其他浏览器的书签导入到 { -brand-short-name }。
bookmarks-toolbar-empty-message = 可将书签放在书签工具栏上，方便快速访问。<a data-l10n-name="manage-bookmarks">管理书签…</a>

## WebRTC Pop-up notifications

popup-select-camera =
    .value = 共享的摄像头：
    .accesskey = C
popup-select-microphone =
    .value = 共享的麦克风：
    .accesskey = M
popup-select-camera-device =
    .value = 摄像头：
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = 摄像头
popup-select-microphone-device =
    .value = 麦克风：
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = 麦克风
popup-select-speaker-icon =
    .tooltiptext = 音频输出设备
popup-all-windows-shared = 您的屏幕上的所有可见窗口都将被共享。
popup-screen-sharing-not-now =
    .label = 暂时不要
    .accesskey = w
popup-screen-sharing-never =
    .label = 永不允许
    .accesskey = N
popup-silence-notifications-checkbox = 共享时，不显示 { -brand-short-name } 的通知
popup-silence-notifications-checkbox-warning = { -brand-short-name } 将不会在共享时显示通知。
popup-screen-sharing-block =
    .label = 阻止
    .accesskey = B
popup-screen-sharing-always-block =
    .label = 一律阻止
    .accesskey = w
popup-mute-notifications-checkbox = 共享期间不显示网站通知

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
urlbar-remote-control-notification-anchor =
    .tooltiptext = 浏览器正被远程控制
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
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = 浏览器受到远程控制（原因：{ $component }）
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

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = 在隐私窗口中用 { $engine } 搜索
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = 在隐私窗口中搜索
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = 使用 { $engine } 搜索
urlbar-result-action-sponsored = 赞助项目
urlbar-result-action-switch-tab = 切换到标签页
urlbar-result-action-visit = 访问
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = 按 Tab 键 { $engine } 一下
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = 按 Tab 键在 { $engine } 上搜索
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = 直接从地址栏 { $engine } 一下
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = 直接从地址栏在 { $engine } 上搜索
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = 复制
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = 搜索书签
urlbar-result-action-search-history = 搜索历史记录
urlbar-result-action-search-tabs = 搜索标签页

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

## Subframe crash notification

crashed-subframe-message = <strong>此页面中的部分内容出现崩溃。</strong>您可以向 { -brand-product-name } 报告此问题，以尽快修复。
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = 此页面中的部分内容出现崩溃。您可以向 { -brand-product-name } 报告此问题，以尽快修复。
crashed-subframe-learnmore-link =
    .value = 详细了解
crashed-subframe-submit =
    .label = 提交报告
    .accesskey = S

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = 管理书签
bookmarks-recent-bookmarks-panel-subheader = 最近的书签
bookmarks-toolbar-chevron =
    .tooltiptext = 显示更多书签
bookmarks-sidebar-content =
    .aria-label = 书签
bookmarks-menu-button =
    .label = 书签菜单
bookmarks-other-bookmarks-menu =
    .label = 其他书签
bookmarks-mobile-bookmarks-menu =
    .label = 移动设备上的书签
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] 隐藏书签侧栏
           *[other] 显示书签侧栏
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] 隐藏书签工具栏
           *[other] 查看书签工具栏
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] 隐藏书签工具栏
           *[other] 显示书签工具栏
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] 从工具栏移除书签菜单
           *[other] 添加书签菜单到工具栏
        }
bookmarks-search =
    .label = 在书签中搜索
bookmarks-tools =
    .label = 书签工具
bookmarks-bookmark-edit-panel =
    .label = 编辑此书签
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = 书签工具栏
    .accesskey = B
    .aria-label = 书签
bookmarks-toolbar-menu =
    .label = 书签工具栏
bookmarks-toolbar-placeholder =
    .title = 书签工具栏项目
bookmarks-toolbar-placeholder-button =
    .label = 书签工具栏项目
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = 将当前标签页加入书签

## Library Panel items

library-bookmarks-menu =
    .label = 书签
library-recent-activity-title =
    .value = 近期动态

## Pocket toolbar button

save-to-pocket-button =
    .label = 保存到 { -pocket-brand-name }
    .tooltiptext = 保存到 { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = 修复文字编码
    .tooltiptext = 根据页面内容猜测正确的文字编码

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = 扩展和主题
    .tooltiptext = 管理您的扩展和主题（{ $shortcut }）
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = 设置
    .tooltiptext =
        { PLATFORM() ->
            [macos] 打开设置（{ $shortcut }）
           *[other] 打开设置
        }

## More items

more-menu-go-offline =
    .label = 脱机工作
    .accesskey = k

## EME notification panel

eme-notifications-drm-content-playing = 此网站的一些音频或视频使用了含数字版权管理（DRM）的软件，这可能会限制 { -brand-short-name } 能让您使用的功能。
eme-notifications-drm-content-playing-manage = 管理设置
eme-notifications-drm-content-playing-manage-accesskey = M
eme-notifications-drm-content-playing-dismiss = 知道了
eme-notifications-drm-content-playing-dismiss-accesskey = D

## Password save/update panel

panel-save-update-username = 用户名
panel-save-update-password = 密码

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = 要移除 { $name } 吗？
addon-removal-abuse-report-checkbox = 向 { -vendor-short-name } 举报此扩展

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = 管理账户
remote-tabs-sync-now = 立即同步
