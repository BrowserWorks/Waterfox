# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = 웹 사이트에 “추적 안 함” 신호를 보내서 추적을 원하지 않는다고 알림
do-not-track-learn-more = 더 알아보기
do-not-track-option-default-content-blocking-known =
    .label = { -brand-short-name }가 알려진 추적기를 차단하도록 설정된 경우에만
do-not-track-option-always =
    .label = 항상
pref-page-title =
    { PLATFORM() ->
        [windows] 설정
       *[other] 환경 설정
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] 설정에서 찾기
           *[other] 설정에서 찾기
        }
settings-page-title = 설정
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = 설정에서 찾기
managed-notice = 조직에서 브라우저를 관리하고 있습니다.
category-list =
    .aria-label = 카테고리
pane-general-title = 일반
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = 홈
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = 검색
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = 개인 정보 및 보안
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-sync-title3 = Sync
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = { -brand-short-name } 실험
category-experimental =
    .tooltiptext = { -brand-short-name } 실험
pane-experimental-subtitle = 주의해서 진행하세요
pane-experimental-search-results-header = { -brand-short-name } 실험: 주의해서 진행하세요
pane-experimental-description2 = 고급 구성 설정을 변경하면 { -brand-short-name }의 성능 또는 보안에 영향을 줄 수 있습니다.
pane-experimental-reset =
    .label = 기본값으로 복원
    .accesskey = R
help-button-label = { -brand-short-name } 도움말
addons-button-label = 확장 기능 및 테마
focus-search =
    .key = f
close-button =
    .aria-label = 닫기

## Browser Restart Dialog

feature-enable-requires-restart = 이 기능을 사용하려면 { -brand-short-name }를 반드시 다시 시작해야 합니다.
feature-disable-requires-restart = 이 기능을 끄려면 { -brand-short-name }를 반드시 다시 시작해야 합니다.
should-restart-title = { -brand-short-name } 다시 시작
should-restart-ok = 지금 { -brand-short-name } 다시 시작
cancel-no-restart-button = 취소
restart-later = 나중에 다시 시작

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = <img data-l10n-name="icon"/> { $name } 확장 기능이 홈페이지를 제어하고 있습니다.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = <img data-l10n-name="icon"/> { $name } 확장 기능이 새 탭 페이지를 제어하고 있습니다.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = <img data-l10n-name="icon"/> { $name } 확장 기능이 이 설정을 제어하고 있습니다.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = <img data-l10n-name="icon"/> { $name } 확장 기능이 이 설정을 제어하고 있습니다.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = <img data-l10n-name="icon"/> { $name } 확장 기능이 기본 검색 엔진을 설정했습니다.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = <img data-l10n-name="icon"/> { $name } 확장 기능은 컨테이너 탭이 필요합니다.
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = <img data-l10n-name="icon"/> { $name } 확장 기능이 이 설정을 제어하고 있습니다.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = <img data-l10n-name="icon"/> { $name } 확장 기능이 { -brand-short-name }가 인터넷에 접근하는 방법을 제어하고 있습니다.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = 확장 기능을 사용하려면 <img data-l10n-name="menu-icon"/> 메뉴에서 <img data-l10n-name="addons-icon"/> 부가 기능으로 이동하세요.

## Preferences UI Search Results

search-results-header = 검색 결과
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] 죄송합니다! “<span data-l10n-name="query"></span>”옵션에 대한 결과가 없습니다.
       *[other] 죄송합니다! “<span data-l10n-name="query"></span>”설정에 대한 결과가 없습니다.
    }
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = 죄송합니다! 설정에서 “<span data-l10n-name="query"></span>”에 대한 결과가 없습니다.
search-results-help-link = 도움이 필요하세요? <a data-l10n-name="url">{ -brand-short-name } 지원</a>에 방문하세요.

## General Section

startup-header = 시작 페이지
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = { -brand-short-name }과 Firefox 같이 돌리기
use-firefox-sync = 팁: 이렇게 하면 프로필을 따로 쓰게 됩니다. { -sync-brand-short-name }를 써서 데이터를 공유하세요.
get-started-not-logged-in = { -sync-brand-short-name }에 로그인…
get-started-configured = { -sync-brand-short-name } 설정 열기
always-check-default =
    .label = { -brand-short-name }가 기본 브라우저인지 항상 확인
    .accesskey = w
is-default = 현재 { -brand-short-name }가 기본 브라우저입니다
is-not-default = { -brand-short-name }가 기본 브라우저가 아닙니다
set-as-my-default-browser =
    .label = 기본 브라우저로…
    .accesskey = D
startup-restore-previous-session =
    .label = 이전 세션 복원
    .accesskey = s
startup-restore-warn-on-quit =
    .label = 브라우저 종료시 경고
disable-extension =
    .label = 확장 기능 사용 안 함
tabs-group-header = 탭
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab으로 최근 사용한 순서대로 탭 순환
    .accesskey = T
open-new-link-as-tabs =
    .label = 링크를 새 창 대신 새 탭에 열기
    .accesskey = w
warn-on-close-multiple-tabs =
    .label = 여러 개의 탭을 닫을 때 경고
    .accesskey = m
warn-on-open-many-tabs =
    .label = 여러개의 탭을 열어서 { -brand-short-name }가 느려질 수 있으면 알려주기
    .accesskey = d
