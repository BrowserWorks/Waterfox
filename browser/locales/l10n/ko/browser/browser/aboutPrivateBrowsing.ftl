# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = 새 사생활 보호 창 시작
    .accesskey = P
about-private-browsing-search-placeholder = 웹 검색
about-private-browsing-info-title = 사생활 보호 창입니다
about-private-browsing-info-myths = 사생활 보호 모드에 대한 일반적인 통념
about-private-browsing =
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
about-private-browsing-info-description = { -brand-short-name }는 앱을 종료하거나 모든 사생활 보호 탭과 창을 닫을 때 검색 및 방문 기록을 지웁니다. 이것이 사용자를 웹 사이트나 인터넷 서비스 제공자로부터 익명으로 만들지는 않지만, 사용자가 온라인에서 한 일을 이 컴퓨터를 사용하는 다른 사용자로부터 보호할 수 있게 합니다.
about-private-browsing-need-more-privacy = 더 많은 사생활 보호가 필요하십니까?
about-private-browsing-turn-on-vpn = { -mozilla-vpn-brand-name } 사용해 보기
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
