# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Subframe crash notification

crashed-subframe-message = <strong>انهار جزء من هذه الصفحة.</strong> لإبلاغ { -brand-product-name } بهذه المشكلة وإصلاحها أسرع، رجاء أرسل بلاغا.

# The string for crashed-subframe-title.title should match crashed-subframe-message,
# but without any markup.
crashed-subframe-title =
    .title = انهار جزء من هذه الصفحة. لإبلاغ { -brand-product-name } بهذه المشكلة وإصلاحها أسرع، رجاء أرسل بلاغا.
crashed-subframe-learnmore-link =
    .value = اطّلع على المزيد
crashed-subframe-submit =
    .label = أرسِل تقريرًا
    .accesskey = س

## Pending crash reports

# Variables:
#   $reportCount (Number): the number of pending crash reports
pending-crash-reports-message =
    { $reportCount ->
        [zero] لا بلاغات انهيار غير مرسلة
        [one] لديك بلاغ انهيار غير مرسل
        [two] لديك بلاغي انهيار غير مرسلين
        [few] لديك { $reportCount } بلاغات انهيار غير مرسلة
        [many] لديك { $reportCount } بلاغ انهيار غير مرسل
       *[other] لديك { $reportCount } بلاغ انهيار غير مرسل
    }
pending-crash-reports-view-all =
    .label = اعرض
pending-crash-reports-send =
    .label = أرسل
pending-crash-reports-always-send =
    .label = أرسل دائمًا
