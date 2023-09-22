# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = Приватный просмотр { -brand-full-name }
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — Приватный просмотр { -brand-full-name }
# These are the default window titles on macOS.
# .data-title-default and .data-title-private are used when the web content
# opened has no title:
#
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# .data-content-title-default and .data-content-title-private are for use when
# there *is* a content title.
# Do not use the brand name in these, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac-window-titles =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } — Приватный просмотр
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } — Приватный просмотр
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }
# The non-variable portion of this MUST match the translation of
# "PRIVATE_BROWSING_SHORTCUT_TITLE" in custom.properties
private-browsing-shortcut-text-2 = Приватный просмотр { -brand-shortcut-name }

##

urlbar-identity-button =
    .aria-label = Просмотреть информацию о сайте

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Открыть панель сообщения об установке
urlbar-web-notification-anchor =
    .tooltiptext = Изменение того, можете ли вы получать уведомления с сайта
urlbar-midi-notification-anchor =
    .tooltiptext = Открыть MIDI-панель
urlbar-eme-notification-anchor =
    .tooltiptext = Управление запуском программы DRM
urlbar-web-authn-anchor =
    .tooltiptext = Открыть панель веб-авторизации
urlbar-canvas-notification-anchor =
    .tooltiptext = Управление доступом к информации в canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Управление доступом сайта к вашему микрофону
urlbar-default-notification-anchor =
    .tooltiptext = Открыть панель сообщений
urlbar-geolocation-notification-anchor =
    .tooltiptext = Открыть панель запроса местоположения
urlbar-xr-notification-anchor =
    .tooltiptext = Открыть панель разрешений виртуальной реальности
urlbar-storage-access-anchor =
    .tooltiptext = Открыть панель разрешений при веб-сёрфинге
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Управление доступом сайта к вашим окнам или экрану
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Открыть панель сообщения об автономном хранилище
urlbar-password-notification-anchor =
    .tooltiptext = Открыть панель запроса на сохранение пароля
urlbar-plugins-notification-anchor =
    .tooltiptext = Управление запуском плагина
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Управление доступом сайта к вашей камере и/или микрофону
# "Speakers" is used in a general sense that might include headphones or
# another audio output connection.
urlbar-web-rtc-share-speaker-notification-anchor =
    .tooltiptext = Управление доступом сайта к другим динамикам
urlbar-autoplay-notification-anchor =
    .tooltiptext = Открыть панель автовоспроизведения
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Хранить данные в постоянном хранилище
urlbar-addons-notification-anchor =
    .tooltiptext = Открыть панель сообщения об установке дополнения
urlbar-tip-help-icon =
    .title = Получить помощь
urlbar-search-tips-confirm = Хорошо, понятно
urlbar-search-tips-confirm-short = Понятно
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Совет:
urlbar-result-menu-button =
    .title = Открыть меню
urlbar-result-menu-button-feedback = Обратная связь
    .title = Открыть меню
urlbar-result-menu-learn-more =
    .label = Узнать больше
    .accesskey = б
urlbar-result-menu-remove-from-history =
    .label = Удалить из истории
    .accesskey = и
urlbar-result-menu-tip-get-help =
    .label = Получить помощь
    .accesskey = м

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Печатайте меньше, находите больше: Ищите в { $engineName } прямо из адресной строки.
urlbar-search-tips-redirect-2 = Начните поиск в адресной строке, чтобы увидеть предложения из { $engineName } и истории посещений.
# Make sure to match the name of the Search panel in settings.
urlbar-search-tips-persist = Поиск стал проще: теперь вы можете уточнять поисковый запрос в адресной строке. Чтобы вместо этого отобразить адрес сайта, перейдите в раздел «Поиск» в настройках.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Выберите этот ярлык, чтобы быстрее найти то, что вам нужно.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Закладки
urlbar-search-mode-tabs = Вкладки
urlbar-search-mode-history = Журнал
urlbar-search-mode-actions = Действия

##

urlbar-geolocation-blocked =
    .tooltiptext = Вы заблокировали доступ этого веб-сайта к информации о местоположении.
urlbar-xr-blocked =
    .tooltiptext = Вы заблокировали доступ этого веб-сайта к устройству виртуальной реальности.
urlbar-web-notifications-blocked =
    .tooltiptext = Вы заблокировали уведомления с этого веб-сайта.
