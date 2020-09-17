# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

do-not-track-description = Указване на сайтовете, че не желаете да бъдете проследявани
do-not-track-learn-more = Научете повече
do-not-track-option-default-content-blocking-known =
    .label = Само когато { -brand-short-name } е настроен да спира проследяването
do-not-track-option-always =
    .label = Винаги

pref-page-title =
    { PLATFORM() ->
        [windows] Настройки
       *[other] Настройки
    }

# This is used to determine the width of the search field in about:preferences,
# in order to make the entire placeholder string visible
#
# Please keep the placeholder string short to avoid truncation.
#
# Notice: The value of the `.style` attribute is a CSS string, and the `width`
# is the name of the CSS property. It is intended only to adjust the element's width.
# Do not translate.
search-input-box =
    .style = width: 15.4em
    .placeholder =
        { PLATFORM() ->
            [windows] Търсене в настройките
           *[other] Търсене в настройките
        }

managed-notice = Мрежовият четец се управлява от вашето ведомство.

pane-general-title = Основни
category-general =
    .tooltiptext = { pane-general-title }

pane-home-title = Начална страница
category-home =
    .tooltiptext = { pane-home-title }

pane-search-title = Търсене
category-search =
    .tooltiptext = { pane-search-title }

pane-privacy-title = Поверителност и защита
category-privacy =
    .tooltiptext = { pane-privacy-title }

pane-sync-title2 = { -sync-brand-short-name }
category-sync2 =
    .tooltiptext = { pane-sync-title2 }

help-button-label = Поддръжка на { -brand-short-name }
addons-button-label = Разширения и теми

focus-search =
    .key = f

close-button =
    .aria-label = Затваряне

## Browser Restart Dialog

feature-enable-requires-restart = Приложението { -brand-short-name } трябва да бъде рестартирано, за да бъде включена тази възможност.
feature-disable-requires-restart = Приложението { -brand-short-name } трябва да бъде рестартирано, за да бъде изключена тази възможност.
should-restart-title = Рестартиране на { -brand-short-name }
should-restart-ok = Рестартиране на { -brand-short-name }
cancel-no-restart-button = Отказ
restart-later = Рестартиране по-късно

## Extension Control Notifications
##
## These strings are used to inform the user
## about changes made by extensions to browser settings.
##
## <img data-l10n-name="icon"/> is going to be replaced by the extension icon.
##
## Variables:
##   $name (String): name of the extension

# This string is shown to notify the user that their home page
# is being controlled by an extension.
extension-controlled-homepage-override = Разширението „<img data-l10n-name="icon"/> { $name }“ управлява началната страница.

# This string is shown to notify the user that their new tab page
# is being controlled by an extension.
extension-controlled-new-tab-url = Разширението „<img data-l10n-name="icon"/> { $name }“ управлява страницата за нов раздел.

# This string is shown to notify the user that their notifications permission
# is being controlled by an extension.
extension-controlled-web-notifications = Разширението „<img data-l10n-name="icon"/> { $name }“ управлява настройката.

# This string is shown to notify the user that the default search engine
# is being controlled by an extension.
extension-controlled-default-search = Разширението „<img data-l10n-name="icon"/> { $name }“ е задало стандартната търсеща машина.

# This string is shown to notify the user that Container Tabs
# are being enabled by an extension.
extension-controlled-privacy-containers = Разширението „<img data-l10n-name="icon"/> { $name }“ има изискване за изолирани раздели.

# This string is shown to notify the user that their content blocking "All Detected Trackers"
# preferences are being controlled by an extension.
extension-controlled-websites-content-blocking-all-trackers = Разширението „<img data-l10n-name="icon"/> { $name }“ управлява настройката.

# This string is shown to notify the user that their proxy configuration preferences
# are being controlled by an extension.
extension-controlled-proxy-config = Разширението „<img data-l10n-name="icon"/> { $name }“ управлява как { -brand-short-name } се свързва с интернет.

# This string is shown after the user disables an extension to notify the user
# how to enable an extension that they disabled.
#
# <img data-l10n-name="addons-icon"/> will be replaced with Add-ons icon
# <img data-l10n-name="menu-icon"/> will be replaced with Menu icon
extension-controlled-enable = Отворете <img data-l10n-name="addons-icon"/> Добавки в менюто <img data-l10n-name="menu-icon"/>, за да включите разширението.

## Preferences UI Search Results

search-results-header = Резултати

# `<span data-l10n-name="query"></span>` will be replaced by the search term.
search-results-empty-message =
    { PLATFORM() ->
        [windows] Съжаляваме! В настройките няма резултати за „<span data-l10n-name="query"></span>“.
       *[other] Съжаляваме! В настройките няма резултати за „<span data-l10n-name="query"></span>“.
    }

search-results-help-link = Имате нужда от помощ? Посетете <a data-l10n-name="url">поддръжката за { -brand-short-name }</a>

## General Section

startup-header = Начална страница

# { -brand-short-name } will be 'Firefox Developer Edition',
# since this setting is only exposed in Firefox Developer Edition
separate-profile-mode =
    .label = Разрешаване на { -brand-short-name } и Firefox да работят едновременно
