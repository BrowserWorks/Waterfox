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

## Spotlight modal shared strings

spotlight-learn-more-collapsed = Tìm hiểu thêm
    .title = Mở rộng để tìm hiểu thêm về tính năng này
spotlight-learn-more-expanded = Tìm hiểu thêm
    .title = Đóng

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = Có vẻ như bạn đang sử dụng Wi-Fi công cộng
spotlight-public-wifi-vpn-body = Để ẩn vị trí và hoạt động duyệt web của bạn, hãy xem xét đến VPN. Nó sẽ giúp bạn được bảo vệ khi duyệt web ở những nơi công cộng như sân bay và quán cà phê.
spotlight-public-wifi-vpn-primary-button = Giữ riêng tư với { -mozilla-vpn-brand-name }
    .accesskey = S
spotlight-public-wifi-vpn-link = Không phải bây giờ
    .accesskey = N

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    Thử trải nghiệm quyền riêng tư mạnh mẽ nhất
    của chúng tôi từ trước đến nay
spotlight-total-cookie-protection-body = Trình chống cookie chung ngăn những trình theo dõi sử dụng cookie để theo dõi bạn trên web.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name } xây dựng một hàng rào xung quanh cookie, giới hạn chúng ở trang web bạn đang truy cập để trình theo dõi không thể sử dụng chúng để theo dõi bạn. Với quyền truy cập sớm, bạn sẽ giúp tối ưu hóa tính năng này để chúng tôi có thể tiếp tục xây dựng một trang web tốt hơn cho mọi người.
spotlight-total-cookie-protection-primary-button = Bật Trình chống cookie chung
spotlight-total-cookie-protection-secondary-button = Không phải bây giờ
cfr-total-cookie-protection-header = Nhờ có bạn, { -brand-short-name } trở nên riêng tư và an toàn hơn bao giờ hết
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = Trình chống cookie chung là biện pháp bảo vệ quyền riêng tư mạnh nhất của chúng tôi – và giờ đây nó là cài đặt mặc định cho người dùng { -brand-short-name } ở mọi nơi. Chúng tôi không thể thực hiện được nếu không có những người tham gia quyền truy cập sớm như bạn. Vì vậy, cảm ơn bạn đã giúp chúng tôi tạo ra một Internet riêng tư và tốt hơn.

## Emotive Continuous Onboarding

spotlight-better-internet-header = Internet tốt hơn bắt đầu với bạn
spotlight-better-internet-body = Khi bạn sử dụng { -brand-short-name }, bạn đang bỏ phiếu cho một Internet mở và có thể truy cập tốt hơn cho tất cả mọi người.
spotlight-peace-mind-header = Chúng tôi đã giúp bạn được bảo vệ
spotlight-peace-mind-body = Hàng tháng, { -brand-short-name } chặn trung bình hơn 3.000 trình theo dõi cho mỗi người dùng. Bởi vì không có gì, đặc biệt là những phiền toái về quyền riêng tư như trình theo dõi, có thể ngăn cản bạn và internet tốt.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Giữ trên thanh Dock
       *[other] Ghim vào thanh tác vụ
    }
spotlight-pin-secondary-button = Không phải bây giờ
