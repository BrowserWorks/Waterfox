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
    .data-title-private = { -brand-full-name } (Поверително разглеждане)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Поверително разглеждане)
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
    .data-title-private = { -brand-full-name } - (Поверително разглеждане)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Поверително разглеждане)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Показване на информация за уеб страницата

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Отваряне на панел със съобщението за инсталиране
urlbar-web-notification-anchor =
    .tooltiptext = Промяна на правата за получаване на известия от страницата
urlbar-midi-notification-anchor =
    .tooltiptext = Отваря панела за MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Управление използването на софтуер с DRM
urlbar-web-authn-anchor =
    .tooltiptext = Отваря панела за удостоверяване през Мрежата
urlbar-canvas-notification-anchor =
    .tooltiptext = Управление на правата извличане на изображения чрез canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Управление споделянето на вашия микрофон със сайта
urlbar-default-notification-anchor =
    .tooltiptext = Отваряне на панел със съобщението
urlbar-geolocation-notification-anchor =
    .tooltiptext = Отваряне на панел със заявката за местоположение
urlbar-xr-notification-anchor =
    .tooltiptext = Отваряне на панела за разрешения за виртуална реалност
urlbar-storage-access-anchor =
    .tooltiptext = Отваря панела за правата при разглеждане
urlbar-translate-notification-anchor =
    .tooltiptext = Превод на страницата
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Управление споделянето на вашите прозорци или екран със сайта
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Отваряне на панел със съобщението за работа без мрежа
urlbar-password-notification-anchor =
    .tooltiptext = Отваряне на панел със съобщението за запазване на парола
urlbar-translated-notification-anchor =
    .tooltiptext = Управление превеждането на страници
urlbar-plugins-notification-anchor =
    .tooltiptext = Управление на използването на приставки
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Управление споделянето на вашата камера и/или микрофон със сайта
urlbar-autoplay-notification-anchor =
    .tooltiptext = Отваряне на панел за автоматично възпроизвеждане
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Използване на хранилището за постоянни данни
urlbar-addons-notification-anchor =
    .tooltiptext = Отваряне на панел със съобщението за инсталиране на добавка
urlbar-tip-help-icon =
    .title = Получете помощ
urlbar-search-tips-confirm = Да, разбрах
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Съвет:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Въвеждайте малко, намирайте много: търсете с { $engineName } направо от адресната лента.
urlbar-search-tips-redirect-2 = Започнете търсене от адресната лента, за да видите предложения от { $engineName } и историята на разглеждане.

## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Забранили сте на страницата достъп до вашето местоположение.
urlbar-xr-blocked =
    .tooltiptext = Блокирахте достъпа до устройства за виртуална реалност за този уебсайт.
urlbar-web-notifications-blocked =
    .tooltiptext = Забранили сте на страницата да ви изпраща известия.
urlbar-camera-blocked =
    .tooltiptext = Забранили сте на страницата достъп до вашата камера.
urlbar-microphone-blocked =
    .tooltiptext = Забранили сте на страницата достъп до вашия микрофон.
urlbar-screen-blocked =
    .tooltiptext = Забранили сте на страницата споделянето на вашия екран.
urlbar-persistent-storage-blocked =
    .tooltiptext = Забранили сте на страницата достъп до хранилището за постоянни данни.
urlbar-popup-blocked =
    .tooltiptext = Забранили сте на страницата да отваря изскачащи прозорци.
urlbar-autoplay-media-blocked =
    .tooltiptext = Забранили сте автоматичното възпроизвеждане на медия на страницата.
urlbar-canvas-blocked =
    .tooltiptext = Забранили сте достъпа до данните от canvas на тази страница.
urlbar-midi-blocked =
    .tooltiptext = Забранили сте на страницата достъп до MIDI.
urlbar-install-blocked =
    .tooltiptext = Забранили сте на страницата да инсталира добавки.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Промяна на отметка ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Отмятане на страницата ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Добавяне към адресната лента
page-action-manage-extension =
    .label = Управление на добавката…
page-action-remove-from-urlbar =
    .label = Премахване от адресната лента
page-action-remove-extension =
    .label = Премахване на разширението

## Auto-hide Context Menu

full-screen-autohide =
    .label = Скриване на лентите
    .accesskey = л
full-screen-exit =
    .label = Излизане от цял екран
    .accesskey = ц

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Този път търсете с:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Настройки на търсене
search-one-offs-change-settings-compact-button =
    .tooltiptext = Настройки на търсене
search-one-offs-context-open-new-tab =
    .label = Търсене в нов раздел
    .accesskey = р
search-one-offs-context-set-as-default =
    .label = Задаване като стандартна търсачка
    .accesskey = с
search-one-offs-context-set-as-default-private =
    .label = Задаване като стандартна търсачка в поверителни прозорци
    .accesskey = п

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Показване на диалога при запазване
    .accesskey = п
bookmark-panel-done-button =
    .label = Готово
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 25em

