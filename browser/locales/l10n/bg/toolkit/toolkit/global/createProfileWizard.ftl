# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Помощник за създаване на профил
    .style = width: 50em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Въведение
       *[other] Добре дошли в { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } съхранява информацията за вашите настройки и предпочитания в личния ви профил.

profile-creation-explanation-2 = Ако с други потребители използвате общо копие на { -brand-short-name }, може да използвате отделни профили, за да държите личната си информация отделена. За да стане това, всеки потребител трябва да създаде свой собствен профил.

profile-creation-explanation-3 = Ако само вие използвате това копие на { -brand-short-name } трябва да имате поне един профил. Ако желаете, може да създадете множество профили за себе си, в които да съхранявате различни настройки и предпочитания. Например, да имате различни профили за работа и вкъщи.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] За да създадете ваш профил, натиснете „Продължаване“.
       *[other] За да започнете процес по създаване на профил изберете „Напред“.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Завършване
       *[other] Завършване на { create-profile-window.title }
    }

profile-creation-intro = Ако създадете няколко профила, може да ги разграничавате с различни имена. Използвайте шаблонното име или използвайте свое.

profile-prompt = Име на профила:
    .accesskey = И

profile-default-name =
    .value = Текущ потребител

profile-directory-explanation = Вашите потребителски настройки и лични данни ще бъдат запазени в:

create-profile-choose-folder =
    .label = Избиране на папка…
    .accesskey = б

create-profile-use-default =
    .label = Използване на стандартна папка
    .accesskey = п
