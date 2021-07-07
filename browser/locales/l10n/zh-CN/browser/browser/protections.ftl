# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Variables:
#   $count (Number) - Number of tracking events blocked.
graph-week-summary =
    { $count ->
       *[other] 过去一周，{ -brand-short-name } 拦截了 { $count } 个跟踪器
    }
# Variables:
#   $count (Number) - Number of tracking events blocked.
#   $earliestDate (Number) - Unix timestamp in ms, representing a date. The
# earliest date recorded in the database.
graph-total-tracker-summary =
    { $count ->
       *[other] 自{ DATETIME($earliestDate, day: "numeric", month: "long", year: "numeric") }起，已拦截 <b>{ $count }</b> 个跟踪器
    }
# Text displayed instead of the graph when in Private Mode
graph-private-window = { -brand-short-name } 将继续在隐私窗口中拦截跟踪器，但不会记录拦截了什么。
# Weekly summary of the graph when the graph is empty in Private Mode
graph-week-summary-private-window = 本周 { -brand-short-name } 所拦截跟踪器
protection-report-webpage-title = 保护信息面板
protection-report-page-content-title = 保护信息面板
# This message shows when all privacy protections are turned off, which is why we use the word "can", Waterfox is able to protect your privacy, but it is currently not.
protection-report-page-summary = 当您上网时，{ -brand-short-name } 会在后台保护您的隐私。以下是这些保护的个性化摘要，以及能够用来保护在线安全的各种工具。
# This message shows when at least some protections are turned on, we are more assertive compared to the message above, Waterfox is actively protecting you.
protection-report-page-summary-default = 当您上网时，{ -brand-short-name } 会在后台保护您的隐私。以下是这些保护的个性化摘要，以及能够用来保护在线安全的各种工具。
protection-report-settings-link = 管理您的隐私与安全设置
etp-card-title-always = 增强型跟踪保护：始终开启
etp-card-title-custom-not-blocking = 增强型跟踪保护：关闭
etp-card-content-description = { -brand-short-name } 会自动阻止大公司在网上偷偷跟踪您。
protection-report-etp-card-content-custom-not-blocking = 目前已关闭所有保护功能。通过管理 { -brand-short-name } 保护设置，即可选择要拦截的跟踪器。
protection-report-manage-protections = 管理设置
# This string is used to label the X axis of a graph. Other days of the week are generated via Intl.DateTimeFormat,
# capitalization for this string should match the output for your locale.
graph-today = 今日
# This string is used to describe the graph for screenreader users.
graph-legend-description = 此图展示了本周各类型跟踪器的总拦截数。
social-tab-title = 社交媒体跟踪器
social-tab-contant = 社交网站会在众多网站上安插跟踪器。除了您在社交网站上分享、发言外，它们还监视您在其他地方看些什么、做些什么。<a data-l10n-name="learn-more-link">详细了解</a>
cookie-tab-title = 跨网站跟踪性 Cookie
cookie-tab-content = 这些 Cookie 由第三方广告商或分析公司设置，能够在不同网站间跟踪您，以收集您的在线活动数据。<a data-l10n-name="learn-more-link">详细了解</a>
tracker-tab-title = 跟踪性内容
tracker-tab-description = 网站可能会载入包含跟踪代码的外部广告、视频等内容。拦截跟踪性内容可以让网站加载更快，但某些按钮、表单、登录栏可能无法正常工作。<a data-l10n-name="learn-more-link">详细了解</a>
fingerprinter-tab-title = 数字指纹跟踪程序
fingerprinter-tab-content = 数字指纹跟踪程序会针对您的浏览器、计算机设置，给您生成独一无二的编号，以便在不同网站间追踪您，勾勒出您的精准画像。<a data-l10n-name="learn-more-link">详细了解</a>
cryptominer-tab-title = 加密货币挖矿程序
cryptominer-tab-content = 加密货币挖矿程序盗用您的计算机算力来“挖掘”数字货币，这会消耗您的电力、拖慢机器性能、增加电费支出。<a data-l10n-name="learn-more-link">详细了解</a>
protections-close-button2 =
    .aria-label = 关闭
    .title = 关闭
mobile-app-title = 在更多设备上拦截广告跟踪器
mobile-app-card-content = 使用内置广告跟踪保护的移动浏览器。
mobile-app-links = { -brand-product-name } 浏览器 <a data-l10n-name="android-mobile-inline-link">Android</a> 与 <a data-l10n-name="ios-mobile-inline-link">iOS</a> 版
lockwise-title = 密码不怕再忘
lockwise-title-logged-in2 = 密码管理
lockwise-header-content = { -lockwise-brand-name } 能将您的密码安全地存储在浏览器中。
lockwise-header-content-logged-in = 安全地存储密码，并同步到您的所有设备中。
protection-report-save-passwords-button = 保存密码
    .title = 将密码保存到 { -lockwise-brand-short-name }
protection-report-manage-passwords-button = 管理密码
    .title = 用 { -lockwise-brand-short-name } 管理密码
lockwise-mobile-app-title = 密码随身带着走
lockwise-no-logins-card-content = 在所有设备上使用 { -brand-short-name } 中存放的密码。
lockwise-app-links = <a data-l10n-name="lockwise-android-inline-link">Android</a> 与 <a data-l10n-name="lockwise-ios-inline-link">iOS</a> 版 { -lockwise-brand-name }
# Variables:
# $count (Number) - Number of passwords exposed in data breaches.
lockwise-scanned-text-breached-logins =
    { $count ->
       *[other] 有 { $count } 个密码可能在数据外泄事件中泄露。
    }
