# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] Kéo xuống để xem lịch sử
           *[other] Nhấn chuột phải hoặc kéo xuống để hiển thị lịch sử
        }

## Back

main-context-menu-back =
    .tooltiptext = Trở lại trang trước
    .aria-label = Quay lại
    .accesskey = B
navbar-tooltip-back =
    .value = { main-context-menu-back.tooltiptext }
toolbar-button-back =
    .label = { main-context-menu-back.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = Trở lại trang trước ({ $shortcut })
    .aria-label = Quay lại
    .accesskey = B
# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = Quay lại
    .accesskey = B
navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }
toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

main-context-menu-forward =
    .tooltiptext = Tiến đến một trang
    .aria-label = Tiếc tục
    .accesskey = F
navbar-tooltip-forward =
    .value = { main-context-menu-forward.tooltiptext }
toolbar-button-forward =
    .label = { main-context-menu-forward.aria-label }
# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = Tiến đến một trang ({ $shortcut })
    .aria-label = Tiếc tục
    .accesskey = F
# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = Tiến
    .accesskey = F
navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }
toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = Tải lại
    .accesskey = R
# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = Tải lại
    .accesskey = R
toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = Dừng
    .accesskey = S
# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = Dừng
    .accesskey = S
toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Firefox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = Lưu trang dưới dạng…
    .accesskey = P
toolbar-button-page-save =
    .label = { main-context-menu-page-save.label }

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = Đánh dấu trang này
    .accesskey = m
    .tooltiptext = Đánh dấu trang này
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = Đánh dấu trang
    .accesskey = m
# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = Chỉnh sửa dấu trang
    .accesskey = m
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = Đánh dấu trang này
    .accesskey = m
    .tooltiptext = Đánh dấu trang này ({ $shortcut })
main-context-menu-bookmark-change =
    .aria-label = Chỉnh sửa dấu trang này
    .accesskey = m
    .tooltiptext = Chỉnh sửa dấu trang này
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = Chỉnh sửa dấu trang này
    .accesskey = m
    .tooltiptext = Chỉnh sửa dấu trang này ({ $shortcut })
main-context-menu-open-link =
    .label = Mở liên kết
    .accesskey = O
main-context-menu-open-link-new-tab =
    .label = Mở liên kết trong thẻ mới
    .accesskey = T
main-context-menu-open-link-container-tab =
    .label = Mở lên kết trong thẻ chứa mới
    .accesskey = b
main-context-menu-open-link-new-window =
    .label = Mở liên kết trong cửa sổ mới
    .accesskey = W
main-context-menu-open-link-new-private-window =
    .label = Mở liên kết trong cửa sổ riêng tư mới
    .accesskey = P
main-context-menu-bookmark-this-link =
    .label = Đánh dấu liên kết này
    .accesskey = L
main-context-menu-bookmark-link =
    .label = Đánh dấu liên kết
    .accesskey = B
main-context-menu-save-link =
    .label = Lưu liên kết tới…
    .accesskey = k
main-context-menu-save-link-to-pocket =
    .label = Lưu liên kết vào { -pocket-brand-name }
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = Sao chép địa chỉ email
    .accesskey = E
main-context-menu-copy-link =
    .label = Sao chép địa chỉ liên kết
    .accesskey = a
main-context-menu-copy-link-simple =
    .label = Sao chép liên kết
    .accesskey = L

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = Phát
    .accesskey = P
main-context-menu-media-pause =
    .label = Tạm dừng
    .accesskey = P

##

main-context-menu-media-mute =
    .label = Tắt tiếng
    .accesskey = M
main-context-menu-media-unmute =
    .label = Bật tiếng
    .accesskey = m
main-context-menu-media-play-speed =
    .label = Tốc độ phát
    .accesskey = d
main-context-menu-media-play-speed-slow =
    .label = Chậm (0,5×)
    .accesskey = S
main-context-menu-media-play-speed-normal =
    .label = Bình thường
    .accesskey = N
main-context-menu-media-play-speed-fast =
    .label = Nhanh (1,25×)
    .accesskey = F
main-context-menu-media-play-speed-faster =
    .label = Nhanh hơn (1,5×)
    .accesskey = a
# "Ludicrous" is a reference to the movie "Space Balls" and is meant
# to say that this speed is very fast.
main-context-menu-media-play-speed-fastest =
    .label = Rất nhanh (2×)
    .accesskey = L
main-context-menu-media-play-speed-2 =
    .label = Tốc độ
    .accesskey = d
main-context-menu-media-play-speed-slow-2 =
    .label = 0.5×
main-context-menu-media-play-speed-normal-2 =
    .label = 1.0×
main-context-menu-media-play-speed-fast-2 =
    .label = 1.25×
main-context-menu-media-play-speed-faster-2 =
    .label = 1.5×
main-context-menu-media-play-speed-fastest-2 =
    .label = 2×
main-context-menu-media-loop =
    .label = Lặp lại
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = Hiện các điều khiển
    .accesskey = C
main-context-menu-media-hide-controls =
    .label = Ẩn các điều khiển
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = Toàn màn hình
    .accesskey = F
main-context-menu-media-video-leave-fullscreen =
    .label = Thoát chế độ toàn màn hình
    .accesskey = u
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-pip =
    .label = Hình trong hình
    .accesskey = u
# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = Xem ở chế độ hình trong hình
    .accesskey = u
main-context-menu-image-reload =
    .label = Tải lại hình ảnh
    .accesskey = R
main-context-menu-image-view =
    .label = Xem ảnh
    .accesskey = I
main-context-menu-video-view =
    .label = Xem Video
    .accesskey = I
