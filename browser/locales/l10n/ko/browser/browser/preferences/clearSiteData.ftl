# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = 데이터 지우기
    .style = width: 35em
clear-site-data-description = { -brand-short-name }에 저장된 모든 쿠키와 사이트 데이터를 지우면 웹 사이트에서 로그아웃되고 오프라인 웹 콘텐츠가 삭제될 수 있습니다. 캐시 데이터를 지우는 것은 로그인에 영향을 미치지 않습니다.
clear-site-data-close-key =
    .key = w
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = 쿠키 및 사이트 데이터 ({ $amount } { $unit })
    .accesskey = S
# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = 쿠키 및 사이트 데이터
    .accesskey = S
clear-site-data-cookies-info = 지우면 웹 사이트에서 로그아웃됩니다
# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = 캐시된 웹 콘텐츠 ({ $amount } { $unit })
    .accesskey = W
# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = 캐시된 웹 콘텐츠
    .accesskey = W
clear-site-data-cache-info = 웹 사이트에서 이미지와 데이터를 다시 로드해야 합니다
clear-site-data-dialog =
    .buttonlabelaccept = 지우기
    .buttonaccesskeyaccept = l
