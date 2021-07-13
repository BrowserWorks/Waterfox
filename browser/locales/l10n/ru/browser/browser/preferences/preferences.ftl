# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Отправлять веб-сайтам сигнал «Не отслеживать», означающий, что вы не хотите, чтобы вас отслеживали
do-not-track-learn-more = Подробнее
do-not-track-option-default-content-blocking-known =
    .label = Только когда { -brand-short-name } настроен на блокировку известных трекеров
do-not-track-option-always =
    .label = Всегда
pref-page-title =
    { PLATFORM() ->
        [windows] Настройки
       *[other] Настройки
    }
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Найти в Настройках
           *[other] Найти в Настройках
        }
settings-page-title = Настройки
# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box2 =
    .style = width: 15.4em
    .placeholder = Найти в Настройках
managed-notice = Ваш браузер управляется Вашей организацией.
category-list =
    .aria-label = Категории
pane-general-title = Основные
category-general =
    .tooltiptext = { pane-general-title }
pane-home-title = Начало
category-home =
    .tooltiptext = { pane-home-title }
pane-search-title = Поиск
category-search =
    .tooltiptext = { pane-search-title }
pane-privacy-title = Приватность и Защита
category-privacy =
    .tooltiptext = { pane-privacy-title }
pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }
pane-sync-title3 = Синхронизация
category-sync3 =
    .tooltiptext = { pane-sync-title3 }
pane-experimental-title = Эксперименты { -brand-short-name }
category-experimental =
    .tooltiptext = Эксперименты { -brand-short-name }
pane-experimental-subtitle = Используйте с осторожностью
pane-experimental-search-results-header = Эксперименты { -brand-short-name }: Используйте с осторожностью
pane-experimental-description2 = Изменение расширенных настроек может затронуть производительность или безопасность { -brand-short-name }.
pane-experimental-reset =
    .label = Восстановить значения по умолчанию
    .accesskey = с
help-button-label = Поддержка { -brand-short-name }
addons-button-label = Расширения и темы
focus-search =
    .key = f
close-button =
    .aria-label = Закрыть

## Browser Restart Dialog

feature-enable-requires-restart = Для включения этого режима необходимо перезапустить { -brand-short-name }.
feature-disable-requires-restart = Для отключения этого режима необходимо перезапустить { -brand-short-name }.
should-restart-title = Перезапуск { -brand-short-name }
should-restart-ok = Перезапустить { -brand-short-name } сейчас
cancel-no-restart-button = Отмена
restart-later = Перезапустить позже

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = Расширение <img data-l10n-name="icon"/> { $name } контролирует вашу домашнюю страницу.
# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Расширение <img data-l10n-name="icon"/> { $name } контролирует вашу страницу новой вкладки.
# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlled-password-saving = Расширение <img data-l10n-name="icon"/> { $name } контролирует этот параметр.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Расширение <img data-l10n-name="icon"/> { $name } контролирует этот параметр.
# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Расширение <img data-l10n-name="icon"/> { $name } установило вашу поисковую систему по умолчанию.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Расширение <img data-l10n-name="icon"/> { $name } требует для своей работы «Вкладки в контейнере».
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Расширение <img data-l10n-name="icon"/> { $name } контролирует этот параметр.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Расширение <img data-l10n-name="icon"/> { $name } контролирует способ соединения { -brand-short-name } с Интернетом.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Чтобы включить расширение, перейдите в пункт <img data-l10n-name="addons-icon"/> Дополнения меню <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Результаты поиска
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Извините! В настройках не найдено результатов для «<span data-l10n-name="query"></span>».
       *[other] Извините! В настройках не найдено результатов для «<span data-l10n-name="query"></span>».
    }
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Извините! В настройках не найдено результатов для «<span data-l10n-name="query"></span>».
search-results-help-link = Нужна помощь? Посетите <a data-l10n-name="url">Сайт поддержки { -brand-short-name }</a>

## General Section

startup-header = Запуск
# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Разрешить одновременный запуск { -brand-short-name } и Firefox
use-firefox-sync = Совет: При этом используются отдельные профили. Используйте { -sync-brand-short-name(case: "accusative") } для обмена между ними данными.
get-started-not-logged-in = Войти в { -sync-brand-short-name(case: "accusative") }…
get-started-configured = Открыть настройки { -sync-brand-short-name(case: "genitive") }
always-check-default =
    .label = Всегда проверять, является ли { -brand-short-name } вашим браузером по умолчанию
    .accesskey = а
is-default = В настоящий момент { -brand-short-name } является вашим браузером по умолчанию
is-not-default = { -brand-short-name } не является вашим браузером по умолчанию
set-as-my-default-browser =
    .label = Установить по умолчанию…
    .accesskey = н
startup-restore-previous-session =
    .label = Восстанавливать предыдущую сессию
    .accesskey = о
startup-restore-warn-on-quit =
    .label = Предупреждать при выходе из браузера
disable-extension =
    .label = Отключить расширение
tabs-group-header = Вкладки
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab переключает между вкладками в порядке недавнего использования
    .accesskey = ж
open-new-link-as-tabs =
    .label = Открывать ссылки во вкладках вместо новых окон
    .accesskey = ы
warn-on-close-multiple-tabs =
    .label = Предупреждать при закрытии нескольких вкладок
    .accesskey = д