switch-links-to-new-tabs =
    .label = 링크를 새 탭에 열면 해당 탭으로 즉시 전환
    .accesskey = h
switch-to-new-tabs =
    .label = 링크, 이미지 또는 미디어를 새 탭에 열면 해당 탭으로 즉시 전환
    .accesskey = h
show-tabs-in-taskbar =
    .label = Windows 작업 표시줄에 탭 미리 보기 표시
    .accesskey = k
browser-containers-enabled =
    .label = 컨테이너 탭 사용
    .accesskey = n
browser-containers-learn-more = 더 알아보기
browser-containers-settings =
    .label = 설정…
    .accesskey = i
containers-disable-alert-title = 모든 컨테이너 탭을 닫으시겠습니까?
containers-disable-alert-desc = 지금 컨테이너 탭을 비활성화하면 { $tabCount }개의 컨테이너 탭이 닫히게 됩니다. 컨테이너 탭을 비활성화하시겠습니까?
containers-disable-alert-ok-button = 컨테이너 탭 { $tabCount }개 닫기
containers-disable-alert-cancel-button = 활성화 하기
containers-remove-alert-title = 이 컨테이너를 삭제하시겠습니까?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg = 이 컨테이너를 삭제하면 { $count } 컨테이너 탭이 닫힙니다. 이 컨테이너를 정말로 삭제하시겠습니까?
containers-remove-ok-button = 이 컨테이너 삭제
containers-remove-cancel-button = 이 컨테이너 삭제하지 않음

## General Section - Language & Appearance

language-and-appearance-header = 언어와 모양
fonts-and-colors-header = 글꼴과 색상
default-font = 기본 글꼴
    .accesskey = D
default-font-size = 크기
    .accesskey = S
advanced-fonts =
    .label = 고급…
    .accesskey = A
colors-settings =
    .label = 색상…
    .accesskey = C
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = 확대/축소
preferences-default-zoom = 기본 확대/축소
    .accesskey = z
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = 글자 크기만 조정
    .accesskey = t
language-header = 언어
choose-language-description = 웹 페이지를 표시할 기본 언어 선택
choose-button =
    .label = 선택…
    .accesskey = o
choose-browser-language-description = { -brand-short-name }가 메뉴, 메시지 및 알림을 표시하는데 사용할 언어를 선택하세요.
manage-browser-languages-button =
    .label = 대체 설정…
    .accesskey = I
confirm-browser-language-change-description = 변경 내용 적용을 위해 { -brand-short-name } 다시 시작
confirm-browser-language-change-button = 적용하고 다시 시작
translate-web-pages =
    .label = 웹 콘텐츠 번역하기
    .accesskey = T
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = 번역:  <img data-l10n-name="logo"/>
translate-exceptions =
    .label = 예외…
    .accesskey = x
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = 날짜, 시간, 숫자 및 측정 단위 형식에 “{ $localeName }”에 대한 운영 체제 설정을 사용
check-user-spelling =
    .label = 입력할 때 맞춤법 검사
    .accesskey = t

## General Section - Files and Applications

files-and-applications-title = 파일 및 애플리케이션
download-header = 다운로드
download-save-to =
    .label = 저장 위치
    .accesskey = v
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] 선택…
           *[other] 찾아보기…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] e
           *[other] o
        }
download-always-ask-where =
    .label = 파일을 저장할 위치를 항상 묻기
    .accesskey = A
applications-header = 애플리케이션
applications-description = { -brand-short-name }가 웹에서 다운로드한 파일이나 탐색하는 동안에 사용하는 애플리케이션을 처리하는 방법을 선택하세요.
applications-filter =
    .placeholder = 파일 형식 또는 애플리케이션 검색
applications-type-column =
    .label = 콘텐츠 유형
    .accesskey = T
applications-action-column =
    .label = 동작
    .accesskey = A
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } 파일
applications-action-save =
    .label = 파일 저장
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = { $app-name } 사용
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = { $app-name } 사용(기본값)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] macOS 기본 애플리케이션 사용
            [windows] Windows 기본 애플리케이션 사용
           *[other] 시스템 기본 애플리케이션 사용
        }
applications-use-other =
    .label = 다른 애플리케이션 사용…
applications-select-helper = 도우미 애플리케이션 선택
applications-manage-app =
    .label = 애플리케이션 세부사항…
applications-always-ask =
    .label = 항상 물어 보기
