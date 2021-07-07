# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Messages used as headers in the main pane

compatibility-selected-element-header = 所选中元素
compatibility-all-elements-header = 所有问题

## Message used as labels for the type of issue

compatibility-issue-deprecated = （不赞成使用）
compatibility-issue-experimental = （实验性）
compatibility-issue-prefixneeded = （需要前缀）
compatibility-issue-deprecated-experimental = （不赞成使用，实验性）
compatibility-issue-deprecated-prefixneeded = （不赞成使用，需要前缀）
compatibility-issue-experimental-prefixneeded = （实验性，需要前缀）
compatibility-issue-deprecated-experimental-prefixneeded = （不赞成使用、实验性，需要前缀）

## Messages used as labels and titles for buttons in the footer

compatibility-settings-button-label = 设置
compatibility-settings-button-title =
    .title = 设置
compatibility-feedback-button-label = 反馈
compatibility-feedback-button-title =
    .title = 反馈

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
