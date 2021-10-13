# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Waterfox Home / New Tab strings for about:home / about:newtab.

newtab-page-title = Thẻ mới
newtab-settings-button =
    .title = Tùy biến trang thẻ mới
newtab-personalize-icon-label =
    .title = Cá nhân hóa thẻ mới
    .aria-label = Cá nhân hóa thẻ mới
newtab-personalize-dialog-label =
    .aria-label = Cá nhân hóa

## Search box component.

# "Search" is a verb/action
newtab-search-box-search-button =
    .title = Tìm kiếm
    .aria-label = Tìm kiếm
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-text = Tìm kiếm với { $engine } hoặc nhập địa chỉ
newtab-search-box-handoff-text-no-engine = Tìm kiếm hoặc nhập địa chỉ
# Variables
#  $engine (String): the name of the user's default search engine
newtab-search-box-handoff-input =
    .placeholder = Tìm kiếm với { $engine } hoặc nhập địa chỉ
    .title = Tìm kiếm với { $engine } hoặc nhập địa chỉ
    .aria-label = Tìm kiếm với { $engine } hoặc nhập địa chỉ
newtab-search-box-handoff-input-no-engine =
    .placeholder = Tìm kiếm hoặc nhập địa chỉ
    .title = Tìm kiếm hoặc nhập địa chỉ
    .aria-label = Tìm kiếm hoặc nhập địa chỉ
newtab-search-box-search-the-web-input =
    .placeholder = Tìm trên mạng
    .title = Tìm trên mạng
    .aria-label = Tìm trên mạng
newtab-search-box-text = Tìm kiếm trên mạng
newtab-search-box-input =
    .placeholder = Tìm kiếm trên mạng
    .aria-label = Tìm kiếm trên mạng

## Top Sites - General form dialog.

newtab-topsites-add-search-engine-header = Thêm công cụ tìm kiếm
newtab-topsites-add-topsites-header = Thêm trang web hàng đầu
newtab-topsites-add-shortcut-header = Lối tắt mới
newtab-topsites-edit-topsites-header = Sửa trang web hàng đầu
newtab-topsites-edit-shortcut-header = Chỉnh sửa lối tắt
newtab-topsites-title-label = Tiêu đề
newtab-topsites-title-input =
    .placeholder = Nhập tiêu đề
newtab-topsites-url-label = URL
newtab-topsites-url-input =
    .placeholder = Nhập hoặc dán URL
newtab-topsites-url-validation = Yêu cầu URL hợp lệ
newtab-topsites-image-url-label = Hình ảnh Tuỳ chỉnh URL
newtab-topsites-use-image-link = Sử dụng hình ảnh tùy chỉnh…
newtab-topsites-image-validation = Không tải được hình ảnh. Hãy thử một URL khác.

## Top Sites - General form dialog buttons. These are verbs/actions.

newtab-topsites-cancel-button = Hủy bỏ
newtab-topsites-delete-history-button = Xóa khỏi lịch sử
newtab-topsites-save-button = Lưu lại
newtab-topsites-preview-button = Xem trước
newtab-topsites-add-button = Thêm

## Top Sites - Delete history confirmation dialog.

newtab-confirm-delete-history-p1 = Bạn có chắc bạn muốn xóa bỏ mọi thứ của trang này từ lịch sử?
# "This action" refers to deleting a page from history.
newtab-confirm-delete-history-p2 = Thao tác này không thể hoàn tác được.

## Top Sites - Sponsored label

newtab-topsite-sponsored = Được tài trợ

## Context Menu - Action Tooltips.

# General tooltip for context menus.
newtab-menu-section-tooltip =
    .title = Mở bảng chọn
    .aria-label = Mở bảng chọn
# Tooltip for dismiss button
newtab-dismiss-button-tooltip =
    .title = Gỡ bỏ
    .aria-label = Gỡ bỏ
# This tooltip is for the context menu of Pocket cards or Topsites
# Variables:
#  $title (String): The label or hostname of the site. This is for screen readers when the context menu button is focused/active.
newtab-menu-content-tooltip =
    .title = Mở bảng chọn
    .aria-label = Mở bảng chọn ngữ cảnh cho { $title }
# Tooltip on an empty topsite box to open the New Top Site dialog.
newtab-menu-topsites-placeholder-tooltip =
    .title = Chỉnh sửa trang web này
    .aria-label = Chỉnh sửa trang web này

## Context Menu: These strings are displayed in a context menu and are meant as a call to action for a given page.

