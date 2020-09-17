# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

addons-window =
    .title = Қосымшалар басқарушысы
addons-page-title = Қосымшалар басқарушысы

search-header =
    .placeholder = addons.mozilla.org-ға іздеу
    .searchbuttonlabel = Іздеу

search-header-shortcut =
    .key = f

list-empty-installed =
    .value = Сізде осы түрдегі қосымшалар орнатылмаған

list-empty-available-updates =
    .value = Жаңартулар табылмады

list-empty-recent-updates =
    .value = Соңғы кезде ешбір кеңейту жаңартылмады

list-empty-find-updates =
    .label = Жаңартуларды тексеру

list-empty-button =
    .label = Қосымшалар жөнінде көбірек біліңіз

help-button = Қосымшаларды қолдау
sidebar-help-button-title =
    .title = Қосымшаларды қолдау

preferences =
    { PLATFORM() ->
        [windows] { -brand-short-name } опциялары
       *[other] { -brand-short-name } баптаулары
    }
sidebar-preferences-button-title =
    .title =
        { PLATFORM() ->
            [windows] { -brand-short-name } опциялары
           *[other] { -brand-short-name } баптаулары
        }

show-unsigned-extensions-button =
    .label = Кейбір кеңейтулерді растау мүмкін емес

show-all-extensions-button =
    .label = Барлық кеңейтулерді көрсету

cmd-show-details =
    .label = Көбірек ақпаратты көрсету
    .accesskey = е

cmd-find-updates =
    .label = Жаңартуларды іздеу
    .accesskey = а

cmd-preferences =
    .label =
        { PLATFORM() ->
            [windows] Баптаулар
           *[other] Баптаулар
        }
    .accesskey =
        { PLATFORM() ->
            [windows] Б
           *[other] р
        }

cmd-enable-theme =
    .label = Теманы киіп көру
    .accesskey = м

cmd-disable-theme =
    .label = Теманы алып тастау
    .accesskey = с

cmd-install-addon =
    .label = Орнату
    .accesskey = н

cmd-contribute =
    .label = Үлес қосу
    .accesskey = с
    .tooltiptext = Бұл қосымшаны дамытуға үлес қосу

detail-version =
    .label = Нұсқасы

detail-last-updated =
    .label = Соңғы жаңартылған

detail-contributions-description = Бұл кеңейтудің әзірлеушісі сізден шағын ғана демеушілік етіп, оның жұмысын қолдау көрсетуді сұраған.

detail-contributions-button = Үлес қосу
    .title = Бұл қосымшаның өндірісіне үлес қосу
    .accesskey = с

detail-update-type =
    .value = Автожаңартулар

detail-update-default =
    .label = Негізгі
    .tooltiptext = Жаңартуларды тек ол негізгі баптау болса ғана автоорнату

detail-update-automatic =
    .label = Іске қосулы
    .tooltiptext = Жаңартуларды автоорнату

detail-update-manual =
    .label = Сөндірулі
    .tooltiptext = Жаңартуларды автоорнатпау

# Used as a description for the option to allow or block an add-on in private windows.
detail-private-browsing-label = Жекелік шолу режиміндегі терезелерде орындау

# Some add-ons may elect to not run in private windows by setting incognito: not_allowed in the manifest.  This
# cannot be overridden by the user.
detail-private-disallowed-label = Жекелік шолу терезелерінде рұқсат етілмеген
detail-private-disallowed-description2 = Бұл кеңейту жекелік шолу режимінде жасамайды. <a data-l10n-name="learn-more">Көбірек білу</a>

# Some special add-ons are privileged, run in private windows automatically, and this permission can't be revoked
detail-private-required-label = Жекелік терезелеріне қатынау рұқсатын талап етеді
detail-private-required-description2 = Бұл кеңейтудің жекелік шолу режимінде сіздің желідегі белсенділігіңізге қатынау рұқсаты бар. <a data-l10n-name="learn-more">Көбірек білу</a>

