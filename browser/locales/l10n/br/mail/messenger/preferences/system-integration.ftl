# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Enframmadur reizhiad

system-integration-dialog =
    .buttonlabelaccept = Lakaat dre ziouer
    .buttonlabelcancel = Leuskel an enframmadur a-gostez
    .buttonlabelcancel2 = Nullañ

default-client-intro = Arverañ { -brand-short-name } da arval dre ziouer evit:

unset-default-tooltip = N'haller ket lemel { -brand-short-name } eus an arventenn arval dre ziouer war { -brand-short-name }. Ret eo deoc'h arverañ ar voest emziviz 'Lakaat dre ziouer' eus an arload a fell deoc'h lakaat dre ziouer.

checkbox-email-label =
    .label = Postel
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Strolladoù keleier
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Lanv
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Enklask Windows
       *[other] { "" }
    }

system-search-integration-label =
    .label = Aotren { system-search-engine-name } da glask er c'hemennadennoù
    .accesskey = n

check-on-startup-label =
    .label = Gwiriañ atav pa loc'h { -brand-short-name }
    .accesskey = a
