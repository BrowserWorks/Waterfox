# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Comhtháthú Córais

system-integration-dialog =
    .buttonlabelaccept = Socraigh mar réamhshocrú
    .buttonlabelcancel = Ná Bac le Comhtháthú
    .buttonlabelcancel2 = Cealaigh

default-client-intro = Úsáid { -brand-short-name } mar chliant réamhshocraithe le haghaidh:

unset-default-tooltip = Ní féidir { -brand-short-name } a dhíshocrú mar chliant réamhshocraithe taobh istigh de { -brand-short-name }. Chun feidhmchlár eile a roghnú, caithfidh tú an dialóg 'Socraigh mar réamhshocrú' san fheidhmchlár sin a úsáid.

checkbox-email-label =
    .label = R-Phost
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grúpaí-Nuachta
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Fothaí
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotsolas
        [windows] Cuardach Windows
       *[other] { "" }
    }

system-search-integration-label =
    .label = Ceadaigh do { system-search-engine-name } teachtaireachtaí a chuardach
    .accesskey = C

check-on-startup-label =
    .label = Seiceáil mar seo i gcónaí agus { -brand-short-name } á thosú
    .accesskey = a
