# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tab-context-new-tab =
    .label = Новая вкладка
    .accesskey = я
reload-tab =
    .label = Обновить вкладку
    .accesskey = и
select-all-tabs =
    .label = Выбрать все вкладки
    .accesskey = б
duplicate-tab =
    .label = Дублировать вкладку
    .accesskey = л
duplicate-tabs =
    .label = Дублировать вкладки
    .accesskey = л
# The following string is displayed on a menuitem that will close the tabs from the start of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Left" and in right-to-left languages this should use "Right".
close-tabs-to-the-start =
    .label = Закрыть вкладки слева
    .accesskey = л
# The following string is displayed on a menuitem that will close the tabs from the end of the tabstrip to the currently targeted tab (excluding the currently targeted and any other selected tabs).
# In left-to-right languages this should use "Right" and in right-to-left languages this should use "Left".
close-tabs-to-the-end =
    .label = Закрыть вкладки справа
    .accesskey = п
close-other-tabs =
    .label = Закрыть другие вкладки
    .accesskey = ы
reload-tabs =
    .label = Обновить вкладки
    .accesskey = и
pin-tab =
    .label = Закрепить вкладку
    .accesskey = к
unpin-tab =
    .label = Открепить вкладку
    .accesskey = к
pin-selected-tabs =
    .label = Закрепить вкладки
    .accesskey = к
unpin-selected-tabs =
    .label = Открепить вкладки
    .accesskey = к
bookmark-selected-tabs =
    .label = Добавить вкладки в закладки…
    .accesskey = а
bookmark-tab =
    .label = Добавить вкладку в закладки
    .accesskey = а
reopen-in-container =
    .label = Переоткрыть в контейнере
    .accesskey = й
tab-context-open-in-new-container-tab =
    .label = Открыть в новой вкладке в контейнере
    .accesskey = к
move-to-start =
    .label = Переместить в начало
    .accesskey = ч
move-to-end =
    .label = Переместить в конец
    .accesskey = ц
move-to-new-window =
    .label = Переместить в новое окно
    .accesskey = е
tab-context-close-multiple-tabs =
    .label = Закрыть несколько вкладок
    .accesskey = ы
tab-context-undo-close-tabs =
    .label =
        Восстановить { $tabCount ->
            [1] закрытую вкладку
            [one] { $tabCount } закрытую вкладку
            [few] { $tabCount } закрытые вкладки
           *[many] { $tabCount } закрытых вкладок
        }
    .accesskey = о
close-tab =
    .label = Закрыть вкладку
    .accesskey = а
close-tabs =
    .label = Закрыть вкладки
    .accesskey = ы
move-tabs =
    .label = Переместить вкладки
    .accesskey = м
move-tab =
    .label = Переместить вкладку
    .accesskey = м
tab-context-share-url =
    .label = Поделиться
    .accesskey = д
tab-context-share-more =
    .label = Ещё…

## Variables:
##  $tabCount (Number): the number of tabs that are affected by the action.

tab-context-reopen-closed-tabs =
    .label =
        { $tabCount ->
            [1] Восстановить закрытую вкладку
            [one] Восстановить { $tabCount } закрытую вкладку
            [few] Восстановить { $tabCount } закрытые вкладки
           *[many] Восстановить { $tabCount } закрытых вкладок
        }
    .accesskey = о
tab-context-close-tabs =
    .label =
        Закрыть { $tabCount ->
            [1] вкладку
            [one] { $tabCount } вкладку
            [few] { $tabCount } вкладки
           *[many] { $tabCount } вкладок
        }
    .accesskey = ь
tab-context-move-tabs =
    .label =
        Переместить { $tabCount ->
            [1] вкладку
            [one] { $tabCount } вкладку
            [few] { $tabCount } вкладки
           *[many] { $tabCount } вкладок
        }
    .accesskey = м
