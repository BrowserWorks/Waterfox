# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

##

about-config-show-all = அனைத்தையும் காட்டு

about-config-pref-add-button =
    .title = சேர்
about-config-pref-toggle-button =
    .title = நிலைமாற்று
about-config-pref-edit-button =
    .title = தொகு
about-config-pref-save-button =
    .title = சேமி
about-config-pref-reset-button =
    .title = மீட்டமை
about-config-pref-delete-button =
    .title = அழி

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = பூலியன்
about-config-pref-add-type-number = எண்
about-config-pref-add-type-string = சரம்

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (இயல்புநிலை)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (தனிப்பயனாக்கு)
