# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = 尋找文字下次出現的位置
findbar-previous =
    .tooltiptext = 尋找文字前次出現的位置

findbar-find-button-close =
    .tooltiptext = 關閉尋找列

findbar-highlight-all2 =
    .label = 強調全部
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = 強調全部出現的詞彙

findbar-case-sensitive =
    .label = 符合大小寫
    .accesskey = c
    .tooltiptext = 搜尋時將大小寫視為不同

findbar-match-diacritics =
    .label = 符合變音符號
    .accesskey = i
    .tooltiptext = 搜尋的字母包含變音符號時，將不同變音符號與基礎字母視為不同。（例如搜尋「resume」，若內容為「résumé」就不會符合）

findbar-entire-word =
    .label = 整個文字
    .accesskey = w
    .tooltiptext = 僅搜尋整個文字

findbar-not-found = 找不到指定文字

findbar-wrapped-to-top = 已達頁尾，從頁首重新搜尋
findbar-wrapped-to-bottom = 已達頁首，從頁尾重新搜尋

findbar-normal-find =
    .placeholder = 在頁面中搜尋
findbar-fast-find =
    .placeholder = 快速尋找
findbar-fast-find-links =
    .placeholder = 快速尋找 (僅鏈結)

findbar-case-sensitive-status =
    .value = （區分大小寫）
findbar-match-diacritics-status =
    .value = （變音符號需符合）
findbar-entire-word-status =
    .value = （僅整個字）

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value = 第 { $current } 筆符合，共符合 { $total } 筆

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value = 符合超過 { $limit } 項
