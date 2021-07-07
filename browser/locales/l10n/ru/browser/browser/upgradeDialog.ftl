# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Поздоровайтесь с новым { -brand-short-name }
upgrade-dialog-new-subtitle = Создан для быстрой доставки вас в нужное место
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Для начала поместите <span data-l10n-name="zap">{ -brand-short-name }</span> на расстояние одного щелчка
upgrade-dialog-new-item-menu-title = Оптимизированное меню и панель инструментов
upgrade-dialog-new-item-menu-description = Расставьте важные вещи в нужном порядке, чтобы быстро найти то, что вам нужно.
upgrade-dialog-new-item-tabs-title = Современные вкладки
upgrade-dialog-new-item-tabs-description = Удобная подача информации с поддержкой фокусировки и упрощённой навигацией.
upgrade-dialog-new-item-icons-title = Обновлённые значки и более понятные сообщения
upgrade-dialog-new-item-icons-description = Помогают вам найти путь одним лёгким прикосновением.
upgrade-dialog-new-primary-primary-button = Сделать { -brand-short-name } моим основным браузером
    .title = Устанавливает { -brand-short-name } в качестве браузера по умолчанию и закрепляет его на панели задач
upgrade-dialog-new-primary-default-button = Сделать { -brand-short-name } моим браузером по умолчанию
upgrade-dialog-new-primary-pin-button = Закрепить { -brand-short-name } на моей панели задач
upgrade-dialog-new-primary-pin-alt-button = Закрепить на панели задач
upgrade-dialog-new-primary-theme-button = Выбрать тему
upgrade-dialog-new-secondary-button = Не сейчас
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Ок, понятно!

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Оставить { -brand-short-name } в моем Dock
       *[other] Закрепить { -brand-short-name } на моей панели задач
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Быстрый и легкий доступ к самому новому { -brand-short-name }.
       *[other] Держите самый новый { -brand-short-name } под своей рукой.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Оставить в Dock
       *[other] Закрепить на панели задач
    }
upgrade-dialog-pin-secondary-button = Не сейчас

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = Сделать { -brand-short-name } вашим браузером по умолчанию?
upgrade-dialog-default-subtitle = Получите скорость, безопасность и конфиденциальность на всех веб-страницах.
upgrade-dialog-default-primary-button = Установить браузером по умолчанию
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Сделать { -brand-short-name } браузером по умолчанию
upgrade-dialog-default-subtitle-2 = Поставьте на автопилот свою скорость, безопасность и приватность.
upgrade-dialog-default-primary-button-2 = Сделать браузером по умолчанию
upgrade-dialog-default-secondary-button = Не сейчас

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Начните с чистого листа
    с обновлённой темой
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Начните с чистого листа со свежей темой
upgrade-dialog-theme-system = Системная тема
    .title = Следовать теме операционной системы для кнопок, меню и окон
upgrade-dialog-theme-light = Светлая
    .title = Использовать светлую тему для кнопок, меню и окон
upgrade-dialog-theme-dark = Тёмная
    .title = Использовать тёмную тему для кнопок, меню и окон
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Использовать динамичную, красочную тему для кнопок, меню и окон
upgrade-dialog-theme-keep = Оставить предыдущую
    .title = Оставить тему, которую вы установили до обновления { -brand-short-name }
upgrade-dialog-theme-primary-button = Выбрать тему
upgrade-dialog-theme-secondary-button = Не сейчас
