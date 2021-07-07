# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-manage-keys-openpgp-cmd =
    .label = OpenPGP 金鑰管理員
    .accesskey = O
openpgp-ctx-decrypt-open =
    .label = 解密並開啟
    .accesskey = D
openpgp-ctx-decrypt-save =
    .label = 解密並另存新檔…
    .accesskey = C
openpgp-ctx-import-key =
    .label = 匯入 OpenPGP 金鑰
    .accesskey = I
openpgp-ctx-verify-att =
    .label = 驗證簽章
    .accesskey = V
openpgp-has-sender-key = 此訊息聲稱包含寄件者的 OpenPGP 公鑰。
openpgp-be-careful-new-key = 警告: 此訊息中的 OpenPGP 新公鑰與您先前接受的 { $email } 公鑰不同。
openpgp-import-sender-key =
    .label = 匯入…
openpgp-search-keys-openpgp =
    .label = 尋找 OpenPGP 金鑰
openpgp-missing-signature-key = 此訊息是使用您沒有的金鑰所簽署的。
openpgp-search-signature-key =
    .label = 尋找…
# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-opened = 這是一封被 MS-Exchange 毀損的 OpenPGP 訊息，由於是用本機檔案的方式開啟，無法修復。請嘗試將訊息複製到郵件資料夾，進行自動修復。
openpgp-broken-exchange-info = 這是一封被 MS Exchange 修改毀損的 OpenPGP 訊息。若訊息內容不正確，可以試試看進行自動修復。
openpgp-broken-exchange-repair =
    .label = 修復訊息
openpgp-broken-exchange-wait = 請稍候…
openpgp-cannot-decrypt-because-mdc = 這是一封使用了舊版並有安全性漏洞所加密的訊息。此訊息可能在傳輸過程中已遭竄改，內容已遭洩漏。為了防止風險，將不顯示內容。
openpgp-cannot-decrypt-because-missing-key = 用來解開此訊息的私鑰不存在。
openpgp-partially-signed = 此訊息當中只有一部分使用 OpenPGP 進行數位簽署。當您點擊驗證按鈕後，將隱藏未保護的部分，並顯示數位簽章狀態。
openpgp-partially-encrypted = 此訊息當中只有一部分使用 OpenPGP 進行數位簽署。訊息當中已經顯示可以閱讀的部分並未加密。當您點擊解密按鈕後，將顯示加密部分的內容。
openpgp-reminder-partial-display = 提醒: 下方顯示的訊息只是原始訊息的一部分。
openpgp-partial-verify-button = 驗證
openpgp-partial-decrypt-button = 解密
