# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Бетті қайта жүктеу
    .accesskey = й
select-all-tabs =
    .label = Барлық беттерді таңдау
    .accesskey = т
duplicate-tab =
    .label = Бетті қосарлау
    .accesskey = о
duplicate-tabs =
    .label = Беттерді қосарлау
    .accesskey = о
close-tabs-to-the-end =
    .label = Оң жақтан беттерді жабу
    .accesskey = О
close-other-tabs =
    .label = Басқа беттерді жабу
    .accesskey = с
reload-tabs =
    .label = Беттерді қайта жүктеу
    .accesskey = й
pin-tab =
    .label = Бетті бекіту
    .accesskey = к
unpin-tab =
    .label = Бетті босату
    .accesskey = Б
pin-selected-tabs =
    .label = Беттерді бекіту
    .accesskey = к
unpin-selected-tabs =
    .label = Беттерді босату
    .accesskey = б
bookmark-selected-tabs =
    .label = Беттерді бетбелгілерге қосу…
    .accesskey = г
bookmark-tab =
    .label = Бетті бетбелгілерге қосу
    .accesskey = б
reopen-in-container =
    .label = Контейнерде қайтадан ашу
    .accesskey = а
move-to-start =
    .label = Басына жылжыту
    .accesskey = с
move-to-end =
    .label = Соңына жылжыту
    .accesskey = н
move-to-new-window =
    .label = Жаңа терезеге жылжыту
    .accesskey = е
tab-context-close-multiple-tabs =
    .label = Бірнеше бетті жабу
    .accesskey = ш

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Жабылған бетті қайтару
           *[other] Жабылған беттерді қайтару
        }
    .accesskey = й
close-tab =
    .label = Бетті жабу
    .accesskey = Б
close-tabs =
    .label = Беттерді жабу
    .accesskey = б
move-tabs =
    .label = Беттерді жылжыту
    .accesskey = ы
move-tab =
    .label = Бетті жылжыту
    .accesskey = ы
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Бетті жабу
           *[other] Беттерді жабу
        }
    .accesskey = ж
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Бетті жылжыту
           *[other] Беттерді жылжыту
        }
    .accesskey = ы
