# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = 关于 { -brand-full-name }

releaseNotes-link = 新版变化

update-checkForUpdatesButton =
    .label = 检查更新
    .accesskey = C

update-updateButton =
    .label = 重启 { -brand-shorter-name } 以更新
    .accesskey = R

update-checkingForUpdates = 正在检查更新…

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>正在下载更新 — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = 正在下载更新 — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = 正在应用更新…

update-failed = 更新失败。 <label data-l10n-name="failed-link">下载最新版本</label>
update-failed-main = 更新失败。 <a data-l10n-name="failed-link-main">下载最新版本</a>

update-adminDisabled = 更新已被系统管理员禁用
update-noUpdatesFound = { -brand-short-name } 已是最新
aboutdialog-update-checking-failed = 检查更新失败。
update-otherInstanceHandlingUpdates = { -brand-short-name } 正在由其他实例更新

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = 可访问 <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = 可访问 <a data-l10n-name="manual-link">{ $displayUrl }</a>

update-unsupported = 您无法在这个系统上进一步更新。<label data-l10n-name="unsupported-link">详细了解</label>

update-restarting = 正在重启浏览器…

update-internal-error2 = 发生内部错误，无法检查更新。可访问 <label data-l10n-name="manual-link">{ $displayUrl }</label> 手动下载更新。

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = 您目前在 <label data-l10n-name="current-channel">{ $channel }</label> 更新通道。

warningDesc-version = { -brand-short-name } 是实验性的测试版本，可能不够稳定。

aboutdialog-help-user = { -brand-product-name } 帮助
aboutdialog-submit-feedback = 提交反馈

community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> 是一个<label data-l10n-name="community-exp-creditsLink">全球社区</label>，携手致力于让互联网保持开放、公开且人人可用。

community-2 = { -brand-short-name } 诞生于 <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label>。我们是一个<label data-l10n-name="community-creditsLink">全球社区</label>，携手致力于让互联网保持开放、公开且人人可用。

helpus = 想支持我们吗？<label data-l10n-name="helpus-donateLink">向我们捐款</label>或者<label data-l10n-name="helpus-getInvolvedLink">参与进来</label>！

bottomLinks-license = 许可信息
bottomLinks-rights = 最终用户权利
bottomLinks-privacy = 隐私政策

# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits } 位)

# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits } 位)
