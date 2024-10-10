# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

places-open =
    .label = Otwórz
    .accesskey = O
places-open-in-tab =
    .label = Otwórz w nowej karcie
    .accesskey = w
places-open-in-container-tab =
    .label = Otwórz w nowej karcie z kontekstem
    .accesskey = k
places-open-all-bookmarks =
    .label = Otwórz wszystkie zakładki
    .accesskey = O
places-open-all-in-tabs =
    .label = Otwórz wszystkie w kartach
    .accesskey = O
places-open-in-window =
    .label = Otwórz w nowym oknie
    .accesskey = n
places-open-in-private-window =
    .label = Otwórz w nowym oknie prywatnym
    .accesskey = p

places-empty-bookmarks-folder =
    .label = (pusty)

places-add-bookmark =
    .label = Dodaj zakładkę…
    .accesskey = z
places-add-folder-contextmenu =
    .label = Dodaj folder…
    .accesskey = f
places-add-folder =
    .label = Dodaj folder…
    .accesskey = D
places-add-separator =
    .label = Dodaj separator
    .accesskey = s

places-view =
    .label = Widok
    .accesskey = k
places-by-date =
    .label = Według daty
    .accesskey = d
places-by-site =
    .label = Według witryny
    .accesskey = w
places-by-most-visited =
    .label = Według liczby wizyt
    .accesskey = l
places-by-last-visited =
    .label = Według ostatniej wizyty
    .accesskey = o
places-by-day-and-site =
    .label = Według daty i witryny
    .accesskey = t

places-history-search =
    .placeholder = Szukaj w historii
places-history =
    .aria-label = Historia
places-bookmarks-search =
    .placeholder = Szukaj w zakładkach

places-delete-domain-data =
    .label = Usuń całą witrynę
    .accesskey = w
places-sortby-name =
    .label = Sortuj wg nazw
    .accesskey = r
# places-edit-bookmark and places-edit-generic will show one or the other and can have the same access key.
places-edit-bookmark =
    .label = Edytuj zakładkę…
    .accesskey = E
places-edit-generic =
    .label = Edytuj…
    .accesskey = E
places-edit-folder2 =
    .label = Edytuj folder…
    .accesskey = E
places-delete-folder =
    .label =
        { $count ->
            [1] Usuń folder
           *[other] Usuń foldery
        }
    .accesskey = U
# Variables:
#   $count (number) - The number of pages selected for removal.
places-delete-page =
    .label =
        { $count ->
            [1] Usuń tę stronę
           *[other] Usuń te strony
        }
    .accesskey = s

# Managed bookmarks are created by an administrator and cannot be changed by the user.
managed-bookmarks =
    .label = Zakładki zarządzane przez administratora
# This label is used when a managed bookmarks folder doesn't have a name.
managed-bookmarks-subfolder =
    .label = Podfolder

# This label is used for the "Other Bookmarks" folder that appears in the bookmarks toolbar.
other-bookmarks-folder =
    .label = Pozostałe zakładki

places-show-in-folder =
    .label = Pokaż w folderze
    .accesskey = P

# Variables:
# $count (number) - The number of elements being selected for removal.
places-delete-bookmark =
    .label =
        { $count ->
            [1] Usuń zakładkę
           *[other] Usuń zakładki
        }
    .accesskey = U

# Variables:
#   $count (number) - The number of bookmarks being added.
places-create-bookmark =
    .label =
        { $count ->
            [1] Dodaj zakładkę do tej strony…
           *[other] Dodaj zakładki do tych stron…
        }
    .accesskey = D

places-untag-bookmark =
    .label = Usuń etykietę
    .accesskey = s

places-manage-bookmarks =
    .label = Zarządzaj zakładkami
    .accesskey = Z

places-forget-about-this-site-confirmation-title = Usuwanie całej witryny

# Variables:
# $hostOrBaseDomain (string) - The base domain (or host in case there is no base domain) for which data is being removed
places-forget-about-this-site-confirmation-msg = Spowoduje to usunięcie danych powiązanych z witryną { $hostOrBaseDomain }, w tym historię, ciasteczka, pamięć podręczną i preferencje dotyczące treści. Powiązane zakładki i hasła nie zostaną usunięte. Czy na pewno kontynuować?

