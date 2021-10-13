# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Tiện ích được đề xuất
cfr-doorhanger-feature-heading = Tính năng được đề xuất

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Tại sao tôi thấy cái này

cfr-doorhanger-extension-cancel-button = Không phải bây giờ
    .accesskey = N

cfr-doorhanger-extension-ok-button = Thêm vào ngay
    .accesskey = A

cfr-doorhanger-extension-manage-settings-button = Quản lý các thiết lập được đề xuất
    .accesskey = M

cfr-doorhanger-extension-never-show-recommendation = Không hiển thị cho tôi đề xuất này
    .accesskey = S

cfr-doorhanger-extension-learn-more-link = Tìm hiểu thêm

# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = bởi { $name }

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = Đề xuất
cfr-doorhanger-extension-notification2 = Đề xuất
    .tooltiptext = Tiện ích được đề xuất
    .a11y-announcement = Tiện ích được đề xuất có sẵn

# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = Đề xuất
    .tooltiptext = Tính năng được đề xuất
    .a11y-announcement = Tính năng được đề xuất có sẵn

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
           *[other] { $total } sao
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
       *[other] { $total } người dùng
    }

## These messages are steps on how to use the feature and are shown together.

## Waterfox Accounts Message

cfr-doorhanger-bookmark-fxa-header = Đồng bộ dấu trang của bạn ở mọi nơi.
cfr-doorhanger-bookmark-fxa-body = Đã tìm thấy tuyệt vời! Bây giờ hãy đồng bộ các dấu trang này với thiết bị di động của bạn. Bắt đầu với một { -fxaccount-brand-name }.
cfr-doorhanger-bookmark-fxa-link-text = Đồng bộ hóa dấu trang ngay bây giờ...
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = Nút đóng
    .title = Đóng

## Protections panel

cfr-protections-panel-header = Duyệt mà không bị theo dõi
cfr-protections-panel-body = Giữ dữ liệu của bạn cho chính mình. { -brand-short-name } bảo vệ bạn khỏi nhiều trình theo dõi phổ biến nhất theo dõi những gì bạn làm trực tuyến.
cfr-protections-panel-link-text = Tìm hiểu thêm

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = Tính năng mới:

cfr-whatsnew-button =
    .label = Có gì mới
    .tooltiptext = Có gì mới

cfr-whatsnew-release-notes-link-text = Đọc ghi chú phát hành

## Search Bar

## Picture-in-Picture

## Permission Prompt

## Fingerprinter Counter

## Bookmark Sync

## Login Sync

## Send Tab

## Waterfox Send

## Social Tracking Protection

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } đã chặn hơn <b>{ $blockedCount }</b> trình theo dõi kể từ { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Xem tất cả
    .accesskey = S

## What’s New Panel Content for Waterfox 76


## Lockwise message

## Vulnerable Passwords message

## Picture-in-Picture fullscreen message

## Protections Dashboard message

## Better PDF message

cfr-doorhanger-milestone-close-button = Đóng
    .accesskey = C

## DOH Message

cfr-doorhanger-doh-body = Vấn đề riêng tư của bạn. { -brand-short-name } bây giờ định tuyến an toàn các yêu cầu DNS của bạn bất cứ khi nào có thể đến dịch vụ đối tác để bảo vệ bạn trong khi bạn duyệt.
cfr-doorhanger-doh-header = Truy vấn DNS được mã hóa, an toàn hơn
cfr-doorhanger-doh-primary-button-2 = Okey
    .accesskey = O
cfr-doorhanger-doh-secondary-button = Vô hiệu hóa
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = Quyền riêng tư của bạn được đặt lên hàng đầu. { -brand-short-name } hiện cô lập hoặc các trang web với nhau vào sandbox, điều này khiến tin tặc khó lấy cắp mật khẩu, số thẻ tín dụng và các thông tin nhạy cảm khác.
cfr-doorhanger-fission-header = Cách ly trang web
cfr-doorhanger-fission-primary-button = OK, đã hiểu
    .accesskey = O
cfr-doorhanger-fission-secondary-button = Tìm hiểu thêm
    .accesskey = T

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Các video trên trang web này có thể phát không đúng trên phiên bản { -brand-short-name } này. Để được hỗ trợ đầy đủ về video, hãy cập nhật { -brand-short-name } ngay bây giờ.
cfr-doorhanger-video-support-header = Cập nhật { -brand-short-name } để phát video
cfr-doorhanger-video-support-primary-button = Cập nhật bây giờ
    .accesskey = U

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

spotlight-public-wifi-vpn-header = Có vẻ như bạn đang sử dụng Wi-Fi công cộng
spotlight-public-wifi-vpn-body = Để ẩn vị trí và hoạt động duyệt web của bạn, hãy xem xét đến VPN. Nó sẽ giúp bạn được bảo vệ khi duyệt web ở những nơi công cộng như sân bay và quán cà phê.
spotlight-public-wifi-vpn-primary-button = Giữ riêng tư với { -mozilla-vpn-brand-name }
    .accesskey = S
spotlight-public-wifi-vpn-link = Không phải bây giờ
    .accesskey = N
