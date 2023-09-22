# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

tabbrowser-empty-tab-title = Новая вкладка
tabbrowser-empty-private-tab-title = Новая приватная вкладка

tabbrowser-menuitem-close-tab =
    .label = Закрыть вкладку
tabbrowser-menuitem-close =
    .label = Закрыть

# Displayed as a tooltip on container tabs
# Variables:
#   $title (String): the title of the current tab.
#   $containerName (String): the name of the current container.
tabbrowser-container-tab-title = { $title } — { $containerName }

# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-close-tabs-tooltip =
    .label =
        { $tabCount ->
            [one] Закрыть { $tabCount } вкладку
            [few] Закрыть { $tabCount } вкладки
           *[many] Закрыть { $tabCount } вкладок
        }

## Tooltips for tab audio control
## Variables:
##   $tabCount (Number): The number of tabs that will be affected.

# Variables:
#   $shortcut (String): The keyboard shortcut for "Mute tab".
tabbrowser-mute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Отключить звук { $tabCount } вкладки ({ $shortcut })
            [few] Отключить звук { $tabCount } вкладок ({ $shortcut })
           *[many] Отключить звук { $tabCount } вкладок ({ $shortcut })
        }
# Variables:
#   $shortcut (String): The keyboard shortcut for "Unmute tab".
tabbrowser-unmute-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Включить звук { $tabCount } вкладки ({ $shortcut })
            [few] Включить звук { $tabCount } вкладок ({ $shortcut })
           *[many] Включить звук { $tabCount } вкладок ({ $shortcut })
        }
tabbrowser-mute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Отключить звук { $tabCount } вкладки
            [few] Отключить звук { $tabCount } вкладок
           *[many] Отключить звук { $tabCount } вкладок
        }
tabbrowser-unmute-tab-audio-background-tooltip =
    .label =
        { $tabCount ->
            [one] Включить звук { $tabCount } вкладки
            [few] Включить звук { $tabCount } вкладок
           *[many] Включить звук { $tabCount } вкладок
        }
tabbrowser-unblock-tab-audio-tooltip =
    .label =
        { $tabCount ->
            [one] Воспроизвести звук { $tabCount } вкладки
            [few] Воспроизвести звук { $tabCount } вкладок
           *[many] Воспроизвести звук { $tabCount } вкладок
        }

## Confirmation dialog when closing a window with more than one tab open,
## or when quitting when only one window is open.

# The singular form is not considered since this string is used only for multiple tabs.
# Variables:
#   $tabCount (Number): The number of tabs that will be closed.
tabbrowser-confirm-close-tabs-title =
    { $tabCount ->
        [one] Закрыть { $tabCount } вкладку?
        [few] Закрыть { $tabCount } вкладки?
       *[many] Закрыть { $tabCount } вкладок?
    }
tabbrowser-confirm-close-tabs-button = Закрыть вкладки
tabbrowser-confirm-close-tabs-checkbox = Подтверждать закрытие нескольких вкладок

## Confirmation dialog when quitting using the menu and multiple windows are open.

# The forms for 0 or 1 items are not considered since this string is used only for
# multiple windows.
# Variables:
#   $windowCount (Number): The number of windows that will be closed.
tabbrowser-confirm-close-windows-title =
    { $windowCount ->
        [one] Закрыть { $windowCount } окно?
        [few] Закрыть { $windowCount } окна?
       *[many] Закрыть { $windowCount } окон?
    }
tabbrowser-confirm-close-windows-button =
    { PLATFORM() ->
        [windows] Закрыть и выйти
       *[other] Закрыть и выйти
    }

## Confirmation dialog when quitting using the keyboard shortcut (Ctrl/Cmd+Q)
## Windows does not show a prompt on quit when using the keyboard shortcut by default.

tabbrowser-confirm-close-tabs-with-key-title = Закрыть окно и выйти из { -brand-short-name }?
tabbrowser-confirm-close-tabs-with-key-button = Выйти из { -brand-short-name }
# Variables:
#   $quitKey (String): the text of the keyboard shortcut for quitting.
tabbrowser-confirm-close-tabs-with-key-checkbox = Подтверждать выход с помощью { $quitKey }

## Confirmation dialog when opening multiple tabs simultaneously

tabbrowser-confirm-open-multiple-tabs-title = Подтверждение открытия
# Variables:
#   $tabCount (Number): The number of tabs that will be opened.
tabbrowser-confirm-open-multiple-tabs-message =
    { $tabCount ->
       *[other] Вы собираетесь открыть несколько ({ $tabCount }) вкладок. Это может замедлить работу { -brand-short-name } на время загрузки этих страниц. Вы действительно хотите это сделать?
    }
tabbrowser-confirm-open-multiple-tabs-button = Открыть вкладки
tabbrowser-confirm-open-multiple-tabs-checkbox = Предупреждать меня, когда открытие нескольких вкладок может замедлить работу { -brand-short-name }

## Confirmation dialog for enabling caret browsing

tabbrowser-confirm-caretbrowsing-title = Активный курсор
tabbrowser-confirm-caretbrowsing-message = Нажатие клавиши F7 включает или выключает режим активного курсора. В этом режиме, поместив курсор на страницу, вы можете выделять текст с помощью клавиатуры. Включить этот режим?
tabbrowser-confirm-caretbrowsing-checkbox = Больше не показывать это окно.

##

# Variables:
#   $domain (String): URL of the page that is trying to steal focus.
tabbrowser-allow-dialogs-to-get-focus =
    .label = Разрешить таким уведомлениям от { $domain } переводить вас на их вкладку

tabbrowser-customizemode-tab-title = Настройка { -brand-short-name }

## Context menu buttons, of which only one will be visible at a time

tabbrowser-context-mute-tab =
    .label = Отключить звук вкладки
    .accesskey = О
tabbrowser-context-unmute-tab =
    .label = Включить звук вкладки
    .accesskey = в
# The accesskey should match the accesskey for tabbrowser-context-mute-tab
tabbrowser-context-mute-selected-tabs =
    .label = Отключить звук вкладок
    .accesskey = О
# The accesskey should match the accesskey for tabbrowser-context-unmute-tab
tabbrowser-context-unmute-selected-tabs =
    .label = Включить звук вкладок
    .accesskey = в

# This string is used as an additional tooltip and accessibility description for tabs playing audio
tabbrowser-tab-audio-playing-description = Воспроизведение звука

## Ctrl-Tab dialog

# Variables:
#   $tabCount (Number): The number of tabs in the current browser window. It will always be 2 at least.
tabbrowser-ctrl-tab-list-all-tabs =
    .label =
        { $tabCount ->
            [one] Показать весь список из { $tabCount } вкладки
            [few] Показать весь список из { $tabCount } вкладок
           *[many] Показать весь список из { $tabCount } вкладок
        }

## Tab manager menu buttons

tabbrowser-manager-mute-tab =
    .tooltiptext = Убрать звук во вкладке
tabbrowser-manager-unmute-tab =
    .tooltiptext = Восстановить звук во вкладке
tabbrowser-manager-close-tab =
    .tooltiptext = Закрыть вкладку
