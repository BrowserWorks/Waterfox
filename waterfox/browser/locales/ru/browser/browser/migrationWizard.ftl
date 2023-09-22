# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

migration-wizard-selection-header = Импорт данных браузера
migration-wizard-selection-list = Выберите данные, которые хотите импортировать.
# Shown in the new migration wizard's dropdown selector for choosing the browser
# to import from. This variant is shown when the selected browser doesn't support
# user profiles, and so we only show the browser name.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
migration-wizard-selection-option-without-profile = { $sourceBrowser }
# Shown in the new migration wizard's dropdown selector for choosing the browser
# and user profile to import from. This variant is shown when the selected browser
# supports user profiles.
#
# Variables:
#  $sourceBrowser (String): the name of the browser to import from.
#  $profileName (String): the name of the user profile to import from.
migration-wizard-selection-option-with-profile = { $sourceBrowser } — { $profileName }

# Each migrator is expected to include a display name string, and that display
# name string should have a key with "migration-wizard-migrator-display-name-"
# as a prefix followed by the unique identification key for the migrator.

migration-wizard-migrator-display-name-brave = Brave
migration-wizard-migrator-display-name-canary = Chrome Canary
migration-wizard-migrator-display-name-chrome = Chrome
migration-wizard-migrator-display-name-chrome-beta = Chrome Бета
migration-wizard-migrator-display-name-chrome-dev = Chrome Dev
migration-wizard-migrator-display-name-chromium = Chromium
migration-wizard-migrator-display-name-chromium-360se = 360 Secure Browser
migration-wizard-migrator-display-name-chromium-edge = Microsoft Edge
migration-wizard-migrator-display-name-chromium-edge-beta = Microsoft Edge Beta
migration-wizard-migrator-display-name-edge-legacy = Microsoft Edge Legacy
migration-wizard-migrator-display-name-firefox = Waterfox
migration-wizard-migrator-display-name-file-password-csv = Пароли из CSV-файла
migration-wizard-migrator-display-name-file-bookmarks = Закладки из HTML-файла
migration-wizard-migrator-display-name-ie = Microsoft Internet Explorer
migration-wizard-migrator-display-name-opera = Opera
migration-wizard-migrator-display-name-opera-gx = Opera GX
migration-wizard-migrator-display-name-safari = Safari
migration-wizard-migrator-display-name-vivaldi = Vivaldi

## These strings will be displayed based on how many resources are selected to import

migration-all-available-data-label = Импортировать все доступные данные
migration-no-selected-data-label = Не выбраны данные для импорта
migration-selected-data-label = Импортировать выбранные данные

##

migration-select-all-option-label = Выбрать все
migration-bookmarks-option-label = Закладки
# Favorites is used for Bookmarks when importing from Internet Explorer or
# Edge, as this is the terminology for bookmarks on those browsers.
migration-favorites-option-label = Избранное
migration-logins-and-passwords-option-label = Сохранённые логины и пароли
migration-history-option-label = Журнал посещений
migration-extensions-option-label = Расширения
migration-form-autofill-option-label = Данные автозаполнения форм
migration-payment-methods-option-label = Способы оплаты
migration-cookies-option-label = Куки
migration-session-option-label = Окна и вкладки
migration-otherdata-option-label = Другие данные
migration-passwords-from-file-progress-header = Импорт паролей из файла
migration-passwords-from-file-success-header = Пароли успешно импортированы
migration-passwords-from-file = Проверка файла на наличие паролей
migration-passwords-new = Новые пароли
migration-passwords-updated = Существующие пароли
migration-passwords-from-file-no-valid-data = Файл не содержит корректных данных о паролях. Выберите другой файл.
migration-passwords-from-file-picker-title = Импорт паролей из файла
# A description for the .csv file format that may be shown as the file type
# filter by the operating system.
migration-passwords-from-file-csv-filter-title =
    { PLATFORM() ->
        [macos] Документ CSV
       *[other] CSV-файл
    }
