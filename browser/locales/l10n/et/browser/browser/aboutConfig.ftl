# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Jätka ettevaatlikult
about-config-intro-warning-text = Parameetrite muutmine võib mõjutada { -brand-short-name }i jõudlust ja turvalisust.
about-config-intro-warning-checkbox = Nende sätete avamisel kuvatakse seda teadet
about-config-intro-warning-button = Nõustu riskiga ja jätka



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Parameetrite muutmine võib mõjutada { -brand-short-name }i jõudlust ja turvalisust.

about-config-page-title = Täpsem häälestamine

about-config-search-input1 =
    .placeholder = Otsi parameetri nime
about-config-show-all = Kuva kõiki

about-config-pref-add-button =
    .title = Lisa
about-config-pref-toggle-button =
    .title = Lülita ümber
about-config-pref-edit-button =
    .title = Muuda
about-config-pref-save-button =
    .title = Salvesta
about-config-pref-reset-button =
    .title = Lähtesta
about-config-pref-delete-button =
    .title = Kustuta

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = tõeväärtus
about-config-pref-add-type-number = number
about-config-pref-add-type-string = string

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (vaikimisi)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (kohandatud)
