# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Профильді жасау шебері
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Басы
       *[other] { create-profile-window.title } өніміне қош келдіңіз
    }

profile-creation-explanation-1 = { -brand-short-name } сіздің баптаулар, бетбелгілер туралы және т.б. ақпаратты жеке профиліңізде сақтайды.

profile-creation-explanation-2 = Егер сіз { -brand-short-name } осы нұсқасын басқа пайдаланушылармен қатар қолдаңсаңыз, әр пайдаланушының жеке ақпаратын бөлек сақтау үшін профильдерді жасауыңыз керек. Әр пайдаланушы өзінің жеке профилін жасау керек.

profile-creation-explanation-3 = Егер сіз { -brand-short-name } осы нұсқасының жалғыз пайдаланушысы болсаңыз, кем дегенде бір профиліңіз болу керек. Сонда да, сіз бірнеше профиль жасап, олардың ішінде баптаулардың әр түрлі нұсқаларын сақтауыңызға болады. Бұл, мысалға, бизнес пен жеке қолдануды ажыратуға өте қолайлы.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Профильді жасау үшін, "Жалғастыру" батырмасын басыңыз:
       *[other] Профильді жасау үшін, "Келесі" батырмасын басыңыз:
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Аяқталуы
       *[other] { create-profile-window.title } жұмысының аяқталуы
    }

profile-creation-intro = Егер сізде бірнеше профиль бар болса, оларды атау арқылы ажырата аласыз. Өзіңіз атап көріңіз, немесе төменде көрсетілгенді қолдана аласыз.

profile-prompt = Жаңа профильдің атын енгізіңіз:
    .accesskey = а

profile-default-name =
    .value = Негізгі пайдаланушы

profile-directory-explanation = Сіздің баптаулар, параметрлер және басқа да пайдаланушы ақпаратыңыз келесі жерде сақталады:

create-profile-choose-folder =
    .label = Буманы таңдау…
    .accesskey = т

create-profile-use-default =
    .label = Бастапқы буманы қолдану
    .accesskey = Б
