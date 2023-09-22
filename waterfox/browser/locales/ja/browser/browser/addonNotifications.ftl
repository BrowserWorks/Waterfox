# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

xpinstall-prompt = このサイトからは { -brand-short-name } にソフトウェアをインストールできない設定になっています。

## Variables:
##   $host (String): The hostname of the site the add-on is being installed from.

xpinstall-prompt-header = { $host } にアドオンのインストールを許可しますか？
xpinstall-prompt-message = { $host } からアドオンをインストールしようとしています。続行するには、このサイトを許可サイトに設定する必要があります。

##

xpinstall-prompt-header-unknown = 不明なサイトにアドオンのインストールを許可しますか？
xpinstall-prompt-message-unknown = 不明なサイトからアドオンをインストールしようとしています。続行するには、このサイトを許可サイトに設定する必要があります。
xpinstall-prompt-dont-allow =
    .label = 許可しない
    .accesskey = D
xpinstall-prompt-never-allow =
    .label = 以後許可しない
    .accesskey = N
# Long text in this context make the dropdown menu extend awkwardly to the left,
# avoid a localization that's significantly longer than the English version.
xpinstall-prompt-never-allow-and-report =
    .label = 不審なサイトを報告
    .accesskey = R
# Accessibility Note:
# Be sure you do not choose an accesskey that is used elsewhere in the active context (e.g. main menu bar, submenu of the warning popup button)
# See https://website-archive.mozilla.org/www.mozilla.org/access/access/keyboard/ for details
xpinstall-prompt-install =
    .label = インストールを続行
    .accesskey = C

# These messages are shown when a website invokes navigator.requestMIDIAccess.

site-permission-install-first-prompt-midi-header = このサイトは MIDI (Musical Instrument Digital Interface) デバイスへのアクセスを要求しています。デバイスへのアクセスはアドオンをインストールすることにより有効化されます。
site-permission-install-first-prompt-midi-message = このアクセスは安全性が保証されません。このサイトが信頼できる場合のみ続行してください。

##

xpinstall-disabled-locked = ソフトウェアのインストールはシステム管理者により無効化されています。
xpinstall-disabled = ソフトウェアのインストールは現在無効になっています。[有効にする] をクリックしてからもう一度やり直してください。
xpinstall-disabled-button =
    .label = 有効にする
    .accesskey = n
# This message is shown when the installation of an add-on is blocked by enterprise policy.
# Variables:
#   $addonName (String): the name of the add-on.
#   $addonId (String): the ID of add-on.
addon-install-blocked-by-policy = { $addonName } ({ $addonId }) はシステム管理者によりブロックされています。
# This message is shown when the installation of add-ons from a domain is blocked by enterprise policy.
addon-domain-blocked-by-policy = このサイトによるソフトウェアのインストールの確認は、システム管理者によりブロックされています。
addon-install-full-screen-blocked = 全画面表示モード中または全画面表示モードに入る前は、アドオンのインストールが許可されていません。
# Variables:
#   $addonName (String): the localized name of the sideloaded add-on.
webext-perms-sideload-menu-item = { $addonName } が { -brand-short-name } に追加されました
# Variables:
#   $addonName (String): the localized name of the extension which has been updated.
webext-perms-update-menu-item = { $addonName } が新たな権限を必要としています
# This message is shown when one or more extensions have been imported from a
# different browser into Waterfox, and the user needs to complete the import to
# start these extensions. This message is shown in the appmenu.
webext-imported-addons = { -brand-short-name } にインポートされた拡張機能のインストールを完了しています

## Add-on removal warning

# Variables:
#  $name (String): The name of the add-on that will be removed.
addon-removal-title = { $name } を削除しますか？
# Variables:
#   $name (String): the name of the extension which is about to be removed.
addon-removal-message = { -brand-shorter-name } から { $name } を削除しますか？
addon-removal-button = 削除
addon-removal-abuse-report-checkbox = この拡張機能を { -vendor-short-name } に報告する
# Variables:
#   $addonCount (Number): the number of add-ons being downloaded
addon-downloading-and-verifying = { $addonCount } 個のアドオンをダウンロードして検証しています...
addon-download-verifying = 検証中
addon-install-cancel-button =
    .label = キャンセル
    .accesskey = C
addon-install-accept-button =
    .label = 追加
    .accesskey = A

## Variables:
##   $addonCount (Number): the number of add-ons being installed

addon-confirm-install-message = このサイトが { -brand-short-name } に { $addonCount } 個のアドオンのインストールを求めています:
addon-confirm-install-unsigned-message = 注意: このサイトが { -brand-short-name } に { $addonCount } 個の未検証アドオンのインストールを求めています。ご自身の責任でインストールしてください。
# Variables:
#   $addonCount (Number): the number of add-ons being installed (at least 2)
addon-confirm-install-some-unsigned-message = 注意: このサイトが { -brand-short-name } に { $addonCount } 個のアドオンのインストールを求めていますが、一部のアドオンは未検証です。ご自身の責任でインストールしてください。

## Add-on install errors
## Variables:
##   $addonName (String): the add-on name.

addon-install-error-network-failure = 接続エラーのため、アドオンをダウンロードできませんでした。
addon-install-error-incorrect-hash = アドオンのハッシュ値が { -brand-short-name } に読み込んだものと一致しないため、インストールできませんでした。
addon-install-error-corrupt-file = このサイトからダウンロードしたアドオンは壊れているため、インストールできませんでした。
addon-install-error-file-access = { -brand-short-name } が必要なファイルを変更できなかったため、{ $addonName } をインストールできませんでした。
addon-install-error-not-signed = { -brand-short-name } はこのサイトからの未検証のアドオンのインストールをブロックしています。
addon-install-error-invalid-domain = この場所からは { $addonName } アドオンをインストールできません。
addon-local-install-error-network-failure = ファイルシステムエラーのため、アドオンをインストールできませんでした。
addon-local-install-error-incorrect-hash = アドオンのハッシュ値が { -brand-short-name } に読み込んだものと一致しないため、インストールできませんでした。
addon-local-install-error-corrupt-file = このアドオンは壊れているため、インストールできませんでした。
addon-local-install-error-file-access = { -brand-short-name } が必要なファイルが変更できなかったため、{ $addonName } をインストールできませんでした。
addon-local-install-error-not-signed = このアドオンは検証されていないため、インストールできませんでした。
# Variables:
#   $appVersion (String): the application version.
addon-install-error-incompatible = { -brand-short-name } { $appVersion } と互換性がないため、{ $addonName } をインストールできませんでした。
addon-install-error-blocklisted = 安定性を大きく損なうかセキュリティに問題があるため、{ $addonName } をインストールできませんでした。
