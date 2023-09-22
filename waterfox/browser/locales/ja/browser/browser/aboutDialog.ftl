# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

aboutDialog-title =
    .title = { -brand-full-name } について
releaseNotes-link = 更新情報
update-checkForUpdatesButton =
    .label = ソフトウェアの更新を確認
    .accesskey = C
update-updateButton =
    .label = 再起動して { -brand-shorter-name } を更新
    .accesskey = R
update-checkingForUpdates = ソフトウェアの更新を確認中...

## Variables:
##   $transfer (string) - Transfer progress.

settings-update-downloading = <img data-l10n-name="icon"/>更新をダウンロード中 — <label data-l10n-name="download-status">{ $transfer }</label>
aboutdialog-update-downloading = 更新をダウンロード中 — <label data-l10n-name="download-status">{ $transfer }</label>

##

update-applying = 更新を適用中...
update-failed = 更新に失敗しました。<label data-l10n-name="failed-link">最新バージョンをダウンロード</label> してください。
update-failed-main = 更新に失敗しました。<a data-l10n-name="failed-link-main">最新バージョンをダウンロード</a> してください。
update-adminDisabled = システム管理者により、更新が無効化されています
update-noUpdatesFound = { -brand-short-name } は最新バージョンです
aboutdialog-update-checking-failed = 更新の確認に失敗しました。
update-otherInstanceHandlingUpdates = { -brand-short-name } は別のインスタンスにより更新中です

## Variables:
##   $displayUrl (String): URL to page with download instructions. Example: www.mozilla.org/firefox/nightly/

aboutdialog-update-manual-with-link = 更新が利用可能です <label data-l10n-name="manual-link">{ $displayUrl }</label>
settings-update-manual-with-link = 更新が利用可能です <a data-l10n-name="manual-link">{ $displayUrl }</a>
update-unsupported = ご利用のシステムでは、このバージョン以降の更新はできません。 <label data-l10n-name="unsupported-link">詳細</label>
update-restarting = 再起動中...
update-internal-error2 = 内部エラーにより更新を確認できません。<label data-l10n-name="manual-link">{ $displayUrl }</label> から更新が利用可能です。

##

# Variables:
#   $channel (String): description of the update channel (e.g. "release", "beta", "nightly" etc.)
aboutdialog-channel-description = 現在の更新チャンネルは <label data-l10n-name="current-channel">{ $channel }</label> です。
warningDesc-version = { -brand-short-name } は実験的であり、動作が不安定である可能性があります。
aboutdialog-help-user = { -brand-product-name } ヘルプ
aboutdialog-submit-feedback = フィードバックを送信
community-exp = <label data-l10n-name="community-exp-mozillaLink">{ -vendor-short-name }</label> はウェブの公開性、公衆性、制限のないアクセスを保つために共に活動している <label data-l10n-name="community-exp-creditsLink">グローバルなコミュニティ</label> です。
community-2 = { -brand-short-name } をデザインしている <label data-l10n-name="community-mozillaLink">{ -vendor-short-name }</label> は、ウェブの公開性、公衆性、制限のないアクセスを保つために共に活動している <label data-l10n-name="community-creditsLink">グローバルなコミュニティ</label> です。
helpus = 参加しませんか？ <label data-l10n-name="helpus-donateLink">寄付</label> または <label data-l10n-name="helpus-getInvolvedLink">コミュニティに参加</label> してください！
bottomLinks-license = ライセンス情報
bottomLinks-rights = あなたの権利について
bottomLinks-privacy = プライバシーポリシー
# Example of resulting string: 66.0.1 (64-bit)
# Variables:
#   $version (String): version of Waterfox, e.g. 66.0.1
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version = { $version } ({ $bits } ビット)
# Example of resulting string: 66.0a1 (2019-01-16) (64-bit)
# Variables:
#   $version (String): version of Waterfox for Nightly builds, e.g. 66.0a1
#   $isodate (String): date in ISO format, e.g. 2019-01-16
#   $bits (Number): bits of the architecture (32 or 64)
aboutDialog-version-nightly = { $version } ({ $isodate }) ({ $bits } ビット)
