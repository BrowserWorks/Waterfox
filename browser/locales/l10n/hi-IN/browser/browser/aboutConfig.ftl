# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = सावधानी के साथ आगे बढ़ें
about-config-intro-warning-text = उन्नत कॉन्फ़िगरेशन वरीयताओं को बदलना { -brand-short-name } की प्रदर्शन या सुरक्षा को प्रभावित कर सकता है।
about-config-intro-warning-checkbox = जब मैं इन सुविधाओं का उपयोग करने का प्रयास करूं तो मुझे चेतावनी दें
about-config-intro-warning-button = जोखिम को स्वीकार करें और जारी रखें

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = इन प्राथमिकताओं को बदलने से { -brand-short-name } का प्रदर्शन या सुरक्षा प्रभावित हो सकती है।

about-config-page-title = उन्नत प्राथमिकताएँ

about-config-search-input1 =
    .placeholder = वरीयता नाम खोजें
about-config-show-all = सभी दिखाएँ

about-config-pref-add-button =
    .title = जोड़ें
about-config-pref-toggle-button =
    .title = टॉगल
about-config-pref-edit-button =
    .title = संपादन
about-config-pref-save-button =
    .title = सहेजें
about-config-pref-reset-button =
    .title = रीसेट
about-config-pref-delete-button =
    .title = मिटाएँ

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
    .aria-label = { $value } (तयशुदा)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (custom)
