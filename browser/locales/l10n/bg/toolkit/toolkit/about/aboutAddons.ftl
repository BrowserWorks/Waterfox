# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Управление на добавките

addons-page-title = Управление на добавките

search-header =
    .placeholder = търсене в addons.mozilla.org
    .searchbuttonlabel = Търсене

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Няма инсталирани добавки от този вид

list-empty-available-updates =
    .value = Не са открити обновявания

list-empty-recent-updates =
    .value = Скоро не сте обновявали никоя добавка

list-empty-find-updates =
    .label = Проверка за обновяване

list-empty-button =
    .label = Научете повече за добавките

help-button = Поддръжка

sidebar-help-button-title =
    .title = Поддръжка

preferences =
    { PLATFORM() ->
        [windows] Настройки на { -brand-short-name }
       *[other] Настройки на { -brand-short-name }
    }

sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] Настройки на { -brand-short-name }
           *[other] Настройки на { -brand-short-name }
        }

show-unsigned-extensions-button =
    .label = Някои разширения не можаха да бъдат проверени

show-all-extensions-button =
    .label = Показване на всички разширения

cmd-show-details =
    .label = Повече информация
    .accesskey = П

cmd-find-updates =
    .label = Намиране на обновявания
    .accesskey = Н

cmd-preferences =
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

cmd-enable-theme =
    .label = Слагане на тема
    .accesskey = С

cmd-disable-theme =
    .label = Спиране на сложената тема
    .accesskey = л

cmd-install-addon =
    .label = Инсталиране
    .accesskey = И

cmd-contribute =
    .label = Допринасяне
    .accesskey = Д
    .tooltiptext = Допринасяне за развитието на добавката

detail-version =
    .label = Версия

detail-last-updated =
    .label = Последно обновяване

detail-contributions-description = Разработчикът на добавката ви приканва да допринесете за бъдещото ѝ развитие, като направите скромно дарение.

detail-contributions-button = Допринасяне
    .title = Допринасяне за развитието на добавката
    .accesskey = Д

detail-update-type =
    .value = Автоматично обновяване

detail-update-default =
    .label = Стандартно
    .tooltiptext = Автоматично инсталиране на обновявания само ако е стандартно

detail-update-automatic =
    .label = Включено
    .tooltiptext = Автоматично инсталиране на обновявания

detail-update-manual =
    .label = Изключено
    .tooltiptext = Без автоматично инсталиране на обновявания

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Работa в поверителни прозорци

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Не позволено в поверителни прозорци

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Изисква достъп до поверителни прозорци

detail-private-browsing-on =
    .label = Разрешаване
    .tooltiptext = Включване при поверително разглеждане

detail-private-browsing-off =
    .label = Забраняване
    .tooltiptext = Изключване при поверително разглеждане

detail-home =
    .label = Страница

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Профил на добавка

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Проверка за обновяване
    .accesskey = П
    .tooltiptext = Проверка за обновяване на тази добавка

detail-show-preferences =
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
    .tooltiptext =
        { PLATFORM() ->
            [windows] Промяна на настройките на тази добавка
           *[other] Сменяне на настройките на тази добавка
        }

detail-rating =
    .value = Оценка

addon-restart-now =
    .label = Рестартиране

disabled-unsigned-heading =
    .value = Някои добавки бяха изключени

disabled-unsigned-description = Следните добавки не са проверени, за да могат да се използват от { -brand-short-name }. Можете <label data-l10n-name="find-addons">да намерите заместители</label> или да поискате от разработчиците тяхната добавка да премине проверка.

disabled-unsigned-learn-more = Научете повече за нашите усилия да поддържаме безопасността ви, докато сте онлайн.

disabled-unsigned-devinfo = Разработчиците, интересуващи се от преминаване на проверка за техните добавки, могат да прочетат повече в нашето <label data-l10n-name="learn-more">ръководство</label>.

plugin-deprecation-description = Липсва ли нещо? Някои приставки вече не се поддържат от { -brand-short-name }. <label data-l10n-name="learn-more">Научете повече</label>

legacy-warning-show-legacy = Показване на остарелите разширения

legacy-extensions =
    .value = Остарели добавки

legacy-extensions-description = Тези разширения не отговарят на текущите стандарти на { -brand-short-name } и затова са изключени. <label data-l10n-name="legacy-learn-more">Научете повече за промените при добавките</label>

private-browsing-description2 =
    { -brand-short-name } променя начина на работа на разширенията в поверителни прозорци. Всяко ново разширение, което добавите в { -brand-short-name } няма да работи по подразбиране в поверителен прозорец, освен ако вие не промените неговите настройки. Направихме тази промяна за да запазим поверителното ви разглеждане наистина поверително.
    <label data-l10n-name="private-browsing-learn-more">Научете повече как да управлявате разширенията</label>

addon-category-discover = Препоръки
addon-category-discover-title =
    .title = Препоръки
addon-category-extension = Разширения
addon-category-extension-title =
    .title = Разширения
addon-category-theme = Теми
addon-category-theme-title =
    .title = Теми
addon-category-plugin = Приставки
addon-category-plugin-title =
    .title = Приставки
addon-category-dictionary = Речници
addon-category-dictionary-title =
    .title = Речници
addon-category-locale = Езици
addon-category-locale-title =
    .title = Езици
addon-category-available-updates = Налични обновявания
addon-category-available-updates-title =
    .title = Налични обновявания
addon-category-recent-updates = Скорошни обновявания
addon-category-recent-updates-title =
    .title = Скорошни обновявания

## These are global warnings

