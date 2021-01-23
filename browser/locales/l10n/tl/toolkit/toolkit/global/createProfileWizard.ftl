# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Lumikha ng Profile Wizard
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Panimula
       *[other] Maligayang Pagdating sa { create-profile-window.title }
    }

profile-creation-explanation-1 = Ang { -brand-short-name } ay nag-iimbak ng impormasyon tungkol sa iyong mga setting at kagustuhan sa iyong personal profile.

profile-creation-explanation-2 = Kung ikaw ay magbabahagi ng kopya ng { -brand-short-name } sa ibang mga gumagamit, maaari kang gumamit ng profile upang panatilihing hiwalay ang impormasyon ng bawat user. Upang gawin ito, ang bawat gumagamit ay dapat na lumikha ng kanyang sariling profile.

profile-creation-explanation-3 = Kung ikaw ay ang tanging tao na gagamit ng kopya ng { -brand-short-name }, kailangan mong magkaroon ng hindi bababa sa isang profile. Kung nais mo, maaari kang lumikha ng maramihang mga profile para sa iyong sarili upang i-imbak ang mga iba't ibang mga hanay ng mga setting at kagustuhan. Halimbawa, maaaring gusto mong magkaroon ng hiwalay na mga profile para sa negosyo at personal na paggamit.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Para masimulan ang paglikha ng iyong profile, pindutin ang Magpatuloy.
       *[other] Upang simulan ang paglikha ng iyong profile, pindutin ang Susunod.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Konklusyon
       *[other] Kinukumpleto ang { create-profile-window.title }
    }

profile-creation-intro = Kung ikaw ay nakagawa ng maraming profiles, puwede mong hiawa-hiwalayin sila sa pamamagitan ng profile names. Puwede mong gamitin ang mga pangalan na nakalagay dito o gamitin mo kung ano ang gusto mo.

profile-prompt = Itala ang bagong profile name:
    .accesskey = e

profile-default-name =
    .value = Nakatakda na User

profile-directory-explanation = Mga setting ng iyong gumagamit, mga kagustuhan at iba pang mga user-nauugnay na data ay naka-imbak sa:

create-profile-choose-folder =
    .label = Piliin ang Folder…
    .accesskey = P

create-profile-use-default =
    .label = Gamitin ang Default Folder
    .accesskey = u