detail-private-browsing-on =
    .label = Рұқсат ету
    .tooltiptext = Жекелік шолу режимінде іске қосу

detail-private-browsing-off =
    .label = Рұқсат етпеу
    .tooltiptext = Жекелік шолу режимінде сөндіру

detail-home =
    .label = Үй парағы

detail-home-value =
    .value = { detail-home.label }

detail-repository =
    .label = Кеңейту профайлы

detail-repository-value =
    .value = { detail-repository.label }

detail-check-for-updates =
    .label = Жаңартуларды тексеру
    .accesskey = т
    .tooltiptext = Бұл қосымша үшін жаңартуларды іздеу

detail-show-preferences =
    .label =
        { PLATFORM() ->
            [windows] Баптаулар
           *[other] Баптаулар
        }
    .accesskey =
        { PLATFORM() ->
            [windows] Б
           *[other] п
        }
    .tooltiptext =
        { PLATFORM() ->
            [windows] Бұл кеңейтудің баптауларын өзгерту
           *[other] Бұл кеңейтудің баптауларын өзгерту
        }

detail-rating =
    .value = Рейтингі

addon-restart-now =
    .label = Қазір қайта қосу

disabled-unsigned-heading =
    .value = Кейбір қосымшалар сөндірілген

disabled-unsigned-description = Келесі қосымшалар { -brand-short-name } ішінде қолданылуға расталмаған. Сіз <label data-l10n-name="find-addons">баламаларын таба аласыз</label> немесе әзірлеушіден оларды растаудан өткізуді сұрай аласыз.

disabled-unsigned-learn-more = Сіздің онлайн қауіпсіздігін сақтауға арналған біздің әрекеттер жөнінде біліңіз.

disabled-unsigned-devinfo = Өз қосымшаларын растау үрдісінен өткізгісі келетін әзірлеушілер біздің келесі құжатты оқи алады: <label data-l10n-name="learn-more">нұсқама</label>.

plugin-deprecation-description = Бірнәрсе жетіспей ма? Кейбір плагиндерді { -brand-short-name } енді қолдамайды. <label data-l10n-name="learn-more">Көбірек білу.</label>

legacy-warning-show-legacy = Ескірген кеңейтулерді көрсету

legacy-extensions =
    .value = Ескірген кеңейтулер

legacy-extensions-description = Бұл кеңейтулер { -brand-short-name } өнімінің ағымдағы стандартқа сай емес, сондықтан сөндірілді. <label data-l10n-name="legacy-learn-more">Қосымшалар өзгерістері туралы көбірек білу</label>

private-browsing-description2 = { -brand-short-name } кеңейтулер жекелік шолуда қалай жасайтынын өзгертеді. { -brand-short-name } ішіне қосылған кез келген жаңа кеңейту жекелік терезелерінде орындалмайды. Оған баптаулар ішінен арнайы рұқсат бермесеңіз, кеңейту жекелік шолу режиміне жұмыс істемейді, және ол кездегі сіздің желілік белсенділікке қол жеткізе алмайды. Бұл өзгерісті жекелік шолуыңызды жеке қалдыру үшін жасадық.<label data-l10n-name="private-browsing-learn-more">Кеңейтудің баптауларын өзгерту тәсілі туралы көбірек білу.</label>

addon-category-discover = Ұсыныстар
addon-category-discover-title =
    .title = Ұсыныстар
addon-category-extension = Кеңейтулер
addon-category-extension-title =
    .title = Кеңейтулер
addon-category-theme = Темалар
addon-category-theme-title =
    .title = Темалар
addon-category-plugin = Плагиндер
addon-category-plugin-title =
    .title = Плагиндер
addon-category-dictionary = Сөздіктер
addon-category-dictionary-title =
    .title = Сөздіктер
addon-category-locale = Тілдер
addon-category-locale-title =
    .title = Тілдер
addon-category-available-updates = Қолжетерлік жаңартулар
addon-category-available-updates-title =
    .title = Қолжетерлік жаңартулар
