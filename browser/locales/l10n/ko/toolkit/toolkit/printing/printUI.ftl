# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

printui-title = 인쇄
# Dialog title to prompt the user for a filename to save print to PDF.
printui-save-to-pdf-title = 다른 이름으로 저장
# Variables
# $sheetCount (integer) - Number of paper sheets
printui-sheets-count =
    { $sheetCount ->
       *[other] 용지 { $sheetCount } 장
    }
printui-page-range-all = 모두
printui-page-range-custom = 사용자 지정
printui-page-range-label = 페이지
printui-page-range-picker =
    .aria-label = 페이지 범위 선택
printui-page-custom-range =
    .aria-label = 사용자 지정 페이지 범위 입력
# This label is displayed before the first input field indicating
# the start of the range to print.
printui-range-start = 시작:
# This label is displayed between the input fields indicating
# the start and end page of the range to print.
printui-range-end = 끝:
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
printui-scale-fit-to-page = 페이지에 맞추기
printui-scale-fit-to-page-width = 페이지 너비에 맞추기
# Label for input control where user can set the scale percentage
printui-scale-pcent = 배율
# Section title for miscellaneous print options
printui-options = 옵션
printui-headers-footers-checkbox = 머리글 및 바닥글 인쇄
printui-backgrounds-checkbox = 배경 인쇄
printui-color-mode-label = 색상 모드
printui-color-mode-color = 컬러
printui-color-mode-bw = 흑백
printui-margins = 여백
printui-margins-default = 기본값
printui-margins-min = 최소값
printui-margins-none = 없음
printui-system-dialog-link = 시스템 대화 상자를 사용하여 인쇄…
printui-primary-button = 인쇄
printui-primary-button-save = 저장
printui-cancel-button = 취소
printui-loading = 미리보기 준비 중
# Reported by screen readers and other accessibility tools to indicate that
# the print preview has focus.
printui-preview-label =
    .aria-label = 인쇄 미리보기

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
# Variables
# $numPages (integer) - Number of pages
printui-error-invalid-range = 범위는 1에서 { $numPages } 사이의 숫자여야 합니다.
printui-error-invalid-start-overflow = "시작" 페이지 번호는 "끝" 페이지 번호보다 작아야 합니다.
