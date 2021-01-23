# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Аб профілях
profiles-subtitle = Гэта старонка дапаможа вам кіраваць вашымі профілямі. Кожны профіль уяўляе сабой асобны свет, які змяшчае асобную гісторыю, закладкі, налады і дадаткі.
profiles-create = Стварыць новы профіль
profiles-restart-title = Перазапусціць
profiles-restart-in-safe-mode = Перазапусціць з адключанымі дадаткамі...
profiles-restart-normal = Перазапусціць у звычайным рэжыме...
profiles-conflict = Іншы асобнік { -brand-product-name } унёс змены ў профіль. Неабходна перазапусціць { -brand-short-name } перш чым рабіць больш змяненняў.
profiles-flush-fail-title = Змены не захаваны
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Нечаканая памылка не дазволіла захаваць вашы змяненні.
profiles-flush-restart-button = Перазапусціць { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Профіль: { $name }
profiles-is-default = Прадвызначаны профіль
profiles-rootdir = Каранёвы каталог

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Лакальны каталог
profiles-current-profile = Гэты профіль зараз выкарыстоўваецца і не можа быць выдалены.
profiles-in-use-profile = Профіль выкарыстоўваецца ў іншай праграме і не можа быць выдалены.

profiles-rename = Перайменаваць
profiles-remove = Выдаліць
profiles-set-as-default = Зрабіць прадвызначаным профілем
profiles-launch-profile = Запусціць профіль у новым браўзеры

profiles-cannot-set-as-default-title = Не ўдалося зрабіць прадвызначаным
profiles-cannot-set-as-default-message = Немагчыма змяніць прадвызначаны профіль для { -brand-short-name }.

profiles-yes = так
profiles-no = не

profiles-rename-profile-title = Пераназваць профіль
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Пераназваць профіль { $name }

profiles-invalid-profile-name-title = Недапушчальная назва профіля
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Імя профілю “{ $name }” не дазволена.

profiles-delete-profile-title = Выдаліць профіль
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Выдаленне профілю прывядзе да выдалення профілю са спісу даступных профіляў і не можа быць адменена.
    Вы можаце таксама выдаліць файлы дадзеных профілю, уключаючы вашы налады, сертыфікаты і іншыя дадзеныя карыстальніка. Выбар гэтай опцыі прывядзе да выдалення папкі “{ $dir }”, што не можа быць адменена.
    Вы хочаце выдаліць файлы дадзеных профілю?
profiles-delete-files = Выдаліць файлы
profiles-dont-delete-files = Не выдаляць файлы

profiles-delete-profile-failed-title = Памылка
profiles-delete-profile-failed-message = Адбылася памылка пры спробе выдалення гэтага профілю.


profiles-opendir =
    { PLATFORM() ->
        [macos] Паказаць у Finder
        [windows] Адкрыць папку
       *[other] Адкрыць каталог
    }
