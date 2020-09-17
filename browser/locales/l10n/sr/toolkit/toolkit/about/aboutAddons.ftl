# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Менаџер додатака

addons-page-title = Менаџер додатака

search-header =
    .placeholder = Претражи сајт addons.mozilla.org
    .searchbuttonlabel = Претражи

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Нисте инсталирали ниједан додатак ове врсте

list-empty-available-updates =
    .value = Нема ажурирања

list-empty-recent-updates =
    .value = Нисте недавно ажурирали додатке

list-empty-find-updates =
    .label = Провери да ли постоје ажурирања

list-empty-button =
    .label = Сазнајте више о додацима

help-button = Подршка за додатке

sidebar-help-button-title =
    .title = Подршка за додатке

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } опције
       *[other] { -brand-short-name } поставке
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } опције
           *[other] { -brand-short-name } поставке
        }

show-unsigned-extensions-button =
    .label = Неке екстензије нису могле бити потврђене

show-all-extensions-button =
    .label = Прикажи све екстензије

cmd-show-details =
    .label = Прикажи више информација
    .accesskey = в

cmd-find-updates =
    .label = Нађи ажурирања
    .accesskey = Н

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Поставке
           *[other] Поставке
        }
    .accesskey =
        { PLATFORM() ->
            [windows] П
           *[other] П
        }

cmd-enable-theme =
    .label = Укључи тему
    .accesskey = У

cmd-disable-theme =
    .label = Искључи тему
    .accesskey = И

cmd-install-addon =
    .label = Постави
    .accesskey = П

cmd-contribute =
    .label = Допринеси
    .accesskey = Д
    .tooltiptext = Дајте прилог аутору овог додатка

detail-version =
    .label = Издање

detail-last-updated =
    .label = Последњи пут ажурирано

detail-contributions-description = Програмер овог додатка моли да подржите његов непрекидан развој, тако што ћете дати мали допринос.

detail-contributions-button = Допринеси
    .title = Допринеси развоју овог додатка
    .accesskey = и

detail-update-type =
    .value = Аутоматска ажурирања

detail-update-default =
    .label = Подразумевано
    .tooltiptext = Аутоматски ажурирај само ако је то подразумевано

detail-update-automatic =
    .label = Укључено
    .tooltiptext = Аутоматски ажурирај додатке

detail-update-manual =
    .label = Искључено
    .tooltiptext = Немој да аутоматски инсталираш додатке

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Рад у приватним прозорима

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Није дозвољено у приватним прозорима

detail-private-disallowed-description2 = Ово проширење се не покреће у приватном прегледавању. <a data-l10n-name="learn-more">Сазнајте више</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Захтева приступ приватним прозорима

detail-private-required-description2 = Ово проширење има приступ вашим активностима у приватном прегледавању. <a data-l10n-name="learn-more">Сазнајте више</a>

detail-private-browsing-on =
    .label = Дозволи
    .tooltiptext = Омогући у приватном прегледању

detail-private-browsing-off =
    .label = Забрани
    .tooltiptext = Онемогући у приватном прегледању

detail-home =
    .label = Почетна страница

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Профил додатка

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Провери да ли постоје ажурирања
    .accesskey = и
    .tooltiptext = Проверите да ли постоје унапређења овог додатка

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Могућности
           *[other] Поставке
        }
    .accesskey =
        { PLATFORM() ->
            [windows] М
           *[other] П
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Промени опције овог додатка
           *[other] Промени подешавања овог додатка
        }

detail-rating =
    .value = Оцена

addon-restart-now =
    .label = Поново покрени

disabled-unsigned-heading =
    .value = Неки додаци су онемогућени

disabled-unsigned-description = Следећи додаци нису могли бити потврђени за коришћење у { -brand-short-name }-у. Можете <label data-l10n-name="find-addons">наћи замене</label> или питати програмере да их потврде.

disabled-unsigned-learn-more = Сазнајте више како да помогнете да Вас одржимо сигурним на мрежи.

disabled-unsigned-devinfo = Програмери који желе да потврде њихове додатке могу да прочитају наша <label data-l10n-name="learn-more">упутства</label>.

plugin-deprecation-description = Нешто недостаје? { -brand-short-name } више не подржава неке прикључке. <label data-l10n-name="learn-more">Сазнајте више.</label>

legacy-warning-show-legacy = Прикажи застареле екстензије

