# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Quản lí tiện ích
search-header =
    .placeholder = Tìm kiếm addons.mozilla.org
    .searchbuttonlabel = Tìm kiếm
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Tải tiện ích mở rộng và chủ đề trên <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = Bạn không có tiện ích nào thuộc kiểu này được cài đặt
list-empty-available-updates =
    .value = Không tìm thấy cập nhật
list-empty-recent-updates =
    .value = Bạn chưa cập nhật tiện ích nào gần đây
list-empty-find-updates =
    .label = Kiểm tra cập nhật
list-empty-button =
    .label = Tìm hiểu thêm về tiện ích
help-button = Hỗ trợ tiện ích
sidebar-help-button-title =
    .title = Hỗ trợ tiện ích
addons-settings-button = Cài đặt { -brand-short-name }
sidebar-settings-button-title =
    .title = Cài đặt { -brand-short-name }
show-unsigned-extensions-button =
    .label = Không thể xác thực một số tiện ích
show-all-extensions-button =
    .label = Hiện tất cả các tiện ích
detail-version =
    .label = Phiên bản
detail-last-updated =
    .label = Cập nhật lần cuối
detail-contributions-description = Nhà phát triển tiện ích này đề nghị bạn hỗ trợ một khoản tài chính nhỏ cho việc phát triển.
detail-contributions-button = Đóng góp
    .title = Đóng góp cho sự phát triển của tiện ích mở rộng này
    .accesskey = C
detail-update-type =
    .value = Cập nhật tự động
detail-update-default =
    .label = Mặc định
    .tooltiptext = Chỉ tự động cài đặt cập nhật khi đó là mặc định
detail-update-automatic =
    .label = Bật
    .tooltiptext = Tự động cài đặt cập nhật
detail-update-manual =
    .label = Tắt
    .tooltiptext = Không tự động cài đặt cập nhật
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Chạy trong cửa sổ riêng tư
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Không được phép trong cửa sổ riêng tư
detail-private-disallowed-description2 = Tiện ích mở rộng này không chạy trong khi duyệt web riêng tư. <a data-l10n-name="learn-more">Tìm hiểu thêm</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Yêu cầu quyền truy cập vào cửa sổ riêng tư
detail-private-required-description2 = Tiện ích mở rộng này có quyền truy cập vào các hoạt động trực tuyến của bạn trong khi duyệt web riêng tư. <a data-l10n-name="learn-more">Tìm hiểu thêm</a>
detail-private-browsing-on =
    .label = Cho phép
    .tooltiptext = Kích hoạt trong duyệt web riêng tư
detail-private-browsing-off =
    .label = Không cho phép
    .tooltiptext = Vô hiệu hóa trong duyệt web riêng tư
detail-home =
    .label = Trang chủ
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Hồ sơ tiện ích
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Kiểm tra cập nhật
    .accesskey = U
    .tooltiptext = Kiểm tra cập nhật cho tiện ích này
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Tùy chọn
           *[other] Tùy chỉnh
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Thay đổi tùy chọn của tiện ích này
           *[other] Thay đổi tùy chỉnh của tiện ích này
        }
detail-rating =
    .value = Xếp hạng
addon-restart-now =
    .label = Khởi động lại ngay
disabled-unsigned-heading =
    .value = Một số tiện ích đã bị vô hiệu hóa
disabled-unsigned-description = Những tiện ích sau chưa được kiểm tra tương thích với { -brand-short-name }. Bạn có thể <label data-l10n-name="find-addons">tìm tiện ích thay thế</label> hoặc chờ nhà phát triển cập nhật bản mới.
disabled-unsigned-learn-more = Tìm hiểu về nỗ lực đảm bảo an toàn trên mạng cho bạn của chúng tôi.
disabled-unsigned-devinfo = Nếu bạn là lập trình viên và muốn tiện ích của mình được kiểm tra thì có thể đọc <label data-l10n-name="learn-more">tài liệu hướng dẫn</label> của chúng tôi.
plugin-deprecation-description = Bạn đang thấy thiếu gì đó? Một số phần bổ trợ không còn được hỗ trợ bởi { -brand-short-name }. <label data-l10n-name="learn-more">Tìm hiểu thêm.</label>
legacy-warning-show-legacy = Hiển thị các tiện ích mở rộng kế thừa
legacy-extensions =
    .value = Tiện ích mở rộng kế thừa
