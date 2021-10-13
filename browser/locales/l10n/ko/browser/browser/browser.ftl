# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - Waterfox
# private - "Waterfox Waterfox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (사생활 보호 모드)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (사생활 보호 모드)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - Waterfox
# "private" - "Waterfox Waterfox — (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } - (사생활 보호 모드)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (사생활 보호 모드)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = 사이트 정보 보기

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = 설치 메시지 패널 열기
urlbar-web-notification-anchor =
    .tooltiptext = 사이트의 알림을 받을지 여부 변경
urlbar-midi-notification-anchor =
    .tooltiptext = MIDI 패널 열기
urlbar-eme-notification-anchor =
    .tooltiptext = DRM 소프트웨어 사용 관리
urlbar-web-authn-anchor =
    .tooltiptext = 웹 인증 패널 열기
urlbar-canvas-notification-anchor =
    .tooltiptext = 캔버스 추출 권한 관리
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = 사이트의 마이크 공유 관리
urlbar-default-notification-anchor =
    .tooltiptext = 메시지 패널 열기
urlbar-geolocation-notification-anchor =
    .tooltiptext = 위치 요청 패널 열기
urlbar-xr-notification-anchor =
    .tooltiptext = 가상 현실 권한 패널 열기
urlbar-storage-access-anchor =
    .tooltiptext = 탐색 활동 권한 패널 열기
urlbar-translate-notification-anchor =
    .tooltiptext = 페이지 번역
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = 사이트의 창 또는 화면 공유 관리
urlbar-indexed-db-notification-anchor =
    .tooltiptext = 오프라인 저장소 메시지 패널 열기
urlbar-password-notification-anchor =
    .tooltiptext = 저장된 비밀번호 메시지 패널 열기
urlbar-translated-notification-anchor =
    .tooltiptext = 페이지 번역 관리
urlbar-plugins-notification-anchor =
    .tooltiptext = 플러그인 사용 관리
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = 사이트의 카메라와 마이크 공유 관리
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = 사이트의 다른 스피커 공유 관리
urlbar-autoplay-notification-anchor =
    .tooltiptext = 자동 재생 패널 열기
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = 영구 저장소에 데이터를 저장
urlbar-addons-notification-anchor =
    .tooltiptext = 부가 기능 설치 메시지 패널 열기
urlbar-tip-help-icon =
    .title = 도움 받기
urlbar-search-tips-confirm = 확인
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = 팁:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = 입력은 더 적게하고 더 많이 찾기: 주소 표시줄에서 바로 { $engineName } 검색해 보세요.
urlbar-search-tips-redirect-2 = 주소 표시줄에서 검색을 시작하여 { $engineName }의 제안 및 방문 기록을 확인하세요.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = 더 빨리 찾으려면 여기에서 하세요.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = 북마크
urlbar-search-mode-tabs = 탭
urlbar-search-mode-history = 기록

##

urlbar-geolocation-blocked =
    .tooltiptext = 이 사이트의 위치 정보 사용을 차단하였습니다.
urlbar-xr-blocked =
    .tooltiptext = 이 웹 사이트에 대한 가상 현실 기기 접근을 차단했습니다.
urlbar-web-notifications-blocked =
    .tooltiptext = 이 사이트의 알림 사용을 차단하였습니다.
urlbar-camera-blocked =
    .tooltiptext = 이 사이트의 카메라 사용을 차단하였습니다.
urlbar-microphone-blocked =
    .tooltiptext = 이 사이트의 마이크 사용을 차단하였습니다.
urlbar-screen-blocked =
    .tooltiptext = 이 사이트의 화면 공유를 차단하였습니다.
urlbar-persistent-storage-blocked =
    .tooltiptext = 이 사이트의 영구 저장소 사용을 차단하였습니다.
urlbar-popup-blocked =
    .tooltiptext = 이 사이트의 팝업을 차단하였습니다.
urlbar-autoplay-media-blocked =
    .tooltiptext = 이 사이트의 소리있는 미디어 자동 재생을 차단하였습니다.
urlbar-canvas-blocked =
    .tooltiptext = 이 사이트의 캔버스 데이터 추출을 차단하였습니다.
urlbar-midi-blocked =
    .tooltiptext = 이 사이트의 MIDI 접근을 차단하였습니다.