addon-category-recent-updates = Соңғы жаңартулар
addon-category-recent-updates-title =
    .title = Соңғы жаңартулар

## These are global warnings

extensions-warning-safe-mode = Барлық кеңейтулер қауіпсіз режимімен сөндірілген.
extensions-warning-check-compatibility = Кеңейтулер үйлесімдігін тексеруді сөндіру. Сізде үйлесімсіз кеңейтулер бар болуы мүмкін.
extensions-warning-check-compatibility-button = Іске қосу
    .title = Кеңейтулер үйлесімдігін тексеруді іске қосу
extensions-warning-update-security = Кеңейтулер жаңартуларын қауісіздікке тексеру сөндірулі. Жаңартулармен қор болуыңыз мүмкін.
extensions-warning-update-security-button = Іске қосу
    .title = Кеңейтулер жаңартуларын қауісіздікке тексеруді іске қосу


## Strings connected to add-on updates

addon-updates-check-for-updates = Жаңартуларды тексеру
    .accesskey = к
addon-updates-view-updates = Соңғы жаңартуларды қарау
    .accesskey = о

# This menu item is a checkbox that toggles the default global behavior for
# add-on update checking.

addon-updates-update-addons-automatically = Кеңейтулерді автожаңарту
    .accesskey = е

## Specific add-ons can have custom update checking behaviors ("Manually",
## "Automatically", "Use default global behavior"). These menu items reset the
## update checking behavior for all add-ons to the default global behavior
## (which itself is either "Automatically" or "Manually", controlled by the
## extensions-updates-update-addons-automatically.label menu item).

addon-updates-reset-updates-to-automatic = Барлық кеңейтулерді автожаңартылатындай етіп қылу
    .accesskey = а
addon-updates-reset-updates-to-manual = Барлық кеңейтулерді тек қолмен жаңартылатындай етіп қылу
    .accesskey = о

## Status messages displayed when updating add-ons

addon-updates-updating = Қосымшалар жаңартылуда
addon-updates-installed = Қосымшаларыңыз жаңартылды.
addon-updates-none-found = Жаңартулар табылмады
addon-updates-manual-updates-found = Қолжетерлік жаңартуларды көрсету

## Add-on install/debug strings for page options menu

addon-install-from-file = Файлдан қосымшаны орнату…
    .accesskey = Ф
addon-install-from-file-dialog-title = Орнату үшін кеңейтуді таңдаңыз
addon-install-from-file-filter-name = Қосымшалар
addon-open-about-debugging = Қосымшаларды жөндеу
    .accesskey = д

## Extension shortcut management

# This is displayed in the page options menu
addon-manage-extensions-shortcuts = Кеңейтудің пернетақта жарлықтарын басқару
    .accesskey = ж

shortcuts-no-addons = Сізде ешқандай кеңейтулер орнатылмаған.
shortcuts-no-commands = Келесі кеңейтулерде жарлықтар жоқ:
shortcuts-input =
    .placeholder = Жарлықты теріңіз

shortcuts-browserAction2 = Құралдар панелінің батырмасын белсендіру
shortcuts-pageAction = Бет әрекетін белсендіру
shortcuts-sidebarAction = Бүйір панелін көрсету/жасыру

shortcuts-modifier-mac = Ctrl, Alt, немесе ⌘ қосыңыз
shortcuts-modifier-other = Ctrl немесе Alt қосыңыз
shortcuts-invalid = Комбинация жарамсыз
shortcuts-letter = Әріпті теріңіз
shortcuts-system = { -brand-short-name } жарлығын қайта анықтау мүмкін емес

# String displayed in warning label when there is a duplicate shortcut
shortcuts-duplicate = Жарлықты қосарлау

# String displayed when a keyboard shortcut is already assigned to more than one add-on
# Variables:
#   $shortcut (string) - Shortcut string for the add-on
shortcuts-duplicate-warning-message = { $shortcut } бірден көп жерде жарлық ретінде қолданылуда. Қосарланған жарлықтар күтпеген мінез-құлығына әкеп соғуы мүмкін.

