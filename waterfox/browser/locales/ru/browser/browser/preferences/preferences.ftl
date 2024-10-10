# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Отправлять сайтам сигнал «Не отслеживать», означающий, что вы не хотите, чтобы вас отслеживали
do-not-track-description2 =
    .label = Отправлять веб-сайтам запрос «Не отслеживать»
    .accesskey = в
do-not-track-learn-more = Подробнее
do-not-track-option-default-content-blocking-known =
    .label = Только когда { -brand-short-name } настроен на блокировку известных трекеров
do-not-track-option-always =
    .label = Всегда
global-privacy-control-description =
    .label = Сообщать веб-сайтам, чтобы они не продавали и не разглашали мои данные
    .accesskey = ы
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
##   $name (string) - Name of the extension

# This string is shown to notify the user that the password manager setting
# is being controlled by an extension
extension-controlling-password-saving = <img data-l10n-name="icon"/> <strong>{ $name }</strong> управляет этой настройкой.
# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlling-web-notifications = <img data-l10n-name="icon"/> <strong>{ $name }</strong> управляет этой настройкой.
# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlling-privacy-containers = <img data-l10n-name="icon"/> <strong>{ $name }</strong> требует для своей работы «Вкладки в контейнере».
# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlling-websites-content-blocking-all-trackers = <img data-l10n-name="icon"/> <strong>{ $name }</strong> управляет этой настройкой.
# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlling-proxy-config = <img data-l10n-name ="icon"/> <strong>{ $name }</strong> контролирует способ соединения { -brand-short-name } с Интернетом.
# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Чтобы включить расширение, перейдите в пункт <img data-l10n-name="addons-icon"/> Дополнения меню <img data-l10n-name="menu-icon"/>.

## Preferences UI Search Results

search-results-header = Результаты поиска
# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message2 = Извините! В настройках не найдено результатов для «<span data-l10n-name="query"></span>».
search-results-help-link = Нужна помощь? Посетите <a data-l10n-name="url">Сайт поддержки { -brand-short-name }</a>

## General Section

startup-header = Запуск
always-check-default =
    .label = Всегда проверять, является ли { -brand-short-name } вашим браузером по умолчанию
    .accesskey = а
is-default = В настоящий момент { -brand-short-name } является вашим браузером по умолчанию
is-not-default = { -brand-short-name } не является вашим браузером по умолчанию
set-as-my-default-browser =
    .label = Сделать браузером по умолчанию…
    .accesskey = у
startup-restore-windows-and-tabs =
    .label = Открыть предыдущие окна и вкладки
    .accesskey = п
startup-restore-warn-on-quit =
    .label = Предупреждать при выходе из браузера
disable-extension =
    .label = Отключить расширение
preferences-data-migration-header = Импорт данных браузера
preferences-data-migration-description = Импорт закладок, паролей, истории и данных автозаполнения в { -brand-short-name }.
preferences-data-migration-button =
    .label = Импорт данных
    .accesskey = м
tabs-group-header = Вкладки
ctrl-tab-recently-used-order =
    .label = Ctrl+Tab переключает между вкладками в порядке недавнего использования
    .accesskey = ж
open-new-link-as-tabs =
    .label = Открывать ссылки во вкладках вместо новых окон
    .accesskey = ы
confirm-on-close-multiple-tabs =
    .label = Подтвердить перед закрытием нескольких вкладок
    .accesskey = е
# This string is used for the confirm before quitting preference.
# Variables:
#   $quitKey (string) - the quit keyboard shortcut, and formatted
#                       in the same manner as it would appear,
#                       for example, in the File menu.
confirm-on-quit-with-key =
    .label = Подтвердить перед выходом с помощью { $quitKey }
    .accesskey = м
warn-on-open-many-tabs =
    .label = Предупреждать, когда открытие нескольких вкладок может замедлить { -brand-short-name }
    .accesskey = р
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

## Variables:
##   $tabCount (number) - Number of tabs

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

##

containers-disable-alert-cancel-button = Оставить включёнными
containers-remove-alert-title = Удалить этот контейнер?
# Variables:
#   $count (number) - Number of tabs that will be closed.
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
preferences-web-appearance-header = Внешний вид сайтов
preferences-web-appearance-description = Некоторые сайты изменяют свою цветовую схему в зависимости от ваших предпочтений. Выберите цветовую схему, которую вы хотите использовать для этих сайтов.
preferences-web-appearance-choice-auto = Автоматически
preferences-web-appearance-choice-light = Светлая
preferences-web-appearance-choice-dark = Тёмная
preferences-web-appearance-choice-tooltip-auto =
    .title = Автоматически менять фон и содержимое сайтов в зависимости от ваших системных настроек и темы { -brand-short-name }.
