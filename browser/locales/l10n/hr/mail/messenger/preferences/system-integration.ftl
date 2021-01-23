# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Sistemska integracija

system-integration-dialog =
    .buttonlabelaccept = Postavi kao zadani
    .buttonlabelcancel = Preskoči integraciju
    .buttonlabelcancel2 = Otkaži

default-client-intro = Koristite { -brand-short-name } kao zadani klijent za:

unset-default-tooltip = Nije moguće isključiti { -brand-short-name } kao zadani klijent iz samog { -brand-short-name }a. Ukoliko želite postaviti drugu aplikaciju za zadanu, morate koristiti njene 'Postavi kao zadani' postavke.

checkbox-email-label =
    .label = E-poštu
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Interesne grupe
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Kanale
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows pretraživanje
       *[other] { "" }
    }

system-search-integration-label =
    .label = Dozvoli { system-search-engine-name } pretraživanje poruka
    .accesskey = D

check-on-startup-label =
    .label = Uvijek napravi ovu provjeru prilikom pokretanja { -brand-short-name }a
    .accesskey = a