main-context-menu-image-view-new-tab =
    .label = Mở hình ảnh trong thẻ mới
    .accesskey = I
main-context-menu-video-view-new-tab =
    .label = Mở video trong thẻ mới
    .accesskey = i
main-context-menu-image-copy =
    .label = Sao chép ảnh
    .accesskey = y
main-context-menu-image-copy-location =
    .label = Sao chép địa chỉ ảnh
    .accesskey = o
main-context-menu-video-copy-location =
    .label = Sao chép địa chỉ video
    .accesskey = o
main-context-menu-audio-copy-location =
    .label = Sao chép địa chỉ âm thanh
    .accesskey = o
main-context-menu-image-copy-link =
    .label = Sao chép liên kết hình ảnh
    .accesskey = o
main-context-menu-video-copy-link =
    .label = Sao chép liên kết video
    .accesskey = o
main-context-menu-audio-copy-link =
    .label = Sao chép liên kết âm thanh
    .accesskey = o
main-context-menu-image-save-as =
    .label = Lưu ảnh dưới dạng…
    .accesskey = v
main-context-menu-image-email =
    .label = Gửi ảnh qua email…
    .accesskey = g
main-context-menu-image-set-as-background =
    .label = Đặt làm hình nền desktop…
    .accesskey = S
main-context-menu-image-set-image-as-background =
    .label = Đặt hình ảnh làm màn hình nền…
    .accesskey = S
main-context-menu-image-info =
    .label = Xem thông tin hình ảnh
    .accesskey = f
main-context-menu-image-desc =
    .label = Xem mô tả
    .accesskey = D
main-context-menu-video-save-as =
    .label = Lưu video tới…
    .accesskey = v
main-context-menu-audio-save-as =
    .label = Lưu audio tới…
    .accesskey = v
main-context-menu-video-image-save-as =
    .label = Lưu ảnh chụp màn hình dưới dạng…
    .accesskey = S
main-context-menu-video-take-snapshot =
    .label = Chụp ảnh…
    .accesskey = S
main-context-menu-video-email =
    .label = Gửi video qua email…
    .accesskey = a
main-context-menu-audio-email =
    .label = Gửi âm thanh qua email…
    .accesskey = a
main-context-menu-plugin-play =
    .label = Kích hoạt phần bổ trợ này
    .accesskey = c
main-context-menu-plugin-hide =
    .label = Ẩn phần bổ trợ này
    .accesskey = H
main-context-menu-save-to-pocket =
    .label = Lưu trang vào { -pocket-brand-name }
    .accesskey = k
main-context-menu-send-to-device =
    .label = Gửi trang tới thiết bị
    .accesskey = n
main-context-menu-view-background-image =
    .label = Xem ảnh nền
    .accesskey = w
main-context-menu-generate-new-password =
    .label = Sử dụng mật khẩu được tạo…
    .accesskey = G

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = Sử dụng thông tin đăng nhập đã lưu
    .accesskey = o
main-context-menu-use-saved-password =
    .label = Sử dụng mật khẩu đã lưu
    .accesskey = o

##

main-context-menu-suggest-strong-password =
    .label = Đề xuất mật khẩu mạnh…
    .accesskey = S
main-context-menu-manage-logins2 =
    .label = Quản lý thông tin đăng nhập
    .accesskey = M
main-context-menu-keyword =
    .label = Tạo từ khóa cho chuỗi tìm kiếm này…
    .accesskey = K
main-context-menu-link-send-to-device =
    .label = Gửi đường dẫn tới thiết bị
    .accesskey = n
main-context-menu-frame =
    .label = Khung này
    .accesskey = h
main-context-menu-frame-show-this =
    .label = Chỉ hiện khung này
    .accesskey = S
main-context-menu-frame-open-tab =
    .label = Mở khung trong thẻ mới
    .accesskey = T
main-context-menu-frame-open-window =
    .label = Mở khung trong cửa sổ mới
    .accesskey = W
main-context-menu-frame-reload =
    .label = Tải lại khung
    .accesskey = R
main-context-menu-frame-bookmark =
    .label = Đánh dấu khung này
    .accesskey = m
main-context-menu-frame-save-as =
    .label = Lưu khung thành…
    .accesskey = F
main-context-menu-frame-print =
    .label = In khung…
    .accesskey = P
main-context-menu-frame-view-source =
    .label = Xem mã nguồn khung
    .accesskey = V
main-context-menu-frame-view-info =
    .label = Xem thông tin khung
    .accesskey = I
main-context-menu-print-selection =
    .label = Lựa chọn in
    .accesskey = i
main-context-menu-view-selection-source =
    .label = Xem mã nguồn của đoạn bôi đen
    .accesskey = e
main-context-menu-take-screenshot =
    .label = Chụp màn hình
    .accesskey = T
main-context-menu-take-frame-screenshot =
    .label = Chụp màn hình
    .accesskey = o
main-context-menu-view-page-source =
    .label = Xem mã nguồn trang
    .accesskey = V
main-context-menu-view-page-info =
    .label = Xem thông tin trang
    .accesskey = I
main-context-menu-bidi-switch-text =
    .label = Chuyển hướng văn bản
    .accesskey = w
main-context-menu-bidi-switch-page =
    .label = Chuyển hướng trang
    .accesskey = D
main-context-menu-inspect-element =
    .label = Kiểm tra phần tử HTML
    .accesskey = Q
main-context-menu-inspect =
    .label = Kiểm tra
    .accesskey = Q
main-context-menu-inspect-a11y-properties =
    .label = Kiểm tra thuộc tính trợ năng
main-context-menu-eme-learn-more =
    .label = Tìm hiểu thêm về DRM…
    .accesskey = D
