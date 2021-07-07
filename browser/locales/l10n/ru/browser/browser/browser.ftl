# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Waterfox"
# private - "Waterfox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Приватный режим)
    .data-content-title-default = { $content-title } — { -brand-full-name }
    .data-content-title-private = { $content-title } — { -brand-full-name } (Приватный режим)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Waterfox"
# "private" - "Waterfox — (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Do not use the brand name in the last two attributes, as we do on non-macOS.
#
# Also note the other subtle difference here: we use a `-` to separate the
# brand name from `(Private Browsing)`, which does not happen on other OSes.
#
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window-mac =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } — (Приватный режим)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } — (Приватный режим)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

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
urlbar-translate-notification-anchor =
    .tooltiptext = Перевод этой страницы
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Управление доступом сайта к вашим окнам или экрану
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Открыть панель сообщения об автономном хранилище
urlbar-password-notification-anchor =
    .tooltiptext = Открыть панель запроса на сохранение пароля
urlbar-translated-notification-anchor =
    .tooltiptext = Управление переводом страницы
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
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Совет:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Печатайте меньше, находите больше: Ищите в { $engineName } прямо из адресной строки.
urlbar-search-tips-redirect-2 = Начните поиск в адресной строке, чтобы увидеть предложения из { $engineName } и истории посещений.
# Prompts users to use the Urlbar when they are typing in the domain of a
# search engine, e.g. google.com or amazon.com.
urlbar-tabtosearch-onboard = Выберите этот ярлык, чтобы быстрее найти то, что вам нужно.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Закладки
urlbar-search-mode-tabs = Вкладки
urlbar-search-mode-history = Журнал

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

page-action-manage-extension =
    .label = Управление расширением…
page-action-remove-extension =
    .label = Удалить расширение

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
    .tooltiptext = Изменить параметры поиска
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
identity-custom-root = Соединение удостоверено сертификатом, издатель которого не распознан Waterfox.
identity-passive-loaded = Части этой страницы (такие как изображения) не защищены.
identity-active-loaded = Вы отключили защиту на этой странице.
identity-weak-encryption = Эта страница использует слабое шифрование.
identity-insecure-login-forms = Учётные данные, вводимые на этой странице, могут быть скомпрометированы.
identity-https-only-connection-upgraded = (переключено на HTTPS)
identity-https-only-label = Режим «Только HTTPS»
identity-https-only-dropdown-on =
    .label = Включён
identity-https-only-dropdown-off =
    .label = Отключён
identity-https-only-dropdown-off-temporarily =
    .label = Временно отключён
identity-https-only-info-turn-on2 = Включите для этого сайта Режим «Только HTTPS», если хотите, чтобы { -brand-short-name } по возможности переключался на безопасное соединение.
identity-https-only-info-turn-off2 = Если страница кажется сломанной, вы можете отключить для этого сайта режим «Только HTTPS», чтобы перезагрузить его с использованием незащищённого HTTP.
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
identity-description-custom-root = Waterfox не может распознать этого издателя сертификатов. Возможно, он был добавлен из вашей операционной системы или администратором. <label data-l10n-name="link">Подробнее</label>
identity-remove-cert-exception =
    .label = Удалить исключение
    .accesskey = л
identity-description-insecure = Ваше соединение с этим сайтом не защищено. Вводимая вами информация (например, пароли, сообщения, номера банковских карт и т.д.) может быть видна посторонним.
identity-description-insecure-login-forms = Учётные данные, вводимые вами на этой странице, не защищены и могут быть скомпрометированы.
identity-description-weak-cipher-intro = Ваше соединение с этим веб-сайтом использует слабое шифрование и не защищено.
identity-description-weak-cipher-risk = Посторонние лица могут просматривать вашу информацию или изменять поведение веб-сайта.
identity-description-active-blocked = { -brand-short-name } заблокировал незащищённые части этой страницы. <label data-l10n-name="link">Подробнее</label>
identity-description-passive-loaded = Ваше соединение не является защищённым и информация, вводимая вами на этом сайте, может быть видна посторонним.
identity-description-passive-loaded-insecure = Этот веб-сайт содержит незащищённое содержимое (такое как изображения). <label data-l10n-name="link">Подробнее</label>
identity-description-passive-loaded-mixed = Хотя { -brand-short-name } заблокировал некоторое содержимое, на этой странице всё ещё имеется незащищённое содержимое (такое как изображения). <label data-l10n-name="link">Подробнее</label>
identity-description-active-loaded = Этот веб-сайт содержит незащищённое содержимое (такое как сценарии) и ваше соединение с ним является незащищённым.
identity-description-active-loaded-insecure = Информация, вводимая вами на этом сайте (например, пароли, сообщения, номера банковских карт и т.д.), может быть видна посторонним.
identity-learn-more =
    .value = Подробнее
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
        [1] УБРАТЬ ЗВУК ВО ВКЛАДКЕ
        [one] УБРАТЬ ЗВУК В { $count } ВКЛАДКЕ
        [few] УБРАТЬ ЗВУК В { $count } ВКЛАДКАХ
       *[many] УБРАТЬ ЗВУК В { $count } ВКЛАДКАХ
    }
