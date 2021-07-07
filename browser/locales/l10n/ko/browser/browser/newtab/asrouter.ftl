# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = 추천 확장 기능
cfr-doorhanger-feature-heading = 추천 기능
cfr-doorhanger-pintab-heading = 사용해보기: 탭 고정

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = 왜 이게 나왔나요
cfr-doorhanger-extension-cancel-button = 나중에
    .accesskey = N
cfr-doorhanger-extension-ok-button = 지금 추가
    .accesskey = A
cfr-doorhanger-pintab-ok-button = 이 탭 고정
    .accesskey = P
cfr-doorhanger-extension-manage-settings-button = 추천 설정 관리
    .accesskey = M
cfr-doorhanger-extension-never-show-recommendation = 이 추천을 표시하지 않음
    .accesskey = S
cfr-doorhanger-extension-learn-more-link = 더 알아보기
# This string is used on a new line below the add-on name
# Variables:
#   $name (String) - Add-on author name
cfr-doorhanger-extension-author = { $name } 제작
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-extension-notification = 추천
cfr-doorhanger-extension-notification2 = 추천
    .tooltiptext = 확장 기능 추천
    .a11y-announcement = 확장 기능 추천 사용 가능
# This is a notification displayed in the address bar.
# When clicked it opens a panel with a message for the user.
cfr-doorhanger-feature-notification = 추천
    .tooltiptext = 기능 추천
    .a11y-announcement = 기능 추천 사용 가능

## Add-on statistics
## These strings are used to display the total number of
## users and rating for an add-on. They are shown next to each other.

# Variables:
#   $total (Number) - The rating of the add-on from 1 to 5
cfr-doorhanger-extension-rating =
    .tooltiptext =
        { $total ->
           *[other] { $total } 점
        }
# Variables:
#   $total (Number) - The total number of users using the add-on
cfr-doorhanger-extension-total-users =
    { $total ->
       *[other] { $total } 사용자
    }
cfr-doorhanger-pintab-description = 가장 많이 사용하는 사이트에 쉽게 접근하세요. 사이트를 탭으로 열어 둡니다(다시 시작할 때에도).

## These messages are steps on how to use the feature and are shown together.

cfr-doorhanger-pintab-step1 = 고정하려는 탭에서 <b>마우스 오른쪽 버튼을 클릭</b>하세요.
cfr-doorhanger-pintab-step2 = 메뉴에서 <b>탭 고정</b>을 선택하세요.
cfr-doorhanger-pintab-step3 = 사이트에 업데이트가 있으면 고정된 탭에 파란색 점이 표시됩니다.
cfr-doorhanger-pintab-animation-pause = 일시 중지
cfr-doorhanger-pintab-animation-resume = 계속

## Firefox Accounts Message

cfr-doorhanger-bookmark-fxa-header = 어디서나 북마크 동기화
cfr-doorhanger-bookmark-fxa-body = 멋진 발견! 이제 다른 휴대 기기에서도 이 북마크를 사용해 보세요. { -fxaccount-brand-name }로 시작해 보세요.
cfr-doorhanger-bookmark-fxa-link-text = 북마크 지금 동기화…
cfr-doorhanger-bookmark-fxa-close-btn-tooltip =
    .aria-label = 닫기 버튼
    .title = 닫기

## Protections panel

cfr-protections-panel-header = 브라우저 추적 차단하기
cfr-protections-panel-body = 자신의 데이터를 보호하세요. { -brand-short-name }는 온라인에서 하는 일을 추적하는 가장 일반적인 많은 추적기로부터 사용자를 보호합니다.
cfr-protections-panel-link-text = 더 알아보기

## What's New toolbar button and panel

# This string is used by screen readers to offer a text based alternative for
# the notification icon
cfr-badge-reader-label-newfeature = 새 기능:
cfr-whatsnew-button =
    .label = 새 기능
    .tooltiptext = 새 기능
cfr-whatsnew-panel-header = 새 기능
cfr-whatsnew-release-notes-link-text = 출시 정보 읽기
cfr-whatsnew-fx70-title = { -brand-short-name }는 이제 사용자의 개인 정보 보호를 위해 더 열심히 싸웁니다
cfr-whatsnew-fx70-body = 최신 업데이트는 추적 방지 기능을 향상시키고 모든 사이트에 대해 안전한 비밀번호를 만드는 것이 그 어느때보다 쉬워졌습니다.
cfr-whatsnew-tracking-protect-title = 추적기로부터 보호
cfr-whatsnew-tracking-protect-body = { -brand-short-name }는 온라인에서 사용자를 따라다니는 많은 일반적인 소셜 및 교차 사이트 추적기를 차단합니다.
cfr-whatsnew-tracking-protect-link-text = 보고서 보기
# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $blockedCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-tracking-blocked-title =
    { $blockedCount ->
       *[other] 추적기 차단됨
    }
