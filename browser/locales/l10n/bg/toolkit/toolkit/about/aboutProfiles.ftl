# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Относно профилите
profiles-subtitle = От тук може да управлявате вашите профили. Всеки профил е отделен свят, съдържащ отделна история, отметки, настройки и добавки.
profiles-create = Създаване на профил
profiles-restart-title = Рестартиране
profiles-restart-in-safe-mode = Рестартиране с изключени добавки…
profiles-restart-normal = Нормално рестартиране…
profiles-conflict = Друг екземпляр на { -brand-product-name } е направил промени в профилите. Трябва да рестартирате { -brand-short-name }, преди да продължите с промените.
profiles-flush-fail-title = Промените не са запазени
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Грешка попречи промените да бъдат запазени.
profiles-flush-restart-button = Рестартиране на { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Профил: { $name }
profiles-is-default = Стандартен профил
profiles-rootdir = Коренова папка

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Местна папка
profiles-current-profile = Това е текущият профил и не може да бъде премахнат.
profiles-in-use-profile = Профилът е използван от друго приложение и не може да бъде премахнат.

profiles-rename = Преименуване
profiles-remove = Премахване
profiles-set-as-default = Задаване като стандартен профил
profiles-launch-profile = Отваряне на четеца с профила

profiles-cannot-set-as-default-title = Грешка при задаване по подразбиране
profiles-cannot-set-as-default-message = Профилът по подразбиране на { -brand-short-name } не може да бъде променен.

profiles-yes = да
profiles-no = не

profiles-rename-profile-title = Преименуване на профил
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Ново име на профила „{ $name }“

profiles-invalid-profile-name-title = Неправилно име на профил
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = „{ $name }“ не може да бъде използвано за име на профил.

profiles-delete-profile-title = Изтриване на профил
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    При изтриване профилът ще бъде необратимо премахнат от списъка с налични профили.
    Може да изберете дали и файловете с данни на профила като настройки, сертификати и други потребителски данни също да бъдат премахнати. По този начин и папката „{ $dir }“ ще бъде необратимо премахната.
    Бихте ли желали файловете с данни на профила да бъдат премахнати?
profiles-delete-files = Премахване на файлове
profiles-dont-delete-files = Без премахване на файлове

profiles-delete-profile-failed-title = Грешка
profiles-delete-profile-failed-message = Грешка при изтриване на профила.


profiles-opendir =
    { PLATFORM() ->
        [macos] Показване във Finder
        [windows] Отваряне на папката
       *[other] Отваряне на папката
    }
