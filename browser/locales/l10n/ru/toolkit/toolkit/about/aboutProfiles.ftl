# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


profiles-title = О профилях
profiles-subtitle = Эта страница поможет вам управлять вашими профилями. Каждый профиль представляет собой отдельный мир, который содержит отдельную историю, закладки, настройки и дополнения.
profiles-create = Создать новый профиль
profiles-restart-title = Перезапустить
profiles-restart-in-safe-mode = Перезапустить с отключёнными дополнениями…
profiles-restart-normal = Перезапустить в обычном режиме…
profiles-conflict = Другая копия { -brand-product-name } сделала изменения в профилях. Вам необходимо перезапустить { -brand-short-name } перед тем, как производить какие-либо другие изменения.
profiles-flush-fail-title = Изменения не сохранены
profiles-flush-conflict = { profiles-conflict }
profiles-flush-failed = Неожиданная ошибка не позволила сохранить ваши изменения.
profiles-flush-restart-button = Перезапустить { -brand-short-name }

# Variables:
#   $name (String) - Name of the profile
profiles-name = Профиль: { $name }
profiles-is-default = Профиль по умолчанию
profiles-rootdir = Корневой каталог

# localDir is used to show the directory corresponding to
# the main profile directory that exists for the purpose of storing data on the
# local filesystem, including cache files or other data files that may not
# represent critical user data. (e.g., this directory may not be included as
# part of a backup scheme.)
# In case localDir and rootDir are equal, localDir is not shown.
profiles-localdir = Локальный каталог
profiles-current-profile = Этот профиль сейчас используется и не может быть удалён.
profiles-in-use-profile = Этот профиль сейчас используется другим приложением и не может быть удалён.

profiles-rename = Переименовать
profiles-remove = Удалить
profiles-set-as-default = Установить как профиль по умолчанию
profiles-launch-profile = Запустить ещё один браузер с этим профилем

profiles-cannot-set-as-default-title = Не удалось установить по умолчанию
profiles-cannot-set-as-default-message = Не удалось сменить профиль по умолчанию для { -brand-short-name }.

profiles-yes = да
profiles-no = нет

profiles-rename-profile-title = Переименовать профиль
# Variables:
#   $name (String) - Name of the profile
profiles-rename-profile = Переименовать профиль { $name }

profiles-invalid-profile-name-title = Некорректное имя профиля
# Variables:
#   $name (String) - Name of the profile
profiles-invalid-profile-name = Имя профиля «{ $name }» не разрешено.

profiles-delete-profile-title = Удалить профиль
# Variables:
#   $dir (String) - Path to be displayed
profiles-delete-profile-confirm =
    Удаление профиля приведёт к удалению профиля из списка доступных профилей и не может быть отменено.
    Вы можете также удалить файлы данных профиля, включая ваши настройки, сертификаты и другие пользовательские данные. Выбор этой опции приведет к удалению папки «{ $dir }», что не может быть отменено.
    Вы хотите удалить файлы данных профиля?
profiles-delete-files = Удалить файлы
profiles-dont-delete-files = Не удалять файлы

profiles-delete-profile-failed-title = Ошибка
profiles-delete-profile-failed-message = При попытке удаления этого профиля произошла ошибка.


profiles-opendir =
    { PLATFORM() ->
        [macos] Показать в Finder
        [windows] Открыть папку
       *[other] Открыть каталог
    }
