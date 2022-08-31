# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

troubleshoot-mode-window =
    .title = { -brand-short-name } — tryb rozwiązywania problemów
    .style = width: 37em;

troubleshoot-mode-description = Użyj tego trybu programu { -brand-short-name } do diagnozowania problemów. Dodatki i ustawienia użytkownika zostaną tymczasowo wyłączone.

troubleshoot-mode-description2 = Wszystkie lub niektóre z poniższych zmian można wprowadzić na stałe:

troubleshoot-mode-disable-addons =
    .label = Wyłącz wszystkie dodatki
    .accesskey = W

troubleshoot-mode-reset-toolbars =
    .label = Przywróć domyślne paski narzędzi i przyciski
    .accesskey = P

troubleshoot-mode-change-and-restart =
    .label = Wprowadź zmiany i uruchom ponownie
    .accesskey = z

troubleshoot-mode-continue =
    .label = Kontynuuj w trybie rozwiązywania problemów
    .accesskey = o

troubleshoot-mode-quit =
    .label =
        { PLATFORM() ->
            [windows] Zakończ
           *[other] Zakończ
        }
    .accesskey =
        { PLATFORM() ->
            [windows] k
           *[other] k
        }
