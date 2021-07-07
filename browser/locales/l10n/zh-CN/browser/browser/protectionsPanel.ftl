# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = 发送反馈时发生错误，请稍后再试。
# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = 网站已修复？发送反馈

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = 严格
    .label = 严格
protections-popup-footer-protection-label-custom = 自定义
    .label = 自定义
protections-popup-footer-protection-label-standard = 标准
    .label = 标准

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = 关于增强型跟踪保护功能的更多信息
protections-panel-etp-on-header = 此网站已开启增强型跟踪保护
protections-panel-etp-off-header = 此网站已关闭增强型跟踪保护
# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = 网站不正常？
# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = 网站不正常？

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = 为什么？
protections-panel-not-blocking-why-etp-on-tooltip = 拦截这些内容可能导致某些网站上的元素异常。若无跟踪器，某些按钮、表单、登录栏可能无法正常工作。
protections-panel-not-blocking-why-etp-off-tooltip = 隐私保护处于关闭状态，已载入此网站的所有跟踪器。

##

protections-panel-no-trackers-found = 此页面上未检测到 { -brand-short-name } 已知的跟踪器。
protections-panel-content-blocking-tracking-protection = 跟踪性内容
protections-panel-content-blocking-socialblock = 社交媒体跟踪器
protections-panel-content-blocking-cryptominers-label = 加密货币挖矿程序
protections-panel-content-blocking-fingerprinters-label = 数字指纹跟踪程序

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = 已拦截
protections-panel-not-blocking-label = 已允许
protections-panel-not-found-label = 未检测到

##

protections-panel-settings-label = 保护设置
protections-panel-protectionsdashboard-label = 保护信息面板

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = 若您遇到以下方面的问题，请先关闭保护：
# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = 登录栏
protections-panel-site-not-working-view-issue-list-forms = 表单
protections-panel-site-not-working-view-issue-list-payments = 支付
protections-panel-site-not-working-view-issue-list-comments = 评论
protections-panel-site-not-working-view-issue-list-videos = 视频
protections-panel-site-not-working-view-send-report = 发送反馈

##

protections-panel-cross-site-tracking-cookies = 这些 Cookie 由第三方广告商或分析公司设置，能够在不同网站间跟踪您，以收集您的在线活动数据。
protections-panel-cryptominers = 加密货币挖矿程序使用您的计算机算力来“挖”数字货币，耗尽您的设备电量、拖慢机器性能、增加电费支出。
protections-panel-fingerprinters = 数字指纹追踪程序收集您的浏览器、计算机设置，勾勒出您的精准画像，并在不同网站间跟踪您。
protections-panel-tracking-content = 网站可能会加载包含跟踪代码的外部广告、视频、其他内容。拦截跟踪内容可以让网站加载更快，但某些按钮、表单、登录栏可能无法正常工作。
protections-panel-social-media-trackers = 社交网站将跟踪器嵌到其他网站，跟踪您在网上做了或看了什么。社交媒体公司对您的了解，绝不止于您在社交媒体上分享的信息。
protections-panel-description-shim-allowed = 由于您已与此页面上的部分跟踪器交互过，已放行下列标记的跟踪器。
protections-panel-description-shim-allowed-learn-more = 详细了解
protections-panel-shim-allowed-indicator =
    .tooltiptext = 已放行部分跟踪器
protections-panel-content-blocking-manage-settings =
    .label = 管理保护设置
    .accesskey = M
protections-panel-content-blocking-breakage-report-view =
    .title = 反馈网站问题
protections-panel-content-blocking-breakage-report-view-description = 拦截某些跟踪器可能导致部分网站出现问题。在您反馈故障时，您得以帮助 { -brand-short-name } 为所有人提供更好的体验。发送反馈将会向 Waterfox 发送网页的地址及浏览器的有关信息。 <label data-l10n-name="learn-more">详细了解</label>
protections-panel-content-blocking-breakage-report-view-collection-url = 网址
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = 网址
protections-panel-content-blocking-breakage-report-view-collection-comments = 描述问题（选填）：
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = 描述问题（选填）：
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = 取消
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = 发送反馈
