# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integraziun en il sistem

system-integration-dialog =
    .buttonlabelaccept = Definir sco standard
    .buttonlabelcancel = Sursiglir l'integraziun
    .buttonlabelcancel2 = Interrumper

default-client-intro = Duvrar { -brand-short-name } sco applicaziun predefinida per:

unset-default-tooltip = Impussibel dad allontanar { -brand-short-name } sco applicaziun da standard entaifer { -brand-short-name }. Per definir in'autra applicaziun sco applicaziun predefinida stos ti utilisar la funcziun 'Definir sco standard' en l'applicaziun correspundenta.

checkbox-email-label =
    .label = E-mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Gruppas da discussiun
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Feeds
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Tschertgader da Windows
       *[other] { "" }
    }

system-search-integration-label =
    .label = Permetter a { system-search-engine-name } da retschertgar messadis
    .accesskey = s

check-on-startup-label =
    .label = Controllar mintga giada che { -brand-short-name } vegn avià
    .accesskey = A
