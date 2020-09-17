# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
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
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
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
    .tooltiptext = 캔바스 추출 권한 관리
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = 사이트에서 마이크를 사용할지 관리
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
    .tooltiptext = 사이트에서 창이나 화면을 공유할지를 관리
urlbar-indexed-db-notification-anchor =
    .tooltiptext = 오프라인 저장소 메시지 패널 열기
urlbar-password-notification-anchor =
    .tooltiptext = 저장된 비밀번호 메시지 패널 열기
urlbar-translated-notification-anchor =
    .tooltiptext = 페이지 번역 관리
urlbar-plugins-notification-anchor =
    .tooltiptext = 플러그인 사용 관리
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = 사이트에서 카메라와 마이크를 사용할지 관리
urlbar-autoplay-notification-anchor =
    .tooltiptext = 자동재생 패널 열기
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

urlbar-search-tips-onboard = 적게 입력, 많이 찾기: 주소 표시줄에서 바로 { $engineName } 검색어로 검색해 보세요.
urlbar-search-tips-redirect-2 = 주소 표시줄에서 검색을 시작하여 { $engineName }의 제안 및 방문 기록을 확인하세요.

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
    .tooltiptext = 이 사이트의 소리있는 미디어 자동재생을 차단하였습니다.
urlbar-canvas-blocked =
    .tooltiptext = 이 사이트의 캔바스 데이터 추출을 차단하였습니다.
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

page-action-add-to-urlbar =
    .label = 주소 표시줄에 추가
page-action-manage-extension =
    .label = 확장 기능 관리…
page-action-remove-from-urlbar =
    .label = 주소 표시줄에서 제거
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

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = 이번만 검색:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = 검색 설정 변경
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

bookmark-panel-show-editor-checkbox =
    .label = 저장할 때 편집기 표시
    .accesskey = S
bookmark-panel-done-button =
    .label = 완료
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = 안전하지 않은 연결
identity-connection-secure = 안전한 연결
identity-connection-internal = 안전한 { -brand-short-name } 페이지입니다.
identity-connection-file = 이 페이지는 컴퓨터에 저장되어 있습니다.
identity-extension-page = 이 페이지는 확장 기능으로부터 로드되었습니다.
identity-active-blocked = { -brand-short-name }가 안전하지 않은 페이지의 일부를 차단했습니다.
identity-custom-root = Mozilla에서 인식하지 못하는 인증서 발급자가 연결을 확인했습니다.
identity-passive-loaded = 페이지의 일부(이미지 등)가 안전하지 않습니다.
identity-active-loaded = 이 페이지에서 보호를 비활성화하셨습니다.
identity-weak-encryption = 이 페이지는 약한 암호화를 사용합니다.
identity-insecure-login-forms = 이 페이지에 입력된 로그인 정보는 노출될 수 있습니다.
identity-permissions =
    .value = 권한
identity-permissions-reload-hint = 변경 사항을 적용하려면 페이지를 다시 로드해야할 수도 있습니다.
identity-permissions-empty = 이 사이트를 특별한 권한으로 승인하지 않았습니다.
identity-clear-site-data =
    .label = 쿠키 및 사이트 데이터 지우기…
identity-connection-not-secure-security-view = 이 사이트에 안전하게 연결되어 있지 않습니다.
identity-connection-verified = 이 사이트에 안전하게 연결되어 있습니다.
identity-ev-owner-label = 인증서 발급 대상:
identity-description-custom-root = Mozilla는 이 인증서 발급자를 인식하지 못합니다. 운영 체제 또는 관리자가 추가한 것일 수 있습니다. <label data-l10n-name="link">더 알아보기</label>
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

## WebRTC Pop-up notifications

popup-select-camera =
    .value = 공유할 카메라:
    .accesskey = C
popup-select-microphone =
    .value = 공유할 마이크:
    .accesskey = M
popup-all-windows-shared = 화면에 표시되어 있는 모든 창을 공유합니다.
popup-screen-sharing-not-now =
    .label = 나중에
    .accesskey = w
popup-screen-sharing-never =
    .label = 허용 안 함
    .accesskey = N
popup-silence-notifications-checkbox = 공유하는 동안 { -brand-short-name }에서 알림을 사용 안 함
popup-silence-notifications-checkbox-warning = { -brand-short-name }는 공유하는 동안 알림을 표시하지 않습니다.

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

urlbar-default-placeholder =
    .defaultPlaceholder = 검색어 또는 주소 입력
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
urlbar-remote-control-notification-anchor =
    .tooltiptext = 브라우저가 원격 제어중
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
urlbar-pocket-button =
    .tooltiptext = { -pocket-brand-name }에 저장

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> 이 전체 화면 모드입니다
fullscreen-warning-no-domain = 이 문서는 전체 화면 모드입니다
fullscreen-exit-button = 전체 화면 종료 (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = 전체 화면 종료 (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> 사이트가 포인터를 제어하려 합니다. 다시 제어하려면 ESC 키를 누르세요.
pointerlock-warning-no-domain = 이 문서가 포인터를 제어하려 합니다. 다시 제어하려면 ESC 키를 누르세요.
