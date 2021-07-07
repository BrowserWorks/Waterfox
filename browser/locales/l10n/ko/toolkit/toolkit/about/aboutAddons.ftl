# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = 부가 기능 관리자
addons-page-title = 부가 기능 관리자
search-header =
    .placeholder = addons.mozilla.org 검색
    .searchbuttonlabel = 검색
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = <a data-l10n-name="get-extensions">{ $domain }</a>에서 확장 기능 및 테마 받기
list-empty-installed =
    .value = 설치한 부가 기능이 없음
list-empty-available-updates =
    .value = 업데이트 없음
list-empty-recent-updates =
    .value = 부가 기능에 대한 업데이트가 없습니다.
list-empty-find-updates =
    .label = 업데이트 확인
list-empty-button =
    .label = 부가 기능 더 알아보기
help-button = 부가 기능 지원
sidebar-help-button-title =
    .title = 부가 기능 지원
preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } 설정
       *[other] { -brand-short-name } 설정
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } 설정
           *[other] { -brand-short-name } 설정
        }
addons-settings-button = { -brand-short-name } 설정
sidebar-settings-button-title =
    .title = { -brand-short-name } 설정
show-unsigned-extensions-button =
    .label = 몇몇 확장 기능은 확인을 할 수 없음
show-all-extensions-button =
    .label = 모든 확장 기능 보기
cmd-show-details =
    .label = 자세히 보기
    .accesskey = S
cmd-find-updates =
    .label = 업데이트 찾기
    .accesskey = F
cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] 설정
           *[other] 환경 설정
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
cmd-enable-theme =
    .label = 테마 적용
    .accesskey = W
cmd-disable-theme =
    .label = 테마 적용 중지
    .accesskey = W
cmd-install-addon =
    .label = 설치
    .accesskey = I
cmd-contribute =
    .label = 기여하기
    .accesskey = C
    .tooltiptext = 이 부가 기능의 개발에 기여하기
detail-version =
    .label = 버전
detail-last-updated =
    .label = 마지막 업데이트
detail-contributions-description = 이 부가 기능의 개발자가 여러분이 작은 기여로 지속적인 개발을 지원해 줄 것을 요청합니다.
detail-contributions-button = 기여하기
    .title = 이 부가 기능의 개발에 기여하기
    .accesskey = C
detail-update-type =
    .value = 자동 업데이트
detail-update-default =
    .label = 기본 설정
    .tooltiptext = 기본으로 업데이트를 자동으로 설치
detail-update-automatic =
    .label = 사용
    .tooltiptext = 업데이트 자동 설치 설정
detail-update-manual =
    .label = 중단
    .tooltiptext = 업데이트 자동 설치 중단
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = 사생활 보호 창에서 실행
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = 사생활 보호 창에서 허용 안 됨
detail-private-disallowed-description2 = 이 확장 기능은 사생활 보호 모드에서는 실행되지 않습니다. <a data-l10n-name="learn-more">더 알아보기</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = 사생활 보호 창에 대한 접근 필요
detail-private-required-description2 = 이 확장 기능은 사생활 보호 모드에서 온라인 활동에 접근 할 수 있습니다. <a data-l10n-name="learn-more">더 알아보기</a>
detail-private-browsing-on =
    .label = 허용
    .tooltiptext = 사생활 보호 모드에서 사용
detail-private-browsing-off =
    .label = 허용 안 함
    .tooltiptext = 사생활 보호 모드에서 사용 안 함
detail-home =
    .label = 홈페이지
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = 부가 기능 프로필
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = 업데이트 확인
    .accesskey = U
    .tooltiptext = 이 부가 기능 업데이트 확인
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] 설정
           *[other] 환경 설정
        }
    .accesskey =
        { PLATFORM() ->
            [windows] O
           *[other] P
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] 부가 기능 설정 변경
           *[other] 부가 기능 환경 설정 변경
        }
detail-rating =
    .value = 평가
addon-restart-now =
    .label = 다시 시작
disabled-unsigned-heading =
    .value = 몇몇 부가 기능이 비활성화 됨
disabled-unsigned-description = 다음 부가 기능은 { -brand-short-name }에서의 사용이 확인되지 않았습니다. <label data-l10n-name="find-addons">대체제를 검색</label>하거나 개발자가 확인을 받도록 요청할 수 있습니다.
disabled-unsigned-learn-more = 사용자가 온라인에서 안전할 수 있게 노력하는 내용에 대해서 더 알아보세요.
disabled-unsigned-devinfo = 부가 기능을 확인하는데 관심이 있는 개발자는 <label data-l10n-name="learn-more">메뉴얼</label>을 읽어보세요.
plugin-deprecation-description = 빠진게 있습니까? 어떤 플러그인은 { -brand-short-name }에서 더 이상 지원하지 않습니다. <label data-l10n-name="learn-more">더 알아보기.</label>
legacy-warning-show-legacy = 레거시 확장 기능 보기
legacy-extensions =
    .value = 레거시 확장 기능