use-firefox-sync = Съвет: Ще бъдат използвани отделни профили. Използвайте { -sync-brand-short-name }, за да споделяте данни между тях.
get-started-not-logged-in = Вписване в { -sync-brand-short-name }…
get-started-configured = Настройки на { -sync-brand-short-name }

always-check-default =
    .label = Проверяване дали { -brand-short-name } е стандартният четец
    .accesskey = ч

is-default = { -brand-short-name } е вашият стандартен четец
is-not-default = { -brand-short-name } не е вашият стандартен четец

set-as-my-default-browser =
    .label = Задаване като стандартен…
    .accesskey = с

startup-restore-previous-session =
    .label = Възстановяване на предишната сесия
    .accesskey = с

startup-restore-warn-on-quit =
    .label = Предупреждаване при затваряне на четеца

disable-extension =
    .label = Изключване на разширението

tabs-group-header = Раздели

ctrl-tab-recently-used-order =
    .label = Ctrl+Tab обикаля разделите в реда на използване
    .accesskey = б

open-new-link-as-tabs =
    .label = Отваряне на препратките в раздели вместо в нови прозорци
    .accesskey = р

warn-on-close-multiple-tabs =
    .label = Предупреждаване при затваряне на няколко раздела
    .accesskey = п

warn-on-open-many-tabs =
    .label = Предупреждаване, ако отваряне на няколко раздела може да забави { -brand-short-name }
    .accesskey = а

switch-links-to-new-tabs =
    .label = При отваряне на препратка в раздел той става активен
    .accesskey = н

show-tabs-in-taskbar =
    .label = Преглед на разделите в лентата със задачите на Windows
    .accesskey = с

browser-containers-enabled =
    .label = Включване на изолатора на раздели
    .accesskey = к

browser-containers-learn-more = Научете повече

browser-containers-settings =
    .label = Настройки…
    .accesskey = а

containers-disable-alert-title = Затваряне на всички изолирани раздели?
containers-disable-alert-desc =
    { $tabCount ->
        [one] Ако сега изключите Изолирани раздели { $tabCount } изолиран раздел ще бъде затворен. Желаете ли да изключите изолираните раздели?
       *[other] Ако сега изключите Изолирани раздели { $tabCount } изолирани раздела ще бъде затворени. Желаете ли да изключите изолираните раздели?
    }

containers-disable-alert-ok-button =
    { $tabCount ->
        [one] Затваряне на { $tabCount } изолиран раздел
       *[other] Затваряне на { $tabCount } изолирани раздела
    }
containers-disable-alert-cancel-button = Оставяне включено

containers-remove-alert-title = Премахване на изолатора?

# Variables:
#   $count (Number) - Number of tabs that will be closed.
containers-remove-alert-msg =
    { $count ->
        [one] Ако сега премахнете този изолатор, { $count } раздел ще бъде затворен. Наистина ли желаете да премахнете този изолатор?
       *[other] Ако сега премахнете този изолатор, { $count } негови раздела ще бъдат затворени. Наистина ли желаете да премахнете този изолатор?
    }

containers-remove-ok-button = Премахване
containers-remove-cancel-button = Запазване


## General Section - Language & Appearance

language-and-appearance-header = Език и изглед

fonts-and-colors-header = Шрифтове и цветове

default-font = Стандартен шрифт
    .accesskey = С
default-font-size = Големина
    .accesskey = Г

advanced-fonts =
    .label = Разширени…
    .accesskey = Р

colors-settings =
    .label = Цветове…
    .accesskey = Ц

# Zoom is a noun, and the message is used as header for a group of options
preferences-zoom-header = Мащабиране

preferences-default-zoom = Мащабиране по подразбиране
    .accesskey = м

preferences-default-zoom-value =
    .label = { $percentage }%

preferences-zoom-text-only =
    .label = Само на текст
    .accesskey = т

language-header = Език

choose-language-description = Избор на език при показване на многоезични страници

choose-button =
    .label = Избиране…
    .accesskey = И

choose-browser-language-description = Изберете езиците, на които да бъдат показвани менютата, съобщенията и известията от { -brand-short-name }.
manage-browser-languages-button =
    .label = Допълнителни езици…
    .accesskey = з
confirm-browser-language-change-description = Рестартирайте { -brand-short-name }, за да бъдат приложени промените
confirm-browser-language-change-button = Прилагане и рестартиране

translate-web-pages =
    .label = Превеждане на съдържанието на страниците
    .accesskey = П

# The <img> element is replaced by the logo of the provider
# used to provide machine translations for web pages.
translate-attribution = Превод от <img data-l10n-name="logo"/>

translate-exceptions =
    .label = Изключения…
    .accesskey = з

check-user-spelling =
    .label = Проверяване на правописа при въвеждане
    .accesskey = в

## General Section - Files and Applications

files-and-applications-title = Файлове и приложения

download-header = Изтегляния

download-save-to =
    .label = Запазване на файловете в
    .accesskey = З

download-choose-folder =
    .label =
        { PLATFORM() ->
            [macos] Избиране…
           *[other] Разглеждане…
        }
    .accesskey =
        { PLATFORM() ->
            [macos] И
           *[other] Р
        }

download-always-ask-where =
    .label = Винаги да пита къде да бъдат запазвани файловете
    .accesskey = В

applications-header = Приложения

applications-description = Изберете как { -brand-short-name } управлява изтеглените файлове или приложенията, които използвате докато разглеждате.

