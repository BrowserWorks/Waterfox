# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Asistent za založenje profilow
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Zachopjeńk
       *[other] Witajśo do { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } składujo informacije wó wašych nastajenjach a preferencach we wašom wósobinskem profilu.

profile-creation-explanation-2 = Jolic wužywaśo toś tu kopiju { -brand-short-name } zgromadnje z drugimi wužywarjami, móžośo rozdźelne profile wužywaś, aby informacije kuždego wužywarja rozdźělone źaržał. Za to by dejał kuždy wužywaŕ swój profil załožyś.

profile-creation-explanation-3 = Jolic sćo jadnučka wósoba, kótaraž wužywa toś tu kopiju { -brand-short-name }, musyśo nanejmjenjej jaden profil měś. Jolic cośo, móžośo někotare profile za sebje załožyś, aby rozdźělne kupki nastajenjow a preference składował. Na pśikład cośo snaź separatne profile za pówołańske a priwatne wužywanje měś.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Aby swój profil załožył, klikniśo na Pókšacowaś.
       *[other] Aby swój profil załožył, klikniśo na Dalej.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Dokóńcenje
       *[other] { create-profile-window.title } dokóńcyś
    }

profile-creation-intro = Jolic založujośo někotare profile, móžośo je z profilowymi mjenjami rozeznaś. Móžośo how pódane abo swójske mě wužywaś.

profile-prompt = Zapódajśo nowe profilowe mě:
    .accesskey = Z

profile-default-name =
    .value = Standardny wužywaŕ

profile-directory-explanation = Waše wužywaŕske nastajenja, preference a druge daty, kótarež pósěguju se na wužywarja, budu se składowaś w:

create-profile-choose-folder =
    .label = Zarědnik wubraś…
    .accesskey = r

create-profile-use-default =
    .label = Standardny zarědnik wužywaś
    .accesskey = S
