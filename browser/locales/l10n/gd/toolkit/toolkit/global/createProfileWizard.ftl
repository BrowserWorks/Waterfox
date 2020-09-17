# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Draoidh cruthachadh pròifile
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Ro-ràdh
       *[other] Fàilte gu { create-profile-window.title }
    }

profile-creation-explanation-1 = Cumaidh { -brand-short-name } fiosrachadh nan roghainnean agad 'nad phròifil phearsanta.

profile-creation-explanation-2 = Ma bhios daoine eile a' cleachdadh { -brand-short-name } air an inneal seo, 's urrainn dhut pròifil a chleachdadh gus fiosrachadh gach cleachdaiche a chumail o chèile. Bu chòir do gach cleachdaiche pròifil aca fhèin a chruthachadh a chum seo.

profile-creation-explanation-3 = Mas tusa an aon duine a bhios a' cleachdadh { -brand-short-name } air an inneal seo, feumaidh aon phròifil a bhith agad air a' char as lugha. 'S urrainn dhut iomadh pròifil a chruthachadh dhut fhèin, ma thogras tu, gus seataichean eadar-dhealaichte de roghainnean a stòradh. Mar eisimpleir, ma bhios tu ag iarraidh pròifil a chleachdas tu 'nad obair 's tè eile a chum cleachdaidh phearsanta.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Briog air "Air adhart" gus a' phròifil agad a chruthachadh.
       *[other] Briog air "Air adhart" gus a' phròifil agad a chruthachadh.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Co-dhùnadh
       *[other] A' toirt gu buil an { create-profile-window.title }
    }

profile-creation-intro = Ma chruthaicheas tu iomadh pròifil, aithnichidh tu iad air an cuid ainmean. 'S urrainn dhut an t-ainm a chaidh a chur air shùilean dhut an-seo a chleachdadh no ainm sam bith eile bu toigh leat.

profile-prompt = Cuir a-steach ainm ùr airson na pròifile:
    .accesskey = e

profile-default-name =
    .value = Cleachdaiche bunaiteach

profile-directory-explanation = Thèid na roghainnean cleachdaiche agad is dàta cleachdaiche sam bith eile a tha co-cheangailte ris a stòradh ann an:

create-profile-choose-folder =
    .label = Tagh pasgan…
    .accesskey = T

create-profile-use-default =
    .label = Cleachd am pasgan bunaiteach
    .accesskey = p