urlbar-install-blocked =
    .tooltiptext = 이 사이트의 부가 기능 설치를 차단했습니다.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = 북마크 편집 ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = 이 페이지 북마크 ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension =
    .label = 확장 기능 관리…
page-action-remove-extension =
    .label = 확장 기능 제거

## Auto-hide Context Menu

full-screen-autohide =
    .label = 도구 모음 닫기
    .accesskey = H
full-screen-exit =
    .label = 전체 화면 종료
    .accesskey = F

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = 이번만 검색:
search-one-offs-change-settings-compact-button =
    .tooltiptext = 검색 설정 변경
search-one-offs-context-open-new-tab =
    .label = 새 탭에 검색
    .accesskey = T
search-one-offs-context-set-as-default =
    .label = 기본 검색 엔진으로 설정
    .accesskey = D
search-one-offs-context-set-as-default-private =
    .label = 사생활 보호 창의 기본 검색 엔진으로 설정
    .accesskey = P
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = “{ $engineName }” 추가
    .tooltiptext = “{ $engineName }” 검색 엔진 추가
    .aria-label = “{ $engineName }” 검색 엔진 추가
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = 검색 엔진 추가

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = 북마크 ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = 탭 ({ $restrict })
search-one-offs-history =
    .tooltiptext = 기록 ({ $restrict })

## Bookmark Panel

bookmarks-add-bookmark = 북마크 추가
bookmarks-edit-bookmark = 북마크 편집
bookmark-panel-cancel =
    .label = 취소
    .accesskey = C
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label = 북마크 { $count }개 삭제
    .accesskey = R
bookmark-panel-show-editor-checkbox =
    .label = 저장할 때 편집기 표시
    .accesskey = S
bookmark-panel-save-button =
    .label = 저장
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = { $host } 사이트 정보
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = { $host }에 대한 연결 보안
identity-connection-not-secure = 안전하지 않은 연결
identity-connection-secure = 안전한 연결
identity-connection-failure = 연결 실패
identity-connection-internal = 안전한 { -brand-short-name } 페이지입니다.
identity-connection-file = 이 페이지는 컴퓨터에 저장되어 있습니다.
identity-extension-page = 이 페이지는 확장 기능으로부터 로드되었습니다.
identity-active-blocked = { -brand-short-name }가 안전하지 않은 페이지의 일부를 차단했습니다.
identity-custom-root = Waterfox에서 인식하지 못하는 인증서 발급자가 연결을 확인했습니다.
identity-passive-loaded = 페이지의 일부(이미지 등)가 안전하지 않습니다.
identity-active-loaded = 이 페이지에서 보호를 비활성화하셨습니다.
identity-weak-encryption = 이 페이지는 약한 암호화를 사용합니다.
identity-insecure-login-forms = 이 페이지에 입력된 로그인 정보는 노출될 수 있습니다.
identity-https-only-connection-upgraded = (HTTPS로 업그레이드됨)
identity-https-only-label = HTTPS 전용 모드
identity-https-only-dropdown-on =
    .label = 켜기
identity-https-only-dropdown-off =
    .label = 끄기
identity-https-only-dropdown-off-temporarily =
    .label = 일시적으로 끄기
identity-https-only-info-turn-on2 = { -brand-short-name }가 가능한 경우 연결을 업그레이드하도록 하려면 이 사이트에 대해 HTTPS 전용 모드를 켜세요.
identity-https-only-info-turn-off2 = 페이지가 손상된 것 같으면 이 사이트가 안전하지 않은 HTTP를 사용하여 다시 로드되도록 HTTPS 전용 모드를 끌 수 있습니다.
identity-https-only-info-no-upgrade = HTTP에서 연결을 업그레이드할 수 없습니다.
identity-permissions-storage-access-header = 교차 사이트 쿠키
identity-permissions-storage-access-hint = 이 당사자는 사용자가 이 사이트에 있는 동안 교차 사이트 쿠키 및 사이트 데이터를 사용할 수 있습니다.
identity-permissions-storage-access-learn-more = 더 알아보기
identity-permissions-reload-hint = 변경 사항을 적용하려면 페이지를 다시 로드해야할 수도 있습니다.
identity-clear-site-data =
    .label = 쿠키 및 사이트 데이터 지우기…
