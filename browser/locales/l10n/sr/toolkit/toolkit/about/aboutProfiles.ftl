# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = О профилима
profiles-subtitle = Ова страница вам помаже да управљате профилима. Сваки профил је засебан свет који садржи засебну историју, језичке, поставке и додатке.
profiles-create = Направи нови профил
profiles-restart-title = Поново покрени
profiles-restart-in-safe-mode = Поново покрени са онемогућеним додацима…
profiles-restart-normal = Поново покрени као иначе…
profiles-conflict = Друга копија { -brand-product-name } је направила измене у профилима. Морате поново покренути { -brand-short-name } пре прављења нових измена.
profiles-flush-fail-title = Измене нису сачуване
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Неочекивана грешка спречила је да се измене сачувају.
profiles-flush-restart-button = Поново покрени { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Профил: { $name }
profiles-is-default = Подразумевани профил
profiles-rootdir = Основни директоријум

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Локални директоријум
profiles-current-profile = Овај профил се тренутно користи и не може бити обрисан.
profiles-in-use-profile = Овај профил се користи на другој апликацији и не може бити обрисан.

profiles-rename = Преименуј
profiles-remove = Уклони
profiles-set-as-default = Постави као подразумевани профил
profiles-launch-profile = Покрени профил у новом прегледачу

profiles-cannot-set-as-default-title = Није могуће поставити подразумевано
profiles-cannot-set-as-default-message = Подразумевани профил се не може мењати за { -brand-short-name }.

profiles-yes = да
profiles-no = не

profiles-rename-profile-title = Преименуј профил
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Преименуј профил { $name }

profiles-invalid-profile-name-title = Неисправно име профила
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Име профила "{ $name }" није дозвољено.

profiles-delete-profile-title = Обриши профил
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Брисање профила ће уклонити профил са листе доступних профила и не може да се опозове.
    Такође можете да обришете датотеке профила, укључујући ваше поставке, сертификате и остале корисничке податке. Ова опција ће обрисати фасциклу "{ $dir }" и не може да се опозове.
    Да ли желите да обришете датотеке профила?
profiles-delete-files = Обриши датотеке
profiles-dont-delete-files = Немој обрисати датотеке

profiles-delete-profile-failed-title = Грешка
profiles-delete-profile-failed-message = Дошло је до грешке приликом брисања овог профила.


profiles-opendir =
    { PLATFORM() ->
        [macos] Прикажи у Finder-у
        [windows] Отвори фасциклу
       *[other] Отвори директоријум
    }
