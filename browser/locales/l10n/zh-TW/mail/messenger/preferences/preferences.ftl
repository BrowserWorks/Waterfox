# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = 關閉
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] 選項
           *[other] 偏好設定
        }
preferences-doc-title = 偏好設定
category-list =
    .aria-label = 分類
pane-general-title = 一般
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = 編輯
category-compose =
    .tooltiptext = 編輯
pane-privacy-title = 隱私權與安全性
category-privacy =
    .tooltiptext = 隱私權與安全性
pane-chat-title = 聊天
category-chat =
    .tooltiptext = 聊天
pane-calendar-title = 行事曆
category-calendar =
    .tooltiptext = 行事曆
general-language-and-appearance-header = 語言與外觀
general-incoming-mail-header = 收到的郵件
general-files-and-attachment-header = 檔案與附件
general-tags-header = 標籤
general-reading-and-display-header = 閱讀與顯示
general-updates-header = 更新
general-network-and-diskspace-header = 網路與磁碟空間
general-indexing-label = 索引
composition-category-header = 編輯
composition-attachments-header = 附件
composition-spelling-title = 拼字檢查
compose-html-style-title = HTML 樣式
composition-addressing-header = 地址
privacy-main-header = 隱私權
privacy-passwords-header = 密碼
privacy-junk-header = 垃圾郵件
collection-header = { -brand-short-name } 資料收集與使用
collection-description = 我們致力於提供您選擇，也只會收集我們在提供與改善 { -brand-short-name } 時所必需的資料。我們也一定會經過您的同意才收集您的個人資訊。
collection-privacy-notice = 隱私權公告
collection-health-report-telemetry-disabled = 將不再允許 { -vendor-short-name } 捕捉技術與互動資料，之前收集的資料將於 30 天內刪除。
collection-health-report-telemetry-disabled-link = 了解更多
collection-health-report =
    .label = 允許 { -brand-short-name } 傳送技術與互動資料給 { -vendor-short-name }
    .accesskey = r
collection-health-report-link = 了解更多
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = 進行編譯設定時，已停用了資料回報功能
collection-backlogged-crash-reports =
    .label = 允許 { -brand-short-name } 為您傳送先前紀錄下的錯誤報告
    .accesskey = c
collection-backlogged-crash-reports-link = 了解更多
privacy-security-header = 安全性
privacy-scam-detection-title = 詐騙信偵測
privacy-anti-virus-title = 防毒
privacy-certificates-title = 憑證
chat-pane-header = 聊天
chat-status-title = 狀態
chat-notifications-title = 通知
chat-pane-styling-header = 樣式
choose-messenger-language-description = 請選擇 { -brand-short-name } 要用來顯示選單、介面訊息以及通知內容的語言。
manage-messenger-languages-button =
    .label = 設定其他語言…
    .accesskey = l
confirm-messenger-language-change-description = 重新啟動 { -brand-short-name } 來套用變更
confirm-messenger-language-change-button = 套用並重新啟動
update-setting-write-failure-title = 儲存更新偏好設定時發生錯誤
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } 遇到錯誤，並未儲存此變更。請注意: 調整此更新偏好設定，需要能夠寫入下列檔案的權限。您或您的系統管理員可以透過授予使用者此檔案的完整控制權，來解決本問題。
    
    無法寫入下列檔案: { $path }
update-in-progress-title = 更新中
update-in-progress-message = 您希望 { -brand-short-name } 使用此更新繼續嗎？
update-in-progress-ok-button = 捨棄 (&D)
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = 繼續 (&C)
addons-button = 擴充套件與佈景主題
account-button = 帳號設定
open-addons-sidebar-button = 附加元件與佈景主題

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = 請在下方輸入您的 Windows 登入帳號密碼才能建立主控密碼。這個動作是為了保護您的登入資訊安全。
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = 建立主控密碼
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = 請在下方輸入您的 Windows 登入帳號密碼才能建立主控密碼。這個動作是為了保護您的登入資訊安全。
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = 建立主控密碼
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = { -brand-short-name } 開始頁
start-page-label =
    .label = 當啟動 { -brand-short-name } 時，在郵件區顯示開始頁
    .accesskey = W
