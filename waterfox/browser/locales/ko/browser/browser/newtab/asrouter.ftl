# This Source Code Form is subject to the terms of the Waterfox Public
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

cfr-doorhanger-fission-body-approved = 개인 정보는 중요합니다. { -brand-short-name }는 이제 웹 사이트를 서로 격리하거나 샌드 박스를 만들어 해커가 비밀번호, 신용 카드 번호 및 기타 중요한 정보를 훔치기 어렵게 만듭니다.
cfr-doorhanger-fission-header = 사이트 격리
cfr-doorhanger-fission-primary-button = 확인
    .accesskey = O
cfr-doorhanger-fission-secondary-button = 더 알아보기
    .accesskey = L

## Full Video Support CFR message

cfr-doorhanger-video-support-body = 이 사이트의 동영상은 이 버전의 { -brand-short-name }에서 제대로 재생되지 않을 수 있습니다. 전체 동영상 지원을 받으려면, 지금 { -brand-short-name }를 업데이트하세요.
cfr-doorhanger-video-support-header = 동영상을 재생하려면 { -brand-short-name } 업데이트
cfr-doorhanger-video-support-primary-button = 지금 업데이트
    .accesskey = U

## Spotlight modal shared strings

spotlight-learn-more-collapsed = 더 알아보기
    .title = 기능에 대해 더 알아보려면 확장하세요
spotlight-learn-more-expanded = 더 알아보기
    .title = 닫기

## VPN promotion dialog for public Wi-Fi users
##
## If a user is detected to be on a public Wi-Fi network, they are given a
## bit of info about how to improve their privacy and then offered a button
## to the Waterfox VPN page and a link to dismiss the dialog.

# This header text can be explicitly wrapped.
spotlight-public-wifi-vpn-header = 공용 Wi-Fi를 사용 중인 것 같습니다
spotlight-public-wifi-vpn-body = 위치 및 탐색 활동을 숨기려면 가상 사설망 (VPN)을 고려하세요. 공항 및 커피숍과 같은 공공 장소에서 탐색할 때 보호를 유지하는 데 도움이 됩니다.
spotlight-public-wifi-vpn-primary-button = { -mozilla-vpn-brand-name }으로 사생활 보호 유지
    .accesskey = S
spotlight-public-wifi-vpn-link = 나중에
    .accesskey = N

## Total Cookie Protection Rollout

# "Test pilot" is used as a verb. Possible alternatives: "Be the first to try",
# "Join an early experiment". This header text can be explicitly wrapped.
spotlight-total-cookie-protection-header =
    가장 강력한 개인 정보 보호 기능을
    최초로 시험해 보세요
spotlight-total-cookie-protection-body = 전체 쿠키 보호는 추적기가 쿠키를 사용하여 웹에서 사용자를 스토킹하는 것을 방지합니다.
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch" as not everybody will get it yet.
spotlight-total-cookie-protection-expanded = { -brand-short-name }는 쿠키 주위에 울타리를 치고 사용자가 있는 사이트로 제한하므로 추적기가 사용자를 팔로우하는 데 쿠키를 사용할 수 없습니다. 먼저 이용해 보시면 이 기능을 최적화하는데 도움이 되므로 저희가 모든 사용자를 위한 더 나은 웹을 계속 구축할 수 있습니다.
spotlight-total-cookie-protection-primary-button = 전체 쿠키 보호 켜기
spotlight-total-cookie-protection-secondary-button = 나중에
cfr-total-cookie-protection-header = 덕분에 { -brand-short-name }는 그 어느 때보다 사적이고 안전합니다
# "Early access" for this feature rollout means it's a "feature preview" or
# "soft launch". Only those who received it and accepted are shown this message.
cfr-total-cookie-protection-body = 전체 쿠키 보호는 가장 강력한 개인 정보 보호 기능이며 이제 { -brand-short-name } 사용자를 위한 기본 설정입니다. 여러분과 같은 조기 참가자가 없었다면 불가능했을 것입니다. 더 나은 사적인 인터넷을 만들 수 있도록 도와주셔서 감사합니다.

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
