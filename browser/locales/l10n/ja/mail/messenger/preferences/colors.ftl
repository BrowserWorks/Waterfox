# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

colors-dialog-window =
    .title = 配色
    .style =
        { PLATFORM() ->
            [macos] width: 41em !important
           *[other] width: 38em !important
        }
colors-dialog-legend = テキストと背景の色
text-color-label =
    .value = テキスト:
    .accesskey = T
background-color-label =
    .value = 背景:
    .accesskey = B
use-system-colors =
    .label = システムの配色を使用する
    .accesskey = s
colors-link-legend = リンクの色
link-color-label =
    .value = 未訪問リンク:
    .accesskey = L
visited-link-color-label =
    .value = 訪問済リンク:
    .accesskey = V
underline-link-checkbox =
    .label = リンクに下線を表示する
    .accesskey = U
override-color-label =
    .value = ウェブページに指定された配色を上記の設定に変更する:
    .accesskey = O
override-color-always =
    .label = 常に変更する
override-color-auto =
    .label = 高コントラストテーマ使用時のみ変更する
override-color-never =
    .label = 変更しない
