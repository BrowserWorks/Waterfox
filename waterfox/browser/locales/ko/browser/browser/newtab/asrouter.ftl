# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These messages are used as headings in the recommendation doorhanger

cfr-doorhanger-extension-heading = 추천 확장 기능
cfr-doorhanger-feature-heading = 추천 기능

##

cfr-doorhanger-extension-sumo-link =
    .tooltiptext = 왜 이게 나왔나요

cfr-doorhanger-extension-cancel-button = 나중에
    .accesskey = N

cfr-doorhanger-extension-ok-button = 지금 추가
    .accesskey = A

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

## Waterfox Accounts Message

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

cfr-whatsnew-release-notes-link-text = 출시 정보 읽기

## Enhanced Tracking Protection Milestones

# Variables:
#   $blockedCount (Number) - The total count of blocked trackers. This number will always be greater than 1.
#   $date (Datetime) - The date we began recording the count of blocked trackers
cfr-doorhanger-milestone-heading2 =
    { $blockedCount ->
       *[other] { -brand-short-name }가 { DATETIME($date, month: "long", year: "numeric") } 이후 <b>{ $blockedCount }</b>개 이상의 추적기를 차단했습니다!
    }
cfr-doorhanger-milestone-ok-button = 모두 보기
    .accesskey = S
cfr-doorhanger-milestone-close-button = 닫기
    .accesskey = C

## DOH Message

cfr-doorhanger-doh-body = 개인 정보 보호는 중요합니다. { -brand-short-name }는 탐색하는 동안 사용자를 보호하기 위해 가능하면 사용자의 DNS 요청을 파트너 서비스로 안전하게 라우팅합니다.
cfr-doorhanger-doh-header = 더 안전하고, 암호화된 DNS 조회
cfr-doorhanger-doh-primary-button-2 = 확인
    .accesskey = O
cfr-doorhanger-doh-secondary-button = 사용 안 함
    .accesskey = D

## Fission Experiment Message

## Full Video Support CFR message

cfr-doorhanger-video-support-body = 이 사이트의 동영상은 이 버전의 { -brand-short-name }에서 제대로 재생되지 않을 수 있습니다. 전체 동영상 지원을 받으려면, 지금 { -brand-short-name }를 업데이트하세요.
cfr-doorhanger-video-support-header = 동영상을 재생하려면 { -brand-short-name } 업데이트
cfr-doorhanger-video-support-primary-button = 지금 업데이트
    .accesskey = U

## Spotlight modal shared strings

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the BrowserWorks VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = 공용 Wi-Fi를 사용 중인 것 같습니다
spotlight-public-wifi-vpn-body = 위치 및 탐색 활동을 숨기려면 가상 사설망 (VPN)을 고려하세요. 공항 및 커피숍과 같은 공공 장소에서 탐색할 때 보호를 유지하는 데 도움이 됩니다.
spotlight-public-wifi-vpn-primary-button = { -mozilla-vpn-brand-name }으로 사생활 보호 유지
    .accesskey = S
spotlight-public-wifi-vpn-link = 나중에
    .accesskey = N

## Total Cookie Protection Rollout

## Emotive Continuous Onboarding

spotlight-better-internet-header = 더 나은 인터넷은 당신과 함께 시작됩니다
spotlight-better-internet-body = { -brand-short-name }를 사용하면 모두에게 더 나은 개방적이고 접근 가능한 인터넷에 투표하는 것입니다.
spotlight-peace-mind-header = 저희가 사용자를 보호합니다
spotlight-peace-mind-body = 매달 { -brand-short-name }는 사용자당 평균 3,000개 이상의 추적기를 차단합니다. 특히 추적기와 같은 개인 정보를 침해하는 요소가 사용자와 좋은 인터넷 사이에 있어서는 안 되기 때문입니다.
spotlight-pin-primary-button =
    { PLATFORM() ->
        [macos] Dock에 넣기
       *[other] 작업 표시줄에 고정
    }
spotlight-pin-secondary-button = 나중에

## MR2022 Background Update Windows native toast notification strings.
##
## These strings will be displayed by the Windows operating system in
## a native toast, like:
##
## <b>multi-line title</b>
## multi-line text
## <img>
## [ primary button ] [ secondary button ]
##
## The button labels are fitted into narrow fixed-width buttons by
## Windows and therefore must be as narrow as possible.

mr2022-background-update-toast-title = 새로운 { -brand-short-name }. 사생활을 더 보호합니다. 추적기가 더 적습니다. 타협이 없습니다.
mr2022-background-update-toast-text = 가장 강력한 추적 방지 보호 기능으로 업그레이드된 최신 { -brand-short-name }를 지금 사용해 보세요.

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it
# using a variable font like Arial): the button can only fit 1-2
# additional characters, exceeding characters will be truncated.
mr2022-background-update-toast-primary-button-label = 지금 { -brand-shorter-name } 열기

