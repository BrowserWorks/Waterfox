# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = OpenPGP 鍵アシスタント
openpgp-key-assistant-rogue-warning = 偽造された鍵の受け入れを避けてください。正しい鍵を取得しているか確かめるには鍵を検証してください。<a data-l10n-name="openpgp-link">詳細情報...</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = 暗号化できません
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] 暗号化するには、受信者 1 名の使用可能な鍵を取得して受け入れなければなりません。<a data-l10n-name="openpgp-link">詳細情報...</a>
        *[other] 暗号化するには、受信者 { $count } 名の使用可能な鍵を取得して受け入れなければなりません。<a data-l10n-name="openpgp-link">詳細情報...</a>
    }
openpgp-key-assistant-info-alias = { -brand-short-name } は通常、受信者のメールアドレスと合致するユーザー ID を含む公開鍵を必要とします。これは OpenPGP の受信者別名規則を使用して上書きすることができます。<a data-l10n-name="openpgp-link">詳細情報...</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] 1 名の受信者の使用可能な鍵をすでに受け入れています。
        *[other] { $count } 名の受信者の使用可能な鍵をすでに受け入れています。
    }
openpgp-key-assistant-recipients-description-no-issues = このメッセージは暗号化されています。すべての受信者の使用可能な鍵を受け入れ済みです。

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] { -brand-short-name } が { $recipient } の鍵を見つけました。
        *[other] { -brand-short-name } が { $recipient } の複数の鍵を見つけました。
    }
openpgp-key-assistant-valid-description = 受け入れる鍵を選択してください
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] 以下の鍵は更新しない限り使用できません。
        *[other] 以下の鍵は更新しない限り使用できません。
    }
openpgp-key-assistant-no-key-available = 使用可能なカギがありません。
openpgp-key-assistant-multiple-keys = 複数の鍵が使用可能です。
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] 1 個の鍵が使用可能ですが、まだ受け入れられていません。
        *[other] 複数の鍵が使用可能ですが、どれもまだ受け入れられていません。
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = 受け入れた 1 個の鍵の有効期限が { $date } に切れています。
openpgp-key-assistant-keys-accepted-expired = 受け入れた複数の鍵の有効期限が切れています。
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = この鍵は以前に受け入れられましたが { $date } に有効期限が切れています。
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = この鍵は { $date } に有効期限が切れました。
openpgp-key-assistant-key-unaccepted-expired-many = 複数の鍵の有効期限が切れています。
openpgp-key-assistant-key-fingerprint = フィンガープリント
openpgp-key-assistant-key-source =
    { $count ->
        [one] ソース
        *[other] ソース
    }
openpgp-key-assistant-key-collected-attachment = メール添付
openpgp-key-assistant-key-collected-autocrypt = Autocrypt ヘッダー
openpgp-key-assistant-key-collected-keyserver = 鍵サーバー
openpgp-key-assistant-key-collected-wkd = Web Key Directory
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] 鍵が見つかりましたが、まだ受け入れられていません。
        *[other] 複数の鍵が見つかりましたが、どれもまだ受け入れられていません。
    }
openpgp-key-assistant-key-rejected = この鍵は以前に拒絶されています。
openpgp-key-assistant-key-accepted-other = この鍵は以前に別のメールアドレスで受け入れられています。
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = オンラインで { $recipient } の追加の鍵や更新された鍵を見つけるか、ファイルから@@Imort-site@@ください。

## Discovery section

openpgp-key-assistant-discover-title = オンラインで探索中です。
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = { $recipient } の鍵を探しています...
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    以前受け入れた { $recipient } の鍵の一つに更新が見つかりました。
    この鍵を使用して有効期限が切れないようにしてください。

## Dialog buttons

openpgp-key-assistant-discover-online-button = 公開鍵をオンラインで探す...
openpgp-key-assistant-import-keys-button = 公開鍵をファイルからインポート...
openpgp-key-assistant-issue-resolve-button = 解決...
openpgp-key-assistant-view-key-button = 鍵を表示...
openpgp-key-assistant-recipients-show-button = 表示
openpgp-key-assistant-recipients-hide-button = 隠す
openpgp-key-assistant-cancel-button = キャンセル
openpgp-key-assistant-back-button = 戻る
openpgp-key-assistant-accept-button = 受け入れる
openpgp-key-assistant-close-button = 閉じる
openpgp-key-assistant-disable-button = 暗号化を無効化
openpgp-key-assistant-confirm-button = 暗号化して送信

# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = { $date } に作成されました