legacy-extensions-description = 이 확장 기능들은 현재 { -brand-short-name } 표준에 맞지 않으므로 비활성화되었습니다. <label data-l10n-name="legacy-learn-more">부가 기능의 변경 내용 알아보기</label>
private-browsing-description2 =
    { -brand-short-name }가 사생활 보호 모드에서 확장 기능이 작동하는 방식을 바꾸고 있습니다.
    { -brand-short-name }에 추가되는 모든 새 확장 기능은 기본적으로 사생활 보호 창에서 실행되지 않습니다. 만약 사용자가 설정에서 허용하지 않는다면, 확장 기능은 사생활 보호 모드에서 작동하지 않으며, 사용자 온라인 활동에 접근할 수 없습니다.
    사용자의 사생활 보호 모드를 비공개로 유지 하기 위해 이렇게 변경했습니다.
    <label data-l10n-name="private-browsing-learn-more">확장 기능 설정 관리 방법 알아보기</label>
addon-category-discover = 추천
addon-category-discover-title =
    .title = 추천
addon-category-extension = 확장 기능
addon-category-extension-title =
    .title = 확장 기능
addon-category-theme = 테마
addon-category-theme-title =
    .title = 테마
addon-category-plugin = 플러그인
addon-category-plugin-title =
    .title = 플러그인
addon-category-dictionary = 사전
addon-category-dictionary-title =
    .title = 사전
addon-category-locale = 언어팩
addon-category-locale-title =
    .title = 언어팩
addon-category-available-updates = 업데이트 가능 항목
addon-category-available-updates-title =
    .title = 업데이트 가능 항목
addon-category-recent-updates = 최근 업데이트
addon-category-recent-updates-title =
    .title = 최근 업데이트

## These are global warnings

extensions-warning-safe-mode = 안전 모드에서는 모든 부가 기능을 사용할 수 없습니다.
extensions-warning-check-compatibility = 부가 기능 호환성 확인 기능을 사용 안 합니다. 호환되지 않는 부가 기능이 있을 수 있습니다.
extensions-warning-check-compatibility-button = 사용
    .title = 부가 기능 호환성 확인 기능 사용
extensions-warning-update-security = 부가 기능 업데이트 보안 확인 기능을 사용 안 합니다. 업데이트로 인해 문제가 발생 할 수 있습니다.
extensions-warning-update-security-button = 사용
    .title = 부가 기능 업데이트 보안 확인 기능 사용

## Strings connected to add-on updates

addon-updates-check-for-updates = 업데이트 확인
    .accesskey = C
addon-updates-view-updates = 최근 업데이트 보기
    .accesskey = V

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = 부가 기능을 자동으로 업데이트
    .accesskey = A

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = 모든 부가 기능을 자동 업데이트로 재설정
    .accesskey = R
addon-updates-reset-updates-to-manual = 모든 부가 기능을 수동 업데이트로 재설정
    .accesskey = R

## Status messages displayed when updating add-ons

addon-updates-updating = 업데이트 확인 중
addon-updates-installed = 업데이트 완료
addon-updates-none-found = 업데이트 없음
addon-updates-manual-updates-found = 업데이트 가능 항목 보기

## Add-on install/debug strings for page options menu

addon-install-from-file = 파일에서 부가 기능 설치…
    .accesskey = I
addon-install-from-file-dialog-title = 설치할 부가 기능 선택
addon-install-from-file-filter-name = 부가 기능
addon-open-about-debugging = 부가 기능 디버그
    .accesskey = B

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = 확장 기능 단축키 관리
    .accesskey = S
shortcuts-no-addons = 사용하는 확장 기능이 없습니다.
shortcuts-no-commands = 다음 확장 기능에는 단축키가 없습니다:
shortcuts-input =
    .placeholder = 단축키 입력
shortcuts-browserAction2 = 도구 모음 버튼 활성화
shortcuts-pageAction = 페이지 작업 활성화
shortcuts-sidebarAction = 탐색창 표시/숨기기
shortcuts-modifier-mac = Ctrl, Alt 또는 ⌘ 포함
shortcuts-modifier-other = Ctrl 또는 Alt 포함
shortcuts-invalid = 잘못된 조합
shortcuts-letter = 문자 입력
shortcuts-system = { -brand-short-name } 단축키를 재정의 할 수 없음
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = 중복 단축키
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } 단축키가 여러 곳에 사용되고 있습니다. 단축키가 중복되면 예상치 못한 동작이 발생할 수 있습니다.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = 이미 { $addon }에서 사용 중입니다.
shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] { $numberToShow }개 더 보기
    }
