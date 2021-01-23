# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Лагіны & паролі

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Вазьміце свае паролі ўсюды
login-app-promo-subtitle = Атрымаць бясплатную праграму { -lockwise-brand-name }
login-app-promo-android =
    .alt = Атрымаць на Google Play
login-app-promo-apple =
    .alt = Сцягнуць з App Store

login-filter =
    .placeholder = Шукаць лагіны

create-login-button = Дадаць новы лагін

fxaccounts-sign-in-text = Атрымайце доступ да сваіх пароляў на іншых прыладах
fxaccounts-sign-in-button = Увайсці ў { -sync-brand-short-name(case: "acc") }
fxaccounts-avatar-button =
    .title = Кіраванне ўліковым запісам

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Адкрыць меню
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Імпартаваць з іншага браўзера…
about-logins-menu-menuitem-import-from-a-file = Імпартаваць з файла…
about-logins-menu-menuitem-export-logins = Экспартаваць лагіны…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Налады
       *[other] Параметры
    }
about-logins-menu-menuitem-help = Даведка
menu-menuitem-android-app = { -lockwise-brand-short-name } для Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } для iPhone і iPad

## Login List

login-list =
    .aria-label = Лагіны, якія адпавядаюць пошукаваму запыту
login-list-count =
    { $count ->
        [one] { $count } лагін
        [few] { $count } лагіны
       *[many] { $count } лагінаў
    }
login-list-sort-label-text = Парадкаванне:
login-list-name-option = Назва (А-Я)
login-list-name-reverse-option = Назва (Я-А)
about-logins-login-list-alerts-option = Папярэджанні
login-list-last-changed-option = Апошняе змяненне
login-list-last-used-option = Апошняе выкарыстанне
login-list-intro-title = Лагіны не знойдзены
login-list-intro-description = Калі вы захоўваеце пароль у { -brand-product-name }, ён з'явіцца тут.
about-logins-login-list-empty-search-title = Лагіны не знойдзены
about-logins-login-list-empty-search-description = Няма вынікаў, якія адпавядаюць вашаму пошуку.
login-list-item-title-new-login = Новы лагін
login-list-item-subtitle-new-login = Увядзіце свае ўліковыя дадзеныя
login-list-item-subtitle-missing-username = (без імя карыстальніка)
about-logins-list-item-breach-icon =
    .title = Узламаны сайт
about-logins-list-item-vulnerable-password-icon =
    .title = Уразлівы пароль

## Introduction screen

