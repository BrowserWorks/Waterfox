# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Тапсырмалар басқарушысы

## Column headers

column-name = Атауы
column-type = Түрі
column-energy-impact = Энергияның әсері
column-memory = Жады

## Special values for the Name column

ghost-windows = Жақында жабылған беттер
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Алдын ала жүктелген: { $title }

## Values for the Type column

type-tab = Бет
type-subframe = Субфрейм
type-tracker = Трекер
type-addon = Қосымша
type-browser = Браузер
type-worker = Жұмыс үрдісі
type-other = Басқа

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Жоғары ({ $value })
energy-impact-medium = Орташа ({ $value })
energy-impact-low = Төмен ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } КБ
size-MB = { $value } МБ
size-GB = { $value } ГБ

## Tooltips for the action buttons

close-tab =
    .title = Бетті жабу
show-addon =
    .title = Қосымшалар басқарушысында көрсету

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Жүктелуден кейін қолданылған процессор ресурстары: { $totalDispatches } ({ $totalDuration }мс)
        Соңғы секундтарда қолданылған процессор ресурстары: { $dispatchesSincePrevious } ({ $durationSincePrevious }мс)
