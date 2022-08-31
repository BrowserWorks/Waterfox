# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = 사생활 보호 창 열기
    .accesskey = P
about-private-browsing-search-placeholder = 웹 검색
about-private-browsing-info-title = 사생활 보호 창입니다
about-private-browsing-search-btn =
    .title = 웹 검색
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = { $engine } 검색 또는 주소 입력
about-private-browsing-handoff-no-engine =
    .title = 검색어 또는 주소 입력
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = { $engine } 검색 또는 주소 입력
about-private-browsing-handoff-text-no-engine = 검색어 또는 주소 입력
about-private-browsing-not-private = 현재 사생활 보호 창에 있지 않습니다.
about-private-browsing-info-description-private-window = 사생활 보호 창: { -brand-short-name }는 모든 사생활 보호 창을 닫을 때 검색 및 방문 기록을 지웁니다. 이것이 사용자를 익명으로 만들지는 않습니다.
about-private-browsing-info-description-simplified = { -brand-short-name }는 모든 사생활 보호 창을 닫을 때 검색 및 방문 기록을 지우지만 사용자를 익명으로 만들지는 않습니다.
about-private-browsing-learn-more-link = 더 알아보기
about-private-browsing-hide-activity = 탐색하는 모든 곳에서 활동 및 위치 숨기기
about-private-browsing-get-privacy = 탐색하는 모든 곳에서 개인 정보를 보호받으세요
about-private-browsing-hide-activity-1 = { -mozilla-vpn-brand-name }으로 탐색 활동 및 위치를 숨기세요. 한 번의 클릭으로 공용 Wi-Fi에서도 보안 연결이 생성됩니다.
about-private-browsing-prominent-cta = { -mozilla-vpn-brand-name }으로 사생활 보호 유지
about-private-browsing-focus-promo-cta = { -focus-brand-name } 다운로드
about-private-browsing-focus-promo-header = { -focus-brand-name }: 열일하는 사생활 보호 모드
about-private-browsing-focus-promo-text = 전용 사생활 보호 모바일 앱은 매번 기록과 쿠키를 지웁니다.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = 휴대폰으로 사생활 보호 모드 사용
about-private-browsing-focus-promo-text-b = 주 모바일 브라우저에 표시하고 싶지 않은 사생활 검색에는 { -focus-brand-name }를 사용하세요.
about-private-browsing-focus-promo-header-c = 모바일에서 한 차원 높은 개인 정보 보호
about-private-browsing-focus-promo-text-c = { -focus-brand-name }는 광고와 추적기를 차단하면서 매번 기록을 지웁니다.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName }은 사생활 보호 창의 기본 검색 엔진입니다
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] 다른 검색 엔진을 선택하려면 <a data-l10n-name="link-options">설정</a>으로 이동하세요
       *[other] 다른 검색 엔진을 선택하려면 <a data-l10n-name="link-options">설정</a>으로 이동하세요
    }
about-private-browsing-search-banner-close-button =
    .aria-label = 닫기
about-private-browsing-promo-close-button =
    .title = 닫기

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = 한 번의 클릭으로 자유로운 사생활 보호 모드
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Dock에 넣기
       *[other] 작업 표시줄에 고정
    }
about-private-browsing-pin-promo-title = 쿠키나 기록이 저장되지 않습니다. 아무도 보고 있지 않은 것처럼 탐색하세요.
