# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Süsteemi integratsioon

system-integration-dialog =
    .buttonlabelaccept = Määra vaikekliendiks
    .buttonlabelcancel = Jäta vahele
    .buttonlabelcancel2 = Loobu

default-client-intro = { -brand-short-name }i kasutatakse vaikimisi rakendusena:

unset-default-tooltip = { -brand-short-name }i endaga pole võimalik { -brand-short-name }i vaikekliendi staatust eemaldada. Mõne teise rakenduse vaikekliendiks tegemiseks pead sa kasutama selle rakenduse vastavat funktsionaalsust.

checkbox-email-label =
    .label = E-postile
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Uudisgruppidele
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Uudistevoogudele
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
    .label = Rakendusel { system-search-engine-name } lubatakse kirju otsida
    .accesskey = R

check-on-startup-label =
    .label = See kontroll sooritatakse igal { -brand-short-name }i käivitumisel
    .accesskey = S
