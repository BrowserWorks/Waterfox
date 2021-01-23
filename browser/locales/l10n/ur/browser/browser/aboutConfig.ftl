# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = احتیاط سے آگے بڑھیں
about-config-intro-warning-text = اعلیٰ سیٹنگز اور ترجیحات کو تبدیل کرنے سے { -brand-short-name } کی کارکردگی یا سلامتی متاثر ہوسکتی ہے۔
about-config-intro-warning-checkbox = مجھے انتباہ کریں جب میں ان ترجیحات تک رسائی حاصل کرنے کی کوشش کروں
about-config-intro-warning-button = خطرے کو قبول کریں اور جاری رکھیں

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = ان ترجیحات کو تبدیل کرنے سے { -brand-short-name } کی کارکردگی یا سلامتی متاثر ہوسکتی ہے۔

about-config-page-title = اعلی درجے کی ترجیحات

about-config-search-input1 =
    .placeholder = ترجیحات  کا نام تلاش کریں
about-config-show-all = تمام دکھائیں

about-config-pref-add-button =
    .title = شامل کریں
about-config-pref-toggle-button =
    .title = ٹوگل
about-config-pref-edit-button =
    .title = تدوین
about-config-pref-save-button =
    .title = محفوظ کریں
about-config-pref-reset-button =
    .title = ری سیٹ کریں
about-config-pref-delete-button =
    .title = حذف کریں

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = بولین
about-config-pref-add-type-number = نمبر
about-config-pref-add-type-string = سٹرنگ

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value }   (طے شدہ)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (مخصوص)