# While English doesn't use the number in the plural form, you can add $count to your language
# if needed for grammatical reasons.
# Variables:
# $count (Number) - Number of passwords stored in Lockwise.
lockwise-scanned-text-no-breached-logins =
    { $count ->
       *[other] 您的 { $count } 个密码皆已安全存放。
    }
lockwise-how-it-works-link = 工作原理
monitor-title = 帮您关心数据泄露事故
monitor-link = 工作原理
monitor-header-content-no-account = 到 { -monitor-brand-name } 检测您是否处于已知数据外泄事件之中，并在有新外泄事件时收到警报。
monitor-header-content-signed-in = 若您的信息出现在已知的数据外泄事件中，{ -monitor-brand-name } 会警示您。
monitor-sign-up-link = 订阅数据外泄警报
    .title = 在 { -monitor-brand-name } 订阅数据外泄警报
auto-scan = 今日已自动扫描
monitor-emails-tooltip =
    .title = 到 { -monitor-brand-short-name } 查看监控中的电子邮件地址
monitor-breaches-tooltip =
    .title = 到 { -monitor-brand-short-name } 查看已知的数据外泄事件
monitor-passwords-tooltip =
    .title = 到 { -monitor-brand-short-name } 查看遭泄露的密码
# This string is displayed after a large numeral that indicates the total number
# of email addresses being monitored. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-monitored-emails =
    { $count ->
       *[other] 正在监控的电子邮件地址
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-known-breaches-found =
    { $count ->
       *[other] 爆出的涉及您的数据泄露事件
    }
# This string is displayed after a large numeral that indicates the total number
# of known data breaches that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-known-breaches-resolved =
    { $count ->
       *[other] 标记为已处理的数据外泄事件数
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords. Don’t add $count to
# your localization, because it would result in the number showing twice.
info-exposed-passwords-found =
    { $count ->
       *[other] 在所有事件中泄露的密码
    }
# This string is displayed after a large numeral that indicates the total number
# of exposed passwords that are marked as resolved by the user. Don’t add $count
# to your localization, because it would result in the number showing twice.
info-exposed-passwords-resolved =
    { $count ->
       *[other] 在未处理事件中泄露的密码
    }
monitor-no-breaches-title = 好消息！
monitor-no-breaches-description = 您没有已知的数据外泄。如果情况发生变化，我们将通知您。
monitor-view-report-link = 查看报告
    .title = 在 { -monitor-brand-short-name } 解决数据外泄。
monitor-breaches-unresolved-title = 处理遇到的数据外泄事件
monitor-breaches-unresolved-description = 确认事件详细信息并采取措施保护自己的数据后，就可以将事件标记为“已处理”。
monitor-manage-breaches-link = 管理数据外泄事件
    .title = 在 { -monitor-brand-short-name } 管理数据外泄事件
monitor-breaches-resolved-title = 真好！您已处理完所有已知的数据外泄事件。
monitor-breaches-resolved-description = 如果您的邮箱地址出现在新的数据外泄事件中，我们将通知您。
# Variables:
# $numBreachesResolved (Number) - Number of breaches marked as resolved by the user on Monitor.
# $numBreaches (Number) - Number of breaches in which a user's data was involved, detected by Monitor.
monitor-partial-breaches-title =
    { $numBreaches ->
       *[other] 已处理 { $numBreachesResolved } 起事件，共 { $numBreaches } 起
    }
# Variables:
# $percentageResolved (Number) - Percentage of breaches marked as resolved by a user on Monitor.
monitor-partial-breaches-percentage = 完成 { $percentageResolved }%
monitor-partial-breaches-motivation-title-start = 很棒的开始！
monitor-partial-breaches-motivation-title-middle = 请保持！
monitor-partial-breaches-motivation-title-end = 就要完成了！请保持。
monitor-partial-breaches-motivation-description = 到 { -monitor-brand-short-name } 处理其他的数据外泄事件。
monitor-resolve-breaches-link = 处理数据外泄事件
    .title = 到 { -monitor-brand-short-name } 处理数据外泄事件

## The title attribute is used to display the type of protection.
## The aria-label is spoken by screen readers to make the visual graph accessible to blind users.
##
## Variables:
##   $count (Number) - Number of specific trackers
##   $percentage (Number) - Percentage this type of tracker contributes to the whole graph

bar-tooltip-social =
    .title = 社交媒体跟踪器
    .aria-label =
        { $count ->
           *[other] { $count } 个社交媒体跟踪器（{ $percentage }%）
        }
bar-tooltip-cookie =
    .title = 跨网站跟踪性 Cookie
    .aria-label =
        { $count ->
           *[other] { $count } 个跨网站跟踪性 Cookie（{ $percentage }%）
        }
bar-tooltip-tracker =
    .title = 跟踪性内容
    .aria-label =
        { $count ->
           *[other] { $count } 个跟踪性内容（{ $percentage }%）
        }
bar-tooltip-fingerprinter =
    .title = 数字指纹跟踪程序
    .aria-label =
        { $count ->
           *[other] { $count } 个数字指纹跟踪程序（{ $percentage }%）
        }
bar-tooltip-cryptominer =
    .title = 加密货币挖矿程序
    .aria-label =
        { $count ->
           *[other] { $count } 个加密货币挖矿程序（{ $percentage }%）
        }
