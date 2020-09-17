# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = گواهی

## Error messages

certificate-viewer-error-message = ما نتوانستیم اطلاعات گواهی را پیدا کنیم، یا گواهی خراب است. لطفا دوباره تلاش کنید.
certificate-viewer-error-title = خطایی رخ داده است.

## Certificate information labels

certificate-viewer-algorithm = الگوریتم
certificate-viewer-certificate-authority = تأیید کنندهٔ گواهی
certificate-viewer-common-name = نام متداول
certificate-viewer-country = کشور
certificate-viewer-distribution-point = نقطه توزیع
certificate-viewer-dns-name = نام DNS
certificate-viewer-id = شناسه
certificate-viewer-method = روش
certificate-viewer-name = نام
certificate-viewer-protocol = پروتکل
certificate-viewer-purposes = اهداف
certificate-viewer-required = ضروری
certificate-viewer-serial-number = شماره سریال
certificate-viewer-signature-algorithm = الگوریتم امضا
certificate-viewer-value = مقدار
certificate-viewer-version = نسخه
certificate-viewer-validity = اعتبار
certificate-viewer-miscellaneous = گوناگون

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = بارگیری
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] بله
       *[false] خیر
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

## Labels for tabs displayed in stand-alone about:certificate page

