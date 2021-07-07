# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

close-button =
    .aria-label = Đóng
preferences-title =
    .title =
        { PLATFORM() ->
            [windows] Tùy chọn
           *[other] Tùy chỉnh
        }
preferences-tab-title =
    .title = Tùy chỉnh
preferences-doc-title = Tùy chỉnh
category-list =
    .aria-label = Thể loại
pane-general-title = Tổng quát
category-general =
    .tooltiptext = { pane-general-title }
pane-compose-title = Soạn thảo
category-compose =
    .tooltiptext = Soạn thảo
pane-privacy-title = Riêng tư & Bảo mật
category-privacy =
    .tooltiptext = Riêng tư & Bảo mật
pane-chat-title = Trò chuyện
category-chat =
    .tooltiptext = Trò chuyện
pane-calendar-title = Lịch
category-calendar =
    .tooltiptext = Lịch
general-language-and-appearance-header = Ngôn ngữ & giao diện
general-incoming-mail-header = Thư đến:
general-files-and-attachment-header = Tập tin & đính kèm
general-tags-header = Nhãn
general-reading-and-display-header = Đọc & hiển thị
general-updates-header = Cập nhật
general-network-and-diskspace-header = Mạng & dung lượng trống
general-indexing-label = Chỉ mục
composition-category-header = Soạn thảo
composition-attachments-header = Đính kèm
composition-spelling-title = Chính tả
compose-html-style-title = Phong cách HTML
composition-addressing-header = Địa chỉ
privacy-main-header = Riêng tư
privacy-passwords-header = Mật khẩu
privacy-junk-header = Thư rác
collection-header = Thu thập và sử dụng dữ liệu { -brand-short-name }
collection-description = Chúng tôi cố gắng cung cấp cho bạn sự lựa chọn và chỉ thu thập những gì chúng tôi cần để cung cấp và cải thiện { -brand-short-name } cho tất cả mọi người. Chúng tôi luôn xin phép trước khi thu thập thông tin cá nhân.
collection-privacy-notice = Chính sách riêng tư
collection-health-report-telemetry-disabled = Bạn không còn cho phép { -vendor-short-name } thu thập dữ liệu kỹ thuật và tương tác. Tất cả dữ liệu trong quá khứ sẽ bị xóa trong vòng 30 ngày.
collection-health-report-telemetry-disabled-link = Tìm hiểu thêm
collection-health-report =
    .label = Cho phép { -brand-short-name } gửi dữ liệu kỹ thuật và tương tác tới { -vendor-short-name }
    .accesskey = r
collection-health-report-link = Tìm hiểu thêm
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Dữ liệu báo cáo bị vô hiệu hóa với cấu hình này
collection-backlogged-crash-reports =
    .label = Cho phép { -brand-short-name } thay bạn gửi các báo cáo sự cố còn tồn đọng
    .accesskey = c
collection-backlogged-crash-reports-link = Tìm hiểu thêm
privacy-security-header = Bảo mật
privacy-scam-detection-title = Phát hiện lừa đảo
privacy-anti-virus-title = Trình chống vi-rút
privacy-certificates-title = Chứng nhận
chat-pane-header = Trò chuyện
chat-status-title = Trạng thái
chat-notifications-title = Thông báo
chat-pane-styling-header = Kiểu dáng
choose-messenger-language-description = Chọn ngôn ngữ được sử dụng để hiển thị menu, tin nhắn và thông báo từ { -brand-short-name }.
manage-messenger-languages-button =
    .label = Tùy chỉnh…
    .accesskey = l
confirm-messenger-language-change-description = Khởi động lại { -brand-short-name } để áp dụng những thay đổi này
confirm-messenger-language-change-button = Áp dụng và khởi động lại
update-setting-write-failure-title = Lỗi khi lưu tùy chọn cập nhật
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } đã gặp lỗi và đã không lưu thay đổi này. Lưu ý rằng thiết lập tùy chọn cập nhật này yêu cầu quyền ghi vào tập tin bên dưới. Bạn hoặc quản trị viên hệ thống có thể giải quyết lỗi bằng cách cấp cho nhóm người dùng toàn quyền kiểm soát tập tin này.
    
    Không thể ghi vào tập tin: { $path }
