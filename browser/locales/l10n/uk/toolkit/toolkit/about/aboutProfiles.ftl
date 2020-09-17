# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = Про профілі
profiles-subtitle = Ця сторінка допомагає керувати вашими профілями. Кожен профіль є окремим світом, що містить окрему історію, закладки, налаштування й додатки.
profiles-create = Створити новий профіль
profiles-restart-title = Перезапустити
profiles-restart-in-safe-mode = Перезапустити з вимкненими додатками…
profiles-restart-normal = Перезапустити в звичайному режимі…
profiles-conflict = Інша копія { -brand-product-name } зробила зміни в профілях. Необхідно перезапустити { -brand-short-name }, щоб виконувати інші зміни.
profiles-flush-fail-title = Зміни не збережено
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Неочікувана помилка не дозволила зберегти ваші зміни.
profiles-flush-restart-button = Перезапустити { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Профіль: { $name }
profiles-is-default = Типовий профіль
profiles-rootdir = Кореневий каталог

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Локальний каталог
profiles-current-profile = Цей профіль використовується і не може бути видалений.
profiles-in-use-profile = Цей профіль використовується в іншій програмі й не може бути видалений.

profiles-rename = Перейменувати
profiles-remove = Видалити
profiles-set-as-default = Встановити типовим профілем
profiles-launch-profile = Запустити профіль в новому браузері

profiles-cannot-set-as-default-title = Не вдалося встановити типовим
profiles-cannot-set-as-default-message = Не вдалося змінити типовий профіль для { -brand-short-name }.

profiles-yes = так
profiles-no = ні

profiles-rename-profile-title = Перейменувати профіль
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Перейменувати профіль { $name }

profiles-invalid-profile-name-title = Неприпустиме ім’я профілю
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Назва профілю “{ $name }” не дозволена.

profiles-delete-profile-title = Видалити профіль
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Видалення профілю вилучить його зі списку доступних профілів і цю дію неможливо скасувати.
    Ви також можете видалити файли даних профілю, включаючи налаштування, сертифікати й інші дані, пов'язані з користувачем. Ця опція видалить теку "{ $dir }" і цю дію неможливо скасувати.
    Чи бажаєте видалити файли даних профілю?
profiles-delete-files = Видалити файли
profiles-dont-delete-files = Не видаляти файли

profiles-delete-profile-failed-title = Помилка
profiles-delete-profile-failed-message = Сталася помилка під час спроби видалення цього профілю.


profiles-opendir =
    { PLATFORM() ->
        [macos] Показати у Finder
        [windows] Відкрити теку
       *[other] Відкрити каталог
    }
