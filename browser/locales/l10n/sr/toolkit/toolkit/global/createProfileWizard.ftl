# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Чаробњак за прављење профила
    .style = width: 50em; height: 35em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Увод
       *[other] Добро дошли у програм { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } чува податке о вашим поставкама, подешавањима итд. у вашем профилу.

profile-creation-explanation-2 = Ако делите овај примерак програма { -brand-short-name } са другим корисницима, можете да користите профиле како бисте податке свих корисника чували засебно. Да би ово било могуће, сваки корисник мора да направи сопствени профил.

profile-creation-explanation-3 = Ако сте једина особа која користи овај примерак програма { -brand-short-name }, морате да имате бар један профил. Ако желите, можете да направите више профила за себе како бисте у њима чували различита подешавања и поставке. На пример, можете да раздвојите профиле за личну и пословну употребу.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Како бисте почели са састављањем свог профила, притисните Даље
       *[other] Како бисте почели са састављањем свог профила, притисните „Даље‟.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Закључак
       *[other] Крај рада у програму { create-profile-window.title }
    }

profile-creation-intro = Ако направите неколико профила, можете их разликовати по имену. Можете користити овде наведено име профила или можете уписати своје.

profile-prompt = Унесите име новог профила:
    .accesskey = У

profile-default-name =
    .value = Подразумевани корисник

profile-directory-explanation = Ваша корисничка подешавања, поставке и остали подаци биће чувани у:

create-profile-choose-folder =
    .label = Избор фасцикле…
    .accesskey = И

create-profile-use-default =
    .label = Користи изворну фасциклу
    .accesskey = К
