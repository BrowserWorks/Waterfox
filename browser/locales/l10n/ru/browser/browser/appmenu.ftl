# This Source Code Form is subject to the terms of the Mozilla Public
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
appmenuitem-customize-mode =
    .label = Настройка…

## Zoom Controls

appmenuitem-new-tab =
    .label = Новая вкладка
appmenuitem-new-window =
    .label = Новое окно
appmenuitem-new-private-window =
    .label = Новое приватное окно
appmenuitem-passwords =
    .label = Пароли
appmenuitem-addons-and-themes =
    .label = Дополнения и темы
appmenuitem-find-in-page =
    .label = Найти на странице…
appmenuitem-more-tools =
    .label = Другие инструменты
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

## Firefox Account toolbar button and Sync panel in App menu.

fxa-toolbar-sync-now =
    .label = Синхронизировать
appmenu-remote-tabs-sign-into-sync =
    .label = Войти в Синхронизацию…
appmenu-remote-tabs-turn-on-sync =
    .label = Включить синхронизацию…
appmenuitem-fxa-toolbar-sync-now2 = Синхронизировать
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

## The Firefox Profiler – The popup is the UI to turn on the profiler, and record
## performance profiles. To enable it go to profiler.firefox.com and click
## "Enable Profiler Menu Button".

profiler-popup-title =
    .value = { -profiler-brand-name }
profiler-popup-reveal-description-button =
    .aria-label = Показать дополнительную информацию
profiler-popup-description-title =
    .value = Записывайте, анализируйте, делитесь
profiler-popup-description = Совместная работа над производительностью с помощью публикации профилей, которыми можно поделиться со своей командой.
profiler-popup-learn-more = Подробнее
profiler-popup-settings =
    .value = Настройки
# This link takes the user to about:profiling, and is only visible with the Custom preset.
profiler-popup-edit-settings = Изменить настройки…
profiler-popup-disabled =
    Профайлер в настоящее время отключён, скорее всего, из-за того, что открыто
    окно приватного просмотра.
profiler-popup-recording-screen = Запись…
# The profiler presets list is generated elsewhere, but the custom preset is defined
# here only.
profiler-popup-presets-custom =
    .label = Пользовательские
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
