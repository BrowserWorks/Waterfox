# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Note: This is currently placed under browser/base/content so that we can
# get the strings to appear without having our localization community need
# to go through and translate everything. Once these strings are ready for
# translation, we'll move it to the locales folder.


## These strings are used so that the window has a title in tools that
## enumerate/look for window titles. It is not normally visible anywhere.

webrtc-indicator-title = { -brand-short-name } - Chỉ báo chia sẻ
webrtc-indicator-window =
    .title = { -brand-short-name } - Chỉ báo chia sẻ

## Used as list items in sharing menu

webrtc-item-camera = camera
webrtc-item-microphone = micro
webrtc-item-audio-capture = âm thanh trên thẻ
webrtc-item-application = ứng dụng
webrtc-item-screen = màn hình
webrtc-item-window = cửa sổ
webrtc-item-browser = thẻ

##

# This is used for the website origin for the sharing menu if no readable origin could be deduced from the URL.
webrtc-sharing-menuitem-unknown-host = Không rõ nguồn gốc

# Variables:
#   $origin (String): The website origin (e.g. www.mozilla.org)
#   $itemList (String): A formatted list of items (e.g. "camera, microphone and tab audio")
webrtc-sharing-menuitem =
    .label = { $origin } ({ $itemList })
webrtc-sharing-menu =
    .label = Thiết bị chia sẻ thẻ
    .accesskey = d

webrtc-sharing-window = Bạn đang chia sẻ một cửa sổ ứng dụng khác.
webrtc-sharing-browser-window = Bạn đang chia sẻ { -brand-short-name }.
webrtc-sharing-screen = Bạn đang chia sẻ toàn bộ màn hình của bạn.
webrtc-stop-sharing-button = Ngừng chia sẻ
webrtc-microphone-unmuted =
    .title = Tắt micrô
webrtc-microphone-muted =
    .title = Bật micrô
webrtc-camera-unmuted =
    .title = Tắt máy ảnh
webrtc-camera-muted =
    .title = Bật máy ảnh
webrtc-minimize =
    .title = Thu nhỏ chỉ báo

## These strings will display as a tooltip on supported systems where we show
## device sharing state in the OS notification area. We do not use these strings
## on macOS, as global menu bar items do not have native tooltips.

webrtc-camera-system-menu =
    .label = Bạn đang chia sẻ máy ảnh của mình. Nhấp để kiểm soát việc chia sẻ.
webrtc-microphone-system-menu =
    .label = Bạn đang chia sẻ micrô của mình. Nhấp để kiểm soát việc chia sẻ.
webrtc-screen-system-menu =
    .label = Bạn đang chia sẻ một cửa sổ hoặc một màn hình. Nhấp để kiểm soát việc chia sẻ.

## Tooltips used by the legacy global sharing indicator

webrtc-indicator-sharing-camera-and-microphone =
    .tooltiptext = Bạn đang chia sẻ máy ảnh và micro. Nhấn vào đây để kiểm soát những gì được chia sẻ.
webrtc-indicator-sharing-camera =
    .tooltiptext = Bạn đang chia sẻ máy ảnh. Nhấn vào đây để kiểm soát những gì được chia sẻ.
webrtc-indicator-sharing-microphone =
    .tooltiptext = Bạn đang chia sẻ micro. Nhấn vào đây để kiểm soát những gì được chia sẻ.
webrtc-indicator-sharing-application =
    .tooltiptext = Bạn đang chia sẻ một ứng dụng. Nhấn vào đây để kiểm soát những gì được chia sẻ.
webrtc-indicator-sharing-screen =
    .tooltiptext = Bạn đang chia sẻ màn hình. Nhấn vào đây để kiểm soát những gì bạn chia sẻ.
webrtc-indicator-sharing-window =
    .tooltiptext = Bạn đang chia sẻ một cửa sổ. Nhấn vào đây để kiểm soát những gì bạn chia sẻ.
webrtc-indicator-sharing-browser =
    .tooltiptext = Bạn đang chia sẻ một thẻ. Nhấn vào đây để kiểm soát những gì bạn chia sẻ.

## These strings are only used on Mac for menus attached to icons
## near the clock on the mac menubar.
## Variables:
##   $streamTitle (String): the title of the tab using the share.
##   $tabCount (Number): the title of the tab using the share.

webrtc-indicator-menuitem-control-sharing =
    .label = Kiểm soát chia sẻ
webrtc-indicator-menuitem-control-sharing-on =
    .label = Kiểm soát chia sẻ với "{ $streamTitle }"

webrtc-indicator-menuitem-sharing-camera-with =
    .label = Chia sẻ máy ảnh với “{ $streamTitle }”
webrtc-indicator-menuitem-sharing-camera-with-n-tabs =
    .label = Đang chia sẻ máy ảnh với { $tabCount } thẻ

webrtc-indicator-menuitem-sharing-microphone-with =
    .label = Chia sẻ micrô với "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-microphone-with-n-tabs =
    .label = Đang chia sẻ micro với { $tabCount } thẻ

webrtc-indicator-menuitem-sharing-application-with =
    .label = Chia sẻ một ứng dụng với "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-application-with-n-tabs =
    .label = Đang chia sẻ ứng dụng với { $tabCount } thẻ

webrtc-indicator-menuitem-sharing-screen-with =
    .label = Chia sẻ màn hình với "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-screen-with-n-tabs =
    .label = Đang chia sẻ màn hình với { $tabCount } thẻ

webrtc-indicator-menuitem-sharing-window-with =
    .label = Chia sẻ một cửa sổ với "{ $streamTitle }"
webrtc-indicator-menuitem-sharing-window-with-n-tabs =
    .label = Đang chia sẻ cửa sổ với { $tabCount } thẻ

