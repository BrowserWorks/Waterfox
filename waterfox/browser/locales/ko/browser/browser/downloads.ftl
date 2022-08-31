# This Source Code Form is subject to the terms of the Waterfox Public
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
downloads-panel-items =
    .style = width: 35em

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

downloads-cmd-show-menuitem-2 =
    .label =
        { PLATFORM() ->
            [macos] Finder에서 보기
           *[other] 폴더에서 보기
        }
    .accesskey = F

## Displayed in the downloads context menu for files that can be opened.
## Variables:
##   $handler (String) - The name of the mime type's default file handler.
##   Example: "Notepad", "Acrobat Reader DC", "7-Zip File Manager"

downloads-cmd-use-system-default =
    .label = 시스템 뷰어에서 열기
    .accesskey = V
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-use-system-default-named =
    .label = { $handler }에서 열기
    .accesskey = I

# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-use-system-default =
    .label = 항상 시스템 뷰어에서 열기
    .accesskey = w
# We can use the same accesskey as downloads-cmd-always-open-similar-files.
# Both should not be visible in the downloads context menu at the same time.
# This version is shown when the download's mime type has a valid file handler.
downloads-cmd-always-use-system-default-named =
    .label = 항상 { $handler }에서 열기
    .accesskey = w

##

# We can use the same accesskey as downloads-cmd-always-use-system-default.
# Both should not be visible in the downloads context menu at the same time.
downloads-cmd-always-open-similar-files =
    .label = 항상 이 파일 유형 열기
    .accesskey = w

downloads-cmd-show-button-2 =
    .tooltiptext =
        { PLATFORM() ->
            [macos] Finder에서 보기
           *[other] 폴더에서 보기
        }

downloads-cmd-show-panel-2 =
    .aria-label =
        { PLATFORM() ->
            [macos] Finder에서 보기
           *[other] 폴더에서 보기
        }
downloads-cmd-show-description-2 =
    .value =
        { PLATFORM() ->
            [macos] Finder에서 보기
           *[other] 폴더에서 보기
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
    .label = 미리보기 패널 정리
    .accesskey = a
downloads-cmd-clear-downloads =
    .label = 다운로드 정리
    .accesskey = D
downloads-cmd-delete-file =
    .label = 삭제
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
    .value = 자세히 보기

# Displayed when hovering a complete download, indicates that it's possible to
# open the file using an app available in the system.
downloads-open-file =
    .value = 파일 열기

## Displayed when the user clicked on a download in process. Indicates that the
## downloading file will be opened after certain amount of time using an app
## available in the system.
## Variables:
##   $hours (number) - Amount of hours left till the file opens.
##   $seconds (number) - Amount of seconds left till the file opens.
##   $minutes (number) - Amount of minutes till the file opens.

downloading-file-opens-in-hours-and-minutes = { $hours }시간 { $minutes }분 후 열림…
downloading-file-opens-in-minutes = { $minutes }분 후 열림…
downloading-file-opens-in-minutes-and-seconds = { $minutes }분 { $seconds }초 후 열림…
downloading-file-opens-in-seconds = { $seconds }초 후 열림…
downloading-file-opens-in-some-time = 완료 후 열림…
downloading-file-click-to-open =
    .value = 완료 후 열기

##

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
    .title = 다운로드 상세 정보

## Displayed when a site attempts to automatically download many files.
## Variables:
##   $num (number) - Number of blocked downloads.
##   $url (string) - The url of the suspicious site, stripped of http, https and www prefix.

downloads-files-not-downloaded =
    { $num ->
       *[other] 파일 { $num }개가 다운로드되지 않았습니다.
    }
downloads-blocked-from-url = { $url }에서 다운로드가 차단되었습니다.
downloads-blocked-download-detailed-info = { $url } 사이트가 자동으로 여러 파일을 다운로드하려고 했습니다. 사이트가 손상되었거나 기기에 스팸 파일을 저장하려고 할 수 있습니다.

##

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

# This is displayed in an item at the bottom of the Downloads Panel when there
# are more downloads than can fit in the list in the panel.
#   $count (number) - number of files being downloaded that are not shown in the
#                     panel list.
downloads-more-downloading =
    { $count ->
       *[other] 파일 { $count }개 더 다운로드 중
    }
