# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

protections-panel-sendreportview-error = 보고서를 보내는 중 오류가 발생했습니다. 나중에 다시 시도하세요.
# A link shown when ETP is disabled for a site. Opens the breakage report subview when clicked.
protections-panel-sitefixedsendreport-label = 사이트가 고쳐졌습니까? 보고서 보내기

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

protections-popup-footer-protection-label-strict = 엄격
    .label = 엄격
protections-popup-footer-protection-label-custom = 사용자 지정
    .label = 사용자 지정
protections-popup-footer-protection-label-standard = 표준
    .label = 표준

##

# The text a screen reader speaks when focused on the info button.
protections-panel-etp-more-info =
    .aria-label = 향상된 추적 방지 기능에 대한 추가 정보
protections-panel-etp-on-header = 이 사이트에 향상된 추적 방지 기능이 켜짐
protections-panel-etp-off-header = 이 사이트에 향상된 추적 방지 기능이 꺼짐
# The link to be clicked to open the sub-panel view
protections-panel-site-not-working = 사이트가 작동하지 않습니까?
# The heading/title of the sub-panel view
protections-panel-site-not-working-view =
    .title = 사이트가 작동하지 않습니까?

## The "Allowed" header also includes a "Why?" link that, when hovered, shows
## a tooltip explaining why these items were not blocked in the page.

protections-panel-not-blocking-why-label = 이유?
protections-panel-not-blocking-why-etp-on-tooltip = 이것들을 차단하면 일부 웹 사이트의 요소가 손상될 수 있습니다. 추적기가 없으면 일부 버튼, 양식 및 로그인 필드가 작동하지 않을 수 있습니다.
protections-panel-not-blocking-why-etp-off-tooltip = 보호 기능이 꺼져 있어 이 사이트의 모든 추적기가 로드되었습니다.

##

protections-panel-no-trackers-found = 이 페이지에서 { -brand-short-name }에 알려진 추적기가 감지되지 않았습니다.
protections-panel-content-blocking-tracking-protection = 추적 콘텐츠
protections-panel-content-blocking-socialblock = 소셜 미디어 추적기
protections-panel-content-blocking-cryptominers-label = 암호화폐 채굴기
protections-panel-content-blocking-fingerprinters-label = 디지털 지문

## In the protections panel, Content Blocking category items are in three sections:
##   "Blocked" for categories being blocked in the current page,
##   "Allowed" for categories detected but not blocked in the current page, and
##   "None Detected" for categories not detected in the current page.
##   These strings are used in the header labels of each of these sections.

protections-panel-blocking-label = 차단됨
protections-panel-not-blocking-label = 허용됨
protections-panel-not-found-label = 감지되지 않음

##

protections-panel-settings-label = 보호 설정
# This should match the "appmenuitem-protection-dashboard-title" string in browser/appmenu.ftl.
protections-panel-protectionsdashboard-label = 보호 대시보드

## In the Site Not Working? view, we suggest turning off protections if
## the user is experiencing issues with any of a variety of functionality.

# The header of the list
protections-panel-site-not-working-view-header = 다음과 관련된 문제가 있는 경우 보호 기능을 끕니다:
# The list items, shown in a <ul>
protections-panel-site-not-working-view-issue-list-login-fields = 로그인 필드
protections-panel-site-not-working-view-issue-list-forms = 양식
protections-panel-site-not-working-view-issue-list-payments = 결제
protections-panel-site-not-working-view-issue-list-comments = 댓글
protections-panel-site-not-working-view-issue-list-videos = 동영상
protections-panel-site-not-working-view-send-report = 보고서 보내기

##

protections-panel-cross-site-tracking-cookies = 이러한 쿠키는 사용자가 온라인에서 수행하는 작업에 대한 데이터를 수집하기 위해 사이트 간에 사용자를 따라갑니다. 광고사나 분석 회사와 같은 제3자가 설정합니다.
protections-panel-cryptominers = 암호화폐 채굴기는 디지털 화폐를 채굴하기 위해 시스템의 연산 능력을 사용합니다. 암호 해독 스크립트는 배터리를 소모하고 컴퓨터 속도를 저하시키며 에너지 요금을 증가시킬 수 있습니다.
protections-panel-fingerprinters = 디지털 지문은 브라우저와 컴퓨터에서 설정을 수집하여 사용자의 프로필을 만듭니다. 이를 사용하여 여러 웹 사이트에서 사용자를 추적할 수 있습니다.
protections-panel-tracking-content = 웹 사이트에서 외부 광고, 동영상 및 기타 추적 코드가 포함된 콘텐츠를 로드할 수 있습니다. 추적 콘텐츠를 차단하면 사이트를 더 빨리 로드할 수 있지만 일부 버튼, 양식 및 로그인 필드는 작동하지 않을 수 있습니다.
protections-panel-social-media-trackers = 소셜 네트워크는 다른 웹 사이트에 추적기를 배치하여 온라인에서 한 일이나 본 것, 재생한 것을 추적합니다. 이를 통해 소셜 미디어 회사들은 소셜 미디어 프로필에서 공유하는 것 이상의 자세한 정보를 얻을 수 있습니다.
protections-panel-description-shim-allowed = 아래에 표시된 일부 추적기는 사용자가 상호 작용했기 때문에 이 페이지에서 부분적으로 차단 해제되었습니다.
protections-panel-description-shim-allowed-learn-more = 더 알아보기
protections-panel-shim-allowed-indicator =
    .tooltiptext = 추적기가 부분적으로 차단 해제됨
protections-panel-content-blocking-manage-settings =
    .label = 보호 설정 관리
    .accesskey = M
protections-panel-content-blocking-breakage-report-view =
    .title = 깨진 사이트 신고
protections-panel-content-blocking-breakage-report-view-description = 특정 추적기를 차단하면 일부 웹 사이트에서 문제가 발생할 수 있습니다. 이러한 문제를 보고하면 모든 사람에게 더 나은 { -brand-short-name }를 제공하는데 도움이 됩니다. 이 보고서를 보내면 URL과 브라우저 설정에 대한 정보가 Mozilla로 전송됩니다. <label data-l10n-name="learn-more">더 알아보기</label>
protections-panel-content-blocking-breakage-report-view-collection-url = URL
protections-panel-content-blocking-breakage-report-view-collection-url-label =
    .aria-label = URL
protections-panel-content-blocking-breakage-report-view-collection-comments = 선택 사항: 문제를 설명해 주세요
protections-panel-content-blocking-breakage-report-view-collection-comments-label =
    .aria-label = 선택 사항: 문제를 설명해 주세요
protections-panel-content-blocking-breakage-report-view-cancel =
    .label = 취소
protections-panel-content-blocking-breakage-report-view-send-report =
    .label = 보고서 보내기
