# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

navbar-tooltip-instruction =
    .value =
        { PLATFORM() ->
            [macos] 아래로 잡아당겨 기록 보기
           *[other] 오른쪽 클릭 또는 아래로 잡아당겨 기록 보기
        }

## Back

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Back command.
main-context-menu-back-2 =
    .tooltiptext = 한 페이지 뒤로 가기 ({ $shortcut })
    .aria-label = 뒤로
    .accesskey = B

# This menuitem is only visible on macOS
main-context-menu-back-mac =
    .label = 뒤로
    .accesskey = B

navbar-tooltip-back-2 =
    .value = { main-context-menu-back-2.tooltiptext }

toolbar-button-back-2 =
    .label = { main-context-menu-back-2.aria-label }

## Forward

# Variables
#   $shortcut (String) - A keyboard shortcut for the Go Forward command.
main-context-menu-forward-2 =
    .tooltiptext = 한 페이지 앞으로 가기 ({ $shortcut })
    .aria-label = 앞으로
    .accesskey = F

# This menuitem is only visible on macOS
main-context-menu-forward-mac =
    .label = 앞으로
    .accesskey = F

navbar-tooltip-forward-2 =
    .value = { main-context-menu-forward-2.tooltiptext }

toolbar-button-forward-2 =
    .label = { main-context-menu-forward-2.aria-label }

## Reload

main-context-menu-reload =
    .aria-label = 새로 고침
    .accesskey = R

# This menuitem is only visible on macOS
main-context-menu-reload-mac =
    .label = 새로 고침
    .accesskey = R

toolbar-button-reload =
    .label = { main-context-menu-reload.aria-label }

## Stop

main-context-menu-stop =
    .aria-label = 중지
    .accesskey = S

# This menuitem is only visible on macOS
main-context-menu-stop-mac =
    .label = 중지
    .accesskey = S

toolbar-button-stop =
    .label = { main-context-menu-stop.aria-label }

## Stop-Reload Button

toolbar-button-stop-reload =
    .title = { main-context-menu-reload.aria-label }

## Waterfox Account Button

toolbar-button-fxaccount =
    .label = { -fxaccount-brand-name }
    .tooltiptext = { -fxaccount-brand-name }

## Save Page

main-context-menu-page-save =
    .label = 페이지를 다른 이름으로 저장…
    .accesskey = P

## Simple menu items

main-context-menu-bookmark-add =
    .aria-label = 이 페이지 북마크
    .accesskey = m
    .tooltiptext = 이 페이지 북마크

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-edit-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-add-mac =
    .label = 페이지 북마크
    .accesskey = m

# This menuitem is only visible on macOS
# Cannot be shown at the same time as main-context-menu-bookmark-add-mac,
# so should probably have the same access key if possible.
main-context-menu-bookmark-edit-mac =
    .label = 북마크 편집
    .accesskey = m

# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
main-context-menu-bookmark-add-with-shortcut =
    .aria-label = 이 페이지 북마크
    .accesskey = m
    .tooltiptext = 이 페이지 북마크 ({ $shortcut })

main-context-menu-bookmark-change =
    .aria-label = 이 북마크 편집
    .accesskey = m
    .tooltiptext = 북마크 편집

# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
main-context-menu-bookmark-change-with-shortcut =
    .aria-label = 이 북마크 편집
    .accesskey = m
    .tooltiptext = 북마크 편집 ({ $shortcut })

main-context-menu-open-link =
    .label = 링크 열기
    .accesskey = O

main-context-menu-open-link-new-tab =
    .label = 링크를 새 탭에 열기
    .accesskey = T

main-context-menu-open-link-container-tab =
    .label = 링크를 새 컨테이너 탭에 열기
    .accesskey = C

main-context-menu-open-link-new-window =
    .label = 링크를 새 창에 열기
    .accesskey = W

main-context-menu-open-link-new-private-window =
    .label = 링크를 새 사생활 보호 창에 열기
    .accesskey = P

main-context-menu-bookmark-link =
    .label = 링크 북마크
    .accesskey = B

main-context-menu-save-link =
    .label = 링크를 다른 이름으로 저장…
    .accesskey = k

main-context-menu-save-link-to-pocket =
    .label = 링크를 { -pocket-brand-name }에 저장
    .accesskey = o

## The access keys for "Copy Link Location" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.


## The access keys for "Copy Link" and "Copy Email Address"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-copy-email =
    .label = 메일 주소 복사
    .accesskey = E

main-context-menu-copy-link-simple =
    .label = 링크 복사
    .accesskey = L

## Media (video/audio) controls
##
## The accesskey for "Play" and "Pause" are the
## same because the two context-menu items are
## mutually exclusive.

main-context-menu-media-play =
    .label = 재생
    .accesskey = P

main-context-menu-media-pause =
    .label = 중지
    .accesskey = P

##

main-context-menu-media-mute =
    .label = 음소거
    .accesskey = M

main-context-menu-media-unmute =
    .label = 음소거 해제
    .accesskey = m

main-context-menu-media-play-speed-2 =
    .label = 속도
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
    .label = 반복
    .accesskey = L

## The access keys for "Show Controls" and "Hide Controls" are the same
## because the two context-menu items are mutually exclusive.

main-context-menu-media-show-controls =
    .label = 컨트롤 표시
    .accesskey = C

main-context-menu-media-hide-controls =
    .label = 컨트롤 숨기기
    .accesskey = C

##

