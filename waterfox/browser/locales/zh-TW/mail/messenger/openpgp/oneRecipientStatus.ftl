# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = OpenPGP 訊息安全
openpgp-one-recipient-status-status =
    .label = 狀態
openpgp-one-recipient-status-key-id =
    .label = 金鑰 ID
openpgp-one-recipient-status-created-date =
    .label = 建立於
openpgp-one-recipient-status-expires-date =
    .label = 有效期限
openpgp-one-recipient-status-open-details =
    .label = 開啟詳細資訊，並編輯接受程度…
openpgp-one-recipient-status-discover =
    .label = 尋找新的金鑰，或是否有金鑰更新

openpgp-one-recipient-status-instruction1 = 若要傳送端到端加密訊息給，需要先取得對方的 OpenPGP 公鑰，並標示為已接受。
openpgp-one-recipient-status-instruction2 = 要取得對方的公要，請匯入對方寄送給您，含有公鑰的郵件。另外您也可以嘗試在網路目錄中尋找看看。

openpgp-key-own = 接受（個人金鑰）
openpgp-key-secret-not-personal = 無法使用
openpgp-key-verified = 接受（已驗證）
openpgp-key-unverified = 接受（未驗證）
openpgp-key-undecided = 不接受（未決定）
openpgp-key-rejected = 不接受（已拒絕）
openpgp-key-expired = 已過期

openpgp-intro = { $key } 可用的公鑰

openpgp-pubkey-import-id = ID: { $kid }
openpgp-pubkey-import-fpr = 指紋: { $fpr }

openpgp-pubkey-import-intro =
    { $num ->
       *[other] 檔案包含下列共 { $num } 把公鑰:
    }

openpgp-pubkey-import-accept =
    { $num ->
       *[one] 您要接受將此金鑰用來驗證下列所有電子郵件地址的數位簽章與加密訊息嗎？
        [other] 您要接受將這些金鑰用來驗證下列所有電子郵件地址的數位簽章與加密訊息嗎？
    }

pubkey-import-button =
    .buttonlabelaccept = 匯入
    .buttonaccesskeyaccept = I
