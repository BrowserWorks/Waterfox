# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Sos Ɗoworde Heftinirde
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Naatirka
       *[other] A jaɓɓaama e { create-profile-window.title }
    }

profile-creation-explanation-1 = { -brand-short-name } mooftat humpito baɗte teelte maa e cuɓoraaɗe maa e nder heftinirde maa heeriinnde.

profile-creation-explanation-2 = So tawii ko a denndauo ndee tummbitere { -brand-short-name }, e woɗɓe, aɗa waawi huutoraade keftinirɗe ngam seerndude humpitooji mom. Ngam waɗde ɗum, kuutoro kala ena foti sosde heftinirde mum heeriinnde.

profile-creation-explanation-3 = So tawii ko aan gooto huutortoo ndee tummbitere { -brand-short-name }, aɗa foti jogaade hay so heftinirde wootere. So aɗa yiɗi, aɗa waawi sosande hoore maa keftinirɗe keewɗe ngam mooftude teelte e cuɓoraaɗe ceertuɗe. Yeu, aɗa waawi yiɗde jogaade keftinirɗe ceertuɗe ngam njulaagu e golle keeriiɗe.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Ngam fuɗɗaade sosde heftinirde maa, dobo Jokku.
       *[other] Ngam fuɗɗaade sosde heftinirde maa, dobo Payɗo.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Tonngirka
       *[other] Nana jokkita { create-profile-window.title }
    }

profile-creation-intro = So a sosii keftinirɗe keewɗe aɗa waawi seerndirɗe-ɗe innde. Aɗa waawi huutoraade innde hokkaande ndee walla kuutoro-ɗaa innde nde cuɓi-ɗaa.

profile-prompt = Naatnu innde heftinirde hesere:
    .accesskey = N

profile-default-name =
    .value = Kuutoro Goowaaɗo

profile-directory-explanation = Teelte kuutoro maa, cuɓoraaɗe e keɓe kuutoro goɗɗe maa moofte e nder:

create-profile-choose-folder =
    .label = Suɓo Runngere…
    .accesskey = S

create-profile-use-default =
    .label = Huutoro Runngere Woowaande
    .accesskey = H