extensions-warning-safe-mode = Всички добавки са изключени от Надеждния режим.
extensions-warning-check-compatibility = Проверката за съвместимост на добавките е изключена. Възможно е да имате несъвместими добавки.
extensions-warning-check-compatibility-button = Включване
    .title = Включване на проверка за съвместимост на добавки
extensions-warning-update-security = Проверката за безопасност на обновяването на добавки е изключена. Възможно е системата да се компрометира от добавки.
extensions-warning-update-security-button = Включване
    .title = Включване на проверка за безопасност на обновяването на добавки


## Strings connected to add-on updates

addon-updates-check-for-updates = Проверка за обновяване
    .accesskey = П
addon-updates-view-updates = Последни обновявания
    .accesskey = о

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Автоматично обновяване на добавките
    .accesskey = А

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Нулиране на всички добавки, за да бъдат автоматично обновявани
    .accesskey = Н
addon-updates-reset-updates-to-manual = Нулиране на всички добавки, за да бъдат ръчно обновявани
    .accesskey = у

## Status messages displayed when updating add-ons

addon-updates-updating = Обновяване на добавките
addon-updates-installed = Добавките са обновени.
addon-updates-none-found = Не са открити обновявания
addon-updates-manual-updates-found = Показване на наличните обновявания

## Add-on install/debug strings for page options menu

addon-install-from-file = Инсталиране на добавка от файл…
    .accesskey = И
addon-install-from-file-dialog-title = Изберете добавка за инсталиране
addon-install-from-file-filter-name = Добавки
addon-open-about-debugging = Дебъгване на добавки
    .accesskey = Д

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Управление на клавишните комбинации на разширението
    .accesskey = к

shortcuts-no-addons = Нямате включени разширения.
shortcuts-no-commands = Следните разширения нямат клавишни комбинации:
shortcuts-input =
    .placeholder = Изберете комбинация

shortcuts-pageAction = Изпълняване на действието със страницата
shortcuts-sidebarAction = Превключване на страничната лента

shortcuts-modifier-mac = Включване на Ctrl, Alt, или ⌘
shortcuts-modifier-other = Включване на Ctrl или Alt
shortcuts-invalid = Недействителна комбинация
shortcuts-letter = Въведете буква
shortcuts-system = Не може да презапишете клавишна комбинация на { -brand-short-name }

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Вече се използва от { $addon }

shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Показване на още { $numberToShow }
       *[other] Показване на още { $numberToShow }
    }

shortcuts-card-collapse-button = По-малко

header-back-button =
    .title = Назад

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Разширенията и темите са като приложения за вашия четец и ви дават
    възможност за защита на пароли, изтегляне на видеоклипове,
    намиране на изгодни оферти, блокиране на досадни реклами, промяна
    на изгледа на четеца и много други. Тези малки софтуерни приложения
    често се разработват от трети страни. Ето избраните, които { -brand-product-name }
    <a data-l10n-name="learn-more-trigger">препоръчва</a> за изключителна
    сигурност, производителност и възможности.

discopane-notice-learn-more = Научете повече

privacy-policy = Политика за поверителност

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = от <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Потребители: { $dailyUsers }
install-extension-button = Добавяне към { -brand-product-name }
install-theme-button = Инсталиране на тема
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Управление
find-more-addons = Повече добавки

## Add-on actions

report-addon-button = Докладване
remove-addon-button = Премахване
disable-addon-button = Изключване
enable-addon-button = Включване
preferences-addon-button =
    { PLATFORM() ->
        [windows] Настройки
       *[other] Настройки
    }
details-addon-button = Подробности
release-notes-addon-button = Бележки към изданието
permissions-addon-button = Права

always-activate-button = Винаги включено
never-activate-button = Винаги изключено

addon-detail-author-label = Автор
addon-detail-version-label = Издание
addon-detail-last-updated-label = Последно обновяване
addon-detail-homepage-label = Страница
addon-detail-rating-label = Оценка

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Оценено на { NUMBER($rating, maximumFractionDigits: 1) } от 5

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (изключено)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } отзив
       *[other] { $numberOfReviews } отзива
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> е премахнато.
pending-uninstall-undo-button = Отменяне

addon-detail-updates-label = Автоматично обновяване
addon-detail-updates-radio-default = Стандартно
addon-detail-updates-radio-on = Включено
addon-detail-updates-radio-off = Изключено
addon-detail-update-check-label = Проверка за обновяване
install-update-button = Обновяване

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Разрешено в поверителни прозорци
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Когато е разрешено, разширението ще има достъп до дейностите ви, докато разглеждате поверително. <a data-l10n-name="learn-more">Научете повече</a>
addon-detail-private-browsing-allow = Разрешаване
addon-detail-private-browsing-disallow = Забраняване

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } препоръчва само разширения, които отговарят на нашите стандарти за сигурност и производителност
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Налични обновявания
recent-updates-heading = Последни обновявания

release-notes-loading = Зареждане…
release-notes-error = За съжаление, зареждането на бележките към изданието е неуспешно.

addon-permissions-empty = Разширението не изисква никакви права

recommended-extensions-heading = Препоръчани разширения
recommended-themes-heading = Препоръчани теми

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Чувствате се креативни? <a data-l10n-name="link"> Създайте своя собствена тема с Firefox Color.</a>

## Page headings

extension-heading = Управление на добавките
theme-heading = Управление на теми
plugin-heading = Управление на приставки
dictionary-heading = Управление на речници
locale-heading = Управление на езици
discover-heading = Персонализирайте вашия { -brand-short-name }
shortcuts-heading = Управление на клавишните комбинации на разширението

default-heading-search-label = Намерете още добавки
addons-heading-search-input =
    .placeholder = търсене в addons.mozilla.org

addon-page-options-button =
    .title = Инструменти за всички добавки
