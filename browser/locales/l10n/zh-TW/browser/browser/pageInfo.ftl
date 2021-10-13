# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 500px;

copy =
    .key = C
menu-copy =
    .label = 複製
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = 全選
    .accesskey = A

close-dialog =
    .key = w

general-tab =
    .label = 一般
    .accesskey = G
general-title =
    .value = 標題:
general-url =
    .value = 網址:
general-type =
    .value = 類型:
general-mode =
    .value = 繪製模式:
general-size =
    .value = 大小:
general-referrer =
    .value = 參照網址:
general-modified =
    .value = 上次修改:
general-encoding =
    .value = 文字編碼:
general-meta-name =
    .label = 名稱
general-meta-content =
    .label = 內容

media-tab =
    .label = 媒體
    .accesskey = M
media-location =
    .value = 位置:
media-text =
    .value = 關聯文字:
media-alt-header =
    .label = 替代文字
media-address =
    .label = 位置
media-type =
    .label = 類型
media-size =
    .label = 大小
media-count =
    .label = 數量
media-dimension =
    .value = 尺寸:
media-long-desc =
    .value = 完整描述:
media-save-as =
    .label = 另存新檔…
    .accesskey = a
media-save-image-as =
    .label = 另存新檔…
    .accesskey = e

perm-tab =
    .label = 權限
    .accesskey = P
permissions-for =
    .value = 此網站權限設定:

security-tab =
    .label = 安全
    .accesskey = S
security-view =
    .label = 檢視憑證
    .accesskey = V
security-view-unknown = 未知
    .value = 未知
security-view-identity =
    .value = 網站身份
security-view-identity-owner =
    .value = 擁有者:
security-view-identity-domain =
    .value = 網站:
security-view-identity-verifier =
    .value = 驗證機構:
security-view-identity-validity =
    .value = 到期於:
security-view-privacy =
    .value = 隱私權及瀏覽記錄

security-view-privacy-history-value = 我以前瀏覽過這個網站嗎？
security-view-privacy-sitedata-value = 此網站有在我的電腦中儲存資訊嗎？

security-view-privacy-clearsitedata =
    .label = 清除 Cookie 與網站資料
    .accesskey = C

security-view-privacy-passwords-value = 我有在此網站儲存任何密碼嗎？

security-view-privacy-viewpasswords =
    .label = 檢視已存密碼
    .accesskey = w
security-view-technical =
    .value = 技術細節

help-button =
    .label = 說明

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = 有，Cookie 及 { $value } { $unit } 的網站資料
security-site-data-only = 有，{ $value } { $unit } 的網站資料

security-site-data-cookies-only = 有，僅 Cookie
security-site-data-no = 無

##

image-size-unknown = 未知
page-info-not-specified =
    .value = 未指定
not-set-alternative-text = 未指定
not-set-date = 未指定
media-img = 圖片
media-bg-img = 背景
media-border-img = 邊框
media-list-img = 項目清單
media-cursor = 游標
media-object = 物件
media-embed = 內嵌
media-link = 圖示
media-input = 輸入
media-video = 視訊
media-audio = 音訊
saved-passwords-yes = 是
saved-passwords-no = 否

no-page-title =
    .value = 未命名頁面:
general-quirks-mode =
    .value = Quirks 模式
general-strict-mode =
    .value = 標準遵循模式
page-info-security-no-owner =
    .value = 這個網站沒有提供擁有者資訊。
media-select-folder = 請選擇要儲存圖片的資料夾
media-unknown-not-cached =
    .value = 未知（未快取）
permissions-use-default =
    .label = 使用預設值
security-no-visits = 否

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
           *[other] Meta（{ $tags } 個標籤）
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] 沒有
        [one] 有，1 次
       *[other] 有，{ $visits } 次
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
           *[other] { $kb } KB（{ $bytes } 位元組）
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
           *[other] { $type } 圖片（動畫，{ $frames } 個畫格）
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } 圖片

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px（縮放為 { $scaledx }px × { $scaledy }px）

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px × { $dimy }px

# This string is used to display the size of a media
# file in kilobytes
# Variables:
#   $size (number) - The size of the media file in kilobytes
media-file-size = { $size } KB

# This string is used to display the website name next to the
# "Block Images" checkbox in the media tab
# Variables:
#   $website (string) - The website name
media-block-image =
    .label = 封鎖來自 { $website } 的圖片
    .accesskey = B

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) — The url of the website pageInfo is getting info for
page-info-page =
    .title = 頁面資訊 — { $website }
page-info-frame =
    .title = 頁框資訊 — { $website }