webrtc-indicator-menuitem-sharing-browser-with =
    .label = Chia sẻ một thẻ với “{ $streamTitle }”
# This message is shown when the contents of a tab is shared during a WebRTC
# session, which currently is only possible with Loop/Hello.
webrtc-indicator-menuitem-sharing-browser-with-n-tabs =
    .label = Đang chia sẻ các thẻ với { $tabCount } thẻ

## Variables:
##   $origin (String): the website origin (e.g. www.mozilla.org).

webrtc-allow-share-audio-capture = Cho phép { $origin } nghe âm thanh của thẻ này?
webrtc-allow-share-camera = Cho phép { $origin } sử dụng máy ảnh của bạn?
webrtc-allow-share-microphone = Cho phép { $origin } sử dụng micrô của bạn?
webrtc-allow-share-screen = Cho phép { $origin } xem màn hình của bạn?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker = Cho phép { $origin } sử dụng các loa khác?
webrtc-allow-share-camera-and-microphone = Cho phép { $origin } sử dụng máy ảnh và micrô của bạn?
webrtc-allow-share-camera-and-audio-capture = Cho phép { $origin } sử dụng máy ảnh của bạn và nghe âm thanh của thẻ này?
webrtc-allow-share-screen-and-microphone = Cho phép { $origin } sử dụng micrô của bạn và xem màn hình của bạn?
webrtc-allow-share-screen-and-audio-capture = Cho phép { $origin } nghe âm thanh của thẻ này và xem màn hình của bạn?

## Variables:
##   $origin (String): the first party origin.
##   $thirdParty (String): the third party origin.

webrtc-allow-share-audio-capture-unsafe-delegation = Cho phép { $origin } cấp quyền cho { $thirdParty } nghe âm thanh của thẻ này?
webrtc-allow-share-camera-unsafe-delegation = Cho phép { $origin } cấp cho { $thirdParty } quyền truy cập vào máy ảnh của bạn?
webrtc-allow-share-microphone-unsafe-delegation = Cho phép { $origin } cấp cho { $thirdParty } quyền truy cập vào micrô của bạn?
webrtc-allow-share-screen-unsafe-delegation = Cho phép { $origin } cấp quyền cho { $thirdParty } xem màn hình của bạn?
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
webrtc-allow-share-speaker-unsafe-delegation = Cho phép { $origin } cấp cho { $thirdParty } quyền truy cập vào các loa khác?
webrtc-allow-share-camera-and-microphone-unsafe-delegation = Cho phép { $origin } cấp cho { $thirdParty } quyền truy cập vào máy ảnh và micrô của bạn?
webrtc-allow-share-camera-and-audio-capture-unsafe-delegation = Cho phép { $origin } cấp cho { $thirdParty } quyền truy cập vào máy ảnh của bạn và nghe âm thanh của thẻ này?
webrtc-allow-share-screen-and-microphone-unsafe-delegation = Cho phép { $origin } cấp cho { $thirdParty } quyền truy cập vào micrô và xem màn hình của bạn?
webrtc-allow-share-screen-and-audio-capture-unsafe-delegation = Cho phép { $origin } cấp quyền cho { $thirdParty } nghe âm thanh của thẻ này và xem màn hình của bạn?

##

webrtc-share-screen-warning = Chỉ chia sẻ màn hình với các trang web mà bạn tin tưởng. Chia sẻ có thể cho phép các trang web lừa đảo duyệt web như bạn và lấy cắp dữ liệu cá nhân của bạn.
webrtc-share-browser-warning = Chỉ chia sẻ { -brand-short-name } với các trang web mà bạn tin tưởng. Chia sẻ có thể cho phép các trang web lừa đảo duyệt web như bạn và lấy cắp dữ liệu cá nhân của bạn.

webrtc-share-screen-learn-more = Tìm hiểu thêm
webrtc-pick-window-or-screen = Chọn cửa sổ hoặc màn hình
webrtc-share-entire-screen = Toàn bộ màn hình
webrtc-share-pipe-wire-portal = Sử dụng cài đặt của hệ điều hành
# Variables:
#   $monitorIndex (String): screen number (digits 1, 2, etc).
webrtc-share-monitor = Màn hình { $monitorIndex }
# Variables:
#   $windowCount (Number): the number of windows currently displayed by the application.
#   $appName (String): the name of the application.
webrtc-share-application = { $appName } ({ $windowCount } cửa sổ)

## These buttons are the possible answers to the various prompts in the "webrtc-allow-share-*" strings.

webrtc-action-allow =
    .label = Cho phép
    .accesskey = A
webrtc-action-block =
    .label = Chặn
    .accesskey = B
webrtc-action-always-block =
    .label = Luôn chặn
    .accesskey = w
webrtc-action-not-now =
    .label = Không phải bây giờ
    .accesskey = N

##

webrtc-remember-allow-checkbox = Ghi nhớ quyết định này
webrtc-mute-notifications-checkbox = Ẩn thông báo trang web khi chia sẻ

webrtc-reason-for-no-permanent-allow-screen = { -brand-short-name } có thể vĩnh viễn không cho phép quyền truy cập vào màn hình của bạn.
webrtc-reason-for-no-permanent-allow-audio = { -brand-short-name } không thể cho phép vĩnh viễn quyền truy cập vào phần âm thanh của thẻ mà không cần yêu cầu thẻ đó chia sẻ.
webrtc-reason-for-no-permanent-allow-insecure = Kết nối của bạn đến website này không an toàn. Để bảo vệ bạn, { -brand-short-name } sẽ chỉ cho phép truy cập vào trang này trong phiên hiện tại.
