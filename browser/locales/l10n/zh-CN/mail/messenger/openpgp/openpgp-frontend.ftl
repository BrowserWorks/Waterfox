# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-manage-keys-openpgp-cmd =
    .label = OpenPGP 密钥管理器
    .accesskey = O
openpgp-ctx-decrypt-open =
    .label = 解密并打开
    .accesskey = D
openpgp-ctx-decrypt-save =
    .label = 解密并另存为...
    .accesskey = C
openpgp-ctx-import-key =
    .label = 导入 OpenPGP 密钥
    .accesskey = I
openpgp-ctx-verify-att =
    .label = 验证签名
    .accesskey = V
openpgp-has-sender-key = 此消息声称包含发件人的 OpenPGP 公钥。
openpgp-be-careful-new-key = 警告：此消息中的 OpenPGP 新公钥不同与您先前接受的 { $email } 公钥。
openpgp-import-sender-key =
    .label = 导入…
openpgp-search-keys-openpgp =
    .label = 寻找 OpenPGP 密钥
openpgp-missing-signature-key = 此消息是用您没有的密钥所签名的。
openpgp-search-signature-key =
    .label = 寻找…
# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-opened = 这是一则被 MS-Exchange 损坏的 OpenPGP 消息，由于是用本地文件的方式打开，无法修复。请尝试将消息复制到邮件文件夹，进行自动修复。
openpgp-broken-exchange-info = 这是一则被 MS Exchange 损坏的 OpenPGP 消息。若消息内容不正确，可以尝试进行自动修复。
openpgp-broken-exchange-repair =
    .label = 修复消息
openpgp-broken-exchange-wait = 请稍候…
openpgp-cannot-decrypt-because-mdc = 这是一则使用了过时且易受攻击的机制所加密的信息。此消息可能在传输过程中已遭窜改，内容已泄露。为避免风险，将不显示此内容。
openpgp-cannot-decrypt-because-missing-key = 用于解密此消息的私钥不存在。
openpgp-partially-signed = 此消息中只有一部分使用 OpenPGP 进行数字签名。当您点击验证按钮后，将隐藏未保护的部分，并显示数字签名状态。
openpgp-partially-encrypted = 此消息中只有一部分使用 OpenPGP 进行数字签名。消息中已显示可以阅读的部分并未加密。当您点击解密按钮后，将显示加密部分的内容。
openpgp-reminder-partial-display = 提醒：下方显示的消息只是原始消息的一部分。
openpgp-partial-verify-button = 验证
openpgp-partial-decrypt-button = 解密
