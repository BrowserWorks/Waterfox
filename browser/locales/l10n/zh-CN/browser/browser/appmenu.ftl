# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = 正在下载 { -brand-shorter-name } 更新
    .label-update-available = 有可用更新 — 立即下载
    .label-update-manual = 有可用更新 — 立即下载
    .label-update-unsupported = 无法更新 — 系统不兼容
    .label-update-restart = 有可用更新 — 立即重启
appmenuitem-protection-dashboard-title = 保护信息面板
appmenuitem-customize-mode =
    .label = 定制…

## Zoom Controls

appmenuitem-new-tab =
    .label = 新建标签页
appmenuitem-new-window =
    .label = 新建窗口
appmenuitem-new-private-window =
    .label = 新建隐私窗口
appmenuitem-passwords =
    .label = 密码
appmenuitem-addons-and-themes =
    .label = 扩展和主题
appmenuitem-find-in-page =
    .label = 在页面中查找…
appmenuitem-more-tools =
    .label = 更多工具
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] 退出
           *[other] 退出
        }
appmenu-menu-button-closed2 =
    .tooltiptext = 打开应用程序菜单
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = 关闭应用程序菜单
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = 设置

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = 放大
appmenuitem-zoom-reduce =
    .label = 缩小
appmenuitem-fullscreen =
    .label = 全屏

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = 立即同步
appmenu-remote-tabs-sign-into-sync =
    .label = 登录以同步…
appmenu-remote-tabs-turn-on-sync =
    .label = 开启同步…
appmenuitem-fxa-toolbar-sync-now2 = 立即同步
appmenuitem-fxa-manage-account = 管理账户
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = 上次同步：{ $time }
    .label = 上次同步：{ $time }
appmenu-fxa-sync-and-save-data2 = 同步并保存数据
appmenu-fxa-signed-in-label = 登录
appmenu-fxa-setup-sync =
    .label = 开启同步...
appmenu-fxa-show-more-tabs = 显示更多标签页
appmenuitem-save-page =
    .label = 另存页面为…

## What's New panel in App menu.

whatsnew-panel-header = 新版变化
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = 有新功能推出时通知我
    .accesskey = f

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = 展示更多信息
profiler-popup-description-title =
    .value = 记录、分析、共享
profiler-popup-description = 与您的团队共享性能测量信息，协作解决性能问题。
profiler-popup-learn-more = 详细了解
profiler-popup-settings =
    .value = 设置
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = 编辑设置…
profiler-popup-disabled = 分析器当前已禁用，可能是因为打开了隐私浏览窗口。
profiler-popup-recording-screen = 正在记录…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = 自定义
profiler-popup-start-recording-button =
    .label = 开始记录
profiler-popup-discard-button =
    .label = 丢弃
profiler-popup-capture-button =
    .label = 捕捉
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## History panel

appmenu-manage-history =
    .label = 管理历史
appmenu-reopen-all-tabs = 重新打开所有标签页
appmenu-reopen-all-windows = 重新打开所有窗口
appmenu-restore-session =
    .label = 恢复先前的浏览状态
appmenu-clear-history =
    .label = 清除最近的历史记录…
appmenu-recent-history-subheader = 近期历史记录
appmenu-recently-closed-tabs =
    .label = 最近关闭的标签页
appmenu-recently-closed-windows =
    .label = 最近关闭的窗口

## Help panel

appmenu-help-header =
    .title = { -brand-shorter-name } 帮助
appmenu-about =
    .label = 关于 { -brand-shorter-name }
    .accesskey = A
appmenu-get-help =
    .label = 获取帮助
    .accesskey = H
appmenu-help-more-troubleshooting-info =
    .label = 更多排障信息
    .accesskey = T
appmenu-help-report-site-issue =
    .label = 反馈网站问题…
appmenu-help-feedback-page =
    .label = 提交反馈…
    .accesskey = S

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = 排障模式…
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = 关闭排障模式
    .accesskey = M

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = 举报诈骗网站…
    .accesskey = D
appmenu-help-not-deceptive =
    .label = 这不是诈骗网站…
    .accesskey = d

## More Tools

appmenu-customizetoolbar =
    .label = 定制工具栏…
appmenu-taskmanager =
    .label = 任务管理器
appmenu-developer-tools-subheader = 浏览器工具
appmenu-developer-tools-extensions =
    .label = 面向开发者的扩展
