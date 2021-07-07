# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = 向网站发出“请勿跟踪”信号，示明您不想被跟踪
do-not-track-learn-more = 详细了解
do-not-track-option-default-content-blocking-known =
    .label = 仅当 { -brand-short-name } 设置为拦截已知跟踪器时
do-not-track-option-always =
    .label = 一律发送
settings-page-title = 设置
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = 在设置中查找
managed-notice = 您的浏览器正由组织管理。
category-list =
    .aria-label = 分类
pane-general-title = 常规
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = 主页
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = 搜索
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = 隐私与安全
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title3 = 同步
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = { -brand-short-name } 实验
category-experimental =
    .tooltiptext = { -brand-short-name } 实验
pane-experimental-subtitle = 三思而后行
pane-experimental-search-results-header = { -brand-short-name } 实验：三思而后行
pane-experimental-description2 = 更改高级配置的设置可能会影响 { -brand-short-name } 的性能和安全性。
pane-experimental-reset =
    .label = 恢复默认设置
    .accesskey = R
help-button-label = { -brand-short-name } 帮助
addons-button-label = 扩展和主题
focus-search =
    .key = f
close-button =
    .aria-label = 关闭

## Browser Restart Dialog

feature-enable-requires-restart = 必须重新启动 { -brand-short-name } 才能启用此功能。
feature-disable-requires-restart = 必须重新启动 { -brand-short-name } 才能禁用此功能。
should-restart-title = 重新启动 { -brand-short-name }
should-restart-ok = 立即重启 { -brand-short-name }
cancel-no-restart-button = 取消
restart-later = 稍后重启浏览器

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = 扩展 <img data-l10n-name="icon"/> { $name } 正在控制此设置。
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = 扩展 <img data-l10n-name="icon"/> { $name } 正在控制此设置。
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = 扩展 <img data-l10n-name="icon"/> { $name } 要求启用身份标签页功能。
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = 扩展 <img data-l10n-name="icon"/> { $name } 正在控制此设置。
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = 扩展 <img data-l10n-name="icon"/> { $name } 正在控制 { -brand-short-name } 如何连接互联网。
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = 要启用该扩展，请从 <img data-l10n-name="menu-icon"/> 菜单打开 <img data-l10n-name="addons-icon"/> 附加组件页面。

## Preferences UI Search Results

search-results-header = 搜索结果
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = 很抱歉，没有找到有关“<span data-l10n-name="query"></span>”的设置。
search-results-help-link = 需要帮助？访问 <a data-l10n-name="url">{ -brand-short-name } 技术支持</a>

## General Section

startup-header = 启动
always-check-default =
    .label = 总是检查 { -brand-short-name } 是否是您的默认浏览器
    .accesskey = w
is-default = { -brand-short-name } 目前是您的默认浏览器
is-not-default = { -brand-short-name } 目前不是您的默认浏览器
set-as-my-default-browser =
    .label = 设为默认…
    .accesskey = D
startup-restore-previous-session =
    .label = 恢复先前的浏览状态
    .accesskey = s
startup-restore-windows-and-tabs =
    .label = 打开先前的窗口和标签页
    .accesskey = s
startup-restore-warn-on-quit =
    .label = 退出浏览器时向您确认
disable-extension =
    .label = 禁用扩展
tabs-group-header = 标签页
ctrl-tab-recently-used-order =
    .label = 按下 Ctrl+Tab 时，依照最近使用顺序循环切换标签页
    .accesskey = T
open-new-link-as-tabs =
    .label = 在新标签页中打开链接而非新窗口
    .accesskey = w
warn-on-close-multiple-tabs =
    .label = 关闭多个标签页时向您确认
    .accesskey = m
confirm-on-close-multiple-tabs =
    .label = 关闭多个标签页时向您确认
    .accesskey = m
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (String) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = 按 { $quitKey } 退出时向您确认
    .accesskey = b
warn-on-open-many-tabs =
    .label = 打开多个标签页可能拖慢 { -brand-short-name } 前提醒我
    .accesskey = d
