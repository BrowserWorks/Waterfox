# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains the entities needed to use the Find Bar.

findbar-next =
    .tooltiptext = Znajdź następne wystąpienie wyszukiwanej frazy
findbar-previous =
    .tooltiptext = Znajdź poprzednie wystąpienie wyszukiwanej frazy

findbar-find-button-close =
    .tooltiptext = Zamknij pasek wyszukiwania

findbar-highlight-all2 =
    .label = Wyróżnianie wszystkich
    .accesskey =
        { PLATFORM() ->
            [macos] W
           *[other] W
        }
    .tooltiptext = Wyróżnij wszystkie wystąpienia szukanej frazy

findbar-case-sensitive =
    .label = Rozróżnianie wielkości liter
    .accesskey = R
    .tooltiptext = Rozróżniaj wielkość liter przy wyszukiwaniu

findbar-match-diacritics =
    .label = Rozróżnianie liter diakrytyzowanych
    .accesskey = o
    .tooltiptext = Rozróżniaj między literami ze znakami diakrytycznymi a ich literami bazowymi (np. podczas wyszukiwania słowa „przeglądarka” słowo „przegladarka” nie będzie dopasowywane)

findbar-entire-word =
    .label = Całe słowa
    .accesskey = C
    .tooltiptext = Wyszukuj tylko całe słowa

findbar-not-found = Szukany tekst nie został odnaleziony.

findbar-wrapped-to-top = Koniec strony. Wyszukiwanie od początku.
findbar-wrapped-to-bottom = Początek strony. Wyszukiwanie od końca.

findbar-normal-find =
    .placeholder = Znajdź na stronie
findbar-fast-find =
    .placeholder = Znajdź szybko
findbar-fast-find-links =
    .placeholder = Znajdź szybko (tylko odnośniki)

findbar-case-sensitive-status =
    .value = (z rozróżnianiem wielkości liter)
findbar-match-diacritics-status =
    .value = (z rozróżnianiem liter diakrytyzowanych)
findbar-entire-word-status =
    .value = (tylko całe słowa)

# Variables:
#   $current (Number): Index of the currently selected match
#   $total (Number): Total count of matches
findbar-found-matches =
    .value =
        { $total ->
            [one] Jedyne trafienie
            [few] { $current }. z { $total } trafień
           *[many] { $current }. z { $total } trafień
        }

# Variables:
#   $limit (Number): Total count of matches allowed before counting stops
findbar-found-matches-count-limit =
    .value =
        { $limit ->
            [one] Więcej niż jedno trafienie
            [few] Więcej niż { $limit } trafienia
           *[many] Więcej niż { $limit } trafień
        }
