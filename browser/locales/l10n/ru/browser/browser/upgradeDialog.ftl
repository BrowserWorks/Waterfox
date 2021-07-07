# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Поздоровайтесь с новым { -brand-short-name }
upgrade-dialog-new-subtitle = Создан для быстрой доставки вас в нужное место
upgrade-dialog-new-item-menu-title = Оптимизированное меню и панель инструментов
upgrade-dialog-new-item-menu-description = Расставьте важные вещи в нужном порядке, чтобы быстро найти то, что вам нужно.
upgrade-dialog-new-item-tabs-title = Современные вкладки
upgrade-dialog-new-item-tabs-description = Удобная подача информации с поддержкой фокусировки и упрощённой навигацией.
upgrade-dialog-new-item-icons-title = Обновлённые значки и более понятные сообщения
upgrade-dialog-new-item-icons-description = Помогают вам найти путь одним лёгким прикосновением.
upgrade-dialog-new-primary-default-button = Сделать { -brand-short-name } моим браузером по умолчанию
upgrade-dialog-new-primary-theme-button = Выбрать тему
upgrade-dialog-new-secondary-button = Не сейчас
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Ок, понятно!

## Pin Waterfox screen
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
upgrade-dialog-default-title-2 = Сделать { -brand-short-name } браузером по умолчанию
upgrade-dialog-default-subtitle-2 = Поставьте на автопилот свою скорость, безопасность и приватность.
upgrade-dialog-default-primary-button-2 = Сделать браузером по умолчанию
upgrade-dialog-default-secondary-button = Не сейчас

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Начните с чистого листа со свежей темой
upgrade-dialog-theme-system = Системная тема
    .title = Следовать теме операционной системы для кнопок, меню и окон

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = Жизнь в цвете
upgrade-dialog-start-subtitle = Яркие новые расцветки. Доступны в течение ограниченного времени.
upgrade-dialog-start-primary-button = Просмотрите цветовые расцветки
upgrade-dialog-start-secondary-button = Не сейчас

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Выберите свою палитру
# This is shown to users with a custom home page, so they can switch to default.
upgrade-dialog-colorway-home-checkbox = Смените расцветку фона Домашней страницы Waterfox
upgrade-dialog-colorway-primary-button = Сохранить расцветку
upgrade-dialog-colorway-secondary-button = Оставить предыдущую тему
upgrade-dialog-colorway-theme-tooltip =
    .title = Просмотрите стандартные темы
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Просмотрите расцветку { $colorwayName }.
upgrade-dialog-colorway-default-theme = По умолчанию
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Авто
    .title = Следовать настройкам операционной системы для кнопок, меню и окон
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
upgrade-dialog-colorway-variation-soft = Мягкая
    .title = Использовать эту расцветку
upgrade-dialog-colorway-variation-balanced = Сбалансированная
    .title = Использовать эту расцветку
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Выразительная
    .title = Использовать эту расцветку

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Спасибо, что выбрали нас
upgrade-dialog-thankyou-subtitle = { -brand-short-name } 一 независимый браузер, поддерживаемый некоммерческой организацией. Вместе мы делаем Интернет более безопасным, здоровым и приватным.
upgrade-dialog-thankyou-primary-button = Начать веб-сёрфинг
