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
    .data-title-private = { -brand-full-name } (Прыватнае агляданне)
    .data-content-title-default = { $content-title } - { -brand-full-name }
    .data-content-title-private = { $content-title } - { -brand-full-name } (Прыватнае агляданне)
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
    .data-title-private = { -brand-full-name } - (Прыватнае агляданне)
    .data-content-title-default = { $content-title }
    .data-content-title-private = { $content-title } - (Прыватнае агляданне)
# This gets set as the initial title, and is overridden as soon as we start
# updating the titlebar based on loaded tabs or private browsing state.
# This should match the `data-title-default` attribute in both
# `browser-main-window` and `browser-main-window-mac`.
browser-main-window-title = { -brand-full-name }

##

urlbar-identity-button =
    .aria-label = Звесткі аб сайце

## Tooltips for images appearing in the address bar

urlbar-services-notification-anchor =
    .tooltiptext = Адкрыць панэль паведамленняў усталявання
urlbar-web-notification-anchor =
    .tooltiptext = Змяніць магчымасць атрымліваць абвесткі з гэтага сайта
urlbar-midi-notification-anchor =
    .tooltiptext = Адкрыць панэль MIDI
urlbar-eme-notification-anchor =
    .tooltiptext = Кіраваць ужываннем DRM-праграм
urlbar-web-authn-anchor =
    .tooltiptext = Адкрыць панэль вэб-аўтарызацыі
urlbar-canvas-notification-anchor =
    .tooltiptext = Кіраванне доступам да інфармацыі ў canvas
urlbar-web-rtc-share-microphone-notification-anchor =
    .tooltiptext = Кіраваць доступам сайта да вашага мікрафона
urlbar-default-notification-anchor =
    .tooltiptext = Адкрыць панэль паведамленняў
urlbar-geolocation-notification-anchor =
    .tooltiptext = Адкрыць панэль запытаў месцазнаходжання
urlbar-xr-notification-anchor =
    .tooltiptext = Адкрыць панэль дазволаў віртуальнай рэальнасці
urlbar-storage-access-anchor =
    .tooltiptext = Адкрыць панэль дазволу дзеянняў аглядання
urlbar-translate-notification-anchor =
    .tooltiptext = Перакласці гэту старонку
urlbar-web-rtc-share-screen-notification-anchor =
    .tooltiptext = Кіраваць дазволам на прагляд сайтам экрану ці вакон
urlbar-indexed-db-notification-anchor =
    .tooltiptext = Адкрыць панэль паведамленняў пазасеткавага сховішча
urlbar-password-notification-anchor =
    .tooltiptext = Адкрыць панэль паведамленняў аб захаванні пароля
urlbar-translated-notification-anchor =
    .tooltiptext = Кіраваць перакладам старонкі
urlbar-plugins-notification-anchor =
    .tooltiptext = Кіраваць выкарыстаннем плагіна
urlbar-web-rtc-share-devices-notification-anchor =
    .tooltiptext = Кіраваць доступам сайта да вашай камеры і/або мікрафона
urlbar-autoplay-notification-anchor =
    .tooltiptext = Адкрыць панэль аўтапрайгравання
urlbar-persistent-storage-notification-anchor =
    .tooltiptext = Захоўваць звесткі ў Сталым Сховішчы (Persistent Storage)
urlbar-addons-notification-anchor =
    .tooltiptext = Адкрыць панэль паведамленняў аб усталяванні дадатка
urlbar-tip-help-icon =
    .title = Дапамога
urlbar-search-tips-confirm = Добра, зразумела
# Read out before Urlbar Tip text content so screenreader users know the
# subsequent text is a tip offered by the browser. It should end in a colon or
# localized equivalent.
urlbar-tip-icon-description =
    .alt = Парада:

## Prompts users to use the Urlbar when they open a new tab or visit the
## homepage of their default search engine.
## Variables:
##  $engineName (String): The name of the user's default search engine. e.g. "Google" or "DuckDuckGo".

urlbar-search-tips-onboard = Уводзьце менш, знаходзьце больш: Пошук { $engineName } наўпрост у адрасным радку.
urlbar-search-tips-redirect-2 = Пачніце свой пошук у адрасным радку, каб пабачыць прапановы ад { $engineName } і з вашай гісторыі аглядання.

## Local search mode indicator labels in the urlbar

urlbar-search-mode-bookmarks = Закладкі
urlbar-search-mode-tabs = Карткі
urlbar-search-mode-history = Гісторыя

##

