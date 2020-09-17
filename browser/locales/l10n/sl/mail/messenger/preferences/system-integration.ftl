# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Vključitev v sistem

system-integration-dialog =
    .buttonlabelaccept = Nastavi kot privzeto
    .buttonlabelcancel = Ne zdaj
    .buttonlabelcancel2 = Prekliči

default-client-intro = Uporabi { -brand-short-name } kot privzeti program za:

unset-default-tooltip = { -brand-short-name }a ni mogoče odstraniti kot privzetega odjemalca znotraj { -brand-short-name }a. Če želite privzeto uporabljati drug program, uporabite njegovo pogovorno okno 'Nastavi kot privzeto'.

checkbox-email-label =
    .label = E-pošto
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Novičarske skupine
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Vire
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] iskalniku Spotlight
        [windows] iskanju Windows
       *[other] { "" }
    }

system-search-integration-label =
    .label = Dovoli { system-search-engine-name } iskanje po sporočilih
    .accesskey = D

check-on-startup-label =
    .label = Vedno preveri ob zagonu { -brand-short-name }a
    .accesskey = V
