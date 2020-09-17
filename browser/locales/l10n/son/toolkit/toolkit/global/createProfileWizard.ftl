# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Bida alhal tee
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Šintin daara
       *[other] Kubayni { create-profile-window.title } do
    }

profile-creation-explanation-1 = { -brand-short-name } ga alhabar jiši war kayandiyaney nda ibaayey še war boŋ alhaaloo ra.

profile-creation-explanation-2 = Nda war ga { -brand-short-name } berandoo woo žemni goykaw fooyaŋ game, war ga hin ka alhaaley zaa k'i gaabu boro foo kul alhabar bataa ra. Ka woo tee, goykaw foo kul ga hima ka nga boŋ alhaaloo tee.

profile-creation-explanation-3 = Nda war ti boro follokaa kaŋ ga goy nda { -brand-short-name } berandoo woo; adiši war ga hima ka alhal foo tee. Nda war ga baa, war ga hin ka alhaal booboyaŋ tee war boŋ še ka kayandi dumiyaŋ nda ibaayiyaŋ jiši. Sanda, nda war ga baa alhaali waani-waaniyaŋ tee war goydoo nda hugay misey še.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Ka šintin ka war alhaaloo tee, Koy jine naagu.
       *[other] Ka sintin ka war alhaaloo tee, Jine naagu.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Kunga
       *[other] { create-profile-window.title } benandi
    }

profile-creation-intro = Nda war baa ka alhaali booboyaŋ tee war ga hin k'i fay nda maaɲey. War ga hin ka ne maawoo zaa wala war boŋ maaɲoo dam.

profile-prompt = Alhal taaga maa dam:
    .accesskey = A

profile-default-name =
    .value = Tilasu goykaw

profile-directory-explanation = War goykaw kayandiyaney, ibaayey nda goy-mise bayhayey ga jisandi ne ra:

create-profile-choose-folder =
    .label = Foolo suuba…
    .accesskey = F

create-profile-use-default =
    .label = Tilasu foolo goyandi
    .accesskey = T
