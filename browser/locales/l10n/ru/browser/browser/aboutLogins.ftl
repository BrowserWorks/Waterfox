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
fxaccounts-sign-in-sync-button = Войти в Синхронизацию
fxaccounts-avatar-button =
    .title = Управление аккаунтом

## The ⋯ menu that is in the top corner of the page

menu =
    .title = Открыть меню
# This menuitem is only visible on Windows and macOS
about-logins-menu-menuitem-import-from-another-browser = Импорт из другого браузера…
about-logins-menu-menuitem-import-from-a-file = Импорт из файла…
about-logins-menu-menuitem-export-logins = Экспорт логинов…
about-logins-menu-menuitem-remove-all-logins = Удалить все логины…
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
about-logins-login-intro-heading-logged-out2 = Ищете сохранённые логины? Включите синхронизацию или импортируйте их.
about-logins-login-intro-heading-logged-in = Синхронизированных логинов не найдено.
login-intro-description = Если вы сохранили ваши логины в { -brand-product-name } на другом устройстве, то вот как получить к ним доступ здесь:
login-intro-instruction-fxa = Создайте или войдите в ваш { -fxaccount-brand-name } на устройстве, где сохранены ваши логины
login-intro-instruction-fxa-settings = Убедитесь, что вы установили флажок «Логины» в настройках { -sync-brand-short-name(case: "genitive") }
about-logins-intro-instruction-help = Посетите <a data-l10n-name="help-link">Поддержку { -lockwise-brand-short-name }</a> для получения помощи
login-intro-instructions-fxa = Создайте или войдите в ваш { -fxaccount-brand-name } на устройстве, где сохранены ваши логины
login-intro-instructions-fxa-settings = Выберите «Настройки» > «Синхронизация» > «Включить синхронизацию…». Установите флажок «Логины и пароли».
login-intro-instructions-fxa-help = Посетите <a data-l10n-name="help-link">Поддержку { -lockwise-brand-short-name }</a> для получения помощи.
about-logins-intro-import = Если ваши логины сохранены в другом браузере, вы можете <a data-l10n-name="import-link">импортировать их в { -lockwise-brand-short-name }</a>
about-logins-intro-import2 = Если ваши логины сохранены не в { -brand-product-name }, вы можете <a data-l10n-name="import-browser-link">импортировать их из другого браузера</a> или <a data-l10n-name="import-file-link">из файла</a>

## Login

login-item-new-login-title = Создать новый логин
login-item-edit-button = Изменить
about-logins-login-item-remove-button = Удалить
login-item-origin-label = Адрес веб-сайта
login-item-tooltip-message = Проверьте, что он действительно соответствует адресу веб-сайта, на который вы входите.
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
confirm-delete-dialog-message = Это действие нельзя отменить.
about-logins-confirm-remove-dialog-confirm-button = Удалить
about-logins-confirm-remove-all-dialog-confirm-button-label =
    { $count ->
        [1] Удалить
        [one] Удалить все
        [few] Удалить все
       *[many] Удалить все
    }
about-logins-confirm-remove-all-dialog-checkbox-label =
    { $count ->
        [1] Да, удалить этот логин
        [one] Да, удалить эти логины
        [few] Да, удалить эти логины
       *[many] Да, удалить эти логины
    }
about-logins-confirm-remove-all-dialog-title =
    { $count ->
        [one] Сохранён { $count } логин. Удалить их все?
        [few] Сохранено { $count } логина. Удалить их все?
       *[many] Сохранено { $count } логинов. Удалить их все?
    }
about-logins-confirm-remove-all-dialog-message =
    { $count ->
        [1] Это приведет к удалению логина, сохранённого вами в { -brand-short-name }, и всех предупреждений об утечках, появляющихся здесь. Вы не сможете отменить это действие.
        [one] Это приведет к удалению всех логинов, сохранённых вами в { -brand-short-name }, и всех предупреждений об утечках, появляющихся здесь. Вы не сможете отменить это действие.
        [few] Это приведет к удалению всех логинов, сохранённых вами в { -brand-short-name }, и всех предупреждений об утечках, появляющихся здесь. Вы не сможете отменить это действие.
       *[many] Это приведет к удалению всех логинов, сохранённых вами в { -brand-short-name }, и всех предупреждений об утечках, появляющихся здесь. Вы не сможете отменить это действие.
    }
about-logins-confirm-remove-all-sync-dialog-title =
    { $count ->
        [one] Сохранён { $count } логин. Удалить их все со всех устройств?
        [few] Сохранено { $count } логина. Удалить их все со всех устройств?
       *[many] Сохранено { $count } логинов. Удалить их все со всех устройств?
    }
about-logins-confirm-remove-all-sync-dialog-message =
    { $count ->
        [1] Это приведет к удалению логина, сохранённого вами в { -brand-short-name } на всех устройствах, синхронизируемых с вашим { -fxaccount-brand-name(case: "instrumental") }. Также будут удалены появляющиеся здесь предупреждения об утечках. Вы не сможете отменить это действие.
        [one] Это приведет к удалению всех логинов, сохранённых вами в { -brand-short-name } на всех устройствах, синхронизируемых с вашим { -fxaccount-brand-name(case: "instrumental") }. Также будут удалены появляющиеся здесь предупреждения об утечках. Вы не сможете отменить это действие.
        [few] Это приведет к удалению всех логинов, сохранённых вами в { -brand-short-name } на всех устройствах, синхронизируемых с вашим { -fxaccount-brand-name(case: "instrumental") }. Также будут удалены появляющиеся здесь предупреждения об утечках. Вы не сможете отменить это действие.
       *[many] Это приведет к удалению всех логинов, сохранённых вами в { -brand-short-name } на всех устройствах, синхронизируемых с вашим { -fxaccount-brand-name(case: "instrumental") }. Также будут удалены появляющиеся здесь предупреждения об утечках. Вы не сможете отменить это действие.
    }
