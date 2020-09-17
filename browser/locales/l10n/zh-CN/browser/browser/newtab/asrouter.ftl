# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = 推荐扩展
cfr-doorhanger-feature-heading = 推荐功能
cfr-doorhanger-pintab-heading = 试试看：固定标签页

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = 为什么我会看到这个？

cfr-doorhanger-extension-cancel-button = 暂时不要
    .accesskey = N

cfr-doorhanger-extension-ok-button = 立刻添加
    .accesskey = A
cfr-doorhanger-pintab-ok-button = 固定此标签页
    .accesskey = P

cfr-doorhanger-extension-manage-settings-button = 管理推荐设置
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = 不再显示此推荐
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = 详细了解

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = 由 { $name } 开发

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = 推荐
cfr-doorhanger-extension-notification2 = 推荐
    .tooltiptext = 推荐扩展
    .a11y-announcement = 有推荐扩展可用

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = 推荐
    .tooltiptext = 推荐功能
    .a11y-announcement = 有推荐功能可用

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
           *[other] { $total } 星
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
       *[other] { $total } 个用户
    }

cfr-doorhanger-pintab-description = 固定常用的网站，就算重启也能快捷打开。

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>右键点击</b>您想要固定的标签页。
cfr-doorhanger-pintab-step2 = 在菜单中选择<b>固定标签页</b>。
cfr-doorhanger-pintab-step3 = 若网站有新动向，固定的标签页上会出现蓝色小点。

cfr-doorhanger-pintab-animation-pause = 暂停
cfr-doorhanger-pintab-animation-resume = 恢复


## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = 把书签随身带着走
cfr-doorhanger-bookmark-fxa-body = 找到好网站了！接下来也把该书签同步至移动设备吧。开始使用 { -fxaccount-brand-name }。
cfr-doorhanger-bookmark-fxa-link-text = 立即同步书签...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = 关闭按钮
    .title = 关闭

## Protections panel

cfr-protections-panel-header = 自由上网，拒绝跟踪
cfr-protections-panel-body = 你的数据只要由你掌握。{ -brand-short-name } 保护您免受众多常见跟踪器对您在线活动的窥视。
cfr-protections-panel-link-text = 详细了解

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = 新功能

cfr-whatsnew-button =
    .label = 新版变化
    .tooltiptext = 新版变化

cfr-whatsnew-panel-header = 新版变化

cfr-whatsnew-release-notes-link-text = 阅读发行说明

cfr-whatsnew-fx70-title = { -brand-short-name } 为您的隐私而战
cfr-whatsnew-fx70-body = 最新的更新增强了跟踪保护功能，并可比以往更容易地让为每个站点创建安全密码。

cfr-whatsnew-tracking-protect-title = 保护自己远离跟踪器
cfr-whatsnew-tracking-protect-body = { -brand-short-name } 拦截了许多会窥视您浏览活动的常见社交和跨网站型跟踪器。
cfr-whatsnew-tracking-protect-link-text = 查看您的报告

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
       *[other] 跟踪器拦截数量
    }
cfr-whatsnew-tracking-blocked-subtitle = 自{ DATETIME($earliestDate, month: "long", year: "numeric") }起
cfr-whatsnew-tracking-blocked-link-text = 查看报告

cfr-whatsnew-lockwise-backup-title = 备份您的密码
cfr-whatsnew-lockwise-backup-body = 立即生成安全密码，并可在您登录的任何设备访问。
cfr-whatsnew-lockwise-backup-link-text = 开启备份

cfr-whatsnew-lockwise-take-title = 随身携带密码
cfr-whatsnew-lockwise-take-body = { -lockwise-brand-short-name } 移动端应用可让您安全地访问在所有设备中备份的密码。
cfr-whatsnew-lockwise-take-link-text = 获取应用

## Search Bar

cfr-whatsnew-searchbar-title = 使用地址栏，输入寥寥，搜遍万千
cfr-whatsnew-searchbar-body-topsites = 现在只需选择地址栏，就会显示包含常用网站链接的下拉框。
cfr-whatsnew-searchbar-icon-alt-text = 放大镜图标

## Picture-in-Picture

cfr-whatsnew-pip-header = 浏览网页的同时看视频
cfr-whatsnew-pip-body = 画中画模式会将视频弹出到浮动窗口中，这样您就可以在浏览其他标签页时继续进行观看。
cfr-whatsnew-pip-cta = 详细了解

## Permission Prompt

cfr-whatsnew-permission-prompt-header = 更少恼人的弹出窗口
cfr-whatsnew-permission-prompt-body = 现在起，{ -brand-shorter-name } 可以自动阻止网站询问您是否可以发送弹出消息的请求。
cfr-whatsnew-permission-prompt-cta = 详细了解

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
       *[other] 已拦截数字指纹跟踪程序
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } 会拦截许多偷偷收集设备信息和操作行为，以针对您投放定向广告的数字指纹跟踪程序。

# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = 数字指纹跟踪程序
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } 可拦截偷偷收集设备信息和操作行为，以针对您投放定向广告的数字指纹跟踪程序。

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = 在手机上获取此书签
cfr-doorhanger-sync-bookmarks-body = 将您的书签、密码、历史记录等数据，同步到登录了{ -brand-product-name }服务的所有设备。
cfr-doorhanger-sync-bookmarks-ok-button = 开启{ -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = 密码不怕再忘
cfr-doorhanger-sync-logins-body = 安全地存储密码，并同步到您的所有设备。
cfr-doorhanger-sync-logins-ok-button = 开启{ -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = 通勤路上再来读
cfr-doorhanger-send-tab-recipe-header = 把这篇食谱带到厨房
cfr-doorhanger-send-tab-body = 标签页发送功能可轻松把网页发到手机上，或是登录了 { -brand-product-name } 的任何设备。
cfr-doorhanger-send-tab-ok-button = 试试标签页发送功能
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = 安全地分享这份 PDF
cfr-doorhanger-firefox-send-body = 端到端加密分享文件，链接到期即焚，确保您敏感文件的安全。
cfr-doorhanger-firefox-send-ok-button = 试用 { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = 看看有哪些保护
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = 关闭
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = 不再显示此类消息
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } 正在防御社交网站对您的跟踪
cfr-doorhanger-socialtracking-description = 隐私是公民的基本权利。现在起，{ -brand-short-name } 会拦截常见的社交媒体跟踪器，限制这些网站收集您的上网活动。
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } 正在拦截此页面上的数字指纹跟踪程序
cfr-doorhanger-fingerprinters-description = 隐私是公民的基本权利。现在起 { -brand-short-name } 会拦截数字指纹跟踪程序，阻止其收集身边设备的唯一识别信息。
cfr-doorhanger-cryptominers-heading = { -brand-short-name } 正在拦截此页面上的加密货币挖矿程序
cfr-doorhanger-cryptominers-description = 隐私是公民的基本权利。现在起 { -brand-short-name } 会拦截加密货币挖矿程序，不让其使用您的计算机算力来“挖”数字货币

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] 自{ $date }起，{ -brand-short-name } 已拦截超过 <b>{ $blockedCount }</b> 个跟踪器！
    }
cfr-doorhanger-milestone-ok-button = 查看全部
    .accesskey = S

cfr-doorhanger-milestone-close-button = 关闭
    .accesskey = C

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = 轻松生成高强度密码
cfr-whatsnew-lockwise-body = 要帮每个账号都创建不重复且安全的密码并不容易。在任何网站上注册账户时，只需点击密码栏，{ -brand-shorter-name } 就可以自动为您生成安全的密码。
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } 图标

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = 当发现密码不安全时收到警报
cfr-whatsnew-passwords-body = 黑客知道人们会重复使用相同密码。若您在多个网站重复使用同一密码，当任一网站发生数据泄露，就会收到 { -lockwise-brand-short-name } 的警报，提醒您尽快更改这些网站的密码。
cfr-whatsnew-passwords-icon-alt = 不安全密码钥匙图标

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = 画中画快速切换全屏
cfr-whatsnew-pip-fullscreen-body = 当您将视频弹出到浮窗时，双击该窗口即可全屏显示。
cfr-whatsnew-pip-fullscreen-icon-alt = 画中画图标

## Protections Dashboard message

cfr-whatsnew-protections-header = 保护信息，一目了然
cfr-whatsnew-protections-body = 保护信息面板包含有关数据外泄和密码管理的摘要报告。现在，您可以跟踪已处理的外泄事件数量，并检查是否有任何存放的密码已遭泄露。
cfr-whatsnew-protections-cta-link = 查看保护信息面板
cfr-whatsnew-protections-icon-alt = 盾牌图标

## Better PDF message

cfr-whatsnew-better-pdf-header = 更佳的 PDF 体验
cfr-whatsnew-better-pdf-body = PDF 文档现可直接在 { -brand-short-name } 中打开，让您的工作流程更顺畅。

## DOH Message

cfr-doorhanger-doh-body = 隐私是公民的基本权利。{ -brand-short-name } 现在会尽可能使用合作伙伴提供的一项服务处理您的 DNS 请求，让您上网更安全。
cfr-doorhanger-doh-header = 更安全、经加密的 DNS 查询
cfr-doorhanger-doh-primary-button = 好，知道了
    .accesskey = O
cfr-doorhanger-doh-secondary-button = 禁用
    .accesskey = D

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = 自动保护，拒绝跟踪
cfr-whatsnew-clear-cookies-body = 有些跟踪器会偷偷将您重定向至设置 Cookie 进行跟踪的网站。{ -brand-short-name } 现在起，会自动清除这些 Cookie 让您不被跟踪。
cfr-whatsnew-clear-cookies-image-alt = 拦截 Cookie 图示
