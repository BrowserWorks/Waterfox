# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Continuă cu prudență
about-config-intro-warning-text = Modificarea preferințelor avansate de configurare poate afecta performanța sau securitatea din { -brand-short-name }.
about-config-intro-warning-checkbox = Avertizează-mă când încerc să accesez aceste preferințe
about-config-intro-warning-button = Acceptă riscul și continuă

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Modificarea acestor preferințe poate afecta performanța sau securitatea din { -brand-short-name }.

about-config-page-title = Preferințe avansate

about-config-search-input1 =
    .placeholder = Caută numele preferinței
about-config-show-all = Afișează tot

about-config-pref-add-button =
    .title = Adaugă
about-config-pref-toggle-button =
    .title = Comută
about-config-pref-edit-button =
    .title = Editează
about-config-pref-save-button =
    .title = Salvează
about-config-pref-reset-button =
    .title = Resetează
about-config-pref-delete-button =
    .title = Șterge

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Număr
about-config-pref-add-type-string = Șir

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (implicit)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personalizat)
