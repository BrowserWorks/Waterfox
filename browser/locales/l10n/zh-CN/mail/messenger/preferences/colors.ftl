# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = 颜色
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = 文字和背景

text-color-label =
    .value = 文字：
    .accesskey = T

background-color-label =
    .value = 背景：
    .accesskey = B

use-system-colors =
    .label = 使用系统颜色
    .accesskey = s

colors-link-legend = 链接颜色

link-color-label =
    .value = 未访问的链接：
    .accesskey = L

visited-link-color-label =
    .value = 已访问的链接：
    .accesskey = V

underline-link-checkbox =
    .label = 为链接添加下划线
    .accesskey = U

override-color-label =
    .value = 使用我在上面选择的颜色覆盖内容指定的颜色：
    .accesskey = O

override-color-always =
    .label = 一律

override-color-auto =
    .label = 仅在使用高对比度主题时

override-color-never =
    .label = 总不
