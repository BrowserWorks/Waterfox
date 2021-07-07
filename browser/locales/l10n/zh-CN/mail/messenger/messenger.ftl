# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
       *[other] { $count } 条未读消息
    }
about-rights-notification-text = { -brand-short-name } 是一款自由且开源的软件，由来自世界各地数千位成员组成的社区所构建。

## Content tabs

content-tab-page-loading-icon =
    .alt = 页面加载中
content-tab-security-high-icon =
    .alt = 连接是安全的
content-tab-security-broken-icon =
    .alt = 连接不安全

## Toolbar

addons-and-themes-button =
    .label = 扩展和主题
    .tooltip = 管理您的附加组件
addons-and-themes-toolbarbutton =
    .label = 扩展和主题
    .tooltiptext = 管理您的附加组件
quick-filter-toolbarbutton =
    .label = 快速筛选
    .tooltiptext = 筛选消息
redirect-msg-button =
    .label = 重定向
    .tooltiptext = 将选择的消息重定向

## Folder Pane

folder-pane-toolbar =
    .toolbarname = 文件夹窗格工具栏
    .accesskey = F
folder-pane-toolbar-options-button =
    .tooltiptext = 文件夹窗格选项
folder-pane-header-label = 文件夹

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = 隐藏工具栏
    .accesskey = H
show-all-folders-label =
    .label = 全部文件夹
    .accesskey = A
show-unread-folders-label =
    .label = 未读文件夹
    .accesskey = n
show-favorite-folders-label =
    .label = 收藏夹
    .accesskey = F
show-smart-folders-label =
    .label = 统一文件夹
    .accesskey = U
show-recent-folders-label =
    .label = 最近文件夹
    .accesskey = R
folder-toolbar-toggle-folder-compact-view =
    .label = 紧凑模式
    .accesskey = C

## Menu

redirect-msg-menuitem =
    .label = 重定向
    .accesskey = D

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = 首选项
appmenu-addons-and-themes =
    .label = 扩展和主题
appmenu-help-enter-troubleshoot-mode =
    .label = 排障模式…
appmenu-help-exit-troubleshoot-mode =
    .label = 关闭故障排除模式
appmenu-help-more-troubleshooting-info =
    .label = 更多排障信息
appmenu-redirect-msg =
    .label = 重定向

## Context menu

context-menu-redirect-msg =
    .label = 重定向

## Message header pane

other-action-redirect-msg =
    .label = 重定向

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = 管理扩展
    .accesskey = E
toolbar-context-menu-remove-extension =
    .label = 移除扩展
    .accesskey = v

## Message headers

message-header-address-in-address-book-icon =
    .alt = 在通讯录中的地址
message-header-address-not-in-address-book-icon =
    .alt = 不在通讯录中的地址

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = 要移除 { $name } 吗？
addon-removal-confirmation-button = 移除
addon-removal-confirmation-message = 要从 { -brand-short-name } 中移除 { $name } 及其配置和数据吗？
caret-browsing-prompt-title = 光标浏览
caret-browsing-prompt-text = 按 F7 来启用或禁用光标浏览。此功能将在某些内容中放置一个可移动的光标，以便您能使用键盘选择文本。您想要启用光标浏览吗？
caret-browsing-prompt-check-text = 不再询问。
repair-text-encoding-button =
    .label = 修复文字编码
    .tooltiptext = 根据消息内容猜测正确的文字编码
