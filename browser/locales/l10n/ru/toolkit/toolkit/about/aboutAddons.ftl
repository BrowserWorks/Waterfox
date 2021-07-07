# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-page-title = Управление дополнениями
search-header =
    .placeholder = Поиск на addons.mozilla.org
    .searchbuttonlabel = Поиск
search-header-shortcut =
    .key = f
list-empty-get-extensions-message = Загрузите расширения и темы на <a data-l10n-name="get-extensions">{ $domain }</a>
list-empty-installed =
    .value = У вас не установлено ни одного дополнения данного типа
list-empty-available-updates =
    .value = Обновлений не найдено
list-empty-recent-updates =
    .value = В последнее время вы не обновляли никаких дополнений
list-empty-find-updates =
    .label = Проверить наличие обновлений
list-empty-button =
    .label = Узнать больше о дополнениях
help-button = Поддержка дополнений
sidebar-help-button-title =
    .title = Поддержка дополнений
addons-settings-button = Настройки { -brand-short-name }
sidebar-settings-button-title =
    .title = Настройки { -brand-short-name }
show-unsigned-extensions-button =
    .label = Некоторые расширения не могут быть проверены
show-all-extensions-button =
    .label = Показать все расширения
detail-version =
    .label = Версия
detail-last-updated =
    .label = Последнее обновление
detail-contributions-description = Разработчик этого дополнения просит вас помочь поддержать его дальнейшее развитие, внеся небольшое пожертвование.
detail-contributions-button = Поддержать
    .title = Внести вклад в разработку этого дополнения
    .accesskey = ж
detail-update-type =
    .value = Автоматическое обновление
detail-update-default =
    .label = По умолчанию
    .tooltiptext = Автоматически устанавливать обновления только если это настройка по умолчанию
detail-update-automatic =
    .label = Включено
    .tooltiptext = Устанавливать обновления автоматически
detail-update-manual =
    .label = Отключено
    .tooltiptext = Не устанавливать обновления автоматически
# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Запуск в приватных окнах
# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Не разрешено в приватных окнах
detail-private-disallowed-description2 = Это расширение не работает в приватном режиме. <a data-l10n-name="learn-more">Подробнее</a>
# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Требует доступа к приватным окнам
detail-private-required-description2 = Это расширение имеет доступ к вашей активности в Интернете в приватном режиме. <a data-l10n-name="learn-more">Подробнее</a>
detail-private-browsing-on =
    .label = Разрешить
    .tooltiptext = Включать в приватном режиме
detail-private-browsing-off =
    .label = Не разрешать
    .tooltiptext = Отключать в приватном режиме
detail-home =
    .label = Домашняя страница
detail-home-value =
    .value = { detail-home.label }
detail-repository =
    .label = Профиль дополнения
detail-repository-value =
    .value = { detail-repository.label }
detail-check-for-updates =
    .label = Проверить наличие обновлений
    .accesskey = в
    .tooltiptext = Проверить наличие обновлений для этого дополнения
detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Настройки
           *[other] Настройки
        }
    .accesskey =
        { PLATFORM() ->
            [windows] с
           *[other] с
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Изменить настройки этого дополнения
           *[other] Изменить настройки этого дополнения
        }
detail-rating =
    .value = Рейтинг
addon-restart-now =
    .label = Перезапустить сейчас
disabled-unsigned-heading =
    .value = Некоторые дополнения были отключены
disabled-unsigned-description = Работа следующих дополнений в { -brand-short-name } не была проверена. Вы можете <label data-l10n-name="find-addons">найти им замену</label> или попросить разработчика произвести их проверку.
disabled-unsigned-learn-more = Узнайте больше о наших усилиях по обеспечению вашей безопасности в Интернете.
disabled-unsigned-devinfo = Разработчики, заинтересованные в проверке своих дополнений, могут прочесть наше <label data-l10n-name="learn-more">руководство</label>.
plugin-deprecation-description = Что-то отсутствует? { -brand-short-name } больше не поддерживает некоторые плагины. <label data-l10n-name="learn-more">Подробнее.</label>
legacy-warning-show-legacy = Показать устаревшие расширения
legacy-extensions =
    .value = Устаревшие расширения
legacy-extensions-description = Эти расширения не соответствуют текущим стандартам { -brand-short-name }, поэтому они были отключены. <label data-l10n-name="legacy-learn-more">Узнайте об изменениях в дополнениях</label>
private-browsing-description2 =
    { -brand-short-name } изменяет работу расширений в приватном режиме. Любые новые расширения, которые вы добавите в
    { -brand-short-name }, не будут запускаться по умолчанию в приватных окнах. Если вы не разрешите этого в настройках,
    расширение не будет работать в приватном режиме и не будет иметь доступа к вашей активности в Интернете.
    Мы внесли это изменение, чтобы сделать ваш приватный режим по-настоящему приватным.
    <label data-l10n-name="private-browsing-learn-more">Узнайте, как управлять настройками расширений.</label>