urlbar-geolocation-blocked =
    .tooltiptext = Вы заблакавалі звесткі аб месцазнаходжанні для гэтага вэб-сайта.
urlbar-xr-blocked =
    .tooltiptext = Вы заблакавалі доступ да прылад віртуальнай рэальнасці для гэтага вэб-сайта.
urlbar-web-notifications-blocked =
    .tooltiptext = Вы заблакавалі абвесткі з гэтага вэб-сайта.
urlbar-camera-blocked =
    .tooltiptext = Вы заблакавалі сваю камеру на гэтым вэб-сайце.
urlbar-microphone-blocked =
    .tooltiptext = Вы заблакавалі свой мікрафон на гэтым вэб-сайце.
urlbar-screen-blocked =
    .tooltiptext = Вы заблакавалі гэтаму вэб-сайту магчымасць бачыць ваш экран.
urlbar-persistent-storage-blocked =
    .tooltiptext = Вы заблакавалі захоўванне звестак для гэтага вэб-сайта.
urlbar-popup-blocked =
    .tooltiptext = Вы заблакавалі выплыўныя вокны для гэтага вэб-сайта.
urlbar-autoplay-media-blocked =
    .tooltiptext = Вы заблакавалі аўтапрайграванне медый з гукам на гэтым вэб-сайце.
urlbar-canvas-blocked =
    .tooltiptext = Вы заблакавалі выманне дадзеных canvas для гэтага вэб-сайта.
urlbar-midi-blocked =
    .tooltiptext = Вы заблакавалі MIDI доступ для гэтага вэб-сайта.
urlbar-install-blocked =
    .tooltiptext = Вы заблакавалі ўсталяванне дадаткаў з гэтага вэб-сайта.
# Variables
#   $shortcut (String) - A keyboard shortcut for the edit bookmark command.
urlbar-star-edit-bookmark =
    .tooltiptext = Правіць гэту закладку ({ $shortcut })
# Variables
#   $shortcut (String) - A keyboard shortcut for the add bookmark command.
urlbar-star-add-bookmark =
    .tooltiptext = Дадаць старонку ў закладкі ({ $shortcut })

## Page Action Context Menu

page-action-add-to-urlbar =
    .label = Дадаць у адрасны радок
page-action-manage-extension =
    .label = Кіраваць пашырэннямі…
page-action-remove-from-urlbar =
    .label = Выдаліць з адраснага радка
page-action-remove-extension =
    .label = Выдаліць пашырэнне

## Auto-hide Context Menu

full-screen-autohide =
    .label = Схаваць паліцы прылад
    .accesskey = х
full-screen-exit =
    .label = Выйсці з поўнаэкраннага рэжыму
    .accesskey = В

## Search Engine selection buttons (one-offs)

# This string prompts the user to use the list of one-click search engines in
# the Urlbar and searchbar.
search-one-offs-with-title = На гэты раз шукайце ў:
# This string won't wrap, so if the translated string is longer,
# consider translating it as if it said only "Search Settings".
search-one-offs-change-settings-button =
    .label = Змяніць налады пошуку
search-one-offs-change-settings-compact-button =
    .tooltiptext = Змяніць налады пошуку
search-one-offs-context-open-new-tab =
    .label = Шукаць у новай картцы
    .accesskey = к
search-one-offs-context-set-as-default =
    .label = Зрабіць прадвызначаным пашукавіком
    .accesskey = п
search-one-offs-context-set-as-default-private =
    .label = Усталяваць як прадвызначаны пашукавік для прыватных акон
    .accesskey = з
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
    .tooltiptext = Закладкі ({ $restrict })
search-one-offs-tabs =
    .tooltiptext = Карткі ({ $restrict })
search-one-offs-history =
    .tooltiptext = Гісторыя ({ $restrict })

## Bookmark Panel

bookmark-panel-show-editor-checkbox =
    .label = Паказваць рэдактар пры захаванні
    .accesskey = П
bookmark-panel-done-button =
    .label = Гатова
# Width of the bookmark panel.
# Should be large enough to fully display the Done and
# Cancel/Remove Bookmark buttons.
bookmark-panel =
    .style = min-width: 25em

## Identity Panel

