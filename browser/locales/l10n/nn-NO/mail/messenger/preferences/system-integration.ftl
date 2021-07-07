# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Systemintegrasjon
system-integration-dialog =
    .buttonlabelaccept = Vel som standard
    .buttonlabelcancel = Hopp over integrasjon
    .buttonlabelcancel2 = Avbryt
default-client-intro = Bruk { -brand-short-name } som standardprogram for:
unset-default-tooltip = Det er ikkje muleg å fjerne { -brand-short-name } som standardklient i sjølve { -brand-short-name }. For å velje eit anna program som standard må du bruke dette programmet sin 'Vel som standard'-dialog.
checkbox-email-label =
    .label = E-post
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Nyheitsgrupper
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = RSS-kjelder
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = Kalender
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows-søk
       *[other] { "" }
    }
system-search-integration-label =
    .label = Tillat { system-search-engine-name } å søke i meldingar
    .accesskey = T
check-on-startup-label =
    .label = Alltid sjekk dette ved oppstart av { -brand-short-name }
    .accesskey = A
