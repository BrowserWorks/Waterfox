# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-button = Riski qəbul et və davam et

##

about-config-page-title = Təkmilləşmiş Nizamlamalar

about-config-show-all = Hamısını göstər

about-config-pref-add-button =
    .title = Əlavə et
about-config-pref-toggle-button =
    .title = Aç/Qapa
about-config-pref-edit-button =
    .title = Düzəlt
about-config-pref-save-button =
    .title = Saxla
about-config-pref-reset-button =
    .title = Sıfırla
about-config-pref-delete-button =
    .title = Sil

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Rəqəm
about-config-pref-add-type-string = Sətir

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (standart)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (fərdi)
