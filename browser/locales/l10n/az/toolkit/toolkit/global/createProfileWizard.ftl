# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Hesab Yaratma Köməkçisi
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Başlatma
       *[other] { create-profile-window.title } bölməsinə xoş gəlmisiniz
    }

profile-creation-explanation-1 = { -brand-short-name } nizamlarınızı, favoritlərinizi və oxşar seçimlərinizi hesabınızda saxlayır.

profile-creation-explanation-2 = { -brand-short-name } brauzerini başqalarıyla ortaq işlədirsinizsə, hər istifadəçinin məlumatlarını ayrı-ayrı saxlamaq üçün fərqli hesablar yarada bilərsiniz.

profile-creation-explanation-3 = { -brand-short-name } brauzerini istifadə edirsinizsə ən azından bir hesaba sahib olmağınız lazımdır. Sizi maraqlandıran fərqli tənzimləmələri birdən çox hesabda saxlaya bilərsiniz. Məsələn iş üçün ayrı, ev üçün ayrı hesab yarada bilərsiniz.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Hesab yaratmaq üçün Davam düyməsinə basın.
       *[other] Hesab yaratmaq üçün 'İrəli' düyməsinə basın.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Nəticə
       *[other] { create-profile-window.title } tamamlanır
    }

profile-creation-intro = Birdən çox hesab yaratsanız bunları bir birindən ayırmaq üçün hesab adlarından istifadə edə bilərsiniz. Burada təqdim olunan  ya da özünüz seçdiyiniz bir addan istifadə edə bilərsiniz.

profile-prompt = Yeni bir hesab adı daxil edin:
    .accesskey = e

profile-default-name =
    .value = Standart istifadəçi

profile-directory-explanation = İstifadəçi tənzimləmələriniz, nizamlamalarınız və digər sizə bağlı məlumatlar burada saxlanacaq:

create-profile-choose-folder =
    .label = Qovluq seç…
    .accesskey = s

create-profile-use-default =
    .label = Standart qovluqdan istifadə et
    .accesskey = d
