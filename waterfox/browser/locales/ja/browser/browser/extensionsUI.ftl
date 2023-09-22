# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = 拡張機能の権限について
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } が既定の検索エンジンを { $currentEngine } から { $newEngine } へ変更しようとしています。よろしいですか？
webext-default-search-yes =
    .label = はい
    .accesskey = Y
webext-default-search-no =
    .label = いいえ
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } が追加されました。

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = 制限されたサイトで { $addonName } を実行しますか？
webext-quarantine-confirmation-line-1 = ユーザーデータを保護するため、このサイトではこの拡張機能の実行が許可されていません。
webext-quarantine-confirmation-line-2 = { -vendor-short-name } によって制限されたサイトでのユーザーデータの取得と変更について、この拡張機能を信頼する場合のみ許可してください。
webext-quarantine-confirmation-allow =
    .label = 許可する
    .accesskey = A
webext-quarantine-confirmation-deny =
    .label = 許可しない
    .accesskey = D