legacy-extensions-description = Các tiện ích mở rộng này không đáp ứng tiêu chuẩn hiện tại của { -brand-short-name } do đó chúng đã bị ngừng hoạt động. <label data-l10n-name="legacy-learn-more">Tìm hiểu về các thay đổi tiện ích</label>
private-browsing-description2 =
    { -brand-short-name } đang thay đổi cách các tiện ích mở rộng hoạt động trong trình duyệt riêng tư. Bất kỳ tiện ích mở rộng mới nào bạn thêm vào
    { -brand-short-name } sẽ không chạy theo mặc định trong cửa sổ riêng tư. Trừ khi bạn cho phép nó trong cài đặt,
    tiện ích mở rộng sẽ không chạy trong khi duyệt web riêng tư và sẽ không có quyền truy cập vào các hoạt động trực tuyến của bạn.
    Chúng tôi đã thực hiện thay đổi này để giữ trình duyệt của bạn riêng tư.
    <label data-l10n-name="private-browsing-learn-more">Tìm hiểu cách quản lý cài đặt tiện ích mở rộng.</label>
addon-category-discover = Đề xuất
addon-category-discover-title =
    .title = Đề xuất
addon-category-extension = Tiện ích mở rộng
addon-category-extension-title =
    .title = Tiện ích mở rộng
addon-category-theme = Chủ đề
addon-category-theme-title =
    .title = Chủ đề
addon-category-plugin = Phần bổ trợ
addon-category-plugin-title =
    .title = Phần bổ trợ
addon-category-dictionary = Từ điển
addon-category-dictionary-title =
    .title = Từ điển
addon-category-locale = Ngôn ngữ
addon-category-locale-title =
    .title = Ngôn ngữ
addon-category-available-updates = Cập nhật có sẵn
addon-category-available-updates-title =
    .title = Cập nhật có sẵn
addon-category-recent-updates = Cập nhật gần đây
addon-category-recent-updates-title =
    .title = Cập nhật gần đây

## These are global warnings

extensions-warning-safe-mode = Tất cả tiện ích đã bị vô hiệu hóa bởi chế độ an toàn.
extensions-warning-check-compatibility = Việc kiểm tra tính tương thích của tiện ích đã bị vô hiệu hóa. Có thể bạn đang dùng các tiện ích không còn tương thích nữa.
extensions-warning-check-compatibility-button = Bật
    .title = Kích hoạt kiểm tra tính tương thích của tiện ích
extensions-warning-update-security = Việc kiểm tra tính an toàn của các cập nhật tiện ích đã bị vô hiệu hóa. Bạn có thể bị tổn hại nếu cập nhật.
extensions-warning-update-security-button = Bật
    .title = Kích hoạt kiểm tra tính bảo mật của cập nhật cho tiện ích

## Strings connected to add-on updates

addon-updates-check-for-updates = Kiểm tra cập nhật
    .accesskey = C
addon-updates-view-updates = Xem các cập nhật gần đây
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Tự động cập nhật tiện ích
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Thiết lập cập nhật tự động tất cả các tiện ích
    .accesskey = R
addon-updates-reset-updates-to-manual = Thiết lập cập nhật thủ công tất cả các tiện ích
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = Đang cập nhật tiện ích
addon-updates-installed = Các tiện ích của bạn đã được cập nhật.
addon-updates-none-found = Không tìm thấy cập nhật
addon-updates-manual-updates-found = Xem các cập nhật hiện có

