# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = 読み込み中:
videocontrols-volume-control =
    .aria-label = 音量
videocontrols-closed-caption-button =
    .aria-label = 字幕
videocontrols-play-button =
    .aria-label = 再生
videocontrols-pause-button =
    .aria-label = 一時停止
videocontrols-mute-button =
    .aria-label = ミュート
videocontrols-unmute-button =
    .aria-label = ミュート解除
videocontrols-enterfullscreen-button =
    .aria-label = 全画面表示
videocontrols-exitfullscreen-button =
    .aria-label = 全画面表示を解除
videocontrols-casting-button-label =
    .aria-label = 画面に映す
# .offlabel is processed by the video control custom element to be used
# as a text-track label
videocontrols-closed-caption-off =
    .offlabel = オフ
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = ピクチャーインピクチャー
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = この動画をポップアウト
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer3 = 多くの画面でさらに楽しめます。他のことをしている間もこの動画を再生します。
videocontrols-error-aborted = 動画の読み込みを中止しました。
videocontrols-error-network = ネットワークエラーが発生したため動画の再生を中止しました。
videocontrols-error-decode = ファイルが壊れているため動画を再生できません。
videocontrols-error-src-not-supported = この動画のファイル形式または MIME タイプはサポートされていません。
videocontrols-error-no-source = サポートされたファイル形式および MIME タイプの動画が見つかりませんでした。
videocontrols-error-generic = 原因不明のエラーが発生したため動画の再生を中止しました。
videocontrols-status-picture-in-picture = この動画はピクチャーインピクチャーモードで再生されています。
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
# This is a plain text version of the videocontrols-position-and-duration-labels
# string, used by screenreaders.
#
# Variables:
#   $position (String): The current media position
#   $duration (String): The total video duration
videocontrols-scrubber-position-and-duration =
    .aria-label = 再生位置
    .aria-valuetext = { $position } / { $duration }