identity-connection-not-secure-security-view = 이 사이트에 안전하게 연결되어 있지 않습니다.
identity-connection-verified = 이 사이트에 안전하게 연결되어 있습니다.
identity-ev-owner-label = 인증서 발급 대상:
identity-description-custom-root = Waterfox는 이 인증서 발급자를 인식하지 못합니다. 운영 체제 또는 관리자가 추가한 것일 수 있습니다. <label data-l10n-name="link">더 알아보기</label>
identity-remove-cert-exception =
    .label = 예외 제거
    .accesskey = R
identity-description-insecure = 이 사이트의 연결이 보호되지 않습니다. 전송하는 정보(비밀번호, 메시지, 신용 카드 번호 등)를 다른사람이 볼 수 있습니다.
identity-description-insecure-login-forms = 이 페이지에 입력한 로그인 정보는 안전하지 않고 손상될 수 있습니다.
identity-description-weak-cipher-intro = 이 사이트의 연결이 약한 암호화를 사용하고 있어서 보호되지 않습니다.
identity-description-weak-cipher-risk = 다른 사람이 정보를 보거나 웹 사이트의 동작을 바꿀 수 있습니다.
identity-description-active-blocked = { -brand-short-name }가 안전하지 않은 페이지의 일부분을 차단했습니다. <label data-l10n-name="link">더 알아보기</label>
identity-description-passive-loaded = 연결이 안전하지 않아서 사용자가 공유하는 정보를 다른 사람이 볼 수 있습니다.
identity-description-passive-loaded-insecure = 이 웹 사이트는 안전하지 않은 콘텐츠(이미지 등)을 포함하고 있습니다. <label data-l10n-name="link">더 알아보기</label>
identity-description-passive-loaded-mixed = { -brand-short-name }가 일부 콘텐츠를 차단했지만 아직 안전하지 않은 콘텐츠(이미지 등)가 있습니다. <label data-l10n-name="link">더 알아보기</label>
identity-description-active-loaded = 이 웹 사이트는 안전하지 않은 콘텐츠(스크립트 등)를 포함하고 있고 사용자의 연결이 보호되지 않습니다.
identity-description-active-loaded-insecure = 이 사이트에 공유하는 정보(비밀번호, 메시지, 신용 카드 번호 등)를 다른사람이 볼 수 있습니다.
identity-learn-more =
    .value = 더 알아보기
identity-disable-mixed-content-blocking =
    .label = 지금부터 보호 끄기
    .accesskey = D
identity-enable-mixed-content-blocking =
    .label = 보호 켜기
    .accesskey = E
identity-more-info-link-text =
    .label = 자세한 정보

## Window controls

browser-window-minimize-button =
    .tooltiptext = 최소화
browser-window-maximize-button =
    .tooltiptext = 최대화
browser-window-restore-down-button =
    .tooltiptext = 이전 크기로 복원
browser-window-close-button =
    .tooltiptext = 닫기

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = 재생 중
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = 음소거됨
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = 자동 재생 차단됨
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = 화면 속 화면

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [1] 탭 음소거
       *[other] 탭 { $count }개 음소거
    }
browser-tab-unmute =
    { $count ->
        [1] 탭 음소거 해제
       *[other] 탭 { $count }개 음소거 해제
    }