urlbar-camera-blocked =
    .tooltiptext = Вы заблокировали доступ этого веб-сайта к вашей камере.
urlbar-microphone-blocked =
    .tooltiptext = Вы заблокировали доступ этого веб-сайта к вашему микрофону.
urlbar-screen-blocked =
    .tooltiptext = Вы заблокировали доступ этого веб-сайта к вашему экрану.
urlbar-persistent-storage-blocked =
    .tooltiptext = Вы заблокировали доступ этого веб-сайта к постоянному хранилищу.
urlbar-popup-blocked =
    .tooltiptext = Вы заблокировали всплывающие окна с этого веб-сайта.
urlbar-autoplay-media-blocked =
    .tooltiptext = Вы заблокировали автовоспроизведение медиа со звуком с этого веб-сайта.
urlbar-canvas-blocked =
    .tooltiptext = Вы заблокировали извлечение данных canvas с этого веб-сайта.
urlbar-midi-blocked =
    .tooltiptext = Вы заблокировали доступ этого веб-сайта к MIDI.
urlbar-install-blocked =
    .tooltiptext = Вы заблокировали установку дополнений с этого веб-сайта.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Редактировать эту закладку ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Добавить страницу в закладки ({ $shortcut })

## Page Action Context Menu

page-action-manage-extension2 =
    .label = Управление расширением…
    .accesskey = ш
page-action-remove-extension2 =
    .label = Удалить расширение
    .accesskey = л

## Auto-hide Context Menu

full-screen-autohide =
    .label = Скрыть панели инструментов
    .accesskey = к
full-screen-exit =
    .label = Выйти из полноэкранного режима
    .accesskey = ы

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of search shortcuts in
# the Urlbar and searchbar.
search-one-offs-with-title = В этот раз искать в:
search-one-offs-change-settings-compact-button =
    .tooltiptext = Изменить настройки поиска
search-one-offs-context-open-new-tab =
    .label = Искать в новой вкладке
    .accesskey = а
search-one-offs-context-set-as-default =
    .label = Установить как поисковую систему по умолчанию
    .accesskey = о
search-one-offs-context-set-as-default-private =
    .label = Использовать как поисковую систему по умолчанию в приватных окнах
    .accesskey = З
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })
# Shown when adding new engines from the address bar shortcut buttons or context
# menu, or from the search bar shortcut buttons.
# Variables:
#  $engineName (String): The name of the engine.
search-one-offs-add-engine =
    .label = Добавить «{ $engineName }»
    .tooltiptext = Добавить поисковую систему «{ $engineName }»
    .aria-label = Добавить поисковую систему «{ $engineName }»
# When more than 5 engines are offered by a web page, they are grouped in a
# submenu using this as its label.
search-one-offs-add-engine-menu =
    .label = Добавить поисковую систему

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Закладках ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Вкладках ({ $restrict })
search-one-offs-history =
    .tooltiptext = Журнале ({ $restrict })
search-one-offs-actions =
    .tooltiptext = Действия ({ $restrict })

## QuickActions are shown in the urlbar as the user types a matching string
## The -cmd- strings are comma separated list of keywords that will match
## the action.

# Opens the about:addons page in the home / recommendations section
quickactions-addons = Просмотр дополнений
quickactions-cmd-addons2 = дополнения
# Opens the bookmarks library window
quickactions-bookmarks2 = Управление закладками
quickactions-cmd-bookmarks = закладки
# Opens a SUMO article explaining how to clear history
quickactions-clearhistory = Удаление истории
quickactions-cmd-clearhistory = удалить историю
# Opens about:downloads page
quickactions-downloads2 = Просмотреть загрузки
quickactions-cmd-downloads = загрузки
# Opens about:addons page in the extensions section
quickactions-extensions = Управление расширениями
quickactions-cmd-extensions = расширения
# Opens the devtools web inspector
quickactions-inspector2 = Открыть Инструменты разработчика
quickactions-cmd-inspector = инспектор, инструменты разработки
# Opens about:logins
quickactions-logins2 = Управление паролями
quickactions-cmd-logins = логины, пароли
# Opens about:addons page in the plugins section
quickactions-plugins = Управление плагинами
quickactions-cmd-plugins = плагины
# Opens the print dialog
quickactions-print2 = Распечатать страницу
quickactions-cmd-print = печать
# Opens a new private browsing window
quickactions-private2 = Открыть приватное окно
quickactions-cmd-private = приватный просмотр
# Opens a SUMO article explaining how to refresh
quickactions-refresh = Очистить { -brand-short-name }
quickactions-cmd-refresh = обновить
# Restarts the browser
quickactions-restart = Перезапустить { -brand-short-name }
quickactions-cmd-restart = перезапустить
# Opens the screenshot tool
quickactions-screenshot3 = Сделать снимок экрана
quickactions-cmd-screenshot = скриншот
# Opens about:preferences
quickactions-settings2 = Управление настройками
quickactions-cmd-settings = настройки, параметры, опции
# Opens about:addons page in the themes section
quickactions-themes = Управление темами
quickactions-cmd-themes = темы
# Opens a SUMO article explaining how to update the browser
quickactions-update = Обновить { -brand-short-name }
quickactions-cmd-update = обновление
# Opens the view-source UI with current pages source
quickactions-viewsource2 = Исходный код страницы
quickactions-cmd-viewsource = просмотр исходного текста, кода
# Tooltip text for the help button shown in the result.
quickactions-learn-more =
    .title = Узнать больше о Быстрых действиях

