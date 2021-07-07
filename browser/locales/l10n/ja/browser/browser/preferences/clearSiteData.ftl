# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = データを消去
    .style = width: 35em
clear-site-data-description = { -brand-short-name } に保存した Cookie とサイトデータをすべて消去すると、ウェブサイトからログアウトされることがあります。また、オフラインのウェブコンテンツが削除されます。キャッシュデータの消去は、ログイン状態には影響しません。
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie とサイトデータ ({ $amount } { $unit })
    .accesskey = S
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookie とサイトデータ
    .accesskey = S
clear-site-data-cookies-info = 消去すると、ウェブサイトからログアウトされることがあります
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = ウェブコンテンツのキャッシュ ({ $amount } { $unit })
    .accesskey = W
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = ウェブコンテンツのキャッシュ
    .accesskey = W
clear-site-data-cache-info = ウェブサイトの画像とデータの再読み込みが必要になります
clear-site-data-cancel =
    .label = キャンセル
    .accesskey = C
clear-site-data-clear =
    .label = 消去
    .accesskey = l
clear-site-data-dialog =
    .buttonlabelaccept = 消去
    .buttonaccesskeyaccept = l