addon-category-discover = Рекомендации
addon-category-discover-title =
    .title = Рекомендации
addon-category-extension = Расширения
addon-category-extension-title =
    .title = Расширения
addon-category-theme = Темы
addon-category-theme-title =
    .title = Темы
addon-category-plugin = Плагины
addon-category-plugin-title =
    .title = Плагины
addon-category-dictionary = Словари
addon-category-dictionary-title =
    .title = Словари
addon-category-locale = Языки
addon-category-locale-title =
    .title = Языки
addon-category-available-updates = Доступные обновления
addon-category-available-updates-title =
    .title = Доступные обновления
addon-category-recent-updates = Недавние обновления
addon-category-recent-updates-title =
    .title = Недавние обновления

## These are global warnings

extensions-warning-safe-mode = В безопасном режиме все дополнения отключены.
extensions-warning-check-compatibility = Проверка совместимости дополнений отключена. У вас могут иметься несовместимые дополнения.
extensions-warning-check-compatibility-button = Включить
    .title = Включить проверку совместимости дополнений
extensions-warning-update-security = Проверка безопасного обновления дополнений отключена. Обновления могут поставить вас под угрозу.
extensions-warning-update-security-button = Включить
    .title = Включить проверку безопасного обновления дополнений

## Strings connected to add-on updates

addon-updates-check-for-updates = Проверить наличие обновлений
    .accesskey = о
addon-updates-view-updates = Показать недавние обновления
    .accesskey = к

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Автоматически обновлять дополнения
    .accesskey = в

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Установить для всех дополнений режим автоматического обновления
    .accesskey = с
addon-updates-reset-updates-to-manual = Установить для всех дополнений режим ручного обновления
    .accesskey = с

## Status messages displayed when updating add-ons

addon-updates-updating = Обновление дополнений
addon-updates-installed = Ваши дополнения были обновлены.
addon-updates-none-found = Обновлений не найдено
addon-updates-manual-updates-found = Показать доступные обновления

## Add-on install/debug strings for page options menu

addon-install-from-file = Установить дополнение из файла…
    .accesskey = а
addon-install-from-file-dialog-title = Выберите дополнение для установки
addon-install-from-file-filter-name = Дополнения
addon-open-about-debugging = Отладка дополнений
    .accesskey = л

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Управление горячими клавишами расширений
    .accesskey = п
shortcuts-no-addons = У вас не включено ни одного расширения.
shortcuts-no-commands = У следующих расширений нет горячих клавиш:
shortcuts-input =
    .placeholder = Введите горячую клавишу
shortcuts-browserAction2 = Активировать кнопку панели инструментов
shortcuts-pageAction = Активировать действие на странице
shortcuts-sidebarAction = Показать/скрыть боковую панель
shortcuts-modifier-mac = Добавьте Ctrl, Alt или ⌘
shortcuts-modifier-other = Добавьте Ctrl или Alt
shortcuts-invalid = Неверная комбинация
shortcuts-letter = Введите букву
shortcuts-system = Нельзя переопределить горячую клавишу { -brand-short-name }
# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Дублирующееся сочетание клавиш
# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } используется более одного раза. Дублирующиеся сочетания клавиш могут вызвать неожиданное поведение.
# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = Уже используется { $addon }
shortcuts-card-expand-button =
    { $numberToShow ->
        [one] Показать ещё { $numberToShow }
        [few] Показать ещё { $numberToShow }
       *[many] Показать ещё { $numberToShow }
    }
shortcuts-card-collapse-button = Показать меньше
header-back-button =
    .title = Вернуться назад

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Расширения и темы — это как приложения для вашего браузера, они позволяют вам
    защищать пароли, загружать видео, находить скидки, блокировать раздражающую рекламу, изменять
    внешний вид браузера и многое другое. Эти небольшие программные продукты
    обычно разрабатываются сторонними разработчиками. Вот подборка расширений и тем, <a data-l10n-name="learn-more-trigger">рекомендуемых</a> { -brand-product-name } за свою исключительную
    безопасность, производительность и функциональность.
# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Некоторые из этих рекомендаций персонализированы. Они основаны на других
    установленных вами расширениях, настройках профиля и статистике использования.
discopane-notice-learn-more = Подробнее
privacy-policy = Политика приватности
# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = от <a data-l10n-name="author">{ $author }</a>
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Пользователей: { $dailyUsers }
install-extension-button = Добавить в { -brand-product-name }
install-theme-button = Установить тему
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Управление
find-more-addons = Найти другие дополнения
find-more-themes = Найти другие темы
# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Другие настройки