cfr-whatsnew-tracking-blocked-subtitle = { DATETIME($earliestDate, month: "long", year: "numeric") } 이후
cfr-whatsnew-tracking-blocked-link-text = 보고서 보기
cfr-whatsnew-lockwise-backup-title = 비밀번호 백업
cfr-whatsnew-lockwise-backup-body = 이제 로그인하는 곳 어디에서나 접근할 수 있는 안전한 비밀번호를 생성하세요.
cfr-whatsnew-lockwise-backup-link-text = 백업 켜기
cfr-whatsnew-lockwise-take-title = 비밀번호를 가지고 다니세요
cfr-whatsnew-lockwise-take-body = { -lockwise-brand-short-name } 모바일 앱을 사용하면 어디서든 백업된 비밀번호에 안전하게 접근할 수 있습니다.
cfr-whatsnew-lockwise-take-link-text = 앱 받기

## Search Bar

cfr-whatsnew-searchbar-title = 주소 표시줄에서 입력은 더 적게하고 더 많이 찾기
cfr-whatsnew-searchbar-body-topsites = 이제 주소 표시줄을 선택하면, 상자가 확장되어 상위 사이트에 대한 링크가 표시됩니다.

## Search bar

cfr-whatsnew-searchbar-icon-alt-text = 돋보기 아이콘

## Picture-in-Picture

cfr-whatsnew-pip-header = 탐색하는 동안 동영상 시청
cfr-whatsnew-pip-body = 화면 속 화면은 동영상을 떠 있는 창으로 띄워 다른 탭에서 작업하는 동안 볼 수 있습니다.
cfr-whatsnew-pip-cta = 더 알아보기

## Permission Prompt

cfr-whatsnew-permission-prompt-header = 성가신 사이트 팝업 감소
cfr-whatsnew-permission-prompt-body = { -brand-shorter-name }는 이제 사이트에서 자동으로 팝업 메시지를 보내도록 요청하는 것을 차단합니다.
cfr-whatsnew-permission-prompt-cta = 더 알아보기

## Fingerprinter Counter

# This string is displayed before a large numeral that indicates the total
# number of tracking elements blocked. Don’t add $fingerprinterCount to your
# localization, because it would result in the number showing twice.
cfr-whatsnew-fingerprinter-counter-header =
    { $fingerprinterCount ->
       *[other] 디지털 지문 차단됨
    }
cfr-whatsnew-fingerprinter-counter-body = { -brand-shorter-name }는 기기와 동작에 대한 정보를 몰래 수집하여 사용자의 광고 프로필을 만드는 많은 디지털 지문을 차단합니다.
# Message variation when fingerprinters count is less than 10
cfr-whatsnew-fingerprinter-counter-header-alt = 디지털 지문
cfr-whatsnew-fingerprinter-counter-body-alt = { -brand-shorter-name }는 기기와 동작에 대한 정보를 몰래 수집하여 사용자의 광고 프로필을 만드는 디지털 지문을 차단할 수 있습니다.

## Bookmark Sync

cfr-doorhanger-sync-bookmarks-header = 이 북마크를 휴대폰에서 사용합니다
cfr-doorhanger-sync-bookmarks-body = { -brand-product-name }에 로그인한 모든 곳에서 북마크, 비밀번호, 방문 기록 등을 가져옵니다.
cfr-doorhanger-sync-bookmarks-ok-button = { -sync-brand-short-name } 켜기
    .accesskey = T

## Login Sync

cfr-doorhanger-sync-logins-header = 다시는 비밀번호를 잃어버리지 마세요
cfr-doorhanger-sync-logins-body = 비밀번호를 모든 기기에 안전하게 저장하고 동기화합니다.
cfr-doorhanger-sync-logins-ok-button = { -sync-brand-short-name } 켜기
    .accesskey = T

## Send Tab

cfr-doorhanger-send-tab-header = 이동 중에 이것을 읽어보세요
cfr-doorhanger-send-tab-recipe-header = 이 요리법을 주방으로 가져가세요
cfr-doorhanger-send-tab-body = 탭 보내기를 사용하면 이 링크를 휴대폰 또는 { -brand-product-name }에 로그인 한 곳 어디에서나 쉽게 공유할 수 있습니다.
cfr-doorhanger-send-tab-ok-button = 탭 보내기 사용해보기
    .accesskey = T

## Firefox Send

cfr-doorhanger-firefox-send-header = 이 PDF를 안전하게 공유하세요
cfr-doorhanger-firefox-send-body = 종단 간 암호화와 완료시 사라지는 링크를 사용하여 중요한 문서를 안전하게 보관할 수 있습니다.
cfr-doorhanger-firefox-send-ok-button = { -send-brand-name } 사용해보기
    .accesskey = T