update-in-progress-title = Đang cập nhật
update-in-progress-message = Bạn có muốn { -brand-short-name } tiếp tục với bản cập nhật này không?
update-in-progress-ok-button = &Loại bỏ
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Tiếp tục
addons-button = Tiện ích mở rộng & chủ đề
account-button = Cài đặt tài khoản
open-addons-sidebar-button = Tiện ích mở rộng và chủ đề

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Để tạo mật khẩu chính, hãy nhập thông tin đăng nhập Windows của bạn. Điều này giúp bảo vệ tính bảo mật của tài khoản của bạn.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = tạo một mật khẩu chính
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Để tạo mật khẩu chính, hãy nhập thông tin đăng nhập Windows của bạn. Điều này giúp bảo vệ tính bảo mật của tài khoản của bạn.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Thunderbird is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = tạo một mật khẩu chính
# Don't change this label.
master-password-os-auth-dialog-caption = { -brand-full-name }

## General Tab

focus-search-shortcut =
    .key = f
focus-search-shortcut-alt =
    .key = k
general-legend = Trang khởi động { -brand-short-name }
start-page-label =
    .label = Khi { -brand-short-name } khởi động, hiển thị trang bắt đầu trong vùng hiển thị thư
    .accesskey = W
location-label =
    .value = Địa chỉ:
    .accesskey = o
restore-default-label =
    .label = Khôi phục về mặc định
    .accesskey = R
default-search-engine = Công cụ tìm kiếm mặc định
add-search-engine =
    .label = Thêm từ tập tin
    .accesskey = A
remove-search-engine =
    .label = Xóa
    .accesskey = v
minimize-to-tray-label =
    .label = Khi { -brand-short-name } đã thu nhỏ, di chuyển nó vào khay
    .accesskey = m
new-message-arrival = Khi có thư mới:
mail-play-sound-label =
    .label =
        { PLATFORM() ->
            [macos] Phát tập tin âm thanh sau:
           *[other] Phát ra âm thanh
        }
    .accesskey =
        { PLATFORM() ->
            [macos] d
           *[other] d
        }
mail-play-button =
    .label = Phát
    .accesskey = P
change-dock-icon = Thay đổi tùy chọn cho biểu tượng ứng dụng
app-icon-options =
    .label = Tùy chọn biểu tượng ứng dụng…
    .accesskey = n
notification-settings = Thông báo và âm thanh mặc định có thể được tắt trong Notification pane của System Preferences.
animated-alert-label =
    .label = Hiển thị thông báo
    .accesskey = S
customize-alert-label =
    .label = Tùy biến…
    .accesskey = C
tray-icon-label =
    .label = Hiển thị biểu tượng trong khay thanh tác vụ
    .accesskey = t
biff-use-system-alert =
    .label = Sử dụng thông báo hệ thống
tray-icon-unread-label =
    .label = Hiển thị biểu tượng khay cho các tin nhắn chưa đọc
    .accesskey = t
tray-icon-unread-description = Được đề xuất khi sử dụng các nút trên thanh tác vụ nhỏ
mail-system-sound-label =
    .label = Âm thanh mặc định của hệ thống khi có thư mới
    .accesskey = D
mail-custom-sound-label =
    .label = Sử dụng tập tin âm thanh sau
    .accesskey = U
mail-browse-sound-button =
    .label = Duyệt…
    .accesskey = B
enable-gloda-search-label =
    .label = Cho phép tìm kiếm và lập chỉ mục đầy đủ
    .accesskey = G
datetime-formatting-legend = Định dạng ngày và giờ
language-selector-legend = Ngôn ngữ
allow-hw-accel =
    .label = Sử dụng chế độ tăng tốc phần cứng khi khả dụng
    .accesskey = h
store-type-label =
    .value = Kiểu lưu trữ thư cho tài khoản mới:
    .accesskey = T
mbox-store-label =
    .label = Tập tin trên mỗi thư mục (mbox)
maildir-store-label =
    .label = Tập tin trên mỗi thư (maildir)
scrolling-legend = Cuộn
autoscroll-label =
    .label = Sử dụng tự động cuộn
    .accesskey = U
smooth-scrolling-label =
    .label = Cuộn uyển chuyển
    .accesskey = m
system-integration-legend = Hệ thống tích hợp
always-check-default =
    .label = Luôn kiểm tra xem { -brand-short-name } có phải là ứng dụng thư mặc định khi khởi động
    .accesskey = A
