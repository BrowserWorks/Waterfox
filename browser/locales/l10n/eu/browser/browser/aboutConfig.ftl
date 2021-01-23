# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Kontuz jarraitu
about-config-intro-warning-text = Konfigurazio-hobespen aurreratuak aldatzeak { -brand-short-name }(r)en errendimendu edo segurtasunean eragin lezake.
about-config-intro-warning-checkbox = Abisa nazazu hobespen hauek atzitzen saiatzean
about-config-intro-warning-button = Onartu arriskua eta jarraitu



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Hobespen hauek aldatzeak { -brand-short-name }(r)en errendimendu edo segurtasunean eragin lezake.

about-config-page-title = Hobespen aurreratuak

about-config-search-input1 =
    .placeholder = Bilatu hobespen-izena
about-config-show-all = Erakutsi denak

about-config-pref-add-button =
    .title = Gehitu
about-config-pref-toggle-button =
    .title = Txandakatu
about-config-pref-edit-button =
    .title = Editatu
about-config-pref-save-button =
    .title = Gorde
about-config-pref-reset-button =
    .title = Berrezarri
about-config-pref-delete-button =
    .title = Ezabatu

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolearra
about-config-pref-add-type-number = Zenbakia
about-config-pref-add-type-string = Katea

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (lehenetsia)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (pertsonalizatua)