# This button label will be fitted into a narrow fixed-width button by
# Windows. Try to not exceed the width of the English text (compare it using a
# variable font like Arial): the button can only fit 1-2 additional characters,
# exceeding characters will be truncated.
mr2022-background-update-toast-secondary-button-label = 나중에 알림

## Waterfox View CFR

firefoxview-cfr-primarybutton = 사용해 보기
    .accesskey = T
firefoxview-cfr-secondarybutton = 나중에
    .accesskey = N
firefoxview-cfr-header-v2 = 중단한 부분부터 빠르게 다시 시작하세요
firefoxview-cfr-body-v2 = { -firefoxview-brand-name }를 사용하여 최근에 닫은 탭을 다시 가져오고, 기기 간에 원활하게 전환하세요.

## Waterfox View Spotlight

firefoxview-spotlight-promo-title = { -firefoxview-brand-name }를 만나보세요

# “Poof” refers to the expression to convey when something or someone suddenly disappears, or in this case, reappears. For example, “Poof, it’s gone.”
firefoxview-spotlight-promo-subtitle = 휴대폰에서 열린 탭을 보고 싶으세요? 가져오세요. 방금 방문했던 사이트가 필요하세요? { -firefoxview-brand-name }로 다시 여세요.
firefoxview-spotlight-promo-primarybutton = 작동 방식 보기
firefoxview-spotlight-promo-secondarybutton = 건너뛰기

## Colorways expiry reminder CFR

colorways-cfr-primarybutton = 컬러웨이 선택
    .accesskey = C

# "shades" refers to the different color options available to users in colorways.
colorways-cfr-body = 문화를 바꾼 목소리에서 영감을 받은 { -brand-short-name } 독점 색상으로 브라우저를 색칠하세요.
colorways-cfr-header-28days = 독립적인 목소리 컬러웨이 1월 16일 만료됨
colorways-cfr-header-14days = 독립적인 목소리 컬러웨이 2주 후 만료됨
colorways-cfr-header-7days = 독립적인 목소리 컬러웨이 이번 주 만료됨
colorways-cfr-header-today = 독립적인 목소리 컬러웨이 오늘 만료됨

## Cookie Banner Handling CFR

cfr-cbh-header = { -brand-short-name }가 쿠키 배너를 거부하도록 허용하시겠습니까?
cfr-cbh-body = { -brand-short-name }가 많은 쿠키 배너 요청을 자동으로 거부할 수 있습니다.
cfr-cbh-confirm-button = 쿠키 배너 거부
    .accesskey = R
cfr-cbh-dismiss-button = 나중에
    .accesskey = N

## These strings are used in the Fox doodle Pin/set default spotlights

july-jam-headline = 저희가 사용자를 보호합니다
july-jam-body = 매달 { -brand-short-name }는 사용자당 평균 3,000개 이상의 추적기를 차단하여 좋은 인터넷에 안전하고 빠르게 액세스할 수 있도록 합니다.
july-jam-set-default-primary = { -brand-short-name }로 내 링크 열기
fox-doodle-pin-headline = 환영합니다

# “indie” is short for the term “independent”.
# In this instance, free from outside influence or control.
fox-doodle-pin-body = 클릭 한 번으로 좋아하는 독립된 브라우저를 계속 사용할 수 있는다는 알림입니다.
fox-doodle-pin-primary = { -brand-short-name }로 내 링크 열기
fox-doodle-pin-secondary = 나중에

## These strings are used in the Set Waterfox as Default PDF Handler for Existing Users experiment

set-default-pdf-handler-headline = <strong>이제 PDF가 { -brand-short-name }에서 열립니다.</strong> 브라우저에서 직접 양식을 편집하거나 서명하세요. 변경하려면, 설정에서 "PDF"를 검색하세요.
set-default-pdf-handler-primary = 확인

## FxA sync CFR

fxa-sync-cfr-header = 미래의 새 기기?
fxa-sync-cfr-body = 새 { -brand-product-name } 브라우저를 열 때마다 최신 북마크, 비밀번호 및 탭이 함께 제공되는지 확인하세요.
fxa-sync-cfr-primary = 더 알아보기
    .accesskey = L
fxa-sync-cfr-secondary = 나중에 알림
    .accesskey = R

## Device Migration FxA Spotlight

device-migration-fxa-spotlight-header = 오래된 기기를 사용하시나요?
device-migration-fxa-spotlight-body = 특히 새 기기로 전환하는 경우 북마크 및 비밀번호와 같은 중요한 정보를 잃지 않도록 데이터를 백업하세요.
device-migration-fxa-spotlight-primary-button = 내 데이터를 백업하는 방법
device-migration-fxa-spotlight-link = 나중에 알림
