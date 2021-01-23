# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
# NOTE: New strings should use the about-logins- prefix.

about-logins-page-title = Логины и пароли

# "Google Play" and "App Store" are both branding and should not be translated

login-app-promo-title = Возьмите свои пароли с собой
login-app-promo-subtitle = Загрузите бесплатное приложение { -lockwise-brand-name }
login-app-promo-android =
    .alt = Доступно в Google Play
login-app-promo-apple =
    .alt = Загрузите в App Store
login-filter =
    .placeholder = Поиск логинов
create-login-button = Создать новый логин
fxaccounts-sign-in-text = Получайте доступ к своим паролям на других устройствах
fxaccounts-sign-in-button = Войти в { -sync-brand-short-name(case: "accusative") }
fxaccounts-avatar-button =
    .title = Управление аккаунтом

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Открыть меню
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Импорт из другого браузера…
about-logins-menu-menuitem-import-from-a-file = Импорт из файла…
about-logins-menu-menuitem-export-logins = Экспорт логинов…
menu-menuitem-preferences =
    { PLATFORM() ->
        [windows] Настройки
       *[other] Настройки
    }
about-logins-menu-menuitem-help = Помощь
menu-menuitem-android-app = { -lockwise-brand-short-name } для Android
menu-menuitem-iphone-app = { -lockwise-brand-short-name } для iPhone и iPad

## Login List

login-list =
    .aria-label = Логины, соответствующие поисковому запросу
login-list-count =
    { $count ->
        [one] { $count } логин
        [few] { $count } логина
       *[many] { $count } логинов
    }
login-list-sort-label-text = Сортировать:
login-list-name-option = По имени (А-Я)
login-list-name-reverse-option = По имени (Я-А)
about-logins-login-list-alerts-option = Уведомления
login-list-last-changed-option = По последнему изменению
login-list-last-used-option = По последнему использованию
login-list-intro-title = Логины не найдены
login-list-intro-description = Когда вы сохраните пароль в { -brand-product-name }, он появится здесь.
about-logins-login-list-empty-search-title = Логины не найдены
about-logins-login-list-empty-search-description = Результатов, подходящих под ваш запрос, не найдено
login-list-item-title-new-login = Новый логин
login-list-item-subtitle-new-login = Введите свои учётные данные
login-list-item-subtitle-missing-username = (нет имени пользователя)
about-logins-list-item-breach-icon =
    .title = Атакованный сайт
about-logins-list-item-vulnerable-password-icon =
    .title = Уязвимый пароль

## Introduction screen