browser-tab-unblock =
    { $count ->
        [1] 탭 재생
       *[other] 탭 { $count }개 재생
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = 북마크 가져오기…
    .tooltiptext = 다른 브라우저에서 { -brand-short-name }로 북마크를 가져옵니다.
bookmarks-toolbar-empty-message = 빠르게 접근하려면, 여기 북마크 도구 모음에 북마크를 놓으세요. <a data-l10n-name="manage-bookmarks">북마크 관리…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = 카메라:
    .accesskey = C
popup-select-camera-icon =
    .tooltiptext = 카메라
popup-select-microphone-device =
    .value = 마이크:
    .accesskey = M
popup-select-microphone-icon =
    .tooltiptext = 마이크
popup-select-speaker-icon =
    .tooltiptext = 스피커
popup-all-windows-shared = 화면에 표시되어 있는 모든 창을 공유합니다.
popup-screen-sharing-block =
    .label = 차단
    .accesskey = B
popup-screen-sharing-always-block =
    .label = 항상 차단
    .accesskey = w
popup-mute-notifications-checkbox = 공유하는 동안 웹 사이트 알림 음소거

## WebRTC window or screen share tab switch warning

sharing-warning-window = { -brand-short-name }를 공유하고 있습니다. 새 탭으로 전환하면 다른 사람들이 볼 수 있습니다.
sharing-warning-screen = 전체 화면을 공유하고 있습니다. 새 탭으로 전환하면 다른 사람들이 볼 수 있습니다.
sharing-warning-proceed-to-tab =
    .label = 탭으로 진행
sharing-warning-disable-for-session =
    .label = 이 세션의 공유 보호 사용 안 함

## DevTools F12 popup

enable-devtools-popup-description = F12 단축키를 사용하려면, 먼저 웹 개발자 메뉴를 통해 DevTools를 여세요.

## URL Bar

# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = 검색어 또는 주소 입력
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = 웹 검색
    .aria-label = { $name } 검색
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = 검색어 입력
    .aria-label = { $name } 검색
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = 검색어 입력
    .aria-label = 북마크 검색
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = 검색어 입력
    .aria-label = 방문 기록 검색
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = 검색어 입력
    .aria-label = 탭 검색
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = { $name } 검색 또는 주소 입력
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = 브라우저가 원격 제어 중입니다 (이유: { $component })
urlbar-permissions-granted =
    .tooltiptext = 이 웹 사이트에 추가 권한을 부여했습니다.
urlbar-switch-to-tab =
    .value = 탭 전환:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = 확장 기능:
urlbar-go-button =
    .tooltiptext = 주소 표시줄의 주소로 이동
urlbar-page-action-button =
    .tooltiptext = 페이지 작업

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = 사생활 보호 창에서 { $engine } 검색
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = 사생활 보호 창에서 검색
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = { $engine } 검색
urlbar-result-action-sponsored = 스폰서
urlbar-result-action-switch-tab = 탭 전환
urlbar-result-action-visit = 방문
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = { $engine } 검색하려면 Tab 키를 누르세요
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = { $engine } 검색하려면 Tab 키를 누르세요
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = 주소 표시줄에서 직접 { $engine } 검색
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = 주소 표시줄에서 직접 { $engine } 검색
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = 복사
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = 북마크 검색
urlbar-result-action-search-history = 기록 검색
urlbar-result-action-search-tabs = 탭 검색

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = { $engine } 제안

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> 사이트가 전체 화면 모드입니다
fullscreen-warning-no-domain = 이 문서는 전체 화면 모드입니다
fullscreen-exit-button = 전체 화면 종료 (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = 전체 화면 종료 (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> 사이트가 포인터를 제어하려 합니다. 다시 제어하려면 ESC 키를 누르세요.
pointerlock-warning-no-domain = 이 문서가 포인터를 제어하려 합니다. 다시 제어하려면 ESC 키를 누르세요.

## Subframe crash notification

crashed-subframe-message = <strong>이 페이지의 일부가 손상되었습니다.</strong> { -brand-product-name }에게 이 문제를 알리고 더 빨리 해결하려면 보고서를 제출하세요.
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = 이 페이지의 일부가 손상되었습니다.{ -brand-product-name }에게 이 문제를 알리고 더 빨리 해결하려면 보고서를 제출하세요.
crashed-subframe-learnmore-link =
    .value = 더 알아보기
crashed-subframe-submit =
    .label = 보고서 제출
    .accesskey = S

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = 북마크 관리
bookmarks-recent-bookmarks-panel-subheader = 최근 북마크
bookmarks-toolbar-chevron =
    .tooltiptext = 북마크 더보기
bookmarks-sidebar-content =
    .aria-label = 북마크
bookmarks-menu-button =
    .label = 북마크 메뉴
bookmarks-other-bookmarks-menu =
    .label = 기타 북마크
bookmarks-mobile-bookmarks-menu =
    .label = 모바일 북마크
bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] 북마크 탐색창 숨기기
           *[other] 북마크 탐색창 보기
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] 북마크 도구 모음 숨기기
           *[other] 북마크 도구 모음 표시
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] 북마크 도구 모음 숨기기
           *[other] 북마크 도구 모음 표시
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] 도구 모음에서 북마크 메뉴 제거
           *[other] 도구 모음에 북마크 메뉴 추가
        }
bookmarks-search =
    .label = 북마크 검색
bookmarks-tools =
    .label = 북마크 도구
bookmarks-bookmark-edit-panel =
    .label = 이 북마크 편집
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = 북마크 도구 모음
    .accesskey = B
    .aria-label = 북마크
bookmarks-toolbar-menu =
    .label = 북마크 도구 모음
