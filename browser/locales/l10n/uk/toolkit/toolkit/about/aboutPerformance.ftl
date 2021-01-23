# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Диспетчер завдань

## Column headers

column-name = Назва
column-type = Тип
column-energy-impact = Споживання енергії
column-memory = Пам'ять

## Special values for the Name column

ghost-windows = Недавно закриті вкладки
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Попередньо завантажено: { $title }

## Values for the Type column

type-tab = Вкладка
type-subframe = Підфрейм
type-tracker = Елемент стеження
type-addon = Додаток
type-browser = Браузер
type-worker = Worker
type-other = Інше

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Високе ({ $value })
energy-impact-medium = Середнє ({ $value })
energy-impact-low = Низьке ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } КБ
size-MB = { $value } МБ
size-GB = { $value } ГБ

## Tooltips for the action buttons

close-tab =
    .title = Закрити вкладку
show-addon =
    .title = Показати в менеджері додатків

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Відправлень після завантаження: { $totalDispatches } ({ $totalDuration } мс)
        Відправлень в останні секунди: { $dispatchesSincePrevious } ({ $durationSincePrevious } мс)
