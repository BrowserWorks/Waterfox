# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Samþætting kerfis

system-integration-dialog =
    .buttonlabelaccept = Setja sem sjálfgefinn
    .buttonlabelcancel = Sleppa samþættingu
    .buttonlabelcancel2 = Hætta við

default-client-intro = Nota { -brand-short-name } sem sjálfgefið forrit fyrir:

unset-default-tooltip = Ekki er hægt taka af { -brand-short-name } sem sjálfgefin vafra í { -brand-short-name } sjálfum. Til að breyta þessu verðurðu að fara í hinn vafrann og nota stillingar þar til að gera þann vafra að sjálfgefnum.

checkbox-email-label =
    .label = Tölvupóst
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Fréttahópa
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Strauma
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows leit
       *[other] { "" }
    }

system-search-integration-label =
    .label = Leyfa { system-search-engine-name } að leita í pósti
    .accesskey = s

check-on-startup-label =
    .label = Alltaf athuga þegar { -brand-short-name } er ræstur
    .accesskey = A
