# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

config-window =
    .title = about:config

## Strings used to display a warning in about:config

# This text should be attention grabbing and playful
config-about-warning-title =
    .value = Groźba utraty gwarancji!
config-about-warning-text = Modyfikacja tych ustawień może spowodować problemy, takie jak utrata stabilności i wydajności programu oraz zagrożenie bezpieczeństwa. Kontynuuj tylko wtedy, gdy masz pewność tego, co robisz.
config-about-warning-button =
    .label = Akceptuję ryzyko
config-about-warning-checkbox =
    .label = Wyświetl to ostrzeżenie następnym razem

config-search-prefs =
    .value = Szukaj:
    .accesskey = S

config-focus-search =
    .key = r

config-focus-search-2 =
    .key = f

## These strings are used for column headers

config-pref-column =
    .label = Nazwa
config-lock-column =
    .label = Stan
config-type-column =
    .label = Typ
config-value-column =
    .label = Wartość

## These strings are used for tooltips

config-pref-column-header =
    .tooltip = Kliknij, aby posortować
config-column-chooser =
    .tooltip = Kliknij, aby wybrać kolumny, które zostaną wyświetlone

## These strings are used for the context menu

config-copy-pref =
    .key = C
    .label = Kopiuj
    .accesskey = K

config-copy-name =
    .label = Kopiuj nazwę
    .accesskey = n

config-copy-value =
    .label = Kopiuj wartość
    .accesskey = w

config-modify =
    .label = Modyfikuj
    .accesskey = M

config-toggle =
    .label = Przełącz
    .accesskey = P

config-reset =
    .label = Resetuj
    .accesskey = R

config-new =
    .label = Dodaj ustawienie typu
    .accesskey = D

config-string =
    .label = Łańcuch (string)
    .accesskey = s

config-integer =
    .label = Liczba całkowita (integer)
    .accesskey = I

config-boolean =
    .label = Wartość logiczna (boolean)
    .accesskey = B

config-default = domyślny
config-modified = zmodyfikowany
config-locked = zablokowany

config-property-string = łańcuch
config-property-int = liczba całkowita
config-property-bool = wartość logiczna

config-new-prompt = Wprowadź nazwę nowego ustawienia

config-nan-title = Nieprawidłowa wartość
config-nan-text = Wprowadzony tekst nie jest liczbą.

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-new-title = Nowe ustawienie typu „{ $type }”

# Variables:
#   $type (String): type of value (boolean, integer or string)
config-modify-title = Wprowadź wartość ustawienia typu „{ $type }”