login-intro-heading = Ищете сохранённые логины? Настройте { -sync-brand-short-name(case: "accusative") }.
about-logins-login-intro-heading-logged-out = Ищете сохранённые логины? Настройте { -sync-brand-short-name(case: "accusative") } или импортируйте их.
about-logins-login-intro-heading-logged-in = Синхронизированных логинов не найдено.
login-intro-description = Если вы сохранили ваши логины в { -brand-product-name } на другом устройстве, то вот как получить к ним доступ здесь:
login-intro-instruction-fxa = Создайте или войдите в ваш { -fxaccount-brand-name } на устройстве, где сохранены ваши логины
login-intro-instruction-fxa-settings = Убедитесь, что вы установили флажок «Логины» в настройках { -sync-brand-short-name(case: "genitive") }
about-logins-intro-instruction-help = Посетите <a data-l10n-name="help-link">Поддержку { -lockwise-brand-short-name }</a> для получения помощи
about-logins-intro-import = Если ваши логины сохранены в другом браузере, вы можете <a data-l10n-name="import-link">импортировать их в { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Если ваши логины сохранены не в { -brand-product-name }, вы можете <a data-l10n-name="import-browser-link">импортировать их из другого браузера</a> или <a data-l10n-name="import-file-link">из файла</a>

## Login

login-item-new-login-title = Создать новый логин
login-item-edit-button = Изменить
about-logins-login-item-remove-button = Удалить
login-item-origin-label = Адрес веб-сайта
login-item-origin =
    .placeholder = https://www.example.com
login-item-username-label = Имя пользователя
about-logins-login-item-username =
    .placeholder = (нет имени пользователя)
login-item-copy-username-button-text = Копировать
login-item-copied-username-button-text = Скопировано!
login-item-password-label = Пароль
login-item-password-reveal-checkbox =
    .aria-label = Показать пароль
login-item-copy-password-button-text = Копировать
login-item-copied-password-button-text = Скопировано!
login-item-save-changes-button = Сохранить изменения
login-item-save-new-button = Сохранить
login-item-cancel-button = Отмена
login-item-time-changed = Последнее изменение: { DATETIME($timeChanged, day: "numeric", month: "long", year: "numeric") }
login-item-time-created = Создан: { DATETIME($timeCreated, day: "numeric", month: "long", year: "numeric") }
login-item-time-used = Последнее использование: { DATETIME($timeUsed, day: "numeric", month: "long", year: "numeric") }

## OS Authentication dialog

about-logins-os-auth-dialog-caption = { -brand-full-name }

## The macOS strings are preceded by the operating system with "Firefox is trying to "
## and includes subtitle of "Enter password for the user "xxx" to allow this." These
## notes are only valid for English. Please test in your respected locale.

# This message can be seen when attempting to edit a login in about:logins on Windows.
about-logins-edit-login-os-auth-dialog-message-win = Чтобы изменить свой логин, введите ваши учётные данные для входа в Windows. Это поможет защитить безопасность ваших аккаунтов.
# This message can be seen when attempting to edit a login in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-edit-login-os-auth-dialog-message-macosx = изменить сохранённый логин
# This message can be seen when attempting to reveal a password in about:logins on Windows.
about-logins-reveal-password-os-auth-dialog-message-win = Чтобы просмотреть свой пароль, введите ваши учётные данные для входа в Windows. Это поможет защитить безопасность ваших аккаунтов.
# This message can be seen when attempting to reveal a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-reveal-password-os-auth-dialog-message-macosx = показать сохранённый пароль
# This message can be seen when attempting to copy a password in about:logins on Windows.
about-logins-copy-password-os-auth-dialog-message-win = Чтобы скопировать свой пароль введите ваши учётные данные для входа в Windows. Это поможет защитить безопасность ваших аккаунтов.
# This message can be seen when attempting to copy a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-copy-password-os-auth-dialog-message-macosx = скопировать сохранённый пароль

## Master Password notification

master-password-notification-message = Пожалуйста, введите ваш мастер-пароль для просмотра сохранённых логинов и паролей
# This message can be seen when attempting to export a password in about:logins on Windows.
about-logins-export-password-os-auth-dialog-message-win = Чтобы экспортировать свои логины, введите ваши учётные данные для входа в Windows. Это поможет защитить безопасность ваших аккаунтов.
# This message can be seen when attempting to export a password in about:logins
# On MacOS, only provide the reason that account verification is needed. Do not put a complete sentence here.
about-logins-export-password-os-auth-dialog-message-macosx = экспортировать сохранённые логины и пароли

## Primary Password notification

about-logins-primary-password-notification-message = Пожалуйста, введите ваш мастер-пароль для просмотра сохранённых логинов и паролей
master-password-reload-button =
    .label = Войти
    .accesskey = В

## Password Sync notification

enable-password-sync-notification-message =
    { PLATFORM() ->
        [windows] Хотите получать доступ к вашим логинам везде, где бы вы ни использовали { -brand-product-name }? Перейдите в настройки { -sync-brand-short-name(case: "genitive") } и выберите «Логины».
       *[other] Хотите получать доступ к вашим логинам везде, где бы вы ни использовали { -brand-product-name }? Перейдите в настройки { -sync-brand-short-name(case: "genitive") } и выберите «Логины».
    }
enable-password-sync-preferences-button =
    .label =
        { PLATFORM() ->
            [windows] Открыть настройки { -sync-brand-short-name(case: "genitive") }
           *[other] Открыть настройки { -sync-brand-short-name(case: "genitive") }
        }
    .accesskey = О
about-logins-enable-password-sync-dont-ask-again-button =
    .label = Не спрашивать в следующий раз
    .accesskey = е

## Dialogs

confirmation-dialog-cancel-button = Отмена
confirmation-dialog-dismiss-button =
    .title = Отмена
about-logins-confirm-remove-dialog-title = Удалить этот логин?
confirm-delete-dialog-message = Это действие не может быть отменено.
about-logins-confirm-remove-dialog-confirm-button = Удалить
about-logins-confirm-export-dialog-title = Экспорт логинов и паролей
about-logins-confirm-export-dialog-message = Ваши пароли будут сохранены в виде читаемого текста (например, BadP@ssw0rd), поэтому любой, кто может открыть файл с ними, сможет их просмотреть.
about-logins-confirm-export-dialog-confirm-button = Экспортировать…
confirm-discard-changes-dialog-title = Отменить несохранённые изменения?
confirm-discard-changes-dialog-message = Все несохранённые изменения будут потеряны.
confirm-discard-changes-dialog-confirm-button = Отменить

## Breach Alert notification

about-logins-breach-alert-title = Утечка на сайте
breach-alert-text = С момента последнего обновления данных для входа, с этого сайта произошла утечка или кража паролей. Измените ваш пароль, чтобы защитить свой аккаунт.
about-logins-breach-alert-date = Эта утечка случилась { DATETIME($date, day: "numeric", month: "long", year: "numeric") }
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-breach-alert-link = Перейти на { $hostname }
about-logins-breach-alert-learn-more-link = Подробнее

## Vulnerable Password notification

about-logins-vulnerable-alert-title = Уязвимый пароль
about-logins-vulnerable-alert-text2 = Этот пароль был использован в другом аккаунте, который, вероятно, подвергся утечке данных. Дальнейшее использование этих учетных данных ставит все ваши аккаунты под угрозу. Смените этот пароль.
# Variables:
#   $hostname (String) - The hostname of the website associated with the login, e.g. "example.com"
about-logins-vulnerable-alert-link = Перейти на { $hostname }
about-logins-vulnerable-alert-learn-more-link = Подробнее

## Error Messages

# This is an error message that appears when a user attempts to save
# a new login that is identical to an existing saved login.
# Variables:
#   $loginTitle (String) - The title of the website associated with the login.
about-logins-error-message-duplicate-login-with-link = Запись для { $loginTitle } с таким именем пользователя уже существует. <a data-l10n-name="duplicate-link">Перейти к существующей записи?</a>
# This is a generic error message.
about-logins-error-message-default = При попытке сохранить этот пароль произошла ошибка.

## Login Export Dialog

# Title of the file picker dialog
about-logins-export-file-picker-title = Экспорт файла логинов
# The default file name shown in the file picker when exporting saved logins.
# This must end in .csv
about-logins-export-file-picker-default-filename = логины.csv
about-logins-export-file-picker-export-button = Экспортировать
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-export-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Документ CSV
       *[other] CSV-файл
    }

## Login Import Dialog

# Title of the file picker dialog
about-logins-import-file-picker-title = Импорт файла логинов
about-logins-import-file-picker-import-button = Импортировать
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
about-logins-import-file-picker-csv-filter-title =
    { PLATFORM() ->
        [macos] Документ CSV
       *[other] CSV-файл
    }
