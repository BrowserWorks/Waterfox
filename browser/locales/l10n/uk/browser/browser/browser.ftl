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
    .data-title-private = { -brand-full-name } (Приватний перегляд)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Приватний перегляд)
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
    .data-title-private = { -brand-full-name } - (Приватний перегляд)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Приватний перегляд)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Перегляд інформації про сайт

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Відкрити панель повідомлень встановлення
urlbar-web-notification-anchor =
    .tooltiptext = Налаштувати отримання сповіщень від сайту
urlbar-midi-notification-anchor =
    .tooltiptext = Відкрити MIDI панель
urlbar-eme-notification-anchor =
    .tooltiptext = Керувати використанням програмного забезпечення DRM
urlbar-web-authn-anchor =
    .tooltiptext = Відкрити панель веб автентифікації
urlbar-canvas-notification-anchor =
    .tooltiptext = Керувати дозволом видобування canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Керувати доступом сайту до вашого мікрофону
urlbar-default-notification-anchor =
    .tooltiptext = Відкрити панель повідомлень
urlbar-geolocation-notification-anchor =
    .tooltiptext = Відкрити панель запитів розташування
urlbar-xr-notification-anchor =
    .tooltiptext = Відкрити панель дозволів віртуальної реальності
urlbar-storage-access-anchor =
    .tooltiptext = Відкрити панель дозволів активності перегляду
urlbar-translate-notification-anchor =
    .tooltiptext = Перекласти цю сторінку
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Керувати доступом сайту до ваших вікон чи екрану
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Відкрити панель повідомлень автономного сховища
urlbar-password-notification-anchor =
    .tooltiptext = Відкрити панель повідомлень збереження паролів
urlbar-translated-notification-anchor =
    .tooltiptext = Керувати перекладом сторінок
urlbar-plugins-notification-anchor =
    .tooltiptext = Керувати використанням плагінів
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Керувати доступом сайту до ваших камери та/або мікрофону
urlbar-autoplay-notification-anchor =
    .tooltiptext = Відкрити панель автовідтворення
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Зберігати дані в постійному сховищі
urlbar-addons-notification-anchor =
    .tooltiptext = Відкрити панель повідомлень встановлення додатків
urlbar-tip-help-icon =
    .title = Отримати допомогу
urlbar-search-tips-confirm = Гаразд, зрозуміло
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Порада:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Вводьте менше, знаходьте більше: Шукайте з { $engineName } прямо з панелі адреси.
urlbar-search-tips-redirect-2 = Розпочніть пошук з адресного рядка, щоб побачити пропозиції від { $engineName } та історії перегляду.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Закладки
urlbar-search-mode-tabs = Вкладки
urlbar-search-mode-history = Історія

##

urlbar-geolocation-blocked =
    .tooltiptext = Ви заблокували інформацію розташування для цього вебсайту.
urlbar-xr-blocked =
    .tooltiptext = Ви заблокували доступ до пристроїв віртуальної реальності для цього вебсайту.
urlbar-web-notifications-blocked =
    .tooltiptext = Ви заблокували сповіщення для цього вебсайту.
urlbar-camera-blocked =
    .tooltiptext = Ви заблокували камеру для цього вебсайту.
urlbar-microphone-blocked =
    .tooltiptext = Ви заблокували мікрофон для цього вебсайту.
urlbar-screen-blocked =
    .tooltiptext = Ви заблокували доступ до екрану для цього вебсайту.
urlbar-persistent-storage-blocked =
    .tooltiptext = Ви заблокували постійне сховище для цього вебсайту.
urlbar-popup-blocked =
    .tooltiptext = Ви заблокували виринаючі вікна для цього вебсайту.
urlbar-autoplay-media-blocked =
    .tooltiptext = Ви заблокували автовідтворення медіа зі звуком для цього вебсайту.
urlbar-canvas-blocked =
    .tooltiptext = Ви заблокували видобування даних canvas для цього вебсайту.
urlbar-midi-blocked =
    .tooltiptext = Ви заблокували MIDI доступ для цього вебсайту.
