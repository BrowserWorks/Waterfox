# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = 帳號設定

## Header

account-setup-title = 設定現有的電子郵件地址
account-setup-description =
    若要使用您目前的電子郵件地址，請填寫該帳號的登入資訊。<br/>
    { -brand-product-name } 將會自動尋找可用並建議使用的伺服器設定。
account-setup-secondary-description = { -brand-product-name } 將自動搜尋建議使用的伺服器設定。
account-setup-success-title = 成功建立帳號！
account-setup-success-description = 您可以在 { -brand-short-name } 使用此帳號了。
account-setup-success-secondary-description = 您可以連結相關服務並設定帳號進階選項來加強使用體驗。

## Form fields

account-setup-name-label = 您的全名
    .accesskey = h
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = 王小明
account-setup-name-info-icon =
    .title = 您的名字，用於顯示在您的郵件上
account-setup-name-warning-icon =
    .title = 請輸入您的大名
account-setup-email-label = 電子郵件地址
    .accesskey = E
account-setup-email-input =
    .placeholder = aming_wang@example.com.tw
account-setup-email-info-icon =
    .title = 您目前的電子郵件地址
account-setup-email-warning-icon =
    .title = 電子郵件地址無效
account-setup-password-label = 密碼
    .accesskey = P
    .title = 非必填，只用來驗證使用者名稱是否正確
account-provisioner-button = 註冊新的電子郵件地址
    .accesskey = G
account-setup-password-toggle =
    .title = 顯示/隱藏密碼
account-setup-password-toggle-show =
    .title = 顯示密碼明碼
account-setup-password-toggle-hide =
    .title = 隱藏密碼
account-setup-remember-password = 記住密碼
    .accesskey = m
account-setup-exchange-label = 您的登入資訊
    .accesskey = l
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = YOURDOMAIN\yourusername
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = 登入網域

## Action buttons

account-setup-button-cancel = 取消
    .accesskey = a
account-setup-button-manual-config = 手動設定
    .accesskey = m
account-setup-button-stop = 停止
    .accesskey = S
account-setup-button-retest = 重新測試
    .accesskey = t
account-setup-button-continue = 繼續
    .accesskey = C
account-setup-button-done = 完成
    .accesskey = D

## Notifications

account-setup-looking-up-settings = 正在尋找設定…
account-setup-looking-up-settings-guess = 正在尋找設定: 嘗試使用常用的伺服器名稱…
account-setup-looking-up-settings-half-manual = 正在尋找設定: 偵測伺服器…
account-setup-looking-up-disk = 正在尋找設定: { -brand-short-name } 安裝…
account-setup-looking-up-isp = 正在尋找設定: 電子郵件服務供應商…
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = 正在尋找設定: Waterfox ISP 資料庫…
account-setup-looking-up-mx = 正在尋找設定: 收件郵件網域…
account-setup-looking-up-exchange = 正在尋找設定: Exchange 伺服器…
account-setup-checking-password = 正在檢查密碼…
account-setup-installing-addon = 正在下載安裝附加元件…
account-setup-success-half-manual = 偵測指定的伺服器後，找到下列設定:
account-setup-success-guess = 嘗試使用常用的伺服器名稱後，找到設定。
account-setup-success-guess-offline = 您目前離線。我們猜了一下，但您還是需要輸入正確的設定。
account-setup-success-password = 密碼正確
account-setup-success-addon = 已成功安裝附加元件
# Note: Do not translate or replace Waterfox. It stands for the public project mozilla.org, not Waterfox Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = 從 Waterfox ISP 資料庫找到設定
account-setup-success-settings-disk = 在 { -brand-short-name } 安裝找到設定。
account-setup-success-settings-isp = 從電子郵件服務供應商找到設定。
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = 找到 Microsoft Exchange 伺服器的設定。

## Illustrations

account-setup-step1-image =
    .title = 初始設定
account-setup-step2-image =
    .title = 載入中…
account-setup-step3-image =
    .title = 找到設定
account-setup-step4-image =
    .title = 連線錯誤
