# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = 色彩
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }

colors-dialog-legend = 文字與背景

text-color-label =
    .value = 文字:
    .accesskey = t

background-color-label =
    .value = 背景:
    .accesskey = b

use-system-colors =
    .label = 使用系統色彩
    .accesskey = s

colors-link-legend = 鏈結色彩

link-color-label =
    .value = 未拜訪鏈結:
    .accesskey = l

visited-link-color-label =
    .value = 已拜訪鏈結:
    .accesskey = v

underline-link-checkbox =
    .label = 鏈結加底線
    .accesskey = u

override-color-label =
    .value = 使用我在上面的選擇蓋過內容指定的色彩:
    .accesskey = O

override-color-always =
    .label = 總是

override-color-auto =
    .label = 僅在使用高對比佈景主題時

override-color-never =
    .label = 永不