urlbar-install-blocked =
    .tooltiptext = Ви заблокували встановлення додатка з цього вебсайту.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Редагувати цю закладку ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Закласти цю сторінку ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Додати до панелі адреси
page-action-manage-extension =
    .label = Керувати розширенням…
page-action-remove-from-urlbar =
    .label = Вилучити з панелі адреси
page-action-remove-extension =
    .label = Вилучити розширення

## Auto-hide Context Menu

full-screen-autohide =
    .label = Приховати панелі
    .accesskey = П
full-screen-exit =
    .label = Вийти з повноекранного режиму
    .accesskey = В

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = Цього разу, пошук з:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Змінити налаштування пошуку
search-one-offs-change-settings-compact-button =
    .tooltiptext = Змінити налаштування пошуку
search-one-offs-context-open-new-tab =
    .label = Пошук в новій вкладці
    .accesskey = в
search-one-offs-context-set-as-default =
    .label = Встановити типовим засобом пошуку
    .accesskey = т
search-one-offs-context-set-as-default-private =
    .label = Встановити типовим засобом пошуку для приватних вікон
    .accesskey = х
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
    .tooltiptext = Історія ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Показати редактор при збереженні
    .accesskey = к
bookmark-panel-done-button =
    .label = Готово
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 23em

## Identity Panel

identity-connection-not-secure = Незахищене з'єднання
identity-connection-secure = Захищене з'єднання
identity-connection-internal = Це захищена сторінка { -brand-short-name }.
identity-connection-file = Ця сторінка збережена на вашому комп'ютері.
identity-extension-page = Ця сторінка завантажена з розширення.
identity-active-blocked = { -brand-short-name } заблокував незахищені частини цієї сторінки.
identity-custom-root = З'єднання засвідчене сертифікатом, видавець якого не розпізнається Mozilla.
identity-passive-loaded = Частини цієї сторінки (такі як зображення) незахищені.
identity-active-loaded = Ви вимкнули захист на цій сторінці.
identity-weak-encryption = Ця сторінка використовує слабке шифрування.
identity-insecure-login-forms = Паролі, введені на цій сторінці, можуть бути скомпрометовані.
identity-permissions =
    .value = Дозволи
identity-permissions-reload-hint = Для застосування змін, можливо, доведеться перезавантажити сторінку.
identity-permissions-empty = Ви не надали цьому сайту жодних спеціальних дозволів.
identity-clear-site-data =
    .label = Стерти куки і дані сайтів…
identity-connection-not-secure-security-view = Ваше з'єднання з цим сайтом незахищене.
identity-connection-verified = Ваше з'єднання з цим сайтом захищене.
identity-ev-owner-label = Сертифікат виданий:
identity-description-custom-root = Mozilla не розпізнає цього видавця сертифіката. Він міг бути доданий вашою операційною системою чи адміністратором. <label data-l10n-name="link">Докладніше</label>
identity-remove-cert-exception =
    .label = Вилучити виняток
    .accesskey = В
identity-description-insecure = Ваше з'єднання з цим сайтом не є приватним. Інформація, яку ви відправляєте може бути переглянута іншими (наприклад, паролі, повідомлення, дані кредитних карт та ін.).
identity-description-insecure-login-forms = Введені на цій сторінці дані входу не захищені і можуть бути перехоплені.
identity-description-weak-cipher-intro = Ваше з'єднання з цим вебсайтом використовує слабке шифрування і не є приватним.
identity-description-weak-cipher-risk = Інші люди можуть переглядати вашу інформацію чи змінювати поведінку вебсайту.
identity-description-active-blocked = { -brand-short-name } заблокував незахищені частини цієї сторінки. <label data-l10n-name="link">Докладніше</label>
identity-description-passive-loaded = Ваше з'єднання не є приватним й інформація, якою ви ділитесь з сайтом може бути переглянута іншими.
identity-description-passive-loaded-insecure = Цей вебсайт містить незахищений вміст (наприклад, зображення). <label data-l10n-name="link">Докладніше</label>
identity-description-passive-loaded-mixed = Хоча { -brand-short-name } заблокував деякий вміст, на сторінці все ще є незахищений вміст (наприклад, зображення). <label data-l10n-name="link">Докладніше</label>
identity-description-active-loaded = Цей вебсайт має вміст, що не є безпечним (наприклад, сценарії) і ваше з'єднання з ним не є приватним.
identity-description-active-loaded-insecure = Інформація, якою ви ділитесь з цим сайтом, може бути переглянута іншими (наприклад, паролі, повідомлення, дані кредитних карт та ін.).
identity-learn-more =
    .value = Докладніше