applications-type-pdf = Portable Document Format (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = { $plugin-name } 사용({ -brand-short-name })
applications-open-inapp =
    .label = { -brand-short-name }에서 열기

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = 디지털 권리 관리(DRM) 콘텐츠
play-drm-content =
    .label = DRM 제어 콘텐츠 재생
    .accesskey = P
play-drm-content-learn-more = 더 알아보기
update-application-title = { -brand-short-name } 업데이트
update-application-description = { -brand-short-name }가 최상의 성능, 안정성, 보안을 유지할 수 있도록 최신 버전으로 유지합니다.
update-application-version = 버전 { $version } <a data-l10n-name="learn-more">새 기능</a>
update-history =
    .label = 업데이트 기록 보기…
    .accesskey = p
update-application-allow-description = { -brand-short-name } 설치 방법
update-application-auto =
    .label = 자동으로 업데이트 설치 (권장)
    .accesskey = A
update-application-check-choose =
    .label = 업데이트를 확인하지만 설치할지는 묻기
    .accesskey = C
update-application-manual =
    .label = 업데이트 확인 안 함 (권장하지 않음)
    .accesskey = N
update-application-background-enabled =
    .label = { -brand-short-name }가 실행 중이 아닐 때
    .accesskey = W
update-application-warning-cross-user-setting = 이 설정은 이 { -brand-short-name } 설치를 사용하는 모든 Windows 계정 및 { -brand-short-name } 프로필에 적용됩니다.
update-application-use-service =
    .label = 업데이트 설치 시 백그라운드 작업으로 하기
    .accesskey = b
update-setting-write-failure-title = 업데이트 설정 저장 중 오류 발생
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    오류가 발생하여 { -brand-short-name }가 이 변경 내용을 저장하지 않았습니다. 이 업데이트 설정을 하려면 아래 파일에 쓰기 권한이 필요합니다. 사용자나 시스템 관리자가 사용자 그룹에 이 파일에 대한 모든 권한을 부여하여 오류를 해결할 수 있습니다.
    
    파일에 쓸 수 없음: { $path }
update-setting-write-failure-title2 = 업데이트 설정 저장 중 오류 발생
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    오류가 발생하여 { -brand-short-name }가 이 변경 내용을 저장하지 않았습니다. 이 업데이트 설정을 변경하려면 아래 파일에 쓰기 권한이 필요합니다. 사용자나 시스템 관리자가 사용자 그룹에 이 파일에 대한 모든 권한을 부여하여 오류를 해결할 수 있습니다.
    
    파일에 쓸 수 없음: { $path }
update-in-progress-title = 업데이트 진행 중
update-in-progress-message = { -brand-short-name }가 이 업데이트를 계속하길 원하십니까?
update-in-progress-ok-button = 취소(&D)
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = 계속(&C)

## General Section - Performance

performance-title = 성능
performance-use-recommended-settings-checkbox =
    .label = 권장 설정을 사용
    .accesskey = U
performance-use-recommended-settings-desc = 이 설정은 컴퓨터 하드웨어 및 운영체제에 맞게 조정됩니다.
performance-settings-learn-more = 더 알아보기
performance-allow-hw-accel =
    .label = 하드웨어 가속이 가능하면 사용
    .accesskey = r
performance-limit-content-process-option = 콘텐츠 프로세스 제한
    .accesskey = L
performance-limit-content-process-enabled-desc = 추가 콘텐츠 프로세스는 여러 탭을 사용할 때 성능을 향상시킬 수 있지만 더 많은 메모리를 사용합니다.
performance-limit-content-process-blocked-desc = 콘텐츠 프로세스 갯수 변경은 다중 프로세스 { -brand-short-name }에서만 가능합니다. <a data-l10n-name="learn-more">다중 프로세스가 활성화되었는지 확인하는 방법</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (기본값)

## General Section - Browsing

browsing-title = 탐색
browsing-use-autoscroll =
    .label = 자동 스크롤 사용
    .accesskey = a
browsing-use-smooth-scrolling =
    .label = 부드러운 스크롤 사용
    .accesskey = m
browsing-use-onscreen-keyboard =
    .label = 필요하면 터치 키보드 보여주기
    .accesskey = k
browsing-use-cursor-navigation =
    .label = 커서 키를 항상 페이지 내에서 사용
    .accesskey = c
browsing-search-on-start-typing =
    .label = 타이핑을 시작하면 검색
    .accesskey = x
browsing-picture-in-picture-toggle-enabled =
    .label = 화면 속 화면 비디오 컨트롤 사용
    .accesskey = E
browsing-picture-in-picture-learn-more = 더 알아보기
browsing-media-control =
    .label = 키보드, 헤드셋 또는 가상 인터페이스를 통해 미디어 제어
    .accesskey = v
browsing-media-control-learn-more = 더 알아보기
browsing-cfr-recommendations =
    .label = 탐색시 확장 기능 추천
    .accesskey = R
browsing-cfr-features =
    .label = 탐색시 기능 추천
    .accesskey = f
browsing-cfr-recommendations-learn-more = 더 알아보기

## General Section - Proxy

network-settings-title = 네트워크 설정
network-proxy-connection-description = { -brand-short-name }가 인터넷에 접근하는 방법을 설정하세요.
network-proxy-connection-learn-more = 더 알아보기
network-proxy-connection-settings =
    .label = 설정…
    .accesskey = e

## Home Section

home-new-windows-tabs-header = 새 창과 탭
home-new-windows-tabs-description2 = 홈페이지, 새 창 및 새 탭을 열 때 표시되는 것을 선택하세요.

## Home Section - Home Page Customization

home-homepage-mode-label = 홈페이지와 새 창
home-newtabs-mode-label = 새 탭
home-restore-defaults =
    .label = 기본값으로 복원
    .accesskey = R
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Waterfox 홈 (기본값)
home-mode-choice-custom =
    .label = 사용자 지정 URL…
home-mode-choice-blank =
    .label = 빈 페이지
home-homepage-custom-url =
    .placeholder = URL 붙여넣기…
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] 현재 페이지
           *[other] 현재 탭
        }
    .accesskey = C
choose-bookmark =
    .label = 북마크 사용…
    .accesskey = B

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Waterfox 홈 콘텐츠
home-prefs-content-description = Waterfox 홈 화면에서 원하는 콘텐츠를 선택하세요.
home-prefs-search-header =
    .label = 웹 검색