## Social Tracking Protection

cfr-doorhanger-socialtracking-ok-button = 보호 보기
    .accesskey = P
cfr-doorhanger-socialtracking-close-button = 닫기
    .accesskey = C
cfr-doorhanger-socialtracking-dont-show-again = 이런 메시지 다시 표시 안 함
    .accesskey = D
cfr-doorhanger-socialtracking-heading = { -brand-short-name }가 여기에서 소셜 네트워크가 사용자를 추적하는 것을 중지했습니다
cfr-doorhanger-socialtracking-description = 개인 정보는 중요합니다. { -brand-short-name }는 이제 일반적인 소셜 미디어 추적기를 차단하여 온라인에서 수행하는 작업에 대해 수집할 수 있는 데이터의 양을 제한합니다.
cfr-doorhanger-fingerprinters-heading = { -brand-short-name }가 이 페이지에서 핑커프린터를 차단했습니다
cfr-doorhanger-fingerprinters-description = 개인 정보는 중요합니다. { -brand-short-name }는 이제 기기에 대해 고유하게 식별 가능한 정보 조각을 수집하여 사용자를 추적하는 디지털 지문을 차단합니다.
cfr-doorhanger-cryptominers-heading = { -brand-short-name }가 이 페이지에서 암호화폐 채굴기를 차단했습니다
cfr-doorhanger-cryptominers-description = 개인 정보는 중요합니다. { -brand-short-name }는 이제 시스템의 컴퓨팅 능력을 사용하여 디지털 화폐를 채굴하는 암호화폐 채굴기를 차단합니다.

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (String) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading =
    { $blockedCount ->
       *[other] { -brand-short-name }가 { $date } 이후 <b>{ $blockedCount }</b>개 이상의 추적기를 차단했습니다!
    }
# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name }가 { DATETIME($date, month: "long", year: "numeric") } 이후 <b>{ $blockedCount }</b>개 이상의 추적기를 차단했습니다!
    }
cfr-doorhanger-milestone-ok-button = 모두 보기
    .accesskey = S

## What’s New Panel Content for Firefox 76


## Lockwise message

cfr-whatsnew-lockwise-header = 안전한 비밀번호를 쉽게 생성
cfr-whatsnew-lockwise-body = 모든 계정에 대해 고유하고 안전한 비밀번호를 생각하기는 어렵습니다. 비밀번호를 만들때 { -brand-shorter-name }에서 생성된 안전한 비밀번호를 사용하려면 비밀번호 필드를 선택하세요.
cfr-whatsnew-lockwise-icon-alt = { -lockwise-brand-short-name } 아이콘

## Vulnerable Passwords message

cfr-whatsnew-passwords-header = 취약한 비밀번호에 대한 알림 받기
cfr-whatsnew-passwords-body = 해커는 사람들이 동일한 비밀번호를 재사용한다는 것을 알고 있습니다. 여러 사이트에서 동일한 비밀번호를 사용하고, 해당 사이트들 중 하나에서 데이터가 유출된 경우, { -lockwise-brand-short-name }에 해당 사이트들의 비밀번호를 변경하라는 알림이 표시됩니다.
cfr-whatsnew-passwords-icon-alt = 취약한 비밀번호 키 아이콘

## Picture-in-Picture fullscreen message

cfr-whatsnew-pip-fullscreen-header = 화면 속 화면을 전체 화면에서 보세요
cfr-whatsnew-pip-fullscreen-body = 동영상을 떠 있는 창에 띄웠을때, 해당 창을 더블 클릭해서 전체 화면으로 전환할 수 있습니다.
cfr-whatsnew-pip-fullscreen-icon-alt = 화면 속 화면 아이콘

## Protections Dashboard message

cfr-doorhanger-milestone-close-button = 닫기
    .accesskey = C

## What’s New Panel Content for Firefox 76
## Protections Dashboard message

cfr-whatsnew-protections-header = 보호 기능을 한 눈에 확인
cfr-whatsnew-protections-body = 보호 대시보드에는 데이터 유출 및 비밀번호 관리에 대한 요약 보고서가 포함되어 있습니다. 이제 해결된 유출 수를 추적하고 저장된 비밀번호 중 데이터 유출에 노출된 비밀번호가 있는지 확인할 수 있습니다.
cfr-whatsnew-protections-cta-link = 보호 대시보드 보기
cfr-whatsnew-protections-icon-alt = 방패 아이콘

## Better PDF message

cfr-whatsnew-better-pdf-header = 더 나은 PDF 경험
cfr-whatsnew-better-pdf-body = 이제 PDF 문서가 { -brand-short-name }에서 직접 열리므로 워크플로에 쉽게 접근할 수 있습니다.

