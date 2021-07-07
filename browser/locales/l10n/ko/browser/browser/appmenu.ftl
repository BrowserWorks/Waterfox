# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = { -brand-shorter-name } 업데이트 다운로드 중
    .label-update-available = 업데이트 사용 가능 — 지금 다운로드
    .label-update-manual = 업데이트 사용 가능 — 지금 다운로드
    .label-update-unsupported = 업데이트할 수 없음 — 시스템이 호환되지 않음
    .label-update-restart = 업데이트 사용 가능 — 지금 다시 시작
appmenuitem-protection-dashboard-title = 보호 대시보드
appmenuitem-customize-mode =
    .label = 사용자 지정…

## Zoom Controls

appmenuitem-new-tab =
    .label = 새 탭
appmenuitem-new-window =
    .label = 새 창
appmenuitem-new-private-window =
    .label = 새 사생활 보호 창
appmenuitem-passwords =
    .label = 비밀번호
appmenuitem-addons-and-themes =
    .label = 부가 기능 및 테마
appmenuitem-find-in-page =
    .label = 페이지에서 찾기…
appmenuitem-more-tools =
    .label = 더 많은 도구
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] 종료
           *[other] 종료
        }
appmenu-menu-button-closed2 =
    .tooltiptext = 애플리케이션 메뉴 열기
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = 애플리케이션 메뉴 닫기
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = 설정

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = 확대
appmenuitem-zoom-reduce =
    .label = 축소
appmenuitem-fullscreen =
    .label = 전체 화면

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = 지금 동기화
appmenu-remote-tabs-sign-into-sync =
    .label = Sync에 로그인…
appmenu-remote-tabs-turn-on-sync =
    .label = Sync 켜기…
appmenuitem-fxa-toolbar-sync-now2 = 지금 동기화
appmenuitem-fxa-manage-account = 계정 관리
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = { $time }에 마지막으로 동기화됨
    .label = { $time }에 마지막으로 동기화됨
appmenu-fxa-sync-and-save-data2 = 데이터 동기화 및 저장
appmenu-fxa-signed-in-label = 로그인
appmenu-fxa-setup-sync =
    .label = 동기화 켜기…
appmenu-fxa-show-more-tabs = 더 많은 탭 표시
appmenuitem-save-page =
    .label = 페이지를 다른 이름으로 저장…

## What's New panel in App menu.

whatsnew-panel-header = 새 기능
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = 새 기능 알림
    .accesskey = f

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = 더 많은 정보 보기
profiler-popup-description-title =
    .value = 기록, 분석, 공유
profiler-popup-description = 팀과 공유할 프로필을 게시하여 성능 문제에 대해 협업합니다.
profiler-popup-learn-more = 더 알아보기
profiler-popup-settings =
    .value = 설정
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = 설정 편집…
profiler-popup-disabled =
    프로파일러가 현재 비활성화되어 있습니다. 대부분의 경우 
    사생활 보호 창이 열려 있기 때문입니다.
profiler-popup-recording-screen = 기록 중…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = 사용자 지정
profiler-popup-start-recording-button =
    .label = 기록 시작
profiler-popup-discard-button =
    .label = 취소
profiler-popup-capture-button =
    .label = 캡처
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## History panel

appmenu-manage-history =
    .label = 기록 관리
appmenu-reopen-all-tabs = 모든 탭 다시 열기
appmenu-reopen-all-windows = 모든 창 다시 열기
appmenu-restore-session =
    .label = 이전 세션 복원
appmenu-clear-history =
    .label = 최근 기록 지우기…
appmenu-recent-history-subheader = 최근 기록
appmenu-recently-closed-tabs =
    .label = 최근에 닫은 탭
appmenu-recently-closed-windows =
    .label = 최근에 닫은 창

## Help panel

appmenu-help-header =
    .title = { -brand-shorter-name } 도움말
appmenu-about =
    .label = { -brand-shorter-name } 정보
    .accesskey = A
appmenu-get-help =
    .label = 도움 받기
    .accesskey = H
appmenu-help-more-troubleshooting-info =
    .label = 추가 문제 해결 정보
    .accesskey = T
appmenu-help-report-site-issue =
    .label = 사이트 문제 보고…
appmenu-help-feedback-page =
    .label = 사용자 의견 보내기…
    .accesskey = S

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = 문제 해결 모드…
    .accesskey = M
appmenu-help-exit-troubleshoot-mode =
    .label = 문제 해결 모드 끄기
    .accesskey = M

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = 가짜 사이트 신고…
    .accesskey = D
appmenu-help-not-deceptive =
    .label = 이 사이트는 가짜 사이트가 아닙니다…
    .accesskey = d

## More Tools

appmenu-customizetoolbar =
    .label = 도구 모음 사용자 지정…
appmenu-taskmanager =
    .label = 작업 관리자
appmenu-developer-tools-subheader = 브라우저 도구
appmenu-developer-tools-extensions =
    .label = 개발자용 확장 기능