check-default-button =
    .label = Kiểm tra ngay…
    .accesskey = N
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Tìm kiếm Windows
       *[other] { "" }
    }
search-integration-label =
    .label = Cho phép { search-engine-name } tìm kiếm thư
    .accesskey = S
config-editor-button =
    .label = Trình chỉnh sửa cấu hình…
    .accesskey = C
return-receipts-description = Xác định cách thức { -brand-short-name } xử lý biên lai
return-receipts-button =
    .label = Biên lai…
    .accesskey = R
update-app-legend = Cập nhật { -brand-short-name }
# Variables:
#   $version (String): version of Thunderbird, e.g. 68.0.1
update-app-version = Phiên bản { $version }
allow-description = Cho phép { -brand-short-name }
automatic-updates-label =
    .label = Tự động cài đặt các cập nhật (nên làm vì tăng tính bảo mật)
    .accesskey = A
check-updates-label =
    .label = Kiểm tra cập nhật, nhưng hãy để tôi chọn có cài đặt chúng không
    .accesskey = C
update-history-button =
    .label = Hiển thị lịch sử cập nhật
    .accesskey = p
use-service =
    .label = Sử dụng dịch vụ chạy nền để cài đặt các cập nhật
    .accesskey = b
cross-user-udpate-warning = Cài đặt này sẽ áp dụng cho tất cả các tài khoản Windows và các cấu hình của { -brand-short-name } sử dụng cài đặt này của { -brand-short-name }.
networking-legend = Kết nối
proxy-config-description = Định cấu hình cách { -brand-short-name } kết nối Internet
network-settings-button =
    .label = Cài đặt…
    .accesskey = S
offline-legend = Ngoại tuyến
offline-settings = Cấu hình thiết lập ngoại tuyến
offline-settings-button =
    .label = Ngoại tuyến…
    .accesskey = O
diskspace-legend = Dung lượng đĩa
offline-compact-folder =
    .label = Nén tất cả các thư mục khi nó sẽ lưu lại
    .accesskey = a
compact-folder-size =
    .value = MB tổng cộng

## Note: The entities use-cache-before and use-cache-after appear on a single
## line in preferences as follows:
## use-cache-before [ textbox for cache size in MB ] use-cache-after

use-cache-before =
    .value = Sử dụng tối đa
    .accesskey = U
use-cache-after = MB dung lượng đĩa cho bộ đệm

##

smart-cache-label =
    .label = Ghi đè quản lý bộ đệm tự động
    .accesskey = v
clear-cache-button =
    .label = Xóa ngay
    .accesskey = C
fonts-legend = Phông chữ & màu sắc
default-font-label =
    .value = Phông chữ mặc định:
    .accesskey = D
default-size-label =
    .value = Kích cỡ:
    .accesskey = S
font-options-button =
    .label = Nâng cao…
    .accesskey = A
color-options-button =
    .label = Màu sắc…
    .accesskey = C
display-width-legend = Thư văn bản thuần túy
# Note : convert-emoticons-label 'Emoticons' are also known as 'Smileys', e.g. :-)
convert-emoticons-label =
    .label = Hiển thị biểu tượng cảm xúc dưới dạng đồ họa
    .accesskey = e
display-text-label = Khi hiển thị các thư văn bản thuần túy được trích dẫn:
style-label =
    .value = Kiểu:
    .accesskey = y
regular-style-item =
    .label = Thông thường
bold-style-item =
    .label = Đậm
italic-style-item =
    .label = Nghiêng
bold-italic-style-item =
    .label = Nghiêng đậm
size-label =
    .value = Kích thước:
    .accesskey = z
regular-size-item =
    .label = Thông thường
bigger-size-item =
    .label = Lớn hơn
smaller-size-item =
    .label = Nhỏ hơn
quoted-text-color =
    .label = Màu sắc:
    .accesskey = o
search-input =
    .placeholder = Tìm kiếm
search-handler-table =
    .placeholder = Lọc các loại nội dung và hành động
type-column-label =
    .label = Kiểu dữ liệu
    .accesskey = T
action-column-label =
    .label = Hành động
    .accesskey = A
save-to-label =
    .label = Lưu các tập tin vào
    .accesskey = S
