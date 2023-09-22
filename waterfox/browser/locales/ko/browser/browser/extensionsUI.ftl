# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webext-perms-learn-more = 더 알아보기
# Variables:
#   $addonName (String): localized named of the extension that is asking to change the default search engine.
#   $currentEngine (String): name of the current search engine.
#   $newEngine (String): name of the new search engine.
webext-default-search-description = { $addonName } 확장 기능이 기본 검색 엔진을 { $currentEngine }에서 { $newEngine }(으)로 변경하려고 합니다. 괜찮습니까?
webext-default-search-yes =
    .label = 예
    .accesskey = Y
webext-default-search-no =
    .label = 아니요
    .accesskey = N
# Variables:
#   $addonName (String): localized named of the extension that was just installed.
addon-post-install-message = { $addonName } 확장 기능이 추가되었습니다.

## A modal confirmation dialog to allow an extension on quarantined domains.

# Variables:
#   $addonName (String): localized name of the extension.
webext-quarantine-confirmation-title = 제한된 사이트에서 { $addonName } 확장 기능을 실행하시겠습니까?
webext-quarantine-confirmation-line-1 = 데이터 보호를 위해 이 사이트에서 이 확장 기능이 허용되지 않습니다.
webext-quarantine-confirmation-line-2 = { -vendor-short-name }에 의해 제한된 사이트에서 이 확장 기능이 데이터를 읽고 변경하는 것을 신뢰한다면 허용하세요.
webext-quarantine-confirmation-allow =
    .label = 허용
    .accesskey = A
webext-quarantine-confirmation-deny =
    .label = 허용 안 함
    .accesskey = D