applications-filter =
    .placeholder = Търсене на видове файлове и приложения

applications-type-column =
    .label = Вид на съдържанието
    .accesskey = В

applications-action-column =
    .label = Действие
    .accesskey = Д

# Variables:
#   $extension (String) - file extension (e.g .TXT)
applications-file-ending = файл { $extension }
applications-action-save =
    .label = Запазване на файла

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app =
    .label = Използване на { $app-name }

# Variables:
#   $app-name (String) - Name of an application (e.g Adobe Acrobat)
applications-use-app-default =
    .label = Използване на { $app-name } (по подразбиране)

applications-use-other =
    .label = Използване на друго…
applications-select-helper = Избиране на помощно приложение

applications-manage-app =
    .label = Подробности за приложение…
applications-always-ask =
    .label = Винаги да пита
applications-type-pdf = Преносим формат за документи (PDF)

# Variables:
#   $type (String) - the MIME type (e.g application/binary)
applications-type-pdf-with-type = { applications-type-pdf } ({ $type })

# Variables:
#   $type-description (String) - Description of the type (e.g "Portable Document Format")
#   $type (String) - the MIME type (e.g application/binary)
applications-type-description-with-type = { $type-description } ({ $type })

# Variables:
#   $extension (String) - file extension (e.g .TXT)
#   $type (String) - the MIME type (e.g application/binary)
applications-file-ending-with-type = { applications-file-ending } ({ $type })

# Variables:
#   $plugin-name (String) - Name of a plugin (e.g Adobe Flash)
applications-use-plugin-in =
    .label = Използване на { $plugin-name } (в { -brand-short-name })

## The strings in this group are used to populate
## selected label element based on the string from
## the selected menu item.

applications-use-plugin-in-label =
    .value = { applications-use-plugin-in.label }

applications-action-save-label =
    .value = { applications-action-save.label }

applications-use-app-label =
    .value = { applications-use-app.label }

applications-always-ask-label =
    .value = { applications-always-ask.label }

applications-use-app-default-label =
    .value = { applications-use-app-default.label }

applications-use-other-label =
    .value = { applications-use-other.label }

##

drm-content-header = Съдържание с цифрови права (DRM)

play-drm-content =
    .label = Изпълняване на съдържание под DRM
    .accesskey = И

play-drm-content-learn-more = Научете повече

update-application-title = Обновявания на { -brand-short-name }

update-application-description = За най-добра производителност, стабилност и защита поддържайте { -brand-short-name } обновен.

update-application-version = Издание { $version } <a data-l10n-name="learn-more">Новото в това издание</a>

update-history =
    .label = Хронология на обновяванията…
    .accesskey = х

update-application-allow-description = Разрешаване на { -brand-short-name }

update-application-auto =
    .label = Да инсталира обновявания автоматично (препоръчително)
    .accesskey = и

update-application-check-choose =
    .label = Да прави проверка за обновявания, но да дава избор дали да бъдат инсталирани
    .accesskey = п

update-application-manual =
    .label = Никога да не прави проверка за обновявания (непрепоръчително)
    .accesskey = Н

update-application-warning-cross-user-setting = Тази настройка ще бъде приложена към всички профили в Windows и всички профили на { -brand-short-name }, използващи тази инсталация на { -brand-short-name }.

update-application-use-service =
    .label = Използване на услуга във фонов режим за инсталиране на обновявания
    .accesskey = у

update-setting-write-failure-title = Грешка при запазване на настройките за обновяване

# Variables:
#   $path (String) - Path to the configuration file
# The newlines between the main text and the line containing the path is
# intentional so the path is easier to identify.
update-setting-write-failure-message =
    Поради възникнала грешка { -brand-short-name } не запази промяната.
    
    Обърнете внимание, че задаването на тази настройка за обновяване изисква права за запис във файла по-долу. Вие или системен администратор може да успеете да разрешите проблема, като предоставите на групата потребители пълни права над файла.
    
    Във файлa „{ $path }“ не може да бъде записвано.

update-in-progress-title = Обновяване е в процес на изпълнение

update-in-progress-message = Желаете ли { -brand-short-name } да продължи с обновяването?

update-in-progress-ok-button = &Отхвърляне
# Continue is the cancel button so pressing escape or using a platform standard
# method of closing the UI will not discard the update.
update-in-progress-cancel-button = &Продължаване

## General Section - Performance

performance-title = Производителност

performance-use-recommended-settings-checkbox =
    .label = Използване на препоръчителните настройки на производителността
    .accesskey = п

performance-use-recommended-settings-desc = Тези настройки са съобразени с хардуера и операционната система на компютъра.

performance-settings-learn-more = Научете повече

performance-allow-hw-accel =
    .label = Използване на хардуерно ускоряване, ако е налично
    .accesskey = х

performance-limit-content-process-option = Процеси за обработка на съдържание
    .accesskey = с

performance-limit-content-process-enabled-desc = Допълнителни процеси за обработка на съдържание може да подобрят производителността при използване на повече раздели за сметка на повече използвана памет.
performance-limit-content-process-blocked-desc = Променянето на броя на процесите за съдържание е възможно само при многопроцесен { -brand-short-name }. <a data-l10n-name="learn-more">Научете как да проверите дали многопроцесността е включена</a>

