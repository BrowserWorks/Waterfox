# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = 若要发送端到端加密消息，必须取得并接受每一位收件人的公钥。
openpgp-compose-key-status-keys-heading = OpenPGP 密钥可用性：
openpgp-compose-key-status-title =
    .title = OpenPGP 消息安全
openpgp-compose-key-status-recipient =
    .label = 收件人
openpgp-compose-key-status-status =
    .label = 状态
openpgp-compose-key-status-open-details = 管理选中的收件人的密钥…
openpgp-recip-good = 确定
openpgp-recip-missing = 无可用密钥
openpgp-recip-none-accepted = 无可接受的密钥
openpgp-compose-general-info-alias = { -brand-short-name } 通常会要求收件者的公钥中包含与电子邮件地址相同的用户 ID。此行为可通过更改 OpenPGP 收件者别名规则来调整。
openpgp-compose-general-info-alias-learn-more = 详细了解
openpgp-compose-alias-status-direct =
    { $count ->
       *[other] 对应到 { $count } 把别名密钥
    }
openpgp-compose-alias-status-error = 不可用 / 不存在的别名密钥