preferences-web-appearance-choice-tooltip-light =
    .title = Использовать светлый вид для фона и содержимого сайтов.
preferences-web-appearance-choice-tooltip-dark =
    .title = Использовать тёмный вид для фона и содержимого сайтов.
preferences-web-appearance-choice-input-auto =
    .aria-description = { preferences-web-appearance-choice-tooltip-auto.title }
preferences-web-appearance-choice-input-light =
    .aria-description = { preferences-web-appearance-choice-tooltip-light.title }
preferences-web-appearance-choice-input-dark =
    .aria-description = { preferences-web-appearance-choice-tooltip-dark.title }
# This can appear when using windows HCM or "Override colors: always" without
# system colors.
preferences-web-appearance-override-warning = Выбранные вами цвета изменяют внешний вид сайтов. <a data-l10n-name="colors-link">Управлять цветами</a>
# This message contains one link. It can be moved within the sentence as needed
# to adapt to your language, but should not be changed.
preferences-web-appearance-footer = Управляйте темами { -brand-short-name } в разделе <a data-l10n-name="themes-link">«Расширения и темы»</a>
preferences-colors-header = Цвета
preferences-colors-description = Переопределяйте цвета { -brand-short-name } по умолчанию для текста, фона сайтов и ссылок.
preferences-colors-manage-button =
    .label = Управление цветами…
    .accesskey = м
preferences-fonts-header = Шрифты
default-font = Шрифт по умолчанию
    .accesskey = ф
default-font-size = Размер
    .accesskey = м
advanced-fonts =
    .label = Дополнительно…
    .accesskey = н
# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Масштаб
preferences-default-zoom = Масштаб по умолчанию
    .accesskey = ш
# Variables:
#   $percentage (number) - Zoom percentage value
preferences-default-zoom-value =
    .label = { $percentage }%
preferences-zoom-text-only =
    .label = Только текст
    .accesskey = о
language-header = Язык
choose-language-description = Выберите язык, предпочитаемый вами для отображения страниц
choose-button =
    .label = Выбрать…
    .accesskey = ы
choose-browser-language-description = Выберите язык отображения меню, сообщений и уведомлений от { -brand-short-name }.
manage-browser-languages-button =
    .label = Выбрать другие…
    .accesskey = ы
confirm-browser-language-change-description = Перезапустите { -brand-short-name } для применения этих изменений
confirm-browser-language-change-button = Применить и перезапустить
translate-web-pages =
    .label = Перевод страниц
    .accesskey = и
fx-translate-web-pages = { -translations-brand-name }
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

files-and-applications-title = Файлы и приложения
download-header = Загрузки
download-save-where = Путь для сохранения файлов
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
            [macos] Использовать приложение macOS по умолчанию
            [windows] Использовать приложение Windows по умолчанию
           *[other] Использовать системное приложение по умолчанию
        }
applications-use-other =
    .label = Использовать другое…
applications-select-helper = Выберите вспомогательное приложение
applications-manage-app =
    .label = Сведения о приложении…
applications-always-ask =
    .label = Всегда спрашивать
# Variables:
#   $type-description (string) - Description of the type (e.g "Portable Document Format")
#   $type (string) - The MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })
# Variables:
#   $extension (string) - File extension (e.g .TXT)
#   $type (string) - The MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })
# Variables:
#   $plugin-name (string) - Name of a plugin (e.g Adobe Flash)
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

applications-handle-new-file-types-description = Что { -brand-short-name } должен делать с другими файлами?
applications-save-for-new-types =
    .label = Сохранять файлы
    .accesskey = я
applications-ask-before-handling =
    .label = Спрашивать, открывать или сохранять файлы
    .accesskey = ш
drm-content-header = Содержимое, использующее средства защиты авторских прав (DRM)
play-drm-content =
    .label = Воспроизводить защищённое DRM содержимое
    .accesskey = п
play-drm-content-learn-more = Подробнее
update-application-title = Обновления { -brand-short-name }
update-application-description = Используйте последнюю версию { -brand-short-name } для наилучшей производительности, стабильности и безопасности.
# Variables:
# $version (string) - Waterfox version
update-application-version = Версия { $version } <a data-l10n-name="learn-more">Что нового</a>
update-history =
    .label = Показать журнал обновлений…
    .accesskey = ж
update-application-allow-description = Разрешить { -brand-short-name }
update-application-auto =
    .label = Автоматически устанавливать обновления (желательно)
    .accesskey = ч
update-application-check-choose =
    .label = Проверять наличие обновлений, но позволять вам решать, устанавливать ли их
    .accesskey = в
