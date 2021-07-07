# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = 탭 언로드
about-unloads-intro-1 =
    { -brand-short-name }에는 시스템의 사용 가능한 메모리가 부족할 때 
    메모리 부족으로 인해 애플리케이션이 충돌하는 것을 방지하기 위해 
    탭을 자동으로 언로드하는 기능이 있습니다. 언로드할 다음 탭은 여러 
    속성을 기반으로 선택됩니다. 이 페이지는 탭 언로드가 실행될 때 
    { -brand-short-name }가 탭의 우선 순위를 지정하는 방법과 어떤 탭이 
    언로드되는지 보여줍니다.
about-unloads-intro-2 =
    기존 탭은 { -brand-short-name }가 언로드할 다음 탭을 선택하는데 사용한 것과 
    동일한 순서로 아래 표에 표시됩니다. 프로세스 ID는 탭의 상단 프레임을 호스팅할 때 
    <strong>굵게</strong> 표시되고, 프로세스가 다른 탭 간에 공유될 때 <em>기울임꼴</em>로 
    표시됩니다. 아래의 <em>언로드</em> 버튼을 클릭하여 탭 언로드를 수동으로 실행할 
    수 있습니다.
about-unloads-intro =
    { -brand-short-name }에는 시스템의 사용 가능한 메모리가 부족할 때 
    메모리 부족으로 인해 애플리케이션이 충돌하는 것을 방지하기 위해 
    탭을 자동으로 언로드하는 기능이 있습니다. 언로드할 다음 탭은 여러 
    속성을 기반으로 선택됩니다. 이 페이지는 탭 언로드가 실행될 때 
    { -brand-short-name }가 탭의 우선 순위를 지정하는 방법과 어떤 탭이 
    언로드되는지 보여줍니다. 아래의 <em>언로드</em> 버튼을 클릭하여 
    탭 언로드를 수동으로 실행할 수 있습니다.
# The link points to a Waterfox documentation page, only available in English,
# with title "Tab Unloading"
about-unloads-learn-more =
    이 기능과 이 페이지에 대해 더 알아보려면 
    <a data-l10n-name="doc-link">탭 언로드</a>를 참고하세요.
about-unloads-last-updated = 마지막 업데이트: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = 언로드
    .title = 가장 높은 우선 순위를 가진 탭 언로드
about-unloads-no-unloadable-tab = 언로드할 수 있는 탭이 없습니다.
about-unloads-column-priority = 우선순위
about-unloads-column-host = 호스트
about-unloads-column-last-accessed = 마지막 액세스
about-unloads-column-weight = 기본 가중치
    .title = 탭은 먼저 소리 재생, WebRTC 등과 같은 일부 특수 속성에서 파생된 이 값으로 정렬됩니다.
about-unloads-column-sortweight = 보조 가중치
    .title = 가능한 경우 탭은 기본 가중치로 정렬된 후 이 값으로 정렬됩니다. 값은 탭의 메모리 사용량과 프로세스 수에서 파생됩니다.
about-unloads-column-memory = 메모리
    .title = 탭의 예상 메모리 사용량
about-unloads-column-processes = 프로세스 ID
    .title = 탭의 콘텐츠를 호스팅하는 프로세스의 ID
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