places-forget-about-this-site-forget = Usuń całą witrynę

places-library3 =
    .title = Biblioteka

places-organize-button =
    .label = Zarządzaj
    .tooltiptext = Zarządzaj zakładkami
    .accesskey = Z

places-organize-button-mac =
    .label = Zarządzaj
    .tooltiptext = Zarządzaj zakładkami

places-file-close =
    .label = Zamknij
    .accesskey = Z

places-cmd-close =
    .key = w

places-view-button =
    .label = Widoki
    .tooltiptext = Zmień widok
    .accesskey = W

places-view-button-mac =
    .label = Widoki
    .tooltiptext = Zmień widok

places-view-menu-columns =
    .label = Wyświetl kolumny
    .accesskey = k

places-view-menu-sort =
    .label = Sortuj
    .accesskey = S

places-view-sort-unsorted =
    .label = Nieposortowane
    .accesskey = N

places-view-sort-ascending =
    .label = Porządek sortowania A > Z
    .accesskey = A

places-view-sort-descending =
    .label = Porządek sortowania Z > A
    .accesskey = Z

places-maintenance-button =
    .label = Importowanie i kopie zapasowe
    .tooltiptext = Importuj zakładki lub utwórz ich kopie zapasowe
    .accesskey = I

places-maintenance-button-mac =
    .label = Importowanie i kopie zapasowe
    .tooltiptext = Importuj zakładki lub utwórz ich kopie zapasowe

places-cmd-backup =
    .label = Utwórz kopię zapasową…
    .accesskey = U

places-cmd-restore =
    .label = Przywróć
    .accesskey = P

places-cmd-restore-from-file =
    .label = Wybierz plik…
    .accesskey = W

places-import-bookmarks-from-html =
    .label = Importuj zakładki z pliku HTML…
    .accesskey = I

places-export-bookmarks-to-html =
    .label = Eksportuj zakładki do pliku HTML…
    .accesskey = E

places-import-other-browser =
    .label = Importuj dane z innej przeglądarki…
    .accesskey = d

places-view-sort-col-name =
    .label = Nazwa

places-view-sort-col-tags =
    .label = Etykiety

places-view-sort-col-url =
    .label = Adres

places-view-sort-col-most-recent-visit =
    .label = Ostatnia wizyta

places-view-sort-col-visit-count =
    .label = Liczba wizyt

places-view-sort-col-date-added =
    .label = Dodano

places-view-sort-col-last-modified =
    .label = Ostatnia modyfikacja

places-view-sortby-name =
    .label = Sortuj według nazw
    .accesskey = n
places-view-sortby-url =
    .label = Sortuj według adresu
    .accesskey = a
places-view-sortby-date =
    .label = Sortuj według daty ostatniej wizyty
    .accesskey = d
places-view-sortby-visit-count =
    .label = Sortuj według liczby wizyt
    .accesskey = c
places-view-sortby-date-added =
    .label = Sortuj według daty dodania
    .accesskey = n
places-view-sortby-last-modified =
    .label = Sortuj według daty ostatniej modyfikacji
    .accesskey = m
places-view-sortby-tags =
    .label = Sortuj według etykiet
    .accesskey = e

places-cmd-find-key =
    .key = f

places-back-button =
    .tooltiptext = Przejdź wstecz

places-forward-button =
    .tooltiptext = Przejdź do przodu

places-details-pane-select-an-item-description = Zaznacz element, by wyświetlić i edytować jego właściwości

places-details-pane-no-items =
    .value = Brak elementów
# Variables:
#   $count (Number): number of items
places-details-pane-items-count =
    .value =
        { $count ->
            [one] Jeden element
            [few] { $count } elementy
           *[many] { $count } elementów
        }

## Strings used as a placeholder in the Library search field. For example,
## "Search History" stands for "Search through the browser's history".

places-search-bookmarks =
    .placeholder = Szukaj w zakładkach
places-search-history =
    .placeholder = Szukaj w historii
places-search-downloads =
    .placeholder = Szukaj w pobranych plikach

##

places-locked-prompt = System zakładek i historii nie będzie działał, ponieważ jeden z plików programu { -brand-short-name } jest używany przez inną aplikację. Niektóre programy związane z bezpieczeństwem mogą powodować ten problem.
