# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integration de systema

system-integration-dialog =
    .buttonlabelaccept = Stabilir como predeterminate
    .buttonlabelcancel = Saltar integration
    .buttonlabelcancel2 = Cancellar

default-client-intro = Usar { -brand-short-name } como cliente predefinite pro:

unset-default-tooltip = Impossibile eliminar { -brand-short-name } del cliente predefinite in { -brand-short-name }. Pro render predefinite un altere application tu debe usar su fenestra de dialogo 'Predefinir'

checkbox-email-label =
    .label = Email
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Gruppos de discussion
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Fluxos
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
    .label = Permitter a { system-search-engine-name } de cercar messages
    .accesskey = c

check-on-startup-label =
    .label = Facer sempre iste controlo al initio de { -brand-short-name }
    .accesskey = s