home-prefs-topsites-header =
    .label = 상위 사이트
home-prefs-topsites-description = 가장 많이 방문한 사이트
home-prefs-topsites-by-option-sponsored =
    .label = 스폰서 상위 사이트
home-prefs-shortcuts-header =
    .label = 바로 가기
home-prefs-shortcuts-description = 저장하거나 방문한 사이트
home-prefs-shortcuts-by-option-sponsored =
    .label = 스폰서 바로 가기

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = { $provider } 추천
home-prefs-recommended-by-description-update = { $provider }에 의해 큐레이션된 웹의 뛰어난 콘텐츠
home-prefs-recommended-by-description-new = { -brand-product-name } 제품군의 일부인 { $provider }에서 선별한 뛰어난 콘텐츠

##

home-prefs-recommended-by-learn-more = 사용 방법
home-prefs-recommended-by-option-sponsored-stories =
    .label = 스폰서 소식
home-prefs-highlights-header =
    .label = 하이라이트
home-prefs-highlights-description = 저장하거나 방문한 사이트 모음
home-prefs-highlights-option-visited-pages =
    .label = 방문한 페이지
home-prefs-highlights-options-bookmarks =
    .label = 북마크
home-prefs-highlights-option-most-recent-download =
    .label = 가장 최근 다운로드
home-prefs-highlights-option-saved-to-pocket =
    .label = { -pocket-brand-name }에 저장된 페이지
home-prefs-recent-activity-header =
    .label = 최근 활동
home-prefs-recent-activity-description = 최근 사이트 및 콘텐츠 선택
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = 짧은 소식
home-prefs-snippets-description = { -vendor-short-name }와 { -brand-product-name }에 대한 업데이트
home-prefs-snippets-description-new = { -vendor-short-name }와 { -brand-product-name }의 팁 및 뉴스
home-prefs-sections-rows-option =
    .label = { $num } 행

## Search Section

search-bar-header = 검색 표시줄
search-bar-hidden =
    .label = 주소 표시줄을 사용하여 검색과 탐색
search-bar-shown =
    .label = 도구 모음에 검색 표시줄 추가
search-engine-default-header = 기본 검색 엔진
search-engine-default-desc-2 = 주소 표시줄과 검색 표시줄의 기본 검색 엔진입니다. 언제든지 바꿀 수 있습니다.
search-engine-default-private-desc-2 = 사생활 보호 창에서만 사용할 다른 기본 검색 엔진을 선택하세요
search-separate-default-engine =
    .label = 이 검색 엔진을 사생활 보호 창에서 사용
    .accesskey = U
search-suggestions-header = 검색 제안
search-suggestions-desc = 검색 엔진의 제안 사항 표시 방법을 선택하세요.
search-suggestions-option =
    .label = 검색 제안 사용
    .accesskey = s
search-show-suggestions-url-bar-option =
    .label = 주소 표시줄 결과에 검색 제안 표시
    .accesskey = l
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = 주소 표시줄 결과의 방문 기록 앞에 검색 제안 표시
search-show-suggestions-private-windows =
    .label = 사생활 보호 창에 검색 제안 표시
suggestions-addressbar-settings-generic = 다른 주소 표시줄 제안에 대한 설정 변경
suggestions-addressbar-settings-generic2 = 다른 주소 표시줄 제안에 대한 설정 변경
search-suggestions-cant-show = 방문 기록을 저장하지 않도록 { -brand-short-name }를 설정했기 때문에 검색 제안이 주소 표시 줄 결과에 표시되지 않습니다.
search-one-click-header = 원클릭 검색 엔진
search-one-click-header2 = 검색 바로 가기
search-one-click-desc = 키워드 입력을 시작했을 때 주소 표시줄과 검색 표시줄 아래에 나타날 대체 검색 엔진을 선택하세요.
search-choose-engine-column =
    .label = 검색 엔진
search-choose-keyword-column =
    .label = 키워드
search-restore-default =
    .label = 기본 검색 엔진 복원
    .accesskey = D
search-remove-engine =
    .label = 삭제
    .accesskey = R
search-add-engine =
    .label = 추가
    .accesskey = A
search-find-more-link = 더 많은 검색 엔진 찾기
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = 키워드 복사
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = "{ $name }"에서 이미 사용 중인 키워드를 선택했습니다. 다른 것을 선택하세요.
search-keyword-warning-bookmark = 북마크에서 이미 사용 중인 키워드를 선택했습니다. 다른 것을 선택하세요.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] 설정으로 돌아가기
           *[other] 설정으로 돌아가기
        }
containers-back-button2 =
    .aria-label = 설정으로 돌아가기
containers-header = 컨테이너 탭
containers-add-button =
    .label = 새 컨테이너 추가
    .accesskey = A
containers-new-tab-check =
    .label = 새 탭마다 컨테이너 선택
    .accesskey = S
containers-preferences-button =
    .label = 설정
containers-settings-button =
    .label = 설정
containers-remove-button =
    .label = 삭제

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = 웹과 함께 하세요.
sync-signedout-description = 북마크, 기록, 탭, 비밀번호, 부가 기능, 설정을 모든 기기에 걸쳐 동기화하세요.
sync-signedout-account-signin2 =
    .label = { -sync-brand-short-name }에 로그인…
    .accesskey = i
