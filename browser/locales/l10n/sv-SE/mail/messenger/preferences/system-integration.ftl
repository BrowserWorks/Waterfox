# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Systemintegration
system-integration-dialog =
    .buttonlabelaccept = Ange som standard
    .buttonlabelcancel = Hoppa över integrationen
    .buttonlabelcancel2 = Avbryt
default-client-intro = Använd { -brand-short-name } som standardklient för:
unset-default-tooltip = Det är inte möjligt att ta bort { -brand-short-name } som standardklient inuti { -brand-short-name }. För att göra ett annat program till standard måste du använda dess 'Ange som standard'-dialog.
checkbox-email-label =
    .label = E-post
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Diskussionsgrupper
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = RSS-kanaler
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = Kalender
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Sök
       *[other] { "" }
    }
system-search-integration-label =
    .label = Låt { system-search-engine-name } söka igenom meddelanden
    .accesskey = L
check-on-startup-label =
    .label = Gör alltid denna kontroll när { -brand-short-name } startar
    .accesskey = G