legacy-extensions =
    .value = Застареле екстензије

legacy-extensions-description = Ове екстензије не подржавају тренутни { -brand-short-name } стандард тако да су онемогућене. <label data-l10n-name="legacy-learn-more">Сазнајте више о променама додатака</label>

private-browsing-description2 =
    { -brand-short-name } мења начин рада екстензија у режиму приватног прегледања. Нове екстензије које 
    будете додали у { -brand-short-name } подразумевано неће радити у приватним прозорима. Осим ако то не 
    дозволите у подешавањима, екстензија неће радити док сте у режиму приватног прегледања и неће имати 
    приступ вашим активностима на мрежи. Начинили смо ову измену да бисмо одржали ваше коришћење 
    интернета у приватном режиму приватним.
    <label data-l10n-name="private-browsing-learn-more">Сазнајте како да управљате подешавањима екстензија</label>

addon-category-discover = Препоруке
addon-category-discover-title =
    .title = Препоруке
addon-category-extension = Екстензије
addon-category-extension-title =
    .title = Екстензије
addon-category-theme = Теме
addon-category-theme-title =
    .title = Теме
addon-category-plugin = Прикључци
addon-category-plugin-title =
    .title = Прикључци
addon-category-dictionary = Речници
addon-category-dictionary-title =
    .title = Речници
addon-category-locale = Језици
addon-category-locale-title =
    .title = Језици
addon-category-available-updates = Доступна ажурирања
addon-category-available-updates-title =
    .title = Доступна ажурирања
addon-category-recent-updates = Недавна ажурирања
addon-category-recent-updates-title =
    .title = Недавна ажурирања

## These are global warnings

extensions-warning-safe-mode = Сви додаци су онемогућени у безбедном начину рада.
extensions-warning-check-compatibility = Провера усклађености додатака је искључена. Можда имате некомпатибилне додатке.
extensions-warning-check-compatibility-button = Укључи
    .title = Омогући проверавање компатибилности додатка
extensions-warning-update-security = Безбедносна провера додатака је искључена. Неисправни додаци могу да наруше безбедност система.
extensions-warning-update-security-button = Омогући
    .title = Омогући проверавање безбедности додатка


## Strings connected to add-on updates

addon-updates-check-for-updates = Провери да ли постоје ажурирања
    .accesskey = П
addon-updates-view-updates = Погледај недавна ажурирања
    .accesskey = н

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Аутоматски ажурирај додатке
    .accesskey = А

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Све додатке аутоматски ажурирај
    .accesskey = С
addon-updates-reset-updates-to-manual = Све додатке мануелно надогради
    .accesskey = м

## Status messages displayed when updating add-ons

addon-updates-updating = Ажурирам додатке
addon-updates-installed = Ваши додаци су ажурирани.
addon-updates-none-found = Нема ажурирања
addon-updates-manual-updates-found = Погледај доступна ажурирања

## Add-on install/debug strings for page options menu

addon-install-from-file = Инсталирај додатак из датотеке…
    .accesskey = И
addon-install-from-file-dialog-title = Изаберите додатке за инсталирање
addon-install-from-file-filter-name = Додаци
addon-open-about-debugging = Испитај додатке
    .accesskey = д

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Управљај пречицама екстензија
    .accesskey = с

shortcuts-no-addons = Немате омогућених проширења.
shortcuts-no-commands = Следећа проширења немају пречице:
shortcuts-input =
    .placeholder = Унесите пречицу

shortcuts-browserAction2 = Активирајте тастер на траци са алатима
shortcuts-pageAction = Активирајте радњу странице
shortcuts-sidebarAction = Мењајте бочну траку

shortcuts-modifier-mac = Укључите Ctrl, Alt, или ⌘
shortcuts-modifier-other = Укључите Ctrl или Alt
shortcuts-invalid = Неважећа комбинација
shortcuts-letter = Унесите слово
shortcuts-system = Пречица { -brand-short-name } се не може премостити

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Дупликат пречице

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } се користи као пречица у више од једног случаја. Дупликати пречица могу проузроковати неочекивано понашање.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = { $addon } је већ у употреби

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Прикажи { $numberToShow } више
        [few] Прикажи { $numberToShow } више
       *[other] Прикажи { $numberToShow } више
    }

shortcuts-card-collapse-button = Прикажи мање