warn-on-open-many-tabs =
    .label = Предупреждать, когда открытие нескольких вкладок может замедлить { -brand-short-name }
    .accesskey = р
switch-links-to-new-tabs =
    .label = Переключаться на открываемую вкладку
    .accesskey = к
switch-to-new-tabs =
    .label = Переключаться на открываемую ссылку, изображение или медиа
    .accesskey = ю
show-tabs-in-taskbar =
    .label = Отображать эскизы вкладок на панели задач Windows
    .accesskey = б
browser-containers-enabled =
    .label = Включить «Вкладки в контейнере»
    .accesskey = ч
browser-containers-learn-more = Подробнее
browser-containers-settings =
    .label = Параметры…
    .accesskey = м
containers-disable-alert-title = Закрыть все вкладки в контейнере?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Если вы отключите сейчас вкладки в контейнере, { $tabCount } вкладка в контейнере будет закрыта. Вы уверены, что хотите отключить вкладки в контейнере?
        [few] Если вы отключите сейчас вкладки в контейнере, { $tabCount } вкладки в контейнере будут закрыты. Вы уверены, что хотите отключить вкладки в контейнере?
       *[many] Если вы отключите сейчас вкладки в контейнере, { $tabCount } вкладок в контейнере будут закрыты. Вы уверены, что хотите отключить вкладки в контейнере?
    }
containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Закрыть { $tabCount } вкладку в контейнере
        [few] Закрыть { $tabCount } вкладки в контейнере
       *[many] Закрыть { $tabCount } вкладок в контейнере
    }
containers-disable-alert-cancel-button = Оставить включёнными
containers-remove-alert-title = Удалить этот контейнер?
# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Если вы удалите сейчас этот контейнер, { $count } вкладка в контейнере будет закрыта. Вы уверены, что хотите удалить этот контейнер?
        [few] Если вы удалите сейчас этот контейнер, { $count } вкладки в контейнере будут закрыты. Вы уверены, что хотите удалить этот контейнер?
       *[many] Если вы удалите сейчас этот контейнер, { $count } вкладок в контейнере будут закрыты. Вы уверены, что хотите удалить этот контейнер?
    }
containers-remove-ok-button = Удалить этот контейнер
containers-remove-cancel-button = Не удалять этот контейнер

## General Section - Language & Appearance

language-and-appearance-header = Язык и внешний вид
fonts-and-colors-header = Шрифты и цвета
default-font = Шрифт по умолчанию
    .accesskey = ф
default-font-size = Размер
    .accesskey = м
advanced-fonts =
    .label = Дополнительно…
    .accesskey = н
colors-settings =
    .label = Цвета…
    .accesskey = в
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Масштаб
preferences-default-zoom = Масштаб по умолчанию
    .accesskey = ш
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Только текст
    .accesskey = о
language-header = Язык
choose-language-description = Выберите язык, предпочитаемый вами для отображения веб-страниц
choose-button =
    .label = Выбрать…
    .accesskey = ы
choose-browser-language-description = Выберите язык отображения меню, сообщений и уведомлений от { -brand-short-name }.
manage-browser-languages-button =
    .label = Выбрать альтернативные…
    .accesskey = ы
confirm-browser-language-change-description = Перезапустите { -brand-short-name } для применения этих изменений
confirm-browser-language-change-button = Применить и перезапустить
translate-web-pages =
    .label = Перевод веб-страниц
    .accesskey = и
# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Перевод выполняется <img data-l10n-name="logo"/>
translate-exceptions =
    .label = Исключения…
    .accesskey = л
# Variables:
#    $localeName (string) - Localized name of the locale to be used.
use-system-locale =
    .label = Использовать настройки «{ $localeName }» вашей операционной системы для форматирования даты, времени, чисел и единиц измерения
check-user-spelling =
    .label = Проверять орфографию при наборе текста
    .accesskey = в

## General Section - Files and Applications

files-and-applications-title = Файлы и Приложения
download-header = Загрузки
download-save-to =
    .label = Путь для сохранения файлов
    .accesskey = ь
download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Выбрать…
           *[other] Обзор…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] ы
           *[other] б
        }
download-always-ask-where =
    .label = Всегда выдавать запрос на сохранение файлов
    .accesskey = е
applications-header = Приложения
applications-description = Выберите, как { -brand-short-name } будет обрабатывать файлы, загружаемые из Интернета, или приложения, используемые при работе в Интернете.
applications-filter =
    .placeholder = Поиск типов файлов или приложений
applications-type-column =
    .label = Тип содержимого
    .accesskey = о
applications-action-column =
    .label = Действие
    .accesskey = е
# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = { $extension } файл
applications-action-save =
    .label = Сохранить файл
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Использовать { $app-name }
# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Использовать { $app-name } (по умолчанию)
applications-use-os-default =
    .label =
        { PLATFORM() ->
            [macos] Использовать приложение по умолчанию в macOS
            [windows] Использовать приложение по умолчанию в Windows
           *[other] Использовать системное приложение по умолчанию
        }
applications-use-other =
    .label = Использовать другое…
applications-select-helper = Выберите вспомогательное приложение
applications-manage-app =
    .label = Сведения о приложении…
applications-always-ask =
    .label = Всегда спрашивать
applications-type-pdf = Portable Document Format (PDF)
# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })
# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Использовать { $plugin-name } (в { -brand-short-name })
applications-open-inapp =
    .label = Открыть в { -brand-short-name }

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }
applications-action-save-label =
    .value = { applications-action-save.label }
