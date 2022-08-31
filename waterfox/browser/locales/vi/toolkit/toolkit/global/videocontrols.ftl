# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Vị trí
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Đang tải:
videocontrols-volume-control =
    .aria-label = Âm lượng
videocontrols-closed-caption-button =
    .aria-label = Closed Captions
videocontrols-play-button =
    .aria-label = Phát
videocontrols-pause-button =
    .aria-label = Tạm dừng
videocontrols-mute-button =
    .aria-label = Tắt tiếng
videocontrols-unmute-button =
    .aria-label = Bật tiếng
videocontrols-enterfullscreen-button =
    .aria-label = Toàn màn hình
videocontrols-exitfullscreen-button =
    .aria-label = Thoát chế độ toàn màn hình
videocontrols-casting-button-label =
    .aria-label = Chiếu ra màn hình
videocontrols-closed-caption-off =
    .offlabel = Tắt
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Hình trong hình
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Xem ở chế độ hình trong hình
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Phát video ở nền trước trong khi bạn làm những việc khác trong { -brand-short-name }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Mở video này ở cửa sổ bật lên
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Nhiều màn hình hơn, vui hơn. Phát video này ở chế độ hình trong hình khi bạn duyệt.
videocontrols-error-aborted = Đã dừng nạp video.
videocontrols-error-network = Không thể xem video vì lỗi kết nối.
videocontrols-error-decode = Không thể xem video vì tập tin bị hỏng.
videocontrols-error-src-not-supported = Định dạng video hoặc kiểu MIME không được hỗ trợ.
videocontrols-error-no-source = Không có video với định đạng được hỗ trợ.
videocontrols-error-generic = Không thể xem video vì một lỗi chưa biết.
videocontrols-status-picture-in-picture = Video này đang phát ở chế độ hình trong hình.
# This message shows the current position and total video duration
#
# Variables:
#   $position (String): The current media position
#   $duration (String): The total video duration
#
# For example, when at the 5 minute mark in a 6 hour long video,
# $position would be "5:00" and $duration would be "6:00:00", result
# string would be "5:00 / 6:00:00". Note that $duration is not always
# available. For example, when at the 5 minute mark in an unknown
# duration video, $position would be "5:00" and the string which is
# surrounded by <span> would be deleted, result string would be "5:00".
videocontrols-position-and-duration-labels = { $position }<span data-l10n-name="position-duration-format"> / { $duration }</span>