## DOH Message

cfr-doorhanger-doh-body = 개인 정보 보호는 중요합니다. { -brand-short-name }는 탐색하는 동안 사용자를 보호하기 위해 가능하면 사용자의 DNS 요청을 파트너 서비스로 안전하게 라우팅합니다.
cfr-doorhanger-doh-header = 더 안전하고, 암호화된 DNS 조회
cfr-doorhanger-doh-primary-button-2 = 확인
    .accesskey = O
cfr-doorhanger-doh-secondary-button = 사용 안 함
    .accesskey = D

## Fission Experiment Message

cfr-doorhanger-fission-body-approved = 개인 정보는 중요합니다. { -brand-short-name }는 이제 웹 사이트를 서로 격리하거나 샌드 박스를 만들어 해커가 비밀번호, 신용 카드 번호 및 기타 중요한 정보를 훔치기 어렵게 만듭니다.
cfr-doorhanger-fission-header = 사이트 격리
cfr-doorhanger-fission-primary-button = 확인
    .accesskey = O
cfr-doorhanger-fission-secondary-button = 더 알아보기
    .accesskey = L

## What's new: Cookies message

cfr-whatsnew-clear-cookies-header = 교활한 추적 전술로부터 자동 보호
cfr-whatsnew-clear-cookies-body = 일부 추적기는 몰래 쿠키를 설정하는 다른 웹 사이트로 사용자를 리디렉션합니다. 이제 { -brand-short-name }는 이런 쿠키를 자동으로 지우므로 사용자를 따라다닐 수 없습니다.
cfr-whatsnew-clear-cookies-image-alt = 쿠키 차단 그림

## What's new: Media controls message

cfr-whatsnew-media-keys-header = 더 많은 미디어 컨트롤
cfr-whatsnew-media-keys-body = 키보드 또는 헤드셋에서 바로 오디오 또는 비디오를 재생 및 일시 중지하여 다른 탭, 프로그램 또는 컴퓨터가 잠긴 경우에도 미디어를 쉽게 제어할 수 있습니다. 또한 앞으로 및 뒤로 키를 사용하여 트랙 사이를 이동할 수도 있습니다.
cfr-whatsnew-media-keys-button = 방법 알아보기

## What's new: Search shortcuts

cfr-whatsnew-search-shortcuts-header = 주소 표시줄의 검색 바로 가기
cfr-whatsnew-search-shortcuts-body = 이제, 검색 엔진이나 특정 사이트를 주소 표시줄에 입력하면 아래의 검색 제안에 파란색 바로 가기가 나타납니다. 주소 표시줄에서 바로 검색을 완료하려면 해당 바로 가기를 선택하세요.

## What's new: Cookies protection

cfr-whatsnew-supercookies-header = 악성 슈퍼쿠키로부터 보호
cfr-whatsnew-supercookies-body = 웹 사이트는 사용자가 쿠키를 지운 후에도 웹에서 사용자를 추적할 수 있는 "슈퍼쿠키"를 브라우저에 몰래 첨부할 수 있습니다. { -brand-short-name }는 이제 슈퍼쿠키에 대한 강력한 보호 기능을 제공하므로 한 사이트에서 다음 사이트로 온라인 활동을 추적하는 데 사용할 수 없습니다.

## What's new: Better bookmarking

cfr-whatsnew-bookmarking-header = 더 나은 북마크
cfr-whatsnew-bookmarking-body = 즐겨찾는 사이트를 더 쉽게 추적할 수 있습니다. 이제 { -brand-short-name }는 저장된 북마크의 선호 위치를 기억하고, 새 탭에 북마크 도구 모음을 기본적으로 표시하며, 도구 모음 폴더를 통해 나머지 북마크에 쉽게 액세스할 수 있습니다.

## What's new: Cross-site cookie tracking

cfr-whatsnew-cross-site-tracking-header = 교차 사이트 쿠키 추적으로부터 포괄적인 보호
cfr-whatsnew-cross-site-tracking-body = 이제 쿠키 추적으로부터 더 나은 보호를 선택할 수 있습니다. { -brand-short-name }는 활동과 데이터를 현재 사이트로 분리하여 브라우저에 저장된 정보가 웹 사이트간에 공유되지 않도록 합니다.

## Full Video Support CFR message

cfr-doorhanger-video-support-body = 이 사이트의 동영상은 이 버전의 { -brand-short-name }에서 제대로 재생되지 않을 수 있습니다. 전체 동영상 지원을 받으려면, 지금 { -brand-short-name }를 업데이트하세요.
cfr-doorhanger-video-support-header = 동영상을 재생하려면 { -brand-short-name } 업데이트
cfr-doorhanger-video-support-primary-button = 지금 업데이트
    .accesskey = U
