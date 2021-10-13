# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = 다음 찾기
findbar-previous =
    .tooltiptext = 이전 찾기

findbar-find-button-close =
    .tooltiptext = 찾기 표시줄 닫기

findbar-highlight-all2 =
    .label = 모두 강조 표시
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = 일치하는 모든 부분을 강조 표시합니다

findbar-case-sensitive =
    .label = 대/소문자 구분
    .accesskey = C
    .tooltiptext = 대문자와 소문자를 구분해서 검색합니다

findbar-match-diacritics =
    .label = 분음 부호 일치
    .accesskey = I
    .tooltiptext = 악센트 문자와 그 기본 문자를 구별합니다 (예: “resume”을 검색할 때 “résumé”는 일치하지 않음)

findbar-entire-word =
    .label = 단어 단위로
    .accesskey = w
    .tooltiptext = 단어 단위로 일치하는 경우만 검색합니다
