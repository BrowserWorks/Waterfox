# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Волшебник за креирање профили
    .style = width: 51em; height: 38em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Вовед
       *[other] Добродојдовте во „{ create-profile-window.title }“
    }

profile-creation-explanation-1 = { -brand-short-name } ги чува информациите за вашите поставки и параметри во вашиот личен профил.

profile-creation-explanation-2 = Ако ја делите оваа копија на { -brand-short-name } со други корисници, можете да ги користите профилите за да чувате информациите за секој од нив на посебно место. За да се направи ова, секој корисник треба да си направи сопствен профил.

profile-creation-explanation-3 = Ако вие сте единствените кои ја користите оваа копија на { -brand-short-name }, тогаш мора да имате барем еден профил. Ако сакате, можете да креирате повеќе профили за себе, за да чувате различни поставки и параметри. На пример, може да имате профили за лична и бизнис употреба.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] За да почнете да го креирате вашиот профил, кликнете Напред.
       *[other] За да почнете да го креирате вашиот профил, кликнете Напред.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Заклучок
       *[other] Комплетирање на „{ create-profile-window.title }“
    }

profile-creation-intro = Ако креирате повеќе профили можете да ги разликувате по нивните имиња. Можете да ги користите имињата наведени овде или да користите ваши имиња.

profile-prompt = Внесете име за новиот профил:
    .accesskey = е

profile-default-name =
    .value = Основен корисник

profile-directory-explanation = Вашите поставки, параметри и други кориснички податоци ќе бидат снимени во:

create-profile-choose-folder =
    .label = Изберете папка…
    .accesskey = з

create-profile-use-default =
    .label = Користи ја основната папка
    .accesskey = о
