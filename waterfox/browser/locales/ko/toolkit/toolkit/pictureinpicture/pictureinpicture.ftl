# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

pictureinpicture-player-title = 화면 속 화면

## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.
##
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

pictureinpicture-pause-btn =
    .aria-label = 일시 정지
    .tooltip = 일시 정지 (스페이스바)
pictureinpicture-play-btn =
    .aria-label = 재생
    .tooltip = 재생 (스페이스바)

pictureinpicture-mute-btn =
    .aria-label = 음소거
    .tooltip = 음소거 ({ $shortcut })
pictureinpicture-unmute-btn =
    .aria-label = 음소거 해제
    .tooltip = 음소거 해제 ({ $shortcut })

pictureinpicture-unpip-btn =
    .aria-label = 탭으로 다시 보내기
    .tooltip = 탭으로 돌아가기

pictureinpicture-close-btn =
    .aria-label = 닫기
    .tooltip = 닫기 ({ $shortcut })

pictureinpicture-subtitles-btn =
    .aria-label = 자막
    .tooltip = 자막

pictureinpicture-fullscreen-btn2 =
    .aria-label = 전체 화면
    .tooltip = 전체 화면 (더블 클릭 또는 { $shortcut })

pictureinpicture-exit-fullscreen-btn2 =
    .aria-label = 전체 화면 종료
    .tooltip = 전체 화면 종료 (더블 클릭 또는 { $shortcut })

##

# Keyboard shortcut to toggle fullscreen mode when Picture-in-Picture is open.
pictureinpicture-toggle-fullscreen-shortcut =
    .key = F

## Note that this uses .tooltip rather than the standard '.title'
## or '.tooltiptext' -  but it has the same effect. Code in the
## picture-in-picture window will read and copy this to an in-document
## DOM node that then shows the tooltip.

pictureinpicture-seekbackward-btn =
    .aria-label = 뒤로
    .tooltip = 뒤로 (←)

pictureinpicture-seekforward-btn =
    .aria-label = 앞으로
    .tooltip = 앞으로 (→)

##

# This string is never displayed on the window. Is intended to be announced by
# a screen reader whenever a user opens the subtitles settings panel
# after selecting the subtitles button.
pictureinpicture-subtitles-panel-accessible = 자막 설정

pictureinpicture-subtitles-label = 자막

pictureinpicture-font-size-label = 글꼴 크기

pictureinpicture-font-size-small = 작게

pictureinpicture-font-size-medium = 보통

pictureinpicture-font-size-large = 크게