switch-to-new-tabs =
    .label = 新建标签页打开链接、图像、媒体时，立即切换过去
    .accesskey = h
show-tabs-in-taskbar =
    .label = 在 Windows 任务栏上显示标签页预览图
    .accesskey = k
browser-containers-enabled =
    .label = 启用身份标签页
    .accesskey = n
browser-containers-learn-more = 详细了解
browser-containers-settings =
    .label = 设置…
    .accesskey = i
containers-disable-alert-title = 关闭所有身份标签页？
containers-disable-alert-desc =
    { $tabCount ->
        [one] 如果您现在禁用身份标签页，将有 { $tabCount } 个容器标签页被关闭。您确实要禁用身份标签页吗？
       *[other] 如果您现在禁用身份标签页，将有 { $tabCount } 个容器标签页被关闭。您确实要禁用身份标签页吗？
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] 关闭 { $tabCount } 个身份标签页
       *[other] 关闭 { $tabCount } 个身份标签页
    }
containers-disable-alert-cancel-button = 保持启用
containers-remove-alert-title = 移除此身份？
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg = 如果您现在移除此身份，{ $count } 个身份标签页将被关闭。您是否确定移除此身份？
containers-remove-ok-button = 移除此身份
containers-remove-cancel-button = 不移除此身份

## General Section - Language & Appearance

language-and-appearance-header = 语言与外观
fonts-and-colors-header = 字体和颜色
default-font = 默认字体
    .accesskey = D
default-font-size = 字号
    .accesskey = S
advanced-fonts =
    .label = 高级…
    .accesskey = A
colors-settings =
    .label = 颜色…
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = 全局缩放
preferences-default-zoom = 默认缩放
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = 仅缩放文本
    .accesskey = t
language-header = 语言
choose-language-description = 选择您想要优先使用哪种语言显示页面
choose-button =
    .label = 选择…
    .accesskey = o
choose-browser-language-description = 选择 { -brand-short-name } 显示菜单、消息和通知时使用的语言。
manage-browser-languages-button =
    .label = 设置备用语言…
    .accesskey = l
confirm-browser-language-change-description = 重启 { -brand-short-name } 以应用这些更改
confirm-browser-language-change-button = 应用并重启浏览器
translate-web-pages =
    .label = 翻译网页内容
    .accesskey = T
fx-translate-web-pages = { -translations-brand-name }
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = 翻译由 <img data-l10n-name="logo"/> 提供
translate-exceptions =
    .label = 例外…
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = 根据您操作系统的“{ $localeName }”首选项设置日期、时间、数字格式和单位制。
check-user-spelling =
    .label = 在您输入时检查拼写
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = 文件与应用程序
download-header = 下载
download-save-to =
    .label = 保存文件至
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] 选择…
           *[other] 浏览…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }
download-always-ask-where =
    .label = 每次都问您要存到何处
    .accesskey = A
applications-header = 应用程序
applications-description = 选择 { -brand-short-name } 如何处理这些文件。
applications-filter =
    .placeholder = 搜索文件类型或应用程序
applications-type-column =
    .label = 内容类型
    .accesskey = T
applications-action-column =
    .label = 操作
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } 文件
applications-action-save =
    .label = 保存文件
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = 使用 { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = 使用 { $app-name } 处理（默认）
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] 使用 macOS 应用程序
            [windows] 使用 Windows 应用程序
           *[other] 使用系统默认应用程序
        }
applications-use-other =
    .label = 使用其他…
applications-select-helper = 选择助手应用程序
applications-manage-app =
    .label = 应用程序详细信息…
applications-always-ask =
    .label = 每次都问我
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = 使用 { $plugin-name } （在 { -brand-short-name } 中）
applications-open-inapp =
    .label = 在 { -brand-short-name } 中打开

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = 采用数字版权管理（DRM）的内容
play-drm-content =
    .label = 播放采用 DRM 的内容
    .accesskey = P