account-setup-step5-image =
    .title = 已建立帳號
account-setup-privacy-footnote2 = 您的登入資訊只會儲存在您的本機電腦上。
account-setup-selection-help = 不確定要怎麼選？
account-setup-selection-error = 需要幫忙嗎？
account-setup-success-help = 不確定接下來要做什麼嗎？
account-setup-documentation-help = 設定文件
account-setup-forum-help = 技術支援討論區
account-setup-privacy-help = 隱私權保護政策
account-setup-getting-started = 開始使用

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
       *[other] 可用設定
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = 與您的伺服器同步信件匣與郵件
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = 將您伺服器上的信件匣與郵件下載到電腦上
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
# Note: Exchange, Office365 are the name of products.
account-setup-result-exchange2-description = 使用 Microsoft Exchange 伺服器或 Office365 雲端服務
account-setup-incoming-title = 收件
account-setup-outgoing-title = 寄件
account-setup-username-title = 使用者名稱
account-setup-exchange-title = 伺服器
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = 無加密
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = 使用已存在的 SMTP 寄件伺服器
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = 收件: { $incoming }，寄件: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = 驗證失敗。可能是輸入的登入資訊不正確，或需要使用另一個使用者名稱來登入。這個使用者名稱通常會是您的 Windows 網域登入帳號，可能包含或不包含網域名稱（例如 aming_wang 或 AD\\aming_wang）
account-setup-credentials-wrong = 驗證失敗，請檢查輸入的使用者名稱與密碼是否正確
account-setup-find-settings-failed = { -brand-short-name } 找不到您適用的郵件帳號設定
account-setup-exchange-config-unverifiable = 無法確認設定方式。若您確定已經輸入正確使用者名稱與密碼的話，可能是伺服器管理員針對您的帳號停用了選擇的設定方式，請試著改用另一種通訊協定。
account-setup-provisioner-error = 使用 { -brand-short-name } 設定您的新帳號時發生錯誤，請嘗試使用您的帳號密碼手動設定帳號。

## Manual configuration area

account-setup-manual-config-title = 伺服器設定
account-setup-incoming-server-legend = 收件伺服器
account-setup-protocol-label = 通訊協定:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = 主機名稱:
account-setup-port-label = Port:
    .title = 輸入 0 即可進行自動偵測
account-setup-auto-description = { -brand-short-name } 將嘗試自動偵測留白的欄位。
account-setup-ssl-label = 連線安全性:
account-setup-outgoing-server-legend = 寄件伺服器

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = 自動偵測
ssl-no-authentication-option = 不認證
ssl-cleartext-password-option = 普通密碼
ssl-encrypted-password-option = 加密過的密碼

## Incoming/Outgoing SSL options

ssl-noencryption-option = 無
account-setup-auth-label = 驗證方式:
account-setup-username-label = 使用者名稱:
account-setup-advanced-setup-button = 進階設定
    .accesskey = A

## Warning insecure server dialog

account-setup-insecure-title = 警告！
account-setup-insecure-incoming-title = 收件設定:
account-setup-insecure-outgoing-title = 寄件設定:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = <b>{ $server }</b> 未加密連線。
account-setup-warning-cleartext-details = 不安全的郵件伺服器並不會透過加密連線來保護您的密碼和隱私資料。連線到這個伺服器很可能讓您的密碼以及隱私資料曝光。
account-setup-insecure-server-checkbox = 我了解風險
    .accesskey = u
account-setup-insecure-description = { -brand-short-name } 可讓您使用剛輸入的設定值來收信。但您仍應連絡系統管理員或電子郵件業者，確認是否有正確的連線參數可用。若需更多資訊，請參考 <a data-l10n-name="thunderbird-faq-link">Thunderbird 常見問題</a>。
insecure-dialog-cancel-button = 變更設定
    .accesskey = S
insecure-dialog-confirm-button = 確認
    .accesskey = C

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } 找到您在 { $domain } 的帳號設定資訊。您想要繼續並送出登入資訊嗎？
exchange-dialog-confirm-button = 登入
exchange-dialog-cancel-button = 取消

