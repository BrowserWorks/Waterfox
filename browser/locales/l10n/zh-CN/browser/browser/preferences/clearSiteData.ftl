# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = 清除数据
    .style = width: 35em
clear-site-data-description = 清除 { -brand-short-name } 存储的所有 Cookie 和网站数据可能使您的网站登录状态丢失，还会删除离线网页内容。仅清除缓存数据则不会影响您的登录状态。
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie 和网站数据 ({ $amount } { $unit })
    .accesskey = S
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookie 和网站数据
    .accesskey = S
clear-site-data-cookies-info = 如果清除，您的网站登录状态可能丢失
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = 已缓存网络数据 ({ $amount } { $unit })
    .accesskey = W
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = 已缓存网络内容
    .accesskey = W
clear-site-data-cache-info = 将重新载入网站的图像等数据
clear-site-data-cancel =
    .label = 取消
    .accesskey = C
clear-site-data-clear =
    .label = 清除
    .accesskey = l
clear-site-data-dialog =
    .buttonlabelaccept = 清除
    .buttonaccesskeyaccept = l
