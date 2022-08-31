# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = 고급 환경 설정 기능
config-about-warning-text = 고급 설정을 변경하면 이 애플리케이션의 안정성, 보안 및 성능에 문제가 발생할 수 있습니다. 자신이 무엇을 하고 있는지 확실히 알고 있는 경우에만 계속해야 합니다.
config-about-warning-button =
    .label = 위험을 감수하겠습니다!
config-about-warning-checkbox =
    .label = 다음에 이 경고창 계속 보여 주기

config-search-prefs =
    .value = 검색:
    .accesskey = r

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = 설정 이름
config-lock-column =
    .label = 상태
config-type-column =
    .label = 유형
config-value-column =
    .label = 값

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = 정렬
config-column-chooser =
    .tooltip = 표시할 열을 선택하려면 누르세요

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = 복사
    .accesskey = C

config-copy-name =
    .label = 이름 복사
    .accesskey = N

config-copy-value =
    .label = 값 복사
    .accesskey = V

config-modify =
    .label = 수정
    .accesskey = M

config-toggle =
    .label = 설정/해제
    .accesskey = T

config-reset =
    .label = 초기화
    .accesskey = R

config-new =
    .label = 새로 만들기
    .accesskey = w

config-string =
    .label = 문자열
    .accesskey = S

config-integer =
    .label = 정수
    .accesskey = I

config-boolean =
    .label = 불린
    .accesskey = B

config-default = 기본
config-modified = 수정됨
config-locked = 잠금

config-property-string = 문자열
config-property-int = 정수
config-property-bool = 불린

config-new-prompt = 설정 이름을 입력하세요

config-nan-title = 유효하지 않는 값
config-nan-text = 입력한 문자가 숫자가 아닙니다.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = 새 { $type } 값

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = { $type } 값 입력