update-application-manual =
    .label = Никогда не проверять наличие обновлений (не желательно)
    .accesskey = и
update-application-background-enabled =
    .label = Когда { -brand-short-name } не запущен
    .accesskey = а
update-application-warning-cross-user-setting = Эта настройка применится ко всем учётным записям Windows и профилям { -brand-short-name }, использующим эту установку { -brand-short-name }.
update-application-use-service =
    .label = Использовать фоновую службу для установки обновлений
    .accesskey = ф
update-application-suppress-prompts =
    .label = Показывать меньше уведомлений об обновлениях
    .accesskey = е
update-setting-write-failure-title2 = Ошибка при сохранении настроек обновления
# Variables:
#   $path (string) - Path to the configuration file
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
performance-limit-content-process-blocked-desc = Изменение числа процессов контента возможно только во многопроцессном { -brand-short-name }. <a data-l10n-name="learn-more">Узнайте, как проверить, включена ли многопроцессность</a>
# Variables:
#   $num (number) - Default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (по умолчанию)

## General Section - Browsing

browsing-title = Просмотр сети
browsing-use-autoscroll =
    .label = Использовать автоматическую прокрутку
    .accesskey = а
browsing-use-smooth-scrolling =
    .label = Использовать плавную прокрутку
    .accesskey = п
browsing-gtk-use-non-overlay-scrollbars =
    .label = Всегда показывать полосы прокрутки
    .accesskey = о
browsing-use-onscreen-keyboard =
    .label = При необходимости показывать сенсорную клавиатуру
    .accesskey = с
browsing-use-cursor-navigation =
    .label = Всегда использовать клавиши курсора для навигации по страницам
    .accesskey = к
browsing-use-full-keyboard-navigation =
    .label = Использовать клавишу табуляции для перемещения фокуса между элементами управления формой и ссылками.
    .accesskey = е
browsing-search-on-start-typing =
    .label = Искать текст на странице по мере его набора
    .accesskey = И
browsing-picture-in-picture-toggle-enabled =
    .label = Включить элементы управления видео «Картинка в картинке»
    .accesskey = а
browsing-picture-in-picture-learn-more = Подробнее
browsing-media-control =
    .label = Управлять воспроизведением звука или видео с помощью клавиатуры, гарнитуры или виртуального интерфейса
    .accesskey = У
browsing-media-control-learn-more = Подробнее
browsing-cfr-recommendations =
    .label = Рекомендовать расширения при просмотре
    .accesskey = р
browsing-cfr-features =
    .label = Рекомендовать функции при просмотре
    .accesskey = ф
browsing-cfr-recommendations-learn-more = Подробнее

## General Section - Proxy

network-settings-title = Настройки сети
network-proxy-connection-description = Настроить, как { -brand-short-name } соединяется с Интернетом.
network-proxy-connection-learn-more = Подробнее
network-proxy-connection-settings =
    .label = Настроить…
    .accesskey = Н

## Home Section

home-new-windows-tabs-header = Новые окна и вкладки
home-new-windows-tabs-description2 = Выберите, что вы хотите увидеть, когда откроете домашнюю страницу, новые окна и новые вкладки.

## Home Section - Home Page Customization

home-homepage-mode-label = Домашняя страница и новые окна
home-newtabs-mode-label = Новые вкладки
home-restore-defaults =
    .label = Восстановить по умолчанию
    .accesskey = о
home-mode-choice-default-fx =
    .label = { -firefox-home-brand-name(case: "nominative") } (По умолчанию)
home-mode-choice-custom =
    .label = Мой сетевой адрес...
home-mode-choice-blank =
    .label = Пустая страница
home-homepage-custom-url =
    .placeholder = Вставьте сетевой адрес...
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

## Home Section - Waterfox Home Content Customization

home-prefs-content-header2 = Содержимое { -firefox-home-brand-name(case: "genitive") }
home-prefs-content-description2 = Выберите, какое содержимое вы хотите видеть на экране { -firefox-home-brand-name(case: "genitive") }.
home-prefs-search-header =
    .label = Поиск в Интернете
home-prefs-shortcuts-header =
    .label = Ярлыки
home-prefs-shortcuts-description = Сохранённые или посещаемые сайты
home-prefs-shortcuts-by-option-sponsored =
    .label = Спонсируемые ярлыки

## Variables:
##  $provider (string) - Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Рекомендовано { $provider }
home-prefs-recommended-by-description-new = Особый контент, курируемый { $provider }, частью семейства { -brand-product-name }

##

home-prefs-recommended-by-learn-more = Как это работает
home-prefs-recommended-by-option-sponsored-stories =
    .label = Статьи спонсоров