play-drm-content-learn-more = 详细了解
update-application-title = { -brand-short-name } 更新
update-application-description = 让 { -brand-short-name } 保持最新，持续拥有最强的性能、稳定性和安全性。
update-application-version = 版本: { $version } <a data-l10n-name="learn-more">新版变化</a>
update-history =
    .label = 显示更新历史…
    .accesskey = p
update-application-allow-description = 允许 { -brand-short-name }：
update-application-auto =
    .label = 自动安装更新（推荐）
    .accesskey = A
update-application-check-choose =
    .label = 检查更新，但由您决定是否安装
    .accesskey = C
update-application-manual =
    .label = 不检查更新（不推荐）
    .accesskey = N
update-application-background-enabled =
    .label = 当 { -brand-short-name } 未运行时
    .accesskey = W
update-application-warning-cross-user-setting = 此设置将影响使用这份 { -brand-short-name } 程序的所有 Windows 账户及 { -brand-short-name } 配置文件。
update-application-use-service =
    .label = 使用后台服务静默安装更新
    .accesskey = b
update-setting-write-failure-title2 = 保存“更新”设置时出错
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } 遇到错误，未能保存此更改。请注意，更改此更新设置需要写入下列文件的权限。您或系统管理员可以通过授予用户组对此文件的完全控制权来解决此错误。
    
    无法写入文件：{ $path }
update-in-progress-title = 正在更新
update-in-progress-message = 您要继续 { -brand-short-name } 的此次更新吗？
update-in-progress-ok-button = 放弃
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = 继续

## General Section - Performance

performance-title = 性能
performance-use-recommended-settings-checkbox =
    .label = 使用推荐的性能设置
    .accesskey = U
performance-use-recommended-settings-desc = 自动选择适合此计算机配置的设置。
performance-settings-learn-more = 详细了解
performance-allow-hw-accel =
    .label = 自动启用硬件加速
    .accesskey = r
performance-limit-content-process-option = 内容进程限制
    .accesskey = L
performance-limit-content-process-enabled-desc = 调高内容进程数量可以改善使用多个标签页时的性能，但也将消耗更多内存。
performance-limit-content-process-blocked-desc = 仅在多进程 { -brand-short-name } 时可修改进程数量。 <a data-l10n-name="learn-more">了解如何检查多进程的启用状况</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (默认)

## General Section - Browsing

browsing-title = 浏览
browsing-use-autoscroll =
    .label = 使用自动滚屏
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = 使用平滑滚动
    .accesskey = m
browsing-use-onscreen-keyboard =
    .label = 在需要时显示触摸键盘
    .accesskey = k
browsing-use-cursor-navigation =
    .label = 一律使用键盘方向键浏览网页（键盘浏览模式）
    .accesskey = c
browsing-search-on-start-typing =
    .label = 若在文本框外输入，则在页面中查找文本
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = 启用画中画视频控件
    .accesskey = E
browsing-picture-in-picture-learn-more = 详细了解
browsing-media-control =
    .label = 通过键盘、耳机或虚拟界面控制媒体
    .accesskey = v
browsing-media-control-learn-more = 详细了解
browsing-cfr-recommendations =
    .label = 在您浏览时推荐扩展
    .accesskey = R
browsing-cfr-features =
    .label = 在您浏览时推荐新功能
    .accesskey = f
browsing-cfr-recommendations-learn-more = 详细了解

## General Section - Proxy

network-settings-title = 网络设置
network-proxy-connection-description = 配置 { -brand-short-name } 如何连接互联网。
network-proxy-connection-learn-more = 详细了解
network-proxy-connection-settings =
    .label = 设置…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = 新窗口和标签页
home-new-windows-tabs-description2 = 选择您打开主页、新窗口和新标签页时要看到的内容。

## Home Section - Home Page Customization

home-homepage-mode-label = 主页和新窗口
home-newtabs-mode-label = 新标签页
home-restore-defaults =
    .label = 恢复默认设置
    .accesskey = R
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Waterfox 主页（默认）
home-mode-choice-custom =
    .label = 自定义网址…
home-mode-choice-blank =
    .label = 空白页
