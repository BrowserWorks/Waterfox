# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integrim me Sistemin

system-integration-dialog =
    .buttonlabelaccept = Vëre si Parazgjedhje
    .buttonlabelcancel = Anashkaloje Integrimin
    .buttonlabelcancel2 = Anuloje

default-client-intro = Përdor { -brand-short-name }-in si klient parazgjedhje për:

unset-default-tooltip = Nuk është e mundur të hiqet { -brand-short-name } si klienti parazgjedhje brenda në { -brand-short-name }. Që të vendosni si parazgjedhje një tjetër aplikacion, duhet të përdorni dialogun e tij 'Caktojeni si parazgjedhje'.

checkbox-email-label =
    .label = Email
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grupe Lajmesh
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Prurje
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Search
       *[other] { "" }
    }

system-search-integration-label =
    .label = Lejo { system-search-engine-name }-n të kërkojë në mesazhe
    .accesskey = L

check-on-startup-label =
    .label = Kryeje përherë këtë kontroll kur niset { -brand-short-name }-i
    .accesskey = K