home-prefs-recommended-by-option-recent-saves =
    .label = Отображать последние сохранения
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
home-prefs-snippets-description-new = Советы и новости от { -vendor-short-name } и { -brand-product-name }
# Variables:
#   $num (number) - Number of rows displayed
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } строка
            [few] { $num } строки
           *[many] { $num } строк
        }

## Search Section

search-bar-header = Строка поиска
search-bar-hidden =
    .label = Использовать адресную строку для поиска и навигации
search-bar-shown =
    .label = Добавить строку поиска на панель инструментов
search-engine-default-header = Поисковая система по умолчанию
search-engine-default-desc-2 = Это ваша поисковая система по умолчанию в адресной строке и строке поиска. Вы можете сменить её в любое время.
search-engine-default-private-desc-2 = Выберите другую поисковую систему по умолчанию для использования только в приватных окнах
search-separate-default-engine =
    .label = Использовать эту поисковую систему в приватных окнах
    .accesskey = п
search-suggestions-header = Поисковые предложения
search-suggestions-desc = Выберите, где будут появляться предложения от поисковых систем.
search-suggestions-option =
    .label = Отображать поисковые предложения
    .accesskey = о
search-show-suggestions-url-bar-option =
    .label = Отображать поисковые предложения при использовании адресной строки
    .accesskey = ж
# With this option enabled, on the search results page
# the URL will be replaced by the search terms in the address bar
# when using the current default search engine.
search-show-search-term-option =
    .label = Показывать поисковые запросы вместо сетевых адресов на странице выдачи поисковой системы по умолчанию
# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Отображать поисковые предложения перед историей просмотра сети при использовании адресной строки
search-show-suggestions-private-windows =
    .label = Отображать поисковые предложения в приватных окнах
suggestions-addressbar-settings-generic2 = Изменить другие настройки предложений в адресной строке
search-suggestions-cant-show = При использовании адресной строки поисковые предложения отображаться не будут, так как вы настроили { -brand-short-name } никогда не запоминать историю.
search-one-click-header2 = Значки поисковых систем
search-one-click-desc = Выберите иные поисковые системы, которые появятся под адресной строкой и строкой поиска, когда вы начнёте вводить ключевое слово.
search-choose-engine-column =
    .label = Поисковая система
search-choose-keyword-column =
    .label = Ключевое слово
search-restore-default =
    .label = Восстановить поисковые системы по умолчанию
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
search-keyword-warning-title = Ключевое слово уже используется
# Variables:
#   $name (string) - Name of a search engine.
search-keyword-warning-engine = Выбранное ключевое слово уже используется «{ $name }». Пожалуйста, выберите другое.
search-keyword-warning-bookmark = Выбранное ключевое слово уже используется одной из закладок. Пожалуйста, выберите другое.

## Containers Section

containers-back-button2 =
    .aria-label = Вернуться в настройки
containers-header = Вкладки в контейнере
containers-add-button =
    .label = Добавить новый контейнер
    .accesskey = а
containers-new-tab-check =
    .label = Выбирать контейнер для каждой новой вкладки
    .accesskey = ы
containers-settings-button =
    .label = Настройки
containers-remove-button =
    .label = Удалить

## Waterfox account - Signed out. Note that "Sync" and "Waterfox account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Возьмите свой Интернет с собой
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
sync-mobile-promo = Загрузите Waterfox для <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> или <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS,</a> чтобы синхронизироваться со своим мобильным устройством.

## Waterfox account - Signed in

sync-profile-picture =
    .tooltiptext = Изменить фотографию в профиле
sync-sign-out =
    .label = Выйти…
    .accesskey = ы
sync-manage-account = Управление аккаунтом
    .accesskey = в

## Variables
## $email (string) - Email used for Waterfox account

sync-signedin-unverified = { $email } не подтверждён.
sync-signedin-login-failure = Войдите для повтора соединения с { $email }

##

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
prefs-sync-turn-on-syncing =
    .label = Включить синхронизацию…
    .accesskey = ю
prefs-sync-offer-setup-label2 = Синхронизируйте свои закладки, историю, вкладки, пароли, дополнения и настройки со всеми своими устройствами.
prefs-sync-now =
    .labelnotsyncing = Синхронизировать
    .accesskeynotsyncing = х
    .labelsyncing = Синхронизирую…
prefs-sync-now-button =
    .label = Синхронизировать
    .accesskey = т
prefs-syncing-button =
    .label = Синхронизирую…

## The list of things currently syncing.

