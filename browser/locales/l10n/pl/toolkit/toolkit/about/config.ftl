# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Zachowaj ostrożność
about-config-intro-warning-text = Modyfikacja zaawansowanych preferencji może wpłynąć na wydajność lub bezpieczeństwo programu { -brand-short-name }.
about-config-intro-warning-checkbox = Wyświetlanie tego ostrzeżenia za każdym razem
about-config-intro-warning-button = Akceptuję ryzyko, kontynuuj

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Modyfikacja tych preferencji może wpłynąć na wydajność lub bezpieczeństwo programu { -brand-short-name }.
about-config-page-title = Preferencje zaawansowane
about-config-search-input1 =
    .placeholder = Szukaj preferencji
about-config-show-all = Wyświetl wszystko
about-config-show-only-modified = Wyświetlaj tylko zmodyfikowane preferencje
about-config-pref-add-button =
    .title = Dodaj
about-config-pref-toggle-button =
    .title = Przełącz
about-config-pref-edit-button =
    .title = Edytuj
about-config-pref-save-button =
    .title = Zapisz
about-config-pref-reset-button =
    .title = Resetuj
about-config-pref-delete-button =
    .title = Usuń

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Wartość logiczna
about-config-pref-add-type-number = Liczba
about-config-pref-add-type-string = Łańcuch

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (domyślne)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (zmienione)
