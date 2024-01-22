# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } duyệt web riêng tư
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — { -brand-full-name } duyệt web riêng tư
# These are the default window titles on macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Do not use the brand name in these, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } — Duyệt web riêng tư
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } — Duyệt web riêng tư
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }
# The non-variable portion of this MUST match the translation of
# "PRIVATE_BROWSING_SHORTCUT_TITLE" in custom.properties
private-browsing-shortcut-text-2 = { -brand-shortcut-name } duyệt web riêng tư

##

urlbar-identity-button =
    .aria-label = Xem thông tin trang

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Mở bảng thông báo cài đặt
urlbar-web-notification-anchor =
    .tooltiptext = Thay đổi liệu bạn có thể nhận thông báo từ trang web hay không
urlbar-midi-notification-anchor =
    .tooltiptext = Mở bảng MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Quản lý sử dụng phần mềm DRM
urlbar-web-authn-anchor =
    .tooltiptext = Mở bảng điều khiển xác thực web
urlbar-canvas-notification-anchor =
    .tooltiptext = Quản lý quyền khai thác canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Quản lý chia sẻ micrô của bạn với trang
urlbar-default-notification-anchor =
    .tooltiptext = Mở bảng thông báo
urlbar-geolocation-notification-anchor =
    .tooltiptext = Mở bảng yêu cầu vị trí
urlbar-xr-notification-anchor =
    .tooltiptext = Mở bảng điều khiển thực tế ảo
urlbar-storage-access-anchor =
    .tooltiptext = Mở bảng điều khiển quyền hoạt động duyệt web
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Quản lý chia sẻ cửa sổ hay màn hình của bạn với trang
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Mở bảng thông báo lưu trữ ngoại tuyến
urlbar-password-notification-anchor =
    .tooltiptext = Mở bảng thông báo lưu mật khẩu
urlbar-plugins-notification-anchor =
    .tooltiptext = Quản lý sử dụng phần bổ trợ
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Quản lý chia sẻ máy ảnh và/hoặc micrô với trang
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Quản lý việc chia sẻ các thiết bị âm thanh khác với trang web
urlbar-autoplay-notification-anchor =
    .tooltiptext = Mở bảng điều khiển tự động phát
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Lưu dữ liệu vào bộ nhớ lâu dài
urlbar-addons-notification-anchor =
    .tooltiptext = Mở bảng thông báo cài đặt tiện ích
urlbar-tip-help-icon =
    .title = Trợ giúp
urlbar-search-tips-confirm = OK, đã hiểu
urlbar-search-tips-confirm-short = Đã hiểu
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Mẹo:
urlbar-result-menu-button =
    .title = Mở menu
urlbar-result-menu-button-feedback = Phản hồi
    .title = Mở menu
urlbar-result-menu-learn-more =
    .label = Tìm hiểu thêm
    .accesskey = L
urlbar-result-menu-remove-from-history =
    .label = Xóa khỏi lịch sử
    .accesskey = R
urlbar-result-menu-tip-get-help =
    .label = Nhận trợ giúp
    .accesskey = h

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Nhập ít hơn, tìm thêm: Tìm kiếm { $engineName } ngay từ thanh địa chỉ của bạn.
urlbar-search-tips-redirect-2 = Bắt đầu tìm kiếm của bạn trong thanh địa chỉ để xem các đề xuất từ { $engineName } và lịch sử duyệt web của bạn.
# Make sure to match the name of the Search panel in settings.
urlbar-search-tips-persist = Việc tìm kiếm trở nên đơn giản hơn. Hãy thử làm cho tìm kiếm của bạn cụ thể hơn ở đây trong thanh địa chỉ. Để hiển thị URL, hãy tìm đến mục Tìm kiếm trong cài đặt.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Chọn phím tắt này để tìm những gì bạn cần nhanh hơn.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Dấu trang
urlbar-search-mode-tabs = Thẻ
urlbar-search-mode-history = Lịch sử
urlbar-search-mode-actions = Hành động

##

urlbar-geolocation-blocked =
    .tooltiptext = Bạn đã chặn thông tin địa điểm ở trang này.
urlbar-xr-blocked =
    .tooltiptext = Bạn đã chặn truy cập thiết bị thực tế ảo cho trang web này.
urlbar-web-notifications-blocked =
    .tooltiptext = Bạn đã chặn thông báo ở trang này.