sync-syncing-across-devices-heading = Вы синхронизируете эти элементы на всех подключённых устройствах:
sync-currently-syncing-bookmarks = Закладки
sync-currently-syncing-history = Историю
sync-currently-syncing-tabs = Открытые вкладки
sync-currently-syncing-logins-passwords = Логины и пароли
sync-currently-syncing-addresses = Адреса
sync-currently-syncing-creditcards = Банковские карты
sync-currently-syncing-addons = Дополнения
sync-currently-syncing-settings = Настройки
sync-change-options =
    .label = Изменить…
    .accesskey = м

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog3 =
    .title = Выберите, что синхронизировать
    .style = min-width: 36em;
    .buttonlabelaccept = Сохранить изменения
    .buttonaccesskeyaccept = х
    .buttonlabelextra2 = Отсоединить…
    .buttonaccesskeyextra2 = е
sync-choose-dialog-subtitle = Изменения в списке элементов для синхронизации будут отражены на всех подключённых устройствах.
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
    .tooltiptext = Расширения и темы для Waterfox на компьютере
    .accesskey = п
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

## These strings are shown in a desktop notification after the
## user requests we resend a verification email.

sync-verification-sent-title = Подтверждение отправлено
# Variables:
#   $email (String): Email address of user's Waterfox account.
sync-verification-sent-body = Ссылка для подтверждения была отправлена на { $email }.
sync-verification-not-sent-title = Не удалось отправить подтверждение
sync-verification-not-sent-body = Мы не можем отправить сейчас письмо для подтверждения, пожалуйста, повторите попытку позже.

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
preferences-relay-integration-checkbox =
    .label = Предлагать псевдонимы электронной почты { -relay-brand-name } для защиты вашего адреса электронной почты
relay-integration-learn-more-link = Подробнее
# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Автозаполнять логины и пароли
    .accesskey = в
forms-saved-logins =
    .label = Сохранённые логины…
    .accesskey = х
forms-primary-pw-use =
    .label = Использовать основной пароль
    .accesskey = с
forms-primary-pw-learn-more-link = Подробнее
# This string uses the former name of the Primary Password feature
# ("Master Password" in English) so that the preferences can be found
# when searching for the old name. The accesskey is unused.
forms-master-pw-change =
    .label = Изменить мастер-пароль…
    .accesskey = з
forms-primary-pw-change =
    .label = Изменить основной пароль…
    .accesskey = з
# Leave this message empty if the translation for "Primary Password" matches
# "Master Password" in your language. If you're editing the FTL file directly,
# use { "" } as the value.
forms-primary-pw-former-name = Ранее — мастер-пароль
forms-primary-pw-fips-title = Сейчас вы находитесь в режиме FIPS. Для работы в этом режиме необходимо установить основной пароль.
forms-master-pw-fips-desc = Смена пароля не удалась
forms-windows-sso =
    .label = Разрешить единый вход Windows для учётных записей Microsoft, учётных записей на работе и в учебных заведениях
forms-windows-sso-learn-more-link = Подробнее
forms-windows-sso-desc = Управление аккаунтами в настройках вашего устройства

## OS Authentication dialog

# This message can be seen by trying to add a Primary Password.
primary-password-os-auth-dialog-message-win = Чтобы создать основной пароль, введите ваши учётные данные для входа в Windows. Это поможет защитить безопасность ваших аккаунтов.
# This message can be seen by trying to add a Primary Password.
# The macOS strings are preceded by the operating system with "Waterfox is trying to "
# and includes subtitle of "Enter password for the user "xxx" to allow this." These
# notes are only valid for English. Please test in your locale.
primary-password-os-auth-dialog-message-macosx = создать основной пароль
master-password-os-auth-dialog-caption = { -brand-full-name }

## Privacy Section - History

history-header = История
# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Waterfox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Waterfox", moving the verb into each option.
#     This will result in "Waterfox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Waterfox history settings:".
history-remember-label = { -brand-short-name }
    .accesskey = i
history-remember-option-all =
    .label = будет запоминать историю
history-remember-option-never =
    .label = не будет запоминать историю
history-remember-option-custom =
    .label = будет использовать ваши настройки хранения истории
history-remember-description = { -brand-short-name } будет помнить историю посещений, загрузок, поиска и сохранять данные форм.
history-dontremember-description = { -brand-short-name } будет использовать те же настройки, что и в приватном режиме, и не будет помнить историю вашей работы с сайтами.
history-private-browsing-permanent =
    .label = Всегда работать в приватном режиме
    .accesskey = и
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
sitedata-total-size-calculating = Вычисление объема данных сайтов и кеша…
# Variables:
#   $value (number) - Value of the unit (for example: 4.6, 500)
#   $unit (string) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Ваши сохранённые куки, данные сайтов и кеш сейчас занимают на диске { $value } { $unit }.
sitedata-learn-more = Подробнее
sitedata-delete-on-close =
    .label = Удалять куки и данные сайтов при закрытии { -brand-short-name }
    .accesskey = д
