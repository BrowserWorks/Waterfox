# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings are used for errors when installing OpenSearch engines, e.g.
## via "Add Search Engine" on the address bar or search bar.
## Variables
## $location-url (String) - the URL of the OpenSearch engine that was attempted to be installed.

opensearch-error-duplicate-title = 설치 오류
opensearch-error-duplicate-desc = { -brand-short-name }는 같은 이름을 가진 검색 플러그인이 있으므로 "{ $location-url }"를 설치할 수 없습니다.

opensearch-error-format-title = 잘못된 형식
opensearch-error-format-desc = { -brand-short-name }가 다음 검색 엔진을 설치하지 못했습니다: { $location-url }

opensearch-error-download-title = 다운로드 오류
opensearch-error-download-desc = { -brand-short-name }가 검색 플러그인을 다운로드할 수 없습니다. 위치: { $location-url }

##

searchbar-submit =
    .tooltiptext = 검색하기

# This string is displayed in the search box when the input field is empty
searchbar-input =
    .placeholder = 검색

searchbar-icon =
    .tooltiptext = 검색

## Infobar shown when search engine is removed and replaced.
## Variables
## $oldEngine (String) - the search engine to be removed.
## $newEngine (String) - the search engine to replace the removed search engine.

removed-search-engine-message = <strong>기본 검색 엔진이 변경되었습니다.</strong> { $oldEngine } 검색 엔진은 { -brand-short-name }에서 더 이상 기본 검색 엔진으로 사용할 수 없습니다. { $newEngine } 검색 엔진이 이제 기본 검색 엔진입니다. 다른 기본 검색 엔진으로 변경하려면 설정으로 이동하세요. <label data-l10n-name="remove-search-engine-article">더 알아보기</label>
remove-search-engine-button = 확인
