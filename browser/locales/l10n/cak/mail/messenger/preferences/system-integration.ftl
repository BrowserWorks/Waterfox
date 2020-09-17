# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Q'inoj Tunuj

system-integration-dialog =
    .buttonlabelaccept = Tichap achi'el ri K'o wi
    .buttonlabelcancel = Tik'o pa Ruwi' Tunuj
    .buttonlabelcancel2 = Tiq'at

default-client-intro = Tokisäx { -brand-short-name } achi'el ri winaqil k'o wi richin:

unset-default-tooltip = Man tikirel ta nib'an chi ri { -brand-short-name } nuya' kan rub'anikil achi'el winaqil k'o wi pa { -brand-short-name }. Richin chi jun chik chokoy nok ri kan k'o wi, tawokisaj 'Tijikib'äx achi'el ri k'o' tzijonem.

checkbox-email-label =
    .label = Taqoya'l
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Rumolaj tzijol
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Taq b'ey
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Kikanoxik Windows
       *[other] { "" }
    }

system-search-integration-label =
    .label = Tiya' q'ij chi re { system-search-engine-name } chi yerukanoj taq tzijol
    .accesskey = S

check-on-startup-label =
    .label = Junelïk tinik'öx toq nitikirisäx el ri { -brand-short-name }
    .accesskey = J
