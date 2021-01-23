# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Vanni avanti ma atento
about-config-intro-warning-button = Acetta o reizego e vanni avanti

##

about-config-page-title = Preferense avansæ

about-config-search-input1 =
    .placeholder = Çerca nomme preferensa
about-config-show-all = Fanni vedde tutto

about-config-pref-add-button =
    .title = Azonzi
about-config-pref-toggle-button =
    .title = Cangia
about-config-pref-edit-button =
    .title = Cangia
about-config-pref-save-button =
    .title = Sarva
about-config-pref-reset-button =
    .title = Reinpòsta
about-config-pref-delete-button =
    .title = Scancella

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boleano
about-config-pref-add-type-number = Numero
about-config-pref-add-type-string = Stringa

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (predefinio)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personâ)