sitedata-delete-on-close-private-browsing = В постоянном приватном режиме куки и данные сайтов всегда будут удаляться при закрытии { -brand-short-name }.
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
sitedata-option-block-cross-site-tracking-cookies =
    .label = Межсайтовые отслеживающие куки
sitedata-option-block-cross-site-cookies =
    .label = Межсайтовые отслеживающие куки, а также изолировать другие межсайтовые куки
sitedata-option-block-unvisited =
    .label = Куки с непосещённых сайтов
sitedata-option-block-all-cross-site-cookies =
    .label = Все межсайтовые куки (может нарушить работу сайтов)
sitedata-option-block-all =
    .label = Все куки (нарушит работу веб-сайтов)
sitedata-clear =
    .label = Удалить данные…
    .accesskey = а
sitedata-settings =
    .label = Управление данными…
    .accesskey = ы
sitedata-cookies-exceptions =
    .label = Управление исключениями…
    .accesskey = ю

## Privacy Section - Cookie Banner Handling

cookie-banner-handling-header = Уменьшение числа уведомлений о куках
cookie-banner-handling-description = { -brand-short-name } будет автоматически пытаться отклонять запросы на сохранение кук в уведомлениях о куках на поддерживаемых сайтах.
cookie-banner-learn-more = Подробнее
forms-handle-cookie-banners =
    .label = Уменьшить число уведомлений о куках

## Privacy Section - Address Bar

addressbar-header = Адресная строка
addressbar-suggest = При использовании адресной строки предлагать ссылки
addressbar-locbar-history-option =
    .label = из журнала посещений
    .accesskey = ж
addressbar-locbar-bookmarks-option =
    .label = из закладок
    .accesskey = д
addressbar-locbar-clipboard-option =
    .label = из буфера обмена
    .accesskey = м
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
addressbar-locbar-quickactions-option =
    .label = Быстрые действия
    .accesskey = ы
addressbar-suggestions-settings = Изменить настройки для предложений поисковых систем
addressbar-quickactions-learn-more = Подробнее

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Улучшенная защита от отслеживания
content-blocking-section-top-level-description = Трекеры отслеживают вас в Интернете, чтобы собирать сведения о ваших привычках и интересах. { -brand-short-name } блокирует многие из этих трекеров и других вредоносных скриптов.
content-blocking-learn-more = Подробнее
content-blocking-fpi-incompatibility-warning = Вы используете First Party Isolation (FPI), которая переопределяет некоторые настройки кук { -brand-short-name }.
# There is no need to translate "Resist Fingerprinting (RFP)". This is a
# feature that can only be enabled via about:config, and it's not exposed to
# standard users (e.g. via Settings).
content-blocking-rfp-incompatibility-warning = Вы используете функцию защиты от сборщиков цифровых отпечатков (RFP), которая заменяет некоторые настройки защиты от сборщиков цифровых отпечатков { -brand-short-name }. Это может привести к неработоспособности некоторых сайтов.

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

content-blocking-etp-standard-desc = Золотая середина: защита и производительность. Страницы будут загружаться нормально.
content-blocking-etp-strict-desc = Усиленная защита может вызывать проблемы с некоторыми сайтами и их содержимым.
content-blocking-etp-custom-desc = Выберите, какие трекеры и скрипты необходимо блокировать.
content-blocking-etp-blocking-desc = { -brand-short-name } блокирует следующее:
content-blocking-private-windows = Отслеживающее содержимое в приватных окнах
content-blocking-cross-site-cookies-in-all-windows2 = Межсайтовые куки во всех окнах
content-blocking-cross-site-tracking-cookies = Межсайтовые отслеживающие куки
content-blocking-all-cross-site-cookies-private-windows = Межсайтовые куки в приватных окнах
content-blocking-cross-site-tracking-cookies-plus-isolate = Межсайтовые отслеживающие куки, а также изолировать оставшиеся куки
content-blocking-social-media-trackers = Трекеры соцсетей
content-blocking-all-cookies = Все куки
content-blocking-unvisited-cookies = Куки с непосещённых сайтов
content-blocking-all-windows-tracking-content = Отслеживающее содержимое во всех окнах
content-blocking-all-cross-site-cookies = Все межсайтовые куки
content-blocking-cryptominers = Криптомайнеры
content-blocking-fingerprinters = Сборщики цифровых отпечатков
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices. And
# the suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-known-and-suspected-fingerprinters = Известные и предполагаемые сборщики цифровых отпечатков

# The tcp-rollout strings are no longer used for the rollout but for tcp-by-default in the standard section