shortcuts-card-collapse-button = 간단히 보기
header-back-button =
    .title = 뒤로 가기

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = 확장 기능 및 테마는 브라우저용 앱과 비슷하며, 비밀번호 보호, 동영상 다운로드, 거래 찾기, 성가신 광고 차단, 브라우저 외양 변경 등을 할 수 있도록 합니다. 이 작은 소프트웨어 프로그램은 보통 제3자에 의해 개발됩니다. 다음은 탁월한 보안, 성능 및 기능을 위해 { -brand-product-name }가 <a data-l10n-name="learn-more-trigger">추천</a>하는 목록입니다.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = 이러한 추천 중 일부는 개인화된 것입니다. 설치한 다른 확장 기능, 프로필 설정 및 사용 통계를 기반으로 합니다.
discopane-notice-learn-more = 더 알아보기
privacy-policy = 개인정보처리방침
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = 제작자: <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = 사용자 { $dailyUsers }명
install-extension-button = { -brand-product-name }에 추가
install-theme-button = 테마 설치
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = 관리
find-more-addons = 더 많은 부가 기능 찾기
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = 추가 옵션

## Add-on actions

report-addon-button = 신고
remove-addon-button = 제거
# The link will always be shown after the other text.
remove-addon-disabled-button = 제거할 수 없음. <a data-l10n-name="link">이유?</a>
disable-addon-button = 사용 안 함
enable-addon-button = 사용함
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = 사용함
preferences-addon-button =
    { PLATFORM() ->
        [windows] 설정
       *[other] 설정
    }
details-addon-button = 상세 정보
release-notes-addon-button = 출시 정보
permissions-addon-button = 권한
extension-enabled-heading = 사용함
extension-disabled-heading = 사용 안 함
theme-enabled-heading = 사용함
theme-disabled-heading = 사용 안 함
plugin-enabled-heading = 사용함
plugin-disabled-heading = 사용 안 함
dictionary-enabled-heading = 사용함
dictionary-disabled-heading = 사용 안 함
locale-enabled-heading = 사용함
locale-disabled-heading = 사용 안 함
ask-to-activate-button = 활성화 요청
always-activate-button = 항상 사용
never-activate-button = 사용 안 함
addon-detail-author-label = 제작자
addon-detail-version-label = 버전
addon-detail-last-updated-label = 마지막 업데이트
addon-detail-homepage-label = 홈페이지
addon-detail-rating-label = 평가
# Message for add-ons with a staged pending update.
install-postponed-message = 이 확장 기능은 { -brand-short-name }가 다시 시작될 때 업데이트됩니다.
install-postponed-button = 지금 업데이트
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = 평점: { NUMBER($rating, maximumFractionDigits: 1) } / 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (사용 안 함)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
       *[other] 리뷰 { $numberOfReviews }개
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> 부가 기능이 제거되었습니다.
pending-uninstall-undo-button = 실행 취소
addon-detail-updates-label = 자동 업데이트 허용
addon-detail-updates-radio-default = 기본값
addon-detail-updates-radio-on = 켜기
addon-detail-updates-radio-off = 끄기
addon-detail-update-check-label = 업데이트 확인
install-update-button = 업데이트
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = 사생활 보호 창에서 허용됨
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = 허용된 경우, 확장 기능은 사생활 보호 모드에서 온라인 활동에 접근 할 수 있습니다. <a data-l10n-name="learn-more">더 알아보기</a>
addon-detail-private-browsing-allow = 허용
addon-detail-private-browsing-disallow = 허용 안 함

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name }는 보안 및 성능 표준을 충족하는 확장 기능만 추천합니다
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Mozilla" in the string below because the extensions are built
# by Mozilla and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Mozilla에서 만든 공식 확장 기능. 보안 및 성능 표준 충족
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = 이 확장 기능은 보안 및 성능 표준을 충족하는 것으로 검토되었습니다
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = 업데이트 가능 항목
recent-updates-heading = 최근 업데이트
release-notes-loading = 로드 중…
release-notes-error = 죄송합니다. 출시 정보를 불러오는 중에 오류가 발생했습니다.
addon-permissions-empty = 이 확장 기능은 권한이 필요하지 않습니다.
addon-permissions-required = 핵심 기능에 필요한 필수 권한:
addon-permissions-optional = 추가 기능에 필요한 선택 권한:
addon-permissions-learnmore = 권한에 대해 더 알아보기
recommended-extensions-heading = 추천 확장 기능
recommended-themes-heading = 추천 테마
# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = 창의적인 느낌이 떠오르십니까? <a data-l10n-name="link">Firefox Color로 나만의 테마를 만들어 보세요.</a>

## Page headings

extension-heading = 확장 기능 관리
theme-heading = 테마 관리
plugin-heading = 플러그인 관리
dictionary-heading = 사전 관리
locale-heading = 언어 관리
updates-heading = 업데이트 관리
discover-heading = { -brand-short-name } 개인화
shortcuts-heading = 확장 기능 단축키 관리
default-heading-search-label = 더 많은 부가 기능 찾기
addons-heading-search-input =
    .placeholder = addons.mozilla.org 검색
addon-page-options-button =
    .title = 부가 기능 도구
