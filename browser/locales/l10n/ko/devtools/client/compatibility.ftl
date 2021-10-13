# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = 선택된 요소
compatibility-all-elements-header = 모든 문제

## Message used as labels for the type of issue

compatibility-issue-deprecated = (사용되지 않음)
compatibility-issue-experimental = (실험적)
compatibility-issue-prefixneeded = (접두사 필요)
compatibility-issue-deprecated-experimental = (사용되지 않음, 실험적)

compatibility-issue-deprecated-prefixneeded = (사용되지 않음, 접두사 필요)
compatibility-issue-experimental-prefixneeded = (실험적, 접두사 필요)
compatibility-issue-deprecated-experimental-prefixneeded = (사용되지 않음, 실험적, 접두사 필요)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = 설정
compatibility-settings-button-title =
    .title = 설정
compatibility-feedback-button-label = 사용자 의견
compatibility-feedback-button-title =
    .title = 사용자 의견

## Messages used as headers in settings pane

compatibility-settings-header = 설정
compatibility-target-browsers-header = 대상 브라우저

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
       *[other] { $number }회
    }

compatibility-no-issues-found = 호환성 문제 없음.
compatibility-close-settings-button =
    .title = 설정 닫기
