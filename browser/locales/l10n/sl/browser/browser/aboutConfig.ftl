# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Nadaljujte previdno
about-config-intro-warning-text = Spreminjanje naprednih nastavitev lahko vpliva na delovanje ali varnost { -brand-short-name }a.
about-config-intro-warning-checkbox = Opozori me, ko poskušam uporabljati te nastavitve
about-config-intro-warning-button = Sprejmi tveganje in nadaljuj



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Spreminjanje teh nastavitev lahko vpliva na delovanje ali varnost { -brand-short-name }a.

about-config-page-title = Napredne nastavitve

about-config-search-input1 =
    .placeholder = Iskanje imena nastavitve
about-config-show-all = Prikaži vse

about-config-pref-add-button =
    .title = Dodaj
about-config-pref-toggle-button =
    .title = Preklopi
about-config-pref-edit-button =
    .title = Uredi
about-config-pref-save-button =
    .title = Shrani
about-config-pref-reset-button =
    .title = Ponastavi
about-config-pref-delete-button =
    .title = Izbriši

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Logična vrednost
about-config-pref-add-type-number = Število
about-config-pref-add-type-string = Niz

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (privzeto)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (po meri)
