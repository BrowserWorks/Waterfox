# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = Ehtiyotkorlik bilan davom eting
about-config-intro-warning-text = Qoʻshimcha sozlamalarni oʻzgartirsangiz, { -brand-short-name } samaradorligi yoki xavfsizligiga taʼsir qilishi mumkin.
about-config-intro-warning-checkbox = Bu parametrlarga kirishga harakat qilganimda, meni ogohlantir
about-config-intro-warning-button = Xavfni oʻz zimmamga olaman va davom etaman



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = Bu parametlarni oʻzgartirsangiz, { -brand-short-name } samaradorligi yoki xavfsizligiga taʼsir qilishi mumkin.

about-config-page-title = Qoʻshimcha parametrlar

about-config-search-input1 =
    .placeholder = Parametr nomini izlash
about-config-show-all = Hammasini koʻrsatish

about-config-pref-add-button =
    .title = Qoʻshish
about-config-pref-toggle-button =
    .title = Almashish
about-config-pref-edit-button =
    .title = Tahrirlash
about-config-pref-save-button =
    .title = Saqlash
about-config-pref-reset-button =
    .title = Tiklash
about-config-pref-delete-button =
    .title = Oʻchirish

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = Boolean
about-config-pref-add-type-number = Raqam
about-config-pref-add-type-string = Qator

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