# "Contains" here means "isolates", "limits".
content-blocking-etp-standard-tcp-rollout-description = Полная защита от кук ограничивает работу кук сайтом, на котором вы находитесь, чтобы трекеры не могли использовать их для слежки за вами от сайта к сайту.
content-blocking-etp-standard-tcp-rollout-learn-more = Подробнее
content-blocking-etp-standard-tcp-title = Включает Полную защиту от кук, нашу самую мощную функцию защиты приватности.
content-blocking-warning-title = Осторожно!
content-blocking-and-isolating-etp-warning-description-2 = Эта настройка может вызвать ошибки отображения содержимого или нарушение правильной работы некоторых сайтов. Если кажется, что сайт не работает, вам, возможно, понадобится отключить защиту от отслеживания на этом сайте, чтобы загрузить всё его содержимое.
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
    .tooltiptext = Дополнительные сведения
# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Криптомайнеры
    .accesskey = п
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Сборщики цифровых отпечатков
    .accesskey = о
# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
#
# The known fingerprinters are those that are known for collecting browser fingerprints from user devices.
content-blocking-known-fingerprinters-label =
    .label = Известные цифровые отпечатки
    .accesskey = в
# The suspected fingerprinters are those that we are uncertain about browser fingerprinting activities. But they could
# possibly acquire browser fingerprints because of the behavior on accessing APIs that expose browser fingerprints.
content-blocking-suspected-fingerprinters-label =
    .label = Подозреваемые цифровые отпечатки
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
# Short form for "the act of choosing sound output devices and redirecting audio to the chosen devices".
permissions-speaker = Выбор динамика
permissions-speaker-settings =
    .label = Параметры…
    .accesskey = м
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
# "popup" is a misspelling that is more popular than the correct spelling of
# "pop-up" so it's included as a search keyword, not displayed in the UI.
permissions-block-popups-exceptions-button =
    .label = Исключения…
    .accesskey = ю
    .searchkeywords = popup
permissions-addon-install-warning =
    .label = Предупреждать при попытке сайтов установить дополнения
    .accesskey = е
permissions-addon-exceptions =
    .label = Исключения…
    .accesskey = с

## Privacy Section - Data Collection

collection-header = Сбор и использование данных { -brand-short-name }
collection-header2 = Сбор и использование данных { -brand-short-name }
    .searchkeywords = телеметрия
collection-description = Мы стремимся предоставить вам выбор и собирать только то, что нам нужно, для выпуска и улучшения { -brand-short-name } для всех и каждого. Мы всегда спрашиваем разрешения перед получением личных сведений.
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
collection-backlogged-crash-reports-with-link = Разрешить { -brand-short-name } отправлять от вашего имени накопившиеся сообщения о его падениях <a data-l10n-name="crash-reports-link">Подробнее</a>
    .accesskey = ш
privacy-segmentation-section-header = Новые возможности, улучшающие ваш просмотр сети
privacy-segmentation-section-description = Когда мы предлагаем возможности, которые используют ваши данные, чтобы улучшить персонализацию браузера:
privacy-segmentation-radio-off =
    .label = Использовать советы { -brand-product-name }
privacy-segmentation-radio-on =
    .label = Показать подробные сведения

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Защита
security-browsing-protection = Поддельное содержимое и защита от вредоносных приложений
security-enable-safe-browsing =
    .label = Блокировать опасное и обманывающее содержимое
    .accesskey = л
security-enable-safe-browsing-link = Подробнее
security-block-downloads =
    .label = Блокировать опасные загрузки
    .accesskey = к
security-block-uncommon-software =
    .label = Предупреждать о нежелательных и редко загружаемых приложениях
    .accesskey = ж

## Privacy Section - Certificates

certs-header = Сертификаты
certs-enable-ocsp =
    .label = Запрашивать у OCSP-серверов подтверждение текущего статуса сертификатов
    .accesskey = п
certs-view =
    .label = Просмотр сертификатов…
    .accesskey = м
certs-devices =
    .label = Устройства защиты…
    .accesskey = т
space-alert-over-5gb-settings-button =
    .label = Открыть Настройки
    .accesskey = к
space-alert-over-5gb-message2 = <strong>У { -brand-short-name } заканчивается место на диске.</strong> Содержимое сайтов может отображаться неправильно. Вы можете удалить сохранённые данные через Настройки > Приватность и Защита > Куки и данные сайтов.
space-alert-under-5gb-message2 = <strong>У { -brand-short-name } заканчивается место на диске.</strong> Содержимое сайтов может отображаться неправильно. Щёлкните «Подробнее», чтобы уменьшить использование вашего диска для улучшения работы в Интернете.

