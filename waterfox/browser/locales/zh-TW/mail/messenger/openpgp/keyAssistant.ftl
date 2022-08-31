# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = OpenPGP 金鑰助理
openpgp-key-assistant-rogue-warning = 避免收到偽造的金鑰。為了確保您收到的是正確的金鑰，請進行驗證。<a data-l10n-name="openpgp-link">了解更多…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = 無法加密
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
       *[other] 若要加密，您必須先取得並接受 { $count } 位收件者的可用金鑰。<a data-l10n-name="openpgp-link">了解更多…</a>
    }
openpgp-key-assistant-info-alias = { -brand-short-name } 一般來說會要求收件者的公鑰當中包含與電子郵件地址相同的使用者 ID。此行為可透過更改 OpenPGP 收件者別名規則來調整。<a data-l10n-name="openpgp-link">了解更多…</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
       *[other] 您已經擁有 { $count } 位收件者可用且已接受的金鑰。
    }
openpgp-key-assistant-recipients-description-no-issues = 您擁有所有使用者可用且已接受的金鑰，可加密此訊息。

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
       *[other] { -brand-short-name } 找到 { $recipient } 的金鑰如下。
    }
openpgp-key-assistant-valid-description = 請選擇您要接受的金鑰
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
       *[other] 在您更新下列金鑰前，無法使用下列金鑰。
    }
openpgp-key-assistant-no-key-available = 無可用金鑰。
openpgp-key-assistant-multiple-keys = 有多把金鑰可以使用。
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] 有一把可用的金鑰，但您尚未接受。
       *[other] 有多把可用的金鑰，但您尚未接受任何一把。
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = 有一把已接受的金鑰，已於 { $date } 過期。
openpgp-key-assistant-keys-accepted-expired = 有多把已接受的金鑰已過期。
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = 先前接受過這把金鑰，但已於 { $date } 過期。
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = 金鑰已於 { $date } 過期。
openpgp-key-assistant-key-unaccepted-expired-many = 有多把金鑰已過期。
openpgp-key-assistant-key-fingerprint = 指紋
openpgp-key-assistant-key-source =
    { $count ->
       *[other] 來源
    }
openpgp-key-assistant-key-collected-attachment = 郵件附件
openpgp-key-assistant-key-collected-autocrypt = Autocrypt 檔頭
openpgp-key-assistant-key-collected-keyserver = 金鑰伺服器
openpgp-key-assistant-key-collected-wkd = 網頁金鑰目錄
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] 找到一把金鑰，但您尚未接受過。
       *[other] 找到多把金鑰，但您尚未接受過任何一把。
    }
openpgp-key-assistant-key-rejected = 先前拒絕過這把金鑰。
openpgp-key-assistant-key-accepted-other = 先前接受過這把金鑰用於另一組電子郵件信箱。
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = 在網路上尋找 { $recipient } 的其他金鑰或更新金鑰，或從檔案匯入。

## Discovery section

openpgp-key-assistant-discover-title = 正在進行網路搜尋。
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = 正在尋找 { $recipient } 的金鑰…
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update = 找到 { $recipient } 先前接受過的其中一把金鑰的更新。由於已經不再過期，現在起可以使用了。

## Dialog buttons

openpgp-key-assistant-discover-online-button = 在網路上尋找公鑰…
openpgp-key-assistant-import-keys-button = 從網路匯入公鑰…
openpgp-key-assistant-issue-resolve-button = 解決…
openpgp-key-assistant-view-key-button = 檢視金鑰…
openpgp-key-assistant-recipients-show-button = 顯示
openpgp-key-assistant-recipients-hide-button = 隱藏
openpgp-key-assistant-cancel-button = 取消
openpgp-key-assistant-back-button = 上一頁
openpgp-key-assistant-accept-button = 接受
openpgp-key-assistant-close-button = 關閉
openpgp-key-assistant-disable-button = 關閉加密
openpgp-key-assistant-confirm-button = 以加密格式寄出
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = 建立於 { $date }