# A description for the .tsv file format that may be shown as the file type
# filter by the operating system. TSV is short for 'tab separated values'.
migration-passwords-from-file-tsv-filter-title =
    { PLATFORM() ->
        [macos] Документ TSV
       *[other] TSV-файл
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if new passwords were added.
#
# Variables:
#  $newEntries (Number): the number of new successfully imported passwords
migration-wizard-progress-success-new-passwords =
    { $newEntries ->
        [one] { $newEntries } добавлен
        [few] { $newEntries } добавлено
       *[many] { $newEntries } добавлено
    }
# Shown in the migration wizard after importing passwords from a file
# has completed, if existing passwords were updated.
#
# Variables:
#  $updatedEntries (Number): the number of updated passwords
migration-wizard-progress-success-updated-passwords =
    { $updatedEntries ->
        [one] { $updatedEntries } обновлён
        [few] { $updatedEntries } обновлено
       *[many] { $updatedEntries } обновлено
    }
migration-bookmarks-from-file-picker-title = Импорт файла закладок
migration-bookmarks-from-file-progress-header = Импорт закладок
migration-bookmarks-from-file = Закладки
migration-bookmarks-from-file-success-header = Закладки успешно импортированы
migration-bookmarks-from-file-no-valid-data = Файл не содержит никаких данных о закладках. Выберите другой файл.
# A description for the .html file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-html-filter-title =
    { PLATFORM() ->
        [macos] HTML-документ
       *[other] HTML-файл
    }
# A description for the .json file format that may be shown as the file type
# filter by the operating system.
migration-bookmarks-from-file-json-filter-title = JSON-файл
# Shown in the migration wizard after importing bookmarks from a file
# has completed.
#
# Variables:
#  $newEntries (Number): the number of imported bookmarks.
migration-wizard-progress-success-new-bookmarks =
    { $newEntries ->
        [one] { $newEntries } закладка
        [few] { $newEntries } закладки
       *[many] { $newEntries } закладок
    }
migration-import-button-label = Импорт
migration-choose-to-import-from-file-button-label = Импортировать из файла
migration-import-from-file-button-label = Выберите файл
migration-cancel-button-label = Отмена
migration-done-button-label = Готово
migration-continue-button-label = Продолжить
migration-wizard-import-browser-no-browsers = { -brand-short-name } не удалось найти ни одной программы, содержащей данные о закладках, истории или паролях.
migration-wizard-import-browser-no-resources = Произошла ошибка. { -brand-short-name } не смог найти данные для импорта из этого профиля браузера.

## These strings will be used to create a dynamic list of items that can be
## imported. The list will be created using Intl.ListFormat(), so it will
## follow each locale's rules, and the first item will be capitalized by code.
## When applicable, the resources should be in their plural form.
## For example, a possible list could be "Bookmarks, passwords and autofill data".

migration-list-bookmark-label = закладки
# “favorites” refers to bookmarks in Edge and Internet Explorer. Use the same terminology
# if the browser is available in your language.
migration-list-favorites-label = избранное
migration-list-password-label = пароли
migration-list-history-label = история
migration-list-extensions-label = расширения
migration-list-autofill-label = данные автозаполнения
migration-list-payment-methods-label = способы оплаты

##

migration-wizard-progress-header = Импорт данных
# This header appears in the final page of the migration wizard only if
# all resources were imported successfully.
migration-wizard-progress-done-header = Данные успешно импортированы
# This header appears in the final page of the migration wizard if only
# some of the resources were imported successfully. This is meant to be
# distinct from migration-wizard-progress-done-header, which is only shown
# if all resources were imported successfully.
migration-wizard-progress-done-with-warnings-header = Импорт данных завершен
migration-wizard-progress-icon-in-progress =
    .aria-label = Идёт импорт…
migration-wizard-progress-icon-completed =
    .aria-label = Завершено
migration-safari-password-import-header = Импорт паролей из Safari
migration-safari-password-import-steps-header = Чтобы импортировать пароли Safari:
migration-safari-password-import-step1 = В Safari откройте меню «Safari» и перейдите в «Настройки» > «Пароли».
migration-safari-password-import-step2 = Нажмите кнопку <img data-l10n-name="safari-icon-3dots"/> и выберите «Экспорт всех паролей».
migration-safari-password-import-step3 = Сохраните файл паролей
migration-safari-password-import-step4 = Используйте «Выберите файл» ниже, чтобы выбрать файл паролей, который вы сохранили.
migration-safari-password-import-skip-button = Пропустить
migration-safari-password-import-select-button = Выберите файл
# Shown in the migration wizard after importing bookmarks from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-bookmarks =
    { $quantity ->
        [one] { $quantity } закладка
        [few] { $quantity } закладки
       *[many] { $quantity } закладок
    }
# Shown in the migration wizard after importing bookmarks from either
# Internet Explorer or Edge.
#
# Use the same terminology if the browser is available in your language.
#
# Variables:
#  $quantity (Number): the number of successfully imported bookmarks
migration-wizard-progress-success-favorites =
    { $quantity ->
        [one] { $quantity } избранное
        [few] { $quantity } избранных
       *[many] { $quantity } избранных
    }

## The import process identifies extensions installed in other supported
## browsers and installs the corresponding (matching) extensions compatible
## with Waterfox, if available.

# Shown in the migration wizard after importing all matched extensions
# from supported browsers.
#
# Variables:
#   $quantity (Number): the number of successfully imported extensions
migration-wizard-progress-success-extensions =
    { $quantity ->
        [one] { $quantity } расширение
        [few] { $quantity } расширения
       *[many] { $quantity } расширений
    }
# Shown in the migration wizard after importing a partial amount of
# matched extensions from supported browsers.
#
# Variables:
#   $matched (Number): the number of matched imported extensions
#   $quantity (Number): the number of total extensions found during import
migration-wizard-progress-partial-success-extensions = { $matched } из { $quantity } расширений
migration-wizard-progress-extensions-support-link = Узнайте, как { -brand-product-name } проверяет расширения на совместимость
# Shown in the migration wizard if there are no matched extensions
# on import from supported browsers.
migration-wizard-progress-no-matched-extensions = Нет подходящих расширений
migration-wizard-progress-extensions-addons-link = Просмотрите расширения для { -brand-short-name }

##

# Shown in the migration wizard after importing passwords from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported passwords
migration-wizard-progress-success-passwords =
    { $quantity ->
        [one] { $quantity } пароль
        [few] { $quantity } пароля
       *[many] { $quantity } паролей
    }
# Shown in the migration wizard after importing history from another
# browser has completed.
#
# Variables:
#  $maxAgeInDays (Number): the maximum number of days of history that might be imported.
migration-wizard-progress-success-history =
    { $maxAgeInDays ->
        [one] За последний { $maxAgeInDays } день
        [few] За последние { $maxAgeInDays } дня
       *[many] За последние { $maxAgeInDays } дней
    }
migration-wizard-progress-success-formdata = Журнал форм
# Shown in the migration wizard after importing payment methods from another
# browser has completed.
#
# Variables:
#  $quantity (Number): the number of successfully imported payment methods
migration-wizard-progress-success-payment-methods =
    { $quantity ->
        [one] { $quantity } способ оплаты
        [few] { $quantity } способа оплаты
       *[many] { $quantity } способов оплаты
    }
migration-wizard-safari-permissions-sub-header = Чтобы импортировать закладки Safari и журнал посещённых страниц:
migration-wizard-safari-instructions-continue = Нажмите «Продолжить»
migration-wizard-safari-instructions-folder = Выберите папку Safari в списке и нажмите «Открыть».