sync-signedout-description2 = 북마크, 기록, 탭, 비밀번호, 부가 기능, 설정을 모든 기기에 걸쳐 동기화하세요.
sync-signedout-account-signin3 =
    .label = Sync에 로그인…
    .accesskey = i
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = 모바일 기기와 동기화하기 위해서 <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> 또는 <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a>용 Firefox를 다운로드하세요.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = 프로필 사진 변경
sync-sign-out =
    .label = 로그아웃…
    .accesskey = g
sync-manage-account = 계정 관리
    .accesskey = o
sync-signedin-unverified = { $email } 은 아직 인증되지 않았습니다.
sync-signedin-login-failure = { $email }으로 다시 연결하려면 로그인하세요
sync-resend-verification =
    .label = 인증 메일 다시 보내기
    .accesskey = d
sync-remove-account =
    .label = 계정 삭제
    .accesskey = R
sync-sign-in =
    .label = 로그인
    .accesskey = g

## Sync section - enabling or disabling sync.

prefs-syncing-on = 동기화 : 켜짐
prefs-syncing-off = 동기화 : 꺼짐
prefs-sync-setup =
    .label = { -sync-brand-short-name } 설정…
    .accesskey = S
prefs-sync-offer-setup-label = 북마크, 기록, 탭, 비밀번호, 부가 기능 및 설정을 모든 기기에 걸쳐 동기화하세요.
prefs-sync-turn-on-syncing =
    .label = 동기화 켜기…
    .accesskey = s
prefs-sync-offer-setup-label2 = 북마크, 기록, 탭, 비밀번호, 부가 기능, 설정을 모든 기기에 걸쳐 동기화하세요.
prefs-sync-now =
    .labelnotsyncing = 지금 동기화
    .accesskeynotsyncing = N
    .labelsyncing = 동기화중…

## The list of things currently syncing.

sync-currently-syncing-heading = 현재 다음 항목을 동기화 중입니다:
sync-currently-syncing-bookmarks = 북마크
sync-currently-syncing-history = 기록
sync-currently-syncing-tabs = 열린 탭
sync-currently-syncing-logins-passwords = 로그인과 비밀번호
sync-currently-syncing-addresses = 주소
sync-currently-syncing-creditcards = 신용카드
sync-currently-syncing-addons = 부가 기능
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] 설정
       *[other] 설정
    }
sync-currently-syncing-settings = 설정
sync-change-options =
    .label = 변경…
    .accesskey = C

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = 동기화할 항목 선택
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = 변경 내용 저장
    .buttonaccesskeyaccept = S
    .buttonlabelextra2 = 연결 끊기…
    .buttonaccesskeyextra2 = D
sync-engine-bookmarks =
    .label = 북마크
    .accesskey = m
sync-engine-history =
    .label = 기록
    .accesskey = r
sync-engine-tabs =
    .label = 열린 탭
    .tooltiptext = 모든 동기화된 기기에서 열린 탭의 목록
    .accesskey = T
sync-engine-logins-passwords =
    .label = 로그인과 비밀번호
    .tooltiptext = 저장한 사용자 이름과 비밀번호
    .accesskey = L
sync-engine-addresses =
    .label = 주소
    .tooltiptext = 저장한 우편 주소(데스크탑)
    .accesskey = e
sync-engine-creditcards =
    .label = 신용카드
    .tooltiptext = 이름, 숫자 그리고 만료 날짜 (데스크톱만)
    .accesskey = C
sync-engine-addons =
    .label = 부가 기능
    .tooltiptext = Waterfox 데스크톱 용 확장 기능 및 테마
    .accesskey = A
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] 설정
           *[other] 환경 설정
        }
    .tooltiptext = 사용자가 변경한 일반, 개인 정보 및 보안 설정
    .accesskey = S
sync-engine-settings =
    .label = 설정
    .tooltiptext = 변경한 일반, 개인 정보 및 보안 설정
    .accesskey = s

## The device name controls.

sync-device-name-header = 기기 이름
sync-device-name-change =
    .label = 기기 이름 변경…
    .accesskey = h
sync-device-name-cancel =
    .label = 취소
    .accesskey = n
sync-device-name-save =
    .label = 저장
    .accesskey = v
sync-connect-another-device = 다른 기기 연결

## Privacy Section

privacy-header = 브라우저 개인 정보

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = 로그인과 비밀번호
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = 웹 사이트의 로그인과 비밀번호를 기억할지 묻기
    .accesskey = r
forms-exceptions =
    .label = 예외 목록…
    .accesskey = x
forms-generate-passwords =
    .label = 강력한 비밀번호 제안 및 생성
    .accesskey = u
forms-breach-alerts =
    .label = 유출된 웹 사이트의 비밀번호에 대한 경고 표시
    .accesskey = b
forms-breach-alerts-learn-more-link = 더 알아보기
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = 로그인과 비밀번호 자동 채우기
    .accesskey = i
forms-saved-logins =
    .label = 저장된 로그인…
    .accesskey = L
forms-master-pw-use =
    .label = 기본 비밀번호 사용
    .accesskey = U
forms-primary-pw-use =
    .label = 기본 비밀번호 사용
    .accesskey = U
forms-primary-pw-learn-more-link = 더 알아보기
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = 기본 비밀번호 변경…
    .accesskey = M