applications-use-app-label =
    .value = { applications-use-app.label }
applications-open-inapp-label =
    .value = { applications-open-inapp.label }
applications-always-ask-label =
    .value = { applications-always-ask.label }
applications-use-app-default-label =
    .value = { applications-use-app-default.label }
applications-use-other-label =
    .value = { applications-use-other.label }
applications-use-os-default-label =
    .value = { applications-use-os-default.label }

##

drm-content-header = Содержимое использующее технические средства защиты авторских прав (DRM)
play-drm-content =
    .label = Воспроизводить защищённое DRM содержимое
    .accesskey = п
play-drm-content-learn-more = Подробнее
update-application-title = Обновления { -brand-short-name }
update-application-description = Используйте последнюю версию { -brand-short-name } для наилучшей производительности, стабильности и безопасности.
update-application-version = Версия { $version } <a data-l10n-name="learn-more">Что нового</a>
update-history =
    .label = Показать журнал обновлений…
    .accesskey = ж
update-application-allow-description = Разрешить { -brand-short-name }
update-application-auto =
    .label = Автоматически устанавливать обновления (рекомендуется)
    .accesskey = ч
update-application-check-choose =
    .label = Проверять наличие обновлений, но позволять вам решать, устанавливать ли их
    .accesskey = в
update-application-manual =
    .label = Никогда не проверять наличие обновлений (не рекомендуется)
    .accesskey = и
update-application-background-enabled =
    .label = Когда { -brand-short-name } не запущен
    .accesskey = а
update-application-warning-cross-user-setting = Этот параметр применится ко всем учётным записям Windows и профилям { -brand-short-name }, использующим эту установку { -brand-short-name }.
update-application-use-service =
    .label = Использовать фоновую службу для установки обновлений
    .accesskey = ф
update-setting-write-failure-title = Ошибка при сохранении настроек обновления
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    { -brand-short-name } столкнулся с ошибкой и не смог сохранить это изменение. Обратите внимание, что для установки этой настройки обновления требуется разрешение на запись в файл, указанный ниже. Вы или системный администратор можете исправить эту проблему, если предоставите группе «Пользователи» полный доступ к этому файлу.
    
    Не удалось произвести запись в файл: { $path }
update-setting-write-failure-title2 = Ошибка при сохранении настроек обновления
# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message2 =
    { -brand-short-name } столкнулся с ошибкой и не смог сохранить это изменение. Обратите внимание, что для изменения этой настройки обновления необходимо разрешение на запись в указанный ниже файл. Вы или системный администратор можете исправить эту проблему, если предоставите группе «Пользователи» полный доступ к этому файлу.
    
    Не удалось произвести запись в файл: { $path }
update-in-progress-title = Идёт обновление
update-in-progress-message = Вы хотите продолжить обновление { -brand-short-name }?
update-in-progress-ok-button = &Отменить
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Продолжить

## General Section - Performance

performance-title = Производительность
performance-use-recommended-settings-checkbox =
    .label = Использовать рекомендуемые настройки производительности
    .accesskey = н
performance-use-recommended-settings-desc = Эти настройки рассчитаны для вашего компьютера и операционной системы.
performance-settings-learn-more = Подробнее
performance-allow-hw-accel =
    .label = По возможности использовать аппаратное ускорение
    .accesskey = л
performance-limit-content-process-option = Максимальное число процессов контента
    .accesskey = в
performance-limit-content-process-enabled-desc = Дополнительные процессы контента могут улучшить производительность при работе со множеством вкладок, но также повысят потребление памяти.
performance-limit-content-process-blocked-desc = Изменение числа процессов контента возможно только в мультипроцессном { -brand-short-name }. <a data-l10n-name="learn-more">Узнайте, как проверить, включена ли мультипроцессность</a>
# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (по умолчанию)

## General Section - Browsing

browsing-title = Просмотр сайтов
browsing-use-autoscroll =
    .label = Использовать автоматическую прокрутку
    .accesskey = с
browsing-use-smooth-scrolling =
    .label = Использовать плавную прокрутку
    .accesskey = о
browsing-use-onscreen-keyboard =
    .label = При необходимости отображать сенсорную клавиатуру
    .accesskey = н
browsing-use-cursor-navigation =
    .label = Всегда использовать клавиши курсора для навигации по страницам
    .accesskey = к
browsing-search-on-start-typing =
    .label = Искать текст на странице по мере его набора
    .accesskey = а
browsing-picture-in-picture-toggle-enabled =
    .label = Включить управление видео «Картинка в картинке»
    .accesskey = ю
browsing-picture-in-picture-learn-more = Подробнее
browsing-media-control =
    .label = Управлять медиа через клавиатуру, гарнитуру или виртуальный интерфейс
    .accesskey = п
browsing-media-control-learn-more = Подробнее
browsing-cfr-recommendations =
    .label = Рекомендовать расширения при просмотре
    .accesskey = к
browsing-cfr-features =
    .label = Рекомендовать функции при просмотре
    .accesskey = ф
browsing-cfr-recommendations-learn-more = Подробнее

## General Section - Proxy

network-settings-title = Параметры сети
network-proxy-connection-description = Настроить, как { -brand-short-name } соединяется с Интернетом.
network-proxy-connection-learn-more = Подробнее
network-proxy-connection-settings =
    .label = Настроить…
    .accesskey = с