# Variables:
#   $num - default value of the `dom.ipc.processCount` pref.
performance-default-content-process-count =
    .label = { $num } (по подразбиране)

## General Section - Browsing

browsing-title = Разглеждане

browsing-use-autoscroll =
    .label = Автоматично плъзгане
    .accesskey = А

browsing-use-smooth-scrolling =
    .label = Плавно плъзгане
    .accesskey = л

browsing-use-onscreen-keyboard =
    .label = Показване на клавиатура за докосване, при необходимост
    .accesskey = д

browsing-use-cursor-navigation =
    .label = Използване на каретка за придвижване в страниците
    .accesskey = к

browsing-search-on-start-typing =
    .label = Търсене на текст при започване на въвеждане
    .accesskey = Т

browsing-picture-in-picture-toggle-enabled =
    .label = Включване на видео картина в картината
    .accesskey = к

browsing-picture-in-picture-learn-more = Научете повече

browsing-cfr-recommendations =
    .label = Препоръчване на разширения
    .accesskey = П
browsing-cfr-features =
    .label = Препоръчване на възможности
    .accesskey = в

browsing-cfr-recommendations-learn-more = Научете повече

## General Section - Proxy

network-settings-title = Настройки на мрежата

network-proxy-connection-description = Настройване на достъпа до интернет от { -brand-short-name }.

network-proxy-connection-learn-more = Научете повече

network-proxy-connection-settings =
    .label = Настройки…
    .accesskey = Н

## Home Section

home-new-windows-tabs-header = Нови прозорци и раздели

home-new-windows-tabs-description2 = Изберете какво да виждате при отваряне на началната страница, нови прозорци или раздели.

## Home Section - Home Page Customization

home-homepage-mode-label = Начална страница и нови прозорци

home-newtabs-mode-label = Нов раздел

home-restore-defaults =
    .label = Стандартни настройки
    .accesskey = с

# "Firefox" should be treated as a brand and kept in English,
# while "Home" and "(Default)" can be localized.
home-mode-choice-default =
    .label = Начална страница на Firefox

home-mode-choice-custom =
    .label = Потребителски адреси…

home-mode-choice-blank =
    .label = Празна страница

home-homepage-custom-url =
    .placeholder = Поставете адрес…

# This string has a special case for '1' and [other] (default). If necessary for
# your language, you can add {$tabCount} to your translations and use the
# standard CLDR forms, or only use the form for [other] if both strings should
# be identical.
use-current-pages =
    .label =
        { $tabCount ->
            [1] Текущата страница
           *[other] Текущите страници
        }
    .accesskey = Т

choose-bookmark =
    .label = Отметка…
    .accesskey = О

## Home Section - Firefox Home Content Customization

home-prefs-content-header = Начална страница на Firefox
home-prefs-content-description = Изберете съдържанието, което искате да виждате на началната страница на Firefox.

home-prefs-search-header =
    .label = Търсене в Мрежата
home-prefs-topsites-header =
    .label = Често посещавани страници
home-prefs-topsites-description = Най-посещаваните от вас страници

## Variables:
##  $provider (String): Name of the corresponding content provider, e.g "Pocket".

home-prefs-recommended-by-header =
    .label = Препоръчано от { $provider }

##

home-prefs-recommended-by-learn-more = Как работи
home-prefs-recommended-by-option-sponsored-stories =
    .label = Платени публикации

home-prefs-highlights-header =
    .label = Акценти
home-prefs-highlights-description = Избрани страници, които сте запазили или посетили
home-prefs-highlights-option-visited-pages =
    .label = Посетени страници
home-prefs-highlights-options-bookmarks =
    .label = Отметки
home-prefs-highlights-option-most-recent-download =
    .label = Последни изтегляния
home-prefs-highlights-option-saved-to-pocket =
    .label = Страници, запазени в { -pocket-brand-name }

# For the "Snippets" feature traditionally on about:home.
# Alternative translation options: "Small Note" or something that
# expresses the idea of "a small message, shortened from something else,
# and non-essential but also not entirely trivial and useless.
home-prefs-snippets-header =
    .label = Изрезки
home-prefs-snippets-description = Новости от { -vendor-short-name } и { -brand-product-name }
home-prefs-sections-rows-option =
    .label =
        { $num ->
            [one] { $num } ред
           *[other] { $num } реда
        }

## Search Section

search-bar-header = Лента за търсене
search-bar-hidden =
    .label = Използване на адресната лента за търсене и отваряне на страници
search-bar-shown =
    .label = Добавяне на лента за търсене в лентата с инструменти

search-engine-default-header = Стандартна търсеща машина
search-engine-default-desc-2 = Това е вашата търсачка по подразбиране в адресната лента и в лентата за търсене. Можете да я променяте по всяко време.
search-engine-default-private-desc-2 = Изберете друга търсачка по подразбиране само при поверително разглеждане
search-separate-default-engine =
    .label = Използвайте тази търсачка при поверително разглеждане
    .accesskey = И

search-suggestions-header = Предложения при търсене
search-suggestions-desc = Изберете как да се показват предложенията от търсещи машини.

search-suggestions-option =
    .label = Показване на предложения при търсене
    .accesskey = П

