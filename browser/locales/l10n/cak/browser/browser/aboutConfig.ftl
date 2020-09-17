# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Tachajij awi' chi Rub'anik
about-config-intro-warning-text = Kejal ri q'axinäq taq rajowaxik nuk'ulem, nitikir nutz'ila' rub'eyal nisamäj o ri rujikomal { -brand-short-name }.
about-config-intro-warning-checkbox = Tiya' rutzijol chwe toq yinok pa re taq ajowaxik re'.
about-config-intro-warning-button = Xinwetamaj ri K'ayewal chuqa' Tinsamajij el

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Kejal re taq rajowaxik nitikir nutz'ila' rub'eyal nisamäj o ri rujikomal { -brand-short-name }.

about-config-page-title = Q'axinäq taq Ajowanïk

about-config-search-input1 =
    .placeholder = Rub'i' rajowaxik kanoxïk
about-config-show-all = Tik'ut Ronojel

about-config-pref-add-button =
    .title = Titz'aqatisäx
about-config-pref-toggle-button =
    .title = Tik'exlöx
about-config-pref-edit-button =
    .title = Nuk'b'äl
about-config-pref-save-button =
    .title = Tiyak
about-config-pref-reset-button =
    .title = Titzolïx
about-config-pref-delete-button =
    .title = Tiyuj

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Ja'/manäq
about-config-pref-add-type-number = Ajilab'äl
about-config-pref-add-type-string = Cholajil

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (k'o wi)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (ichinan)
