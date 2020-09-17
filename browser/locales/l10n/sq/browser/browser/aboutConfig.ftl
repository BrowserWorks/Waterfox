# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Vazhdoni me Kujdes
about-config-intro-warning-text = Ndryshimi i parapëlqimeve për formësim të mëtejshëm mund të ketë ndikim në funksionimin dhe sigurinë e { -brand-short-name }-it.
about-config-intro-warning-checkbox = Sinjalizomë kur provoj të hyj në këto parapëlqime
about-config-intro-warning-button = Pranoni Rrezikun dhe Vazhdoni



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Ndryshimi i këtyre parapëlqimeve mund të ketë ndikim në funksionimin dhe sigurinë e { -brand-short-name }-it.

about-config-page-title = Parapëlqime të Mëtejshme

about-config-search-input1 =
    .placeholder = Kërkoni për emër parapëlqimi
about-config-show-all = Shfaqi Krejt

about-config-pref-add-button =
    .title = Shtoni
about-config-pref-toggle-button =
    .title = Këmbeje
about-config-pref-edit-button =
    .title = Përpunojeni
about-config-pref-save-button =
    .title = Ruaje
about-config-pref-reset-button =
    .title = Riktheje te parazgjedhjet
about-config-pref-delete-button =
    .title = Fshije

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Vlerë buleane
about-config-pref-add-type-number = Numër
about-config-pref-add-type-string = Varg

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (parazgjedhje)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (vetjake)
