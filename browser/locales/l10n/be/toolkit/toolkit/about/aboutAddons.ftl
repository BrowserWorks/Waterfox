# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Менеджар дадаткаў
addons-page-title = Менеджар дадаткаў

search-header =
    .placeholder = Пошук на addons.mozilla.org
    .searchbuttonlabel = Пошук

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = У вас няма ніводнага ўсталяванага дадатку гэтага тыпу

list-empty-available-updates =
    .value = Абнаўленні не знойдзеныя

list-empty-recent-updates =
    .value = Нядаўна вы не абнаўлялі ніякіх дадаткаў

list-empty-find-updates =
    .label = Знайсці абнаўленні

list-empty-button =
    .label = Падрабязней пра дадаткі

help-button = Падтрымка дадаткаў
sidebar-help-button-title =
    .title = Падтрымка дадаткаў

preferences =
    { PLATFORM() ->
        [windows] Налады { -brand-short-name }
       *[other] Параметры { -brand-short-name }
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Налады { -brand-short-name }
           *[other] Параметры { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Некаторыя пашырэнні не могуць быць правераны

show-all-extensions-button =
    .label = Паказаць усе пашырэнні

cmd-show-details =
    .label = Паказаць больш звестак
    .accesskey = П

cmd-find-updates =
    .label = Знайсці абнаўленні
    .accesskey = З

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Налады
           *[other] Налады
        }
    .accesskey =
        { PLATFORM() ->
            [windows] Н
           *[other] Н
        }

cmd-enable-theme =
    .label = Ужыць тэму
    .accesskey = У

cmd-disable-theme =
    .label = Спыніць ужыванне тэмы
    .accesskey = у

cmd-install-addon =
    .label = Усталяваць
    .accesskey = У

cmd-contribute =
    .label = Ахвяраваць
    .accesskey = А
    .tooltiptext = Ахвяраваць сродкі на распрацоўку гэтага дадатку

detail-version =
    .label = Версія

detail-last-updated =
    .label = Апошняе абнаўленне

detail-contributions-description = Распрацоўца гэтага дадатка просіць падтрымаць яго распрацоўку невялікім ахвяраваннем.

detail-contributions-button = Зрабіць унёсак
    .title = Зрабіць унёсак у распрацоўку гэтага дадатку
    .accesskey = с

detail-update-type =
    .value = Аўтаматычныя абнаўленні

detail-update-default =
    .label = Прадвызначана
    .tooltiptext = Самастойна ўсталёўваць абнаўленні, калі гэта прадвызначана

detail-update-automatic =
    .label = Укл.
    .tooltiptext = Аўтаматычна ўсталёўваць абнаўленні

detail-update-manual =
    .label = Выкл.
    .tooltiptext = Не ўсталёўваць абнаўленні аўтаматычна

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Задзейнічаць у прыватных вокнах

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Не дазволена ў прыватных вокнах
detail-private-disallowed-description2 = Гэта пашырэнне не працуе ў час прыватнага аглядання. <a data-l10n-name="learn-more">Падрабязней</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Патрабуе доступ да прыватных акон
detail-private-required-description2 = Гэта пашырэнне мае доступ да вашай дзейнасці ў сеціве ў час прыватнага аглядання. <a data-l10n-name="learn-more">Падрабязней</a>

detail-private-browsing-on =
    .label = Дазволіць
    .tooltiptext = Уключаць у рэжыме прыватнага аглядання

detail-private-browsing-off =
    .label = Не дазваляць
    .tooltiptext = Адключаць у рэжыме прыватнага аглядання

detail-home =
    .label = Хатняя старонка

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Профіль дадатка

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Знайсці абнаўленні
    .accesskey = н
    .tooltiptext = Праверыць, ці існуюць абнаўленні гэтага дадатку

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Налады
           *[other] Налады
        }
    .accesskey =
        { PLATFORM() ->
            [windows] Н
           *[other] Н
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Змяненне налад гэтага дадатка
           *[other] Змяненне налад гэтага дадатка
        }

detail-rating =
    .value = Ацэнка

addon-restart-now =
    .label = Перазапусціць зараз

disabled-unsigned-heading =
    .value = Некаторыя дадаткі былі адключаны

disabled-unsigned-description = Праца наступных дадаткаў у { -brand-short-name } не была праверана. Вы можаце <label data-l10n-name="find-addons">знайсці ім замену</label> або папрасіць распрацоўшчыка правесці іх праверку.

disabled-unsigned-learn-more = Даведайцеся больш пра нашы намаганні ў забеспячэнні вашай бяспекі ў інтэрнэце.

disabled-unsigned-devinfo = Распрацоўшчыкі, зацікаўленыя ў праверцы сваіх дадаткаў, могуць прачытаць наш <label data-l10n-name="learn-more">дапаможнік</label>.

plugin-deprecation-description = Нешта адсутнічае? { -brand-short-name } больш не падтрымлівае некаторыя плагіны. <label data-l10n-name="learn-more">Падрабязней.</label>

legacy-warning-show-legacy = Паказаць састарэлыя пашырэнні

