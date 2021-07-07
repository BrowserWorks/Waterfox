# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = Tiện ích được đề xuất
cfr-doorhanger-feature-heading = Tính năng được đề xuất
cfr-doorhanger-pintab-heading = Hãy thử cái này: Ghim thẻ

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = Tại sao tôi thấy cái này
cfr-doorhanger-extension-cancel-button = Không phải bây giờ
    .accesskey = N
cfr-doorhanger-extension-ok-button = Thêm vào ngay
    .accesskey = A
cfr-doorhanger-pintab-ok-button = Ghim thẻ này
    .accesskey = P
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
cfr-doorhanger-pintab-description = Dễ dàng truy cập vào các trang web được sử dụng nhiều nhất của bạn. Giữ các trang web mở trong một thẻ (ngay cả khi bạn khởi động lại).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = <b>Nhấp chuột phải</b> trên thẻ bạn muốn ghim.
cfr-doorhanger-pintab-step2 = Chọn <b>Ghim thẻ</b> từ menu.
cfr-doorhanger-pintab-step3 = Nếu trang web có bản cập nhật, bạn sẽ thấy một chấm màu xanh trên thẻ được ghim.
cfr-doorhanger-pintab-animation-pause = Tạm dừng
cfr-doorhanger-pintab-animation-resume = Tiếp tục

## Firefox Accounts Message

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
cfr-whatsnew-panel-header = Có gì mới
cfr-whatsnew-release-notes-link-text = Đọc ghi chú phát hành
cfr-whatsnew-fx70-title = { -brand-short-name } bây giờ chiến đấu mạnh mẽ hơn cho quyền riêng tư của bạn
cfr-whatsnew-fx70-body =
    Bản cập nhật mới nhất nâng cao tính năng chống theo dõi và làm cho nó
    dễ dàng hơn bao giờ hết để tạo mật khẩu an toàn cho mọi trang web.
cfr-whatsnew-tracking-protect-title = Bảo vệ bạn khỏi trình theo dõi
cfr-whatsnew-tracking-protect-body =
    { -brand-short-name } chặn nhiều trình theo dõi xã hội và trang web phổ biến mà
    nó theo dõi những gì bạn làm trực tuyến
cfr-whatsnew-tracking-protect-link-text = Xem báo cáo của bạn
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
       *[other] Trình theo dõi đã chặn
    }
cfr-whatsnew-tracking-blocked-subtitle = Từ { DATETIME($earliestDate, month: "long", year: "numeric") }
cfr-whatsnew-tracking-blocked-link-text = Xem báo cáo
cfr-whatsnew-lockwise-backup-title = Sao lưu mật khẩu của bạn
cfr-whatsnew-lockwise-backup-body = Bây giờ tạo mật khẩu an toàn, bạn có thể truy cập bất cứ nơi nào bạn đăng nhập.
cfr-whatsnew-lockwise-backup-link-text = Bật sao lưu
cfr-whatsnew-lockwise-take-title = Mang mật khẩu theo bên bạn
cfr-whatsnew-lockwise-take-body =
    Ứng dụng di động { -lockwise-brand-short-name } cho phép bạn truy cập an toàn
    mật khẩu được sao lưu từ bất cứ đâu.
cfr-whatsnew-lockwise-take-link-text = Tải ứng dụng

## Search Bar

cfr-whatsnew-searchbar-title = Nhập ít hơn, tìm nhiều hơn với thanh địa chỉ
cfr-whatsnew-searchbar-body-topsites = Bây giờ, chỉ cần chọn thanh địa chỉ và một hộp sẽ mở rộng với các liên kết đến các trang web hàng đầu của bạn.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = Biểu tượng kính lúp

## Picture-in-Picture

cfr-whatsnew-pip-header = Xem video trong khi bạn duyệt
cfr-whatsnew-pip-body = Hình trong hình bật video vào một cửa sổ nổi để bạn có thể xem trong khi làm việc trong các thẻ khác.
cfr-whatsnew-pip-cta = Tìm hiểu thêm

## Permission Prompt