forms-master-pw-fips-title = 현재 FIPS 모드입니다. FIPS는 기본 비밀번호가 설정되어야 합니다.
forms-primary-pw-change =
    .label = 기본 비밀번호 변경…
    .accesskey = P
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = 현재 FIPS 모드입니다. FIPS는 기본 비밀번호가 설정되어야 합니다.
forms-master-pw-fips-desc = 비밀번호 변경 실패

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = 기본 비밀번호를 만들려면, Windows 로그인 자격 증명을 입력하세요. 이는 계정의 보안을 보호하는데 도움이 됩니다.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = 기본 비밀번호 만들기
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = 기본 비밀번호를 만들려면, Windows 로그인 자격 증명을 입력하세요. 이는 계정의 보안을 보호하는데 도움이 됩니다.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = 기본 비밀번호 만들기
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = 기록
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name }가
    .accesskey = w
history-remember-option-all =
    .label = 기록을 기억함
history-remember-option-never =
    .label = 기록을 기억 안 함
history-remember-option-custom =
    .label = 기록에 사용자 지정 설정 사용
history-remember-description = { -brand-short-name }가 방문, 다운로드, 양식 및 검색 기록을 기억합니다.
history-dontremember-description = { -brand-short-name }는 사생활 보호 모드와 같은 설정을 가지며, 웹 사이트 방문 중 어떤 기록도 기억하지 않습니다.
history-private-browsing-permanent =
    .label = 항상 사생활 보호 모드 사용
    .accesskey = p
history-remember-browser-option =
    .label = 방문 및 다운로드 기록 기억
    .accesskey = b
history-remember-search-option =
    .label = 검색 및 양식 기록 기억
    .accesskey = f
history-clear-on-close-option =
    .label = { -brand-short-name }를 닫을 때 기록 지우기
    .accesskey = r
history-clear-on-close-settings =
    .label = 설정…
    .accesskey = t
history-clear-button =
    .label = 기록 지우기…
    .accesskey = s

## Privacy Section - Site Data

sitedata-header = 쿠키 및 사이트 데이터
sitedata-total-size-calculating = 사이트 데이터와 캐시 크기 계산 중…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = 현재 저장된 쿠키, 사이트 데이터 및 캐시가 { $value } { $unit }의 디스크를 사용하고 있습니다.
sitedata-learn-more = 더 알아보기
sitedata-delete-on-close =
    .label = { -brand-short-name }를 닫을 때 쿠키와 사이트 데이터를 삭제
    .accesskey = c
sitedata-delete-on-close-private-browsing = 영구 사생활 보호 모드에서는 { -brand-short-name }를 닫으면 쿠키와 사이트 데이터가 항상 지워집니다.
sitedata-allow-cookies-option =
    .label = 쿠키와 사이트 데이터 허용
    .accesskey = A
sitedata-disallow-cookies-option =
    .label = 쿠키와 사이트 데이터 차단
    .accesskey = B
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = 차단 유형
    .accesskey = T
sitedata-option-block-cross-site-trackers =
    .label = 교차 사이트 추적기
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = 교차 사이트 및 소셜 미디어 추적기
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = 교차 사이트 추적 쿠키 — 소셜 미디어 쿠키 포함
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = 교차 사이트 쿠키 — 소셜 미디어 쿠키 포함
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = 교차 사이트 및 소셜 미디어 추적기, 그리고 나머지 쿠키 격리
sitedata-option-block-unvisited =
    .label = 방문하지 않은 웹 사이트의 쿠키
sitedata-option-block-all-third-party =
    .label = 모든 제3자 쿠키 (웹 사이트가 제대로 작동 안 할 수 있음)
sitedata-option-block-all =
    .label = 모든 쿠키 (웹 사이트가 제대로 작동 안하게 됨)
sitedata-clear =
    .label = 데이터 지우기…
    .accesskey = l
sitedata-settings =
    .label = 데이터 관리…
    .accesskey = M
sitedata-cookies-permissions =
    .label = 권한 관리…
    .accesskey = P
sitedata-cookies-exceptions =
    .label = 예외 관리…
    .accesskey = x

## Privacy Section - Address Bar

addressbar-header = 주소 표시줄
addressbar-suggest = 주소 표시줄 사용시 제안할 항목
addressbar-locbar-history-option =
    .label = 방문 기록
    .accesskey = H
addressbar-locbar-bookmarks-option =
    .label = 북마크
    .accesskey = k
addressbar-locbar-openpage-option =
    .label = 열린 탭
    .accesskey = O
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = 바로 가기
    .accesskey = S
addressbar-locbar-topsites-option =
    .label = 상위 사이트
    .accesskey = T
addressbar-locbar-engines-option =
    .label = 검색 엔진
    .accesskey = a
addressbar-suggestions-settings = 검색 엔진 제안 설정 변경

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = 향상된 추적 방지 기능
content-blocking-section-top-level-description = 추적기는 온라인에서 사용자를 따라다니며 탐색 습관과 관심사에 대한 정보를 수집합니다. { -brand-short-name }는 이러한 많은 추적기 및 기타 악성 스크립트를 차단합니다.
content-blocking-learn-more = 더 알아보기
content-blocking-fpi-incompatibility-warning = { -brand-short-name }의 일부 쿠키 설정을 재정의하는 자사 격리 (FPI)를 사용 중입니다.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = 표준
    .accesskey = d
