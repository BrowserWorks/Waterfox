# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integrácia so systémom

system-integration-dialog =
    .buttonlabelaccept = Nastaviť ako predvolený
    .buttonlabelcancel = Preskočiť nastavenie integrácie
    .buttonlabelcancel2 = Zrušiť

default-client-intro = Použiť { -brand-short-name } ako predvolený program pre:

unset-default-tooltip = Ak chcete zrušiť { -brand-short-name } ako predvolený e-mailový klient, použite zamýšľanú predvolenú aplikáciu a jej voľbu 'Nastaviť ako predvolenú aplikáciu'. Túto zmenu nie je možné vykonať priamo v aplikácii { -brand-short-name }.

checkbox-email-label =
    .label = Poštu
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = Diskusné skupiny
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = Informačné kanály (RSS)
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
    .label = Umožniť službe { system-search-engine-name } prehľadávať správy
    .accesskey = U

check-on-startup-label =
    .label = Pri štarte { -brand-short-name }u vždy vykonať túto kontrolu
    .accesskey = a
