# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/. --

page-info-window =
    .style = width: 600px; min-height: 550px;

copy =
    .key = C
menu-copy =
    .label = Sao chép
    .accesskey = C

select-all =
    .key = A
menu-select-all =
    .label = Chọn tất cả
    .accesskey = B

close-dialog =
    .key = w

general-tab =
    .label = Tổng quát
    .accesskey = T
general-title =
    .value = Tiêu đề:
general-url =
    .value = Địa chỉ:
general-type =
    .value = Kiểu:
general-mode =
    .value = Chế độ xử lí:
general-size =
    .value = Kích thước:
general-referrer =
    .value = URL liên quan:
general-modified =
    .value = Được chỉnh sửa:
general-encoding =
    .value = Mã hóa văn bản:
general-meta-name =
    .label = Tên
general-meta-content =
    .label = Nội dung

media-tab =
    .label = Đa phương tiện
    .accesskey = a
media-location =
    .value = Địa chỉ:
media-text =
    .value = Văn bản đi kèm:
media-alt-header =
    .label = Văn bản Thay thế
media-address =
    .label = Địa chỉ
media-type =
    .label = Kiểu
media-size =
    .label = Kích thước
media-count =
    .label = Tổng số
media-dimension =
    .value = Kích cỡ:
media-long-desc =
    .value = Mô tả Đầy đủ:
media-save-as =
    .label = Lưu thành…
    .accesskey = L
media-save-image-as =
    .label = Lưu thành…
    .accesskey = h

perm-tab =
    .label = Quyền hạn
    .accesskey = Q
permissions-for =
    .value = Quyền hạn cho:

security-tab =
    .label = Bảo mật
    .accesskey = B
security-view =
    .label = Xem chứng nhận
    .accesskey = C
security-view-unknown = Không rõ
    .value = Không rõ
security-view-identity =
    .value = Nhận dạng trang web
security-view-identity-owner =
    .value = Chủ sở hữu:
security-view-identity-domain =
    .value = Trang web:
security-view-identity-verifier =
    .value = Xác minh bởi:
security-view-identity-validity =
    .value = Hết hạn vào:
security-view-privacy =
    .value = Riêng tư & lịch sử

security-view-privacy-history-value = Tôi đã từng truy cập trang web này trước ngày hôm nay chưa?
security-view-privacy-sitedata-value = Có phải trang web này lưu trữ thông tin trên máy tính của tôi?

security-view-privacy-clearsitedata =
    .label = Xóa cookie và dữ liệu trang web
    .accesskey = C

security-view-privacy-passwords-value = Tôi có lưu mật khẩu nào trên trang web này không?

security-view-privacy-viewpasswords =
    .label = Xem các mật khẩu đã lưu
    .accesskey = M
security-view-technical =
    .value = Chi tiết kĩ thuật

help-button =
    .label = Trợ giúp

## These strings are used to tell the user if the website is storing cookies
## and data on the users computer in the security tab of pageInfo
## Variables:
##   $value (number) - Amount of data being stored
##   $unit (string) - The unit of data being stored (Usually KB)

security-site-data-cookies = Có, cookie và { $value } { $unit } dữ liệu trang web
security-site-data-only = Có, { $value } { $unit } dữ liệu trang web

security-site-data-cookies-only = Có, cookie
security-site-data-no = Không

image-size-unknown = Không rõ
page-info-not-specified =
    .value = Không được chỉ định
not-set-alternative-text = Không được chỉ định
not-set-date = Không được chỉ định
media-img = Hình
media-bg-img = Nền
media-border-img = Viền
media-list-img = Dấu tròn đầu dòng
media-cursor = Con trỏ
media-object = Đối tượng
media-embed = Được nhúng
media-link = Biểu tượng
media-input = Nhập vào
media-video = Đoạn phim
media-audio = Âm thanh
saved-passwords-yes = Có
saved-passwords-no = Không

no-page-title =
    .value = Trang không có tiêu đề:
general-quirks-mode =
    .value = Chế độ Quirks
general-strict-mode =
    .value = Chế độ chuẩn
page-info-security-no-owner =
    .value = Trang web này không cung cấp thông tin về người sở hữu.
media-select-folder = Chọn một thư mục để lưu hình ảnh
media-unknown-not-cached =
    .value = Không rõ (không được đệm)
permissions-use-default =
    .label = Sử dụng mặc định
security-no-visits = Không

# This string is used to display the number of meta tags
# in the General Tab
# Variables:
#   $tags (number) - The number of meta tags
general-meta-tags =
    .value =
        { $tags ->
           *[other] Meta ({ $tags } thẻ)
        }

# This string is used to display the number of times
# the user has visited the website prior
# Variables:
#   $visits (number) - The number of previous visits
security-visits-number =
    { $visits ->
        [0] Không
       *[other] Có, { $visits } lần
    }

# This string is used to display the size of a media file
# Variables:
#   $kb (number) - The size of an image in Kilobytes
#   $bytes (number) - The size of an image in Bytes
properties-general-size =
    .value =
        { $bytes ->
           *[other] { $kb } KB ({ $bytes } byte)
        }

# This string is used to display the type and number
# of frames of a animated image
# Variables:
#   $type (string) - The type of a animated image
#   $frames (number) - The number of frames in an animated image
media-animated-image-type =
    .value =
        { $frames ->
           *[other] { $type } hình ảnh (hoạt hình, { $frames } khung)
        }

# This string is used to display the type of
# an image
# Variables:
#   $type (string) - The type of an image
media-image-type =
    .value = { $type } Ảnh

# This string is used to display the size of a scaled image
# in both scaled and unscaled pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
#   $scaledx (number) - The scaled horizontal size of an image
#   $scaledy (number) - The scaled vertical size of an image
media-dimensions-scaled =
    .value = { $dimx }px × { $dimy }px (chỉnh tỉ lệ thành { $scaledx }px × { $scaledy }px)

# This string is used to display the size of an image in pixels
# Variables:
#   $dimx (number) - The horizontal size of an image
#   $dimy (number) - The vertical size of an image
media-dimensions =
    .value = { $dimx }px x { $dimy }px

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
    .label = Chặn ảnh từ { $website }
    .accesskey = C

# This string is used to display the URL of the website on top of the
# pageInfo dialog box
# Variables:
#   $website (string) - The url of the website pageInfo is getting info for
page-info-page =
    .title = Thông tin Trang - { $website }
page-info-frame =
    .title = Thông tin Khung - { $website }