login-intro-heading = Шукаеце захаваныя лагіны? Наладзьце { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Шукаеце захаваныя лагіны? Наладзьце { -sync-brand-short-name } або імпартуйце іх.
about-logins-login-intro-heading-logged-in = Сінхранізаваныя лагіны не знойдзены.
login-intro-description = Калі вы захавалі свае лагіны ў { -brand-product-name } на іншай прыладзе, вось як атрымаць іх тут:
login-intro-instruction-fxa = Стварыце альбо ўвайдзіце ў свой { -fxaccount-brand-name } на прыладзе, дзе захоўваюцца вашы лагіны
login-intro-instruction-fxa-settings = Пераканайцеся, што вы ўстанавілі сцяжок Лагіны у наладах { -sync-brand-short-name }
about-logins-intro-instruction-help = Для атрымання дадатковай даведкі наведайце <a data-l10n-name="help-link">{ -lockwise-brand-short-name } падтрымку</a>
about-logins-intro-import = Калі вашы паролі захоўваюцца ў іншым браўзеры, вы можаце <a data-l10n-name="import-link">імпартаваць іх у { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = Калі вашы лагіны захоўваюцца па-за { -brand-product-name }, вы можаце <a data-l10n-name="import-browser-link">імпартаваць іх з іншага браўзера</a> або <a data-l10n-name="import-file-link">з файла</a>

## Login

login-item-new-login-title = Дадаць новы лагін
login-item-edit-button = Змяніць
about-logins-login-item-remove-button = Выдаліць
login-item-origin-label = Адрас сайта
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Імя карыстальніка
about-logins-login-item-username =
    .placeholder = (без імя карыстальніка)
login-item-copy-username-button-text = Капіяваць
login-item-copied-username-button-text = Скапіявана!
login-item-password-label = Пароль
login-item-password-reveal-checkbox =
    .aria-label = Паказаць пароль
login-item-copy-password-button-text = Капіяваць
login-item-copied-password-button-text = Скапіявана!
login-item-save-changes-button = Захаваць змены
login-item-save-new-button = Захаваць
login-item-cancel-button = Скасаваць
login-item-time-changed = Апошняе змяненне: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Створаны: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Апошняе выкарыстанне: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Каб змяніць ваш лагін, увядзіце свае ўліковыя дадзеныя для ўваходу ў Windows. Гэта дапамагае захоўваць бяспеку вашых уліковых запісаў.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = рэдагаваць захаваны лагін

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Каб пабачыць свой пароль, увядзіце свае ўліковыя дадзеныя для ўваходу ў Windows. Гэта дапамагае захоўваць бяспеку вашых уліковых запісаў.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = паказаць захаваны пароль

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Каб скапіраваць свой пароль, увядзіце свае ўліковыя дадзеныя для ўваходу ў Windows. Гэта дапамагае захоўваць бяспеку вашых уліковых запісаў.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = скапіраваць захаваны пароль

## Master Password notification

master-password-notification-message = Калі ласка, увядзіце ваш галоўны пароль для прагляду захаваных лагінаў і пароляў

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Каб экспартаваць вашы лагіны, увядзіце свае ўліковыя дадзеныя для ўваходу ў Windows. Гэта дапамагае захоўваць бяспеку вашых уліковых запісаў.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = экспартаваць захаваныя лагіны і паролі

## Primary Password notification

about-logins-primary-password-notification-message = Калі ласка, увядзіце свой галоўны пароль для прагляду захаваных лагінаў і пароляў
master-password-reload-button =
    .label = Увайсці
    .accesskey = У

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Хочаце мець свае лагіны ўсюды, дзе карыстаецеся { -brand-product-name }? Перайдзіце ў налады { -sync-brand-short-name } і выберыце сцяжок Лагіны.
       *[other] Хочаце мець свае лагіны ўсюды, дзе карыстаецеся { -brand-product-name }? Перайдзіце ў перавагі { -sync-brand-short-name } і выберыце сцяжок Лагіны.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Адкрыць налады { -sync-brand-short-name }
           *[other] Адкрыць налады { -sync-brand-short-name }
        }
    .accesskey = А
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Больш не пытацца
    .accesskey = а

## Dialogs

confirmation-dialog-cancel-button = Скасаваць
confirmation-dialog-dismiss-button =
    .title = Скасаваць

about-logins-confirm-remove-dialog-title = Выдаліць гэты лагін?
confirm-delete-dialog-message = Гэтае дзеянне незваротнае.
about-logins-confirm-remove-dialog-confirm-button = Выдаліць

about-logins-confirm-export-dialog-title = Экспарт лагінаў і пароляў
about-logins-confirm-export-dialog-message = Вашы паролі будуць захаваны як звычайны тэкст (напр., BadP@ssw0rd), таму кожны, хто можа адкрыць экспартаваны файл, можа ўбачыць іх.
about-logins-confirm-export-dialog-confirm-button = Экспартаваць…

confirm-discard-changes-dialog-title = Адхіліць незахаваныя змены?
confirm-discard-changes-dialog-message = Усе незапісаныя змены будуць страчаны.
confirm-discard-changes-dialog-confirm-button = Адхіліць

## Breach Alert notification

about-logins-breach-alert-title = Уцечка з сайта
breach-alert-text = З моманту апошняга абнаўлення дадзеных для ўваходу, паролі з гэтага сайта ўцеклі ці былі выкрадзены. Змяніце пароль, каб абараніць свой уліковы запіс.
about-logins-breach-alert-date = Гэта ўцечка здарылася { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Перайсці да { $hostname }
about-logins-breach-alert-learn-more-link = Падрабязней

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Уразлівы пароль
about-logins-vulnerable-alert-text2 = Гэты пароль быў выкарыстаны ў іншым уліковым запісе, які, імаверна, патрапіў ва ўцечку звестак. Паўторнае выкарыстанне ўліковых дадзеных ставіць пад пагрозу ўсе вашы ўліковыя запісы. Змяніце гэты пароль.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Перайсці да { $hostname }
about-logins-vulnerable-alert-learn-more-link = Падрабязней

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Запіс для { $loginTitle } з такім імем карыстальніка ўжо ёсць. <a data-l10n-name="duplicate-link">Перайсці да наяўнага запісу?</a>

# This is a generic error message.
about-logins-error-message-default = Пры спробе захавання гэтага пароля здарылася памылка.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Экспартаваны файл лагінаў
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = дадзеныя-для-ўваходу.csv
about-logins-export-file-picker-export-button = Экспартаваць
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Дакумент CSV
       *[other] Файл CSV
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Імпартаваць файл лагінаў
about-logins-import-file-picker-import-button = Імпартаваць
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Дакумент CSV
       *[other] Файл CSV
    }
