# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = 位置
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = 正在載入:
videocontrols-volume-control =
    .aria-label = 音量
videocontrols-closed-caption-button =
    .aria-label = 隱藏式字幕
videocontrols-play-button =
    .aria-label = 播放
videocontrols-pause-button =
    .aria-label = 暫停
videocontrols-mute-button =
    .aria-label = 靜音
videocontrols-unmute-button =
    .aria-label = 取消靜音
videocontrols-enterfullscreen-button =
    .aria-label = 全螢幕
videocontrols-exitfullscreen-button =
    .aria-label = 離開全螢幕模式
videocontrols-casting-button-label =
    .aria-label = 投放至裝置
videocontrols-closed-caption-off =
    .offlabel = 關閉
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = 子母畫面
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = 使用子畫面觀賞
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = 讓您在 { -brand-short-name } 作別的事情時，同時能在前景播放影片
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = 彈出這部影片
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = 越多畫面越有趣。在您上網時將這段影片放到子畫面中播放。
videocontrols-error-aborted = 已停止載入視訊。
videocontrols-error-network = 因為網路錯誤，已中止視訊播放。
videocontrols-error-decode = 因為檔案毀損，無法播放視訊。
videocontrols-error-src-not-supported = 不支援的視訊格式或 MIME 類型。
videocontrols-error-no-source = 沒有找到支援格式與 MIME 類型的影片。
videocontrols-error-generic = 因為未知錯誤，已中止視訊播放。
videocontrols-status-picture-in-picture = 正以子母畫面模式播放此影片。
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
