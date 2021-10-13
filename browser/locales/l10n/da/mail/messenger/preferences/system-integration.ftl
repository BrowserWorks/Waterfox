# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Systemintegration

system-integration-dialog =
    .buttonlabelaccept = Angiv som standard
    .buttonlabelcancel = Undlad integration
    .buttonlabelcancel2 = Fortryd

default-client-intro = Brug { -brand-short-name } som standardprogram til:

unset-default-tooltip = Det er ikke muligt at angive et andet standardprogram end { -brand-short-name } inde fra { -brand-short-name }. For at angive et andet standardprogram skal du gå ind i det ønskede program og der angive, at det skal bruges som standard.

checkbox-email-label =
    .label = Mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Nyhedsgrupper
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Feeds
    .tooltiptext = { unset-default-tooltip }

checkbox-calendar-label =
    .label = Kalender
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Søgning
       *[other] { "" }
    }

system-search-integration-label =
    .label = Tillad { system-search-engine-name } at søge i meddelelser
    .accesskey = S

check-on-startup-label =
    .label = Undersøg altid om { -brand-short-name } er standardmailprogrammet, når det startes
    .accesskey = A