bookmarks-toolbar-placeholder =
    .title = 북마크 도구 모음 항목
bookmarks-toolbar-placeholder-button =
    .label = 북마크 도구 모음 항목
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-current-tab =
    .label = 현재 탭 북마크

## Library Panel items

library-bookmarks-menu =
    .label = 북마크
library-recent-activity-title =
    .value = 최근 활동

## Pocket toolbar button

save-to-pocket-button =
    .label = { -pocket-brand-name }에 저장
    .tooltiptext = { -pocket-brand-name }에 저장

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = 텍스트 인코딩 복구
    .tooltiptext = 페이지 콘텐츠에서 올바른 텍스트 인코딩 추측

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = 부가 기능 및 테마
    .tooltiptext = 부가 기능 및 테마 관리 ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = 설정
    .tooltiptext =
        { PLATFORM() ->
            [macos] 설정 열기 ({ $shortcut })
           *[other] 설정 열기
        }

## More items

more-menu-go-offline =
    .label = 오프라인으로 작업
    .accesskey = w
toolbar-overflow-customize-button =
    .label = 도구 모음 사용자 지정…
    .accesskey = C
toolbar-button-email-link =
    .label = 메일로 링크 보내기
    .tooltiptext = 메일로 이 페이지의 링크 보내기
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = 페이지 저장
    .tooltiptext = 이 페이지 저장 ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = 파일 열기
    .tooltiptext = 파일 열기 ({ $shortcut })
toolbar-button-synced-tabs =
    .label = 동기화된 탭
    .tooltiptext = 다른 기기의 탭 보기
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = 새 사생활 보호 창
    .tooltiptext = 새 사생활 보호 창 열기 ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = 이 사이트의 일부 오디오 또는 비디오는 DRM 소프트웨어를 사용하므로 { -brand-short-name }에서 수행할 수 있는 작업이 제한될 수 있습니다.
eme-notifications-drm-content-playing-manage = 설정 관리
eme-notifications-drm-content-playing-manage-accesskey = M
eme-notifications-drm-content-playing-dismiss = 닫기
eme-notifications-drm-content-playing-dismiss-accesskey = D

## Password save/update panel

panel-save-update-username = 사용자 이름
panel-save-update-password = 비밀번호

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = { $name } 부가 기능을 제거하시겠습니까?
addon-removal-abuse-report-checkbox = 이 확장 기능을 { -vendor-short-name }에 신고

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = 계정 관리
remote-tabs-sync-now = 지금 동기화

##

# "More" item in macOS share menu
menu-share-more =
    .label = 더보기…
ui-tour-info-panel-close =
    .tooltiptext = 닫기

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = { $uriHost }의 팝업 허용
    .accesskey = p
popups-infobar-block =
    .label = { $uriHost }의 팝업 차단
    .accesskey = p

##

popups-infobar-dont-show-message =
    .label = 팝업이 차단될 때 이 메시지를 표시하지 않음
    .accesskey = D
edit-popup-settings =
    .label = 팝업 설정 관리…
    .accesskey = M
picture-in-picture-hide-toggle =
    .label = 화면 속 화면 토글 숨기기
    .accesskey = H

# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = 탐색
navbar-downloads =
    .label = 다운로드
navbar-overflow =
    .tooltiptext = 도구 더보기…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = 인쇄
    .tooltiptext = 이 페이지 인쇄… ({ $shortcut })
navbar-print-tab-modal-disabled =
    .label = 인쇄
    .tooltiptext = 이 페이지 인쇄
navbar-home =
    .label = 홈
    .tooltiptext = { -brand-short-name } 홈 페이지
navbar-library =
    .label = 라이브러리
    .tooltiptext = 기록, 저장된 북마크 등 보기
navbar-search =
    .title = 검색
navbar-accessibility-indicator =
    .tooltiptext = 접근성 기능 활성화됨
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = 브라우저 탭
tabs-toolbar-new-tab =
    .label = 새 탭
tabs-toolbar-list-all-tabs =
    .label = 탭 전체 목록
    .tooltiptext = 탭 전체 목록

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>이전 탭을 여시겠습니까?</strong> { -brand-short-name } 애플리케이션 메뉴 <img data-l10n-name="icon"/>의 기록 아래에서 이전 세션을 복원할 수 있습니다.
restore-session-startup-suggestion-button = 사용법 보기