## Home Section

home-new-windows-tabs-header = Новые окна и вкладки
home-new-windows-tabs-description2 = Выберите, что вы хотите увидеть, когда откроете домашнюю страницу, новые окна и новые вкладки.

## Home Section - Home Page Customization

home-homepage-mode-label = Домашняя страница и новые окна
home-newtabs-mode-label = Новые вкладки
home-restore-defaults =
    .label = Восстановить по умолчанию
    .accesskey = о
# "Waterfox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Домашняя страница Firefox (по умолчанию)
home-mode-choice-custom =
    .label = Мой URL...
home-mode-choice-blank =
    .label = Пустая страница
home-homepage-custom-url =
    .placeholder = Вставьте URL...
# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Использовать текущую страницу
           *[other] Использовать текущие страницы
        }
    .accesskey = п
choose-bookmark =
    .label = Использовать закладку…
    .accesskey = в

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Домашняя страница Firefox
home-prefs-content-description = Выберите, какое содержимое вы хотите видеть на домашней странице Firefox.
home-prefs-search-header =
    .label = Поиск в Интернете
home-prefs-topsites-header =
    .label = Топ сайтов
home-prefs-topsites-description = Сайты, которые вы чаще всего посещаете
home-prefs-topsites-by-option-sponsored =
    .label = Топ сайтов спонсоров
home-prefs-shortcuts-header =
    .label = Ярлыки
home-prefs-shortcuts-description = Сохранённые или посещаемые сайты
home-prefs-shortcuts-by-option-sponsored =
    .label = Спонсируемые ярлыки

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Рекомендовано { $provider }
home-prefs-recommended-by-description-update = Интересные материалы из Интернета, подобранные { $provider }
home-prefs-recommended-by-description-new = Особый контент, курируемый { $provider }, частью семейства { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Как это работает
home-prefs-recommended-by-option-sponsored-stories =
    .label = Статьи спонсоров
home-prefs-highlights-header =
    .label = Избранное
home-prefs-highlights-description = Избранные сайты, которые вы сохранили или посещали
home-prefs-highlights-option-visited-pages =
    .label = Посещённые страницы
home-prefs-highlights-options-bookmarks =
    .label = Закладки
home-prefs-highlights-option-most-recent-download =
    .label = Недавние загрузки
home-prefs-highlights-option-saved-to-pocket =
    .label = Страницы, сохранённые в { -pocket-brand-name }
home-prefs-recent-activity-header =
    .label = Последние действия
home-prefs-recent-activity-description = Подборка недавних сайтов и контента
# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Заметки
home-prefs-snippets-description = Обновления от { -vendor-short-name } и { -brand-product-name }
home-prefs-snippets-description-new = Советы и новости от { -vendor-short-name } и { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } строка
            [few] { $num } строки
           *[many] { $num } строк
        }

## Search Section

search-bar-header = Панель поиска
search-bar-hidden =
    .label = Использовать адресную строку для поиска и навигации
search-bar-shown =
    .label = Добавить панель поиска на панель инструментов
search-engine-default-header = Поисковая система по умолчанию
search-engine-default-desc-2 = Это ваша поисковая система по умолчанию в адресной строке и панели поиска. Вы можете сменить её в любое время.
search-engine-default-private-desc-2 = Выберите другую поисковую систему по умолчанию для использования только в Приватных окнах
search-separate-default-engine =
    .label = Использовать в Приватных окнах эту поисковую систему
    .accesskey = п
search-suggestions-header = Поисковые предложения
search-suggestions-desc = Выберите, где будут появляться предложения от поисковых систем.
search-suggestions-option =
    .label = Отображать поисковые предложения
    .accesskey = о
search-show-suggestions-url-bar-option =
    .label = Отображать поисковые предложения при использовании панели адреса
    .accesskey = ж
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Отображать поисковые предложения перед историей веб-сёрфинга при использовании панели адреса
search-show-suggestions-private-windows =
    .label = Отображать поисковые предложения в Приватных окнах
suggestions-addressbar-settings-generic = Изменить другие настройки предложений в адресной строке
suggestions-addressbar-settings-generic2 = Изменить другие настройки предложений в адресной строке
search-suggestions-cant-show = При использовании панели адреса поисковые предложения отображаться не будут, так как вы настроили { -brand-short-name } никогда не запоминать историю.
search-one-click-header = Поиск одним щелчком
search-one-click-header2 = Значки поисковых систем
search-one-click-desc = Выберите альтернативные поисковые системы, которые появятся под панелью адреса и панелью поиска, когда вы начнёте вводить ключевое слово.
search-choose-engine-column =
    .label = Поисковая система
search-choose-keyword-column =
    .label = Краткое имя
search-restore-default =
    .label = Восстановить набор поисковых систем по умолчанию
    .accesskey = а
search-remove-engine =
    .label = Удалить
    .accesskey = и
search-add-engine =
    .label = Добавить
    .accesskey = в
search-find-more-link = Найти другие поисковые системы
# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Краткое имя уже используется
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Вы выбрали краткое имя, которое в данный момент используется «{ $name }». Пожалуйста, выберите другое.
search-keyword-warning-bookmark = Вы выбрали краткое имя, которое в данный момент используется одной из закладок. Пожалуйста, выберите другое.

## Containers Section

containers-back-button =
    .aria-label =
        { PLATFORM() ->
            [windows] Вернуться в настройки
           *[other] Вернуться в настройки
        }