search-show-suggestions-url-bar-option =
    .label = Показване на предложения при търсене в резултатите от адресната лента
    .accesskey = р

# This string describes what the user will observe when the system
# prioritizes search suggestions over browsing history in the results
# that extend down from the address bar. In the original English string,
# "ahead" refers to location (appearing most proximate to), not time
# (appearing before).
search-show-suggestions-above-history-option =
    .label = Показване на подсказките преди резултатите от историята при търсене от адресната лента

search-show-suggestions-private-windows =
    .label = Показване на предложенията за търсене при поверително разглеждане

search-suggestions-cant-show = Предложения при търсене в резултатите на адресната лента няма да бъдат показвани, защото { -brand-short-name } е настроен да не запазва историята на разглеждане.

search-one-click-header = Търсене с едно щракване

search-one-click-desc = Изберете допълнителни търсещи машини, които да се показват под адресната лента и лентата за търсене при въвеждане на текст.

search-choose-engine-column =
    .label = Търсеща машина
search-choose-keyword-column =
    .label = Ключова дума

search-restore-default =
    .label = Връщане на стандартните
    .accesskey = В

search-remove-engine =
    .label = Премахване
    .accesskey = П

search-find-more-link = Други търсещи машини

# This warning is displayed when the chosen keyword is already in use
# ('Duplicate' is an adjective)
search-keyword-warning-title = Дублиране на ключовата дума
# Variables:
#   $name (String) - Name of a search engine.
search-keyword-warning-engine = Избрали сте ключова дума, която вече се използва от „{ $name }“. Моля, изберете друга.
search-keyword-warning-bookmark = Избрали сте дума, която вече се използва от отметка. Моля, изберете друга.

## Containers Section

containers-header = Изолирани раздели
containers-add-button =
    .label = Нов изолатор
    .accesskey = и

containers-preferences-button =
    .label = Настройки
containers-remove-button =
    .label = Премахване

## Sync Section - Signed out


## Firefox Account - Signed out. Note that "Sync" and "Firefox Account" are now
## more discrete ("signed in" no longer means "and sync is connected").

sync-signedout-caption = Вземете Мрежата със себе си
sync-signedout-description = Синхронизирайте вашите отметки, история, раздели, добавки и настройки с всички ваши устройства.

# This message contains two links and two icon images.
#   `<img data-l10n-name="android-icon"/>` - Android logo icon
#   `<a data-l10n-name="android-link">` - Link to Android Download
#   `<img data-l10n-name="ios-icon">` - iOS logo icon
#   `<a data-l10n-name="ios-link">` - Link to iOS Download
#
# They can be moved within the sentence as needed to adapt
# to your language, but should not be changed or translated.
sync-mobile-promo = Изтеглете Firefox за <img data-l10n-name="android-icon"/> <a data-l10n-name="android-link">Android</a> или <img data-l10n-name="ios-icon"/> <a data-l10n-name="ios-link">iOS</a>, за да синхронизирате с мобилното си устройство.

## Sync Section - Signed in


## Firefox Account - Signed in

sync-profile-picture =
    .tooltiptext = Промяна снимката на профила

sync-sign-out =
    .label = Излизане…
    .accesskey = з

sync-manage-account = Управление на сметката
    .accesskey = У

sync-signedin-unverified = { $email } не е проверен.
sync-signedin-login-failure = Моля, впишете се, за да се свържете наново { $email }

sync-resend-verification =
    .label = Повторно изпращане на потвърждение
    .accesskey = в

sync-remove-account =
    .label = Премахване на сметка
    .accesskey = п

sync-sign-in =
    .label = Вписване
    .accesskey = В

## Sync section - enabling or disabling sync.

prefs-syncing-on = Синхронизиране: ВКЛЮЧЕНО

prefs-syncing-off = Синхронизиране: ИЗКЛЮЧЕНО

prefs-sync-setup =
    .label = Настройка на { -sync-brand-short-name }…
    .accesskey = н

prefs-sync-offer-setup-label = Синхронизирайте вашите отметки, история, раздели, добавки и настройки с всички ваши устройства.

prefs-sync-now =
    .labelnotsyncing = Синхронизиране
    .accesskeynotsyncing = с
    .labelsyncing = Синхронизиране…

## The list of things currently syncing.

sync-currently-syncing-heading = В момента се синхронизират следните елементи:

sync-currently-syncing-bookmarks = Отметки
sync-currently-syncing-history = История
sync-currently-syncing-tabs = Отворени раздели
sync-currently-syncing-logins-passwords = Регистрации и пароли
sync-currently-syncing-addresses = Адреси
sync-currently-syncing-creditcards = Банкови карти
sync-currently-syncing-addons = Добавки
sync-currently-syncing-prefs =
    { PLATFORM() ->
        [windows] Настройки
       *[other] Настройки
    }

sync-change-options =
    .label = Променяне…
    .accesskey = П

## The "Choose what to sync" dialog.

sync-choose-what-to-sync-dialog =
    .title = Изберете какво да бъде синхронизирано
    .style = width: 36em; min-height: 35em;
    .buttonlabelaccept = Запазване
    .buttonaccesskeyaccept = з
    .buttonlabelextra2 = Изключване…
    .buttonaccesskeyextra2 = и

sync-engine-bookmarks =
    .label = Отметки
    .accesskey = О

