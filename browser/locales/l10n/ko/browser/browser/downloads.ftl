# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The title and aria-label attributes are used by screen readers to describe
## the Downloads Panel.

downloads-window =
    .title = 다운로드
downloads-panel =
    .aria-label = 다운로드

##

# The style attribute has the width of the Downloads Panel expressed using
# a CSS unit. The longest labels that should fit are usually those of
# in-progress and blocked downloads.
downloads-panel-list =
    .style = width: 70ch
downloads-cmd-pause =
    .label = 일시 중지
    .accesskey = P
downloads-cmd-resume =
    .label = 계속
    .accesskey = R
downloads-cmd-cancel =
    .tooltiptext = 취소
downloads-cmd-cancel-panel =
    .aria-label = 취소
# This message is only displayed on Windows and Linux devices
downloads-cmd-show-menuitem =
    .label = 폴더 열기
    .accesskey = F
# This message is only displayed on macOS devices
downloads-cmd-show-menuitem-mac =
    .label = Finder에서 보기
    .accesskey = F
downloads-cmd-use-system-default =
    .label = 시스템 뷰어에서 열기
    .accesskey = V
downloads-cmd-always-use-system-default =
    .label = 항상 시스템 뷰어에서 열기
    .accesskey = w
downloads-cmd-show-button =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Finder에서 보기
           *[other] 폴더 열기
        }
downloads-cmd-show-panel =
    .aria-label =
        { PLATFORM() ->
            [macos] Finder에서 보기
           *[other] 폴더 열기
        }
downloads-cmd-show-description =
    .value =
        { PLATFORM() ->
            [macos] Finder에서 보기
           *[other] 폴더 열기
        }
downloads-cmd-show-downloads =
    .label = 다운로드 폴더 보기
downloads-cmd-retry =
    .tooltiptext = 다시 시도
downloads-cmd-retry-panel =
    .aria-label = 다시 시도
downloads-cmd-go-to-download-page =
    .label = 다운로드 페이지 가기
    .accesskey = G
downloads-cmd-copy-download-link =
    .label = 다운로드 링크 복사
    .accesskey = L
downloads-cmd-remove-from-history =
    .label = 기록에서 삭제
    .accesskey = e
downloads-cmd-clear-list =
    .label = 미리보기 패널 지우기
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = 다운로드 정리
    .accesskey = D
# This command is shown in the context menu when downloads are blocked.
downloads-cmd-unblock =
    .label = 다운로드 허용
    .accesskey = o
# This is the tooltip of the action button shown when malware is blocked.
downloads-cmd-remove-file =
    .tooltiptext = 파일 삭제
downloads-cmd-remove-file-panel =
    .aria-label = 파일 삭제
# This is the tooltip of the action button shown when potentially unwanted
# downloads are blocked. This opens a dialog where the user can choose
# whether to unblock or remove the download. Removing is the default option.
downloads-cmd-choose-unblock =
    .tooltiptext = 파일 삭제 또는 다운로드 허용
downloads-cmd-choose-unblock-panel =
    .aria-label = 파일 삭제 또는 다운로드 허용
# This is the tooltip of the action button shown when uncommon downloads are
# blocked.This opens a dialog where the user can choose whether to open the
# file or remove the download. Opening is the default option.
downloads-cmd-choose-open =
    .tooltiptext = 파일 열기 또는 삭제
downloads-cmd-choose-open-panel =
    .aria-label = 파일 열기 또는 삭제
# Displayed when hovering a blocked download, indicates that it's possible to
# show more information for user to take the next action.
downloads-show-more-information =
    .value = 정보 더 보기
# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = 파일 열기
# Displayed when hovering a download which is able to be retried by users,
# indicates that it's possible to download this file again.
downloads-retry-download =
    .value = 다운로드 다시 시도
# Displayed when hovering a download which is able to be cancelled by users,
# indicates that it's possible to cancel and stop the download.
downloads-cancel-download =
    .value = 다운로드 취소
# This string is shown at the bottom of the Downloads Panel when all the
# downloads fit in the available space, or when there are no downloads in
# the panel at all.
downloads-history =
    .label = 모든 다운로드 항목 보기
    .accesskey = S
# This string is shown at the top of the Download Details Panel, to indicate
# that we are showing the details of a single download.
downloads-details =
    .title = 다운로드 상세
downloads-clear-downloads-button =
    .label = 다운로드 정리
    .tooltiptext = 완료, 취소 및 실패한 다운로드 항목 지우기
# This string is shown when there are no items in the Downloads view, when it
# is displayed inside a browser tab.
downloads-list-empty =
    .value = 다운로드 항목이 없습니다.
# This string is shown when there are no items in the Downloads Panel.
downloads-panel-empty =
    .value = 이 세션에 다운로드 항목이 없습니다.
