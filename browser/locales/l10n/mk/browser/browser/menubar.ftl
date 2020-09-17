# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## File Menu

menu-file =
    .label = Датотека
    .accesskey = Д
menu-file-new-tab =
    .label = Ново јазиче
    .accesskey = ј
menu-file-new-container-tab =
    .label = Ново контејнерско јазиче
    .accesskey = К
menu-file-new-window =
    .label = Нов прозорец
    .accesskey = Н
menu-file-new-private-window =
    .label = Нов приватен прозорец
    .accesskey = П
# "Open Location" is only displayed on macOS, and only on windows
# that aren't main browser windows, or when there are no windows
# but Firefox is still running.
menu-file-open-location =
    .label = Отвори локација…
menu-file-open-file =
    .label = Отвори датотека…
    .accesskey = О
menu-file-close =
    .label = Затвори
    .accesskey = т
menu-file-close-window =
    .label = Затвори го прозорецот
    .accesskey = п
menu-file-save-page =
    .label = Сними страница како…
    .accesskey = а
menu-file-email-link =
    .label = Испрати линк…
    .accesskey = И
menu-file-print-setup =
    .label = Поставување на страницата…
    .accesskey = с
menu-file-print-preview =
    .label = Преглед за печатење
    .accesskey = г
menu-file-print =
    .label = Печати…
    .accesskey = ч
menu-file-go-offline =
    .label = Работи локално
    .accesskey = Р

## Edit Menu

menu-edit =
    .label = Уредување
    .accesskey = е
menu-edit-find-on =
    .label = Пронајди во оваа страница…
    .accesskey = р
menu-edit-find-again =
    .label = Пронајди повторно
    .accesskey = а
menu-edit-bidi-switch-text-direction =
    .label = Промени ја насоката на текстот
    .accesskey = р

## View Menu

menu-view =
    .label = Поглед
    .accesskey = г
menu-view-toolbars-menu =
    .label = Алатници
    .accesskey = А
menu-view-customize-toolbar =
    .label = Прилагоди…
    .accesskey = р
menu-view-sidebar =
    .label = Странична лента
    .accesskey = н
menu-view-bookmarks =
    .label = Обележувачи
menu-view-history-button =
    .label = Историја
menu-view-synced-tabs-sidebar =
    .label = Синхронизирани јазичиња
menu-view-full-zoom =
    .label = Приказ
    .accesskey = З
menu-view-full-zoom-enlarge =
    .label = Зголеми
    .accesskey = г
menu-view-full-zoom-reduce =
    .label = Намали
    .accesskey = м
menu-view-full-zoom-toggle =
    .label = Зумирај само текст
    .accesskey = т
menu-view-page-style-menu =
    .label = Стил на страница
    .accesskey = л
menu-view-page-style-no-style =
    .label = Без стил
    .accesskey = е
menu-view-page-basic-style =
    .label = Основен стил на страница
    .accesskey = О

## These should match what Safari and other Apple applications
## use on macOS.

menu-view-enter-full-screen =
    .label = На цел екран
    .accesskey = ц
menu-view-exit-full-screen =
    .label = Исклучи цел екран
    .accesskey = ц
menu-view-full-screen =
    .label = На цел екран
    .accesskey = ц

##

menu-view-show-all-tabs =
    .label = Прикажи ги сите јазичиња
    .accesskey = П
menu-view-bidi-switch-page-direction =
    .label = Промени ја насоката на страницата
    .accesskey = о

## History Menu

menu-history =
    .label = Историја
    .accesskey = с
menu-history-show-all-history =
    .label = Прикажи ја сета историја
menu-history-clear-recent-history =
    .label = Исчисти ја скорешната историја…
menu-history-synced-tabs =
    .label = Синхронизирани јазичиња
menu-history-restore-last-session =
    .label = Врати претходна сесија
menu-history-undo-menu =
    .label = Скоро-затворени јазичиња
menu-history-undo-window-menu =
    .label = Скоро-затворени прозорци

## Bookmarks Menu

menu-bookmarks-menu =
    .label = Обележувачи
    .accesskey = б
menu-bookmarks-show-all =
    .label = Прикажи ги сите обележувачи
menu-bookmark-this-page =
    .label = Обележи ја оваа страница
menu-bookmark-edit =
    .label = Уреди го овој обележувач
menu-bookmarks-all-tabs =
    .label = Обележи ги сите јазичиња…
menu-bookmarks-toolbar =
    .label = Алатник со обележувачи
menu-bookmarks-other =
    .label = Останати обележувачи
menu-bookmarks-mobile =
    .label = Мобилни обележувачи

## Tools Menu

menu-tools =
    .label = Алатки
    .accesskey = т
menu-tools-downloads =
    .label = Преземања
    .accesskey = р
menu-tools-addons =
    .label = Додатоци
    .accesskey = Д
menu-tools-sync-now =
    .label = Синхронизирај сега
    .accesskey = С
menu-tools-web-developer =
    .label = Web Developer
    .accesskey = W
menu-tools-page-source =
    .label = Изворен код
    .accesskey = о
menu-tools-page-info =
    .label = Информации за страницата
    .accesskey = И
menu-preferences =
    .label =
        { PLATFORM() ->
            [windows] Опции
           *[other] Поставки
        }
    .accesskey =
        { PLATFORM() ->
            [windows] О
           *[other] ф
        }

## Window Menu

menu-window-menu =
    .label = Прозорец
menu-window-bring-all-to-front =
    .label = Донеси ги сите напред

## Help Menu

menu-help =
    .label = Помош
    .accesskey = ш
menu-help-product =
    .label = Помош за { -brand-shorter-name }
    .accesskey = H
menu-help-show-tour =
    .label = Тура на { -brand-shorter-name }
    .accesskey = o
menu-help-keyboard-shortcuts =
    .label = Кратенки за тастатура
    .accesskey = K
menu-help-troubleshooting-info =
    .label = Информации за проблеми
    .accesskey = И
menu-help-feedback-page =
    .label = Испрати коментар…
    .accesskey = с
menu-help-safe-mode-without-addons =
    .label = Рестартирај со исклучени додатоци…
    .accesskey = Р
menu-help-safe-mode-with-addons =
    .label = Рестрартирај со овозможени додатоци
    .accesskey = R
