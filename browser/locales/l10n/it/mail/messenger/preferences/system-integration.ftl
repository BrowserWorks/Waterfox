# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integrazione col sistema
system-integration-dialog =
    .buttonlabelaccept = Imposta come predefinito
    .buttonlabelcancel = Salta integrazione
    .buttonlabelcancel2 = Annulla
default-client-intro = Utilizza { -brand-short-name } come programma predefinito per:
unset-default-tooltip = Non è possibile rendere { -brand-short-name } non predefinito dall’interno di { -brand-short-name } stesso. Se si desidera che un’altra applicazione sia la predefinita si deve utilizzare la voce “Rendila predefinita” all’interno della stessa.
checkbox-email-label =
    .label = EMail
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Gruppi di discussione
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Feed
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = Calendario
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Ricerca di Windows
       *[other] { "" }
    }
system-search-integration-label =
    .label = Permetti a { system-search-engine-name } di cercare nei messaggi
    .accesskey = P
check-on-startup-label =
    .label = Esegui sempre questo controllo all’avvio di { -brand-short-name }
    .accesskey = A
