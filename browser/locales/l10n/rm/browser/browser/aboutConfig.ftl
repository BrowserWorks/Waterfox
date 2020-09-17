# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Proceder cun precauziun
about-config-intro-warning-text = La modificaziun da la configuraziun da las preferenzas avanzadas po cumprometter la prestaziun u la segirezza da { -brand-short-name }.
about-config-intro-warning-checkbox = Mussar quest avis cun acceder a questas preferenzas
about-config-intro-warning-button = Acceptar la ristga e cuntinuar



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = La modificaziun da questas preferenzas po cumprometter la prestaziun u la segirezza da { -brand-short-name }.

about-config-page-title = Preferenzas avanzadas

about-config-search-input1 =
    .placeholder = Tschertgar in num dad ina preferenza
about-config-show-all = Mussar tut

about-config-pref-add-button =
    .title = Agiuntar
about-config-pref-toggle-button =
    .title = Alternar
about-config-pref-edit-button =
    .title = Modifitgar
about-config-pref-save-button =
    .title = Memorisar
about-config-pref-reset-button =
    .title = Reinizialisar
about-config-pref-delete-button =
    .title = Stizzar

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Dumber
about-config-pref-add-type-string = String

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (predefinì)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (persunalisà)