header-back-button =
    .title = Иди назад

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro = Проширења и теме су као апликације за ваш прегледач и омогућавају вам да заштитите лозинке, преузмете видео записе, пронађете понуде, блокирате досадне огласе, промените изглед претраживача и још много тога. Ове мале софтверске програме често развија трећа страна. Ево избора које { -brand-product-name } <a data-l10n-name="learn-more-trigger">препоручује</a> за изузетну безбедност, перформансе и употребљивост.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations = Неке од ових препорука су персонализоване. Оне се заснивају на другим проширењима која сте инсталирали, поставкама профила и статистици употребе.
discopane-notice-learn-more = Сазнајте више

privacy-policy = Политика приватности

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = од стране <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Корисници: { $dailyUsers }
install-extension-button = Додај у { -brand-product-name }
install-theme-button = Инсталирај тему
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Управљај
find-more-addons = Пронађи више додатака

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Више опција

## Add-on actions

report-addon-button = Пријави
remove-addon-button = Уклони
# The link will always be shown after the other text.
remove-addon-disabled-button = Не може се уклонити. <a data-l10n-name="link">Зашто?</a>
disable-addon-button = Онемогући
enable-addon-button = Омогући
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Омогући
preferences-addon-button =
    { PLATFORM() ->
        [windows] Подешавања
       *[other] Поставке
    }
details-addon-button = Детаљи
release-notes-addon-button = Белешке о издању
permissions-addon-button = Дозволе

extension-enabled-heading = Омогућено
extension-disabled-heading = Онемогућено

theme-enabled-heading = Омогућено
theme-disabled-heading = Онемогућено

plugin-enabled-heading = Омогућено
plugin-disabled-heading = Онемогућено

dictionary-enabled-heading = Омогућено
dictionary-disabled-heading = Онемогућено

locale-enabled-heading = Омогућено
locale-disabled-heading = Онемогућено

ask-to-activate-button = Питај за активирање
always-activate-button = Увек активирај
never-activate-button = Никад не активирај

addon-detail-author-label = Аутор
addon-detail-version-label = Издање
addon-detail-last-updated-label = Последњи пут ажурирано
addon-detail-homepage-label = Матична страница
addon-detail-rating-label = Оцена

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Оцењено је { NUMBER($rating, maximumFractionDigits: 1) } од 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (искључено)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } рецензија
        [few] { $numberOfReviews } рецензије
       *[other] { $numberOfReviews } рецензија
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = Додатак <span data-l10n-name="addon-name">{ $addon }</span> је уклоњен.
pending-uninstall-undo-button = Опозови

addon-detail-updates-label = Дозволи аутоматско ажурирање
addon-detail-updates-radio-default = Подразумевано
addon-detail-updates-radio-on = Укључено
addon-detail-updates-radio-off = Искључено
addon-detail-update-check-label = Провери ажурирања
install-update-button = Ажурирај

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Дозвољено у приватним прозорима
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Када је дозвољено, проширење ће имати приступ вашим активностима на мрежи у приватном прегледавању. <a data-l10n-name="learn-more">Сазнај више</a>
addon-detail-private-browsing-allow = Дозволи
addon-detail-private-browsing-disallow = Не дозволи

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } препоручује само проширења која задовољавају наше стандарде сигурности и перформанси
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Доступна ажурирања
recent-updates-heading = Недавна ажурирања

release-notes-loading = Учитава се...
release-notes-error = Нажалост, дошло је до грешке при учитавању напомена о издању.

addon-permissions-empty = Ово проширење не захтева никакве дозволе

recommended-extensions-heading = Препоручена проширења
recommended-themes-heading = Препоручене теме

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Креативни сте? <a data-l10n-name="link">Направите своју сопствену тему уз помоћ Firefox Color-а.</a>

## Page headings

extension-heading = Управљајте вашим екстензијама
theme-heading = Управљајте вашим темама
plugin-heading = Управљајте вашим прикључцима
dictionary-heading = Управљајте вашим речницима
locale-heading = Управљајте вашим језицима
updates-heading = Управљајте вашим ажурирањима
discover-heading = Персонализујте ваш { -brand-short-name }
shortcuts-heading = Управљај пречицама екстензија

default-heading-search-label = Пронађите још додатака
addons-heading-search-input =
    .placeholder = Претражи сајт addons.mozilla.org

addon-page-options-button =
    .title = Алатке за све додатке
