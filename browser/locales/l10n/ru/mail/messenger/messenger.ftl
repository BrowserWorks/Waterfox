# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

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

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
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

## Message header pane

other-action-redirect-msg =
    .label = Перенаправить

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Управление расширением
    .accesskey = п
toolbar-context-menu-remove-extension =
    .label = Удалить расширение
    .accesskey = л

## Message headers

message-header-address-in-address-book-icon =
    .alt = Этот адрес есть в Адресной книге

message-header-address-not-in-address-book-icon =
    .alt = Этого адреса нет в Адресной книге

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
