# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Fortset med varsemd
about-config-intro-warning-text = Endrar du avanserte konfigurasjonsinnstillingar kan det påverke yting eller sikkerheit i { -brand-short-name }.
about-config-intro-warning-checkbox = Åtvar meg når eg prøver å få tilgang til desse innstillingane
about-config-intro-warning-button = Godta risikoen og fortsett



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Endring av desse innstillingane kan påverke yting eller sikkerheit i { -brand-short-name }

about-config-page-title = Avanserte innstillingar

about-config-search-input1 =
    .placeholder = Søk på innstillingsnamn
about-config-show-all = Vis alt

about-config-pref-add-button =
    .title = Legg til
about-config-pref-toggle-button =
    .title = Veksle
about-config-pref-edit-button =
    .title = Rediger
about-config-pref-save-button =
    .title = Lagre
about-config-pref-reset-button =
    .title = Nullstill
about-config-pref-delete-button =
    .title = Slett

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolsk
about-config-pref-add-type-number = Tal
about-config-pref-add-type-string = Streng

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (standard)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (tilpassa)
