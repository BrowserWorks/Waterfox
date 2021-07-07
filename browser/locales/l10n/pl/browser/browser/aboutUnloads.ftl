# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings used in about:unloads, allowing users to manage the "tab unloading"
### feature.

about-unloads-page-title = Zwalnianie kart
about-unloads-intro-1 =
    { -brand-short-name } ma funkcję automatycznie zwalniającą karty,
    aby zapobiec awariom programu z powodu niewystarczającej pamięci,
    kiedy na komputerze jest mało dostępnej pamięci. Następna karta
    do zwolnienia jest wybierana na podstawie kilku cech. Ta strona
    pokazuje, jak { -brand-short-name } ustala priorytety kart i która karta
    zostanie zwolniona po spełnieniu warunków.
about-unloads-intro-2 =
    Istniejące karty są wyświetlane w poniższej tabeli w tej samej kolejności,
    w jakiej { -brand-short-name } wybiera następną kartę do zwolnienia.
    Identyfikatory procesów są <strong>pogrubione</strong>, kiedy
    zawierają główną ramkę karty, a <em>pochylone</em>, kiedy proces
    jest współdzielony między różnymi kartami. Można ręcznie wywołać
    zwolnienie karty klikając przycisk <em>Zwolnij</em> poniżej.
about-unloads-last-updated = Ostatnia aktualizacja: { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-button-unload = Zwolnij
    .title = Zwolnij kartę o najwyższym priorytecie
about-unloads-no-unloadable-tab = Nie ma kart do zwolnienia.
about-unloads-column-priority = Priorytet
about-unloads-column-host = Host
about-unloads-column-last-accessed = Ostatni dostęp
about-unloads-column-weight = Waga podstawowa
    .title = Karty są najpierw porządkowane według tej wartości, która jest pochodną pewnych specjalnych cech, takich jak odtwarzanie dźwięku, WebRTC itp.
about-unloads-column-sortweight = Waga dodatkowa
    .title = Jeśli dostępne, karty są porządkowane według tej wartości po uporządkowaniu według wagi podstawowej. Wartość jest pochodną użycia pamięci przez kartę i liczby procesów.
about-unloads-column-memory = Pamięć
    .title = Szacowane użycie pamięci przez kartę
about-unloads-column-processes = Identyfikatory procesów
    .title = Identyfikatory procesów zawierających treść karty
about-unloads-last-accessed = { DATETIME($date, year: "numeric", month: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric", hour12: "false") }
about-unloads-memory-in-mb = { NUMBER($mem, maxFractionalUnits: 2) } MB
about-unloads-memory-in-mb-tooltip =
    .title = { NUMBER($mem, maxFractionalUnits: 2) } MB