home-homepage-custom-url =
    .placeholder = 粘贴一个网址…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] 使用当前页面
           *[other] 使用当前所有页面
        }
    .accesskey = C
choose-bookmark =
    .label = 使用书签…
    .accesskey = B

## Home Section - Waterfox Home Content Customization

home-prefs-content-header = Waterfox 主页内容
home-prefs-content-description = 选择要在您的 Waterfox 主页上显示的版块。
home-prefs-search-header =
    .label = 网络搜索
home-prefs-topsites-header =
    .label = 常用网站
home-prefs-topsites-description = 您经常访问的网站
home-prefs-topsites-by-option-sponsored =
    .label = 赞助商网站
home-prefs-shortcuts-header =
    .label = 快捷方式
home-prefs-shortcuts-description = 您保存或访问过的网站
home-prefs-shortcuts-by-option-sponsored =
    .label = 赞助商网站

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = { $provider } 推荐
home-prefs-recommended-by-description-update = 由 { $provider } 整理提供的网络精选内容
home-prefs-recommended-by-description-new = 由 { -brand-product-name } 旗下 { $provider } 策划的特别内容

##

home-prefs-recommended-by-learn-more = 使用方法
home-prefs-recommended-by-option-sponsored-stories =
    .label = 赞助内容
home-prefs-highlights-header =
    .label = 集锦
home-prefs-highlights-description = 您访问过或保存过的网站精选
home-prefs-highlights-option-visited-pages =
    .label = 访问过的页面
home-prefs-highlights-options-bookmarks =
    .label = 书签
home-prefs-highlights-option-most-recent-download =
    .label = 最近下载
home-prefs-highlights-option-saved-to-pocket =
    .label = 保存在 { -pocket-brand-name } 的页面
home-prefs-recent-activity-header =
    .label = 近期动态
home-prefs-recent-activity-description = 近期访问的网站与内容精选
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = 只言片语
home-prefs-snippets-description = 来自 { -vendor-short-name } 和 { -brand-product-name } 的快讯
home-prefs-snippets-description-new = 来自 { -vendor-short-name } 和 { -brand-product-name } 的使用窍门与快讯
home-prefs-sections-rows-option =
    .label = { $num } 行

## Search Section

search-bar-header = 搜索栏
search-bar-hidden =
    .label = 使用地址栏完成搜索和访问
search-bar-shown =
    .label = 添加搜索栏到工具栏
search-engine-default-header = 默认搜索引擎
search-engine-default-desc-2 = 这是地址栏和搜索栏中的默认搜索引擎，您可以随时切换。
search-engine-default-private-desc-2 = 为隐私窗口选择不同的默认搜索引擎
search-separate-default-engine =
    .label = 在隐私窗口中使用此搜索引擎
    .accesskey = U
search-suggestions-header = 搜索建议
search-suggestions-desc = 选择搜索引擎建议的呈现方式。
search-suggestions-option =
    .label = 提供搜索建议
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = 在地址栏结果中显示搜索建议
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = 在地址栏显示的结果中，将搜索建议显示在浏览历史上方
search-show-suggestions-private-windows =
    .label = 在隐私窗口中显示搜索建议
suggestions-addressbar-settings-generic2 = 更改其他地址栏建议设置
search-suggestions-cant-show = 由于您已经设置 { -brand-short-name } 不要记住浏览历史，地址栏中将不会显示搜索建议。
search-one-click-header2 = 快捷搜索
search-one-click-desc = 请选择在地址栏和搜索栏输入关键词时，您希望显示在下方的其他可选用的搜索引擎。
search-choose-engine-column =
    .label = 搜索引擎
search-choose-keyword-column =
    .label = 关键词
search-restore-default =
    .label = 恢复默认搜索引擎
    .accesskey = d
search-remove-engine =
    .label = 移除
    .accesskey = R
search-add-engine =
    .label = 添加
    .accesskey = A
search-find-more-link = 寻找更多搜索引擎
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = 关键词重复
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = 您选择的关键词已用于“{ $name }”，请换一个。
search-keyword-warning-bookmark = 您选择的关键词已用于某个书签，请换一个。

