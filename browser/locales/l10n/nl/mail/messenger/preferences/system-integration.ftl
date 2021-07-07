# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Systeemintegratie
system-integration-dialog =
    .buttonlabelaccept = Als standaard instellen
    .buttonlabelcancel = Integratie overslaan
    .buttonlabelcancel2 = Annuleren
default-client-intro = { -brand-short-name } als de standaardclient gebruiken voor:
unset-default-tooltip = Het is niet mogelijk om het instellen van { -brand-short-name } als de standaardclient binnen { -brand-short-name } ongedaan te maken. Om een andere toepassing de standaardclient te maken, moet u het dialoogvenster ‘Als standaard instellen’ ervan gebruiken.
checkbox-email-label =
    .label = E-mail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Nieuwsgroepen
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Feeds
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = Agenda
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Windows Zoeken
       *[other] { "" }
    }
system-search-integration-label =
    .label = { system-search-engine-name } toestaan om berichten te doorzoeken
    .accesskey = t
check-on-startup-label =
    .label = Deze controle altijd uitvoeren bij het starten van { -brand-short-name }
    .accesskey = D