location-label =
    .value = 位置:
    .accesskey = o
restore-default-label =
    .label = 回復預設值
    .accesskey = R
default-search-engine = 預設搜尋引擎
add-search-engine =
    .label = 從檔案新增
    .accesskey = A
remove-search-engine =
    .label = 移除
    .accesskey = v
minimize-to-tray-label =
    .label = 最小化 { -brand-short-name } 時，移動到工具列
    .accesskey = m
new-message-arrival = 當有新郵件時:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] 播放下列音效檔案:
           *[other] 播放音效
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] d
        }
mail-play-button =
    .label = 播放
    .accesskey = P
change-dock-icon = 修改應用程式圖示的偏好設定
app-icon-options =
    .label = 應用程式圖示選項…
    .accesskey = n
notification-settings = 可在系統偏好設定的通知窗格中關閉警示與預設音效。
animated-alert-label =
    .label = 顯示警告視窗
    .accesskey = S
customize-alert-label =
    .label = 自訂…
    .accesskey = C
tray-icon-label =
    .label = 顯示工具列圖示
    .accesskey = t
biff-use-system-alert =
    .label = 使用系統通知
tray-icon-unread-label =
    .label = 有未讀訊息時，在工作列顯示圖示
    .accesskey = t
tray-icon-unread-description = 建議在使用小型工作列按鈕時開啟此設定
mail-system-sound-label =
    .label = 系統預設「收到新郵件」音效
    .accesskey = D
mail-custom-sound-label =
    .label = 使用下列音效檔案
    .accesskey = U
mail-browse-sound-button =
    .label = 瀏覽…
    .accesskey = B
enable-gloda-search-label =
    .label = 開啟全域搜尋與索引器
    .accesskey = E
datetime-formatting-legend = 日期與時間格式
language-selector-legend = 語言
allow-hw-accel =
    .label = 可用時開啟硬體加速
    .accesskey = h
store-type-label =
    .value = 新帳號的訊息儲存方式:
    .accesskey = T
mbox-store-label =
    .label = 為每個信件匣建立一個檔案（mbox）
maildir-store-label =
    .label = 為每封訊息建立檔案（maildir）
scrolling-legend = 捲動
autoscroll-label =
    .label = 使用自動捲動
    .accesskey = U
smooth-scrolling-label =
    .label = 使用平滑捲動
    .accesskey = m
system-integration-legend = 系統整合
always-check-default =
    .label = 每次啟動時檢查 { -brand-short-name } 是否為預設電子郵件用戶端
    .accesskey = a
check-default-button =
    .label = 立刻檢查…
    .accesskey = N
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows 搜尋
       *[other] { "" }
    }
search-integration-label =
    .label = 允許 { search-engine-name } 搜尋訊息
    .accesskey = s
config-editor-button =
    .label = 組態編輯器…
    .accesskey = C
return-receipts-description = 決定 { -brand-short-name } 要如何處理收件回執
return-receipts-button =
    .label = 收件回執…
    .accesskey = R
update-app-legend = { -brand-short-name } 更新
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = { $version } 版
allow-description = 讓 { -brand-short-name }:
automatic-updates-label =
    .label = 自動安裝更新（建議的，保持安全性）
    .accesskey = A
check-updates-label =
    .label = 自動檢查更新，但讓我選擇要不要安裝
    .accesskey = C
update-history-button =
    .label = 顯示更新記錄
    .accesskey = p
use-service =
    .label = 在背景服務當中安裝更新
    .accesskey = b
cross-user-udpate-warning = 此設定將套用到本電腦上的所有 Windows 帳號及此份 { -brand-short-name } 的所有 { -brand-short-name } 設定檔。
networking-legend = 連線
proxy-config-description = 設定 { -brand-short-name } 要如何連到網路
network-settings-button =
    .label = 設定…
    .accesskey = S