legacy-extensions =
    .value = Састарэлыя пашырэнні

legacy-extensions-description = Гэтыя пашырэнні не адпавядаюць бягучым стандартам { -brand-short-name }, таму яны былі выключаны. <label data-l10n-name="legacy-learn-more">Даведацца аб зменах у дадатках</label>

private-browsing-description2 =
    { -brand-short-name } змяняе парадак працы пашырэнняў у прыватным агляданні. Усе новыя пашырэнні, якія вы дадаяце да
    { -brand-short-name }, тыпова не будуць дзейнічаць у прыватных вокнах. Пакуль вы не выставіце дазвол у наладах,
    пашырэнне не будзе працаваць у час прыватнага аглядання, і не будзе мець доступу да вашай сеціўнай
    актыўнасці ў гэтым рэжыме. Мы зрабілі гэта для аховы вашай прыватнасці.
    <label data-l10n-name="private-browsing-learn-more">Даведайцеся, як кіраваць наладамі пашырэння.</label>

addon-category-discover = Рэкамендацыі
addon-category-discover-title =
    .title = Рэкамендацыі
addon-category-extension = Пашырэнні
addon-category-extension-title =
    .title = Пашырэнні
addon-category-theme = Тэмы
addon-category-theme-title =
    .title = Тэмы
addon-category-plugin = Плагіны
addon-category-plugin-title =
    .title = Плагіны
addon-category-dictionary = Слоўнікі
addon-category-dictionary-title =
    .title = Слоўнікі
addon-category-locale = Мовы
addon-category-locale-title =
    .title = Мовы
addon-category-available-updates = Даступныя абнаўленні
addon-category-available-updates-title =
    .title = Даступныя абнаўленні
addon-category-recent-updates = Нядаўнія абнаўленні
addon-category-recent-updates-title =
    .title = Нядаўнія абнаўленні

## These are global warnings

extensions-warning-safe-mode = Усе дадаткі адключаны бяспечным рэжымам.
extensions-warning-check-compatibility = Праверка сумяшчальнасці дадаткаў адключана. Вы можаце мець несумяшчальныя дадаткі.
extensions-warning-check-compatibility-button = Уключыць
    .title = Уключыць праверку сумяшчальнасці дадаткаў
extensions-warning-update-security = Праверка бяспечнасці дадаткаў адключана. Вы можаце быць падведзены пад рызыку абнаўленнямі.
extensions-warning-update-security-button = Уключыць
    .title = Уключыць праверку бяспечнасці абнаўленняў дадаткаў


## Strings connected to add-on updates

addon-updates-check-for-updates = Праверыць наяўнасць абнаўленняў
    .accesskey = с
addon-updates-view-updates = Пабачыць нядаўнія абнаўленні
    .accesskey = б

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Аўтаматычна абнаўляць дадаткі
    .accesskey = А

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Наладзіць усе дадаткі абнаўляцца самастойна
    .accesskey = Н
addon-updates-reset-updates-to-manual = Наладзіць усе дадаткі на ручное абнаўленне
    .accesskey = Н

## Status messages displayed when updating add-ons

addon-updates-updating = Абнаўленне дадаткаў
addon-updates-installed = Вашы дадаткі абноўленыя.
addon-updates-none-found = Абнаўленні не знойдзеныя
addon-updates-manual-updates-found = Пабачыць даступныя абнаўленні

## Add-on install/debug strings for page options menu

addon-install-from-file = Усталяваць дадатак з файла…
    .accesskey = У
addon-install-from-file-dialog-title = Выберыце дадатак для ўсталявання
addon-install-from-file-filter-name = Дадаткі
addon-open-about-debugging = Адладка дадаткаў
    .accesskey = А

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Кіраваць спалучэннямі клавіш пашырэнняў
    .accesskey = ы

shortcuts-no-addons = У вас не ўключана ніводнага пашырэння.
shortcuts-no-commands = Наступныя пашырэнні не маюць спалучэнняў клавіш:
shortcuts-input =
    .placeholder = Увядзіце спалучэнне клавіш

shortcuts-browserAction2 = Актываваць кнопку на паліцы прылад
shortcuts-pageAction = Актываваць дзеянні старонкі
shortcuts-sidebarAction = Паказаць/схаваць бакавую панэль

shortcuts-modifier-mac = Улучыце Ctrl, Alt або ⌘
shortcuts-modifier-other = Улучыце Ctrl або Alt
shortcuts-invalid = Недапушчальная камбінацыя
shortcuts-letter = Увядзіце літару
shortcuts-system = Нельга перавызначыць спалучэнне клавіш { -brand-short-name }

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Дублікат спалучэння клавіш

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } выкарыстоўваецца як спалучэнне клавіш больш чым у адным выпадку. Дубліраваныя спалучэнні могуць выклікаць нечаканыя паводзіны.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Ужо выкарыстоўваецца дадаткам { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Паказаць яшчэ { $numberToShow }
        [few] Паказаць яшчэ { $numberToShow }
       *[many] Паказаць яшчэ { $numberToShow }
    }

shortcuts-card-collapse-button = Паказаць менш