# String displayed when a keyboard shortcut is already used by another add-on
# Variables:
#   $addon (string) - Name of the add-on
shortcuts-exists = { $addon } қолдануда

shortcuts-card-expand-button =
    { $numberToShow ->
       *[other] Тағы { $numberToShow } көрсету
    }

shortcuts-card-collapse-button = Азырақ көрсету

header-back-button =
    .title = Артқа

## Recommended add-ons page

# Explanatory introduction to the list of recommended add-ons. The action word
# ("recommends") in the final sentence is a link to external documentation.
discopane-intro =
    Кеңейтулер және темалар сіздің браузеріңіз үшін қолданбалар сияқты,
    олардың көмегімен парольдерді қорғау, видеоларды жүктеп алу,
    жеңілдіктерді табу, жарнаманы бұғаттау, браузердің сыртқы түрін өзгерту,
    және т.б. жасауға болады. Бұндай кішігірім БҚ жиі үшінші жақтармен
    жасалады. { -brand-product-name } қосымша қауіпсіздік, өнімділік және
    мүмкіндіктері үшін <a data-l10n-name="learn-more-trigger">ұсынатын</a> тізім.

# Notice to make user aware that the recommendations are personalized.
discopane-notice-recommendations =
    Бұл ұсыныстардың кейбіреулері жекеленген. Олар сіз басқа орнатқан кеңейтулер,
    профиль баптаулары және қолданылу статистикасына негізделген.
discopane-notice-learn-more = Көбірек білу

privacy-policy = Жекелік саясаты

# Refers to the author of an add-on, shown below the name of the add-on.
# Variables:
#   $author (string) - The name of the add-on developer.
created-by-author = <a data-l10n-name="author">{ $author }</a> жасаған
# Shows the number of daily users of the add-on.
# Variables:
#   $dailyUsers (number) - The number of daily users.
user-count = Пайдаланушылар: { $dailyUsers }
install-extension-button = { -brand-product-name } ішіне қосу
install-theme-button = Теманы орнату
# The label of the button that appears after installing an add-on. Upon click,
# the detailed add-on view is opened, from where the add-on can be managed.
manage-addon-button = Басқару
find-more-addons = Көбірек қосымшаларды табу

# This is a label for the button to open the "more options" menu, it is only
# used for screen readers.
addon-options-button =
    .aria-label = Көбірек опциялар

## Add-on actions

report-addon-button = Хабарлау
remove-addon-button = Өшіру
# The link will always be shown after the other text.
remove-addon-disabled-button = Өшіру мүмкін емес <a data-l10n-name="link">Неге?</a>
disable-addon-button = Сөндіру
enable-addon-button = Іске қосу
# This is used for the toggle on the extension card, it's a checkbox and this
# is always its label.
extension-enable-addon-button-label =
    .aria-label = Іске қосу
preferences-addon-button =
    { PLATFORM() ->
        [windows] Баптаулар
       *[other] Баптаулар
    }
details-addon-button = Ақпараты
release-notes-addon-button = Шығарылым ескертпесі
permissions-addon-button = Рұқсаттар

extension-enabled-heading = Іске қосулы
extension-disabled-heading = Сөндірілген

theme-enabled-heading = Іске қосулы
theme-disabled-heading = Сөндірілген

plugin-enabled-heading = Іске қосулы
plugin-disabled-heading = Сөндірілген

dictionary-enabled-heading = Іске қосулы
dictionary-disabled-heading = Сөндірілген

locale-enabled-heading = Іске қосулы
locale-disabled-heading = Сөндірілген

ask-to-activate-button = Белсендіруді сұрау
always-activate-button = Әрқашан белсендіру
never-activate-button = Ешқашан белсендірмеу

