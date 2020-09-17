# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Sistemska integracija

system-integration-dialog =
    .buttonlabelaccept = Postavi kao glavno
    .buttonlabelcancel = Preskoči integraciju
    .buttonlabelcancel2 = Otkaži

default-client-intro = Koristite { -brand-short-name } kao glavni klijent za:

unset-default-tooltip = Nije moguće isključiti { -brand-short-name } kao glavni klijent iz samog { -brand-short-name }a. Ukoliko želite postaviti drugu aplikaciju kao glavnu, morate koristiti njen 'Postavi kao glavni' dijalog.

checkbox-email-label =
    .label = E-mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = News grupe
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Feedove
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows pretraga
       *[other] { "" }
    }

system-search-integration-label =
    .label = Dozvoli { system-search-engine-name } pretraživanje poruka
    .accesskey = D

check-on-startup-label =
    .label = Uvijek provjeri prilikom pokretanja { -brand-short-name }a
    .accesskey = A