identity-disable-mixed-content-blocking =
    .label = Тимчасово вимкнути захист
    .accesskey = в
identity-enable-mixed-content-blocking =
    .label = Увімкнути захист
    .accesskey = У
identity-more-info-link-text =
    .label = Докладніше

## Window controls

browser-window-minimize-button =
    .tooltiptext = Згорнути
browser-window-maximize-button =
    .tooltiptext = Розгорнути
browser-window-restore-down-button =
    .tooltiptext = Відновити вниз
browser-window-close-button =
    .tooltiptext = Закрити

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Доступ до камери:
    .accesskey = к
popup-select-microphone =
    .value = Доступ до мікрофону:
    .accesskey = м
popup-all-windows-shared = Надасться доступ до всіх видимих вікон на вашому екрані.
popup-screen-sharing-not-now =
    .label = Не зараз
    .accesskey = е
popup-screen-sharing-never =
    .label = Ніколи не дозволяти
    .accesskey = Н
popup-silence-notifications-checkbox = Вимкнути сповіщення від { -brand-short-name } під час спільного доступу
popup-silence-notifications-checkbox-warning = { -brand-short-name } не показуватиме сповіщення під час спільного доступу.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Ви надаєте спільний доступ до { -brand-short-name }. Інші люди можуть бачити, коли ви перемикаєтесь на нову вкладку.
sharing-warning-screen = Ви надаєте спільний доступ до цілого екрана. Інші люди можуть бачити, коли ви перемикаєтесь на нову вкладку.
sharing-warning-proceed-to-tab =
    .label = Перемкнути вкладку
sharing-warning-disable-for-session =
    .label = Вимкнути захист спільного доступу для цього сеансу

## DevTools F12 popup

enable-devtools-popup-description = Щоб використовувати F12, спочатку відкрийте DevTools через меню Веб розробка.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Введіть пошуковий запит чи адресу
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Введіть пошуковий запит чи адресу
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Пошук в Інтернеті
    .aria-label = Шукати за допомогою { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Введіть пошукові терміни
    .aria-label = Шукати { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Введіть пошукові терміни
    .aria-label = Шукати в закладках
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Введіть пошукові терміни
    .aria-label = Шукати в історії
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Введіть пошукові терміни
    .aria-label = Шукати у вкладках
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Шукайте з { $name } або введіть адресу
urlbar-remote-control-notification-anchor =
    .tooltiptext = Браузер знаходиться під віддаленим керуванням
urlbar-permissions-granted =
    .tooltiptext = Ви надали цьому вебсайту додаткові дозволи.
urlbar-switch-to-tab =
    .value = Перемкнутись на вкладку:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Розширення:
urlbar-go-button =
    .tooltiptext = Перейти за адресою з панелі адреси
urlbar-page-action-button =
    .tooltiptext = Дії сторінки
urlbar-pocket-button =
    .tooltiptext = Зберегти в { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> тепер у повноекранному режимі
fullscreen-warning-no-domain = Цей документ тепер у повноекранному режимі
fullscreen-exit-button = Вийти з повноекранного режиму (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Вийти з повноекранного режиму (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> отримав контроль над вашим вказівником. Натисніть Esc для повернення контролю.
pointerlock-warning-no-domain = Цей документ отримав контроль над вашим вказівником. Натисніть Esc для повернення контролю.
