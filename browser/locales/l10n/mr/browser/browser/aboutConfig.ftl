# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = सावधानतापूर्वक पुढे जा
about-config-intro-warning-button = जोखिम स्वीकारा आणि पुढे चला



##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = ही प्राधान्ये बदलल्यास { -brand-short-name } कार्यक्षमता किंवा सुरक्षिततेवर परिणाम होऊ शकतो.

about-config-page-title = प्रगत प्राधान्यक्रम

about-config-search-input1 =
    .placeholder = प्राधान्य नाव शोधा
about-config-show-all = सर्व दर्शवा

about-config-pref-add-button =
    .title = जोडा
about-config-pref-toggle-button =
    .title = बदला
about-config-pref-edit-button =
    .title = संपादित करा
about-config-pref-save-button =
    .title = साठवा
about-config-pref-reset-button =
    .title = मूळस्थितीत आणा
about-config-pref-delete-button =
    .title = नष्ट करा

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = बुलियन
about-config-pref-add-type-number = संख्या
about-config-pref-add-type-string = अक्षरमाळ

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (पूर्वनिर्धारीत)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (सानुकूल)
