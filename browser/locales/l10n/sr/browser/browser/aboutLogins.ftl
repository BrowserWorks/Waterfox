# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Пријаве и лозинке

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Понесите ваше лозинке са собом
login-app-promo-subtitle = Преузмите бесплатну { -lockwise-brand-name } апликацију
login-app-promo-android =
    .alt = Преузмите на Google Play
login-app-promo-apple =
    .alt = Преузмите на App Store-у

login-filter =
    .placeholder = Претражите пријаве

create-login-button = Направите нову пријаву

fxaccounts-sign-in-text = Пронађите своје лозинке на свим својим уређајима
fxaccounts-sign-in-button = Пријавите се у { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Управљај налогом

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Отвори мени
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Увези из другог прегледача…
about-logins-menu-menuitem-import-from-a-file = Увезите из датотеке:…
about-logins-menu-menuitem-export-logins = Извезите пријаве…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Опције
       *[other] Подешавања
    }
about-logins-menu-menuitem-help = Помоћ
menu-menuitem-android-app = { -lockwise-brand-short-name } за Андроид
menu-menuitem-iphone-app = { -lockwise-brand-short-name } за iPhone и iPad

## Login List

login-list =
    .aria-label = Пријаве подударне са појмом претраге
login-list-count =
    { $count ->
        [one] { $count } пријава
        [few] { $count } пријаве
       *[other] { $count } пријава
    }
login-list-sort-label-text = Поређај по:
login-list-name-option = Назив (А-Ш)
login-list-name-reverse-option = Назив (А-Ш)
about-logins-login-list-alerts-option = Упозорења
login-list-last-changed-option = Последња измена
login-list-last-used-option = Последњи пут коришћено
login-list-intro-title = Нема пронађених пријава
login-list-intro-description = Када сачувате лозинку унутар програма { -brand-product-name }, појавиће се и овде.
about-logins-login-list-empty-search-title = Нису пронађене пријаве
about-logins-login-list-empty-search-description = Нема резултата који одговарају критеријумима претраге.
login-list-item-title-new-login = Нова пријава
login-list-item-subtitle-new-login = Унесите своје податке за пријаву
login-list-item-subtitle-missing-username = (без корисничког имена)
about-logins-list-item-breach-icon =
    .title = Веб страница на којој долази до цурења података
about-logins-list-item-vulnerable-password-icon =
    .title = Рањива лозинка

## Introduction screen

