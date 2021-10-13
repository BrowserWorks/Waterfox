# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

clear-site-data-window =
    .title = Xóa dữ liệu
    .style = width: 35em

clear-site-data-description = Xóa tất cả cookie và dữ liệu trang được lưu bởi { -brand-short-name } có thể khiến bạn đăng xuất khỏi trang web và xóa các nội dung ngoại tuyến. Xóa dữ liệu cache sẽ không ảnh hưởng đến đăng nhập của bạn.

clear-site-data-close-key =
    .key = w

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cookies and Site Data (24 KB)"
# Variables:
#   $amount (Number) - Amount of site data currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cookies-with-data =
    .label = Cookie và dữ liệu trang ({ $amount } { $unit })
    .accesskey = S

# This string is a placeholder for while the data used to fill
# clear-site-data-cookies-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cookies-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cookies-empty =
    .label = Cookie và dữ liệu trang
    .accesskey = S

clear-site-data-cookies-info = Bạn có thể bị đăng xuất khỏi trang web nếu xóa

# The parameters in parentheses in this string describe disk usage
# in the format ($amount $unit), e.g. "Cached Web Content (24 KB)"
# Variables:
#   $amount (Number) - Amount of cache currently stored on disk
#   $unit (String) - Abbreviation of the unit that $amount is in, e.g. "MB"
clear-site-data-cache-with-data =
    .label = Nội dung web lưu vào cache ({ $amount } { $unit })
    .accesskey = W

# This string is a placeholder for while the data used to fill
# clear-site-data-cache-with-data is loading. This placeholder is usually
# only shown for a very short time (< 1s), so it should be very similar
# or the same as clear-site-data-cache-with-data (except the amount and unit),
# to avoid flickering.
clear-site-data-cache-empty =
    .label = Nội dung web được nhớ đệm
    .accesskey = W

clear-site-data-cache-info = Sẽ yêu cầu trang web tải lại ảnh và dữ liệu

clear-site-data-dialog =
    .buttonlabelaccept = Xóa
    .buttonaccesskeyaccept = l
