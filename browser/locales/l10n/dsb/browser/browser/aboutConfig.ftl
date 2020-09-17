# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Z glědanim pókšacowaś
about-config-intro-warning-text = Gaž nastajenja rozšyrjoneje konfiguracije změnijośo, móžo to wugbaśe abo wěstotu { -brand-short-name } wobwliwowaś.
about-config-intro-warning-checkbox = Warnowaś, gaž wopytujom, pśistup k tutym nastajenjam dostaś
about-config-intro-warning-button = Riziko akceptěrowaś a pókšacowaś



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Gaž toś te nastajenja změnijośo, móžo to wugbaśe abo wěstotu { -brand-short-name } wobwliwowaś.

about-config-page-title = Rozšyrjone nastajenja

about-config-search-input1 =
    .placeholder = Mě nastajenja pytaś
about-config-show-all = Wšykne pokazaś

about-config-pref-add-button =
    .title = Pśidaś
about-config-pref-toggle-button =
    .title = Pśešaltowaś
about-config-pref-edit-button =
    .title = Wobźěłaś
about-config-pref-save-button =
    .title = Składowaś
about-config-pref-reset-button =
    .title = Slědk stajiś
about-config-pref-delete-button =
    .title = Lašowaś

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Licba
about-config-pref-add-type-string = String

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (standard)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (swójski)