containers-back-button2 =
    .aria-label = Вернуться в настройки
containers-header = Вкладки в контейнере
containers-add-button =
    .label = Добавить новый контейнер
    .accesskey = а
containers-new-tab-check =
    .label = Выбирать контейнер для каждой новой вкладки
    .accesskey = ы
containers-preferences-button =
    .label = Настройки
containers-settings-button =
    .label = Настройки
containers-remove-button =
    .label = Удалить

## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Возьмите свой Интернет с собой
sync-signedout-description = Синхронизируйте свои закладки, историю, вкладки, пароли, дополнения и настройки на всех ваших устройствах.
sync-signedout-account-signin2 =
    .label = Войти в { -sync-brand-short-name(case: "accusative") }…
    .accesskey = о
sync-signedout-description2 = Синхронизируйте свои закладки, историю, вкладки, пароли, дополнения и настройки со всеми своими устройствами.
sync-signedout-account-signin3 =
    .label = Войти в Синхронизацию…
    .accesskey = о
# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Загрузите Firefox для <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> или <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS,</a> чтобы синхронизироваться со своим мобильным устройством.

## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Изменить фотографию в профиле
sync-sign-out =
    .label = Выйти…
    .accesskey = ы
sync-manage-account = Управление аккаунтом
    .accesskey = в
sync-signedin-unverified = { $email } не подтверждён.
sync-signedin-login-failure = Войдите для повтора соединения с { $email }
sync-resend-verification =
    .label = Повторить отправку подтверждения
    .accesskey = и
sync-remove-account =
    .label = Удалить аккаунт
    .accesskey = л
sync-sign-in =
    .label = Войти
    .accesskey = о

## Sync section - enabling or disabling sync.

prefs-syncing-on = Синхронизация: ВКЛЮЧЕНА
prefs-syncing-off = Синхронизация: ОТКЛЮЧЕНА
prefs-sync-setup =
    .label = Настроить { -sync-brand-short-name(case: "accusative") }…
    .accesskey = а
prefs-sync-offer-setup-label = Синхронизируйте свои закладки, историю, вкладки, пароли, дополнения и настройки на всех ваших устройствах.
prefs-sync-turn-on-syncing =
    .label = Включить синхронизацию…
    .accesskey = ю
prefs-sync-offer-setup-label2 = Синхронизируйте свои закладки, историю, вкладки, пароли, дополнения и настройки со всеми своими устройствами.
prefs-sync-now =
    .labelnotsyncing = Синхронизировать
    .accesskeynotsyncing = х
    .labelsyncing = Синхронизирую…

## The list of things currently syncing.

sync-currently-syncing-heading = Сейчас вы синхронизируете:
sync-currently-syncing-bookmarks = Закладки
sync-currently-syncing-history = Историю
sync-currently-syncing-tabs = Открытые вкладки
sync-currently-syncing-logins-passwords = Логины и пароли
sync-currently-syncing-addresses = Адреса
sync-currently-syncing-creditcards = Банковские карты
sync-currently-syncing-addons = Дополнения
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Настройки
       *[other] Настройки
    }
sync-currently-syncing-settings = Настройки
sync-change-options =
    .label = Изменить…
    .accesskey = м

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Выберите, что синхронизировать
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Сохранить изменения
    .buttonaccesskeyaccept = х
    .buttonlabelextra2 = Отсоединить…
    .buttonaccesskeyextra2 = е
sync-engine-bookmarks =
    .label = Закладки
    .accesskey = к
sync-engine-history =
    .label = Историю
    .accesskey = т
sync-engine-tabs =
    .label = Открытые вкладки
    .tooltiptext = Список того, что открыто на всех синхронизированных устройствах
    .accesskey = л
sync-engine-logins-passwords =
    .label = Логины и пароли
    .tooltiptext = Сохранённые вами имена пользователей и пароли
    .accesskey = н
sync-engine-addresses =
    .label = Адреса
    .tooltiptext = Сохранённые вами почтовые адреса (только для компьютера)
    .accesskey = с
sync-engine-creditcards =
    .label = Банковские карты
    .tooltiptext = Имена, номера и сроки действия (только для компьютера)
    .accesskey = н
sync-engine-addons =
    .label = Дополнения
    .tooltiptext = Расширения и темы для Firefox на компьютере
    .accesskey = п
sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Настройки
           *[other] Настройки
        }
    .tooltiptext = Изменённые вами настройки: Общие, Приватность и Защита
    .accesskey = й
sync-engine-settings =
    .label = Настройки
    .tooltiptext = Изменённые вами общие настройки, настройки приватности и безопасности
    .accesskey = а

## The device name controls.

sync-device-name-header = Имя устройства
sync-device-name-change =
    .label = Изменить имя устройства…
    .accesskey = м
sync-device-name-cancel =
    .label = Отмена
    .accesskey = е
sync-device-name-save =
    .label = Сохранить
    .accesskey = х
sync-connect-another-device = Подключить другое устройство

## Privacy Section

privacy-header = Приватность браузера

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Логины и пароли
    .searchkeywords = { -lockwise-brand-short-name }
# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Запрашивать сохранение логинов и паролей для веб-сайтов
    .accesskey = ш
forms-exceptions =
    .label = Исключения…
    .accesskey = ю
forms-generate-passwords =
    .label = Предлагать и генерировать надежные пароли
    .accesskey = н