## Containers Section

containers-back-button2 =
    .aria-label = 回到设置
containers-header = 身份标签页
containers-add-button =
    .label = 添加新身份
    .accesskey = A
containers-new-tab-check =
    .label = 每次新建标签页时选择身份
    .accesskey = S
containers-settings-button =
    .label = 设置
containers-remove-button =
    .label = 移除

## Waterfox Account - Signed out. Note that "Sync" and "Waterfox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = 让您个性化的网络体验随身相伴
sync-signedout-description2 = 在您的各种设备间同步您的书签、历史记录、标签页、密码、附加组件与设置。
sync-signedout-account-signin3 =
    .label = 登录同步服务…
    .accesskey = i
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = 在 <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> 或者 <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a> 上安装 Waterfox，让您的个性体验随身相伴。

## Waterfox Account - Signed in

sync-profile-picture =
    .tooltiptext = 更改头像
sync-sign-out =
    .label = 退出登录…
    .accesskey = g
sync-manage-account = 管理账户
    .accesskey = o
sync-signedin-unverified = { $email } 未验证。
sync-signedin-login-failure = 请登录以重新绑定 { $email }
sync-resend-verification =
    .label = 重发验证邮件
    .accesskey = d
sync-remove-account =
    .label = 移除账号
    .accesskey = p
sync-sign-in =
    .label = 登录
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = 同步：开启
prefs-syncing-off = 同步：关闭
prefs-sync-turn-on-syncing =
    .label = 正在开启同步...
    .accesskey = s
prefs-sync-offer-setup-label2 = 在您的各种设备间同步您的书签、历史记录、标签页、密码、附加组件与设置。
prefs-sync-now =
    .labelnotsyncing = 立即同步
    .accesskeynotsyncing = N
    .labelsyncing = 正在同步...

## The list of things currently syncing.

sync-currently-syncing-heading = 您当前正在同步以下项目：
sync-currently-syncing-bookmarks = 书签
sync-currently-syncing-history = 历史记录
sync-currently-syncing-tabs = 打开的标签页
sync-currently-syncing-logins-passwords = 登录名和密码
sync-currently-syncing-addresses = 邮政地址
sync-currently-syncing-creditcards = 信用卡
sync-currently-syncing-addons = 附加组件
sync-currently-syncing-settings = 设置
sync-change-options =
    .label = 更改…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = 选择要同步的项目
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = 保存更改
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = 断开连接…
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = 书签
    .accesskey = m
sync-engine-history =
    .label = 历史记录
    .accesskey = r
sync-engine-tabs =
    .label = 打开的标签页
    .tooltiptext = 已同步的所有设备目前打开什么
    .accesskey = T
sync-engine-logins-passwords =
    .label = 登录名和密码
    .tooltiptext = 您存入的用户名和密码
    .accesskey = L
sync-engine-addresses =
    .label = 邮政地址
    .tooltiptext = 您已保存的邮政地址（仅限桌面版）
    .accesskey = e
sync-engine-creditcards =
    .label = 信用卡
    .tooltiptext = 姓名、号码、有效期限（仅限桌面版）
    .accesskey = C
sync-engine-addons =
    .label = 附加组件
    .tooltiptext = 用于 Waterfox 桌面版的扩展和主题
    .accesskey = A
sync-engine-settings =
    .label = 设置
    .tooltiptext = 您更改过的常规、隐私与安全等设置
    .accesskey = s

## The device name controls.

sync-device-name-header = 设备名称
sync-device-name-change =
    .label = 更改设备名称…
    .accesskey = h
sync-device-name-cancel =
    .label = 取消
    .accesskey = n
sync-device-name-save =
    .label = 保存
    .accesskey = v
sync-connect-another-device = 绑定其他设备

## Privacy Section

privacy-header = 浏览器隐私

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = 登录信息与密码
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = 向您询问是否保存网站的登录名和密码
    .accesskey = r
forms-exceptions =
    .label = 例外…
    .accesskey = x
