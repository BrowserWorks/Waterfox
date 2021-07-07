# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = 任务管理器

## Column headers

column-name = 名称
column-type = 类型
column-energy-impact = 能耗影响
column-memory = 内存

## Special values for the Name column

ghost-windows = 最近关闭的标签页
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = 预先载入：{ $title }

## Values for the Type column

type-tab = 标签页
type-subframe = 子框架
type-tracker = 跟踪器
type-addon = 附加组件
type-browser = 浏览器
type-worker = Worker
type-other = 其他

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
    .title = 关闭标签页
show-addon =
    .title = 在附加组件管理器中显示

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        载入以来调度：{ $totalDispatches } 次 ({ $totalDuration }ms)
        最近几秒调度：{ $dispatchesSincePrevious } 次 ({ $durationSincePrevious }ms)
