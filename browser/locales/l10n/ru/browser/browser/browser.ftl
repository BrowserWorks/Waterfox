# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## The main browser window's title

# These are the default window titles everywhere except macOS. The first two
# attributes are used when the web content opened has no title:
#
# default - "Mozilla Firefox"
# private - "Mozilla Firefox (Private Browsing)"
#
# The last two are for use when there *is* a content title.
# Variables:
#  $content-title (String): the title of the web content.
browser-main-window =
    .data-title-default = { -brand-full-name }
    .data-title-private = { -brand-full-name } (Приватный просмотр)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Приватный просмотр)
# These are the default window titles on macOS. The first two are for use when
# there is no content title:
#
# "default" - "Mozilla Firefox"
# "private" - "Mozilla Firefox - (Private Browsing)"
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
    .data-title-private = { -brand-full-name } - (Приватный просмотр)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Приватный просмотр)
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

page-action-add-to-urlbar =
    .label = Добавить на панель адреса
page-action-manage-extension =
    .label = Управление расширением…
page-action-remove-from-urlbar =
    .label = Удалить с панели адреса
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

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = В этот раз искать с помощью:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Изменить настройки поиска
search-one-offs-change-settings-compact-button =
    .tooltiptext = Изменить параметры поиска
search-one-offs-context-open-new-tab =
    .label = Искать в новой вкладке
    .accesskey = а
search-one-offs-context-set-as-default =
    .label = Установить как поисковую систему по умолчанию
    .accesskey = о
search-one-offs-context-set-as-default-private =
    .label = Использовать данную поисковую систему по умолчанию в Приватных окнах
    .accesskey = З
# Search engine one-off buttons with an @alias shortcut/keyword.
# Variables:
#  $engineName (String): The name of the engine.
#  $alias (String): The @alias shortcut/keyword.
search-one-offs-engine-with-alias =
    .tooltiptext = { $engineName } ({ $alias })

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).

search-one-offs-bookmarks =
    .tooltiptext = Закладки ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Вкладки ({ $restrict })
search-one-offs-history =
    .tooltiptext = Журнал ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Показывать редактор при сохранении
    .accesskey = ы
bookmark-panel-done-button =
    .label = Готово
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Незащищённое соединение
identity-connection-secure = Защищённое соединение
identity-connection-internal = Это встроенная страница { -brand-short-name }.
identity-connection-file = Эта страница хранится на вашем компьютере.
identity-extension-page = Эта страница загружена из расширения.
identity-active-blocked = { -brand-short-name } заблокировал незащищённые части этой страницы.
identity-custom-root = Соединение удостоверено сертификатом, издатель которого не распознан Mozilla.
identity-passive-loaded = Части этой страницы (такие как изображения) не защищены.
identity-active-loaded = Вы отключили защиту на этой странице.
identity-weak-encryption = Эта страница использует слабое шифрование.
identity-insecure-login-forms = Учётные данные, вводимые на этой странице, могут быть скомпрометированы.
identity-permissions =
    .value = Разрешения
identity-permissions-reload-hint = Чтобы изменения возымели действие, вам, возможно, потребуется перезагрузить страницу.
identity-permissions-empty = Вы не давали этому сайту каких-либо специальных разрешений.
identity-clear-site-data =
    .label = Удалить куки и данные сайта…
identity-connection-not-secure-security-view = Вы подключились к этому сайту по незащищённому соединению.
identity-connection-verified = Вы подключились к этому сайту по защищённому соединению.
identity-ev-owner-label = Сертификат выдан:
identity-description-custom-root = Mozilla не может распознать этого издателя сертификатов. Возможно, он был добавлен из вашей операционной системы или администратором. <label data-l10n-name="link">Подробнее</label>
identity-remove-cert-exception =
    .label = Удалить исключение
    .accesskey = л
identity-description-insecure = Ваше соединение с этим сайтом не защищено. Вводимая вами информация может быть видна посторонним (например, пароли, сообщения, номера кредитных карт и т.д.).
identity-description-insecure-login-forms = Учётные данные, вводимые вами на этой странице, не защищены и могут быть скомпрометированы.
identity-description-weak-cipher-intro = Ваше соединение с этим веб-сайтом использует слабое шифрование и не защищено.
identity-description-weak-cipher-risk = Посторонние лица могут просматривать вашу информацию или изменять поведение веб-сайта.
identity-description-active-blocked = { -brand-short-name } заблокировал незащищённые части этой страницы. <label data-l10n-name="link">Подробнее</label>
identity-description-passive-loaded = Ваше соединение не является защищённым и информация, вводимая вами на этом сайте, может быть видна посторонним.
identity-description-passive-loaded-insecure = Этот веб-сайт содержит незащищённое содержимое (такое как изображения). <label data-l10n-name="link">Подробнее</label>
identity-description-passive-loaded-mixed = Хотя { -brand-short-name } заблокировал некоторое содержимое, на этой странице всё ещё имеется незащищённое содержимое (такое как изображения). <label data-l10n-name="link">Подробнее</label>
identity-description-active-loaded = Этот веб-сайт содержит незащищённое содержимое (такое как сценарии) и ваше соединение с ним является незащищённым.
identity-description-active-loaded-insecure = Информация, вводимая вами на этом сайте, может быть видна посторонним (например, пароли, сообщения, номера кредитных карт и т.д.).
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

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Доступ к камере:
    .accesskey = к
popup-select-microphone =
    .value = Доступ к микрофону:
    .accesskey = м
popup-all-windows-shared = Будет предоставлен доступ ко всем видимым окнам на вашем экране.
popup-screen-sharing-not-now =
    .label = Не сейчас
    .accesskey = е
popup-screen-sharing-never =
    .label = Никогда не разрешать
    .accesskey = и
popup-silence-notifications-checkbox = Отключить уведомления от { -brand-short-name } если к нему предоставлен доступ
popup-silence-notifications-checkbox-warning = { -brand-short-name } не будет отображать уведомления, пока к нему предоставлен доступ.

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

urlbar-default-placeholder =
    .defaultPlaceholder = Введите поисковый запрос или адрес
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
urlbar-remote-control-notification-anchor =
    .tooltiptext = Браузер находится под удалённым управлением
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
urlbar-pocket-button =
    .tooltiptext = Сохранить в { -pocket-brand-name }

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
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> контролирует ваш указатель мыши. Нажмите Esc, чтобы вернуть себе контроль.
pointerlock-warning-no-domain = Этот документ контролирует ваш указатель мыши. Нажмите Esc, чтобы вернуть себе контроль.