forms-generate-passwords =
    .label = 建议并生成高强度密码
    .accesskey = u
forms-breach-alerts =
    .label = 显示有关网站密码外泄的提醒
    .accesskey = b
forms-breach-alerts-learn-more-link = 详细了解
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = 自动填写登录名和密码
    .accesskey = i
forms-saved-logins =
    .label = 已保存的登录信息…
    .accesskey = L
forms-primary-pw-use =
    .label = 使用主密码
    .accesskey = U
forms-primary-pw-learn-more-link = 详细了解
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = 修改主密码…
    .accesskey = M
forms-primary-pw-change =
    .label = 更改主密码…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = 您正处于 FIPS 模式。该模式需要一个非空的主密码。
forms-master-pw-fips-desc = 密码修改失败
forms-windows-sso =
    .label = 允许面向 Microsoft 账户（个人/工作/学校）的 Windows 单点登录
forms-windows-sso-learn-more-link = 详细了解
forms-windows-sso-desc = 在您的设备设置中管理账户

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = 请输入 Windows 登录凭据，以创建主密码。这有助于保护您的账户安全。
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = 创建主密码
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = 历史记录
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = { -brand-short-name } 将
    .accesskey = w
history-remember-option-all =
    .label = 记录历史
history-remember-option-never =
    .label = 不记录历史
history-remember-option-custom =
    .label = 使用自定义设置
history-remember-description = { -brand-short-name } 将记住您的浏览、下载、表单和搜索记录。
history-dontremember-description = { -brand-short-name } 将采用与“隐私浏览模式”相同的设置，不会记录您浏览网络的历史。
history-private-browsing-permanent =
    .label = 一律使用隐私浏览模式
    .accesskey = p
history-remember-browser-option =
    .label = 记住浏览和下载历史
    .accesskey = b
history-remember-search-option =
    .label = 记住搜索和表单历史
    .accesskey = f
history-clear-on-close-option =
    .label = 在 { -brand-short-name } 关闭时清除历史记录
    .accesskey = r
history-clear-on-close-settings =
    .label = 设置…
    .accesskey = t
history-clear-button =
    .label = 清除历史记录…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = Cookie 和网站数据
sitedata-total-size-calculating = 正在计算网站数据和缓存的大小…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = 您已存储的 Cookie、网站数据和缓存目前使用了 { $value } { $unit } 磁盘空间。
sitedata-learn-more = 详细了解
sitedata-delete-on-close =
    .label = 关闭 { -brand-short-name } 时删除 Cookie 与网站数据
    .accesskey = C
sitedata-delete-on-close-private-browsing = 永久启用隐私浏览模式后，每次关闭 { -brand-short-name } 时都会清除 Cookie 和网站数据。
sitedata-allow-cookies-option =
    .label = 接受 Cookie 和网站数据
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = 阻止 Cookie 和网站数据
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = 阻止类型
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = 跨网站跟踪器
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = 跨网站和社交媒体跟踪器
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = 跨网站跟踪型 Cookie — 包括社交媒体跟踪器
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = 跨网站 Cookie — 包括社交媒体跟踪器
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = 跨网站和社交媒体跟踪器，并隔离其余的 Cookie
sitedata-option-block-unvisited =
    .label = 未访问网站的 Cookie
sitedata-option-block-all-third-party =
    .label = 所有第三方 Cookie（可能导致网站异常）
sitedata-option-block-all =
    .label = 所有 Cookie（将会导致网站异常）
sitedata-clear =
    .label = 清除数据…
    .accesskey = l
sitedata-settings =
    .label = 管理数据…
    .accesskey = M
sitedata-cookies-exceptions =
    .label = 管理例外…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = 地址栏
addressbar-suggest = 使用地址栏时，为我建议：
addressbar-locbar-history-option =
    .label = 浏览历史
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = 书签
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = 打开的标签页
    .accesskey = O
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = 快捷方式
    .accesskey = S
addressbar-locbar-topsites-option =
    .label = 常用网站
    .accesskey = T