enhanced-tracking-protection-setting-strict =
    .label = 엄격
    .accesskey = r
enhanced-tracking-protection-setting-custom =
    .label = 사용자 지정
    .accesskey = C

##

content-blocking-etp-standard-desc = 보호와 성능사이의 균형이 잡혀 있습니다. 페이지가 정상적으로 로드됩니다.
content-blocking-etp-strict-desc = 더 강력한 보호 기능을 제공하지만, 일부 사이트나 콘텐츠가 손상될 수 있습니다.
content-blocking-etp-custom-desc = 차단할 추적기와 스크립트를 선택하세요.
content-blocking-etp-blocking-desc = { -brand-short-name }가 다음을 차단함:
content-blocking-private-windows = 사생활 보호 창의 추적 콘텐츠
content-blocking-cross-site-cookies-in-all-windows = 모든 창에서 교차 사이트 쿠키 (추적 쿠키 포함)
content-blocking-cross-site-tracking-cookies = 교차 사이트 추적 쿠키
content-blocking-all-cross-site-cookies-private-windows = 사생활 보호 창에서 교차 사이트 쿠키
content-blocking-cross-site-tracking-cookies-plus-isolate = 교차 사이트 추적 쿠키, 그리고 나머지 쿠키 격리
content-blocking-social-media-trackers = 소셜 미디어 추적기
content-blocking-all-cookies = 모든 쿠키
content-blocking-unvisited-cookies = 방문하지 않은 사이트의 쿠키
content-blocking-all-windows-tracking-content = 모든 창의 추적 콘텐츠
content-blocking-all-third-party-cookies = 모든 제3자 쿠키
content-blocking-cryptominers = 암호화폐 채굴기
content-blocking-fingerprinters = 디지털 지문
content-blocking-warning-title = 주의하세요!
content-blocking-and-isolating-etp-warning-description = 추적기 차단 및 쿠키 격리는 일부 사이트의 기능에 영향을 줄 수 있습니다. 모든 콘텐츠를 로드하려면 추적기가 있는 페이지를 다시 로드하세요.
content-blocking-and-isolating-etp-warning-description-2 = 이 설정으로 인해 일부 웹 사이트가 콘텐츠를 표시하지 않거나 제대로 작동하지 않을 수 있습니다. 사이트가 손상된 것 같으면 해당 사이트에 대한 추적 방지 기능을 해제하여 모든 콘텐츠를 로드할 수 있습니다.
content-blocking-warning-learn-how = 방법 알아보기
content-blocking-reload-description = 변경 사항을 적용하려면 탭을 다시 로드해야 합니다.
content-blocking-reload-tabs-button =
    .label = 모든 탭 새로 고침
    .accesskey = R
content-blocking-tracking-content-label =
    .label = 추적 콘텐츠
    .accesskey = T
content-blocking-tracking-protection-option-all-windows =
    .label = 모든 창에서
    .accesskey = A
content-blocking-option-private =
    .label = 사생활 보호 창에서만
    .accesskey = P
content-blocking-tracking-protection-change-block-list = 차단 목록 변경
content-blocking-cookies-label =
    .label = 쿠키
    .accesskey = C
content-blocking-expand-section =
    .tooltiptext = 더 알아보기
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = 암호화폐 채굴기
    .accesskey = y
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = 디지털 지문
    .accesskey = F

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = 예외 관리…
    .accesskey = x

## Privacy Section - Permissions

permissions-header = 권한
permissions-location = 위치
permissions-location-settings =
    .label = 설정…
    .accesskey = l
permissions-xr = 가상 현실
permissions-xr-settings =
    .label = 설정…
    .accesskey = t
permissions-camera = 카메라
permissions-camera-settings =
    .label = 설정…
    .accesskey = c
permissions-microphone = 마이크
permissions-microphone-settings =
    .label = 설정…
    .accesskey = m
permissions-notification = 알림
permissions-notification-settings =
    .label = 설정…
    .accesskey = n
permissions-notification-link = 더 알아보기
permissions-notification-pause =
    .label = { -brand-short-name }가 다시 시작될 때까지 알림을 일시 중지
    .accesskey = n
permissions-autoplay = 자동 재생
permissions-autoplay-settings =
    .label = 설정…
    .accesskey = t
permissions-block-popups =
    .label = 팝업 창 차단
    .accesskey = B
permissions-block-popups-exceptions =
    .label = 예외 목록…
    .accesskey = E
permissions-addon-install-warning =
    .label = 웹 사이트가 부가 기능을 설치하려 할 때 경고
    .accesskey = W
permissions-addon-exceptions =
    .label = 예외 목록…
    .accesskey = E
permissions-a11y-privacy-checkbox =
    .label = 접근성 서비스가 브라우저에 접근하지 못하게 함
    .accesskey = a
permissions-a11y-privacy-link = 더 알아보기

## Privacy Section - Data Collection

collection-header = { -brand-short-name } 데이터 수집과 사용
collection-description = { -brand-short-name }를 모두를 위해 제공하고 개선하기 위해서 필요한 것만 수집하고 선택권을 제공하기 위해 노력합니다. 개인 정보를 전송하기 전에 항상 허가여부를 묻습니다.
collection-privacy-notice = 개인정보처리방침
collection-health-report-telemetry-disabled = { -vendor-short-name }에서 더 이상 기술 및 상호 작용 데이터를 캡처할 수 없습니다. 모든 과거 데이터는 30일 이내에 삭제됩니다.
collection-health-report-telemetry-disabled-link = 더 알아보기
collection-health-report =
    .label = { -brand-short-name }가 기술과 상호 작용 정보를 { -vendor-short-name }에 전송하도록 허용
    .accesskey = r
