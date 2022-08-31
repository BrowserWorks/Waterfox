# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Window controls

messenger-window-minimize-button =
    .tooltiptext = Свернуть
messenger-window-maximize-button =
    .tooltiptext = Развернуть
messenger-window-restore-down-button =
    .tooltiptext = Свернуть в окно
messenger-window-close-button =
    .tooltiptext = Закрыть
# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] { $count } непрочитанное сообщение
        [few] { $count } непрочитанных сообщения
       *[many] { $count } непрочитанных сообщений
    }
about-rights-notification-text = { -brand-short-name } — это бесплатное программное обеспечение с открытым исходным кодом, созданное сообществом тысяч людей со всего мира.

## Content tabs

content-tab-page-loading-icon =
    .alt = Страница загружается
content-tab-security-high-icon =
    .alt = Защищённое соединение
content-tab-security-broken-icon =
    .alt = Соединение не защищено

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Дополнения и темы
    .tooltiptext = Управление своими дополнениями
quick-filter-toolbarbutton =
    .label = Быстрый фильтр
    .tooltiptext = Фильтрация сообщений
redirect-msg-button =
    .label = Перенаправить
    .tooltiptext = Перенаправить выбранное сообщение

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Панель вида папок
    .accesskey = н
folder-pane-toolbar-options-button =
    .tooltiptext = Настройки вида папок
folder-pane-header-label = Папки

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Скрыть панель инструментов
    .accesskey = ы
show-all-folders-label =
    .label = Все папки
    .accesskey = е
show-unread-folders-label =
    .label = Непрочитанные папки
    .accesskey = и
show-favorite-folders-label =
    .label = Избранные папки
    .accesskey = з
show-smart-folders-label =
    .label = Объединённые папки
    .accesskey = б
show-recent-folders-label =
    .label = Недавно открытые папки
    .accesskey = а
folder-toolbar-toggle-folder-compact-view =
    .label = Компактный вид
    .accesskey = п

## Menu

redirect-msg-menuitem =
    .label = Перенаправить
    .accesskey = н
menu-file-save-as-file =
    .label = Файл…
    .accesskey = а

## AppMenu

appmenu-save-as-file =
    .label = Файл…
appmenu-settings =
    .label = Настройки
appmenu-addons-and-themes =
    .label = Дополнения и темы
appmenu-help-enter-troubleshoot-mode =
    .label = Безопасный режим…
appmenu-help-exit-troubleshoot-mode =
    .label = Отключить безопасный режим
appmenu-help-more-troubleshooting-info =
    .label = Информация для решения проблем
appmenu-redirect-msg =
    .label = Перенаправить

## Context menu

context-menu-redirect-msg =
    .label = Перенаправить
mail-context-delete-messages =
    .label =
        { $count ->
            [one] Удалить выбранное сообщение
            [few] Удалить выбранные сообщения
           *[many] Удалить выбранные сообщения
        }
context-menu-decrypt-to-folder =
    .label = Копировать в расшифрованном виде в
    .accesskey = ш

## Message header pane

other-action-redirect-msg =
    .label = Перенаправить
message-header-msg-flagged =
    .title = Отмечено звёздочкой
    .aria-label = Отмечено звёздочкой
message-header-msg-not-flagged =
    .title = Не отмечено звёздочкой
    .aria-label = Не отмечено звёздочкой
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = Фотография профиля { $address }.

## Message header cutomize panel

message-header-customize-panel-title = Настройки заголовка сообщения
message-header-customize-button-style =
    .value = Стиль кнопок
    .accesskey = л
message-header-button-style-default =
    .label = Значки и текст
message-header-button-style-text =
    .label = Текст
message-header-button-style-icons =
    .label = Значки
message-header-show-sender-full-address =
    .label = Всегда показывать полный адрес отправителя
    .accesskey = ы
message-header-show-sender-full-address-description = Адрес электронной почты будет отображаться под отображаемым именем.
message-header-show-recipient-avatar =
    .label = Показывать фото профиля отправителя
    .accesskey = ф
message-header-hide-label-column =
    .label = Скрыть столбец меток
    .accesskey = ы
message-header-large-subject =
    .label = Большая тема
    .accesskey = ш

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Управление расширением
    .accesskey = п
toolbar-context-menu-remove-extension =
    .label = Удалить расширение
    .accesskey = л

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Удалить { $name }?
addon-removal-confirmation-button = Удалить
addon-removal-confirmation-message = Удалить { $name }, а также его конфигурацию и данные из { -brand-short-name }?
caret-browsing-prompt-title = Активный курсор
caret-browsing-prompt-text = Нажатие клавиши F7 включает или выключает режим активного курсора. В этом режиме, поместив курсор в текст, вы можете выделять текст с помощью клавиатуры. Включить этот режим?
caret-browsing-prompt-check-text = Больше не спрашивать.
repair-text-encoding-button =
    .label = Исправить кодировку текста
    .tooltiptext = Угадать правильную кодировку текста по содержимому сообщения

## no-reply handling

no-reply-title = Ответ не поддерживается
no-reply-message = Адрес для ответа ({ $email }) не похож на отслеживаемый адрес. Сообщения, отправленные по этому адресу, скорее всего никто не прочитает.
no-reply-reply-anyway-button = Все равно ответить

## error messages

decrypt-and-copy-failures = { $failures } из { $total } сообщений не могли быть расшифрованы и не были скопированы.

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = Панель мест
    .aria-label = Панель мест
    .aria-description = Вертикальная панель инструментов для переключения между разными местами. Используйте клавиши со стрелками для навигации доступными кнопками.
spaces-toolbar-button-mail2 =
    .title = Почта
spaces-toolbar-button-address-book2 =
    .title = Адресная книга
spaces-toolbar-button-calendar2 =
    .title = Календарь
spaces-toolbar-button-tasks2 =
    .title = Задачи
spaces-toolbar-button-chat2 =
    .title = Чат
spaces-toolbar-button-overflow =
    .title = Больше мест…
spaces-toolbar-button-settings2 =
    .title = Настройки
spaces-toolbar-button-hide =
    .title = Скрыть панель мест
spaces-toolbar-button-show =
    .title = Показать панель мест
spaces-context-new-tab-item =
    .label = Открыть в новой вкладке
spaces-context-new-window-item =
    .label = Открыть в новом окне
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = Переключиться на { $tabName }
settings-context-open-settings-item2 =
    .label = Настройки
settings-context-open-account-settings-item2 =
    .label = Настройки учётной записи
settings-context-open-addons-item2 =
    .label = Дополнения и темы

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = Меню мест
spaces-pinned-button-menuitem-mail =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-mail2 =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book2 =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar2 =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks2 =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat2 =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings2 =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-show =
    .label = { spaces-toolbar-button-show.title }
# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title =
        { $count ->
            [one] { $count } непрочтённое сообщение
            [few] { $count } непрочтённых сообщения
           *[many] { $count } непрочтённых сообщений
        }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = Настроить…
spaces-customize-panel-title = Настройки панели мест
spaces-customize-background-color = Цвет фона
spaces-customize-icon-color = Цвет кнопки
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = Выбранный цвет фона кнопки
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = Выбранный цвет кнопки
spaces-customize-button-restore = Восстановить по умолчанию
    .accesskey = м
customize-panel-button-save = Готово
    .accesskey = о