browser-tab-unmute =
    { $count ->
        [1] ВОССТАНОВИТЬ ЗВУК ВО ВКЛАДКЕ
        [one] ВОССТАНОВИТЬ ЗВУК В { $count } ВКЛАДКЕ
        [few] ВОССТАНОВИТЬ ЗВУК В { $count } ВКЛАДКАХ
       *[many] ВОССТАНОВИТЬ ЗВУК В { $count } ВКЛАДКАХ
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
popup-all-windows-shared = Будет предоставлен доступ ко всем видимым окнам на вашем экране.
popup-screen-sharing-block =
    .label = Блокировать
    .accesskey = л
popup-screen-sharing-always-block =
    .label = Всегда блокировать
    .accesskey = е
popup-mute-notifications-checkbox = Отключить уведомления веб-сайтов при предоставлении доступа

## WebRTC window or screen share tab switch warning

sharing-warning-window = Вы предоставляете доступ к { -brand-short-name }. Если вы перейдете на новую вкладку, это могут увидеть другие.
sharing-warning-screen = Вы предоставляете доступ ко всему своему экрану. Если вы перейдете на новую вкладку, это могут увидеть другие.
sharing-warning-proceed-to-tab =
    .label = Перейти на вкладку
sharing-warning-disable-for-session =
    .label = Отключить защиту от общего доступа на эту сессию

## DevTools F12 popup

enable-devtools-popup-description = Чтобы использовать клавишу F12, сначала откройте Инструменты разработчика через меню Веб-разработка.

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
urlbar-result-action-copy-to-clipboard = Копировать
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

## Labels shown above groups of urlbar results

# A label shown above the "Waterfox Suggest" (bookmarks/history) group in the
# urlbar results.
urlbar-group-firefox-suggest =
    .label = { -firefox-suggest-brand-name }
# A label shown above the search suggestions group in the urlbar results. It
# should use title case.
# Variables
#  $engine (String): the name of the search engine providing the suggestions
urlbar-group-search-suggestions =
    .label = Предложения от { $engine }

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

## Subframe crash notification

crashed-subframe-message = <strong>Часть этой страницы потерпела сбой.</strong> Чтобы сообщить { -brand-product-name } об этой проблеме и ускорить её исправление, отправьте отчёт.
# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = Часть этой страницы потерпела сбой. Чтобы сообщить { -brand-product-name } об этой проблеме и ускорить её исправление, отправьте отчёт.
crashed-subframe-learnmore-link =
    .value = Узнать больше
crashed-subframe-submit =
    .label = Отправить сообщение
    .accesskey = п

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
bookmarks-search =
    .label = Поиск закладок
bookmarks-tools =
    .label = Инструменты закладок
bookmarks-bookmark-edit-panel =
    .label = Редактировать эту закладку
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
bookmarks-current-tab =
    .label = Добавить текущую вкладку в закладки

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
#  $shortcut (String): keyboard shortcut to open the add-ons manager
toolbar-addons-themes-button =
    .label = Дополнения и темы
    .tooltiptext = Управляйте своими дополнениями и темами ({ $shortcut })
# Variables:
#  $shortcut (String): keyboard shortcut to open settings (only on macOS)
toolbar-settings-button =
    .label = Настройки
    .tooltiptext =
        { PLATFORM() ->
            [macos] Открыть настройки ({ $shortcut })
           *[other] Открыть настройки
        }

## More items

more-menu-go-offline =
    .label = Работать автономно
    .accesskey = б
toolbar-overflow-customize-button =
    .label = Настроить панель инструментов…
    .accesskey = а
toolbar-button-email-link =
    .label = Отправить ссылку
    .tooltiptext = Отправить по почте ссылку на эту страницу
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

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Удалить { $name }?
addon-removal-abuse-report-checkbox = Пожаловаться на это расширение в { -vendor-short-name }

## Remote / Synced tabs

remote-tabs-manage-account =
    .label = Управление аккаунтом
remote-tabs-sync-now = Синхронизировать

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
    .accesskey = Р
popups-infobar-block =
    .label = Заблокировать всплывающие окна для { $uriHost }
    .accesskey = Р

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
navbar-print-tab-modal-disabled =
    .label = Печать
    .tooltiptext = Распечатать эту страницу
navbar-home =
    .label = Домой
    .tooltiptext = Домашняя страница { -brand-short-name }
navbar-library =
    .label = Библиотека
    .tooltiptext = Просмотр истории, сохранённых закладок и многого другого
navbar-search =
    .title = Поиск
navbar-accessibility-indicator =
    .tooltiptext = Поддержка доступности включена
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