choose-folder-label =
    .label =
        { PLATFORM() ->
            [macos] Chọn…
           *[other] Duyệt…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] C
           *[other] B
        }
always-ask-label =
    .label = Luôn hỏi tôi nơi lưu tập tin
    .accesskey = A
display-tags-text = Thẻ có thể được sử dụng để phân loại và ưu tiên thư của bạn.
new-tag-button =
    .label = Mới…
    .accesskey = N
edit-tag-button =
    .label = Chỉnh sửa…
    .accesskey = E
delete-tag-button =
    .label = Xóa
    .accesskey = D
auto-mark-as-read =
    .label = Tự động đánh dấu thư là đã đọc
    .accesskey = A
mark-read-no-delay =
    .label = Ngay lập tức trên màn hình
    .accesskey = o

## Note: This will concatenate to "After displaying for [___] seconds",
## using (mark-read-delay) and a number (seconds-label).

mark-read-delay =
    .label = Sau khi hiển thị
    .accesskey = d
seconds-label = giây

##

open-msg-label =
    .value = Mở thư trong:
open-msg-tab =
    .label = Một thẻ mới
    .accesskey = t
open-msg-window =
    .label = Một cửa sổ thư mới
    .accesskey = n
open-msg-ex-window =
    .label = Một cửa sổ thư hiện có
    .accesskey = e
close-move-delete =
    .label = Đóng cửa sổ thư/thẻ khi di chuyển hoặc xóa
    .accesskey = C
display-name-label =
    .value = Tên hiển thị:
condensed-addresses-label =
    .label = Chỉ hiển thị tên cho những người trong sổ địa chỉ của tôi
    .accesskey = S

## Compose Tab

forward-label =
    .value = Chuyển tiếp thư:
    .accesskey = y
inline-label =
    .label = Ngay trong thư
as-attachment-label =
    .label = Dưới dạng đính kèm
extension-label =
    .label = thêm phần mở rộng cho tên tập tin
    .accesskey = e

## Note: This will concatenate to "Auto Save every [___] minutes",
## using (auto-save-label) and a number (auto-save-end).

auto-save-label =
    .label = Tự động lưu mỗi
    .accesskey = A
auto-save-end = phút

##

warn-on-send-accel-key =
    .label = Xác nhận khi sử dụng phím tắt để gửi thư
    .accesskey = C
spellcheck-label =
    .label = Kiểm tra chính tả trước khi gửi
    .accesskey = C
spellcheck-inline-label =
    .label = Kiểm tra chính tả ngay khi đang gõ
    .accesskey = E
language-popup-label =
    .value = Ngôn ngữ:
    .accesskey = L
download-dictionaries-link = Tải thêm từ điển
font-label =
    .value = Phông chữ:
    .accesskey = n
font-size-label =
    .value = Cỡ chữ:
    .accesskey = z
default-colors-label =
    .label = Sử dụng màu mặc định của trình đọc
    .accesskey = d
font-color-label =
    .value = Màu chữ:
    .accesskey = T
bg-color-label =
    .value = Màu nền:
    .accesskey = B
restore-html-label =
    .label = Khôi phục về mặc định
    .accesskey = R
default-format-label =
    .label = Sử dụng định dạng của đoạn thay vì phần thân văn bản theo mặc định
    .accesskey = P
format-description = Cấu hình hành vi định dạng văn bản
send-options-label =
    .label = Tùy chọn gửi…
    .accesskey = S
autocomplete-description = Khi tìm địa chỉ trong thư, tra cứu các mục khớp nhau trong:
ab-label =
    .label = Sổ địa chỉ nội bộ
    .accesskey = L
directories-label =
    .label = Máy chủ thư mục:
    .accesskey = D
directories-none-label =
    .none = Không có
edit-directories-label =
    .label = Chỉnh sửa thư mục…
    .accesskey = E
email-picker-label =
    .label = Tự động thêm địa chỉ email gửi đi vào:
    .accesskey = A
default-directory-label =
    .value = Thư mục khởi động mặc định trong cửa sổ của sổ địa chỉ:
    .accesskey = S
default-last-label =
    .none = Thư mục được sử dụng lần cuối
attachment-label =
    .label = Kiểm tra các tập tin đính kèm bị thiếu
    .accesskey = m
attachment-options-label =
    .label = Từ khóa…
    .accesskey = K