newtab-menu-edit-topsites = Chỉnh sửa
newtab-menu-open-new-window = Mở trong cửa sổ mới
newtab-menu-open-new-private-window = Mở trong cửa sổ riêng tư mới
newtab-menu-dismiss = Bỏ qua
newtab-menu-pin = Ghim
newtab-menu-unpin = Bỏ ghim
newtab-menu-delete-history = Xóa khỏi lịch sử
newtab-menu-save-to-pocket = Lưu vào { -pocket-brand-name }
newtab-menu-delete-pocket = Xóa khỏi { -pocket-brand-name }
newtab-menu-archive-pocket = Lưu trữ trong { -pocket-brand-name }
newtab-menu-show-privacy-info = Nhà tài trợ của chúng tôi và sự riêng tư của bạn

## Message displayed in a modal window to explain privacy and provide context for sponsored content.

newtab-privacy-modal-button-done = Xong
newtab-privacy-modal-button-manage = Quản lý cài đặt nội dung được tài trợ
newtab-privacy-modal-header = Vấn đề riêng tư của bạn.
newtab-privacy-modal-paragraph-2 =
    Ngoài việc tận hưởng những câu chuyện hấp dẫn, chúng tôi cũng cho bạn thấy có liên quan,
    nội dung được đánh giá cao từ các nhà tài trợ chọn lọc. Hãy yên tâm, <strong>dữ liệu duyệt của bạn
    không bao giờ để lại bản sao { -brand-product-name }</strong> của bạn — chúng tôi không thể nhìn thấy nó
    và các tài trợ của chúng tôi cũng vậy.
newtab-privacy-modal-link = Tìm hiểu cách hoạt động của quyền riêng tư trên thẻ mới

##

# Bookmark is a noun in this case, "Remove bookmark".
newtab-menu-remove-bookmark = Xóa dấu trang
# Bookmark is a verb here.
newtab-menu-bookmark = Dấu trang

## Context Menu - Downloaded Menu. "Download" in these cases is not a verb,
## it is a noun. As in, "Copy the link that belongs to this downloaded item".

newtab-menu-copy-download-link = Sao chép địa chỉ tải xuống
newtab-menu-go-to-download-page = Đi tới trang web tải xuống
newtab-menu-remove-download = Xóa khỏi lịch sử

## Context Menu - Download Menu: These are platform specific strings found in the context menu of an item that has
## been downloaded. The intention behind "this action" is that it will show where the downloaded file exists on the file
## system for each operating system.

newtab-menu-show-file =
    { PLATFORM() ->
        [macos] Hiển thị trong Finder
       *[other] Mở thư mục chứa
    }
newtab-menu-open-file = Mở tập tin

## Card Labels: These labels are associated to pages to give
## context on how the element is related to the user, e.g. type indicates that
## the page is bookmarked, or is currently open on another device.

newtab-label-visited = Đã truy cập
newtab-label-bookmarked = Đã được đánh dấu
newtab-label-removed-bookmark = Đã xóa dấu trang
newtab-label-recommended = Xu hướng
newtab-label-saved = Đã lưu vào { -pocket-brand-name }
newtab-label-download = Đã tải xuống
# This string is used in the story cards to indicate sponsored content
# Variables:
#  $sponsorOrSource (String): This is the name of a company or their domain
newtab-label-sponsored = { $sponsorOrSource } · Được tài trợ
# This string is used at the bottom of story cards to indicate sponsored content
# Variables:
#  $sponsor (String): This is the name of a sponsor
newtab-label-sponsored-by = Được tài trợ bởi { $sponsor }
# This string is used under the image of story cards to indicate source and time to read
# Variables:
#  $source (String): This is the name of a company or their domain
#  $timeToRead (Number): This is the estimated number of minutes to read this story
newtab-label-source-read-time = { $source } · { $timeToRead } phút

## Section Menu: These strings are displayed in the section context menu and are
## meant as a call to action for the given section.

newtab-section-menu-remove-section = Xoá mục
newtab-section-menu-collapse-section = Thu gọn mục
newtab-section-menu-expand-section = Mở rộng mục
newtab-section-menu-manage-section = Quản lý mục
newtab-section-menu-manage-webext = Quản lí tiện ích
newtab-section-menu-add-topsite = Thêm trang web hàng đầu
newtab-section-menu-add-search-engine = Thêm công cụ tìm kiếm
newtab-section-menu-move-up = Di chuyển lên
newtab-section-menu-move-down = Di chuyển xuống
newtab-section-menu-privacy-notice = Thông báo bảo mật

## Section aria-labels

newtab-section-collapse-section-label =
    .aria-label = Thu gọn mục
