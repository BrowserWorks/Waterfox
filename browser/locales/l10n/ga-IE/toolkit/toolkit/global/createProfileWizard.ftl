# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

create-profile-window =
    .title = Treoraí na bPróifílí
    .style = width: 45em; height: 32em;

## First wizard page

create-profile-first-page-header =
    { PLATFORM() ->
        [macos] Réamhrá
       *[other] Fáilte go dtí { create-profile-window.title }
    }

profile-creation-explanation-1 = Sábhálann { -brand-short-name } eolas faoi do shocruithe agus sainroghanna i do phróifíl phearsanta.

profile-creation-explanation-2 = Má tá an chóip seo de { -brand-short-name } á roinnt le húsáideoirí eile, is féidir leat úsáid a bhaint as próifílí chun eolas pearsanta a choinneáil ar leithligh ó chéile. Seo le déanamh, ní foláir do gach úsáideoir próifíl phearsanta a chruthú.

profile-creation-explanation-3 = Más tusa an t-aon duine amháin ag baint úsáide as an gcóip seo de { -brand-short-name }, is gá próifíl amháin ar a laghad a bheith agat. Más mian leat, is féidir leat próifílí éagsúla a chruthú duit féin chun socruithe agus roghanna éagsúla a choinneáil. Mar shampla, d'fhéadfaí próifílí ar leith a bheith agat le haghaidh gnó agus le haghaidh d'úsáide féin.

profile-creation-explanation-4 =
    { PLATFORM() ->
        [macos] Chun próifíl a chruthú, cliceáil Ar Aghaidh.
       *[other] Chun próifíl a chruthú, cliceáil Ar Aghaidh.
    }

## Second wizard page

create-profile-last-page-header =
    { PLATFORM() ->
        [macos] Críoch
       *[other] { create-profile-window.title } á chur i gcrích
    }

profile-creation-intro = Má chruthaíonn tú próifílí éagsúla, is féidir iad a aithint óna chéile le hainmneacha na bpróifílí. Is féidir an t-ainm a thugtar anseo a úsáid, nó do cheann féin.

profile-prompt = Cuir isteach ainm próifíle nua:
    .accesskey = e

profile-default-name =
    .value = Úsáideoir Réamhshocraithe

profile-directory-explanation = Stórálfar do chuid socruithe úsáideora, roghanna agus sonraí úsáideora eile i:

create-profile-choose-folder =
    .label = Roghnaigh Fillteán…
    .accesskey = R

create-profile-use-default =
    .label = Úsáid Fillteán Réamhshocraithe
    .accesskey = s
