# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integrare cu sistemul

system-integration-dialog =
    .buttonlabelaccept = Setează ca implicit
    .buttonlabelcancel = Omite integrarea
    .buttonlabelcancel2 = Renunțare

default-client-intro = Folosește { -brand-short-name } ca și client implicit pentru:

unset-default-tooltip = Nu este posibil să deselectezi { -brand-short-name } ca clientul implicit în cadrul opțiunilor din { -brand-short-name }. Pentru a face un program ca și client implicit trebuie să folosești dialogul său „Setează ca implicit”.

checkbox-email-label =
    .label = E-mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grupuri de discuții
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Fluxuri
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Căutare Windows
       *[other] { "" }
    }

system-search-integration-label =
    .label = Permite la { system-search-engine-name } să caute în mesaje
    .accesskey = P

check-on-startup-label =
    .label = Verifică întotdeauna la pornirea { -brand-short-name }
    .accesskey = a
