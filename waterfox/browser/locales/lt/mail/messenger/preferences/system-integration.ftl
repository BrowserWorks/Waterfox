# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integracija su sistema

system-integration-dialog =
    .buttonlabelaccept = Skirti numatytąja
    .buttonlabelcancel = Praleisti integraciją
    .buttonlabelcancel2 = Atsisakyti

default-client-intro = „{ -brand-short-name }“ laikyti numatytąja programa:

unset-default-tooltip = Programai „{ -brand-short-name }“ neįmanoma nurodyti kad ji nebūtų laikoma numatytąja programa. Jeigu numatytąja norite skirti kitą programą, pasinaudokite atitinkamu tos programos dialogo langu.

checkbox-email-label =
    .label = el. pašto
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = naujienų grupių
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = sklaidos kanalų
    .tooltiptext = { unset-default-tooltip }

checkbox-calendar-label =
    .label = Kalendorius
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
    .label = Leisti „{ system-search-engine-name }“ ieškoti laiškų
    .accesskey = L

check-on-startup-label =
    .label = Paleidžiant „{ -brand-short-name }“ tikrinti, ar ji yra numatytoji
    .accesskey = P