offline-legend = 離線模式
offline-settings = 離線模式設定
offline-settings-button =
    .label = 離線模式…
    .accesskey = O
diskspace-legend = 磁碟空間
offline-compact-folder =
    .label = 在可以節省超過
    .accesskey = a
compact-folder-size =
    .value = MB 時壓實重整所有郵件匣

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = 最多使用
    .accesskey = U
use-cache-after = MB 磁碟空間存放快取資料

##

smart-cache-label =
    .label = 停用自動快取管理
    .accesskey = v
clear-cache-button =
    .label = 立刻清除
    .accesskey = C
fonts-legend = 字型與色彩
default-font-label =
    .value = 預設字型:
    .accesskey = D
default-size-label =
    .value = 大小:
    .accesskey = S
font-options-button =
    .label = 進階…
    .accesskey = A
color-options-button =
    .label = 色彩…
    .accesskey = C
display-width-legend = 純文字郵件
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = 顯示表情符號圖片
    .accesskey = e
display-text-label = 顯示引用的純文字郵件時:
style-label =
    .value = 樣式:
    .accesskey = y
regular-style-item =
    .label = 正常
bold-style-item =
    .label = 粗體字
italic-style-item =
    .label = 斜體字
bold-italic-style-item =
    .label = 粗斜體
size-label =
    .value = 大小:
    .accesskey = z
regular-size-item =
    .label = 正常
bigger-size-item =
    .label = 增大
smaller-size-item =
    .label = 減少
quoted-text-color =
    .label = 色彩:
    .accesskey = o
search-input =
    .placeholder = 搜尋
search-handler-table =
    .placeholder = 篩選內容類型與動作
type-column-label =
    .label = 內容類型
    .accesskey = t
action-column-label =
    .label = 動作
    .accesskey = A
save-to-label =
    .label = 儲存檔案到
    .accesskey = S
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] 選擇…
           *[other] 瀏覽…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }
always-ask-label =
    .label = 每次都問我要存到何處
    .accesskey = A
display-tags-text = 標籤可以用來分類或排出郵件的優先順序。
new-tag-button =
    .label = 新增…
    .accesskey = N
edit-tag-button =
    .label = 編輯…
    .accesskey = E
delete-tag-button =
    .label = 刪除
    .accesskey = D
auto-mark-as-read =
    .label = 自動將郵件標示為已讀
    .accesskey = A
mark-read-no-delay =
    .label = 顯示時立刻標示
    .accesskey = o

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = 在顯示
    .accesskey = d
seconds-label = 秒之後

##

open-msg-label =
    .value = 開啟郵件於:
open-msg-tab =
    .label = 新分頁
    .accesskey = t
open-msg-window =
    .label = 新視窗
    .accesskey = n
open-msg-ex-window =
    .label = 重複使用已存在的視窗
    .accesskey = e
close-move-delete =
    .label = 在移動或刪除郵件時關閉訊息視窗/分頁
    .accesskey = C
display-name-label =
    .value = 顯示名稱:
condensed-addresses-label =
    .label = 顯示通訊錄裡設定的名字
    .accesskey = S

## Compose Tab

forward-label =
    .value = 轉寄郵件時:
    .accesskey = F
inline-label =
    .label = 引入內文
as-attachment-label =
    .label = 以附件轉寄
extension-label =
    .label = 加入副檔名
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = 每隔
    .accesskey = A
auto-save-end = 分鐘自動儲存

##

warn-on-send-accel-key =
    .label = 用快速鍵發送郵件時需要確認
    .accesskey = C
spellcheck-label =
    .label = 寄送前先檢查拼字
    .accesskey = C
spellcheck-inline-label =
    .label = 啟用拼字檢查
    .accesskey = E
language-popup-label =
    .value = 語言:
    .accesskey = L
download-dictionaries-link = 下載其他字典
font-label =
    .value = 字型:
    .accesskey = n
