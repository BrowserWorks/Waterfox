# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Мастер создания профиля
    .style = width: 50em; height: 35em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Начало
       *[other] Добро пожаловать в { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } хранит информацию о ваших установках, настройках и т.д. в личном профиле.

profile-creation-explanation-2 = Если вы не единственный пользователь этой копии { -brand-short-name }, вы можете воспользоваться профилями для разделения используемых данных. Для этого у каждого пользователя должен быть свой профиль.

profile-creation-explanation-3 = Если вы единственный пользователь этой копии { -brand-short-name }, у вас должен быть хотя бы один профиль. Если хотите, можете пользоваться несколькими профилями для хранения разных наборов настроек. Например, вы можете использовать один профиль для личного пользования, а другой для работы.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Чтобы создать профиль, нажмите кнопку «Продолжить»:
       *[other] Чтобы создать профиль, нажмите кнопку «Далее»:
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Завершение
       *[other] Завершение работы { create-profile-window.title }
    }

profile-creation-intro = Если у вас несколько профилей, вы можете различать их по именам. Придумайте имя самостоятельно или воспользуйтесь указанным ниже.

profile-prompt = Введите имя нового профиля:
    .accesskey = и

profile-default-name =
    .value = Пользователь по умолчанию

profile-directory-explanation = Ваши настройки, параметры и другие пользовательские данные будут храниться в:

create-profile-choose-folder =
    .label = Выбрать папку…
    .accesskey = п

create-profile-use-default =
    .label = Использовать папку по умолчанию
    .accesskey = м
