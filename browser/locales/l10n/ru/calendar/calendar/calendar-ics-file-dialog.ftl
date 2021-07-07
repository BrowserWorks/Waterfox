# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

calendar-ics-file-window-2 =
    .title = Импорт событий и задач календаря
calendar-ics-file-dialog-import-event-button-label = Импортировать событие
calendar-ics-file-dialog-import-task-button-label = Импортировать задачу
calendar-ics-file-dialog-2 =
    .buttonlabelaccept = Импортировать всё
calendar-ics-file-accept-button-ok-label = OK
calendar-ics-file-cancel-button-close-label = Закрыть
calendar-ics-file-dialog-message-2 = Импорт из файла:
calendar-ics-file-dialog-calendar-menu-label = Импорт в календарь:
calendar-ics-file-dialog-items-loading-message =
    .value = Загрузка элементов…
calendar-ics-file-dialog-search-input =
    .placeholder = Фильтр элементов…
calendar-ics-file-dialog-sort-start-ascending =
    .label = Сортировать по дате начала (от первого до последнего)
calendar-ics-file-dialog-sort-start-descending =
    .label = Сортировать по дате начала (от последнего до первого)
# "A > Z" is used as a concise way to say "alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-ascending =
    .label = Сортировать в алфавитном порядке
# "Z > A" is used as a concise way to say "reverse alphabetical order".
# You may replace it with something appropriate to your language.
calendar-ics-file-dialog-sort-title-descending =
    .label = Сортировать в обратном алфавитном порядке
calendar-ics-file-dialog-progress-message = Идёт импорт…
calendar-ics-file-import-success = Импорт успешно произведён!
calendar-ics-file-import-error = Произошла ошибка, импорт выполнить не удалось.
calendar-ics-file-import-complete = Импорт завершён.
calendar-ics-file-import-duplicates =
    { $duplicatesCount ->
        [1] Проигнорирован один элемент, так как он уже есть в календаре.
        [one] Проигнорирован { $duplicatesCount } элемент, так как он уже есть в календаре.
        [few] Проигнорировано { $duplicatesCount } элемента, так как они уже есть в календаре.
       *[many] Проигнорировано { $duplicatesCount } элементов, так как они уже есть в календаре.
    }
calendar-ics-file-import-errors =
    { $errorsCount ->
        [1] Не удалось импортировать один элемент. Посмотрите подробности в Консоли ошибок.
        [one] Не удалось импортировать { $errorsCount } элемент. Посмотрите подробности в Консоли ошибок.
        [few] Не удалось импортировать { $errorsCount } элемента. Посмотрите подробности в Консоли ошибок.
       *[many] Не удалось импортировать { $errorsCount } элементов. Посмотрите подробности в Консоли ошибок.
    }
calendar-ics-file-dialog-no-calendars = Ни в один календарь нельзя импортировать события или задачи.
