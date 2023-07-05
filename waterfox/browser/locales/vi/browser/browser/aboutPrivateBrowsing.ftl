# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Mở một cửa sổ riêng tư
    .accesskey = P
about-private-browsing-search-placeholder = Tìm kiếm trên mạng
about-private-browsing-info-title = Bạn đang ở cửa sổ riêng tư
about-private-browsing-search-btn =
    .title = Tìm kiếm trên mạng
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Tìm kiếm với { $engine } hoặc nhập địa chỉ
about-private-browsing-handoff-no-engine =
    .title = Tìm kiếm hoặc nhập địa chỉ
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Tìm kiếm với { $engine } hoặc nhập địa chỉ
about-private-browsing-handoff-text-no-engine = Tìm kiếm hoặc nhập địa chỉ
about-private-browsing-not-private = Hiện tại bạn không sử dụng cửa sổ riêng tư riêng tư.
about-private-browsing-info-description-private-window = Cửa sổ riêng tư: { -brand-short-name } xóa lịch sử tìm kiếm và duyệt web của bạn khi bạn đóng tất cả các cửa sổ riêng tư. Điều này không làm cho bạn ẩn danh.
about-private-browsing-info-description-simplified = { -brand-short-name } xóa lịch sử tìm kiếm và duyệt web của bạn khi bạn đóng tất cả các cửa sổ riêng tư, nhưng điều này không khiến bạn ẩn danh.
about-private-browsing-learn-more-link = Tìm hiểu thêm
about-private-browsing-hide-activity = Ẩn hoạt động và vị trí của bạn, ở mọi nơi bạn duyệt
about-private-browsing-get-privacy = Nhận các biện pháp bảo vệ quyền riêng tư ở mọi nơi bạn duyệt
about-private-browsing-hide-activity-1 = Ẩn hoạt động duyệt web và vị trí với { -mozilla-vpn-brand-name }. Một cú nhấp chuột sẽ tạo ra một kết nối an toàn, ngay cả trên Wi-Fi công cộng.
about-private-browsing-prominent-cta = Giữ riêng tư với { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Tải xuống { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: Duyệt web riêng tư khi đang di chuyển
about-private-browsing-focus-promo-text = Ứng dụng di động duyệt web riêng tư chuyên dụng của chúng tôi sẽ xóa lịch sử và cookie của bạn mọi lúc.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Duyệt qua điện thoại của bạn ở chế độ riêng tư
about-private-browsing-focus-promo-text-b = Sử dụng { -focus-brand-name } cho những tìm kiếm riêng tư mà bạn không muốn trình duyệt chính trên thiết bị di động của mình nhìn thấy.
about-private-browsing-focus-promo-header-c = Quyền riêng tư nâng cao trên thiết bị di động
about-private-browsing-focus-promo-text-c = { -focus-brand-name } xóa lịch sử của bạn mọi lúc trong khi chặn quảng cáo và trình theo dõi.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } là công cụ tìm kiếm mặc định của bạn trong cửa sổ riêng tư
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Để chọn một công cụ tìm kiếm khác, hãy truy cập <a data-l10n-name="link-options">Tùy chọn</a>
       *[other] Để chọn một công cụ tìm kiếm khác, hãy truy cập <a data-l10n-name="link-options">Tùy chỉnh</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Đóng
about-private-browsing-promo-close-button =
    .title = Đóng

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Tự do duyệt web riêng tư trong một cú nhấp chuột
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Giữ trên Dock
       *[other] Ghim vào thanh tác vụ
    }
about-private-browsing-pin-promo-title = Không có cookie hoặc lịch sử đã lưu, ngay từ màn hình của bạn. Duyệt như không có ai đang xem.
