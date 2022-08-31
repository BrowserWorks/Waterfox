# This Source Code Form is subject to the terms of the Waterfox Public
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
