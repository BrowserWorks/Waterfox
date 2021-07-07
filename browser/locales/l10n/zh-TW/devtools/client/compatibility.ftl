# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = 選擇的元素
compatibility-all-elements-header = 所有問題

## Message used as labels for the type of issue

compatibility-issue-deprecated = （已棄用）
compatibility-issue-experimental = （實驗中）
compatibility-issue-prefixneeded = （需要前綴）
compatibility-issue-deprecated-experimental = （已棄用、實驗中）
compatibility-issue-deprecated-prefixneeded = （已棄用、需要前綴）
compatibility-issue-experimental-prefixneeded = （實驗中、需要前綴）
compatibility-issue-deprecated-experimental-prefixneeded = （已棄用、實驗中、需要前綴）

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = 設定
compatibility-settings-button-title =
    .title = 設定
compatibility-feedback-button-label = 意見回饋
compatibility-feedback-button-title =
    .title = 意見回饋

## Messages used as headers in settings pane

compatibility-settings-header = 設定
compatibility-target-browsers-header = 目標瀏覽器

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
       *[other] 發生 { $number } 次
    }

compatibility-no-issues-found = 找不到相容性問題。
compatibility-close-settings-button =
    .title = 關閉設定