font-size-label =
    .value = 大小:
    .accesskey = z
default-colors-label =
    .label = 使用閱讀器的預設色彩
    .accesskey = d
font-color-label =
    .value = 文字色彩:
    .accesskey = T
bg-color-label =
    .value = 背景色彩:
    .accesskey = B
restore-html-label =
    .label = 回復為預設值
    .accesskey = R
default-format-label =
    .label = 預設使用段落模式而非內文
    .accesskey = P
format-description = 設定文字編排方式
send-options-label =
    .label = 寄送選項…
    .accesskey = S
autocomplete-description = 使用下列功能以加速尋找符合的收件者:
ab-label =
    .label = 使用自動完成收件者 Email 功能
    .accesskey = l
directories-label =
    .label = 目錄伺服器:
    .accesskey = D
directories-none-label =
    .none = 無
edit-directories-label =
    .label = 編輯目錄…
    .accesskey = E
email-picker-label =
    .label = 自動把寄信時使用的電子郵件地址加到我的:
    .accesskey = A
default-directory-label =
    .value = 通訊錄視窗開啟時的預設目錄:
    .accesskey = S
default-last-label =
    .none = 最近使用的目錄
attachment-label =
    .label = 檢查忘記加入的附件
    .accesskey = m
attachment-options-label =
    .label = 關鍵字…
    .accesskey = K
enable-cloud-share =
    .label = 檔案超過一定大小時使用雲端鏈結服務:
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = 新增…
    .accesskey = A
    .defaultlabel = 新增…
remove-cloud-account =
    .label = 移除
    .accesskey = R
find-cloud-providers =
    .value = 尋找更多供應商…
cloud-account-description = 新增雲端檔案鏈結儲存服務

## Privacy Tab

mail-content = 郵件內容
remote-content-label =
    .label = 允許在訊息中顯示遠端內容
    .accesskey = m
exceptions-button =
    .label = 例外網站…
    .accesskey = E
remote-content-info =
    .value = 了解更多遠端內容的隱私風險
web-content = 網站內容
history-label =
    .label = 記住我開啟過的網站與鏈結
    .accesskey = R
cookies-label =
    .label = 允許網站設定 Cookie
    .accesskey = A
third-party-label =
    .value = 接受來自第三方的 Cookies:
    .accesskey = c
third-party-always =
    .label = 總是
third-party-never =
    .label = 永不
third-party-visited =
    .label = 造訪過的網站
keep-label =
    .value = 保留 Cookie 直到:
    .accesskey = K
keep-expire =
    .label = Cookie 過期
keep-close =
    .label = 關閉 { -brand-short-name }
keep-ask =
    .label = 每次都詢問我
cookies-button =
    .label = 顯示 Cookie…
    .accesskey = S
do-not-track-label =
    .label = 傳送「Do Not Track」訊號，告訴網站您不想被追蹤
    .accesskey = n
learn-button =
    .label = 了解更多
passwords-description = { -brand-short-name } 可以幫您記住所有帳號的密碼。
passwords-button =
    .label = 已存密碼…
    .accesskey = S
master-password-description = 主控密碼可以保護您的密碼，但您每個作業階段時都必須輸入它一次。
master-password-label =
    .label = 使用主控密碼
    .accesskey = U
master-password-button =
    .label = 變更主控密碼…
    .accesskey = c
primary-password-description = 主控密碼可以保護您的密碼，但在每次使用瀏覽器時都必須輸入一次。
primary-password-label =
    .label = 使用主控密碼
    .accesskey = U
primary-password-button =
    .label = 變更主控密碼…
    .accesskey = C
forms-primary-pw-fips-title = 您目前使用 FIPS 模式。FIPS 模式需要有主控密碼。
forms-master-pw-fips-desc = 密碼變更失敗
junk-description = 設定您的預設垃圾郵件處理方式。可以到「帳號設定」調整各個帳號自己的處理方式。
junk-label =
    .label = 當標示郵件為垃圾信時:
    .accesskey = W