addon-detail-author-label = Авторы
addon-detail-version-label = Нұсқасы
addon-detail-last-updated-label = Соңғы жаңартылған
addon-detail-homepage-label = Үй парағы
addon-detail-rating-label = Рейтингі

install-postponed-button = Қазір жаңарту

# The average rating that the add-on has received.
# Variables:
#   $rating (number) - A number between 0 and 5. The translation should show at most one digit after the comma.
five-star-rating =
    .title = Рейтингі: 5 ішінен { NUMBER($rating, maximumFractionDigits: 1) }

# This string is used to show that an add-on is disabled.
# Variables:
#   $name (string) - The name of the add-on
addon-name-disabled = { $name } (сөндірілген)

# The number of reviews that an add-on has received on AMO.
# Variables:
#   $numberOfReviews (number) - The number of reviews received
addon-detail-reviews-link =
    { $numberOfReviews ->
       *[other] { $numberOfReviews } пікір
    }

## Pending uninstall message bar

# Variables:
#   $addon (string) - Name of the add-on
pending-uninstall-description = <span data-l10n-name="addon-name">{ $addon }</span> өшірілді.
pending-uninstall-undo-button = Болдырмау

addon-detail-updates-label = Автожаңартуларды рұқсат ету
addon-detail-updates-radio-default = Бастапқы
addon-detail-updates-radio-on = Іске қосулы
addon-detail-updates-radio-off = Сөндірулі
addon-detail-update-check-label = Жаңартуларды тексеру
install-update-button = Жаңарту

# This is the tooltip text for the private browsing badge in about:addons. The
# badge is the private browsing icon included next to the extension's name.
addon-badge-private-browsing-allowed2 =
    .title = Жекелік терезелерінде рұқсат етілген
    .aria-label = { addon-badge-private-browsing-allowed2.title }
addon-detail-private-browsing-help = Рұқсат етілген кезде, кеңейту жекелік шолу кезінде сіздің желілік белсенділігіңізге қол жеткізе алады. <a data-l10n-name="learn-more">Көбірек білу</a>
addon-detail-private-browsing-allow = Рұқсат ету
addon-detail-private-browsing-disallow = Рұқсат етпеу

# This is the tooltip text for the recommended badge for an extension in about:addons. The
# badge is a small icon displayed next to an extension when it is recommended on AMO.
addon-badge-recommended2 =
    .title = { -brand-product-name } тек біздің қауіпсіздік және өнімділік стандарттарына сай келетін кеңейтулерді ұсынады
    .aria-label = { addon-badge-recommended2.title }

available-updates-heading = Қолжетерлік жаңартулар
recent-updates-heading = Соңғы жаңартулар

release-notes-loading = Жүктелуде…
release-notes-error = Кешіріңіз, шығарылым ескертпесін жүктеп алу кезінде қате кетті.

addon-permissions-empty = Бұл кеңейту ешқандай рұқсаттарды қажет етпейді

recommended-extensions-heading = Ұсынылатын кеңейтулер
recommended-themes-heading = Ұсынылатын темалар

# A recommendation for the Firefox Color theme shown at the bottom of the theme
# list view. The "Firefox Color" name itself should not be translated.
recommended-theme-1 = Шабытты сезіп тұрсыз ба? <a data-l10n-name="link">Firefox Color көмегімен өз темаңызды жасаңыз.</a>

## Page headings

extension-heading = Кеңейтулерді басқару
theme-heading = Темаларды басқару
plugin-heading = Плагиндерді басқару
dictionary-heading = Сөздіктерді басқару
locale-heading = Тілдерді басқару
updates-heading = Жаңартуларды басқару
discover-heading = Өз { -brand-short-name } жеке қылыңыз
shortcuts-heading = Кеңейтудің пернетақта жарлықтарын басқару

default-heading-search-label = Көбірек қосымшаларды табу
addons-heading-search-input =
    .placeholder = addons.mozilla.org-ға іздеу

addon-page-options-button =
    .title = Барлық қосымшалар үшін құралдар