cfr-whatsnew-permission-prompt-header = Ít trang web gây phiền nhiễu hơn
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name } hiện chặn các trang web tự động yêu cầu gửi cho bạn thông báo bật lên.
cfr-whatsnew-permission-prompt-cta = Tìm hiểu thêm

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
       *[other] Dấu vết bị chặn
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name } chặn nhiều trang lấy dấu vết để bí mật thu thập thông tin về thiết bị và hành động của bạn để tạo hồ sơ quảng cáo về bạn.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = Dấu vết
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name } có thể chặn những trang lấy dấu vết để bí mật thu thập thông tin về thiết bị và hành động của bạn để tạo hồ sơ quảng cáo về bạn.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = Nhận dấu trang này trên điện thoại của bạn
cfr-doorhanger-sync-bookmarks-body = Nhận dấu trang, mật khẩu, lịch sử của bạn và nhiều nơi khác mà bạn đã đăng nhập vào { -brand-product-name }.
cfr-doorhanger-sync-bookmarks-ok-button = Bật { -sync-brand-short-name }
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = Không bao giờ mất mật khẩu lần nữa
cfr-doorhanger-sync-logins-body = Lưu trữ an toàn và đồng bộ hóa mật khẩu của bạn với tất cả các thiết bị của bạn.
cfr-doorhanger-sync-logins-ok-button = Bật { -sync-brand-short-name }
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = Đọc cái này khi đang di chuyển
cfr-doorhanger-send-tab-recipe-header = Mang công thức này vào bếp
cfr-doorhanger-send-tab-body = Gửi thẻ cho phép bạn dễ dàng chia sẻ liên kết này với điện thoại của mình hoặc bất cứ nơi nào bạn đăng nhập vào { -brand-product-name }.
cfr-doorhanger-send-tab-ok-button = Thử trình gửi thẻ
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = Chia sẻ PDF này một cách an toàn
cfr-doorhanger-firefox-send-body = Giữ các tài liệu nhạy cảm của bạn an toàn khỏi những con mắt tò mò với mã hóa đầu cuối và một liên kết sẽ biến mất khi bạn thực hiện xong.
cfr-doorhanger-firefox-send-ok-button = Thử { -send-brand-name }
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = Xem mục bảo vệ
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = Đóng
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = Đừng hiện cho tôi những tin này nữa
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name } đã dừng mạng xã hội mà nó theo dõi bạn tại đây
cfr-doorhanger-socialtracking-description = Vấn đề riêng tư của bạn. { -brand-short-name } hiện chặn các trình theo dõi phương tiện truyền thông xã hội phổ biến, giới hạn số lượng dữ liệu họ có thể thu thập về những gì bạn làm trực tuyến.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name } đã chặn một dấu vết trên trang này
cfr-doorhanger-fingerprinters-description = Vấn đề riêng tư của bạn. { -brand-short-name } hiện chặn các dấu vết, mà nó thu thập các mẫu thông tin nhận dạng duy nhất về thiết bị của bạn để theo dõi bạn.
cfr-doorhanger-cryptominers-heading = { -brand-short-name } đã chặn một loại tiền điện tử trên trang này
cfr-doorhanger-cryptominers-description = Vấn đề riêng tư của bạn. { -brand-short-name } hiện chặn các loại tiền điện tử, mà nó sử dụng sức mạnh tính toán của hệ thống của bạn để khai thác tiền kỹ thuật số.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name } đã chặn hơn <b>{ $blockedCount }</b> trình theo dõi từ { $date }!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name } đã chặn hơn <b>{ $blockedCount }</b> trình theo dõi kể từ { DATETIME($date, month: "long", year: "numeric") }!
    }
cfr-doorhanger-milestone-ok-button = Xem tất cả
    .accesskey = S

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = Dễ dàng tạo mật khẩu an toàn
cfr-whatsnew-lockwise-body = Thật khó để nghĩ về mật khẩu độc đáo, an toàn cho mọi tài khoản. Khi tạo mật khẩu, chọn trường mật khẩu để sử dụng mật khẩu được tạo an toàn từ { -brand-shorter-name }.
cfr-whatsnew-lockwise-icon-alt = Biểu tượng { -lockwise-brand-short-name }

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = Nhận thông báo về mật khẩu dễ bị tấn công
cfr-whatsnew-passwords-body = Tin tặc biết mọi người sử dụng lại cùng một mật khẩu. Nếu bạn đã sử dụng cùng một mật khẩu trên nhiều trang web và một trong những trang web đó đã bị rò rỉ dữ liệu, bạn sẽ thấy một cảnh báo trong { -lockwise-brand-short-name } để thay đổi mật khẩu của bạn trên các trang web đó.
cfr-whatsnew-passwords-icon-alt = Biểu tượng khóa mật khẩu dễ bị tổn thương

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = Làm cho hình trong hình toàn màn hình
cfr-whatsnew-pip-fullscreen-body = Khi bạn bật video vào một cửa sổ nổi, bây giờ bạn có thể nhấp đúp vào cửa sổ đó để vào chế độ toàn màn hình.
cfr-whatsnew-pip-fullscreen-icon-alt = Biểu tượng hình trong hình

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = Đóng
    .accesskey = C

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = Bảo vệ trong nháy mắt
cfr-whatsnew-protections-body = Bảng điều khiển bảo vệ bao gồm các báo cáo tóm tắt về rò rỉ dữ liệu và quản lý mật khẩu. Bây giờ bạn có thể theo dõi có bao nhiêu rò rỉ mà bạn đã giải quyết và xem liệu bất kỳ mật khẩu đã lưu nào của bạn có thể bị lộ trong một rò rỉ dữ liệu hay không.
cfr-whatsnew-protections-cta-link = Xem bảng điều khiển bảo vệ
cfr-whatsnew-protections-icon-alt = Biểu tượng khiên

