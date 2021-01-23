# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = ਧਿਆਨ ਨਾਲ ਅੱਗੇ ਵਧੋ
about-config-intro-warning-text = ਤਕਨੀਕੀ ਸੰਰਚਨਾ ਪਸੰਦਾਂ ਨੂੰ ਬਦਲਣਾ { -brand-short-name } ਕਾਰਗੁਜ਼ਾਰੀ ਜਾਂ ਸੁਰੱਖਿਆ ਨੂੰ ਪ੍ਰਭਾਵਤ ਕਰ ਸਕਦਾ ਹੈ।
about-config-intro-warning-checkbox = ਮੈਨੂੰ ਸੂਚਿਤ ਕਰੋ ਜਦੋਂ ਮੈਂ ਇਨ੍ਹਾਂ ਤਰਜੀਹਾਂ ਨੂੰ ਵੇਖਣ ਦੀ ਕੋਸ਼ਿਸ਼ ਕਰਾਂਗਾ
about-config-intro-warning-button = ਖ਼ਤਰੇ ਨੂੰ ਮੰਨੋ ਤੇ ਜਾਰੀ ਰੱਖੋ

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = ਇਨ੍ਹਾਂ ਤਰਜੀਹਾਂ ਨੂੰ ਬਦਲਣਾ { -brand-short-name } ਪ੍ਰਦਰਸ਼ਨ ਜਾਂ ਸੁਰੱਖਿਆ ਨੂੰ ਪ੍ਰਭਾਵਤ ਕਰ ਸਕਦਾ ਹੈ।

about-config-page-title = ਤਕਨੀਕੀ ਪਸੰਦਾਂ

about-config-search-input1 =
    .placeholder = ਪਸੰਦ ਨਾਂ ਖੋਜੋ
about-config-show-all = ਸਾਰੇ ਦਿਖਾਓ

about-config-pref-add-button =
    .title = ਜੋੜੋ
about-config-pref-toggle-button =
    .title = ਬਦਲੋ
about-config-pref-edit-button =
    .title = ਸੋਧੋ
about-config-pref-save-button =
    .title = ਸੰਭਾਲੋ
about-config-pref-reset-button =
    .title = ਮੁੜ-ਸੈੱਟ
about-config-pref-delete-button =
    .title = ਹਟਾਓ

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = ਬੂਲੀਅਨ
about-config-pref-add-type-number = ਨੰਬਰ
about-config-pref-add-type-string = ਸਤਰ

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (ਡਿਫਾਲਟ)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (ਕਸਟਮ)