identity-connection-not-secure = Злучэнне не бяспечнае
identity-connection-secure = Бяспечнае злучэнне
identity-connection-internal = Гэта бяспечная { -brand-short-name } старонка.
identity-connection-file = Гэта старонка захоўваецца на вашым камп'ютары.
identity-extension-page = Гэтая старонка загружана з пашырэння.
identity-active-blocked = { -brand-short-name } заблакаваў небяспечныя часткі старонкі.
identity-custom-root = Падключэнне пацверджана сертыфікатам эмітэнта, які не прызнаны Mozilla.
identity-passive-loaded = Некаторыя часткі гэтай старонкі небяспечныя (напрыклад, выявы).
identity-active-loaded = Вы адключылі ахову на гэтай старонцы.
identity-weak-encryption = Гэта старонка ўжывае слабы тып шыфравання.
identity-insecure-login-forms = Лагіны, уведзеныя на гэтай старонцы, могуць быць скампраметаваны.
identity-permissions =
    .value = Дазволы
identity-permissions-reload-hint = Магчыма, вам спатрэбіцца перазагрузіць старонку, каб змены пачалі дзейнічаць.
identity-permissions-empty = Вы не давалі гэтаму сайту ніякіх адмысловых дазволаў.
identity-clear-site-data =
    .label = Выдаліць кукі і дадзеныя сайтаў…
identity-connection-not-secure-security-view = Вы не злучаны бяспечна з гэтым сайтам.
identity-connection-verified = Вы бяспечна злучаны з гэтым сайтам.
identity-ev-owner-label = Сертыфікат выдадзены:
identity-description-custom-root = Mozilla не прызнае гэтага выдаўца сертыфікатаў. Магчыма, ён дададзены з вашай аперацыйнай сістэмы ці адміністратарам. <label data-l10n-name="link">Даведацца больш</label>
identity-remove-cert-exception =
    .label = Выдаліць выключэнне
    .accesskey = В
identity-description-insecure = Ваша злучэнне з гэтым сайтам не з'яўляецца прыватным. Інфармацыя, якую вы ўводзіце, можа быць бачная для іншых (напрыклад, паролі, паведамленні, нумары крэдытных карт і г.д.).
identity-description-insecure-login-forms = Ідэнтыфікацыйная інфармацыя, уведзеная на гэтай старонцы, можа быць скампраметавана.
identity-description-weak-cipher-intro = Вашае злучэнне з гэтым сайтам ўжывае слабы тып шыфравання і не з'яўляецца прыватным.
identity-description-weak-cipher-risk = Іншыя людзі могуць праглядаць вашу асабістую інфармацыю або змяніць паводзіны вэб-сайта.
identity-description-active-blocked = { -brand-short-name } заблакаваў небяспечныя часткі старонкі. <label data-l10n-name="link">Даведацца больш</label>
identity-description-passive-loaded = Ваша злучэнне не з'яўляецца прыватным і інфармацыя, якую вы ўводзіце, можа быць бачная для іншых.
identity-description-passive-loaded-insecure = Гэты сайт мае небяспечны змест (напрыклад, выявы). <label data-l10n-name="link">Даведацца больш</label>
identity-description-passive-loaded-mixed = { -brand-short-name } заблакаваў некаторае змесціва, але яно яшчэ застаецца на гэтай старонцы (напрыклад, выявы). <label data-l10n-name="link">Даведацца больш</label>
identity-description-active-loaded = Гэты вэб-сайт змяшчае неабароненае змесціва (такое, як сцэнары) і ваша злучэнне з ім не з'яўляецца прыватным.
identity-description-active-loaded-insecure = Інфармацыя, якую вы ўводзіце на гэтым сайце, можа быць бачная для іншых (напрыклад, паролі, паведамленні, нумары крэдытных карт і г.д.).
identity-learn-more =
    .value = Даведацца больш
identity-disable-mixed-content-blocking =
    .label = Часова адключыць ахову
    .accesskey = А
identity-enable-mixed-content-blocking =
    .label = Уключыць ахову
    .accesskey = У
identity-more-info-link-text =
    .label = Падрабязней

## Window controls

browser-window-minimize-button =
    .tooltiptext = Мінімізаваць
browser-window-maximize-button =
    .tooltiptext = Разгарнуць
browser-window-restore-down-button =
    .tooltiptext = Згарнуць у акно
browser-window-close-button =
    .tooltiptext = Закрыць

## WebRTC Pop-up notifications

popup-select-camera =
    .value = Да якой камеры даць доступ:
    .accesskey = З
popup-select-microphone =
    .value = Да якога мікрафона даць доступ:
    .accesskey = М
popup-all-windows-shared = Усе бачныя вокны на вашым экране будуць абагулены.
popup-screen-sharing-not-now =
    .label = Не цяпер
    .accesskey = ц
popup-screen-sharing-never =
    .label = Ніколі не дазваляць
    .accesskey = і