## Bookmark Panel

bookmarks-add-bookmark = Добавить закладку
bookmarks-edit-bookmark = Изменить закладку
bookmark-panel-cancel =
    .label = Отмена
    .accesskey = м
# Variables:
#  $count (number): number of bookmarks that will be removed
bookmark-panel-remove =
    .label =
        { $count ->
            [one] Удалить { $count } закладку
            [few] Удалить { $count } закладки
           *[many] Удалить { $count } закладок
        }
    .accesskey = а
bookmark-panel-show-editor-checkbox =
    .label = Показывать редактор при сохранении
    .accesskey = ы
bookmark-panel-save-button =
    .label = Сохранить
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-site-information = Информация о сайте { $host }
# Variables
#  $host (String): the hostname of the site that is being displayed.
identity-header-security-with-host =
    .title = Защита соединения с { $host }
identity-connection-not-secure = Незащищённое соединение
identity-connection-secure = Защищённое соединение
identity-connection-failure = Ошибка соединения
identity-connection-internal = Это встроенная страница { -brand-short-name }.
identity-connection-file = Эта страница хранится на вашем компьютере.
identity-extension-page = Эта страница загружена из расширения.
identity-active-blocked = { -brand-short-name } заблокировал незащищённые части этой страницы.
identity-custom-root = Соединение удостоверено сертификатом, издатель которого не распознан BrowserWorks.
identity-passive-loaded = Части этой страницы (такие как изображения) не защищены.
identity-active-loaded = Вы отключили защиту на этой странице.
identity-weak-encryption = Эта страница использует слабое шифрование.
identity-insecure-login-forms = Учётные данные, вводимые на этой странице, могут быть скомпрометированы.
identity-https-only-connection-upgraded = (переключено на HTTPS)
identity-https-only-label = Режим «Только HTTPS»
identity-https-only-label2 = Автоматическое переключение этого сайта на безопасное соединение
identity-https-only-dropdown-on =
    .label = Включено
identity-https-only-dropdown-off =
    .label = Отключено
identity-https-only-dropdown-off-temporarily =
    .label = Временно отключено
identity-https-only-info-turn-on2 = Включите для этого сайта Режим «Только HTTPS», если хотите, чтобы { -brand-short-name } по возможности переключался на безопасное соединение.
identity-https-only-info-turn-off2 = Если страница кажется сломанной, вы можете отключить для этого сайта режим «Только HTTPS», чтобы перезагрузить его с использованием незащищённого HTTP.
identity-https-only-info-turn-on3 = Включите переключение на HTTPS для этого сайта, если хотите, чтобы { -brand-short-name } переключался на безопасное соединение, когда это возможно.
identity-https-only-info-turn-off3 = Если страница кажется неработающей, вы можете отключить переключение соединения на HTTPS для этого сайта, чтобы перезагрузить его с использованием небезопасного HTTP.
identity-https-only-info-no-upgrade = Невозможно переключить соединение с HTTP.
identity-permissions-storage-access-header = Межсайтовые куки
identity-permissions-storage-access-hint = Следующие стороны могут использовать межсайтовые куки и данные сайта, пока вы находитесь на этом сайте.
identity-permissions-storage-access-learn-more = Узнать больше
identity-permissions-reload-hint = Чтобы изменения возымели действие, вам, возможно, потребуется перезагрузить страницу.
identity-clear-site-data =
    .label = Удалить куки и данные сайта…
