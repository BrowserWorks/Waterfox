# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Mag-ingat sa Pagpatuloy
about-config-intro-warning-text = Ang pagbago sa mga advanced configuration preferences ay maaaring makaapekto sa performance o seguridad ng { -brand-short-name }.
about-config-intro-warning-checkbox = Balaan ako kapag tinangka kong i-access ang mga kagustuhang ito
about-config-intro-warning-button = Tanggapin ang Panganib at Magpatuloy



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Ang pagbago sa mga kagustuhang ito ay maaaring makaapekto sa performance o seguridad ng { -brand-short-name }.

about-config-page-title = Advanced Preferences

about-config-search-input1 =
    .placeholder = Maghanap ng config property
about-config-show-all = Ipakita Lahat

about-config-pref-add-button =
    .title = Magdagdag
about-config-pref-toggle-button =
    .title = i-Toggle
about-config-pref-edit-button =
    .title = Baguhin
about-config-pref-save-button =
    .title = I-save
about-config-pref-reset-button =
    .title = I-reset
about-config-pref-delete-button =
    .title = Burahin

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Numero
about-config-pref-add-type-string = String

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (default)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (custom)
