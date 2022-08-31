# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Nastavení systému

system-integration-dialog =
    .buttonlabelaccept = Nastavit jako výchozí
    .buttonlabelcancel = Přeskočit integraci
    .buttonlabelcancel2 = Zrušit

default-client-intro =
    Použít { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "acc") }
        [feminine] { -brand-short-name(case: "acc") }
        [neuter] { -brand-short-name(case: "acc") }
       *[other] aplikaci { -brand-short-name }
    } jako výchozí pro:

unset-default-tooltip =
    Z { -brand-short-name.gender ->
        [masculine] { -brand-short-name(case: "gen") }
        [feminine] { -brand-short-name(case: "gen") }
        [neuter] { -brand-short-name(case: "gen") }
       *[other] aplikace { -brand-short-name }
    } není možné nastavit, aby { -brand-short-name.gender ->
        [masculine] { -brand-short-name } nebyl
        [feminine] { -brand-short-name } nebyla
        [neuter] { -brand-short-name } nebylo
       *[other] aplikace { -brand-short-name } nebyla
    } výchozím klientem. Pro nastavení jiné aplikace jako výchozí použijte její dialog pro nastavení výchozí aplikace.

checkbox-email-label =
    .label = E-mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Diskusní skupiny
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Kanály
    .tooltiptext = { unset-default-tooltip }

checkbox-calendar-label =
    .label = Kalendář
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
    .label = Povolit službě { system-search-engine-name } prohledávat zprávy
    .accesskey = P

check-on-startup-label =
    .label =
        Vždy kontrolovat při startu { -brand-short-name.gender ->
            [masculine] { -brand-short-name(case: "gen") }
            [feminine] { -brand-short-name(case: "gen") }
            [neuter] { -brand-short-name(case: "gen") }
           *[other] aplikace { -brand-short-name }
        }
    .accesskey = V
