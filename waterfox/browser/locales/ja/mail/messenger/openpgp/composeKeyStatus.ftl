# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = エンドツーエンド暗号化されたメッセージを送信するには、メッセージの受信者ごとの公開鍵を入手し、受け入れる必要があります。
openpgp-compose-key-status-keys-heading = OpenPGP 鍵の可用性:
openpgp-compose-key-status-title =
    .title = OpenPGP メッセージセキュリティ
openpgp-compose-key-status-recipient =
    .label = 受信者
openpgp-compose-key-status-status =
    .label = 状態
openpgp-compose-key-status-open-details = 選択した受信者の鍵の管理...
openpgp-recip-good = 成功
openpgp-recip-missing = 利用可能な鍵がありません
openpgp-recip-none-accepted = 受け入れられた鍵がありません
openpgp-compose-general-info-alias = { -brand-short-name} は通常、メールアドレスと一致するユーザー ID を含む受信者の公開鍵を必要とします。これは OpenPGP の受信者エイリアス規則で上書きできます。
openpgp-compose-general-info-alias-learn-more = 詳細情報
openpgp-compose-alias-status-direct = { $count ->
      [one] 1 個のエイリアス鍵に割り当てました
      *[other] {$count} 個のエイリアス鍵に割り当てました
    }
openpgp-compose-alias-status-error = 使用不能または利用不可のエイリアス鍵
