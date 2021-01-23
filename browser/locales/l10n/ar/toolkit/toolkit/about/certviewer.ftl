# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = الشهادة

## Error messages

certificate-viewer-error-message = تعذّر العثور على معلومات الشهادة، أو أنّ الشهادة تالفة. أعِد المحاولة لاحقًا.
certificate-viewer-error-title = حدث خطب ما.

## Certificate information labels

certificate-viewer-algorithm = الخوارزمية
certificate-viewer-certificate-authority = سلطة شهادات
certificate-viewer-common-name = الاسم الشائع
certificate-viewer-email-address = عنوان البريد الإلكتروني
certificate-viewer-country = البلد
certificate-viewer-dns-name = اسم DNS
certificate-viewer-name = الاسم
certificate-viewer-not-after = ليس بعد
certificate-viewer-not-before = ليس قبل
certificate-viewer-organization = المنظّمة
certificate-viewer-organizational-unit = الوحدة التنظيمية
certificate-viewer-state-province = الولاية/المحافظة
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = الرقم التسلسلي
certificate-viewer-value = القيمة
certificate-viewer-version = الإصدارة
certificate-viewer-issuer-name = اسم المُصدِر
certificate-viewer-validity = الصلاحية
certificate-viewer-miscellaneous = متنوّع
certificate-viewer-fingerprints = البصمات

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = نزّل
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] نعم
       *[false] لا
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

## Labels for tabs displayed in stand-alone about:certificate page

