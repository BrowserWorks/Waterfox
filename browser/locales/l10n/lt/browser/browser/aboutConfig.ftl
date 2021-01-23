# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Elkitės atsargiai
about-config-intro-warning-text = Išplėstinių nuostatų keitimas gali paveikti „{ -brand-short-name }“ veikimą arba saugumą.
about-config-intro-warning-checkbox = Įspėti prieš patenkant į šias nuostatas
about-config-intro-warning-button = Priimti riziką ir tęsti



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Šių nuostatų keitimas gali paveikti „{ -brand-short-name }“ veikimą arba saugumą.

about-config-page-title = Išplėstinės nuostatos

about-config-search-input1 =
    .placeholder = Ieškoti nuostatos pavadinimo
about-config-show-all = Rodyti viską

about-config-pref-add-button =
    .title = Pridėti
about-config-pref-toggle-button =
    .title = Perjungti
about-config-pref-edit-button =
    .title = Keisti
about-config-pref-save-button =
    .title = Įrašyti
about-config-pref-reset-button =
    .title = Atstatyti
about-config-pref-delete-button =
    .title = Pašalinti

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Loginis
about-config-pref-add-type-number = Skaičius
about-config-pref-add-type-string = Simbolių eilutė

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (numatytoji)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (pakeista)