urlbar-camera-blocked =
    .tooltiptext = Bạn đã chặn camera của mình ở trang này
urlbar-microphone-blocked =
    .tooltiptext = Bạn đã chặn micro của mình ở trang này
urlbar-screen-blocked =
    .tooltiptext = Bạn đã chặn việc chia sẻ màn hình của mình với trang web này.
urlbar-persistent-storage-blocked =
    .tooltiptext = Bạn đã chặn lưu dữ liệu vào bộ nhớ lâu dài ở trang này.
urlbar-popup-blocked =
    .tooltiptext = Bạn đã chặn cửa sổ bật lên ở trang web này.
urlbar-autoplay-media-blocked =
    .tooltiptext = Bạn đã chặn phương tiện tự động phát có âm thanh cho trang web này.
urlbar-canvas-blocked =
    .tooltiptext = Bạn đã chặn khai thác dữ liệu canvas đối với trang web này.
urlbar-midi-blocked =
    .tooltiptext = Bạn đã chặn quyền truy cập MIDI của trang web này.
urlbar-install-blocked =
    .tooltiptext = Bạn đã chặn cài đặt tiện ích cho trang web này.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Chỉnh sửa dấu trang này ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Đánh dấu trang này ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension2 =
    .label = Quản lý tiện ích mở rộng…
    .accesskey = E
page-action-remove-extension2 =
    .label = Xóa tiện ích mở rộng
    .accesskey = v

## Auto-hide Context Menu

full-screen-autohide =
    .label = Ẩn thanh công cụ
    .accesskey = H
full-screen-exit =
    .label = Thoát chế độ toàn màn hình
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = Lần này, tìm kiếm với:
search-one-offs-change-settings-compact-button =
    .tooltiptext = Thay đổi cài đặt tìm kiếm
search-one-offs-context-open-new-tab =
    .label = Tìm trong thẻ mới
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = Đặt làm công cụ tìm kiếm mặc định
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = Đặt làm công cụ tìm kiếm mặc định cho cửa sổ riêng tư
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Thêm “{ $engineName }”
    .tooltiptext = Thêm công cụ tìm kiếm “{ $engineName }”
    .aria-label = Thêm công cụ tìm kiếm “{ $engineName }”
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Thêm dịch vụ tìm kiếm

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Dấu trang ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Thẻ ({ $restrict })
search-one-offs-history =
    .tooltiptext = Lịch sử ({ $restrict })
search-one-offs-actions =
    .tooltiptext = Hành động ({ $restrict })

## QuickActions are shown in the urlbar as the user types a matching string
## The -cmd- strings are comma separated list of keywords that will match
## the action.

# Opens the about:addons page in the home / recommendations section
quickactions-addons = Xem tiện tích
quickactions-cmd-addons2 = tiện ích
# Opens the bookmarks library window
quickactions-bookmarks2 = Quản lý dấu trang
quickactions-cmd-bookmarks = dấu trang, dau trang
# Opens a SUMO article explaining how to clear history
quickactions-clearhistory = Xóa lịch sử
quickactions-cmd-clearhistory = xóa lịch sử, xoa lich su
# Opens about:downloads page
quickactions-downloads2 = Xem tải xuống
quickactions-cmd-downloads = tải xuống, tai xuong
# Opens about:addons page in the extensions section
quickactions-extensions = Quản lý tiện ích
quickactions-cmd-extensions = tiện ích mở rộng
# Opens the devtools web inspector
quickactions-inspector2 = Mở Công cụ dành cho nhà phát triển
quickactions-cmd-inspector = trình kiểm tra, devtools, trinh kiem tra
# Opens about:logins
quickactions-logins2 = Quản lý mật khẩu
quickactions-cmd-logins = đăng nhập, thông tin đăng nhập, mật khẩu, dang nhap, thong tin dang nhap, mat khau
# Opens about:addons page in the plugins section
quickactions-plugins = Quản lý phần bổ trợ
quickactions-cmd-plugins = phần bổ trợ
# Opens the print dialog
quickactions-print2 = Trang in
quickactions-cmd-print = in
# Opens a new private browsing window
quickactions-private2 = Mở cửa sổ riêng tư
quickactions-cmd-private = duyệt web riêng tư, duyet web rieng tu
# Opens a SUMO article explaining how to refresh
quickactions-refresh = Làm mới { -brand-short-name }
quickactions-cmd-refresh = làm mới, lam moi
# Restarts the browser
quickactions-restart = Khởi động lại { -brand-short-name }
quickactions-cmd-restart = khởi động lại, khoi dong lai
# Opens the screenshot tool
quickactions-screenshot3 = Chụp ảnh màn hình
quickactions-cmd-screenshot = chụp ảnh màn hình, chup anh man hinh
# Opens about:preferences
quickactions-settings2 = Quản lý cài đặt
quickactions-cmd-settings = cài đặt, tùy chọn, thiết lập, cai dat, tuy chon, thiet lap
# Opens about:addons page in the themes section
quickactions-themes = Quản lý chủ đề
quickactions-cmd-themes = chủ đề
# Opens a SUMO article explaining how to update the browser
quickactions-update = Cập nhật { -brand-short-name }
quickactions-cmd-update = cập nhật, cap nhat
# Opens the view-source UI with current pages source
quickactions-viewsource2 = Xem mã nguồn trang
quickactions-cmd-viewsource = xem mã nguồn, xem nguồn, nguồn, xem ma nguon, xem nguon, nguon
# Tooltip text for the help button shown in the result.
quickactions-learn-more =
    .title = Tìm hiểu thêm về Hành động nhanh

