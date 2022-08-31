# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-banner-update-downloading =
    .label = Загрузка обновления { -brand-shorter-name }
appmenuitem-banner-update-available =
    .label = Доступно обновление — загрузить сейчас
appmenuitem-banner-update-manual =
    .label = Доступно обновление — загрузить сейчас
appmenuitem-banner-update-unsupported =
    .label = Не удалось выполнить обновление — несовместимая система
appmenuitem-banner-update-restart =
    .label = Доступно обновление — перезапустить сейчас
appmenuitem-new-tab =
    .label = Новая вкладка
appmenuitem-new-window =
    .label = Новое окно
appmenuitem-new-private-window =
    .label = Новое приватное окно
appmenuitem-history =
    .label = Журнал
appmenuitem-downloads =
    .label = Загрузки
appmenuitem-passwords =
    .label = Пароли
appmenuitem-addons-and-themes =
    .label = Дополнения и темы
appmenuitem-print =
    .label = Печать…
appmenuitem-find-in-page =
    .label = Найти на странице…
appmenuitem-zoom =
    .value = Масштаб
appmenuitem-more-tools =
    .label = Другие инструменты
appmenuitem-help =
    .label = Справка
appmenuitem-exit2 =
    .label =
        { PLATFORM() ->
            [linux] Выход
           *[other] Выход
        }
appmenu-menu-button-closed2 =
    .tooltiptext = Открыть меню приложения
    .label = { -brand-short-name }
appmenu-menu-button-opened2 =
    .tooltiptext = Закрыть меню приложения
    .label = { -brand-short-name }
# Settings is now used to access the browser settings across all platforms,
# instead of Options or Preferences.
appmenuitem-settings =
    .label = Настройки

## Zoom and Fullscreen Controls

appmenuitem-zoom-enlarge =
    .label = Увеличить
appmenuitem-zoom-reduce =
    .label = Уменьшить
appmenuitem-fullscreen =
    .label = Полный экран

## Waterfox Account toolbar button and Sync panel in App menu.

appmenu-remote-tabs-sign-into-sync =
    .label = Войти для синхронизации…
appmenu-remote-tabs-turn-on-sync =
    .label = Включить синхронизацию…
# This is shown after the tabs list if we can display more tabs by clicking on the button
appmenu-remote-tabs-showmore =
    .label = Показать больше вкладок
    .tooltiptext = Показать больше вкладок с этого устройства
# This is shown beneath the name of a device when that device has no open tabs
appmenu-remote-tabs-notabs = Нет открытых вкладок
# This is shown when Sync is configured but syncing tabs is disabled.
appmenu-remote-tabs-tabsnotsyncing = Включите синхронизацию вкладок, чтобы увидеть список вкладок с других устройств.
appmenu-remote-tabs-opensettings =
    .label = Настройки
# This is shown when Sync is configured but this appears to be the only device attached to
# the account. We also show links to download Waterfox for android/ios.
appmenu-remote-tabs-noclients = Хотите увидеть здесь ваши вкладки с других устройств?
appmenu-remote-tabs-connectdevice =
    .label = Подключить другое устройство
appmenu-remote-tabs-welcome = Просмотрите список вкладок с других устройств.
appmenu-remote-tabs-unverified = Ваш аккаунт должен быть подтверждён.
appmenuitem-fxa-toolbar-sync-now2 = Синхронизировать
appmenuitem-fxa-sign-in = Войти в { -brand-product-name }
appmenuitem-fxa-manage-account = Управление аккаунтом
appmenu-fxa-header2 = { -fxaccount-brand-name }
# Variables
# $time (string) - Localized relative time since last sync (e.g. 1 second ago,
# 3 hours ago, etc.)
appmenu-fxa-last-sync = Последняя синхронизация { $time }
    .label = Последняя синхронизация { $time }
appmenu-fxa-sync-and-save-data2 = Синхронизация и сохранение данных
appmenu-fxa-signed-in-label = Войти
appmenu-fxa-setup-sync =
    .label = Включить синхронизацию…
appmenuitem-save-page =
    .label = Сохранить как…

## What's New panel in App menu.

whatsnew-panel-header = Что нового
# Checkbox displayed at the bottom of the What's New panel, allowing users to
# enable/disable What's New notifications.
whatsnew-panel-footer-checkbox =
    .label = Уведомлять о новых функциях
    .accesskey = в

