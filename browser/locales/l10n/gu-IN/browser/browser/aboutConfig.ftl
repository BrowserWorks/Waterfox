# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = સાવધાની સાથે આગળ વધો
about-config-intro-warning-text = અદ્યતન ગોઠવણી પસંદગીઓ બદલવી { -brand-short-name } કામગીરી અથવા સુરક્ષાને અસર કરી શકે છે.
about-config-intro-warning-checkbox = જ્યારે હું આ પસંદગીઓને ઍક્સેસ કરવાનો પ્રયત્ન કરું ત્યારે મને ચેતવણી આપો
about-config-intro-warning-button = જોખમ સ્વીકારો અને ચાલુ રાખો



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = આ પસંદગીઓને બદલવાથી { -brand-short-name } કામગીરી અથવા સુરક્ષાને અસર થઈ શકે છે.

about-config-page-title = અદ્યતન પસંદગીઓ

about-config-search-input1 =
    .placeholder = શોધ પસંદગી નામ
about-config-show-all = બધું બતાવો

about-config-pref-add-button =
    .title = ઉમેરો
about-config-pref-toggle-button =
    .title = ટૉગલ કરો
about-config-pref-edit-button =
    .title = ફેરફાર કરો
about-config-pref-save-button =
    .title = સાચવો
about-config-pref-reset-button =
    .title = ફરીથી સેટ કરો
about-config-pref-delete-button =
    .title = કાઢી નાખો

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = બુલિયન
about-config-pref-add-type-number = નંબર
about-config-pref-add-type-string = શબ્દમાળા

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (મૂળભૂત)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (વૈવિધ્યપૂર્ણ)
