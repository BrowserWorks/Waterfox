# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

about-telemetry-ping-data-source = 핑 데이터 소스:
about-telemetry-show-current-data = 현재 데이터
about-telemetry-show-archived-ping-data = 저장된 핑 데이터
about-telemetry-show-subsession-data = 하위 세션 데이터 보기
about-telemetry-choose-ping = 핑 선택:
about-telemetry-archive-ping-type = 핑 유형
about-telemetry-archive-ping-header = 핑
about-telemetry-option-group-today = 오늘
about-telemetry-option-group-yesterday = 어제
about-telemetry-option-group-older = 이전
about-telemetry-previous-ping = <<
about-telemetry-next-ping = >>
about-telemetry-page-title = Telemetry 데이터
about-telemetry-current-store = 현재 저장소:
about-telemetry-more-information = 자세한 정보를 찾고 계십니까?
about-telemetry-firefox-data-doc = <a data-l10n-name="data-doc-link">Waterfox 데이터 문서</a>에 데이터 도구를 사용하는 방법에 대한 안내서가 포함되어 있습니다.
about-telemetry-telemetry-client-doc = <a data-l10n-name="client-doc-link">Waterfox Telemetry 클라이언트 문서</a>에 개요, API 문서 및 데이터 참조에 대한 정의가 포함되어 있습니다.
about-telemetry-telemetry-dashboard = <a data-l10n-name="dashboard-link">Telemetry 대시보드</a>를 사용하면 Telemetry를 통해 Waterfox가 받는 데이터를 시각화 할 수 있습니다.
about-telemetry-telemetry-probe-dictionary = <a data-l10n-name="probe-dictionary-link">프로브 사전</a>은 Telemetry에 의해 수집된 조사 내용에 대한 상세 정보와 설명을 제공합니다.
about-telemetry-show-in-Waterfox-json-viewer = JSON 뷰어에서 열기
about-telemetry-home-section = 홈
about-telemetry-general-data-section = 일반 데이터
about-telemetry-environment-data-section = 환경 데이터
about-telemetry-session-info-section = 세션 정보
about-telemetry-scalar-section = 스칼라
about-telemetry-keyed-scalar-section = 키 스칼라
about-telemetry-histograms-section = 히스토그램
about-telemetry-keyed-histogram-section = 키가 들어간 히스토그램
about-telemetry-events-section = 이벤트
about-telemetry-simple-measurements-section = 단순 측정
about-telemetry-slow-sql-section = 느린 SQL 문
about-telemetry-addon-details-section = 부가 기능 상세 정보
about-telemetry-captured-stacks-section = 스택 캡처
about-telemetry-late-writes-section = 최종 작성
about-telemetry-raw-payload-section = 원시 페이로드
about-telemetry-raw = 원시 JSON
about-telemetry-full-sql-warning = 참고: 느린 SQL 디버깅이 활성화 되어 있습니다. 전체 SQL 문자열이 아래에 표시될 수 있지만 Telemetry에 제출되지는 않습니다.
about-telemetry-fetch-stack-symbols = 스택에 대한 함수 이름 가져오기
about-telemetry-hide-stack-symbols = 원시 스택 데이터 보기
# Selects the correct release version
# Variables:
#   $channel (String): represents the corresponding release data string
about-telemetry-data-type =
    { $channel ->
        [release] 정식판 데이터
       *[prerelease] 시험판 데이터
    }
# Selects the correct upload string
# Variables:
#   $uploadcase (String): represents a corresponding upload string
about-telemetry-upload-type =
    { $uploadcase ->
        [enabled] 활성화됨
       *[disabled] 비활성화됨
    }
# Example Output: 1 sample, average = 0, sum = 0
# Variables:
#   $sampleCount (Integer): amount of histogram samples
#   $prettyAverage (Integer): average of histogram samples
#   $sum (Integer): sum of histogram samples
about-telemetry-histogram-stats =
    { $sampleCount ->
       *[other] { $sampleCount } 샘플, 평균 = { $prettyAverage }, 합계 = { $sum }
    }
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-page-subtitle = 이 페이지는 Telemetry에 의해서 수집된 성능, 하드웨어, 사용 현황 및 사용자 정의에 대한 정보를 표시합니다. 이 정보는 { -brand-full-name }의 개선을 위해 { $telemetryServerOwner }에 제출됩니다.
about-telemetry-settings-explanation = Telemetry가 { about-telemetry-data-type }를 수집 중이며 업로드는 <a data-l10n-name="upload-link">{ about-telemetry-upload-type }</a>입니다.
# Variables:
#   $name (String): ping name, e.g. “saved-session”
#   $timeStamp (String): ping localized timestamp, e.g. “2017/07/08 10:40:46”
about-telemetry-ping-details = 각 정보 조각들은 “<a data-l10n-name="ping-link">핑</a>“로 번들되어 보내집니다. 지금은 { $name }, { $timestamp } 핑을 보고 있습니다.
about-telemetry-data-details-current = 각 정보는 "<a data-l10n-name="ping-link">핑</a>"에 묶여 전송됩니다. 현재의 데이터를 보고 계십니다.
# string used as a placeholder for the search field
# More info about it can be found here:
# https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $selectedTitle (String): the section name from the structure of the ping.
about-telemetry-filter-placeholder =
    .placeholder = { $selectedTitle }에서 찾기
