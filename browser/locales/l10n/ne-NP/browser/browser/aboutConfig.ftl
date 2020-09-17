# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

##

about-config-show-all = सबै देखाऊ

about-config-pref-add-button =
    .title = थप्नुहोस्
about-config-pref-toggle-button =
    .title = टगल
about-config-pref-edit-button =
    .title = सम्पादन गर्नुहोस्
about-config-pref-save-button =
    .title = बचत गर्नुहोस्
about-config-pref-reset-button =
    .title = रिसेट गर्नुहोस्
about-config-pref-delete-button =
    .title = हटाउनुहोस्

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = बुलियन
about-config-pref-add-type-number = संख्या
about-config-pref-add-type-string = स्ट्रिंग

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value }(पूर्वनिर्धारित)
about-config-pref-accessible-value-custom =
    .aria-label = { $value }(अनुकूलन)
