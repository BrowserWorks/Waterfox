# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

system-integration-title =
    .title = Integracja z systemem operacyjnym
system-integration-dialog =
    .buttonlabelaccept = Ustaw jako domyślny
    .buttonlabelcancel = Pomiń integrację
    .buttonlabelcancel2 = Anuluj
default-client-intro = { -brand-short-name } ma być domyślnym klientem:
unset-default-tooltip = Nie jest możliwe usunięcie programu { -brand-short-name } z roli domyślnego klienta z poziomu programu { -brand-short-name }. Aby uczynić inny program domyślnym klientem, należy skorzystać z jego możliwości integracji z systemem operacyjnym.
checkbox-email-label =
    .label = poczty
    .tooltiptext = { unset-default-tooltip }
checkbox-newsgroups-label =
    .label = grup dyskusyjnych
    .tooltiptext = { unset-default-tooltip }
checkbox-feeds-label =
    .label = źródeł aktualności
    .tooltiptext = { unset-default-tooltip }
checkbox-calendar-label =
    .label = kalendarza
    .tooltiptext = { unset-default-tooltip }
# Note: This is the search engine name for all the different platforms.
# Platforms that don't support it should be left blank.
system-search-engine-name =
    { PLATFORM() ->
        [macos] Spotlight
        [windows] Usługa wyszukiwania systemu Windows
       *[other] { "" }
    }
system-search-integration-label =
    .label = Zezwalaj programowi { system-search-engine-name } na wyszukiwanie wiadomości
    .accesskey = Z
check-on-startup-label =
    .label = Sprawdzaj te ustawienia zawsze podczas uruchamiania programu { -brand-short-name }
    .accesskey = S
