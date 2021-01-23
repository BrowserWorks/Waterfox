# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Майстер створення профілю
    .style = width: 50em; height: 35em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Початок
       *[other] Ласкаво просимо в { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } зберігає інформацію про ваші налаштування та вподобання у вашому особистому профілі.

profile-creation-explanation-2 = Якщо ви не єдиний користувач цієї копії { -brand-short-name }, тоді за допомогою профілів ви можете зберігати інформацію кожного користувача окремо. Для цього кожному користувачу необхідно створити свій власний профіль.

profile-creation-explanation-3 = Якщо ви єдиний користувач цієї копії { -brand-short-name }, ви повинні мати принаймні один профіль. При бажанні, ви можете створити декілька власних профілів для зберігання різних наборів налаштувань. Наприклад, якщо ви захочете мати два різні профілі для роботи і для особистого користування.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Щоб створити профіль, натисніть Далі:
       *[other] Щоб створити профіль, натисніть Далі:
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Завершення
       *[other] Завершення роботи { create-profile-window.title }
    }

profile-creation-intro = При створенні декількох профілів, ви зможете розрізняти їх за назвою. Ви можете скористатися пропонованою назвою, або ж придумати власну.

profile-prompt = Введіть назву нового профілю:
    .accesskey = е

profile-default-name =
    .value = Типовий Користувач

profile-directory-explanation = Ваші налаштування, вподобання й інші користувацькі дані зберігатимуться в:

create-profile-choose-folder =
    .label = Обрати теку…
    .accesskey = т

create-profile-use-default =
    .label = Використати типову теку
    .accesskey = т
