# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = 若要傳送端到端加密訊息，必須取得並接受每一位收件者的公鑰。
openpgp-compose-key-status-keys-heading = OpenPGP 金鑰可用性:
openpgp-compose-key-status-title =
    .title = OpenPGP 訊息安全
openpgp-compose-key-status-recipient =
    .label = 收件者
openpgp-compose-key-status-status =
    .label = 狀態
openpgp-compose-key-status-open-details = 管理選擇的收件者的金鑰…
openpgp-recip-good = 確定
openpgp-recip-missing = 無可用金鑰
openpgp-recip-none-accepted = 無可接受的金鑰
openpgp-compose-general-info-alias = { -brand-short-name } 一般來說會要求收件者的公鑰當中包含與電子郵件地址相同的使用者 ID。此行為可透過更改 OpenPGP 收件者別名規則來調整。
openpgp-compose-general-info-alias-learn-more = 了解更多
openpgp-compose-alias-status-direct =
    { $count ->
       *[other] 對應到 { $count } 把別名金鑰
    }
openpgp-compose-alias-status-error = 無法使用 / 不存在的別名金鑰
