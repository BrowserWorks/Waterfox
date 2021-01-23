# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Pokročujće z kedźbliwosću
about-config-intro-warning-text = Hdyž nastajenja rozšěrjeneje konfiguracije změniće, móže to wukon abo wěstotu { -brand-short-name } wobwliwować.
about-config-intro-warning-checkbox = Warnować, hdyž pospytuju, přistup na tute nastajenja dóstać
about-config-intro-warning-button = Riziko akceptować a pokročować



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Hdyž tute nastajenja změniće, móže to wukon abo wěstotu { -brand-short-name } wobwliwować.

about-config-page-title = Rozšěrjene nastajenja

about-config-search-input1 =
    .placeholder = Mjeno nastajenja pytać
about-config-show-all = Wšě pokazać

about-config-pref-add-button =
    .title = Přidać
about-config-pref-toggle-button =
    .title = Přepinać
about-config-pref-edit-button =
    .title = Wobdźěłać
about-config-pref-save-button =
    .title = Składować
about-config-pref-reset-button =
    .title = Wróćo stajić
about-config-pref-delete-button =
    .title = Zhašeć

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Ličba
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
