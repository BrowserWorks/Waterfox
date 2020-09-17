# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Диспетчер задач

## Column headers

column-name = Название
column-type = Тип
column-energy-impact = Расход энергии
column-memory = Память

## Special values for the Name column

ghost-windows = Недавно закрытые вкладки
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Предзагружено: { $title }

## Values for the Type column

type-tab = Вкладка
type-subframe = Подфрейм
type-tracker = Трекер
type-addon = Дополнение
type-browser = Браузер
type-worker = Worker
type-other = Другое

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Высокий ({ $value })
energy-impact-medium = Средний ({ $value })
energy-impact-low = Низкий ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } КБ
size-MB = { $value } МБ
size-GB = { $value } ГБ

## Tooltips for the action buttons

close-tab =
    .title = Закрыть вкладку
show-addon =
    .title = Показать в менеджере дополнений

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title = Ресурсов процессора с момента загрузки использовано: { $totalDispatches } ({ $totalDuration }мс) Ресурсов процессора за последние секунды использовано: { $dispatchesSincePrevious } ({ $durationSincePrevious }мс)