newtab-section-expand-section-label =
    .aria-label = Mở rộng mục

## Section Headers.

newtab-section-header-topsites = Trang web hàng đầu
newtab-section-header-highlights = Nổi bật
newtab-section-header-recent-activity = Hoạt động gần đây
# Variables:
#  $provider (String): Name of the corresponding content provider.
newtab-section-header-pocket = Được đề xuất bởi { $provider }

## Empty Section States: These show when there are no more items in a section. Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.

newtab-empty-section-highlights = Bắt đầu duyệt web và chúng tôi sẽ hiển thị một số bài báo, video, và các trang khác mà bạn đã xem hoặc đã đánh dấu tại đây.
# Ex. When there are no more Pocket story recommendations, in the space where there would have been stories, this is shown instead.
# Variables:
#  $provider (String): Name of the content provider for this section, e.g "Pocket".
newtab-empty-section-topstories = Bạn đã bắt kịp. Kiểm tra lại sau để biết thêm các câu chuyện hàng đầu từ { $provider }. Không muốn đợi? Chọn một chủ đề phổ biến để tìm thêm những câu chuyện tuyệt vời từ khắp nơi trên web.

## Empty Section (Content Discovery Experience). These show when there are no more stories or when some stories fail to load.

newtab-discovery-empty-section-topstories-header = Bạn đã bắt kịp!
newtab-discovery-empty-section-topstories-content = Kiểm tra lại sau để biết thêm câu chuyện.
newtab-discovery-empty-section-topstories-try-again-button = Thử lại
newtab-discovery-empty-section-topstories-loading = Đang tải…
# Displays when a layout in a section took too long to fetch articles.
newtab-discovery-empty-section-topstories-timed-out = Rất tiếc! Chúng tôi gần như tải phần này, nhưng không hoàn toàn.

## Pocket Content Section.

# This is shown at the bottom of the trending stories section and precedes a list of links to popular topics.
newtab-pocket-read-more = Các chủ đề phổ biến:
newtab-pocket-new-topics-title = Muốn nhiều câu chuyện hơn nữa? Xem các chủ đề phổ biến này từ { -pocket-brand-name }
newtab-pocket-more-recommendations = Nhiều khuyến nghị hơn
newtab-pocket-learn-more = Tìm hiểu thêm
newtab-pocket-cta-button = Nhận { -pocket-brand-name }
newtab-pocket-cta-text = Lưu những câu chuyện bạn yêu thích trong { -pocket-brand-name } và vui vẻ khi đọc chúng.
newtab-pocket-pocket-firefox-family = { -pocket-brand-name } là một phần của gia đình { -brand-product-name }
# A save to Pocket button that shows over the card thumbnail on hover.
newtab-pocket-save-to-pocket = Lưu vào { -pocket-brand-name }
newtab-pocket-saved-to-pocket = Đã lưu vào { -pocket-brand-name }
# This is a button shown at the bottom of the Pocket section that loads more stories when clicked.
newtab-pocket-load-more-stories-button = Tải thêm các câu chuyện

## Pocket Final Card Section.
## This is for the final card in the Pocket grid.

newtab-pocket-last-card-title = Bạn đã bắt kịp tất cả!
newtab-pocket-last-card-desc = Kiểm tra lại sau để biết thêm.
newtab-pocket-last-card-image =
    .alt = Bạn đã bắt kịp tất cả

## Error Fallback Content.
## This message and suggested action link are shown in each section of UI that fails to render.

newtab-error-fallback-info = Rất tiếc, đã xảy ra lỗi khi tải nội dung này.
newtab-error-fallback-refresh-link = Thử làm mới lại trang.

## Customization Menu

newtab-custom-shortcuts-title = Lối tắt
newtab-custom-shortcuts-subtitle = Các trang web bạn lưu hoặc truy cập
newtab-custom-row-selector =
    { $num ->
       *[other] { $num } hàng
    }
newtab-custom-sponsored-sites = Các lối tắt được tài trợ
newtab-custom-pocket-title = Được đề xuất bởi { -pocket-brand-name }
newtab-custom-pocket-subtitle = Nội dung đặc biệt do { -pocket-brand-name }, một phần của { -brand-product-name }, quản lý
newtab-custom-pocket-sponsored = Câu chuyện được tài trợ
newtab-custom-recent-title = Hoạt động gần đây
newtab-custom-recent-subtitle = Tuyển chọn các trang và nội dung gần đây
newtab-custom-close-button = Đóng
newtab-custom-settings = Quản lý các cài đặt khác
