# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = 인쇄
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = 다른 이름으로 저장

# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
       *[other] 용지 { $sheetCount }장
    }

printui-page-range-all = 모두
printui-page-range-custom = 사용자 지정
printui-page-range-label = 페이지
printui-page-range-picker =
    .aria-label = 페이지 범위 선택
printui-page-custom-range-input =
    .aria-label = 사용자 지정 페이지 범위 입력
    .placeholder = 예: 2-6, 9, 12-16

# Section title for the number of copies to print
printui-copies-label = 매수

printui-orientation = 방향
printui-landscape = 가로
printui-portrait = 세로

# Section title for the printer or destination device to target
printui-destination-label = 대상
printui-destination-pdf-label = PDF로 저장

printui-more-settings = 설정 자세히
printui-less-settings = 설정 간단히

printui-paper-size-label = 용지 크기

# Section title (noun) for the print scaling options
printui-scale = 배율
printui-scale-fit-to-page-width = 페이지 너비에 맞추기
# Label for input control where user can set the scale percentage
printui-scale-pcent = 배율

# Section title (noun) for the two-sided print options
printui-two-sided-printing = 양면 인쇄
printui-two-sided-printing-off = 끄기
# Flip the sheet as if it were bound along its long edge.
printui-two-sided-printing-long-edge = 긴 가장자리에서 뒤집기
# Flip the sheet as if it were bound along its short edge.
printui-two-sided-printing-short-edge = 짧은 가장자리에서 뒤집기

# Section title for miscellaneous print options
printui-options = 옵션
printui-headers-footers-checkbox = 머리글 및 바닥글 인쇄
printui-backgrounds-checkbox = 배경 인쇄

## The "Format" section, select a version of the website to print. Radio
## options to select between the original page, selected text only, or a version
## where the page is processed with "Reader View".

# The section title.
printui-source-label = 형식
# Option for printing the original page.
printui-source-radio = 원본
# Option for printing just the content a user selected prior to printing.
printui-selection-radio = 선택 영역
# Option for "simplifying" the page by printing the Reader View version.
printui-simplify-page-radio = 단순화

##

printui-color-mode-label = 색상 모드
printui-color-mode-color = 컬러
printui-color-mode-bw = 흑백

printui-margins = 여백
printui-margins-default = 기본값
printui-margins-min = 최소값
printui-margins-none = 없음
printui-margins-custom-inches = 사용자 정의 (인치)
printui-margins-custom-mm = 사용자 지정 (mm)
printui-margins-custom-top = 위쪽
printui-margins-custom-top-inches = 위쪽 (인치)
printui-margins-custom-top-mm = 위쪽 (mm)
printui-margins-custom-bottom = 아래쪽
printui-margins-custom-bottom-inches = 아래쪽 (인치)
printui-margins-custom-bottom-mm = 아래쪽 (mm)
printui-margins-custom-left = 왼쪽
printui-margins-custom-left-inches = 왼쪽 (인치)
printui-margins-custom-left-mm = 왼쪽 (mm)
printui-margins-custom-right = 오른쪽
printui-margins-custom-right-inches = 오른쪽 (인치)
printui-margins-custom-right-mm = 오른쪽 (mm)

printui-system-dialog-link = 시스템 대화 상자를 사용하여 인쇄…

printui-primary-button = 인쇄
printui-primary-button-save = 저장
printui-cancel-button = 취소
printui-close-button = 닫기

printui-loading = 미리보기 준비 중

# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = 인쇄 미리보기

printui-pages-per-sheet = 용지당 페이지

# This is shown next to the Print button with an indefinite loading spinner
# when the user prints a page and it is being sent to the printer.
printui-print-progress-indicator = 인쇄 중…
printui-print-progress-indicator-saving = 저장 중…

## Paper sizes that may be supported by the Save to PDF destination:

printui-paper-a5 = A5
printui-paper-a4 = A4
printui-paper-a3 = A3
printui-paper-a2 = A2
printui-paper-a1 = A1
printui-paper-a0 = A0
printui-paper-b5 = B5
printui-paper-b4 = B4
printui-paper-jis-b5 = JIS-B5
printui-paper-jis-b4 = JIS-B4
printui-paper-letter = US 레터
printui-paper-legal = US 리걸
printui-paper-tabloid = 타블로이드

## Error messages shown when a user has an invalid input

printui-error-invalid-scale = 배율은 10에서 200 사이의 숫자여야 합니다.
printui-error-invalid-margin = 선택한 용지 크기에 유효한 여백을 입력하세요.
printui-error-invalid-copies = 매수는 1에서 10000 사이의 숫자여야 합니다.

# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = 범위는 1에서 { $numPages } 사이의 숫자여야 합니다.
printui-error-invalid-start-overflow = "시작" 페이지 번호는 "끝" 페이지 번호보다 작아야 합니다.
