# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Регистрации и пароли

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Вземете паролите си навсякъде
login-app-promo-subtitle = Изтеглете свободното приложение { -lockwise-brand-name }
login-app-promo-android =
    .alt = Изтеглете от Google Play
login-app-promo-apple =
    .alt = Изтеглете от App Store

login-filter =
    .placeholder = Търсене на регистрация

create-login-button = Нова регистрация

fxaccounts-sign-in-text = Вземете паролите си на всички ваши устройства
fxaccounts-sign-in-button = Вписване в { -sync-brand-short-name }
fxaccounts-avatar-button =
    .title = Управление на сметката

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Отваря менюто
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Внасяне от друг мрежов четец…
about-logins-menu-menuitem-export-logins = Изнасяне на регистрации…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Настройки
       *[other] Настройки
    }
about-logins-menu-menuitem-help = Помощ
menu-menuitem-android-app = { -lockwise-brand-short-name } за Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } за iPhone и iPad

## Login List

login-list =
    .aria-label = Регистрации, отговарящи на търсеното
login-list-count =
    { $count ->
        [one] { $count } регистрация
       *[other] { $count } регистрации
    }
login-list-sort-label-text = Подреждане по:
login-list-name-option = Име (A-Z)
login-list-name-reverse-option = Име (Z-A)
about-logins-login-list-alerts-option = Предупреждения
login-list-last-changed-option = Последна промяна
login-list-last-used-option = Последно използване
login-list-intro-title = Няма намерени регистрации
login-list-intro-description = Като запазите парола в { -brand-product-name }, тя ще се покаже тук.
about-logins-login-list-empty-search-title = Няма намерени регистрации
about-logins-login-list-empty-search-description = Няма резултати, отговарящи на търсенето.
login-list-item-title-new-login = Нова регистрация
login-list-item-subtitle-new-login = Въведете данните за вход
login-list-item-subtitle-missing-username = (без потребителско име)
about-logins-list-item-breach-icon =
    .title = Взломена страница
about-logins-list-item-vulnerable-password-icon =
    .title = Уязвима парола

## Introduction screen

login-intro-heading = Търсите запазените си данни за вход? Настройте { -sync-brand-short-name }.

about-logins-login-intro-heading-logged-in = Не са намерени синхронизирани регистрации.
login-intro-description = Ако сте запазили данните си за вход в { -brand-product-name } на друго устройство, ето как да ги вземете тук:
login-intro-instruction-fxa = Създайте или влезте в своята { -fxaccount-brand-name } на устройството, където са запазени вашите данни за вход
login-intro-instruction-fxa-settings = Уверете се, че сте отметнали квадратчето за входни данни в настройките на { -sync-brand-short-name }
about-logins-intro-instruction-help = Посетете <a data-l10n-name="help-link">Поддръжка за { -lockwise-brand-short-name }</a> за повече помощ.
about-logins-intro-import = Ако вашите регистрации са запазени в друг мрежов четец, можете да ги <a data-l10n-name="import-link">внесете във { -lockwise-brand-short-name }</a>.

## Login

login-item-new-login-title = Нова регистрация
login-item-edit-button = Променяне
about-logins-login-item-remove-button = Премахване
login-item-origin-label = Адрес на страницата
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Потребителско име
about-logins-login-item-username =
    .placeholder = (без потребителско име)
login-item-copy-username-button-text = Копиране
login-item-copied-username-button-text = Копирано!
login-item-password-label = Парола
login-item-password-reveal-checkbox =
    .aria-label = Показване на паролата
login-item-copy-password-button-text = Копиране
login-item-copied-password-button-text = Копирано!
login-item-save-changes-button = Запазване
login-item-save-new-button = Запазване
login-item-cancel-button = Отказ
login-item-time-changed = Последна промяна: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Създадване: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Последна употреба: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = промени данни за вход

# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = разкрие запазена парола

# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = копира запазена парола

## Master Password notification

master-password-notification-message = Моля, въведете главната си парола, за да видите запазените входни данни и пароли

## Primary Password notification

master-password-reload-button =
    .label = Вписване
    .accesskey = в

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Искате вашите данни за вход навсякъде, където използвате { -brand-product-name }? Отворете настройките на { -sync-brand-short-name } и изберете отметката пред „данни за вход“.
       *[other] Искате вашите данни за вход навсякъде, където използвате { -brand-product-name }? Отворете настройките на { -sync-brand-short-name } и изберете отметката пред „данни за вход“.
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Настройки на { -sync-brand-short-name }
           *[other] Настройки на { -sync-brand-short-name }
        }
    .accesskey = т
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Спиране на този въпрос
    .accesskey = п

## Dialogs

confirmation-dialog-cancel-button = Отказ
confirmation-dialog-dismiss-button =
    .title = Отказ

about-logins-confirm-remove-dialog-title = Изтриване на регистрацията?
confirm-delete-dialog-message = Действието е необратимо.
about-logins-confirm-remove-dialog-confirm-button = Премахване

about-logins-confirm-export-dialog-title = Изнасяне на регистрации и пароли
about-logins-confirm-export-dialog-message = Вашите пароли ще бъдат запазени като четим текст (например Лош@Пар0ла), така че всеки, който има достъп до изнесения файл ще може да ги види.
about-logins-confirm-export-dialog-confirm-button = Изнасяне…

confirm-discard-changes-dialog-title = Отказвате се от промените?
confirm-discard-changes-dialog-message = Незапазените промени ще бъдат изгубени.
confirm-discard-changes-dialog-confirm-button = Отхвърляне

## Breach Alert notification

about-logins-breach-alert-title = Пробив в страница
breach-alert-text = Паролите са изтекли или откраднати от този уебсайт, откакто последно сте обновили данните си за вход. Променете паролата си, за да защитите сметката си.
about-logins-breach-alert-date = Пробивът е станал на { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Отидете на { $hostname }
about-logins-breach-alert-learn-more-link = Научете повече

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Уязвима парола
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Към { $hostname }
about-logins-vulnerable-alert-learn-more-link = Научете повече

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Запис за { $loginTitle } с това потребителско име вече съществува. <a data-l10n-name="duplicate-link">Преглед на записа.</a>

# This is a generic error message.
about-logins-error-message-default = Възникна грешка при опита за запазване на тази парола.


## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Изнасяне на регистрации
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = logins.csv
about-logins-export-file-picker-export-button = Изнасяне
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Документ на CSV
       *[other] Файл на CSV
    }

## Login Import Dialog