collection-health-report-link = 더 알아보기
collection-studies =
    .label = { -brand-short-name }가 연구를 설치하고 실행하도록 허용
collection-studies-link = { -brand-short-name } 연구 보기
addon-recommendations =
    .label = { -brand-short-name }가 개인화된 확장 기능 추천을 하도록 허용
addon-recommendations-link = 더 알아보기
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = 이 빌드 설정에서는 데이터 보고가 비활성화 되어 있음
collection-backlogged-crash-reports =
    .label = { -brand-short-name }가 사용자를 대신하여 백로그된 충돌 보고서를 보내도록 허용
    .accesskey = c
collection-backlogged-crash-reports-link = 더 알아보기
collection-backlogged-crash-reports-with-link = { -brand-short-name }가 사용자를 대신하여 백로그된 충돌 보고서를 보내도록 허용 <a data-l10n-name="crash-reports-link">더 알아보기</a>
    .accesskey = c

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = 보안
security-browsing-protection = 사기성 콘텐츠 및 위험한 소프트웨어 보호
security-enable-safe-browsing =
    .label = 위험하고 사기성 있는 콘텐츠 차단
    .accesskey = B
security-enable-safe-browsing-link = 더 알아보기
security-block-downloads =
    .label = 위험한 다운로드 차단
    .accesskey = D
security-block-uncommon-software =
    .label = 원치 않거나 일반적이지 않은 소프트웨어에 대해 알림
    .accesskey = C

## Privacy Section - Certificates

certs-header = 인증서
certs-personal-label = 서버가 인증 정보를 요구할 때
certs-select-auto-option =
    .label = 자동으로 하나를 선택
    .accesskey = S
certs-select-ask-option =
    .label = 항상 물어보기
    .accesskey = A
certs-enable-ocsp =
    .label = 인증서의 현재 유효성을 확인하기 위해 OCSP 응답기 서버에 쿼리
    .accesskey = Q
certs-view =
    .label = 인증서 보기…
    .accesskey = C
certs-devices =
    .label = 보안 장치…
    .accesskey = D
space-alert-learn-more-button =
    .label = 더 알아보기
    .accesskey = L
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] 옵션 열기
           *[other] 설정 열기
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] O
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] { -brand-short-name } 디스크 용량이 부족합니다. 웹 사이트 내용이 제대로 표시되지 않을 수 있습니다. 설정 > 개인 정보 및 보안 > 쿠키 및 사이트 데이터에서 저장된 데이터를 지울 수 있습니다.
       *[other] { -brand-short-name } 디스크 용량이 부족합니다. 웹 사이트 내용이 제대로 표시되지 않을 수 있습니다. 설정 > 개인 정보 및 보안 > 쿠키 및 사이트 데이터에서 저장된 데이터를 지울 수 있습니다.
    }
space-alert-under-5gb-ok-button =
    .label = 확인
    .accesskey = K
space-alert-under-5gb-message = { -brand-short-name } 디스크 용량이 부족합니다. 웹 사이트 내용이 제대로 표시되지 않을 수 있습니다. 더 나은 인터넷 경험을 위해 디스크 용량을 최적화하는 방법을 알아보려면 “더 알아보기”를 방문하세요.
space-alert-over-5gb-settings-button =
    .label = 설정 열기
    .accesskey = O
space-alert-over-5gb-message2 = <strong>{ -brand-short-name } 디스크 용량이 부족합니다.</strong> 웹 사이트 내용이 제대로 표시되지 않을 수 있습니다. 설정 > 개인 정보 및 보안 > 쿠키 및 사이트 데이터에서 저장된 데이터를 지울 수 있습니다.
space-alert-under-5gb-message2 = <strong>{ -brand-short-name } 디스크 용량이 부족합니다.</strong> 웹 사이트 내용이 제대로 표시되지 않을 수 있습니다. 더 나은 인터넷 경험을 위해 디스크 용량을 최적화하는 방법을 알아보려면 “더 알아보기”를 방문하세요.

## Privacy Section - HTTPS-Only

httpsonly-header = HTTPS 전용 모드
httpsonly-description = HTTPS는 { -brand-short-name }와 사용자가 방문한 웹 사이트 간에 안전한 암호화된 연결을 제공합니다. 대부분의 웹 사이트는 HTTPS를 지원하며, HTTPS 전용 모드를 사용하도록 설정한 경우 { -brand-short-name }는 모든 연결을 HTTPS로 업그레이드합니다.
httpsonly-learn-more = 더 알아보기
httpsonly-radio-enabled =
    .label = 모든 창에서 HTTPS 전용 모드 사용
httpsonly-radio-enabled-pbm =
    .label = 사생활 보호 창에서만 HTTPS 전용 모드 사용
httpsonly-radio-disabled =
    .label = HTTPS 전용 모드 사용 안 함

## The following strings are used in the Download section of settings

desktop-folder-name = 바탕 화면
downloads-folder-name = 다운로드
choose-download-folder-title = 다운로드 폴더 선택:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = { $service-name }에 파일 저장
