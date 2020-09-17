# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Strings used for device manager

devmgr =
    .title = מנהל התקנים
    .style = width: 67em; height: 32em;

devmgr-devlist =
    .label = מודולי והתקני אבטחה

devmgr-header-details =
    .label = פרטים

devmgr-header-value =
    .label = ערך

devmgr-button-login =
    .label = התחברות
    .accesskey = ח

devmgr-button-logout =
    .label = התנתקות
    .accesskey = נ

devmgr-button-changepw =
    .label = שינוי ססמה
    .accesskey = ס

devmgr-button-load =
    .label = טעינה
    .accesskey = ט

devmgr-button-unload =
    .label = פריקה
    .accesskey = פ

devmgr-button-enable-fips =
    .label = הפעלת FIPS
    .accesskey = F

devmgr-button-disable-fips =
    .label = השבתת FIPS
    .accesskey = F

## Strings used for load device

load-device =
    .title = טעינת מנהל התקן PKCS#11

load-device-info = נא להכניס את המידע עבור המודול שברצונך להוסיף.

load-device-modname =
    .value = שם המודול
    .accesskey = ש

load-device-modname-default =
    .value = מודול PKCS#11 חדש

load-device-filename =
    .value = שם קובץ המודול
    .accesskey = ק

load-device-browse =
    .label = עיון…
    .accesskey = ע

## Token Manager

devinfo-status =
    .label = מצב

devinfo-status-disabled =
    .label = לא מאופשר

devinfo-status-not-present =
    .label = לא קיים

devinfo-status-uninitialized =
    .label = לא מאותחל

devinfo-status-not-logged-in =
    .label = לא מחובר

devinfo-status-logged-in =
    .label = מחובר

devinfo-status-ready =
    .label = מוכן

devinfo-desc =
    .label = תיאור

devinfo-man-id =
    .label = יצרן

devinfo-hwversion =
    .label = גרסת HW
devinfo-fwversion =
    .label = גרסת FW

devinfo-modname =
    .label = מודול

devinfo-modpath =
    .label = נתיב

login-failed = התחברות נכשלה

devinfo-label =
    .label = תווית

devinfo-serialnum =
    .label = מספר סידורי

fips-nonempty-password-required = מצב FIPS דורש שתהיה לך ססמה ראשית עבור כל התקן אבטחה. נא להגדיר ססמה לפני ניסיון הפעלת מצב FIPS.

fips-nonempty-primary-password-required = מצב FIPS דורש שתהיה לך ססמה ראשית עבור כל התקן אבטחה. נא להגדיר ססמה לפני ניסיון הפעלת מצב FIPS.
unable-to-toggle-fips = לא ניתן לשנות את מצב ה־FIPS עבור התקן האבטחה. מומלץ לצאת ולהפעיל יישום זה מחדש.
load-pk11-module-file-picker-title = נא לבחור במנהל התקן PKCS#11 לטעינה

# Load Module Dialog
load-module-help-empty-module-name =
    .value = שם המודול לא יכול להיות ריק.

# Do not translate 'Root Certs'
load-module-help-root-certs-module-name =
    .value = ‘Root Certs‘ הוא שם שמור ואין אפשרות להשתמש בו בתור שם המודול.

add-module-failure = לא ניתן להוסיף מודול
del-module-warning = האם ברצונך למחוק מודול אבטחה זה?
del-module-error = לא ניתן למחוק מודול