forms-breach-alerts =
    .label = Показывать уведомления о паролях для взломанных сайтов
    .accesskey = ы
forms-breach-alerts-learn-more-link = Подробнее
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Автозаполнять логины и пароли
    .accesskey = в
forms-saved-logins =
    .label = Сохранённые логины…
    .accesskey = х
forms-master-pw-use =
    .label = Использовать мастер-пароль
    .accesskey = о
forms-primary-pw-use =
    .label = Использовать мастер-пароль
    .accesskey = о
forms-primary-pw-learn-more-link = Подробнее
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Сменить мастер-пароль…
    .accesskey = м
forms-master-pw-fips-title = Вы работаете в режиме соответствия FIPS. При работе в этом режиме необходимо установить мастер-пароль.
forms-primary-pw-change =
    .label = Сменить мастер-пароль…
    .accesskey = м
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = { "" }
forms-primary-pw-fips-title = Вы работаете в режиме соответствия FIPS. При работе в этом режиме необходимо установить мастер-пароль.
forms-master-pw-fips-desc = Смена пароля не удалась

## OS Authentication dialog

# This message can be seen by trying to add a Master Password.
master-password-os-auth-dialog-message-win = Чтобы создать мастер-пароль, введите ваши учётные данные для входа в Windows. Это поможет защитить безопасность ваших аккаунтов.
# This message can be seen by trying to add a Master Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
master-password-os-auth-dialog-message-macosx = создать мастер-пароль
# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Чтобы создать мастер-пароль, введите ваши учётные данные для входа в Windows. Это поможет защитить безопасность ваших аккаунтов.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Firefox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = создать мастер-пароль
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = История
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = { -brand-short-name }
    .accesskey = i
history-remember-option-all =
    .label = будет запоминать историю
history-remember-option-never =
    .label = не будет запоминать историю
history-remember-option-custom =
    .label = будет использовать ваши настройки хранения истории
history-remember-description = { -brand-short-name } будет помнить историю посещений, загрузок, поиска и сохранять данные форм.
history-dontremember-description = { -brand-short-name } будет использовать те же настройки, что и при приватном просмотре, и не будет помнить историю вашей работы с веб-сайтами.
history-private-browsing-permanent =
    .label = Всегда работать в режиме приватного просмотра
    .accesskey = т
history-remember-browser-option =
    .label = Помнить историю посещений и загрузок
    .accesskey = и
history-remember-search-option =
    .label = Помнить историю поиска и данных форм
    .accesskey = и
history-clear-on-close-option =
    .label = Удалять историю при закрытии { -brand-short-name }
    .accesskey = я
history-clear-on-close-settings =
    .label = Параметры…
    .accesskey = ы
history-clear-button =
    .label = Удалить историю…
    .accesskey = л

## Privacy Section - Site Data

sitedata-header = Куки и данные сайтов
sitedata-total-size-calculating = Вычисление объема данных сайтов и кэша…
# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Ваши сохранённые куки, данные сайтов и кэш сейчас занимают на диске { $value } { $unit }.
sitedata-learn-more = Подробнее
sitedata-delete-on-close =
    .label = Удалять куки и данные сайтов при закрытии { -brand-short-name }
    .accesskey = д
sitedata-delete-on-close-private-browsing = В режиме постоянного приватного просмотра, куки и данные сайтов всегда будут удаляться при закрытии { -brand-short-name }.
sitedata-allow-cookies-option =
    .label = Принимать куки и данные сайтов
    .accesskey = и
sitedata-disallow-cookies-option =
    .label = Блокировать куки и данные сайтов
    .accesskey = о
# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Тип заблокированного
    .accesskey = п
sitedata-option-block-cross-site-trackers =
    .label = Межсайтовые трекеры
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Межсайтовые и социальные трекеры
sitedata-option-block-cross-site-tracking-cookies-including-social-media =
    .label = Межсайтовые отслеживающие куки — включая куки социальных сетей
sitedata-option-block-cross-site-cookies-including-social-media =
    .label = Межсайтовые куки — включая куки социальных сетей
sitedata-option-block-cross-site-and-social-media-trackers-plus-isolate =
    .label = Межсайтовые и социальные трекеры, а также изолировать оставшиеся куки
sitedata-option-block-unvisited =
    .label = Куки с непосещённых сайтов
sitedata-option-block-all-third-party =
    .label = Все сторонние куки (может нарушить работу веб-сайтов)
sitedata-option-block-all =
    .label = Все куки (нарушит работу веб-сайтов)
sitedata-clear =
    .label = Удалить данные…
    .accesskey = а
sitedata-settings =
    .label = Управление данными…
    .accesskey = ы
sitedata-cookies-permissions =
    .label = Управление разрешениями…
    .accesskey = п
sitedata-cookies-exceptions =
    .label = Управление исключениями…
    .accesskey = ю

## Privacy Section - Address Bar

addressbar-header = Панель адреса
addressbar-suggest = При использовании панели адреса предлагать ссылки
addressbar-locbar-history-option =
    .label = из журнала посещений
    .accesskey = ж
addressbar-locbar-bookmarks-option =
    .label = из закладок
    .accesskey = д
addressbar-locbar-openpage-option =
    .label = из открытых вкладок
    .accesskey = к
# Shortcuts refers to the shortcut tiles on the new tab page, previously known as top sites. Translation should be consistent.
addressbar-locbar-shortcuts-option =
    .label = из ярлыков
    .accesskey = з