junk-move-label =
    .label = 移動到該帳號的「垃圾郵件」資料夾
    .accesskey = o
junk-delete-label =
    .label = 刪除它
    .accesskey = D
junk-read-label =
    .label = 標示垃圾郵件為已讀
    .accesskey = M
junk-log-label =
    .label = 啟用漸進式垃圾郵件過濾記錄
    .accesskey = E
junk-log-button =
    .label = 顯示記錄
    .accesskey = S
reset-junk-button =
    .label = 重設訓練資料
    .accesskey = R
phishing-description = { -brand-short-name } 可以分析詐騙郵件常用的手法找出可疑的郵件。
phishing-label =
    .label = 當我閱讀可能是詐騙信的郵件時告訴我
    .accesskey = T
antivirus-description = { -brand-short-name } 可讓防毒軟體在郵件存入電腦前檢查郵件是否有問題。
antivirus-label =
    .label = 允許防毒軟體個別處理與檢查新郵件
    .accesskey = A
certificate-description = 當伺服器要求我的個人憑證時:
certificate-auto =
    .label = 自動選擇一組憑證
    .accesskey = m
certificate-ask =
    .label = 每次都詢問我
    .accesskey = A
ocsp-label =
    .label = 向 OCSP 回應伺服器查詢，以確認憑證有效性
    .accesskey = Q
certificate-button =
    .label = 管理憑證…
    .accesskey = M
security-devices-button =
    .label = 安全性裝置…
    .accesskey = D

## Chat Tab

startup-label =
    .value = 當 { -brand-short-name } 啟動時:
    .accesskey = S
offline-label =
    .label = 保持我的聊天帳號離線
auto-connect-label =
    .label = 自動連線到我的聊天帳號

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = 讓我的聯絡人在超過
    .accesskey = I
idle-time-label = 分鐘沒有使用後知道我正在閒置

##

away-message-label =
    .label = 並將我的狀態設定為不在電腦前，且加上此狀態訊息:
    .accesskey = a
send-typing-label =
    .label = 在對話中傳送正在輸入的通知
    .accesskey = t
notification-label = 收到只傳給您的私訊時:
show-notification-label =
    .label = 顯示通知:
    .accesskey = c
notification-all =
    .label = 包含寄件者名稱與訊息預覽
notification-name =
    .label = 只有寄件者名稱
notification-empty =
    .label = 不顯示任何資訊
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] 在 dock 圖示顯示動畫
           *[other] 閃爍工具列項目
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }
chat-play-sound-label =
    .label = 播放音效
    .accesskey = d
chat-play-button =
    .label = 播放
    .accesskey = P
chat-system-sound-label =
    .label = 系統預設「收到新郵件」音效
    .accesskey = D
chat-custom-sound-label =
    .label = 使用下列音效檔案
    .accesskey = U
chat-browse-sound-button =
    .label = 瀏覽…
    .accesskey = B
theme-label =
    .value = 佈景主題:
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = 泡泡
style-dark =
    .label = 暗色
style-paper =
    .label = 紙張
style-simple =
    .label = 簡單
preview-label = 預覽:
no-preview-label = 沒有可用預覽
no-preview-description = 此佈景主題無效，或無法使用（停用了附加元件、處於安全模式等等）。
chat-variant-label =
    .value = 設計風格:
    .accesskey = V
chat-header-label =
    .label = 顯示標題
    .accesskey = H
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] 搜尋選項
           *[other] 搜尋偏好設定
        }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = 搜尋偏好設定

## Preferences UI Search Results

search-results-header = 搜尋結果
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] 抱歉！沒有「<span data-l10n-name="query"></span>」的選項搜尋結果。
       *[other] 抱歉！沒有「<span data-l10n-name="query"></span>」的偏好設定搜尋結果。
    }
search-results-help-link = 需要幫忙嗎？請到 <a data-l10n-name="url">{ -brand-short-name } 技術支援</a>