enable-cloud-share =
    .label = Đề nghị chia sẻ cho các tập tin lớn hơn
cloud-share-size =
    .value = MB
add-cloud-account =
    .label = Thêm…
    .accesskey = A
    .defaultlabel = Thêm…
remove-cloud-account =
    .label = Xóa
    .accesskey = R
find-cloud-providers =
    .value = Tìm thêm nhà cung cấp…
cloud-account-description = Thêm dịch vụ lưu trữ Filelink mới

## Privacy Tab

mail-content = Nội dung thư
remote-content-label =
    .label = Cho phép nội dung từ xa trong thư
    .accesskey = m
exceptions-button =
    .label = Ngoại lệ…
    .accesskey = E
remote-content-info =
    .value = Tìm hiểu thêm về các vấn đề riêng tư của nội dung từ xa
web-content = Nội dung web
history-label =
    .label = Ghi nhớ các trang web và liên kết tôi đã truy cập
    .accesskey = R
cookies-label =
    .label = Cho phép cookie từ các trang
    .accesskey = A
third-party-label =
    .value = Cho phép cookie từ bên thứ ba:
    .accesskey = c
third-party-always =
    .label = Luôn luôn
third-party-never =
    .label = Không bao giờ
third-party-visited =
    .label = Từ các trang đã truy cập
keep-label =
    .value = Lưu cho tới khi:
    .accesskey = K
keep-expire =
    .label = chúng hết hạn
keep-close =
    .label = Tôi đóng { -brand-short-name }
keep-ask =
    .label = hỏi tôi mọi lúc
cookies-button =
    .label = Hiện cookie…
    .accesskey = S
do-not-track-label =
    .label = Gửi tín hiệu “Không theo dõi” tới trang web để cho biết bạn không muốn bị theo dõi
    .accesskey = n
learn-button =
    .label = Tìm hiểu thêm
passwords-description = { -brand-short-name } có thể ghi nhớ mật khẩu cho tất cả tài khoản của bạn.
passwords-button =
    .label = Mật khẩu đã lưu…
    .accesskey = S
master-password-description = Mật khẩu chính bảo vệ tất cả mật khẩu của bạn, nhưng bạn phải nhập mật khẩu một lần mỗi phiên.
master-password-label =
    .label = Dùng một mật khẩu chính
    .accesskey = U
master-password-button =
    .label = Thay đổi mật khẩu chính…
    .accesskey = C
primary-password-description = Mật khẩu chính bảo vệ tất cả mật khẩu của bạn, nhưng bạn phải nhập mật khẩu một lần mỗi phiên.
primary-password-label =
    .label = Sử dụng mật khẩu chính
    .accesskey = U
primary-password-button =
    .label = Thay đổi mật khẩu chính…
    .accesskey = C
forms-primary-pw-fips-title = Bạn hiện đang ở chế độ FIPS. FIPS yêu cầu tính năng mật khẩu chính.
forms-master-pw-fips-desc = Thay đổi mật khẩu không thành công
junk-description = Đặt cài đặt thư rác mặc định của bạn. Cài đặt thư rác dành riêng cho tài khoản có thể được định cấu hình trong cài đặt tài khoản.
junk-label =
    .label = Khi tôi đánh dấu thư là thư rác:
    .accesskey = W
junk-move-label =
    .label = Di chuyển chúng vào thư mục "Thư rác" của tài khoản
    .accesskey = o
junk-delete-label =
    .label = Xóa chúng
    .accesskey = D
junk-read-label =
    .label = Đánh dấu thư được xác định là thư rác khi đọc
    .accesskey = M
junk-log-label =
    .label = Cho phép ghi nhật ký bộ lọc thư rác thích ứng
    .accesskey = E
junk-log-button =
    .label = Hiển thị nhật ký
    .accesskey = S
reset-junk-button =
    .label = Đặt lại dữ liệu đào tạo
    .accesskey = R
phishing-description = { -brand-short-name } có thể phân tích tin nhắn cho các vụ lừa đảo email đáng ngờ bằng cách tìm kiếm các kỹ thuật phổ biến được sử dụng để đánh lừa bạn.
phishing-label =
    .label = Hãy cho tôi biết nếu thư tôi đang đọc là một email lừa đảo đáng ngờ
    .accesskey = T