identity-connection-not-secure-security-view = Вы подключились к этому сайту по незащищённому соединению.
identity-connection-verified = Вы подключились к этому сайту по защищённому соединению.
identity-ev-owner-label = Сертификат выдан:
identity-description-custom-root2 = BrowserWorks не может распознать этого издателя сертификатов. Возможно, он был добавлен из вашей операционной системы или администратором.
identity-remove-cert-exception =
    .label = Удалить исключение
    .accesskey = л
identity-description-insecure = Ваше соединение с этим сайтом не защищено. Вводимая вами информация (например, пароли, сообщения, номера банковских карт и т.д.) может быть видна посторонним.
identity-description-insecure-login-forms = Учётные данные, вводимые вами на этой странице, не защищены и могут быть скомпрометированы.
identity-description-weak-cipher-intro = Ваше соединение с этим веб-сайтом использует слабое шифрование и не защищено.
identity-description-weak-cipher-risk = Посторонние лица могут просматривать вашу информацию или изменять поведение веб-сайта.
identity-description-active-blocked2 = { -brand-short-name } заблокировал незащищённые части этой страницы.
identity-description-passive-loaded = Ваше соединение не является защищённым и информация, вводимая вами на этом сайте, может быть видна посторонним.
identity-description-passive-loaded-insecure2 = Этот веб-сайт содержит незащищённое содержимое (такое как изображения).
identity-description-passive-loaded-mixed2 = Хотя { -brand-short-name } заблокировал некоторое содержимое, на этой странице всё ещё имеется незащищённое содержимое (такое как изображения).
identity-description-active-loaded = Этот веб-сайт содержит незащищённое содержимое (такое как сценарии) и ваше соединение с ним является незащищённым.
identity-description-active-loaded-insecure = Информация, вводимая вами на этом сайте (например, пароли, сообщения, номера банковских карт и т.д.), может быть видна посторонним.
identity-disable-mixed-content-blocking =
    .label = Пока отключить защиту
    .accesskey = а
identity-enable-mixed-content-blocking =
    .label = Включить защиту
    .accesskey = ю
identity-more-info-link-text =
    .label = Подробнее

## Window controls

browser-window-minimize-button =
    .tooltiptext = Свернуть
browser-window-maximize-button =
    .tooltiptext = Развернуть
browser-window-restore-down-button =
    .tooltiptext = Свернуть в окно
browser-window-close-button =
    .tooltiptext = Закрыть

## Tab actions

# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-playing2 = ВОСПРОИЗВОДИТСЯ
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-muted2 = БЕЗ ЗВУКА
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-blocked = АВТОЗАПУСК ЗАБЛОКИРОВАН
# This label should be written in all capital letters if your locale supports them.
browser-tab-audio-pip = КАРТИНКА В КАРТИНКЕ

## These labels should be written in all capital letters if your locale supports them.
## Variables:
##  $count (number): number of affected tabs

browser-tab-mute =
    { $count ->
        [one] ОТКЛЮЧИТЬ ЗВУК ВКЛАДКИ
        [few] ОТКЛЮЧИТЬ ЗВУК { $count } ВКЛАДОК
       *[many] ОТКЛЮЧИТЬ ЗВУК { $count } ВКЛАДОК
    }
browser-tab-unmute =
    { $count ->
        [one] ВКЛЮЧИТЬ ЗВУК ВКЛАДКИ
        [few] ВКЛЮЧИТЬ ЗВУК { $count } ВКЛАДОК
       *[many] ВКЛЮЧИТЬ ЗВУК { $count } ВКЛАДОК
    }
browser-tab-unblock =
    { $count ->
        [1] ВОСПРОИЗВЕСТИ ЗВУК ВО ВКЛАДКЕ
        [one] ВОСПРОИЗВЕСТИ ЗВУК В { $count } ВКЛАДКЕ
        [few] ВОСПРОИЗВЕСТИ ЗВУК В { $count } ВКЛАДКАХ
       *[many] ВОСПРОИЗВЕСТИ ЗВУК В { $count } ВКЛАДКАХ
    }

## Bookmarks toolbar items