## Bookmark Panel

bookmarks-add-bookmark = Thêm dấu trang
bookmarks-edit-bookmark = Chỉnh sửa dấu trang
bookmark-panel-cancel =
    .label = Hủy bỏ
    .accesskey = C
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label = Xóa { $count } dấu trang
    .accesskey = R
bookmark-panel-show-editor-checkbox =
    .label = Hiển thị trình chỉnh sửa khi lưu
    .accesskey = S
bookmark-panel-save-button =
    .label = Lưu
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Thông tin trang web { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Bảo mật kết nối cho { $host }
identity-connection-not-secure = Kết nối không an toàn
identity-connection-secure = Kết nối an toàn
identity-connection-failure = Kết nối thất bại
identity-connection-internal = Đây là một trang an toàn của { -brand-short-name }
identity-connection-file = Trang này đã được lưu ở máy tính của bạn.
identity-extension-page = Trang này được tải từ một tiện ích mở rộng.
identity-active-blocked = { -brand-short-name } đã chặn những phần không an toàn của trang này.
identity-custom-root = Kết nối được xác minh bởi nhà phát hành chứng chỉ không được BrowserWorks công nhận.
identity-passive-loaded = Có nhiều thành phân của trang không an toàn (ví dụ như ảnh).
identity-active-loaded = Bạn đã tắt tính năng bảo vệ trên trang này.
identity-weak-encryption = Trang này sử dụng mã hóa yếu.
identity-insecure-login-forms = Đăng nhập vào trang này bạn có thể bị xâm nhập.
identity-https-only-connection-upgraded = (đã nâng cấp lên HTTPS)
identity-https-only-label = Chế độ chỉ HTTPS
identity-https-only-label2 = Tự động nâng cấp trang web này lên kết nối an toàn
identity-https-only-dropdown-on =
    .label = Bật
identity-https-only-dropdown-off =
    .label = Tắt
identity-https-only-dropdown-off-temporarily =
    .label = Tắt tạm thời
identity-https-only-info-turn-on2 = Bật Chế độ chỉ HTTPS cho trang web này nếu bạn muốn { -brand-short-name } nâng cấp kết nối khi có thể.
identity-https-only-info-turn-off2 = Nếu trang có vẻ bị hỏng, bạn có thể tắt Chế độ chỉ HTTPS để trang web này tải lại sử dụng HTTP không an toàn.
identity-https-only-info-turn-on3 = Bật nâng cấp HTTPS cho trang web này nếu bạn muốn { -brand-short-name } nâng cấp kết nối khi có thể.
identity-https-only-info-turn-off3 = Nếu trang có vẻ bị hỏng, bạn có thể muốn tắt nâng cấp HTTPS cho trang web này để tải lại bằng HTTP không an toàn.
identity-https-only-info-no-upgrade = Không thể nâng cấp kết nối từ HTTP.
identity-permissions-storage-access-header = Cookie trên nhiều trang web
identity-permissions-storage-access-hint = Khi bạn mở trang web này, các trang web này có thể sử dụng cookie trên nhiều trang web và lấy thông tin của bạn trên trang web này.
identity-permissions-storage-access-learn-more = Tìm hiểu thêm
identity-permissions-reload-hint = Bạn có thể cần phải tải lại trang để các thay đổi được áp dụng.
identity-clear-site-data =
    .label = Xóa cookie và dữ liệu trang web…
identity-connection-not-secure-security-view = Bạn không được kết nối an toàn với trang web này.
identity-connection-verified = Bạn đang kết nối an toàn tới trang này.
identity-ev-owner-label = Chứng nhận được cấp cho:
identity-description-custom-root2 = BrowserWorks không công nhận nhà phát hành chứng nhận này. Nó có thể đã được thêm từ hệ điều hành của bạn hoặc bởi quản trị viên.
identity-remove-cert-exception =
    .label = Loại bỏ ngoại lệ
    .accesskey = R
identity-description-insecure = Kết nối của bạn đến trang này không được bảo mật. Thông tin bạn gửi có thể bị thấy bởi người khác (ví dụ như mật khẩu, tin nhắn, thẻ tín dụng).
identity-description-insecure-login-forms = Thông tin đăng nhập mà bạn nhập vào trên trang này không an toàn và có thể bị xâm nhập.
identity-description-weak-cipher-intro = Kết nối đến trang này sử dụng mã hóa yếu và không bảo mật.
identity-description-weak-cipher-risk = Người khác có thể thấy thông tin của bạn hoặc thay đổi hành vi của trang.
identity-description-active-blocked2 = { -brand-short-name } đã chặn những phần không an toàn của trang này.
identity-description-passive-loaded = Kết nối không được bảo mật và thông tin bạn chia sẻ với trang này có thể bị thấy bởi người khác.
identity-description-passive-loaded-insecure2 = Trang web này chứa nội dung không an toàn (ví dụ: ảnh).
identity-description-passive-loaded-mixed2 = Dù { -brand-short-name } đã chặn một số nội dung, vẫn có những nội dung trên trang không an toàn (ví dụ: ảnh).
identity-description-active-loaded = Trang web này chứa nội dung không an toàn (ví dụ: các đoạn mã) và kết nối tới nội dung này không bảo mật.
identity-description-active-loaded-insecure = Thông tin bạn chia sẻ với trang này có thể bị thấy bởi người khác (ví dụ: mật khẩu, tin nhắn, thẻ tín dụng, vâng vâng).
identity-disable-mixed-content-blocking =
    .label = Tạm thời tắt bảo vệ
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = Bật bảo vệ
    .accesskey = E
identity-more-info-link-text =
    .label = Thông tin thêm

## Window controls

browser-window-minimize-button =
    .tooltiptext = Thu nhỏ
browser-window-maximize-button =
    .tooltiptext = Cực đại hoá
browser-window-restore-down-button =
    .tooltiptext = Khôi phục kích thước
browser-window-close-button =
    .tooltiptext = Đóng

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = ĐANG PHÁT
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = ĐÃ TẮT TIẾNG
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = TỰ ĐỘNG PHÁT BỊ CHẶN
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = HÌNH TRONG HÌNH

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] TẮT TIẾNG THẺ
       *[other] TẮT TIẾNG { $count } THẺ
    }