addressbar-locbar-topsites-option =
    .label = из топа сайтов
    .accesskey = й
addressbar-locbar-engines-option =
    .label = из поисковых систем
    .accesskey = ы
addressbar-suggestions-settings = Изменить настройки для предложений поисковых систем

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Улучшенная защита от отслеживания
content-blocking-section-top-level-description = Трекеры отслеживают вас в Интернете, чтобы собирать информацию о ваших привычках и интересах. { -brand-short-name } блокирует многие из этих трекеров и других вредоносных скриптов.
content-blocking-learn-more = Подробнее
content-blocking-fpi-incompatibility-warning = Вы используете First Party Isolation (FPI), которая переопределяет некоторые настройки кук { -brand-short-name }.

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Стандартная
    .accesskey = н
enhanced-tracking-protection-setting-strict =
    .label = Строгая
    .accesskey = о
enhanced-tracking-protection-setting-custom =
    .label = Персональная
    .accesskey = а

##

content-blocking-etp-standard-desc = Баланс защиты и производительности. Страницы будут загружаться нормально.
content-blocking-etp-strict-desc = Усиленная защита может вызывать проблемы с некоторыми сайтами и их содержимым.
content-blocking-etp-custom-desc = Выберите, какие трекеры и скрипты необходимо блокировать.
content-blocking-etp-blocking-desc = { -brand-short-name } блокирует следующее:
content-blocking-private-windows = Отслеживающее содержимое в приватных окнах
content-blocking-cross-site-cookies-in-all-windows = Межсайтовые куки во всех окнах (включая отслеживающие куки)
content-blocking-cross-site-tracking-cookies = Межсайтовые отслеживающие куки
content-blocking-all-cross-site-cookies-private-windows = Межсайтовые куки в Приватных окнах
content-blocking-cross-site-tracking-cookies-plus-isolate = Межсайтовые отслеживающие куки, а также изолировать оставшиеся куки
content-blocking-social-media-trackers = Трекеры социальных сетей
content-blocking-all-cookies = Все куки
content-blocking-unvisited-cookies = Куки с непосещённых сайтов
content-blocking-all-windows-tracking-content = Отслеживающее содержимое во всех окнах
content-blocking-all-third-party-cookies = Все сторонние куки
content-blocking-cryptominers = Криптомайнеры
content-blocking-fingerprinters = Сборщики цифровых отпечатков
content-blocking-warning-title = Осторожно!
content-blocking-and-isolating-etp-warning-description = Блокировка трекеров и изоляция куков может нарушить работу некоторых сайтов. Перезагрузите страницу с трекерами, чтобы загрузить все содержимое.
content-blocking-and-isolating-etp-warning-description-2 = Эта настройка может вызвать ошибки отображения содержимого или нарушение корректной работы некоторых веб-сайтов. Если кажется, что сайт не работает, вам, возможно, понадобится отключить защиту от отслеживания на этом сайте, чтобы загрузить всё его содержимое.
content-blocking-warning-learn-how = Подробнее
content-blocking-reload-description = Вам понадобится обновить свои вкладки, чтобы применить эти изменения.
content-blocking-reload-tabs-button =
    .label = Обновить все вкладки
    .accesskey = н
content-blocking-tracking-content-label =
    .label = Отслеживающее содержимое
    .accesskey = ж
content-blocking-tracking-protection-option-all-windows =
    .label = Во всех окнах
    .accesskey = е
content-blocking-option-private =
    .label = Только в приватных окнах
    .accesskey = и
content-blocking-tracking-protection-change-block-list = Сменить список блокировки
content-blocking-cookies-label =
    .label = Куки
    .accesskey = и
content-blocking-expand-section =
    .tooltiptext = Дополнительная информация
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Криптомайнеры
    .accesskey = п
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Сборщики цифровых отпечатков
    .accesskey = о

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Управление исключениями…
    .accesskey = е

## Privacy Section - Permissions

permissions-header = Разрешения
permissions-location = Местоположение
permissions-location-settings =
    .label = Параметры…
    .accesskey = м
permissions-xr = Виртуальная реальность
permissions-xr-settings =
    .label = Параметры…
    .accesskey = м
permissions-camera = Камера
permissions-camera-settings =
    .label = Параметры…
    .accesskey = а
permissions-microphone = Микрофон
permissions-microphone-settings =
    .label = Параметры…
    .accesskey = ы
permissions-notification = Уведомления
permissions-notification-settings =
    .label = Параметры…
    .accesskey = е
permissions-notification-link = Подробнее
permissions-notification-pause =
    .label = Отключить уведомления до перезапуска { -brand-short-name }
    .accesskey = ю
permissions-autoplay = Автовоспроизведение
permissions-autoplay-settings =
    .label = Параметры…
    .accesskey = м
permissions-block-popups =
    .label = Блокировать всплывающие окна
    .accesskey = о
permissions-block-popups-exceptions =
    .label = Исключения…
    .accesskey = ю
permissions-addon-install-warning =
    .label = Предупреждать при попытке веб-сайтов установить дополнения
    .accesskey = е
permissions-addon-exceptions =
    .label = Исключения…
    .accesskey = с
permissions-a11y-privacy-checkbox =
    .label = Запретить службам поддержки доступности доступ к вашему браузеру
    .accesskey = е
permissions-a11y-privacy-link = Подробнее

