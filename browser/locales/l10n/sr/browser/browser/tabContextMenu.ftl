# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

reload-tab =
    .label = Обнови језичак
    .accesskey = О
select-all-tabs =
    .label = Изабери све језичке
    .accesskey = И
duplicate-tab =
    .label = Удвостручи језичак
    .accesskey = д
duplicate-tabs =
    .label = Удвостручи језичке
    .accesskey = д
close-tabs-to-the-end =
    .label = Затвори језичке удесно
    .accesskey = д
close-other-tabs =
    .label = Затвори остале језичке
    .accesskey = З
reload-tabs =
    .label = Поново учитај језичке
    .accesskey = П
pin-tab =
    .label = Закачи језичак
    .accesskey = а
unpin-tab =
    .label = Откачи језичак
    .accesskey = т
pin-selected-tabs =
    .label = Закачи језичке
    .accesskey = З
unpin-selected-tabs =
    .label = Откачи језичке
    .accesskey = О
bookmark-selected-tabs =
    .label = Јежичци забелешки…
    .accesskey = ж
bookmark-tab =
    .label = Забележи језичак
    .accesskey = б
reopen-in-container =
    .label = Поново отвори у контејнеру
    .accesskey = о
move-to-start =
    .label = Помери на почетак
    .accesskey = о
move-to-end =
    .label = Помери на крај
    .accesskey = к
move-to-new-window =
    .label = Премести у нови прозор
    .accesskey = н
tab-context-close-multiple-tabs =
    .label = Затвори вишеструке језичке
    .accesskey = M

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-undo-close-tabs =
    .label =
        { $tabCount ->
            [1] Врати затворене језичке
            [one] Врати затворен језичак
            [few] Врати затворена језичка
           *[other] Врати затворених језичака
        }
    .accesskey = U
close-tab =
    .label = Затвори језичак
    .accesskey = ч
close-tabs =
    .label = Затвори језичке
    .accesskey = З
move-tabs =
    .label = Помери језичке
    .accesskey = м
move-tab =
    .label = Помери језичак
    .accesskey = м
tab-context-close-tabs =
    .label =
        { $tabCount ->
            [1] Затвори језичак
            [one] Затвори језичак
            [few] Затвори језичка
           *[other] Затвори језичака
        }
    .accesskey = C
tab-context-move-tabs =
    .label =
        { $tabCount ->
            [1] Помери језичак
            [one] Помери језичак
            [few] Помери језичка
           *[other] Помери језичака
        }
    .accesskey = v
