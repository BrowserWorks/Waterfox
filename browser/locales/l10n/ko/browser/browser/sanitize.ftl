# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

sanitize-prefs =
    .title = 기록 지우기 설정
    .style = width: 34em

sanitize-prefs-style =
    .style = width: 17em

dialog-title =
    .title = 최근 기록 지우기
    .style = width: 34em

# When "Time range to clear" is set to "Everything", this message is used for the
# title instead of dialog-title.
dialog-title-everything =
    .title = 모든 기록 지우기
    .style = width: 34em

clear-data-settings-label = 닫을 때, { -brand-short-name }가 자동으로 모두 지우기

## clear-time-duration-prefix is followed by a dropdown list, with
## values localized using clear-time-duration-value-* messages.
## clear-time-duration-suffix is left empty in English, but can be
## used in other languages to change the structure of the message.
##
## This results in English:
## Time range to clear: (Last Hour, Today, etc.)

clear-time-duration-prefix =
    .value = 지우는 시간 범위:{ " " }
    .accesskey = T

clear-time-duration-value-last-hour =
    .label = 최근 1시간

clear-time-duration-value-last-2-hours =
    .label = 최근 2시간

clear-time-duration-value-last-4-hours =
    .label = 최근 4시간

clear-time-duration-value-today =
    .label = 오늘

clear-time-duration-value-everything =
    .label = 전체

clear-time-duration-suffix =
    .value = { "" }

## These strings are used as section comments and checkboxes
## to select the items to remove

history-section-label = 기록

item-history-and-downloads =
    .label = 방문 및 다운로드 기록
    .accesskey = B

item-cookies =
    .label = 쿠키
    .accesskey = C

item-active-logins =
    .label = 활성 로그인
    .accesskey = L

item-cache =
    .label = 캐시
    .accesskey = a

item-form-search-history =
    .label = 양식 및 검색 기록
    .accesskey = F

data-section-label = 데이터

item-site-preferences =
    .label = 사이트 설정
    .accesskey = S

item-site-settings =
    .label = 사이트 설정
    .accesskey = S

item-offline-apps =
    .label = 오프라인 웹 데이터
    .accesskey = O

sanitize-everything-undo-warning = 이 작업은 취소할 수 없습니다.

window-close =
    .key = w

sanitize-button-ok =
    .label = 지금 지우기

# The label for the default button between the user clicking it and the window
# closing.  Indicates the items are being cleared.
sanitize-button-clearing =
    .label = 지우는 중

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has not modified the default set
# of history items to clear.
sanitize-everything-warning = 모든 기록이 지워집니다.

# Warning that appears when "Time range to clear" is set to "Everything" in Clear
# Recent History dialog, provided that the user has modified the default set of
# history items to clear.
sanitize-selected-warning = 모든 선택 항목이 지워집니다.