main-context-menu-media-video-fullscreen =
    .label = 전체 화면
    .accesskey = F

main-context-menu-media-video-leave-fullscreen =
    .label = 전체 화면 종료
    .accesskey = u

# This is used when right-clicking on a video in the
# content area when the Picture-in-Picture feature is enabled.
main-context-menu-media-watch-pip =
    .label = 화면 속 화면에서 보기
    .accesskey = u

main-context-menu-image-reload =
    .label = 이미지 다시 읽기
    .accesskey = R

main-context-menu-image-view-new-tab =
    .label = 이미지를 새 탭에 열기
    .accesskey = I

main-context-menu-video-view-new-tab =
    .label = 동영상을 새 탭에 열기
    .accesskey = i

main-context-menu-image-copy =
    .label = 이미지 복사
    .accesskey = y

main-context-menu-image-copy-link =
    .label = 이미지 링크 복사
    .accesskey = o

main-context-menu-video-copy-link =
    .label = 동영상 링크 복사
    .accesskey = o

main-context-menu-audio-copy-link =
    .label = 오디오 링크 복사
    .accesskey = o

main-context-menu-image-save-as =
    .label = 이미지를 다른 이름으로 저장…
    .accesskey = v

main-context-menu-image-email =
    .label = 메일로 이미지 보내기…
    .accesskey = a

main-context-menu-image-set-image-as-background =
    .label = 바탕 화면 배경으로 설정…
    .accesskey = S

main-context-menu-image-info =
    .label = 이미지 정보 보기
    .accesskey = f

main-context-menu-image-desc =
    .label = 설명 보기
    .accesskey = D

main-context-menu-video-save-as =
    .label = 동영상을 다른 이름으로 저장…
    .accesskey = v

main-context-menu-audio-save-as =
    .label = 오디오를 다른 이름으로 저장…
    .accesskey = v

main-context-menu-video-take-snapshot =
    .label = 스냅샷 찍기…
    .accesskey = S

main-context-menu-video-email =
    .label = 메일로 동영상 보내기…
    .accesskey = a

main-context-menu-audio-email =
    .label = 메일로 오디오 보내기…
    .accesskey = a

main-context-menu-plugin-play =
    .label = 이 플러그인 활성화
    .accesskey = c

main-context-menu-plugin-hide =
    .label = 이 플러그인 숨기기
    .accesskey = H

main-context-menu-save-to-pocket =
    .label = 페이지를 { -pocket-brand-name }에 저장
    .accesskey = k

main-context-menu-send-to-device =
    .label = 페이지를 기기로 보내기
    .accesskey = D

## The access keys for "Use Saved Login" and "Use Saved Password"
## should be the same if possible; the two context menu items
## are mutually exclusive.

main-context-menu-use-saved-login =
    .label = 저장된 로그인 사용
    .accesskey = o

main-context-menu-use-saved-password =
    .label = 저장된 비밀번호 사용
    .accesskey = o

##

main-context-menu-suggest-strong-password =
    .label = 강력한 비밀번호 제안…
    .accesskey = S

main-context-menu-manage-logins2 =
    .label = 로그인 관리
    .accesskey = M

main-context-menu-keyword =
    .label = 이 검색의 키워드 추가…
    .accesskey = K

main-context-menu-link-send-to-device =
    .label = 링크를 기기로 보내기
    .accesskey = D

main-context-menu-frame =
    .label = 이 프레임
    .accesskey = h

main-context-menu-frame-show-this =
    .label = 이 프레임만 표시
    .accesskey = S

main-context-menu-frame-open-tab =
    .label = 프레임을 새 탭에 열기
    .accesskey = T

main-context-menu-frame-open-window =
    .label = 프레임을 새 창에 열기
    .accesskey = W

main-context-menu-frame-reload =
    .label = 프레임 새로 고침
    .accesskey = R

main-context-menu-frame-bookmark =
    .label = 이 프레임 북마크
    .accesskey = m

main-context-menu-frame-save-as =
    .label = 프레임을 다른 이름으로 저장…
    .accesskey = F

main-context-menu-frame-print =
    .label = 프레임 인쇄…
    .accesskey = P

main-context-menu-frame-view-source =
    .label = 프레임 소스 보기
    .accesskey = V

main-context-menu-frame-view-info =
    .label = 프레임 정보 보기
    .accesskey = I

main-context-menu-print-selection =
    .label = 선택 영역 인쇄
    .accesskey = r

main-context-menu-view-selection-source =
    .label = 선택 영역 소스 보기
    .accesskey = e

main-context-menu-take-screenshot =
    .label = 스크린샷 찍기
    .accesskey = T

main-context-menu-take-frame-screenshot =
    .label = 스크린샷 찍기
    .accesskey = o

main-context-menu-view-page-source =
    .label = 페이지 소스 보기
    .accesskey = V

main-context-menu-bidi-switch-text =
    .label = 글자 방향 변경
    .accesskey = w

main-context-menu-bidi-switch-page =
    .label = 페이지 방향 변경
    .accesskey = g

main-context-menu-inspect =
    .label = 검사
    .accesskey = Q

main-context-menu-inspect-a11y-properties =
    .label = 접근성 속성 검사

main-context-menu-eme-learn-more =
    .label = DRM에 대해 더 알아보기…
    .accesskey = D

# Variables
#   $containerName (String): The name of the current container
main-context-menu-open-link-in-container-tab =
    .label = 링크를 새 { $containerName } 탭에 열기
    .accesskey = T
