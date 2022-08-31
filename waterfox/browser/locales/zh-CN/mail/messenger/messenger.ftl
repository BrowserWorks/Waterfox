# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Window controls

messenger-window-minimize-button =
    .tooltiptext = 最小化
messenger-window-maximize-button =
    .tooltiptext = 最大化
messenger-window-restore-down-button =
    .tooltiptext = 向下还原
messenger-window-close-button =
    .tooltiptext = 关闭
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
menu-file-save-as-file =
    .label = 文件…
    .accesskey = F

## AppMenu

appmenu-save-as-file =
    .label = 文件…
appmenu-settings =
    .label = 设置
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
mail-context-delete-messages =
    .label =
        { $count ->
           *[other] 删除选择的消息？
        }
context-menu-decrypt-to-folder =
    .label = 复制解密消息到
    .accesskey = y

## Message header pane

other-action-redirect-msg =
    .label = 重定向
message-header-msg-flagged =
    .title = 已加星标
    .aria-label = 已加星标
message-header-msg-not-flagged =
    .title = 非星标邮件
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = { $address } 的头像。

## Message header cutomize panel

message-header-customize-panel-title = 消息标题设置
message-header-customize-button-style =
    .value = 按钮样式
    .accesskey = B
message-header-button-style-default =
    .label = 图标和文本
message-header-button-style-text =
    .label = 文本
message-header-button-style-icons =
    .label = 图标
message-header-show-recipient-avatar =
    .label = 显示发件人头像
    .accesskey = p
message-header-hide-label-column =
    .label = 隐藏标签列
    .accesskey = I
message-header-large-subject =
    .label = 放大主题
    .accesskey = s

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = 管理扩展
    .accesskey = E
toolbar-context-menu-remove-extension =
    .label = 移除扩展
    .accesskey = v

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

## no-reply handling

no-reply-title = 不支持回复
no-reply-message = 邮件的回复地址（{ $email }）看起来不像是有人会收件的地址。发送到此地址的邮件，不大可能被人阅读。
no-reply-reply-anyway-button = 仍然回复

## error messages

decrypt-and-copy-failures = 共计 { $total } 条消息，有 { $failures } 条因解密失败而未复制。

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = 侧工具栏
    .aria-label = 侧工具栏
    .aria-description = 用于切换各种功能的垂直工具栏（支持方向键）。
spaces-toolbar-button-mail2 =
    .title = 邮件
spaces-toolbar-button-address-book2 =
    .title = 通讯录
spaces-toolbar-button-calendar2 =
    .title = 日历
spaces-toolbar-button-tasks2 =
    .title = 任务
spaces-toolbar-button-chat2 =
    .title = 聊天
spaces-toolbar-button-overflow =
    .title = 更多按钮…
spaces-toolbar-button-settings2 =
    .title = 设置
spaces-toolbar-button-hide =
    .title = 隐藏侧工具栏
spaces-toolbar-button-show =
    .title = 显示侧工具栏
spaces-context-new-tab-item =
    .label = 新建标签页打开
spaces-context-new-window-item =
    .label = 新建窗口打开
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = 切换到 { $tabName }
settings-context-open-settings-item2 =
    .label = 设置
settings-context-open-account-settings-item2 =
    .label = 账户设置
settings-context-open-addons-item2 =
    .label = 扩展和主题

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = 打开侧工具菜单
spaces-pinned-button-menuitem-mail =
    .label = { spaces-toolbar-button-mail.title }
spaces-pinned-button-menuitem-address-book =
    .label = { spaces-toolbar-button-address-book.title }
spaces-pinned-button-menuitem-calendar =
    .label = { spaces-toolbar-button-calendar.title }
spaces-pinned-button-menuitem-tasks =
    .label = { spaces-toolbar-button-tasks.title }
spaces-pinned-button-menuitem-chat =
    .label = { spaces-toolbar-button-chat.title }
spaces-pinned-button-menuitem-settings =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-show =
    .label = { spaces-toolbar-button-show.title }
# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title =
        { $count ->
           *[other] { $count } 条未读消息
        }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = 定制…
spaces-customize-panel-title = 侧工具栏设置
spaces-customize-background-color = 背景颜色
spaces-customize-icon-color = 按钮颜色
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = 选定按钮的背景颜色
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = 选定按钮的颜色
spaces-customize-button-restore = 恢复默认设置
    .accesskey = R
customize-panel-button-save = 完成
    .accesskey = D