## Privacy Section - Data Collection

collection-header = Сбор и использование данных { -brand-short-name }
collection-description = Мы стремимся предоставить вам выбор и собирать только то, что нам нужно, для выпуска и улучшения { -brand-short-name } для всех и каждого. Мы всегда спрашиваем разрешения перед получением личной информации.
collection-privacy-notice = Уведомление о конфиденциальности
collection-health-report-telemetry-disabled = Вы больше не разрешаете { -vendor-short-name } собирать технические данные и данные взаимодействия. Все собранные ранее данные будут удалены в течение 30 дней.
collection-health-report-telemetry-disabled-link = Подробнее
collection-health-report =
    .label = Разрешить { -brand-short-name } отправлять технические данные и данные взаимодействия в { -vendor-short-name }
    .accesskey = е
collection-health-report-link = Подробнее
collection-studies =
    .label = Разрешить { -brand-short-name } устанавливать и проводить исследования
collection-studies-link = Просмотреть исследования { -brand-short-name }
addon-recommendations =
    .label = Разрешить { -brand-short-name } давать персональные рекомендации расширений
addon-recommendations-link = Подробнее
# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Для этой конфигурации сборки отправка данных отключена
collection-backlogged-crash-reports =
    .label = Разрешить { -brand-short-name } отправлять от вашего имени накопившиеся сообщения о падениях
    .accesskey = ш
collection-backlogged-crash-reports-link = Подробнее
collection-backlogged-crash-reports-with-link = Разрешить { -brand-short-name } отправлять от вашего имени накопившиеся сообщения о падениях <a data-l10n-name="crash-reports-link">Подробнее</a>
    .accesskey = ш

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Защита
security-browsing-protection = Поддельное содержимое и защита от вредоносных программ
security-enable-safe-browsing =
    .label = Блокировать опасное и обманывающее содержимое
    .accesskey = л
security-enable-safe-browsing-link = Подробнее
security-block-downloads =
    .label = Блокировать опасные загрузки
    .accesskey = к
security-block-uncommon-software =
    .label = Предупреждать о нежелательных и редко загружаемых программах
    .accesskey = ж

## Privacy Section - Certificates

certs-header = Сертификаты
certs-personal-label = Когда сервер запрашивает личный сертификат
certs-select-auto-option =
    .label = Отправлять автоматически
    .accesskey = а
certs-select-ask-option =
    .label = Спрашивать каждый раз
    .accesskey = ш
certs-enable-ocsp =
    .label = Запрашивать у OCSP-серверов подтверждение текущего статуса сертификатов
    .accesskey = п
certs-view =
    .label = Просмотр сертификатов…
    .accesskey = м
certs-devices =
    .label = Устройства защиты…
    .accesskey = т
space-alert-learn-more-button =
    .label = Подробнее
    .accesskey = о
space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Открыть настройки
           *[other] Открыть настройки
        }
    .accesskey =
        { PLATFORM() ->
            [windows] ы
           *[other] ы
        }
space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] У { -brand-short-name } заканчивается место на диске. Содержимое веб-сайтов может отображаться неправильно. Вы можете удалить сохранённые данные через Настройки > Приватность и Защита > Куки и данные сайтов.
       *[other] У { -brand-short-name } заканчивается место на диске. Содержимое веб-сайтов может отображаться неправильно. Вы можете удалить сохранённые данные через Настройки > Приватность и Защита > Куки и данные сайтов.
    }
space-alert-under-5gb-ok-button =
    .label = OK, понятно
    .accesskey = я
space-alert-under-5gb-message = У { -brand-short-name } заканчивается место на диске. Содержимое веб-сайтов может отображаться неправильно. Щёлкните «Подробнее», чтобы оптимизировать использование вашего диска для улучшения веб-сёрфинга.
space-alert-over-5gb-settings-button =
    .label = Открыть Настройки
    .accesskey = к
space-alert-over-5gb-message2 = <strong>У { -brand-short-name } заканчивается место на диске.</strong> Содержимое веб-сайтов может отображаться некорректно. Вы можете удалить сохранённые данные через Настройки > Приватность и Защита > Куки и данные сайтов.
space-alert-under-5gb-message2 = <strong>У { -brand-short-name } заканчивается место на диске.</strong> Содержимое веб-сайтов может отображаться некорректно. Щёлкните «Подробнее», чтобы оптимизировать использование вашего диска для улучшения веб-сёрфинга.

## Privacy Section - HTTPS-Only

httpsonly-header = Режим «Только HTTPS»
httpsonly-description = HTTPS обеспечивает безопасное и зашифрованное соединение между { -brand-short-name } и веб-сайтами, которые вы посещаете. Большинство веб-сайтов поддерживают HTTPS, и если включён режим «Только HTTPS», то { -brand-short-name } переключит все соединения на HTTPS.
httpsonly-learn-more = Подробнее
httpsonly-radio-enabled =
    .label = Включить режим «Только HTTPS» во всех окнах
httpsonly-radio-enabled-pbm =
    .label = Включить режим «Только HTTPS» только в приватных окнах
httpsonly-radio-disabled =
    .label = Не включать режим «Только HTTPS»

## The following strings are used in the Download section of settings

desktop-folder-name = Рабочий стол
downloads-folder-name = Загрузки
choose-download-folder-title = Выберите папку для загрузок:
# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Сохранять файлы в { $service-name }