sync-engine-history =
    .label = История
    .accesskey = И

sync-engine-tabs =
    .label = Отворени раздели
    .tooltiptext = Списък с разделите от всички устройства
    .accesskey = р

sync-engine-logins-passwords =
    .label = Регистрации и пароли
    .tooltiptext = Запазени потребителски имена и пароли
    .accesskey = е

sync-engine-addresses =
    .label = Адреси
    .tooltiptext = Запазени адреси (само от настолния)
    .accesskey = а

sync-engine-creditcards =
    .label = Банкови карти
    .tooltiptext = Имена, номера и дати на изтичане (само от настолния)
    .accesskey = н

sync-engine-addons =
    .label = Добавки
    .tooltiptext = Разширения и теми за настолния Firefox
    .accesskey = в

sync-engine-prefs =
    .label =
        { PLATFORM() ->
            [windows] Настройки
           *[other] Настройки
        }
    .tooltiptext = Променени настройки
    .accesskey = Н

## The device name controls.

sync-device-name-header = Име на текущото устройство

sync-device-name-change =
    .label = Преименуване…
    .accesskey = м

sync-device-name-cancel =
    .label = Отказ
    .accesskey = о

sync-device-name-save =
    .label = Запазване
    .accesskey = З

sync-connect-another-device = Добавяне на устройство

## Privacy Section

privacy-header = Поверителност на четеца

## Privacy Section - Forms

## Privacy Section - Logins and Passwords

# The search keyword isn't shown to users but is used to find relevant settings in about:preferences.
pane-privacy-logins-and-passwords-header = Регистрации и пароли
    .searchkeywords = { -lockwise-brand-short-name }

# Checkbox to control whether UI is shown to users to save or fill logins/passwords.
forms-ask-to-save-logins =
    .label = Питане при запазване имена и пароли за вход в страниците
    .accesskey = т
forms-exceptions =
    .label = Изключения…
    .accesskey = к
forms-generate-passwords =
    .label = Предлагане и създаване на силни пароли
    .accesskey = р
forms-breach-alerts =
    .label = Показване на известия за изтекли пароли от разбити страници
    .accesskey = и
forms-breach-alerts-learn-more-link = Научете повече

# Checkbox which controls filling saved logins into fields automatically when they appear, in some cases without user interaction.
forms-fill-logins-and-passwords =
    .label = Автоматично попълване на регистрации и пароли
    .accesskey = р
forms-saved-logins =
    .label = Запазени регистрации…
    .accesskey = р
forms-master-pw-use =
    .label = Използване на главна парола
    .accesskey = г
forms-master-pw-change =
    .label = Промяна на главна парола…
    .accesskey = л

forms-master-pw-fips-title = В момента е активен режим FIPS. Той изисква попълнена главна парола.

forms-master-pw-fips-desc = Грешка при промяна на паролата

## OS Authentication dialog


## Privacy Section - History

history-header = История

# This label is followed, on the same line, by a dropdown list of options
# (Remember history, etc.).
# In English it visually creates a full sentence, e.g.
# "Firefox will" + "Remember history".
#
# If this doesn't work for your language, you can translate this message:
#   - Simply as "Firefox", moving the verb into each option.
#     This will result in "Firefox" + "Will remember history", etc.
#   - As a stand-alone message, for example "Firefox history settings:".
history-remember-label = Нека { -brand-short-name } да
    .accesskey = д

history-remember-option-all =
    .label = Помни история
history-remember-option-never =
    .label = Не помни история
history-remember-option-custom =
    .label = Използва потребителски настройки

history-remember-description = { -brand-short-name } ще пази историята на разглеждане, изтегляния и търсене.
history-dontremember-description = { -brand-short-name } ще използва същите настройки като при поверително разглеждане и няма да помни никаква история, докато сте в интернет.

history-private-browsing-permanent =
    .label = Винаги включено поверително разглеждане
    .accesskey = п

history-remember-browser-option =
    .label = Запазване на история на разглеждане и изтегляния
    .accesskey = и

history-remember-search-option =
    .label = Запазване на история на търсения и формуляри
    .accesskey = ф

history-clear-on-close-option =
    .label = Изчистване на история при изход от { -brand-short-name }
    .accesskey = И

history-clear-on-close-settings =
    .label = Настройки…
    .accesskey = Н

history-clear-button =
    .label = Изчистване на историята…
    .accesskey = и

## Privacy Section - Site Data

sitedata-header = Бисквитки и данни на страници

sitedata-total-size-calculating = Изчисляване на размера на данните и буфера…

# Variables:
#   $value (Number) - Value of the unit (for example: 4.6, 500)
#   $unit (String) - Name of the unit (for example: "bytes", "KB")
sitedata-total-size = Буферът, бисквитките и данните от страници в момента заемат { $value } { $unit } дисково пространство.

sitedata-learn-more = Научете повече

sitedata-delete-on-close =
    .label = Изтриване на бисквитки и данни на страници при затваряне на { -brand-short-name }
    .accesskey = д

sitedata-delete-on-close-private-browsing = В постоянен режим на поверително разглеждане бисквитките и данните на страници винаги ще бъдат изчиствани при затваряне на { -brand-short-name }.

sitedata-allow-cookies-option =
    .label = Разрешаване на бисквитки и данни
    .accesskey = р

