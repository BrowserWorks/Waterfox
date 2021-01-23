# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Stelselintegrasie

default-client-intro = Gebruik { -brand-short-name } as die verstekkliënt vir:

checkbox-email-label =
    .label = E-pos
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Nuusgroepe
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Nuusvoere
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windowssoektog
       *[other] { "" }
    }

system-search-integration-label =
    .label = Laat { system-search-engine-name } toe om boodskappe te deursoek
    .accesskey = b

check-on-startup-label =
    .label = Kontroleer altyd wanneer { -brand-short-name } begin word
    .accesskey = K
