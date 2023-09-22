# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = 查找语句在页面中的下一个位置
findbar-previous =
    .tooltiptext = 查找语句在页面中的上一个位置

findbar-find-button-close =
    .tooltiptext = 关闭查找栏

findbar-highlight-all2 =
    .label = 高亮全部
    .accesskey =
        { PLATFORM() ->
            [macos] l
           *[other] a
        }
    .tooltiptext = 高亮显示语句在页面中的所有位置

findbar-case-sensitive =
    .label = 区分大小写
    .accesskey = c
    .tooltiptext = 以大小写敏感方式搜索

findbar-match-diacritics =
    .label = 匹配变音符号
    .accesskey = i
    .tooltiptext = 区分重音字母和它们的基本字母（如：在搜索“resume”时，不会匹配到“résumé”）

findbar-entire-word =
    .label = 全词匹配
    .accesskey = w
    .tooltiptext = 仅匹配由符号分隔开的整个词或句

findbar-not-found = 找不到指定文字

findbar-wrapped-to-top = 到达页尾，从页首继续
findbar-wrapped-to-bottom = 到达页首，从尾部继续

findbar-normal-find =
    .placeholder = 在此页面中查找
findbar-fast-find =
    .placeholder = 快速查找
findbar-fast-find-links =
    .placeholder = 快速查找（仅链接）

findbar-case-sensitive-status =
    .value = （区分大小写）
findbar-match-diacritics-status =
    .value = （匹配变音符号）
findbar-entire-word-status =
    .value = （仅匹配整个词或句）

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value = 第 { $current } 项，共找到 { $total } 个匹配项

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value = 匹配超过 { $limit } 项