login-intro-heading = Тражите сачуване пријаве? Подесите { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-out = Тражите сачуване пријаве? Подесите { -sync-brand-short-name } или их увезите.
about-logins-login-intro-heading-logged-in = Нису пронађене синхронизоване пријаве.
login-intro-description = Уколико сте пријаве сачували у програму { -brand-product-name } на неком другом уређају, следите ове кораке:
login-intro-instruction-fxa = Направите или се пријавите на ваш { -fxaccount-brand-name } налог, на уређају где су ваше пријаве сачуване
login-intro-instruction-fxa-settings = Уверите се да сте штиклирали „Пријаве“ { -sync-brand-short-name } подешавањима
about-logins-intro-instruction-help = Посетите <a data-l10n-name="help-link">страницу подршке за { -lockwise-brand-short-name }</a>
about-logins-intro-import = Ако су ваше пријаве сачуване у другом прегледачу, можете да их <a data-l10n-name="import-link">увезете у { -lockwise-brand-short-name }</a>

about-logins-intro-import2 = Ако сте сачували своје пријаве изван { -brand-product-name }-а, можете их <a data-l10n-name="import-browser-link">увести из другог прегледача</a> или <a data-l10n-name="import-file-link">из датотеке</a>

## Login

login-item-new-login-title = Направите нову пријаву
login-item-edit-button = Уреди
about-logins-login-item-remove-button = Уклони
login-item-origin-label = Адреса веб странице
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Корисничко име
about-logins-login-item-username =
    .placeholder = (без корисничког имена)
login-item-copy-username-button-text = Копирај
login-item-copied-username-button-text = Копирано!
login-item-password-label = Лозинка
login-item-password-reveal-checkbox =
    .aria-label = Прикажи лозинку
login-item-copy-password-button-text = Копирај
login-item-copied-password-button-text = Копирано!
login-item-save-changes-button = Сачувај промене
login-item-save-new-button = Сачувај
login-item-cancel-button = Откажи
login-item-time-changed = Последња измена: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Направљено: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Последњи пут коришћено: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Да бисте уредили пријаву, унесите ваше податке за пријаву у Windows. Ово помаже у заштити ваших налога.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = уредите сачувану пријаву

# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Да бисте видели лозинку, унестие ваше податке за пријаву у Windows. Ово помаже у заштити ваших налога.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = откријте сачувану лозинку

# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Да бисте копирали лозинку, унесите ваше податке за пријаву у Windows. Ово помаже у заштити ваших налога.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = копирајте сачувану лозинку

## Master Password notification

master-password-notification-message = Унесите своју главну лозинку да бисте видели сачуване пријаве и лозинке

# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Да бисте извезли ваше пријаве, унесите ваше Windows податке за пријаву. Ово помаже у заштити ваших налога.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = извезите сачуване пријаве и лозинке

## Primary Password notification

about-logins-primary-password-notification-message = Унесите вашу главну лозинку да бисте видели сачуване пријаве и лозинке
master-password-reload-button =
    .label = Пријава
    .accesskey = L

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Желите да синхронизујете своје пријаве на другим уређајима са { -brand-product-name }? Идите на { -sync-brand-short-name } подешавања и потврдите избор Пријаве.
       *[other] Желите да синхронизујете своје пријаве на другим уређајима са { -sync-brand-short-name }? Идите на { -sync-brand-short-name } подешавања и потврдите избор Пријаве.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Посетите { -sync-brand-short-name } опције
           *[other] Посетите { -sync-brand-short-name } подешавања
        }
    .accesskey = V
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Не питај ме поново
    .accesskey = D

## Dialogs

confirmation-dialog-cancel-button = Откажи
confirmation-dialog-dismiss-button =
    .title = Откажи

about-logins-confirm-remove-dialog-title = Уклонити ову пријаву?
confirm-delete-dialog-message = Ова радња се не може опозвати.
about-logins-confirm-remove-dialog-confirm-button = Уклони

about-logins-confirm-export-dialog-title = Извезите пријаве и лозинке
about-logins-confirm-export-dialog-message = Ваше лозинке ће бити сачуване као читљив текст (нпр. BadP@ssw0rd) тако да може погледати свако ко може да отвори извезену датотеку.
about-logins-confirm-export-dialog-confirm-button = Извоз…

confirm-discard-changes-dialog-title = Одбацити несачуване измене?
confirm-discard-changes-dialog-message = Све несачуване измене ће бити изгубљене.
confirm-discard-changes-dialog-confirm-button = Одбаци

## Breach Alert notification

about-logins-breach-alert-title = Страница која цури податке
breach-alert-text = Лозинке на овој веб страници су украдене или јавно објављене од последњег пута када сте ажурирали податке за пријаву. Промените лозинку да бисте заштитили свој налог.
about-logins-breach-alert-date = Ово цурење података се десило { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Идите на { $hostname }
about-logins-breach-alert-learn-more-link = Сазнајте више

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Рањива лозинка
about-logins-vulnerable-alert-text2 = Ова се лозинка већ користи за налог вероватно угрожен цурењем података. Поновна употреба акредитива доводи у ризик све ваше налоге. Промените ову лозинку.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Идите на { $hostname }
about-logins-vulnerable-alert-learn-more-link = Сазнајте више

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Унос { $loginTitle } са овим корисничким именом већ постоји. <a data-l10n-name="duplicate-link">Идите на постојећи унос?</a>

# This is a generic error message.
about-logins-error-message-default = Дошло је до грешке приликом покушаја чувања лозинке.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Извези датотеке пријаве
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Извоз
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV документ
       *[other] CSV датотека
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Увези пријавну датотеку
about-logins-import-file-picker-import-button = Увези
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] CSV документ
       *[other] CSV датотека
    }