## Add-on actions

report-addon-button = Пожаловаться
remove-addon-button = Удалить
# The link will always be shown after the other text.
remove-addon-disabled-button = Нельзя удалить <a data-l10n-name="link">Почему?</a>
disable-addon-button = Отключить
enable-addon-button = Включить
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Включить
preferences-addon-button =
    { PLATFORM() ->
        [windows] Настройки
       *[other] Настройки
    }
details-addon-button = Подробности
release-notes-addon-button = Примечания к выпуску
permissions-addon-button = Разрешения
extension-enabled-heading = Включены
extension-disabled-heading = Отключены
theme-enabled-heading = Включены
theme-disabled-heading = Отключены
theme-monochromatic-heading = Расцветки
theme-monochromatic-subheading = Яркие новые расцветки от { -brand-product-name }. Доступны в течение ограниченного времени.
plugin-enabled-heading = Включены
plugin-disabled-heading = Отключены
dictionary-enabled-heading = Включены
dictionary-disabled-heading = Отключены
locale-enabled-heading = Включены
locale-disabled-heading = Отключены
always-activate-button = Всегда включать
never-activate-button = Никогда не включать
addon-detail-author-label = Автор
addon-detail-version-label = Версия
addon-detail-last-updated-label = Последнее обновление
addon-detail-homepage-label = Домашняя страница
addon-detail-rating-label = Рейтинг
# Message for add-ons with a staged pending update.
install-postponed-message = Это расширение будет обновлено после перезапуска { -brand-short-name }.
install-postponed-button = Обновить сейчас
# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Оценено на { NUMBER($rating, maximumFractionDigits: 1) } из 5
# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (отключено)
# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
        [one] { $numberOfReviews } отзыв
        [few] { $numberOfReviews } отзыва
       *[many] { $numberOfReviews } отзывов
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> было удалено.
pending-uninstall-undo-button = Отмена
addon-detail-updates-label = Разрешить автообновления
addon-detail-updates-radio-default = По умолчанию
addon-detail-updates-radio-on = Включено
addon-detail-updates-radio-off = Отключено
addon-detail-update-check-label = Проверить наличие обновлений
install-update-button = Обновить
# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Разрешено в приватных окнах
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Когда разрешено, расширение будет иметь доступ к вашей активности в Интернете в приватном режиме. <a data-l10n-name="learn-more">Подробнее</a>
addon-detail-private-browsing-allow = Разрешить
addon-detail-private-browsing-disallow = Не разрешать

## This is the tooltip text for the recommended badges for an extension in about:addons. The
## badge is a small icon displayed next to an extension when it is recommended on AMO.

addon-badge-recommended2 =
    .title = { -brand-product-name } рекомендует только те расширения, которые соответствуют нашим стандартам по безопасности и производительности
    .aria-label = { addon-badge-recommended2.title }
# We hard code "Waterfox" in the string below because the extensions are built
# by Waterfox and we don't want forks to display "by Fork".
addon-badge-line3 =
    .title = Официальное расширение, созданное Waterfox. Соответствует стандартам безопасности и производительности.
    .aria-label = { addon-badge-line3.title }
addon-badge-verified2 =
    .title = Это расширение было проверено на соответствие нашим стандартам безопасности и производительности
    .aria-label = { addon-badge-verified2.title }

##

available-updates-heading = Доступные обновления
recent-updates-heading = Недавно обновлённые
release-notes-loading = Загрузка…
release-notes-error = При загрузке примечаний к выпуску возникли проблемы.
addon-permissions-empty = Это расширение не требует дополнительных разрешений
addon-permissions-required = Необходимые разрешения для основных функций:
addon-permissions-optional = Необязательные разрешения для дополнительных функций:
addon-permissions-learnmore = Узнать больше о разрешениях
recommended-extensions-heading = Рекомендуемые расширения
recommended-themes-heading = Рекомендуемые темы
# A recommendation for the Waterfox Color theme shown at the bottom of the theme
# list view. The "Waterfox Color" name itself should not be translated.
recommended-theme-1 = Чувствуете прилив вдохновения? <a data-l10n-name="link">Создайте свою собственную тему с помощью Waterfox Color.</a>

## Page headings

extension-heading = Управление моими расширениями
theme-heading = Управление моими темами
plugin-heading = Управление моими плагинами
dictionary-heading = Управление моими словарями
locale-heading = Управление моими языками
updates-heading = Управление моими обновлениями
discover-heading = Сделайте { -brand-short-name } своим
shortcuts-heading = Управление горячими клавишами расширений
default-heading-search-label = Найти больше дополнений
addons-heading-search-input =
    .placeholder = Поиск на addons.mozilla.org
addon-page-options-button =
    .title = Инструменты для всех дополнений
