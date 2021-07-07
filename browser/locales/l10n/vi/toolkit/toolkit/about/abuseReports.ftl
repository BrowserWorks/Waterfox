# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Localized string used as the dialog window title (a new behavior locked
# behind the "extensions.abuseReport.openDialog" preference).
# "Report" is a noun in this case, "Report for AddonName".
#
# Variables:
#   $addon-name (string) - Name of the add-on being reported
abuse-report-dialog-title = Báo cáo về { $addon-name }

abuse-report-title-extension = Báo cáo tiện ích mở rộng này cho { -vendor-short-name }
abuse-report-title-theme = Báo cáo chủ đề này cho { -vendor-short-name }
abuse-report-subtitle = Vấn đề là gì?

# Variables:
#   $author-name (string) - Name of the add-on author
abuse-report-addon-authored-by = bởi <a data-l10n-name="author-name">{ $author-name }</a>

abuse-report-learnmore =
    Không chắc chắn vấn đề cần chọn?
    <a data-l10n-name="learnmore-link">Tìm hiểu thêm về việc báo cáo tiện ích mở rộng và chủ đề</a>

abuse-report-submit-description = Mô tả vấn đề (tùy chọn)
abuse-report-textarea =
    .placeholder = Chúng tôi dễ dàng giải quyết vấn đề hơn nếu chúng tôi có thông tin cụ thể. Hãy mô tả những gì bạn đã trải qua. Cảm ơn bạn đã giúp chúng tôi giữ cho web lành mạnh.
abuse-report-submit-note =
    Lưu ý: Không bao gồm thông tin cá nhân (như tên, địa chỉ thư điện tử, số điện thoại, địa chỉ nhà).
    { -vendor-short-name } giữ một bản ghi vĩnh viễn của các báo cáo này.

## Panel buttons.

abuse-report-cancel-button = Hủy
abuse-report-next-button = Tiếp
abuse-report-goback-button = Quay lại
abuse-report-submit-button = Gửi

## Message bars descriptions.


## Variables:
##   $addon-name (string) - Name of the add-on

## Message bars descriptions.
##
## Variables:
##   $addon-name (string) - Name of the add-on

abuse-report-messagebar-aborted = Báo cáo về <span data-l10n-name="addon-name">{ $addon-name }</span> đã bị hủy.
abuse-report-messagebar-submitting = Đang gửi báo cáo về <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-submitted = Cám ơn bạn đã gửi báo cáo. Bạn có muốn xóa <span data-l10n-name="addon-name">{ $addon-name }</span> không?
abuse-report-messagebar-submitted-noremove = Cảm ơn bạn đã gửi báo cáo.
abuse-report-messagebar-removed-extension = Cảm ơn bạn đã gửi báo cáo. Bạn đã xóa tiện ích mở rộng <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-removed-theme = Cảm ơn bạn đã gửi báo cáo. Bạn đã xóa chủ đề <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error = Đã xảy ra lỗi khi gửi báo cáo về <span data-l10n-name="addon-name">{ $addon-name }</span>.
abuse-report-messagebar-error-recent-submit = Báo cáo về <span data-l10n-name="addon-name">{ $addon-name }</span> không thể gửi do đã có một báo cáo khác đã được gửi gần đây.

## Message bars actions.

abuse-report-messagebar-action-remove-extension = Vâng, loại bỏ nó
abuse-report-messagebar-action-keep-extension = Không, tôi sẽ giữ nó
abuse-report-messagebar-action-remove-theme = Vâng, loại bỏ nó
abuse-report-messagebar-action-keep-theme = Không, tôi sẽ giữ nó
abuse-report-messagebar-action-retry = Thử lại
abuse-report-messagebar-action-cancel = Hủy

## Abuse report reasons (optionally paired with related examples and/or suggestions)

abuse-report-damage-reason-v2 = Nó làm hỏng máy tính của tôi hoặc làm hỏng dữ liệu của tôi
abuse-report-damage-example = Ví dụ: bị nhiễm phần mềm độc hại hay đánh cắp dữ liệu

abuse-report-spam-reason-v2 = Nó chứa thư rác hoặc chèn quảng cáo không mong muốn
abuse-report-spam-example = Ví dụ: chèn quảng cáo trên các trang web

abuse-report-settings-reason-v2 = Nó đã thay đổi công cụ tìm kiếm, trang chủ hoặc thẻ mới của tôi mà không thông báo hoặc hỏi tôi
abuse-report-settings-suggestions = Trước khi báo cáo tiện ích mở rộng, bạn có thể thử thay đổi cài đặt của mình:
abuse-report-settings-suggestions-search = Thay đổi cài đặt tìm kiếm mặc định của bạn
abuse-report-settings-suggestions-homepage = Thay đổi trang chủ và thẻ mới của bạn

abuse-report-deceptive-reason-v2 = Nó tuyên bố là một cái gì đó mà nó không làm
abuse-report-deceptive-example = Ví dụ: phần mô tả hoặc hình ảnh gây hiểu lầm

abuse-report-broken-reason-extension-v2 = Nó không hoạt động, phá vỡ các trang web hoặc làm chậm { -brand-product-name }
abuse-report-broken-reason-theme-v2 = Nó không hoạt động hoặc phá vỡ cách trình duyệt hiển thị
abuse-report-broken-example = Ví dụ: tính năng chậm, khó sử dụng hoặc không hoạt động; các phần của trang web không tải được hoặc trông khác thường
abuse-report-broken-suggestions-extension =
    Có vẻ như bạn đã xác định được một lỗi. Ngoài việc gửi báo cáo ở đây, cách tốt nhất
    để giải quyết vấn đề là liên hệ với nhà phát triển tiện ích mở rộng.
    <a data-l10n-name="support-link">Truy cập trang web tiện ích mở rộng</a> để nhận thông tin về nhà phát triển.
abuse-report-broken-suggestions-theme =
    Có vẻ như bạn đã xác định được một lỗi. Ngoài việc gửi báo cáo ở đây, cách tốt nhất
    để giải quyết vấn đề là liên hệ với nhà phát triển chủ đề.
    <a data-l10n-name="support-link">Truy cập trang web chủ đề của</a> để lấy thông tin nhà phát triển.

abuse-report-policy-reason-v2 = Nó chứa nội dung thù địch, bạo lực hoặc bất hợp pháp
abuse-report-policy-suggestions =
    Lưu ý: Các vấn đề về bản quyền và nhãn hiệu phải được báo cáo trong một quy trình riêng.
    <a data-l10n-name="report-infringement-link">Sử dụng các hướng dẫn này</a> để
    báo cáo vấn đề.

abuse-report-unwanted-reason-v2 = Tôi không bao giờ muốn nó và không biết làm thế nào để thoát khỏi nó
abuse-report-unwanted-example = Ví dụ: Một ứng dụng đã cài đặt nó mà không có sự cho phép của tôi

abuse-report-other-reason = Điều gì đó khác

