# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = 清除資料
    .style = width: 35em
clear-site-data-description = 清除 { -brand-short-name } 儲存的所有 Cookie 與網站資料可能會將您從許多網站登出，並清除網頁離線內容。單純清除快取資料則不會影響登入狀態。
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie 與網站資料（{ $amount } { $unit }）
    .accesskey = S
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookie 與網站資料
    .accesskey = S
clear-site-data-cookies-info = 清除後，網站可能會要求您重新登入
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = 網頁快取內容（{ $amount } { $unit }）
    .accesskey = W
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = 網頁快取內容
    .accesskey = W
clear-site-data-cache-info = 將重新載入網站的圖片與資料
clear-site-data-cancel =
    .label = 取消
    .accesskey = C
clear-site-data-clear =
    .label = 清除
    .accesskey = l
clear-site-data-dialog =
    .buttonlabelaccept = 清除
    .buttonaccesskeyaccept = l