browser-import-button2 =
    .label = Импорт закладок…
    .tooltiptext = Импортируйте закладки из другого браузера в { -brand-short-name }.
bookmarks-toolbar-empty-message = Для ускорения доступа разместите свои закладки на панели закладок. <a data-l10n-name="manage-bookmarks">Управление закладками…</a>

## WebRTC Pop-up notifications

popup-select-camera-device =
    .value = Камера:
    .accesskey = м
popup-select-camera-icon =
    .tooltiptext = Камера
popup-select-microphone-device =
    .value = Микрофон:
    .accesskey = ф
popup-select-microphone-icon =
    .tooltiptext = Микрофон
popup-select-speaker-icon =
    .tooltiptext = Динамики
popup-select-window-or-screen =
    .label = Окно или экран:
    .accesskey = Н
popup-all-windows-shared = Будет предоставлен доступ ко всем видимым окнам на вашем экране.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Вы предоставляете доступ к { -brand-short-name }. Если вы перейдете на новую вкладку, это могут увидеть другие.
sharing-warning-screen = Вы предоставляете доступ ко всему своему экрану. Если вы перейдете на новую вкладку, это могут увидеть другие.
sharing-warning-proceed-to-tab =
    .label = Перейти на вкладку
sharing-warning-disable-for-session =
    .label = Отключить защиту от общего доступа на эту сессию

## DevTools F12 popup

enable-devtools-popup-description2 = Чтобы использовать горячую клавишу F12, сначала откройте «Инструменты разработчика» в меню «Инструменты браузера».

## URL Bar

# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Введите поисковый запрос или адрес
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Искать в Интернете
    .aria-label = Поиск с помощью { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Введите поисковый запрос
    .aria-label = Поиск в { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Введите поисковый запрос
    .aria-label = Поиск в закладках
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Введите поисковый запрос
    .aria-label = Поиск в истории
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Введите поисковый запрос
    .aria-label = Поиск во вкладках
# This placeholder is used when searching quick actions.
urlbar-placeholder-search-mode-other-actions =
    .placeholder = Введите поисковый запрос
    .aria-label = Поисковые действия
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Найдите в { $name } или введите адрес
# Variables
#  $component (String): the name of the component which forces remote control.
#    Example: "DevTools", "Marionette", "RemoteAgent".
urlbar-remote-control-notification-anchor2 =
    .tooltiptext = Браузер находится под удалённым управлением (причина: { $component })
urlbar-permissions-granted =
    .tooltiptext = Вы предоставили этому веб-сайту дополнительные разрешения.
urlbar-switch-to-tab =
    .value = Перейти на вкладку:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Расширение:
urlbar-go-button =
    .tooltiptext = Перейти по введённому адресу
urlbar-page-action-button =
    .tooltiptext = Действия на странице

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".

# Used when the private browsing engine differs from the default engine.
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-in-private-w-engine = Искать с помощью { $engine } в приватном окне
# Used when the private browsing engine is the same as the default engine.
urlbar-result-action-search-in-private = Искать в приватном окне
# The "with" format was chosen because the search engine name can end with
# "Search", and we would like to avoid strings like "Search MSN Search".
# Variables
#  $engine (String): the name of a search engine
urlbar-result-action-search-w-engine = Поиск через { $engine }
urlbar-result-action-sponsored = Спонсировано
urlbar-result-action-switch-tab = Перейти на вкладку
urlbar-result-action-visit = Посетить
# Allows the user to visit a URL that was previously copied to the clipboard.
urlbar-result-action-visit-from-your-clipboard = Посетить из буфера обмена
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-before-tabtosearch-web = Нажмите Tab для поиска с помощью { $engine }
# Directs a user to press the Tab key to perform a search with the specified
# engine.
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-before-tabtosearch-other = Нажмите Tab для поиска в { $engine }
# Variables
#  $engine (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-result-action-tabtosearch-web = Ищите в { $engine } прямо в адресной строке
# Variables
#  $engine (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-result-action-tabtosearch-other-engine = Ищите на { $engine } прямо в адресной строке
# Action text for copying to clipboard.
urlbar-result-action-copy-to-clipboard = Скопировать
# Shows the result of a formula expression being calculated, the last = sign will be shown
# as part of the result (e.g. "= 2").
# Variables
#  $result (String): the string representation for a formula result
urlbar-result-action-calculator-result = = { $result }

## Action text shown in urlbar results, usually appended after the search
## string or the url, like "result value - action text".
## In these actions "Search" is a verb, followed by where the search is performed.

urlbar-result-action-search-bookmarks = Искать в закладках
urlbar-result-action-search-history = Искать в журнале
urlbar-result-action-search-tabs = Искать во вкладках
urlbar-result-action-search-actions = Искать в действиях

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use sentence case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Предложения от { $engine }
# A label shown above Quick Actions in the urlbar results.
urlbar-group-quickactions =
    .label = Быстрые действия

## Reader View toolbar buttons

# This should match menu-view-enter-readerview in menubar.ftl
reader-view-enter-button =
    .aria-label = Перейти в режим чтения
# This should match menu-view-close-readerview in menubar.ftl
reader-view-close-button =
    .aria-label = Закрыть режим чтения

## Picture-in-Picture urlbar button
## Variables:
##   $shortcut (String) - Keyboard shortcut to execute the command.

picture-in-picture-urlbar-button-open =
    .tooltiptext = Открыть «Картинку в картинке» ({ $shortcut })
picture-in-picture-urlbar-button-close =
    .tooltiptext = Закрыть «Картинку в картинке» ({ $shortcut })
picture-in-picture-panel-header = Картинка в картинке
picture-in-picture-panel-headline = Этот веб-сайт не рекомендует функцию «Картинка в картинке».
picture-in-picture-panel-body = Видео может отображаться не так, как задумано разработчиком, когда включена функция «Картинка в картинке».
picture-in-picture-enable-toggle =
    .label = Включить в любом случае

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> теперь находится в полноэкранном режиме
fullscreen-warning-no-domain = Этот документ теперь находится в полноэкранном режиме
fullscreen-exit-button = Выйти из полноэкранного режима (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Выйти из полноэкранного режима (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> контролирует ваш курсор. Нажмите Esc, чтобы вернуть себе контроль.
pointerlock-warning-no-domain = Этот документ контролирует ваш курсор. Нажмите Esc, чтобы вернуть себе контроль.

## Bookmarks panels, menus and toolbar

bookmarks-manage-bookmarks =
    .label = Управление закладками
bookmarks-recent-bookmarks-panel-subheader = Недавние закладки
bookmarks-toolbar-chevron =
    .tooltiptext = Показать больше закладок
bookmarks-sidebar-content =
    .aria-label = Закладки
bookmarks-menu-button =
    .label = Меню закладок
bookmarks-other-bookmarks-menu =
    .label = Другие закладки
bookmarks-mobile-bookmarks-menu =
    .label = Мобильные закладки

## Variables:
##   $isVisible (boolean): if the specific element (e.g. bookmarks sidebar,
##                         bookmarks toolbar, etc.) is visible or not.

bookmarks-tools-sidebar-visibility =
    .label =
        { $isVisible ->
            [true] Скрыть боковую панель закладок
           *[other] Показать боковую панель закладок
        }
bookmarks-tools-toolbar-visibility-menuitem =
    .label =
        { $isVisible ->
            [true] Скрыть панель закладок
           *[other] Показать панель закладок
        }
bookmarks-tools-toolbar-visibility-panel =
    .label =
        { $isVisible ->
            [true] Скрыть панель закладок
           *[other] Показать панель закладок
        }
bookmarks-tools-menu-button-visibility =
    .label =
        { $isVisible ->
            [true] Удалить меню закладок с панели
           *[other] Добавить меню закладок на панель
        }

##

bookmarks-search =
    .label = Поиск закладок
bookmarks-tools =
    .label = Инструменты закладок
bookmarks-subview-edit-bookmark =
    .label = Изменить эту закладку…
# The aria-label is a spoken label that should not include the word "toolbar" or
# such, because screen readers already know that this container is a toolbar.
# This avoids double-speaking.
bookmarks-toolbar =
    .toolbarname = Панель закладок
    .accesskey = з
    .aria-label = Закладки
bookmarks-toolbar-menu =
    .label = Панель закладок
bookmarks-toolbar-placeholder =
    .title = Элементы панели закладок
bookmarks-toolbar-placeholder-button =
    .label = Элементы панели закладок
# "Bookmark" is a verb, as in "Add current tab to bookmarks".
bookmarks-subview-bookmark-tab =
    .label = Добавить текущую вкладку в закладки…

## Library Panel items

library-bookmarks-menu =
    .label = Закладки
library-recent-activity-title =
    .value = Последние действия

## Pocket toolbar button

save-to-pocket-button =
    .label = Сохранить в { -pocket-brand-name }
    .tooltiptext = Сохранить в { -pocket-brand-name }

## Repair text encoding toolbar button

repair-text-encoding-button =
    .label = Исправить кодировку текста
    .tooltiptext = Угадать правильную кодировку текста по содержимому страницы

## Customize Toolbar Buttons

# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Настройки
    .tooltiptext =
        { PLATFORM() ->
            [macos] Открыть настройки ({ $shortcut })
           *[other] Открыть настройки
        }
toolbar-overflow-customize-button =
    .label = Настроить панель инструментов…
    .accesskey = а
toolbar-button-email-link =
    .label = Отправить ссылку
    .tooltiptext = Отправить по почте ссылку на эту страницу
toolbar-button-logins =
    .label = Пароли
    .tooltiptext = Просмотр и управление сохраненными паролями
# Variables:
#  $shortcut (String): keyboard shortcut to save a copy of the page
toolbar-button-save-page =
    .label = Сохранить страницу
    .tooltiptext = Сохранить эту страницу ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open a local file
toolbar-button-open-file =
    .label = Открыть файл
    .tooltiptext = Открыть файл ({ $shortcut })
toolbar-button-synced-tabs =
    .label = Облачные вкладки
    .tooltiptext = Показать вкладки с других устройств
# Variables
# $shortcut (string) - Keyboard shortcut to open a new private browsing window
toolbar-button-new-private-window =
    .label = Новое приватное окно
    .tooltiptext = Открыть новое приватное окно ({ $shortcut })

## EME notification panel

eme-notifications-drm-content-playing = Некоторое аудио или видео на этом сайте использует программу DRM, что может ограничить возможности, предоставляемые вам { -brand-short-name }.
eme-notifications-drm-content-playing-manage = Управление настройками
eme-notifications-drm-content-playing-manage-accesskey = в
eme-notifications-drm-content-playing-dismiss = Закрыть
eme-notifications-drm-content-playing-dismiss-accesskey = к

## Password save/update panel

panel-save-update-username = Имя пользователя
panel-save-update-password = Пароль

##

# "More" item in macOS share menu
menu-share-more =
    .label = Ещё…
ui-tour-info-panel-close =
    .tooltiptext = Закрыть

## Variables:
##  $uriHost (String): URI host for which the popup was allowed or blocked.

popups-infobar-allow =
    .label = Разрешить всплывающие окна для { $uriHost }
    .accesskey = в
popups-infobar-block =
    .label = Блокировать всплывающие окна для { $uriHost }
    .accesskey = в

##

popups-infobar-dont-show-message =
    .label = Не показывать это сообщение при блокировке всплывающих окон
    .accesskey = н
edit-popup-settings =
    .label = Управление настройками всплывающих окон…
    .accesskey = ы
picture-in-picture-hide-toggle =
    .label = Скрыть переключатель «Картинка в картинке»
    .accesskey = ы

## Since the default position for PiP controls does not change for RTL layout,
## right-to-left languages should use "Left" and "Right" as in the English strings,

picture-in-picture-move-toggle-right =
    .label = Переместить переключатель «Картинка в картинке» вправо
    .accesskey = п
picture-in-picture-move-toggle-left =
    .label = Переместить переключатель «Картинка в картинке» влево
    .accesskey = л

##


# Navigator Toolbox

# This string is a spoken label that should not include
# the word "toolbar" or such, because screen readers already know that
# this container is a toolbar. This avoids double-speaking.
navbar-accessible =
    .aria-label = Навигация
navbar-downloads =
    .label = Загрузки
navbar-overflow =
    .tooltiptext = Другие инструменты…
# Variables:
#   $shortcut (String): keyboard shortcut to print the page
navbar-print =
    .label = Печать
    .tooltiptext = Распечатать эту страницу… ({ $shortcut })
navbar-home =
    .label = Домой
    .tooltiptext = Домашняя страница { -brand-short-name }
navbar-library =
    .label = Библиотека
    .tooltiptext = Просмотр истории, сохранённых закладок и многого другого
navbar-search =
    .title = Поиск
# Name for the tabs toolbar as spoken by screen readers. The word
# "toolbar" is appended automatically and should not be included in
# in the string
tabs-toolbar =
    .aria-label = Вкладки браузера
tabs-toolbar-new-tab =
    .label = Новая вкладка
tabs-toolbar-list-all-tabs =
    .label = Список всех вкладок
    .tooltiptext = Список всех вкладок

## Infobar shown at startup to suggest session-restore

# <img data-l10n-name="icon"/> will be replaced by the application menu icon
restore-session-startup-suggestion-message = <strong>Открыть предыдущие вкладки?</strong> Вы можете восстановить предыдущий сеанс из меню { -brand-short-name } <img data-l10n-name="icon"/> в разделе История.
restore-session-startup-suggestion-button = Показать мне как

## BrowserWorks data reporting notification (Telemetry, Waterfox Health Report, etc)

data-reporting-notification-message = { -brand-short-name } автоматически отправляет некоторые данные в { -vendor-short-name }, чтобы мы могли улучшить ваш браузер.
data-reporting-notification-button =
    .label = Выбрать, чем мне поделиться
    .accesskey = В
# Label for the indicator shown in the private browsing window titlebar.
private-browsing-indicator-label = Приватный просмотр

## Unified extensions (toolbar) button

unified-extensions-button =
    .label = Расширения
    .tooltiptext = Расширения

## Unified extensions button when permission(s) are needed.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-permissions-needed =
    .label = Расширения
    .tooltiptext =
        Расширения
        Необходимы разрешения

## Unified extensions button when some extensions are quarantined.
## Note that the new line is intentionally part of the tooltip.

unified-extensions-button-quarantined =
    .label = Расширения
    .tooltiptext =
        Расширения
        Некоторые расширения не разрешены

## Autorefresh blocker

refresh-blocked-refresh-label = { -brand-short-name } заблокировал автоматическую перезагрузку этой страницы.
refresh-blocked-redirect-label = { -brand-short-name } заблокировал автоматическое перенаправление на другую страницу.
refresh-blocked-allow =
    .label = Разрешить
    .accesskey = Р

## Waterfox Relay integration

firefox-relay-offer-why-to-use-relay = Наши безопасные и простые в использовании псевдонимы защищают вашу личность и предотвращают спам, скрывая ваш адрес электронной почты.
# Variables:
#  $useremail (String): user email that will receive messages
firefox-relay-offer-what-relay-provides = Все электронные письма, отправленные на ваши псевдонимы электронной почты, будут перенаправлены на <strong>{ $useremail }</strong> (если вы не решите их заблокировать).
firefox-relay-offer-legal-notice = Нажимая «Использовать псевдоним электронной почты», вы соглашаетесь с <label data-l10n-name="tos-url">Условиями использования</label> и <label data-l10n-name="privacy-url">Примечанием о конфиденциальности</label>.

## Add-on Pop-up Notifications

popup-notification-addon-install-unsigned =
    .value = (Не проверено)
popup-notification-xpinstall-prompt-learn-more = Узнайте больше о безопасной установке дополнений

## Pop-up warning

# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-message =
    { $popupCount ->
        [one] { -brand-short-name } заблокировал { $popupCount } всплывающее окно с этого сайта.
        [few] { -brand-short-name } заблокировал { $popupCount } всплывающих окна с этого сайта.
       *[many] { -brand-short-name } заблокировал { $popupCount } всплывающих окон с этого сайта.
    }
# The singular form is left out for English, since the number of blocked pop-ups is always greater than 1.
# Variables:
#   $popupCount (Number): the number of pop-ups blocked.
popup-warning-exceeded-message =
    { $popupCount ->
        [one] { -brand-short-name } заблокировал более { $popupCount } всплывающего окна с этого сайта.
        [few] { -brand-short-name } заблокировал более { $popupCount } всплывающих окон с этого сайта.
       *[many] { -brand-short-name } заблокировал более { $popupCount } всплывающих окон с этого сайта.
    }
popup-warning-button =
    .label =
        { PLATFORM() ->
            [windows] Настройки
           *[other] Настройки
        }
    .accesskey =
        { PLATFORM() ->
            [windows] Н
           *[other] Н
        }
# Variables:
#   $popupURI (String): the URI for the pop-up window
popup-show-popup-menuitem =
    .label = Показать «{ $popupURI }»
