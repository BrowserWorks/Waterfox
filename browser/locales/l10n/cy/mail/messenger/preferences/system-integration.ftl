# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integreiddio System

system-integration-dialog =
    .buttonlabelaccept = Gosod fel Rhagosodiad
    .buttonlabelcancel = Hepgor Integreiddio
    .buttonlabelcancel2 = Diddymu

default-client-intro = Defnyddio { -brand-short-name } fel y rhaglen rhagosodedig ar gyfer:

unset-default-tooltip = Nid yw'n bosib dadosod { -brand-short-name } fel y cleient rhagosodedig o fewn { -brand-short-name }. I wneud rhaglen arall y rhagosodedig rhaid defnyddio ei ddeialog 'Gosod fel y rhagosodedig' ei hun.

checkbox-email-label =
    .label = E-Bost
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Grwpiau Newyddion
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Llif
    .tooltiptext = { unset-default-tooltip }

# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Sbotolau
        [windows] Chwilio Ffenestri
       *[other] { "" }
    }

system-search-integration-label =
    .label = Caniatáu i { system-search-engine-name } chwilio drwy'r negeseuon
    .accesskey = C

check-on-startup-label =
    .label = Gwirio hwn bob tro wrth gychwyn { -brand-short-name }
    .accesskey = G
