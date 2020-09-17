# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

## These strings appear on the warning you see when first visiting about:config.

about-config-intro-warning-title = נא להמשיך בזהירות
about-config-intro-warning-text = שינוי העדפות התצורה המתקדמות עשוי להשפיע על הביצועים או אבטחה של { -brand-short-name }.
about-config-intro-warning-checkbox = להזהיר אותי כשאני מנסה לגשת להעדפות האלו
about-config-intro-warning-button = קבלת הסיכון והמשך

##

# This is shown on the page before searching but after the warning is accepted.
about-config-caution-text = שינוי העדפות אלו עשוי להשפיע על הביצועים או אבטחה של { -brand-short-name }.

about-config-page-title = העדפות מתקדמות

about-config-search-input1 =
    .placeholder = חיפוש שם העדפה
about-config-show-all = הצגת הכל

about-config-pref-add-button =
    .title = הוספה
about-config-pref-toggle-button =
    .title = החלפה
about-config-pref-edit-button =
    .title = עריכה
about-config-pref-save-button =
    .title = שמירה
about-config-pref-reset-button =
    .title = איפוס
about-config-pref-delete-button =
    .title = מחיקה

## Labels for the type selection radio buttons shown when adding preferences.

about-config-pref-add-type-boolean = בוליאני
about-config-pref-add-type-number = מספר
about-config-pref-add-type-string = מחרוזת

## Preferences with a non-default value are differentiated visually, and at the
## same time the state is made accessible to screen readers using an aria-label
## that won't be visible or copied to the clipboard.
##
## Variables:
##   $value (String): The full value of the preference.

about-config-pref-accessible-value-default =
    .aria-label = { $value } (ברירת מחדל)
about-config-pref-accessible-value-custom =
    .aria-label = { $value } (מותאם אישית)