## Privacy Section - HTTPS-Only

httpsonly-header = Режим «Только HTTPS»
httpsonly-description = HTTPS обеспечивает безопасное и зашифрованное соединение между { -brand-short-name } и сайтами, которые вы посещаете. Большинство сайтов поддерживают HTTPS, и если включён режим «Только HTTPS», то { -brand-short-name } переключит все соединения на HTTPS.
httpsonly-learn-more = Подробнее
httpsonly-radio-enabled =
    .label = Включить режим «Только HTTPS» во всех окнах
httpsonly-radio-enabled-pbm =
    .label = Включить режим «Только HTTPS» только в приватных окнах
httpsonly-radio-disabled =
    .label = Не включать режим «Только HTTPS»

## DoH Section

preferences-doh-header = DNS через HTTPS
preferences-doh-description = Система доменных имён (DNS) через HTTPS отправляет ваш запрос доменного имени через зашифрованное соединение, создавая безопасный DNS и затрудняя другим возможность увидеть, к какому сайту вы собираетесь получить доступ.
# Variables:
#   $status (string) - The status of the DoH connection
preferences-doh-status = Состояние: { $status }
# Variables:
#   $name (string) - The name of the DNS over HTTPS resolver. If a custom resolver is used, the name will be the domain of the URL.
preferences-doh-resolver = Поставщик: { $name }
# This is displayed instead of $name in preferences-doh-resolver
# when the DoH URL is not a valid URL
preferences-doh-bad-url = Некорректный URL
preferences-doh-steering-status = Использование местного поставщика
preferences-doh-status-active = Активно
preferences-doh-status-disabled = Отключено
# Variables:
#   $reason (string) - A string representation of the reason DoH is not active. For example NS_ERROR_UNKNOWN_HOST or TRR_RCODE_FAIL.
preferences-doh-status-not-active = Неактивно ({ $reason })
preferences-doh-group-message = Включить безопасный DNS, используя:
preferences-doh-expand-section =
    .tooltiptext = Подробная информация
preferences-doh-setting-default =
    .label = Защиту по умолчанию
    .accesskey = м
preferences-doh-default-desc = { -brand-short-name } решает, когда использовать безопасный DNS для защиты вашей конфиденциальности.
preferences-doh-default-detailed-desc-1 = Использовать безопасный DNS в регионах, где он доступен
preferences-doh-default-detailed-desc-2 = Использовать разрешение DNS по умолчанию, если имеется проблема с поставщиком безопасного DNS.
preferences-doh-default-detailed-desc-3 = Использовать местного поставщика, если это возможно
preferences-doh-default-detailed-desc-4 = Отключить, когда активны VPN, родительский контроль или корпоративные политики.
preferences-doh-default-detailed-desc-5 = Отключить, когда сеть сообщает { -brand-short-name }, что она не должна использовать безопасный DNS.
preferences-doh-setting-enabled =
    .label = Повышенную защиту
    .accesskey = ы
preferences-doh-enabled-desc = Вы сами решаете, когда использовать безопасный DNS, и выбираете своего поставщика.
preferences-doh-enabled-detailed-desc-1 = Использовать выбранного вами поставщика
preferences-doh-enabled-detailed-desc-2 = Использовать разрешение DNS по умолчанию только в том случае, если есть проблема с безопасным DNS
preferences-doh-setting-strict =
    .label = Максимальную защиту
    .accesskey = к
preferences-doh-strict-desc = { -brand-short-name } всегда будет использовать безопасный DNS. Вы увидите предупреждение об угрозе безопасности, прежде чем мы будем использовать DNS вашей системы.
preferences-doh-strict-detailed-desc-1 = Использовать только выбранного вами поставщика
preferences-doh-strict-detailed-desc-2 = Всегда предупреждать, если безопасный DNS недоступен
preferences-doh-strict-detailed-desc-3 = Если безопасный DNS недоступен, сайты не будут загружаться или работать должным образом.
preferences-doh-setting-off =
    .label = Отключить
    .accesskey = ю
preferences-doh-off-desc = Использовать разрешение DNS по умолчанию
preferences-doh-checkbox-warn =
    .label = Предупреждать, если третья сторона активно препятствует безопасному DNS
    .accesskey = ж
preferences-doh-select-resolver = Выбрать поставщика:
preferences-doh-exceptions-description = { -brand-short-name } не будет использовать безопасный DNS на этих сайтах
preferences-doh-manage-exceptions =
    .label = Управление исключениями…
    .accesskey = ю

## The following strings are used in the Download section of settings

desktop-folder-name = Рабочий стол
downloads-folder-name = Загрузки
choose-download-folder-title = Выберите папку для загрузок:
