# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Page title
about-performance-title = Менеджар задач

## Column headers

column-name = Назва
column-type = Тып
column-energy-impact = Спажыванне энергіі
column-memory = Памяць

## Special values for the Name column

ghost-windows = Нядаўна закрытыя карткі
# Variables:
#   $title (String) - the title of the preloaded page, typically 'New Tab'
preloaded-tab = Перадзагружана: { $title }

## Values for the Type column

type-tab = Картка
type-subframe = Падфрэйм
type-tracker = Трэкер
type-addon = Дадатак
type-browser = Браўзер
type-worker = Worker
type-other = Іншае

## Values for the Energy Impact column
##
## Variables:
##   $value (Number) - Value of the energy impact, eg. 0.25 (low),
##                     5.38 (medium), 105.38 (high)

energy-impact-high = Высокае ({ $value })
energy-impact-medium = Сярэдняе ({ $value })
energy-impact-low = Нізкае ({ $value })

## Values for the Memory column
##
## Variables:
##   $value (Number) - How much memory is used

size-KB = { $value } КБ
size-MB = { $value } MB
size-GB = { $value } ГБ

## Tooltips for the action buttons

close-tab =
    .title = Закрыць картку
show-addon =
    .title = Паказаць у менеджары дадаткаў

# Tooltip when hovering an item of the about:performance table
# Variables:
#   $totalDispatches (Number) - how many dispatches occured for this page since it loaded
#   $totalDuration (Number) - how much CPU time was used by this page since it loaded
#   $dispatchesSincePrevious (Number) - how many dispatches occured in the last 2 seconds
#   $durationSincePrevious (Number) - how much CPU time was used in the last 2 seconds
item =
    .title =
        Рэсурсаў працэсара ад загрузкі выкарыстана: { $totalDispatches } ({ $totalDuration }мс)
        Рэсурсаў працэсара за апошнія секунды выкарыстана: { $dispatchesSincePrevious } ({ $durationSincePrevious }мс)