header-back-button =
    .title = Вярнуцца

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Пашырэнні і тэмы - як праграмы для вашага браўзера, яны дазваляюць
    вам абараняць паролі, сцягваць відэа, знаходзіць зніжкі, блакаваць
    раздражняльныя аб'явы, змяняць выгляд браўзера і шмат іншага. Гэтыя
    невялікія праграмы часта распрацаваны трэцім бокам. Гэты набор { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">рэкамендуе </a> для выключнай
    бяспекі, прадукцыйнасці і функцыянальнасці.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Некаторыя з гэтых рэкамендацый персаніфікаваныя. Яны заснаваны на іншых
    пашырэннях, якія вы ўсталявалі, перавагах профілю і статыстыцы выкарыстання.
discopane-notice-learn-more = Даведацца больш

privacy-policy = Палітыка прыватнасці

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = ад <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Карыстальнікаў: { $dailyUsers }
install-extension-button = Дадаць у { -brand-product-name }
install-theme-button = Усталяваць тэму
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Кіраванне
find-more-addons = Знайсці больш дадаткаў

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Дадатковыя параметры

## Add-on actions

report-addon-button = Паведаміць
remove-addon-button = Выдаліць
# The link will always be shown after the other text.
remove-addon-disabled-button = Нельга выдаліць <a data-l10n-name="link">Чаму?</a>
disable-addon-button = Адключыць
enable-addon-button = Уключыць
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Уключыць
preferences-addon-button =
    { PLATFORM() ->
        [windows] Налады
       *[other] Перавагі
    }
details-addon-button = Падрабязнасці
release-notes-addon-button = Заўвагі да выпуску
permissions-addon-button = Правы доступу

extension-enabled-heading = Уключана
extension-disabled-heading = Адключана

theme-enabled-heading = Уключана
theme-disabled-heading = Выключана

plugin-enabled-heading = Уключана
plugin-disabled-heading = Адключана

dictionary-enabled-heading = Уключана
dictionary-disabled-heading = Адключана

locale-enabled-heading = Уключана
locale-disabled-heading = Выключана

ask-to-activate-button = Спытаць для задзейнічання
always-activate-button = Заўсёды задейнічаць
never-activate-button = Ніколі не задзейнічаць

addon-detail-author-label = Аўтар
addon-detail-version-label = Версія
addon-detail-last-updated-label = Апошняе абнаўленне
addon-detail-homepage-label = Хатняя старонка
addon-detail-rating-label = Ацэнка

# Message for add-ons with a staged pending update.
install-postponed-message = Гэта пашырэнне будзе абноўлена пасля перазапуску { -brand-short-name }.
install-postponed-button = Абнавіць зараз

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Ацэнена на { NUMBER($rating, maximumFractionDigits: 1) } з 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (адключана)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } водгук
        [few] { $numberOfReviews } водгукі
       *[many] { $numberOfReviews } водгукаў
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> быў выдалены.
pending-uninstall-undo-button = Адмяніць

addon-detail-updates-label = Дазволіць аўтаматычныя абнаўленні
addon-detail-updates-radio-default = Прадвызначана
addon-detail-updates-radio-on = Укл.
addon-detail-updates-radio-off = Выкл.
addon-detail-update-check-label = Праверыць наяўнасць абнаўленняў
install-update-button = Абнавіць

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Дазволена ў прыватных вокнах
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Калі дазволена, пашырэнне будзе мець доступ да вашай дзейнасці ў сеціве ў час прыватнага аглядання. <a data-l10n-name="learn-more">Даведацца больш</a>
addon-detail-private-browsing-allow = Дазволіць
addon-detail-private-browsing-disallow = Не дазваляць

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } рэкамендуе толькі пашырэнні, якія адпавядаюць нашым стандартам бяспекі і прадукцыйнасці
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Даступныя абнаўленні
recent-updates-heading = Нядаўнія абнаўленні

release-notes-loading = Загрузка…
release-notes-error = Выбачайце, здарылася памылка пры загрузцы заўваг да выпуску.

addon-permissions-empty = Гэта пашырэнне не патрабуе якіх-небудзь дазволаў

recommended-extensions-heading = Рэкамендаваныя пашырэнні
recommended-themes-heading = Рэкамендаваныя тэмы

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Адчуваеце натхненне? <a data-l10n-name="link">Стварыце ўласную тэму з дапамогай Firefox Color.</a>

## Page headings

extension-heading = Кіруйце сваімі пашырэннямі
theme-heading = Кіруйце сваімі тэмамі
plugin-heading = Кіруйце сваімі плагінамі
dictionary-heading = Кіруйце сваімі слоўнікамі
locale-heading = Кіруйце сваімі мовамі
updates-heading = Кіруйце сваімі абнаўленнямі
discover-heading = Персаналізуйце свой { -brand-short-name }
shortcuts-heading = Кіраваць спалучэннямі клавіш пашырэнняў

default-heading-search-label = Знайсці больш дадаткаў
addons-heading-search-input =
    .placeholder = Пошук на addons.mozilla.org

addon-page-options-button =
    .title = Прылады для ўсіх дадаткаў
