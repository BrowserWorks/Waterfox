# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = 下载
downloads-panel =
    .aria-label = 下载

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch
downloads-cmd-pause =
    .label = 暂停
    .accesskey = P
downloads-cmd-resume =
    .label = 继续
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = 取消
downloads-cmd-cancel-panel =
    .aria-label = 取消
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = 打开所在文件夹
    .accesskey = F
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = 在 Finder 中显示
    .accesskey = F
downloads-cmd-use-system-default =
    .label = 用系统查看器打开
    .accesskey = V
downloads-cmd-always-use-system-default =
    .label = 一律使用系统查看器打开
    .accesskey = w
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] 在 Finder 中显示
           *[other] 打开所在文件夹
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] 在 Finder 中显示
           *[other] 打开所在文件夹
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] 在 Finder 中显示
           *[other] 打开所在文件夹
        }
downloads-cmd-show-downloads =
    .label = 显示下载文件夹
downloads-cmd-retry =
    .tooltiptext = 重试
downloads-cmd-retry-panel =
    .aria-label = 重试
downloads-cmd-go-to-download-page =
    .label = 转至下载页面
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = 复制下载链接
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = 从历史记录中移除
    .accesskey = e
downloads-cmd-clear-list =
    .label = 清空预览面板
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = 清空下载记录
    .accesskey = D
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = 允许下载
    .accesskey = o
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = 移除文件
downloads-cmd-remove-file-panel =
    .aria-label = 移除文件
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = 移除文件或允许下载
downloads-cmd-choose-unblock-panel =
    .aria-label = 移除文件或允许下载
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = 打开或移除文件
downloads-cmd-choose-open-panel =
    .aria-label = 打开或移除文件
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = 显示详细信息
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = 打开文件
# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = 重试下载
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = 取消下载
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = 显示全部下载
    .accesskey = S
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = 下载详情
downloads-clear-downloads-button =
    .label = 清空下载列表
    .tooltiptext = 清除已完成、已取消及失败的下载项
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = 没有下载记录。
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = 这次浏览期间还未下载文件。