about-logins-confirm-export-dialog-title = Экспорт логинов и паролей
about-logins-confirm-export-dialog-message = Ваши пароли будут сохранены в виде читаемого текста (например, BadP@ssw0rd), поэтому любой, кто может открыть файл с ними, сможет их просмотреть.
about-logins-confirm-export-dialog-confirm-button = Экспортировать…
about-logins-alert-import-title = Импорт завершён
about-logins-alert-import-message = Посмотреть подробную сводку импорта
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
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
about-logins-import-file-picker-tsv-filter-title =
    { PLATFORM() ->
        [macos] Документ TSV
       *[other] TSV-файл
    }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-dialog-title = Импорт завершён
about-logins-import-dialog-items-added =
    { $count ->
        [one] <span>Добавлены новые логины:</span> <span data-l10n-name="count">{ $count }</span>
        [few] <span>Добавлены новые логины:</span> <span data-l10n-name="count">{ $count }</span>
       *[many] <span>Добавлены новые логины:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-modified =
    { $count ->
        [one] <span>Обновлены существующие логины:</span> <span data-l10n-name="count">{ $count }</span>
        [few] <span>Обновлены существующие логины:</span> <span data-l10n-name="count">{ $count }</span>
       *[many] <span>Обновлены существующие логины:</span> <span data-l10n-name="count">{ $count }</span>
    }
about-logins-import-dialog-items-no-change =
    { $count ->
        [one] <span>Найдены повторяющие логины:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(не импортирован)</span>
        [few] <span>Найдены повторяющие логины:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(не импортированы)</span>
       *[many] <span>Найдены повторяющие логины:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(не импортированы)</span>
    }
about-logins-import-dialog-items-error =
    { $count ->
        [one] <span>Ошибки:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(не импортирован)</span>
        [few] <span>Ошибки:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(не импортированы)</span>
       *[many] <span>Ошибки:</span> <span data-l10n-name="count">{ $count }</span> <span data-l10n-name="meta">(не импортированы)</span>
    }
about-logins-import-dialog-done = Готово
about-logins-import-dialog-error-title = Ошибка импорта
about-logins-import-dialog-error-conflicting-values-title = Несколько конфликтующих учётных данных для одного логина
about-logins-import-dialog-error-conflicting-values-description = Например: несколько имён пользователей, паролей, URL для одного логина.
about-logins-import-dialog-error-file-format-title = Неверный формат файла
about-logins-import-dialog-error-file-format-description = Неверные или отсутствующие заголовки столбцов. Проверьте, что в файле действительно содержатся колонки для имени пользователя, пароля и URL.
about-logins-import-dialog-error-file-permission-title = Не удалось прочитать файл
about-logins-import-dialog-error-file-permission-description = { -brand-short-name } не имеет прав на чтение файла. Попробуйте сменить разрешения для файла.
about-logins-import-dialog-error-unable-to-read-title = Не удалось обработать файл
about-logins-import-dialog-error-unable-to-read-description = Проверьте, что вы действительно выбрали CSV- или TSV-файл.
about-logins-import-dialog-error-no-logins-imported = Ни один логин не импортирован
about-logins-import-dialog-error-learn-more = Подробнее
about-logins-import-dialog-error-try-again = Повторить…
about-logins-import-dialog-error-try-import-again = Повторить попытку импорта…
about-logins-import-dialog-error-cancel = Отмена
about-logins-import-report-title = Сводка импорта
about-logins-import-report-description = Логины и пароли, импортированные в { -brand-short-name }.
#
# Variables:
#  $number (number) - The number of the row
about-logins-import-report-row-index = Строка { $number }
about-logins-import-report-row-description-no-change = Дубликат: Такой логин уже существует
about-logins-import-report-row-description-modified = Существующий логин обновлен
about-logins-import-report-row-description-added = Новый логин добавлен
about-logins-import-report-row-description-error = Ошибка: Отсутствует поле

##
## Variables:
##  $field (String) - The name of the field from the CSV file for example url, username or password

about-logins-import-report-row-description-error-multiple-values = Ошибка: Несколько значений для { $field }
about-logins-import-report-row-description-error-missing-field = Ошибка: Отсутствует { $field }

##
## Variables:
##  $count (number) - The number of affected elements

about-logins-import-report-added =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">новый логин добавлен</div>
        [few] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">новых логина добавлено</div>
       *[many] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">новых логинов добавлено</div>
    }
about-logins-import-report-modified =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">существующий логин обновлён</div>
        [few] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">существующих логина обновлено</div>
       *[many] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">существующих логинов обновлено</div>
    }
about-logins-import-report-no-change =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">повторяющийся логин</div> <div data-l10n-name="not-imported">(не импортировано)</div>
        [few] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">повторяющихся логина</div> <div data-l10n-name="not-imported">(не импортировано)</div>
       *[many] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">повторяющихся логинов</div> <div data-l10n-name="not-imported">(не импортировано)</div>
    }
about-logins-import-report-error =
    { $count ->
        [one] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">ошибка</div> <div data-l10n-name="not-imported">(не импортировано)</div>
        [few] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">ошибки</div> <div data-l10n-name="not-imported">(не импортировано)</div>
       *[many] <div data-l10n-name="count">{ $count }</div> <div data-l10n-name="details">ошибок</div> <div data-l10n-name="not-imported">(не импортировано)</div>
    }

## Logins import report page

about-logins-import-report-page-title = Сводный отчет об импорте