## Identity Panel

identity-connection-not-secure = Връзката не е защитена
identity-connection-secure = Връзката е защитена
identity-connection-internal = Това е защитена страница на { -brand-short-name }.
identity-connection-file = Страницата е запазена в компютъра.
identity-extension-page = Страницата е отворена от разширение.
identity-active-blocked = { -brand-short-name } блокира части от страницата, които не са шифрирани.
identity-custom-root = Връзката е потвърдена от издател на сертификат, който не е разпознат от Mozilla.
identity-passive-loaded = Части от страницата, например изображения, не са шифровани.
identity-active-loaded = Изключихте защитата за тази страница.
identity-weak-encryption = Тази странница използва слабо шифриране.
identity-insecure-login-forms = Въведените на страницата данни за вход може да бъдат компрометирани.
identity-permissions =
    .value = Права
identity-permissions-reload-hint = За да бъдат приложени промените може да се наложи да презаредите страницата.
identity-permissions-empty = Не сте дали допълнителни права на страницата.
identity-clear-site-data =
    .label = Изчистване на бисквитки и данни…
identity-connection-not-secure-security-view = Връзката със сайта не е сигурна.
identity-connection-verified = Връзката със сайта е сигурна.
identity-ev-owner-label = Сертификатът е издаден на:
identity-description-custom-root = Mozilla не разпознава този издател на сертификати. Може да е добавен от вашата операционна система или от администратор. <label data-l10n-name="link">Научете повече</label>
identity-remove-cert-exception =
    .label = Премахване на изключението
    .accesskey = П
identity-description-insecure = Връзката ви със сайта не е поверителна. Изпращаната информация, като например пароли, съобщения, банкови карти и др., може да бъде видяна от други.
identity-description-insecure-login-forms = Данните за регистрацията, които въвеждате в страницата, не са защитени и може да бъдат компрометирани.
identity-description-weak-cipher-intro = Връзката с тази страница използва слабо шифроване и не е поверителна.
identity-description-weak-cipher-risk = Други хора могат да виждат ваша информация и да променят поведението на уебсайта.
identity-description-active-blocked = { -brand-short-name } блокира части от страницата, които не са шифрирани. <label data-l10n-name="link">Научете повече</label>
identity-description-passive-loaded = Връзката не е поверителна и споделяната информация със сайта може да бъде видяна от други.
identity-description-passive-loaded-insecure = Страницата има нешифровано съдържание, като например изображения. <label data-l10n-name="link">Научете повече</label>
identity-description-passive-loaded-mixed = { -brand-short-name } блокира част от съдържанието, но все още има съдържание, което не е шифрирано, като например изображения. <label data-l10n-name="link">Научете повече</label>
identity-description-active-loaded = Страницата има съдържание, например скриптове, което не е шифровано, и връзката със сайта не е поверителна.
identity-description-active-loaded-insecure = Споделяната със сайта информация, като например пароли, съобщения, банкови карти и др., може да бъде виждана от други.
identity-learn-more =
    .value = Научете повече
identity-disable-mixed-content-blocking =
    .label = Изключване на защитата за момента
    .accesskey = И
identity-enable-mixed-content-blocking =
    .label = Включване на защитата
    .accesskey = В
identity-more-info-link-text =
    .label = Повече информация

## Window controls

browser-window-minimize-button =
    .tooltiptext = Минимизиране
browser-window-maximize-button =
    .tooltiptext = Увеличаване
browser-window-close-button =
    .tooltiptext = Затваряне

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Камера за споделяне:
    .accesskey = К
popup-select-microphone =
    .value = Микрофон за споделяне:
    .accesskey = М
popup-all-windows-shared = Всички видими прозорци на вашия екран ще бъдат споделени.
popup-screen-sharing-not-now =
    .label = Не сега
    .accesskey = а
popup-screen-sharing-never =
    .label = Никога
    .accesskey = Н

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Търсете или въведете адрес
urlbar-placeholder =
    .placeholder = Търсете или въведете адрес
urlbar-remote-control-notification-anchor =
    .tooltiptext = Четецът е под дистанционно управление
urlbar-permissions-granted =
    .tooltiptext = Дали сте допълнителни права на страницата.
urlbar-switch-to-tab =
    .value = Превключване към раздел:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Разширение:
urlbar-go-button =
    .tooltiptext = Зареждане на адреса в полето
urlbar-page-action-button =
    .tooltiptext = Действия със страницата
urlbar-pocket-button =
    .tooltiptext = Запазване в { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> на цял екран
fullscreen-warning-no-domain = Сега документът е на цял екран
fullscreen-exit-button = Излизане от цял екран (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Излизане от цял екран (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> контролира показалеца на мишката ви. Натиснете Esc, за да си възвърнете контрола.
pointerlock-warning-no-domain = Този документ контролира показалеца на мишката ви. Натиснете Esc, за да си възвърнете контрола.