antivirus-description = { -brand-short-name } có thể giúp phần mềm chống vi-rút dễ dàng phân tích thư đến của vi-rút trước khi chúng được lưu trữ cục bộ.
antivirus-label =
    .label = Cho phép máy khách chống vi-rút cách ly các thư đến riêng lẻ
    .accesskey = A
certificate-description = Khi một máy chủ yêu cầu chứng chỉ cá nhân của tôi:
certificate-auto =
    .label = Tự động chọn một cái
    .accesskey = S
certificate-ask =
    .label = Hỏi tôi mọi lúc
    .accesskey = A
ocsp-label =
    .label = Truy vấn máy chủ đáp ứng giao thức OCSP để xác minh hiệu lực của các chứng chỉ
    .accesskey = Q
certificate-button =
    .label = Quản lý chứng chỉ…
    .accesskey = M
security-devices-button =
    .label = Thiết bị bảo mật…
    .accesskey = D

## Chat Tab

startup-label =
    .value = Khi { -brand-short-name } khởi động:
    .accesskey = s
offline-label =
    .label = Giữ tài khoản trò chuyện của tôi ngoại tuyến
auto-connect-label =
    .label = Tự động kết nối tài khoản trò chuyện của tôi

## Note: idle-label is displayed first, then there's a field where the user
## can enter a number, and itemTime is displayed at the end of the line.
## The translations of the idle-label and idle-time-label parts don't have
## to mean the exact same thing as in English; please try instead to
## translate the whole sentence.

idle-label =
    .label = Hãy để những người liên hệ của tôi biết rằng tôi đang nhàn rỗi sau
    .accesskey = I
idle-time-label = phút không hoạt động

##

away-message-label =
    .label = và đặt trạng thái của tôi thành vắng với thông báo trạng thái này:
    .accesskey = A
send-typing-label =
    .label = Gửi thông báo về việc gõ trong các cuộc hội thoại
    .accesskey = t
notification-label = Khi có tin nhắn đến:
show-notification-label =
    .label = Hiển thị thông báo:
    .accesskey = c
notification-all =
    .label = với tên người xem và tin nhắn xem trước
notification-name =
    .label = chỉ với tên người gửi
notification-empty =
    .label = không có bất kỳ thông tin nào
notification-type-label =
    .label =
        { PLATFORM() ->
            [macos] Hoạt ảnh biểu tượng trên dock
           *[other] Nhấp nháy mục trên thanh tác vụ
        }
    .accesskey =
        { PLATFORM() ->
            [macos] o
           *[other] F
        }
chat-play-sound-label =
    .label = Phát một âm thanh
    .accesskey = d
chat-play-button =
    .label = Phát
    .accesskey = P
chat-system-sound-label =
    .label = Âm thanh mặc định của hệ thống khi có thư mới
    .accesskey = D
chat-custom-sound-label =
    .label = Sử dụng tập tin âm thanh sau
    .accesskey = U
chat-browse-sound-button =
    .label = Duyệt…
    .accesskey = B
theme-label =
    .value = Chủ đề:
    .accesskey = T
style-thunderbird =
    .label = Thunderbird
style-bubbles =
    .label = Bong bóng
style-dark =
    .label = Tối
style-paper =
    .label = Những trang giấy
style-simple =
    .label = Đơn giản
preview-label = Xem trước:
no-preview-label = Không có bản xem trước
no-preview-description = Chủ đề này không hợp lệ hoặc hiện không khả dụng (tiện ích bị tắt, chế độ an toàn, …).
chat-variant-label =
    .value = Biến thể:
    .accesskey = V
chat-header-label =
    .label = Hiển thị Header
    .accesskey = H
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Tìm kiếm trong Tùy chọn
           *[other] Tìm kiếm trong Tùy chỉnh
        }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-preferences-input =
    .style = width: 15.4em
    .placeholder = Tìm kiếm trong Tùy chỉnh

## Preferences UI Search Results

search-results-header = Kết quả tìm kiếm
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Xin lỗi! Không có kết quả trong phần Tùy chọn cho “<span data-l10n-name="query"></span>”.
       *[other] Xin lỗi! Không có kết quả trong phần Tùy chỉnh cho “<span data-l10n-name="query"></span>”.
    }
search-results-help-link = Cần trợ giúp? Đi đến <a data-l10n-name="url">Hỗ trợ { -brand-short-name }</a>
