# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = タスクマネージャー

## Column headers

column-name = 名前
column-type = 種類
column-energy-impact = 消費電力への影響
column-memory = メモリー

## Special values for the Name column

ghost-windows = 最近閉じたタブ
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = プリロード: { $title }

## Values for the Type column

type-tab = タブ
type-subframe = サブフレーム
type-tracker = トラッカー
type-addon = アドオン
type-browser = ブラウザー
type-worker = Worker
type-other = その他

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = 高 ({ $value })
energy-impact-medium = 中 ({ $value })
energy-impact-low = 低 ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = タブを閉じます
show-addon =
    .title = アドオンマネージャーで表示します

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        読み込み後のディスパッチ数: { $totalDispatches } ({ $totalDuration }ms)
        最新 1 秒以内のディスパッチ数: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
