# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printpreview-simplify-page-checkbox =
    .label = 페이지 단순화
    .accesskey = i
    .tooltiptext = 이 페이지는 자동으로 단순화할 수 없습니다
printpreview-simplify-page-checkbox-enabled =
    .label = { printpreview-simplify-page-checkbox.label }
    .accesskey = { printpreview-simplify-page-checkbox.accesskey }
    .tooltiptext = 쉽게 읽을 수 있도록 레이아웃 변경
printpreview-close =
    .label = 닫기
    .accesskey = C
printpreview-portrait =
    .label = 세로
    .accesskey = o
printpreview-landscape =
    .label = 가로
    .accesskey = L
printpreview-scale =
    .value = 배율:
    .accesskey = S
printpreview-shrink-to-fit =
    .label = 페이지에 맞게 축소
printpreview-custom =
    .label = 사용자 지정…
printpreview-print =
    .label = 인쇄…
    .accesskey = P
printpreview-of =
    .value = /
printpreview-custom-scale-prompt-title = 사용자 지정 배율
printpreview-page-setup =
    .label = 페이지 설정…
    .accesskey = u
printpreview-page =
    .value = 페이지:
    .accesskey = a

# Variables
# $sheetNum (integer) - The current sheet number
# $sheetCount (integer) - The total number of sheets to print
printpreview-sheet-of-sheets = { $sheetNum } / { $sheetCount }

## Variables
## $percent (integer) - menuitem percent label
## $arrow (String) - UTF-8 arrow character for navigation buttons

printpreview-percentage-value =
    .label = { $percent }%
printpreview-homearrow =
    .label = { $arrow }
    .tooltiptext = 첫 페이지
printpreview-previousarrow =
    .label = { $arrow }
    .tooltiptext = 이전 페이지
printpreview-nextarrow =
    .label = { $arrow }
    .tooltiptext = 다음 페이지
printpreview-endarrow =
    .label = { $arrow }
    .tooltiptext = 마지막 페이지

printpreview-homearrow-button =
    .title = 첫 페이지
printpreview-previousarrow-button =
    .title = 이전 페이지
printpreview-nextarrow-button =
    .title = 다음 페이지
printpreview-endarrow-button =
    .title = 마지막 페이지