sitedata-disallow-cookies-option =
    .label = Ограничаване на бисквитки и данни
    .accesskey = о

# This label means 'type of content that is blocked', and is followed by a drop-down list with content types below.
# The list items are the strings named sitedata-block-*-option*.
sitedata-block-desc = Вид на ограничения ресурс
    .accesskey = в

sitedata-option-block-cross-site-trackers =
    .label = Проследяване в различни сайтове
sitedata-option-block-cross-site-and-social-media-trackers =
    .label = Проследяване в различни сайтове и социални сайтове
sitedata-option-block-unvisited =
    .label = Бисквитки от непосетени страници
sitedata-option-block-all-third-party =
    .label = Всички странични бисквитки (може да наруши работата на страниците)
sitedata-option-block-all =
    .label = Всички бисквитки (ще наруши работата на страниците)

sitedata-clear =
    .label = Изчистване на данни…
    .accesskey = т

sitedata-settings =
    .label = Управление на данни…
    .accesskey = у

sitedata-cookies-permissions =
    .label = Управление на права…
    .accesskey = п

## Privacy Section - Address Bar

addressbar-header = Адресна лента

addressbar-suggest = При въвеждане в адресната лента, подсказване с

addressbar-locbar-history-option =
    .label = История на разглеждане
    .accesskey = р
addressbar-locbar-bookmarks-option =
    .label = Отметки
    .accesskey = О
addressbar-locbar-openpage-option =
    .label = Отворени раздели
    .accesskey = р

addressbar-suggestions-settings = Настройки на предложенията от търсещите машини

## Privacy Section - Content Blocking

content-blocking-enhanced-tracking-protection = Разширена защита от проследяване

content-blocking-section-top-level-description = Проследяванията ви следват онлайн, за да събират информация за навиците и интересите ви при разглеждане. { -brand-short-name } спира много от тях, както и други злонамерени скриптове.

content-blocking-learn-more = Научете повече

## These strings are used to define the different levels of
## Enhanced Tracking Protection.

# "Standard" in this case is an adjective, meaning "default" or "normal".
enhanced-tracking-protection-setting-standard =
    .label = Стандартна
    .accesskey = с
enhanced-tracking-protection-setting-strict =
    .label = Строга
    .accesskey = т
enhanced-tracking-protection-setting-custom =
    .label = По избор
    .accesskey = и

##

content-blocking-etp-standard-desc = Баланс между защита и бързодействие. Страниците ще се зареждат нормално.
content-blocking-etp-strict-desc = По-високо ниво на защита, но някои страници може да не работят.
content-blocking-etp-custom-desc = Изберете какво проследяване и кои скриптове да спрете.

content-blocking-private-windows = Проследяващо съдържание в поверителните прозорци
content-blocking-cross-site-tracking-cookies = Бисквитки за следене в различни сайтове
content-blocking-social-media-trackers = Проследяване от социални мрежи
content-blocking-all-cookies = Всички бисквитки
content-blocking-unvisited-cookies = Бисквитки от непосетени страници
content-blocking-all-windows-tracking-content = Проследяващо съдържание във всички прозорци
content-blocking-all-third-party-cookies = Всички странични бисквитки
content-blocking-cryptominers = Добиване на криптовалути
content-blocking-fingerprinters = Снемане на цифров отпечатък

content-blocking-warning-title = Внимание!
content-blocking-warning-learn-how = Научете как

content-blocking-reload-description = За да бъдат приложени промените, разделите трябва да бъдат презаредени.
content-blocking-reload-tabs-button =
    .label = Презареждане на всички раздели
    .accesskey = р

content-blocking-tracking-content-label =
    .label = Проследяващо съдържание
    .accesskey = п
content-blocking-tracking-protection-option-all-windows =
    .label = Във всички прозорци
    .accesskey = в
content-blocking-option-private =
    .label = Само в поверителните прозорци
    .accesskey = о
content-blocking-tracking-protection-change-block-list = Промяна списъка за блокиране

content-blocking-cookies-label =
    .label = Бисквитки
    .accesskey = б

content-blocking-expand-section =
    .tooltiptext = Повече информация

# Cryptomining refers to using scripts on websites that can use a computer’s resources to mine cryptocurrency without a user’s knowledge.
content-blocking-cryptominers-label =
    .label = Добиване на криптовалути
    .accesskey = к

# Browser fingerprinting is a method of tracking users by the configuration and settings information (their "digital fingerprint")
# that is visible to websites they browse, rather than traditional tracking methods such as IP addresses and unique cookies.
content-blocking-fingerprinters-label =
    .label = Снемане на цифров отпечатък
    .accesskey = ц

## Privacy Section - Tracking

tracking-manage-exceptions =
    .label = Изключения…
    .accesskey = и

## Privacy Section - Permissions

permissions-header = Права

permissions-location = Местоположение
permissions-location-settings =
    .label = Настройки…
    .accesskey = с

permissions-xr = Виртуална реалност

permissions-camera = Камера
permissions-camera-settings =
    .label = Настройки…
    .accesskey = с

permissions-microphone = Микрофон
permissions-microphone-settings =
    .label = Настройки…
    .accesskey = с

permissions-notification = Известия
permissions-notification-settings =
    .label = Настройки…
    .accesskey = с
