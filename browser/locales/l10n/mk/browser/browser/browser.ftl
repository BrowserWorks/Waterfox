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
    .data-title-private = { -brand-full-name } (Приватно прелистување)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Приватно прелистување)
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
    .data-title-private = { -brand-full-name } - (Приватно прелистување)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Приватно прелистување)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Видете ги информациите за веб-сајтот

## Tooltips for images appearing in the address bar

urlbar-eme-notification-anchor =
    .tooltiptext = Менаџирање со користење на софтвер со DRM
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Менаџирајте го споделувањето на вашиот микрофон со ова место
urlbar-default-notification-anchor =
    .tooltiptext = Отвори го панелот со пораки
urlbar-translate-notification-anchor =
    .tooltiptext = Преведи ја оваа страница
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Менаџирајте го споделувањето на вашите прозорци или екран со ова место
urlbar-translated-notification-anchor =
    .tooltiptext = Менаџирање со превод на страници
urlbar-plugins-notification-anchor =
    .tooltiptext = Менаџирајте го користењето на приклучоци
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Менаџирајте го споделувањето на вашата камера и/или микрофон со ова место
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Складирани податоци во Трајно складиште

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".


## Local search mode indicator labels in the urlbar


##

urlbar-geolocation-blocked =
    .tooltiptext = Го блокиравте пристапот до локациските информации за ова мрежно место.
urlbar-web-notifications-blocked =
    .tooltiptext = Ги блокиравте известувањата за ова мрежно место.
urlbar-camera-blocked =
    .tooltiptext = Го блокиравте пристапот до камерата за ова мрежно место.
urlbar-microphone-blocked =
    .tooltiptext = Го блокиравте пристапот до микрофонот за ова мрежно место.
urlbar-screen-blocked =
    .tooltiptext = Го блокиравте споделувањето на екранот од страна на ова мрежно место.

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Додај во Адресна летна
page-action-remove-from-urlbar =
    .label = Отстрани од Адресна лента

## Auto-hide Context Menu

full-screen-autohide =
    .label = Скриј ги алатниците
    .accesskey = С
full-screen-exit =
    .label = Излез од режим на цел екран
    .accesskey = ц

## Search Engine selection buttons (one-offs)

# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Промени поставки за пребарување
search-one-offs-change-settings-compact-button =
    .tooltiptext = Промени поставки за пребарување
search-one-offs-context-open-new-tab =
    .label = Пребарај во ново јазиче
    .accesskey = П
search-one-offs-context-set-as-default =
    .label = Постави како основен пребарувач
    .accesskey = П

## Local search mode one-off buttons
## Variables:
##  $restrict (String): The restriction token corresponding to the search mode.
##    Restriction tokens are special characters users can type in the urlbar to
##    restrict their searches to certain sources (e.g., "*" to search only
##    bookmarks).


## Bookmark Panel

bookmark-panel-done-button =
    .label = Во ред

## Identity Panel

identity-connection-internal = Ова е безбедна страница на { -brand-short-name }.
identity-connection-file = Оваа страница е складирана на вашиот компјутер.
identity-extension-page = Оваа страница е вчитана преку проширување.
identity-active-blocked = { -brand-short-name } блокираше делови од оваа страница што не се безбедни.
identity-passive-loaded = Делови од оваа страница не се безбедни (како на пример, сликите).
identity-active-loaded = Ја исклучивте заштитата за оваа страница.
identity-weak-encryption = Оваа страница користи слаба енкрипција.
identity-insecure-login-forms = Најавувањата на оваа страница можат да бидат злоупотребени.
identity-permissions-reload-hint = Можно е да треба да ја превчитате страницата за измените да имаат ефект.
identity-permissions-empty = Немате активирано специфични дозволи за ова место.
identity-remove-cert-exception =
    .label = Отстрани исклучок
    .accesskey = Д
identity-description-insecure-login-forms = Податоците што ги внесувате за најава на оваа страница не се безбедни и би можеле да бидат злоупотребени.
identity-description-weak-cipher-intro = Вашата врска со ова мрежно место користи слаба енкрипција и не е приватна.
identity-description-weak-cipher-risk = Други луѓе можат да ги гледаат вашите информации или да го менуваат однесувањето на мрежното место.
identity-description-active-blocked = { -brand-short-name } блокираше делови од оваа страница што не се безбедни. <label data-l10n-name="link">Дознај повеќе</label>
identity-description-passive-loaded = Вашата врска не е приватна и податоците што ги споделувате со ова место, би можеле да бидат видливи за други.
identity-description-passive-loaded-insecure = Ова мрежно место има содржини што не се безбедни (како на пример: слики). <label data-l10n-name="link">Дознај повеќе</label>
identity-description-passive-loaded-mixed = Иако { -brand-short-name } блокираше некои содржини, оваа страница сѐ уште има содржини што не се безбедни (како, на пример, слики). <label data-l10n-name="link">Дознај повеќе</label>
identity-description-active-loaded = Ова мрежно место има содржини што не се безбедни (како на пример: скрипти) и вашата врска не е приватна.
identity-description-active-loaded-insecure = Податоците што ги споделувате со ова место би можеле да бидат видливи за други (како на пример: лозинки, пораки, кредитни картички и сл.).
identity-learn-more =
    .value = Дознај повеќе
identity-disable-mixed-content-blocking =
    .label = Исклучи заштита за сега
    .accesskey = Д
identity-enable-mixed-content-blocking =
    .label = Активирај заштита
    .accesskey = Б
identity-more-info-link-text =
    .label = Повеќе информации

## Window controls

browser-window-minimize-button =
    .tooltiptext = Минимизира
browser-window-close-button =
    .tooltiptext = Затвора

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Камера што се споделува:
    .accesskey = П
popup-select-microphone =
    .value = Микрофон што се споделува:
    .accesskey = м
popup-all-windows-shared = Сите видливи прозорци на вашиот екран ќе бидат споделени.

## WebRTC window or screen share tab switch warning


## DevTools F12 popup


## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Барај или внеси адреса
urlbar-placeholder =
    .placeholder = Барај или внеси адреса
urlbar-remote-control-notification-anchor =
    .tooltiptext = Прелистувачот е контролиран далечински
urlbar-switch-to-tab =
    .value = Оди до јазиче:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Проширување:
urlbar-go-button =
    .tooltiptext = Ја отвора адресата во локациската лента
urlbar-page-action-button =
    .tooltiptext = Активности на страница

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> сега се прикажува на цел екран
fullscreen-warning-no-domain = Овој документ сега се прикажува на цел екран
fullscreen-exit-button = Излези од приказ на цел екран (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Излези од приказ на цел екран (Esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> го контролира вашиот покажувач. Притиснете Esc за да ја преземете контролата.
pointerlock-warning-no-domain = Овој документ ви ја презема контролата врз покажувачот. Притиснете Esc за да си ја вратите.
