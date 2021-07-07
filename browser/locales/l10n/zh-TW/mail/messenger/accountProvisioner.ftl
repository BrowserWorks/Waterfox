# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-provisioner-tab-title = 從服務供應商註冊新的信箱
provisioner-searching-icon =
    .alt = 搜尋中…
account-provisioner-title = 建立新的電子郵件地址
account-provisioner-description = 使用我們可靠的合作業者來註冊一套有隱私又安全的電子郵件信箱。
account-provisioner-start-help = 搜尋詞彙將傳送到 { -vendor-short-name }（<a data-l10n-name="mozilla-privacy-link">隱私權保護政策</a>）及第三方電子郵件服務業者 <strong>mailfence.com</strong>（<a data-l10n-name="mailfence-privacy-link">隱私權保護政策</a>、<a data-l10n-name="mailfence-tou-link">使用條款</a>）及 <strong>gandi.net</strong>（<a data-l10n-name="gandi-privacy-link">隱私權保護政策</a>、<a data-l10n-name="gandi-tou-link">使用條款</a>）來尋找是否有可用的信箱帳號。
account-provisioner-mail-account-title = 購買新的電子郵件地址
account-provisioner-mail-account-description = Thunderbird 與 <a data-l10n-name="mailfence-home-link">Mailfence</a> 合作，可提供您一套全新，有隱私又安全的電子郵件服務。我們相信，每個人都該使用安全的電子郵件信箱服務。
account-provisioner-domain-title = 購買您自己的信箱地址與網域名稱
account-provisioner-domain-description = Thunderbird 與 <a data-l10n-name="gandi-home-link">Gandi</a> 合作，提供您自訂的網域名稱，您可以使用該網域建立任何信箱帳號。

## Forms

account-provisioner-mail-input =
    .placeholder = 您的名字、暱稱或其他搜尋關鍵字
account-provisioner-domain-input =
    .placeholder = 您的名字、暱稱或其他搜尋關鍵字
account-provisioner-search-button = 搜尋
account-provisioner-button-cancel = 取消
account-provisioner-button-existing = 使用現有的郵件帳號
account-provisioner-button-back = 回上一頁

## Notifications

account-provisioner-fetching-provisioners = 正在向供應商搜尋…
account-provisioner-connection-issues = 無法與我們的註冊伺服器聯繫，請檢查您的網路連線是否正常。
account-provisioner-searching-email = 正在搜尋可用的郵件帳號…
account-provisioner-searching-domain = 正在搜尋可用的網域名稱…
account-provisioner-searching-error = 找不到可建議您使用的帳號，請嘗試改用其他搜尋關鍵字。

## Illustrations

account-provisioner-step1-image =
    .title = 選擇要建立的帳號

## Search results

# Variables:
# $count (Number) - The number of domains found during search.
account-provisioner-results-title =
    { $count ->
       *[other] 找到 { $count } 個網域名稱:
    }
account-provisioner-mail-results-caption = 您可以試者搜尋其他暱稱或詞彙來尋找更多郵件帳號。
account-provisioner-domain-results-caption = 您可以試者搜尋其他暱稱或詞彙來尋找更多網域名稱。
account-provisioner-free-account = 免費
account-provision-price-per-year = 每年 { $price }
account-provisioner-all-results-button = 顯示所有結果