## Add-on install/debug strings for page options menu

addon-install-from-file = Cài đặt tiện ích từ tập tin…
    .accesskey = I
addon-install-from-file-dialog-title = Chọn tiện ích để cài đặt
addon-install-from-file-filter-name = Tiện ích
addon-open-about-debugging = Gỡ lỗi tiện ích
    .accesskey = b

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Quản lý phím tắt tiện ích mở rộng
    .accesskey = s
shortcuts-no-addons = Bạn không có bất kỳ tiện ích mở rộng nào được kích hoạt.
shortcuts-no-commands = Các tiện ích mở rộng sau không có phím tắt:
shortcuts-input =
    .placeholder = Nhập một phím tắt
shortcuts-browserAction2 = Kích hoạt nút thanh công cụ
shortcuts-pageAction = Kích hoạt hành động trang
shortcuts-sidebarAction = Chuyển đến thanh lề
shortcuts-modifier-mac = Bao gồmCtrl, Alt, hoặc ⌘
shortcuts-modifier-other = Bao gồm Ctrl hoặc Alt
shortcuts-invalid = Kết hợp không hợp lệ
shortcuts-letter = Nhập một kí tự
shortcuts-system = Không thể ghi đè một phím tắt { -brand-short-name }
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Phím tắt trùng lặp
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } đang được sử dụng làm phím tắt trong nhiều trường hợp. Phím tắt trùng lặp có thể gây ra hành vi bất ngờ.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Đã được sử dụng bởi { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] Hiển thị { $numberToShow } khác
    }
shortcuts-card-collapse-button = Hiện ít hơn
header-back-button =
    .title = Quay lại

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Tiện ích mở rộng và chủ đề giống như các ứng dụng cho trình duyệt của bạn và chúng cho phép
    bạn bảo vệ mật khẩu, tải video, tìm giao dịch, chặn quảng cáo gây phiền nhiễu, thay đổi
    trình duyệt của bạn trông như thế nào, và nhiều hơn nữa. Những chương trình phần mềm
    nhỏ này là thường được phát triển bởi một bên thứ ba. Ở đây, một lựa chọn
    <a data-l10n-name="learn-more-trigger">đề xuất</a> { -brand-product-name } cho trường hợp
    bảo mật, hiệu suất và chức năng đặc biệt.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Một số trong những khuyến nghị được cá nhân hóa. Nó dựa trên khác
    tiện ích mở rộng mà bạn đã cài đặt, tùy chọn hồ sơ và thống kê sử dụng.
discopane-notice-learn-more = Tìm hiểu thêm
privacy-policy = Chính sách riêng tư
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = bởi <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Người dùng: { $dailyUsers }
install-extension-button = Thêm vào { -brand-product-name }
install-theme-button = Cài đặt chủ đề
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Quản lý
find-more-addons = Tìm thêm tiện ích
find-more-themes = Tìm thêm chủ đề
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Tùy chọn khác

## Add-on actions

report-addon-button = Báo cáo
remove-addon-button = Xóa
# The link will always be shown after the other text.
remove-addon-disabled-button = Không thể xóa bỏ dữ liệu <a data-l10n-name="link">Tại sao?</a>
disable-addon-button = Tắt
enable-addon-button = Bật
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Bật
preferences-addon-button =
    { PLATFORM() ->
        [windows] Tùy chọn
       *[other] Tùy chỉnh
    }