## Better PDF message

cfr-whatsnew-better-pdf-header = Trải nghiệm PDF tốt hơn
cfr-whatsnew-better-pdf-body = Tài liệu PDF hiện mở trực tiếp bằng { -brand-short-name }, giữ cho công việc của bạn trong tầm tay dễ dàng.

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

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = Bảo vệ tự động, không có theo dõi ẩn
cfr-whatsnew-clear-cookies-body = Một số trình theo dõi chuyển hướng bạn đến các trang web khác bí mật đặt cookie. { -brand-short-name } bây giờ sẽ tự động xóa các cookie đó để bạn không thể bị theo dõi.
cfr-whatsnew-clear-cookies-image-alt = Minh họa về cookie bị chặn

## What's new: Media controls message

cfr-whatsnew-media-keys-header = Điều khiển phương tiện khác
cfr-whatsnew-media-keys-body = Phát và tạm dừng âm thanh hoặc video ngay từ bàn phím hoặc tai nghe của bạn, giúp bạn dễ dàng điều khiển phương tiện từ thẻ, chương trình khác hoặc ngay cả khi máy tính của bạn bị khóa. Bạn cũng có thể di chuyển giữa các bản nhạc bằng cách sử dụng các phím tiến và lùi.
cfr-whatsnew-media-keys-button = Tìm hiểu cách thức

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = Tìm kiếm các phím tắt trong thanh địa chỉ
cfr-whatsnew-search-shortcuts-body = Bây giờ, khi bạn nhập công cụ tìm kiếm hoặc trang web cụ thể vào thanh địa chỉ, một phím tắt màu xanh lam sẽ xuất hiện trong các đề xuất tìm kiếm bên dưới. Chọn lối tắt đó để hoàn tất tìm kiếm của bạn trực tiếp từ thanh địa chỉ.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = Bảo vệ khỏi supercookie độc hại
cfr-whatsnew-supercookies-body = Các trang web có thể bí mật đính kèm một “supercookie” vào trình duyệt của bạn để có thể theo dõi bạn trên khắp trang web, ngay cả sau khi bạn xóa cookie của mình. { -brand-short-name } hiện cung cấp khả năng bảo vệ mạnh mẽ chống lại các supercookie để chúng không thể được sử dụng để theo dõi các hoạt động trực tuyến của bạn từ trang web này sang trang web khác.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = Đánh dấu trang tốt hơn
cfr-whatsnew-bookmarking-body = Theo dõi các trang web yêu thích của bạn dễ dàng hơn. Bây giờ { -brand-short-name } nhớ vị trí ưa thích của bạn cho các dấu trang đã lưu, hiển thị thanh công cụ dấu trang theo mặc định trên các thẻ mới và cho phép bạn dễ dàng truy cập vào phần còn lại của dấu trang thông qua thư mục thanh công cụ.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = Bảo vệ toàn diện khỏi theo dõi cookie trên nhiều trang web
cfr-whatsnew-cross-site-tracking-body = Bây giờ bạn có thể chọn tham gia để bảo vệ tốt hơn khỏi theo dõi cookie. { -brand-short-name } có thể cô lập các hoạt động và dữ liệu của bạn với trang web bạn hiện đang truy cập, vì vậy thông tin được lưu trữ trong trình duyệt sẽ không được chia sẻ giữa các trang web.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = Các video trên trang web này có thể phát không đúng trên phiên bản { -brand-short-name } này. Để được hỗ trợ đầy đủ về video, hãy cập nhật { -brand-short-name } ngay bây giờ.
cfr-doorhanger-video-support-header = Cập nhật { -brand-short-name } để phát video
cfr-doorhanger-video-support-primary-button = Cập nhật bây giờ
    .accesskey = U
