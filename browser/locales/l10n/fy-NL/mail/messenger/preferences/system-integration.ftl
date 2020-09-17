# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Systeemyntegraasje

system-integration-dialog =
    .buttonlabelaccept = As standert ynstelle
    .buttonlabelcancel = Yntegraasje oerslaan
    .buttonlabelcancel2 = Annulearje

default-client-intro = { -brand-short-name } as standertprogramma brûke foar:

unset-default-tooltip = It is net mooglik om it ynstellen fan { -brand-short-name } as de standerrclient yn { -brand-short-name } ûngedien te meitsjen. Om in oare tapassing de standertclient te meitsjen, moatte jo it dialoochfinster ‘As standert ynstellen’ dêrfan brûke.

checkbox-email-label =
    .label = E-mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Nijsgroepen
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Feeds
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Zoeken
       *[other] { "" }
    }

system-search-integration-label =
    .label = Lit { system-search-engine-name } troch berjochten sykje
    .accesskey = S

check-on-startup-label =
    .label = Dizze kontrole altyd útfiere by it starten fan { -brand-short-name }
    .accesskey = D