popup-silence-notifications-checkbox = Адключыць абвесткі ад { -brand-short-name } на час супольнага доступу
popup-silence-notifications-checkbox-warning = { -brand-short-name } не будзе паказваць абвесткі ў час супольнага доступу.

## WebRTC window or screen share tab switch warning

sharing-warning-window = Вы адкрываеце доступ да { -brand-short-name }. Іншыя людзі могуць бачыць, калі вы пераходзіце на новую картку.
sharing-warning-screen = Вы адкрываеце доступ да ўсяго экрана. Іншыя людзі могуць бачыць, калі вы пераходзіце на новую картку.
sharing-warning-proceed-to-tab =
    .label = Перайсці на картку
sharing-warning-disable-for-session =
    .label = Адключыць ахову агульнага доступу на гэты сеанс

## DevTools F12 popup

enable-devtools-popup-description = Каб выкарыстаць клавішу F12, спачатку адкрыйце інструменты праз меню распрацоўшчыкаў сеціва.

## URL Bar

urlbar-default-placeholder =
    .defaultPlaceholder = Шукаць ці ўвесці адрас
# This placeholder is used when not in search mode and the user's default search
# engine is unknown.
urlbar-placeholder =
    .placeholder = Шукаць ці ўвесці адрас
# This placeholder is used in search mode with search engines that search the
# entire web.
# Variables
#  $name (String): the name of a search engine that searches the entire Web
#  (e.g. Google).
urlbar-placeholder-search-mode-web-2 =
    .placeholder = Пошук у Інтэрнэце
    .aria-label = Пошук з дапамогай { $name }
# This placeholder is used in search mode with search engines that search a
# specific site (e.g., Amazon).
# Variables
#  $name (String): the name of a search engine that searches a specific site
#  (e.g. Amazon).
urlbar-placeholder-search-mode-other-engine =
    .placeholder = Увядзіце пошукавыя тэрміны
    .aria-label = Шукаць на { $name }
# This placeholder is used when searching bookmarks.
urlbar-placeholder-search-mode-other-bookmarks =
    .placeholder = Увядзіце пошукавыя тэрміны
    .aria-label = Шукаць закладкі
# This placeholder is used when searching history.
urlbar-placeholder-search-mode-other-history =
    .placeholder = Увядзіце пошукавыя тэрміны
    .aria-label = Шукаць у гісторыі
# This placeholder is used when searching open tabs.
urlbar-placeholder-search-mode-other-tabs =
    .placeholder = Увядзіце пошукавыя тэрміны
    .aria-label = Шукаць карткі
# Variables
#  $name (String): the name of the user's default search engine
urlbar-placeholder-with-name =
    .placeholder = Шукайце ў { $name } або ўвядзіце адрас
urlbar-remote-control-notification-anchor =
    .tooltiptext = Браўзер знаходзіцца пад аддаленым кіраваннем
urlbar-permissions-granted =
    .tooltiptext = Вы далі гэтаму вэб-сайту дадатковыя дазволы.
urlbar-switch-to-tab =
    .value = Пераключыцца ў картку:
# Used to indicate that a selected autocomplete entry is provided by an extension.
urlbar-extension =
    .value = Пашырэнне:
urlbar-go-button =
    .tooltiptext = Пайсці па адрасе, які зараз у адрасным радку
urlbar-page-action-button =
    .tooltiptext = Дзеянні старонкі
urlbar-pocket-button =
    .tooltiptext = Захаваць у { -pocket-brand-name }

## Full Screen and Pointer Lock UI

# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is full screen, e.g. "mozilla.org"
fullscreen-warning-domain = <span data-l10n-name="domain">{ $domain }</span> цяпер поўнаэкранны
fullscreen-warning-no-domain = Гэты дакумент цяпер поўнаэкранны
fullscreen-exit-button = Выйсці з поўнаэкраннага рэжыму (Esc)
# "esc" is lowercase on mac keyboards, but uppercase elsewhere.
fullscreen-exit-mac-button = Выйсці з поўнаэкраннага рэжыму (esc)
# Please ensure that the domain stays in the `<span data-l10n-name="domain">` markup.
# Variables
#  $domain (String): the domain that is using pointer-lock, e.g. "mozilla.org"
pointerlock-warning-domain = <span data-l10n-name="domain">{ $domain }</span> кіруе вашым указальнікам. Націсніце Esc, каб узяць кіраванне.
pointerlock-warning-no-domain = Гэты дакумент кіруе вашым указальнікам. Націсніце Esc, каб узяць кіраванне.