details-addon-button = Chi tiết
release-notes-addon-button = Ghi chú phát hành
permissions-addon-button = Quyền hạn
extension-enabled-heading = Đã bật
extension-disabled-heading = Đã vô hiệu hóa
theme-enabled-heading = Đã bật
theme-disabled-heading = Đã tắt
theme-monochromatic-heading = Màu
theme-monochromatic-subheading = Các màu mới sống động từ { -brand-product-name }. Có sẵn trong một thời gian giới hạn.
plugin-enabled-heading = Đã bật
plugin-disabled-heading = Đã tắt
dictionary-enabled-heading = Đã bật
dictionary-disabled-heading = Đã tắt
locale-enabled-heading = Đã bật
locale-disabled-heading = Đã tắt
always-activate-button = Luôn kích hoạt
never-activate-button = Không bao giờ kích hoạt
addon-detail-author-label = Tác giả
addon-detail-version-label = Phiên bản
addon-detail-last-updated-label = Cập nhật cuối
addon-detail-homepage-label = Trang chủ
addon-detail-rating-label = Xêp hạng
# Message for add-ons with a staged pending update.
install-postponed-message = Tiện ích mở rộng này sẽ được cập nhật khi { -brand-short-name } khởi động lại.
install-postponed-button = Cập nhật ngay
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Xếp hạng { NUMBER($rating, maximumFractionDigits: 1) } trên 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (đã vô hiệu hóa)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
       *[other] { $numberOfReviews } đánh giá
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> đã bị xóa.
pending-uninstall-undo-button = Hoàn tác
addon-detail-updates-label = Cho phép cập nhật tự động
addon-detail-updates-radio-default = Mặc định
addon-detail-updates-radio-on = Bật
addon-detail-updates-radio-off = Tắt
addon-detail-update-check-label = Kiểm tra cập nhật
install-update-button = Cập nhật
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Được phép trong cửa sổ riêng tư
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Khi được cho phép, tiện ích mở rộng sẽ có quyền truy cập vào các hoạt động trực tuyến của bạn trong khi duyệt web riêng tư. <a data-l10n-name="learn-more">Tìm hiểu thêm</a>
addon-detail-private-browsing-allow = Cho phép
addon-detail-private-browsing-disallow = Không cho phép

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } chỉ đề xuất các tiện ích mở rộng đáp ứng các tiêu chuẩn của chúng tôi về bảo mật và hiệu suất
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Waterfox" in the string below because the extensions are built
# by Waterfox and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Tiện ích mở rộng chính thức do Waterfox xây dựng. Đáp ứng các tiêu chuẩn về bảo mật và hiệu suất.
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Tiện ích mở rộng này đã được xem xét để đáp ứng các tiêu chuẩn của chúng tôi về bảo mật và hiệu suất
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Cập nhật có sẵn
recent-updates-heading = Cập nhật gần đây
release-notes-loading = Đang tải…
release-notes-error = Xin lỗi, nhưng có lỗi xảy ra khi mở ghi chú phát hành.
addon-permissions-empty = Tiện ích mở rộng này không yêu cầu bất kỳ quyền nào
addon-permissions-required = Các quyền cần thiết cho chức năng cốt lõi:
addon-permissions-optional = Các quyền tùy chọn cho chức năng được bổ sung:
addon-permissions-learnmore = Tìm hiểu thêm về quyền hạn
recommended-extensions-heading = Tiện ích mở rộng được đề xuất
recommended-themes-heading = Chủ đề được đề xuất
# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = Cảm thấy muốn sáng tạo? <a data-l10n-name="link">Xây dựng chủ đề của riêng bạn với Waterfox Color.</a>

## Page headings

extension-heading = Quản lí tiện ích của bạn
theme-heading = Quản lí chủ đề của bạn
plugin-heading = Quản lí phần bổ trợ của bạn
dictionary-heading = Quản lí từ điển của bạn
locale-heading = Quản lí ngôn ngữ của bạn
updates-heading = Quản lý cập nhật của bạn
discover-heading = Cá nhân hóa { -brand-short-name } của bạn
shortcuts-heading = Quản lý phím tắt tiện ích mở rộng
default-heading-search-label = Tìm thêm tiện ích
addons-heading-search-input =
    .placeholder = Tìm kiếm addons.mozilla.org
addon-page-options-button =
    .title = Công cụ cho tất cả tiện ích
