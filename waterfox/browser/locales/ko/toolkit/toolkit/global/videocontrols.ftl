# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = 위치
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = 로드 중:
videocontrols-volume-control =
    .aria-label = 볼륨
videocontrols-closed-caption-button =
    .aria-label = 선택 자막
videocontrols-play-button =
    .aria-label = 재생
videocontrols-pause-button =
    .aria-label = 정지
videocontrols-mute-button =
    .aria-label = 음소거
videocontrols-unmute-button =
    .aria-label = 음소거 해제
videocontrols-enterfullscreen-button =
    .aria-label = 전체 화면 표시
videocontrols-exitfullscreen-button =
    .aria-label = 전체 화면 종료
videocontrols-casting-button-label =
    .aria-label = 화면으로 출력
videocontrols-closed-caption-off =
    .offlabel = 끔
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = 화면 속 화면
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = 화면 속 화면에서 보기
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = { -brand-short-name }에서 다른 작업을 수행하는 동안 전경에서 동영상을 재생합니다
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = 이 동영상을 창 분리
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = 더 많은 화면이 더 재미있습니다. 탐색하는 동안에 화면 속 화면으로 이 동영상을 재생하세요.
videocontrols-error-aborted = 동영상 로드가 중지되었습니다.
videocontrols-error-network = 네트워크 오류로 인해 동영상 재생이 중단되었습니다.
videocontrols-error-decode = 파일이 깨져서 동영상을 재생할 수 없습니다.
videocontrols-error-src-not-supported = 동영상 형식 또는 MIME 유형을 지원하지 않습니다.
videocontrols-error-no-source = 지원되는 형식 및 MIME 유형의 동영상를 찾을 수 없습니다.
videocontrols-error-generic = 알 수 없는 오류로 인해 동영상 재생이 중단되었습니다.
videocontrols-status-picture-in-picture = 이 동영상은 화면 속 화면 모드에서 재생 중입니다.
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