browser-tab-unmute =
    { $count ->
        [1] BỎ TẮT TIẾNG THẺ
       *[other] BỎ TẮT TIẾNG { $count } THẺ
    }
browser-tab-unblock =
    { $count ->
        [1] PHÁT THẺ
       *[other] PHÁT { $count } THẺ
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Nhập dấu trang…
    .tooltiptext = Nhập dấu trang từ trình duyệt khác sang { -brand-short-name }.
bookmarks-toolbar-empty-message = Để truy cập nhanh, hãy đặt dấu trang của bạn tại đây trên thanh công cụ dấu trang. <a data-l10n-name="manage-bookmarks">Quản lý dấu trang…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Máy ảnh:
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = Máy ảnh
popup-select-microphone-device =
    .value = Micrô:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = Micrô
popup-select-speaker-icon =
    .tooltiptext = Loa
popup-select-window-or-screen =
    .label = Cửa sổ hoặc màn hình:
    .accesskey = W
popup-all-windows-shared = Tất cả các cửa sổ trên màn hình sẽ được chia sẻ.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Bạn đang chia sẻ { -brand-short-name }. Người khác có thể thấy khi bạn chuyển sang một thẻ mới.
sharing-warning-screen = Bạn đang chia sẻ toàn bộ màn hình của bạn. Người khác có thể thấy khi bạn chuyển sang một thẻ mới.
sharing-warning-proceed-to-tab =
    .label = Tiếp tục với thẻ
sharing-warning-disable-for-session =
    .label = Vô hiệu hóa bảo vệ chia sẻ cho phiên này

## DevTools F12 popup

enable-devtools-popup-description2 = Để sử dụng phím tắt F12, trước tiên hãy mở Công cụ phát triển web qua menu Công cụ trình duyệt.

## URL Bar

# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Nhập địa chỉ hoặc từ khóa tìm kiếm
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Tìm kiếm trên mạng
    .aria-label = Tìm kiếm với { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Nhập từ tìm kiếm
    .aria-label = Tìm kiếm { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Nhập từ tìm kiếm
    .aria-label = Tìm kiếm dấu trang
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Nhập từ tìm kiếm
    .aria-label = Tìm kiếm lịch sử
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Nhập từ tìm kiếm
    .aria-label = Tìm kiếm thẻ
# This placeholder is used when searching quick actions.
urlbar-placeholder-search-mode-other-actions =
    .placeholder = Nhập từ tìm kiếm
    .aria-label = Tìm kiếm hành động
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Tìm kiếm với { $name } hoặc nhập địa chỉ
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Trình duyệt đang được điều khiển từ xa (lý do: { $component })
urlbar-permissions-granted =
    .tooltiptext = Bạn đã cấp cho trang web này các quyền bổ sung.
urlbar-switch-to-tab =
    .value = Chuyển qua thẻ:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Tiện ích mở rộng:
urlbar-go-button =
    .tooltiptext = Mở trang trong thanh địa chỉ
urlbar-page-action-button =
    .tooltiptext = Hành động trên trang

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Tìm kiếm với { $engine } trong cửa sổ riêng tư
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Tìm kiếm trong cửa sổ riêng tư
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Tìm với { $engine }
urlbar-result-action-sponsored = Được tài trợ
urlbar-result-action-switch-tab = Chuyển sang thẻ
urlbar-result-action-visit = Truy cập
# Allows the user to visit a URL that was previously copied to the clipboard.
urlbar-result-action-visit-from-your-clipboard = Truy cập khay nhớ tạm của bạn
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Nhấn Tab để tìm kiếm bằng { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Nhấn Tab để tìm kiếm { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Tìm kiếm với { $engine } trực tiếp từ thanh địa chỉ
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Tìm kiếm { $engine } trực tiếp từ thanh địa chỉ
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Sao chép
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Tìm kiếm dấu trang
urlbar-result-action-search-history = Tìm kiếm lịch sử
urlbar-result-action-search-tabs = Tìm kiếm thẻ
urlbar-result-action-search-actions = Tìm kiếm hành động

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use sentence case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Đề xuất của { $engine }
# A label shown above Quick Actions in the urlbar results.
urlbar-group-quickactions =
    .label = Hành động nhanh

## Reader View toolbar buttons

# This should match menu-view-enter-readerview in menubar.ftl
reader-view-enter-button =
    .aria-label = Vào chế độ đọc sách
# This should match menu-view-close-readerview in menubar.ftl
reader-view-close-button =
    .aria-label = Đóng chế độ đọc sách

## Picture-in-Picture urlbar button
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

picture-in-picture-urlbar-button-open =
    .tooltiptext = Mở hình trong hình ({ $shortcut })
picture-in-picture-urlbar-button-close =
    .tooltiptext = Đóng hình trong hình ({ $shortcut })
picture-in-picture-panel-header = Hình trong hình
picture-in-picture-panel-headline = Trang web này không khuyến nghị hình trong hình
picture-in-picture-panel-body = Video có thể không hiển thị như ý định của nhà phát triển khi hình trong hình được bật.
picture-in-picture-enable-toggle =
    .label = Vẫn bật

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> giờ đã hiển thị toàn màn hình
fullscreen-warning-no-domain = Trang này giờ đã hiển thị toàn màn hình
fullscreen-exit-button = Thoát toàn màn hình (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Thoát toàn màn hình (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> có quyền điều khiển con trỏ của bạn. Ấn Esc để lấy lại quyền điều khiển.
pointerlock-warning-no-domain = Trang này có quyền điều khiển con trỏ của bạn. Ấn Esc để lấy lại quyền điều khiển.

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Quản lý dấu trang
bookmarks-recent-bookmarks-panel-subheader = Dấu trang gần đây
bookmarks-toolbar-chevron =
    .tooltiptext = Hiển thị thêm dấu trang
bookmarks-sidebar-content =
    .aria-label = Dấu trang
bookmarks-menu-button =
    .label = Trình đơn dấu trang
bookmarks-other-bookmarks-menu =
    .label = Dấu trang khác
bookmarks-mobile-bookmarks-menu =
    .label = Dấu trang trên di động

## Variables:
##   $isVisible (boolean): if the specific element (e.g. bookmarks sidebar,
##                         bookmarks toolbar, etc.) is visible or not.

bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Ẩn thanh lề dấu trang
           *[other] Hiển thị thanh lề dấu trang
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Ẩn thanh công cụ dấu trang
           *[other] Hiển thị thanh công cụ dấu trang
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Ẩn thanh dấu trang
           *[other] Hiển thị thanh dấu trang
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Xóa bảng chọn dấu trang từ thanh công cụ
           *[other] Thêm bảng chọn dấu trang vào thanh công cụ
        }

##

bookmarks-search =
    .label = Tìm kiếm dấu trang
bookmarks-tools =
    .label = Công cụ đánh dấu trang
bookmarks-subview-edit-bookmark =
    .label = Chỉnh sửa dấu trang này…
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Thanh dấu trang
    .accesskey = B
    .aria-label = Dấu trang
bookmarks-toolbar-menu =
    .label = Thanh dấu trang
bookmarks-toolbar-placeholder =
    .title = Các mục của thanh dấu trang
bookmarks-toolbar-placeholder-button =
    .label = Các mục của thanh dấu trang
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-subview-bookmark-tab =
    .label = Đánh dấu thẻ hiện tại…

## Library Panel items

library-bookmarks-menu =
    .label = Dấu trang
library-recent-activity-title =
    .value = Hoạt động gần đây

## Pocket toolbar button

save-to-pocket-button =
    .label = Lưu vào { -pocket-brand-name }
    .tooltiptext = Lưu vào { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Sửa chữa mã hóa văn bản
    .tooltiptext = Đoán mã hóa văn bản chính xác từ nội dung trang

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Cài đặt
    .tooltiptext =
        { PLATFORM() ->
            [macos] Mở cài đặt ({ $shortcut })
           *[other] Mở cài đặt
        }
toolbar-overflow-customize-button =
    .label = Tùy biến thanh công cụ…
    .accesskey = C
toolbar-button-email-link =
    .label = Gửi liên kết này qua email
    .tooltiptext = Gửi một thư điện tử chứa liên kết tới trang này
toolbar-button-logins =
    .label = Mật khẩu
    .tooltiptext = Xem và quản lý mật khẩu đã lưu của bạn
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Lưu trang
    .tooltiptext = Lưu trang này ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Mở tập tin
    .tooltiptext = Mở một tập tin ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Các thẻ đã đồng bộ
    .tooltiptext = Hiện thẻ từ các thiết bị khác
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Cửa sổ riêng tư mới
    .tooltiptext = Mở một cửa sổ duyệt web riêng tư mới ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Một số nguồn audio và video trên trang này có sử dụng phần mềm DRM bảo vệ bản quyền nên một số thao tác có thể bị giới hạn với { -brand-short-name }.
eme-notifications-drm-content-playing-manage = Quản lý cài đặt
eme-notifications-drm-content-playing-manage-accesskey = M
eme-notifications-drm-content-playing-dismiss = Bỏ qua
eme-notifications-drm-content-playing-dismiss-accesskey = D

## Password save/update panel

panel-save-update-username = Tên đăng nhập
panel-save-update-password = Mật khẩu

##

# "More" item in macOS share menu
menu-share-more =
    .label = Xem thêm…
ui-tour-info-panel-close =
    .tooltiptext = Đóng

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Cho phép { $uriHost } mở cửa sổ bật lên
    .accesskey = p
popups-infobar-block =
    .label = Chặn cửa sổ bật lên từ { $uriHost }
    .accesskey = p

##

popups-infobar-dont-show-message =
    .label = Không hiển thị thông báo này khi có cửa sổ bật lên bị chặn
    .accesskey = D
edit-popup-settings =
    .label = Quản lý cài đặt cửa sổ bật lên…
    .accesskey = M
picture-in-picture-hide-toggle =
    .label = Ẩn nút hình trong hình
    .accesskey = H

## Since the default position for PiP controls does not change for RTL layout,
## right-to-left languages should use "Left" and "Right" as in the English strings,

picture-in-picture-move-toggle-right =
    .label = Chuyển chế độ hình trong hình sang phải
    .accesskey = R
picture-in-picture-move-toggle-left =
    .label = Chuyển chế độ hình trong hình sang trái
    .accesskey = L

##


# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Điều hướng
navbar-downloads =
    .label = Tải xuống
navbar-overflow =
    .tooltiptext = Công cụ khác...
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = In
    .tooltiptext = In trang này… ({ $shortcut })
navbar-home =
    .label = Trang chủ
    .tooltiptext = { -brand-short-name } Trang Chủ
navbar-library =
    .label = Thư viện
    .tooltiptext = Xem lịch sử, dấu trang đã lưu và nhiều hơn nữa
navbar-search =
    .title = Tìm kiếm
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Thẻ trình duyệt
tabs-toolbar-new-tab =
    .label = Thẻ mới
tabs-toolbar-list-all-tabs =
    .label = Liệt kê tất cả các thẻ
    .tooltiptext = Liệt kê tất cả các thẻ

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Đã mở các thẻ trước đó?</strong> Bạn có thể khôi phục phiên trước đó của mình từ menu ứng dụng { -brand-short-name } <img data-l10n-name="icon"/>, trong mục Lịch sử.
restore-session-startup-suggestion-button = Hướng dẫn cho tôi

## BrowserWorks data reporting notification (Telemetry, Waterfox Health Report, etc)

data-reporting-notification-message = { -brand-short-name } tự động gửi dữ liệu về { -vendor-short-name } để chúng tôi có thể cải thiện trải nghiệm của bạn.
data-reporting-notification-button =
    .label = Chọn những thứ tôi muốn chia sẻ
    .accesskey = C
# Label for the indicator shown in the private browsing window titlebar.
private-browsing-indicator-label = Duyệt web riêng tư

## Unified extensions (toolbar) button

unified-extensions-button =
    .label = Tiện ích mở rộng
    .tooltiptext = Tiện ích mở rộng

## Unified extensions button when permission(s) are needed.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-permissions-needed =
    .label = Tiện ích mở rộng
    .tooltiptext =
        Tiện ích mở rộng
        Cần yêu cầu quyền hạn

## Unified extensions button when some extensions are quarantined.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-quarantined =
    .label = Tiện ích mở rộng
    .tooltiptext =
        Tiện ích mở rộng
        Vài tiện ích mở rộng không được phép

## Autorefresh blocker

refresh-blocked-refresh-label = { -brand-short-name } đã ngăn trang web này tự động tải lại.
refresh-blocked-redirect-label = { -brand-short-name } đã ngăn trang web này tự động chuyển đến trang khác.
refresh-blocked-allow =
    .label = Cho phép
    .accesskey = A

## Waterfox Relay integration

firefox-relay-offer-why-to-use-relay = Mặt nạ an toàn, dễ sử dụng của chúng tôi bảo vệ danh tính của bạn và ngăn chặn thư rác bằng cách ẩn địa chỉ email của bạn.
# Variables:
#  $useremail (String): user email that will receive messages
firefox-relay-offer-what-relay-provides = Tất cả email gửi đến mặt nạ email của bạn sẽ được chuyển đến <strong>{ $useremail }</strong> (trừ khi bạn quyết định chặn chúng).
firefox-relay-offer-legal-notice = Bằng cách nhấp vào “Sử dụng mặt nạ email”, bạn đồng ý với <label data-l10n-name="tos-url">điều khoản sử dụng</label> và <label data-l10n-name="privacy-url">thông báo về quyền riêng tư</label>.

## Add-on Pop-up Notifications

popup-notification-addon-install-unsigned =
    .value = (Chưa xác thực)
popup-notification-xpinstall-prompt-learn-more = Tìm hiểu thêm về cách cài đặt tiện ích một cách an toàn

## Pop-up warning

# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-message = { -brand-short-name } đã chặn trang web này mở { $popupCount } cửa sổ bật lên.
# The singular form is left out for English, since the number of blocked pop-ups is always greater than 1.
# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-exceeded-message = { -brand-short-name } đã ngăn trang web này mở nhiều hơn { $popupCount } cửa sổ bật lên.
popup-warning-button =
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
# Variables:
#   $popupURI (String): the URI for the pop-up window
popup-show-popup-menuitem =
    .label = Hiển thị '{ $popupURI }'