permissions-notification-link = Научете повече

permissions-notification-pause =
    .label = Спиране на известията до рестарт на { -brand-short-name }
    .accesskey = з

permissions-autoplay = Автоматично възпроизвеждане

permissions-autoplay-settings =
    .label = Настройки…
    .accesskey = н

permissions-block-popups =
    .label = Спиране на изскачащите прозорци
    .accesskey = С

permissions-block-popups-exceptions =
    .label = Изключения…
    .accesskey = з

permissions-addon-install-warning =
    .label = Предупреждаване при опит на страница да инсталира добавки
    .accesskey = д

permissions-addon-exceptions =
    .label = Изключения…
    .accesskey = И

permissions-a11y-privacy-checkbox =
    .label = Забраняване на достъпа до четеца на услуги за достъпност
    .accesskey = б

permissions-a11y-privacy-link = Научете повече

## Privacy Section - Data Collection

collection-header = Събиране и използване на данни от { -brand-short-name }

collection-description = Стремим се да ви предоставяме възможност и да събираме само толкова, колкото ни е необходимо, за да предоставяме и подобряваме { -brand-short-name } за всички. Винаги искаме разрешение преди да получим лична информация.
collection-privacy-notice = Политика на поверителност

collection-health-report-telemetry-disabled = Вече не позволявате на { -vendor-short-name } да събира технически данни и данни за взаимодействията. Всички стари данни ще бъдат изтрити в рамките на 30 дни.
collection-health-report-telemetry-disabled-link = Научете повече

collection-health-report =
    .label = Разрешаване на { -brand-short-name } да изпраща техническа информация и данни за използването към { -vendor-short-name }
    .accesskey = т
collection-health-report-link = Научете повече

collection-studies =
    .label = Разрешаване на { -brand-short-name } да инсталира и извършва изследвания
collection-studies-link = Преглед на изследванията на { -brand-short-name }

addon-recommendations =
    .label = Разрешаване на { -brand-short-name } да прави персонализирани препоръки за разширения
addon-recommendations-link = Научете повече

# This message is displayed above disabled data sharing options in developer builds
# or builds with no Telemetry support available.
collection-health-report-disabled = Докладването да данни е изключено за тази конфигурация на изданието

collection-backlogged-crash-reports =
    .label = Разрешаване на { -brand-short-name } да изпраща от ваше име предишни доклади за срив
    .accesskey = и
collection-backlogged-crash-reports-link = Научете повече

## Privacy Section - Security
##
## It is important that wording follows the guidelines outlined on this page:
## https://developers.google.com/safe-browsing/developers_guide_v2#AcceptableUsage

security-header = Защита

security-browsing-protection = Измамно съдържание и защита от опасен софтуер

security-enable-safe-browsing =
    .label = Блокиране на опасно и измамно съдържание
    .accesskey = Б
security-enable-safe-browsing-link = Научете повече

security-block-downloads =
    .label = Блокиране на опасни изтегляния
    .accesskey = т

security-block-uncommon-software =
    .label = Предупреждаване при нежелан или рядко срещан софтуер
    .accesskey = н

## Privacy Section - Certificates

certs-header = Сертификати

certs-personal-label = Когато сървър поиска личния ви сертификат

certs-select-auto-option =
    .label = Автоматично избиране на някой
    .accesskey = а

certs-select-ask-option =
    .label = Питане всеки път
    .accesskey = п

certs-enable-ocsp =
    .label = Заявка към сървър OCSP responder за потвърждаване валидността на сертификатите
    .accesskey = З

certs-view =
    .label = Преглед на сертификатите…
    .accesskey = с

certs-devices =
    .label = Устройства по безопасността…
    .accesskey = у

space-alert-learn-more-button =
    .label = Научете повече
    .accesskey = н

space-alert-over-5gb-pref-button =
    .label =
        { PLATFORM() ->
            [windows] Настройки
           *[other] Настройки
        }
    .accesskey =
        { PLATFORM() ->
            [windows] н
           *[other] н
        }

space-alert-over-5gb-message =
    { PLATFORM() ->
        [windows] Дисковото пространство достъпно за { -brand-short-name } е на свършване. Съдържанието на страницата може да не се показва правилно. Може да изчистите текущите данни от Настройки > Поверителност и защита > Бисквитки и данни на страници.
       *[other] Дисковото пространство достъпно за { -brand-short-name } е на свършване. Съдържанието на страницата може да не се показва правилно. Може да изчистите текущите данни от Настройки > Поверителност и защита > Бисквитки и данни на страници.
    }

space-alert-under-5gb-ok-button =
    .label = Добре
    .accesskey = д

space-alert-under-5gb-message = Дисковото пространство достъпно за { -brand-short-name } е на свършване. Съдържанието на страницата може да не се показва правилно. За да оптимално използване на дисковото пространство при сърфиране посетете „Научете повече“.

## Privacy Section - HTTPS-Only

## The following strings are used in the Download section of settings

desktop-folder-name = Плот
downloads-folder-name = Изтегляния
choose-download-folder-title = Избиране на папка за изтегляне:

# Variables:
#   $service-name (String) - Name of a cloud storage provider like Dropbox, Google Drive, etc...
save-files-to-cloud-storage =
    .label = Запазване на файла в { $service-name }
