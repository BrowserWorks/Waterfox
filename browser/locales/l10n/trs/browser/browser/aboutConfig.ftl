# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Ga gudadû gan'anjt ne' ñaan
about-config-intro-warning-text = Sisi nadunat sa anïn ruhuât nan ni ga'ue ga'uì' yi'ìj da' hìo 'iaj sunj asi { -brand-short-name }
about-config-intro-warning-checkbox = Gunumà 'ngo nuguan'an gini'ia ngà gatu ñú riña nej sa hua dànanj
about-config-intro-warning-button = Garayinaj sa gahuin ni yakà gan'àn ne'ñaa



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Sisi nadunat sa hua riña nan ni ga'ue ga'uì' yi'ìj dàj 'iaj sun asi sa huì hua { -brand-short-name }.

about-config-page-title = Sa tàj ñaan doj sa garan' ruhuât

about-config-search-input1 =
    .placeholder = Si yugui sa nana'ui' yitïnjt
about-config-show-all = Nadigân Daran'anj

about-config-pref-add-button =
    .title = Nutà'
about-config-pref-toggle-button =
    .title = Toogle
about-config-pref-edit-button =
    .title = Nagi'iaj
about-config-pref-save-button =
    .title = Na'nïnj sà'
about-config-pref-reset-button =
    .title = Nagi'iaj ñû
about-config-pref-delete-button =
    .title = Dure'

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Nûmero
about-config-pref-add-type-string = Sa nanikò' dugui'i

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (sa 'na' niñaa)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (sa hua yitïnj ïn)
