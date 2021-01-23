# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Daŭrigu singarde
about-config-intro-warning-text = La ŝanĝo de spertulaj agordaj preferoj povas efiki sur la sekureco kaj efikeco de { -brand-short-name }.
about-config-intro-warning-checkbox = Averti min kiam mi pretas aliri tiujn ĉi preferojn
about-config-intro-warning-button = Akcepti la riskon kaj daŭrigi



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = La ŝanĝo de tiuj ĉi preferoj povas efiki sur la sekureco kaj efikeco de { -brand-short-name }.

about-config-page-title = Spertulaj preferoj

about-config-search-input1 =
    .placeholder = Serĉi nomon de prefero
about-config-show-all = Montri ĉiujn

about-config-pref-add-button =
    .title = Aldoni
about-config-pref-toggle-button =
    .title = Baskuligi
about-config-pref-edit-button =
    .title = Redakti
about-config-pref-save-button =
    .title = Konservi
about-config-pref-reset-button =
    .title = Norma valoro
about-config-pref-delete-button =
    .title = Forigi

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Logika
about-config-pref-add-type-number = Nombra
about-config-pref-add-type-string = Teksta

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (norma)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (personecigita)