## The Waterfox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-button-idle =
    .label = Профайлер
    .tooltiptext = Записать профиль производительности
profiler-popup-button-recording =
    .label = Профайлер
    .tooltiptext = Профайлер записывает профиль
profiler-popup-button-capturing =
    .label = Профайлер
    .tooltiptext = Профайлер захватывает профиль
profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Показать дополнительную информацию
profiler-popup-description-title =
    .value = Записывайте, анализируйте, делитесь
profiler-popup-description = Совместная работа над производительностью с помощью публикации профилей, которыми можно поделиться со своей командой.
profiler-popup-learn-more-button =
    .label = Подробнее
profiler-popup-settings =
    .value = Настройки
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Изменить настройки…
profiler-popup-recording-screen = Запись…
profiler-popup-start-recording-button =
    .label = Начать запись
profiler-popup-discard-button =
    .label = Отменить
profiler-popup-capture-button =
    .label = Захватить
profiler-popup-start-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧1
       *[other] Ctrl+Shift+1
    }
profiler-popup-capture-shortcut =
    { PLATFORM() ->
        [macos] ⌃⇧2
       *[other] Ctrl+Shift+2
    }

## Profiler presets
## They are shown in the popup's select box.


# Presets and their l10n IDs are defined in the file
# devtools/client/performance-new/popup/background.jsm.js
# Please take care that the same values are also defined in devtools' perftools.ftl.

profiler-popup-presets-web-developer-description = Рекомендуемые настройки для отладки большинства веб-приложений с низкими накладными расходами.
profiler-popup-presets-web-developer-label =
    .label = Веб-разработка
profiler-popup-presets-firefox-description = Рекомендуемые настройки для профилирования { -brand-shorter-name }.
profiler-popup-presets-firefox-label =
    .label = { -brand-shorter-name }
profiler-popup-presets-graphics-description = Настройки для выявления ошибок графики в { -brand-shorter-name }.
profiler-popup-presets-graphics-label =
    .label = Графика
profiler-popup-presets-media-description2 = Настройки для выявления ошибок аудио и видео в { -brand-shorter-name }.
profiler-popup-presets-media-label =
    .label = Медиа
profiler-popup-presets-networking-description = Настройки для выявления сетевых ошибок в { -brand-shorter-name }.
profiler-popup-presets-networking-label =
    .label = Сеть
profiler-popup-presets-power-description = Настройки для выявления ошибок потребления энергии в { -brand-shorter-name }, с небольшими накладными расходами.
# "Power" is used in the sense of energy (electricity used by the computer).
profiler-popup-presets-power-label =
    .label = Электропитание
profiler-popup-presets-custom-label =
    .label = Персональный

## History panel

appmenu-manage-history =
    .label = Управление журналом
appmenu-reopen-all-tabs = Снова открыть все вкладки
appmenu-reopen-all-windows = Снова открыть все окна
appmenu-restore-session =
    .label = Восстановить предыдущую сессию
appmenu-clear-history =
    .label = Удалить историю…
appmenu-recent-history-subheader = Недавняя история
appmenu-recently-closed-tabs =
    .label = Недавно закрытые вкладки
appmenu-recently-closed-windows =
    .label = Недавно закрытые окна

## Help panel

appmenu-help-header =
    .title = Справка { -brand-shorter-name }
appmenu-about =
    .label = О { -brand-shorter-name }
    .accesskey = О
appmenu-get-help =
    .label = Получить помощь
    .accesskey = ч
appmenu-help-more-troubleshooting-info =
    .label = Информация для решения проблем
    .accesskey = а
appmenu-help-report-site-issue =
    .label = Сообщить о проблеме с сайтом…
appmenu-help-share-ideas =
    .label = Поделиться идеей или оставить отзыв…
    .accesskey = д

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Безопасный режим…
    .accesskey = Б
appmenu-help-exit-troubleshoot-mode =
    .label = Отключить безопасный режим
    .accesskey = Б

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Сообщить о поддельном сайте…
    .accesskey = п
appmenu-help-not-deceptive =
    .label = Это не поддельный сайт…
    .accesskey = п

## More Tools

appmenu-customizetoolbar =
    .label = Настройка панели инструментов…
appmenu-developer-tools-subheader = Инструменты браузера
appmenu-developer-tools-extensions =
    .label = Расширения для разработчиков