addressbar-locbar-engines-option =
    .label = 搜索引擎
    .accesskey = a
addressbar-suggestions-settings = 更改搜索引擎建议的首选项

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = 增强型跟踪保护
content-blocking-section-top-level-description = 跟踪器会跟踪您的在线活动，收集您的浏览习惯与兴趣爱好。{ -brand-short-name } 可拦截众多跟踪器和其他恶意脚本。
content-blocking-learn-more = 详细了解
content-blocking-fpi-incompatibility-warning = 您已启用第一方隔离（FPI）功能，会覆盖 { -brand-short-name } 的某些 Cookie 设置。

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = 标准
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = 严格
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = 自定义
    .accesskey = C

##

content-blocking-etp-standard-desc = 平衡保护和性能。页面将正常加载。
content-blocking-etp-strict-desc = 更强大的保护，但可能导致某些网站异常。
content-blocking-etp-custom-desc = 选择要拦截的跟踪器和脚本。
content-blocking-etp-blocking-desc = { -brand-short-name } 拦截下列项目：
content-blocking-private-windows = 隐私窗口中的跟踪性内容
content-blocking-cross-site-cookies-in-all-windows = 所有窗口中的跨网站 Cookie（包括跟踪性 Cookie）
content-blocking-cross-site-tracking-cookies = 跨网站跟踪性 Cookie
content-blocking-all-cross-site-cookies-private-windows = 隐私窗口中的跨网站 Cookie
content-blocking-cross-site-tracking-cookies-plus-isolate = 跨网站跟踪性 Cookie，并隔离其余的 Cookie
content-blocking-social-media-trackers = 社交媒体跟踪器
content-blocking-all-cookies = 所有 Cookie
content-blocking-unvisited-cookies = 未访问网站的 Cookie
content-blocking-all-windows-tracking-content = 所有窗口中的跟踪性内容
content-blocking-all-third-party-cookies = 所有第三方 Cookie
content-blocking-cryptominers = 加密货币挖矿程序
content-blocking-fingerprinters = 数字指纹跟踪程序
content-blocking-warning-title = 注意！
content-blocking-and-isolating-etp-warning-description = 拦截跟踪器并隔离 Cookie 可能会影响某些网站的功能。放行跟踪器，刷新页面即可加载所有内容。
content-blocking-and-isolating-etp-warning-description-2 = 此设置可能会导致某些网站无法显示内容或正常工作。若网站异常，则可能需要对该网站关闭跟踪保护功能，以加载全部内容。
content-blocking-warning-learn-how = 了解要如何做
content-blocking-reload-description = 需要重新载入标签页才能应用变更。
content-blocking-reload-tabs-button =
    .label = 重新载入所有标签页
    .accesskey = R
content-blocking-tracking-content-label =
    .label = 跟踪性内容
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = 所有窗口
    .accesskey = A
content-blocking-option-private =
    .label = 仅在隐私窗口中
    .accesskey = p
content-blocking-tracking-protection-change-block-list = 更换拦截列表
content-blocking-cookies-label =
    .label = Cookie
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = 详细信息
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = 加密货币挖矿程序
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = 数字指纹跟踪程序
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = 管理例外…
    .accesskey = x

## Privacy Section - Permissions

permissions-header = 权限
permissions-location = 位置
permissions-location-settings =
    .label = 设置…
    .accesskey = l
permissions-xr = 虚拟现实
permissions-xr-settings =
    .label = 设置…
    .accesskey = t
permissions-camera = 摄像头
permissions-camera-settings =
    .label = 设置…
    .accesskey = c
permissions-microphone = 麦克风
permissions-microphone-settings =
    .label = 设置…
    .accesskey = m
permissions-notification = 通知
permissions-notification-settings =
    .label = 设置…
    .accesskey = n
permissions-notification-link = 详细了解
permissions-notification-pause =
    .label = 暂停通知直至下次打开 { -brand-short-name }
    .accesskey = n
permissions-autoplay = 自动播放
permissions-autoplay-settings =
    .label = 设置…
    .accesskey = t
