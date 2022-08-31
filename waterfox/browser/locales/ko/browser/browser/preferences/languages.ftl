# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

webpage-languages-window =
    .title = 웹 페이지 언어 설정
    .style = width: 40em

languages-close-key =
    .key = w

languages-description = 웹 페이지는 여러 언어로 제공되는 경우가 있습니다. 이런 웹 페이지를 표시할 언어를 선호하는 순서대로 선택하세요

languages-customize-spoof-english =
    .label = 향상된 개인 정보 보호를 위해 웹 페이지의 영어 버전을 요청하기

languages-customize-moveup =
    .label = 위로 이동
    .accesskey = U

languages-customize-movedown =
    .label = 아래로 이동
    .accesskey = D

languages-customize-remove =
    .label = 제거
    .accesskey = R

languages-customize-select-language =
    .placeholder = 추가할 언어 선택…

languages-customize-add =
    .label = 추가
    .accesskey = A

# The pattern used to generate strings presented to the user in the
# locale selection list.
#
# Example:
#   Icelandic [is]
#   Spanish (Chile) [es-CL]
#
# Variables:
#   $locale (String) - A name of the locale (for example: "Icelandic", "Spanish (Chile)")
#   $code (String) - Locale code of the locale (for example: "is", "es-CL")
languages-code-format =
    .label = { $locale }  [{ $code }]

languages-active-code-format =
    .value = { languages-code-format.label }

browser-languages-window =
    .title = { -brand-short-name } 언어 설정
    .style = width: 40em

browser-languages-description = { -brand-short-name }가 첫번째 언어를 기본 언어로 표시하고 필요한 경우 순서대로 대체 언어를 표시합니다.

browser-languages-search = 다른 언어 검색…

browser-languages-searching =
    .label = 언어 검색 중…

browser-languages-downloading =
    .label = 다운로드 중…

browser-languages-select-language =
    .label = 추가할 언어 선택…
    .placeholder = 추가할 언어 선택…

browser-languages-installed-label = 설치된 언어
browser-languages-available-label = 사용 가능한 언어

browser-languages-error = { -brand-short-name }가 지금 언어를 업데이트할 수 없습니다. 인터넷에 연결되어 있는지 확인하거나 다시 시도하세요.
