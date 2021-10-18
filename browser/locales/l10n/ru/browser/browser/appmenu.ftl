# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## App Menu

appmenuitem-update-banner3 =
    .label-update-downloading = Загрузка обновления { -brand-shorter-name }
    .label-update-available = Доступно обновление — загрузить сейчас
    .label-update-manual = Доступно обновление — загрузить сейчас
    .label-update-unsupported = Не удалось выполнить обновление — несовместимая система
    .label-update-restart = Доступно обновление — перезапустить сейчас
appmenuitem-protection-dashboard-title = Панель состояния защиты
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
    .label = Войти в Синхронизацию…
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
appmenu-fxa-show-more-tabs = Показать больше вкладок
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
profiler-popup-learn-more = Подробнее
profiler-popup-learn-more-button =
    .label = Подробнее
profiler-popup-settings =
    .value = Настройки
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Изменить настройки…
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings-button =
    .label = Изменить настройки…
profiler-popup-disabled = Профайлер в настоящее время отключён, скорее всего, из-за того, что открыто приватное окно.
profiler-popup-recording-screen = Запись…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Персональный
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
profiler-popup-presets-firefox-platform-description = Рекомендуемые настройки для внутренней отладки платформы Waterfox.
profiler-popup-presets-firefox-platform-label =
    .label = Платформа Waterfox
profiler-popup-presets-firefox-front-end-description = Рекомендуемые настройки для внутренней отладки клиентской части Waterfox.
profiler-popup-presets-firefox-front-end-label =
    .label = Клиентская часть Waterfox
profiler-popup-presets-firefox-graphics-description = Рекомендуемые настройки для исследования производительности графики Waterfox.
profiler-popup-presets-firefox-graphics-label =
    .label = Графика Waterfox
profiler-popup-presets-media-description = Рекомендуемые настройки для диагностики проблем со звуком и видео.
profiler-popup-presets-media-label =
    .label = Медиа
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
appmenu-help-feedback-page =
    .label = Отправить отзыв…
    .accesskey = т

## appmenu-help-enter-troubleshoot-mode and appmenu-help-exit-troubleshoot-mode
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-enter-troubleshoot-mode2 =
    .label = Безопасный режим…
    .accesskey = й
appmenu-help-exit-troubleshoot-mode =
    .label = Отключить безопасный режим
    .accesskey = п

## appmenu-help-report-deceptive-site and appmenu-help-not-deceptive
## are mutually exclusive, so it's possible to use the same accesskey for both.

appmenu-help-report-deceptive-site =
    .label = Сообщить о поддельном сайте…
    .accesskey = б
appmenu-help-not-deceptive =
    .label = Это не поддельный сайт…
    .accesskey = е

## More Tools

appmenu-customizetoolbar =
    .label = Настройка панели инструментов…
appmenu-taskmanager =
    .label = Диспетчер задач
appmenu-developer-tools-subheader = Инструменты браузера
appmenu-developer-tools-extensions =
    .label = Расширения для разработчиков