permissions-block-popups =
    .label = 阻止弹出式窗口
    .accesskey = B
permissions-block-popups-exceptions =
    .label = 例外…
    .accesskey = E
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = 例外…
    .accesskey = e
    .searchkeywords = popups 彈出 視窗
permissions-addon-install-warning =
    .label = 当网站尝试安装附加组件时警告您
    .accesskey = W
permissions-addon-exceptions =
    .label = 例外…
    .accesskey = E

## Privacy Section - Data Collection

collection-header = { -brand-short-name } 数据收集与使用
collection-description = 我们力图为您提供选择权，并保证只收集我们为众人提供和改进 { -brand-short-name } 所需的信息。我们仅在征得您的同意后接收个人信息。
collection-privacy-notice = 隐私声明
collection-health-report-telemetry-disabled = 您不再允许 { -vendor-short-name } 捕获技术和交互数据。过去收集的所有数据将在 30 天内删除。
collection-health-report-telemetry-disabled-link = 详细了解
collection-health-report =
    .label = 允许 { -brand-short-name } 向 { -vendor-short-name } 发送技术信息及交互数据
    .accesskey = r
collection-health-report-link = 详细了解
collection-studies =
    .label = 允许 { -brand-short-name } 安装并运行一些实验项目
collection-studies-link = 查看 { -brand-short-name } 在进行的实验
addon-recommendations =
    .label = 允许 { -brand-short-name } 提供个性化扩展推荐
addon-recommendations-link = 详细了解
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = 在此构建配置下数据反馈被禁用
collection-backlogged-crash-reports-with-link = 允许 { -brand-short-name } 代您发送积压的崩溃报告 <a data-l10n-name="crash-reports-link">详细了解</a>
    .accesskey = c

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = 安全
security-browsing-protection = 欺诈内容和危险软件防护
security-enable-safe-browsing =
    .label = 拦截危险与诈骗内容
    .accesskey = B
security-enable-safe-browsing-link = 详细了解
security-block-downloads =
    .label = 拦截危险的下载项
    .accesskey = D
security-block-uncommon-software =
    .label = 发现流氓软件或罕见软件时发出警告
    .accesskey = C

## Privacy Section - Certificates

certs-header = 证书
certs-enable-ocsp =
    .label = 查询 OCSP 响应服务器，以确认证书当前是否有效
    .accesskey = Q
certs-view =
    .label = 查看证书…
    .accesskey = C
certs-devices =
    .label = 安全设备…
    .accesskey = D
space-alert-over-5gb-settings-button =
    .label = 打开设置
    .accesskey = O
space-alert-over-5gb-message2 = <strong>{ -brand-short-name } 运行所需的磁盘空间不足。</strong>网站内容可能无法正常显示。您可以在 设置 > 隐私与安全 > Cookie 和网站数据 中清除已存储的数据。
space-alert-under-5gb-message2 = <strong>{ -brand-short-name } 运行所需的磁盘空间不足。</strong>网站内容可能无法正常显示。点击“详细了解”了解如何优化您的磁盘空间，从而获得更好的浏览体验。

## Privacy Section - HTTPS-Only

httpsonly-header = HTTPS-Only 模式
httpsonly-description = HTTPS 可在 { -brand-short-name } 和您访问的网站之间提供安全、加密的连接。现今，大多数网站都支持 HTTPS，若选择启用 HTTPS-Only 模式，{ -brand-short-name } 将会升级所有连接为 HTTPS。
httpsonly-learn-more = 详细了解
httpsonly-radio-enabled =
    .label = 在所有窗口启用 HTTPS-Only 模式
httpsonly-radio-enabled-pbm =
    .label = 仅在隐私窗口启用 HTTPS-Only 模式
httpsonly-radio-disabled =
    .label = 不启用 HTTPS-Only 模式

## The following strings are used in the Download section of settings

desktop-folder-name = 桌面
downloads-folder-name = 下载
choose-download-folder-title = 选择下载文件夹：
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = 保存文件至 { $service-name }
