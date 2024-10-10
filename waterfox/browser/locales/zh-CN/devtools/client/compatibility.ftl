# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = 所选中元素
compatibility-all-elements-header = 所有问题

## Message used as labels for the type of issue

compatibility-issue-deprecated = (已弃用)
compatibility-issue-experimental = (实验性)
compatibility-issue-prefixneeded = (需加前缀)
compatibility-issue-deprecated-experimental = (已弃用，实验性)
compatibility-issue-deprecated-prefixneeded = (已弃用，需加前缀)
compatibility-issue-experimental-prefixneeded = (实验性，需加前缀)
compatibility-issue-deprecated-experimental-prefixneeded = (已弃用，实验性，需加前缀)

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = 设置
compatibility-settings-button-title =
    .title = 设置

## Messages used as headers in settings pane

compatibility-settings-header = 设置
compatibility-target-browsers-header = 目标浏览器

##

# Text used as the label for the number of nodes where the issue occurred
# Variables:
#   $number (Number) - The number of nodes where the issue occurred
compatibility-issue-occurrences =
    { $number ->
       *[other] 遇到 { $number } 个
    }

compatibility-no-issues-found = 未发现兼容性问题。
compatibility-close-settings-button =
    .title = 关闭设置

# Text used in the element containing the browser icons for a given compatibility issue.
# Line breaks are significant.
# Variables:
#   $browsers (String) - A line-separated list of browser information (e.g. Waterfox 98\nChrome 99).
compatibility-issue-browsers-list =
    .title =
        存在兼容性问题：
        { $browsers }
