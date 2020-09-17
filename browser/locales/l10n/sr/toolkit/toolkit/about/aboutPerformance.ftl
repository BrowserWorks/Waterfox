# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Управник задатака

## Column headers

column-name = Назив
column-type = Врста
column-energy-impact = Потрошња енергије
column-memory = Меморија

## Special values for the Name column

ghost-windows = Недавно затворене картице
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Претходно учитано: { $title }

## Values for the Type column

type-tab = Језичак
type-subframe = Подоквир
type-tracker = Праћење
type-addon = Додатак
type-browser = Прегледач
type-worker = Радник
type-other = Друго

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Високо ({ $value })
energy-impact-medium = Средње ({ $value })
energy-impact-low = Ниско ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } KB
size-MB = { $value } MB
size-GB = { $value } GB

## Tooltips for the action buttons

close-tab =
    .title = Затвори картицу
show-addon =
    .title = Прикажи у управнику додатака

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occurred for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occurred in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Пошиљке од учитавања: { $totalDispatches } ({ $totalDuration }ms)
        Пошиљке у последњим секундама: { $dispatchesSincePrevious } ({ $durationSincePrevious }ms)