about-telemetry-filter-all-placeholder =
    .placeholder = 모든 섹션에서 찾기
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-results-for-search = “{ $searchTerms }”에 대한 결과
# More info about it can be found here: https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/data/main-ping.html
# Variables:
#   $sectionName (String): the section name from the structure of the ping.
#   $currentSearchText (String): the current text in the search input
about-telemetry-no-search-results = 죄송합니다! { $sectionName }에 “{ $currentSearchText }”에 대한 결과가 없습니다.
# Variables:
#   $searchTerms (String): the searched terms
about-telemetry-no-search-results-all = 죄송합니다! “{ $searchTerms }”에 대한 섹션 결과가 없습니다.
# This message is displayed when a section is empty.
# Variables:
#   $sectionName (String): is replaced by the section name.
about-telemetry-no-data-to-display = 죄송합니다! “{ $sectionName }”에 현재 데이터가 없습니다.
# used as a tooltip for the “current” ping title in the sidebar
about-telemetry-current-data-sidebar = 현재 데이터
# used in the “Ping Type” select
about-telemetry-telemetry-ping-type-all = 모두
# button label to copy the histogram
about-telemetry-histogram-copy = 복사
# these strings are used in the “Slow SQL Statements” section
about-telemetry-slow-sql-main = 주 스레드에서 느린 SQL 문
about-telemetry-slow-sql-other = 헬퍼 스레드에서 느린 SQL 문
about-telemetry-slow-sql-hits = 횟수
about-telemetry-slow-sql-average = 평균 시간(ms)
about-telemetry-slow-sql-statement = 문
# these strings are used in the “Add-on Details” section
about-telemetry-addon-table-id = 부가 기능 ID
about-telemetry-addon-table-details = 상세 정보
# Variables:
#   $addonProvider (String): the name of an Add-on Provider (e.g. “XPI”, “Plugin”)
about-telemetry-addon-provider = { $addonProvider } 공급자
about-telemetry-keys-header = 속성
about-telemetry-names-header = 이름
about-telemetry-values-header = 값
# Variables:
#   $stackKey (String): the string key for this stack
#   $capturedStacksCount (Integer):  the number of times this stack was captured
about-telemetry-captured-stacks-title = { $stackKey } (캡쳐 수: { $capturedStacksCount })
# Variables:
#   $lateWriteCount (Integer): the number of the late writes
about-telemetry-late-writes-title = 최종 작성- #{ $lateWriteCount }번
about-telemetry-stack-title = 스택:
about-telemetry-memory-map-title = 메모리 맵:
about-telemetry-error-fetching-symbols = 심볼을 가져오는데 오류가 생겼습니다. 인터넷 연결을 확인해 보시고 다시 시도하세요.
about-telemetry-time-stamp-header = 타임스탬프
about-telemetry-category-header = 카테고리
about-telemetry-method-header = 메서드
about-telemetry-object-header = 객체
about-telemetry-extra-header = 추가
about-telemetry-origin-section = Origin Telemetry
about-telemetry-origin-origin = origin
about-telemetry-origin-count = 개수
# Variables:
#   $telemetryServerOwner (String): the value of the toolkit.telemetry.server_owner preference. Typically "Waterfox"
about-telemetry-origins-explanation = <a data-l10n-name="origin-doc-link">Waterfox Origin Telemetry</a>는 전송되기 전에 데이터를 인코딩하여 { $telemetryServerOwner }가 항목의 수를 셀 수는 있지만, 주어진 { -brand-product-name }가 해당 카운트에 기여했는지 여부는 알 수 없습니다. (<a data-l10n-name="prio-blog-link">더 알아보기</a>)
# Variables:
#  $process (String): type of process in subsection headers ( e.g. "content", "parent" )
about-telemetry-process = { $process } 프로세스