## Dismiss account creation dialog

exit-dialog-title = 未設定電子郵件帳號
exit-dialog-description = 您確定要取消設定過程嗎？不設定郵件帳號還是可以使用 { -brand-short-name }，但無法提供許多功能。
account-setup-no-account-checkbox = 不設定電子郵件帳號，繼續使用 { -brand-short-name }
    .accesskey = U
exit-dialog-cancel-button = 繼續設定
    .accesskey = C
exit-dialog-confirm-button = 結束設定
    .accesskey = E

## Alert dialogs

account-setup-creation-error-title = 建立帳號時發生錯誤
account-setup-error-server-exists = 收件伺服器已存在。
account-setup-confirm-advanced-title = 確認進階設定
account-setup-confirm-advanced-description = 此對話框將關閉，就算設定內容不正確也會使用目前設定來建立帳號。您確定要繼續嗎？

## Addon installation section

account-setup-addon-install-title = 安裝
account-setup-addon-install-intro = 安裝第三方附加元件後，可讓您存取此伺服器上的郵件帳號:
account-setup-addon-no-protocol = 此郵件伺服器不支援開放式通訊協定。{ account-setup-addon-install-intro }

## Success view

account-setup-settings-button = 帳號設定
account-setup-encryption-button = 端到端加密
account-setup-signature-button = 加入簽章
account-setup-dictionaries-button = 下載字典套件
account-setup-address-book-carddav-button = 連結 CardDAV 通訊錄
account-setup-address-book-ldap-button = 連結 LDAP 通訊錄
account-setup-calendar-button = 連結遠端行事曆
account-setup-linked-services-title = 連結您的線上服務
account-setup-linked-services-description = { -brand-short-name } 偵測到您的郵件帳號可連結其他服務。
account-setup-no-linked-description = 設定其他服務，讓您可充分使用 { -brand-short-name } 的相關功能。
# Variables:
# $count (Number) - The number of address books found during autoconfig.
account-setup-found-address-books-description =
    { $count ->
        [one] { -brand-short-name } 偵測到有一本通訊錄與您的電子郵件帳號連結。
       *[other] { -brand-short-name } 偵測到有 { $count } 本通訊錄與您的電子郵件帳號連結。
    }
# Variables:
# $count (Number) - The number of calendars found during autoconfig.
account-setup-found-calendars-description =
    { $count ->
        [one] { -brand-short-name } 偵測到有一份行事曆與您的電子郵件帳號連結。
       *[other] { -brand-short-name } 偵測到有 { $count } 份行事曆與您的電子郵件帳號連結。
    }
account-setup-button-finish = 完成
    .accesskey = F
account-setup-looking-up-address-books = 正在尋找通訊錄…
account-setup-looking-up-calendars = 正在尋找行事曆…
account-setup-address-books-button = 通訊錄
account-setup-calendars-button = 行事曆
account-setup-connect-link = 連結
account-setup-existing-address-book = 已連結
    .title = 已經連結該通訊錄
account-setup-existing-calendar = 已連結
    .title = 已經連結該行事曆
account-setup-connect-all-calendars = 連結所有行事曆
account-setup-connect-all-address-books = 連結所有通訊錄

## Calendar synchronization dialog

calendar-dialog-title = 連結行事曆
calendar-dialog-cancel-button = 取消
    .accesskey = C
calendar-dialog-confirm-button = 連結
    .accesskey = n
account-setup-calendar-name-label = 名稱
account-setup-calendar-name-input =
    .placeholder = 我的行事曆
account-setup-calendar-color-label = 色彩
account-setup-calendar-refresh-label = 重新整理
account-setup-calendar-refresh-manual = 手動
account-setup-calendar-refresh-interval =
    { $count ->
        [one] 每分鐘
       *[other] 每 { $count } 分鐘
    }
account-setup-calendar-read-only = 唯讀
    .accesskey = R
account-setup-calendar-show-reminders = 顯示提醒
    .accesskey = S
account-setup-calendar-offline-support = 離線支援
    .accesskey = O
