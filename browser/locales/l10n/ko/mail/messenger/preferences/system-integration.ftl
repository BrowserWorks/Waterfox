# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = 시스템 통합
system-integration-dialog =
    .buttonlabelaccept = 기본으로 설정
    .buttonlabelcancel = 통합 미루기
    .buttonlabelcancel2 = 미루기
default-client-intro = { -brand-short-name }를 다음 항목의 기본 프로그램으로 사용:
unset-default-tooltip = { -brand-short-name }에서 { -brand-short-name }를 기본 클라이언트로 사용하지 않게 할 수 없습니다. 다른 어플리케이션을 기본으로 사용하려면 해당 어플리케이션의 '기본으로 설정' 창을 이용하세요.
checkbox-email-label =
    .label = 이메일
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = 뉴스 그룹
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = 피드
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = 달력
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }
system-search-integration-label =
    .label = 검색시 { system-search-engine-name } 엔진 사용 허가
    .accesskey = S
check-on-startup-label =
    .label = { -brand-short-name } 시작할 때 항상 확인
    .accesskey = A
