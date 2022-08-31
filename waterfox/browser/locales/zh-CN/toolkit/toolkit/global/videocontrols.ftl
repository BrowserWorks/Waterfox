# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = 位置
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = 正在加载：
videocontrols-volume-control =
    .aria-label = 音量
videocontrols-closed-caption-button =
    .aria-label = 隐藏式字幕
videocontrols-play-button =
    .aria-label = 播放
videocontrols-pause-button =
    .aria-label = 暂停
videocontrols-mute-button =
    .aria-label = 静音
videocontrols-unmute-button =
    .aria-label = 恢复声音
videocontrols-enterfullscreen-button =
    .aria-label = 全屏
videocontrols-exitfullscreen-button =
    .aria-label = 退出全屏
videocontrols-casting-button-label =
    .aria-label = 投射到屏幕
videocontrols-closed-caption-off =
    .offlabel = 关
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = 画中画
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = 画中画观看
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = 让您在 { -brand-short-name } 做其他事时，同时能在前台观看视频。
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = 弹出此视频
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = 同屏多任务，在您浏览网页的同时画中画播放视频。
videocontrols-error-aborted = 视频载入已停止。
videocontrols-error-network = 视频播放因网络错误中止。
videocontrols-error-decode = 视频无法播放，因为该文件已损坏。
videocontrols-error-src-not-supported = 视频格式或 MIME 类型不受支持。
videocontrols-error-no-source = 没有找到支持的视频格式和 MIME 类型。
videocontrols-error-generic = 视频播放因未知错误中止。
videocontrols-status-picture-in-picture = 正以画中画模式播放此视频。
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
