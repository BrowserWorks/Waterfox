# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = প্রশংসাপত্র

## Error messages

certificate-viewer-error-title = কিছু একটা সমস্যা হয়েছে

## Certificate information labels

certificate-viewer-algorithm = অ্যালগরিদম
certificate-viewer-certificate-authority = সার্টিফিকেট কর্তৃপক্ষ
certificate-viewer-cipher-suite = সাইফার স্যুট
certificate-viewer-common-name = সাধারণ নাম
certificate-viewer-email-address = ইমেইল ঠিকানা
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = দেশ সহ
certificate-viewer-country = দেশ
certificate-viewer-curve = বাঁক
certificate-viewer-distribution-point = বিতরণ পয়েন্ট
certificate-viewer-dns-name = DNS নাম
certificate-viewer-id = আইডি
certificate-viewer-key-exchange-group = কী এক্সচেঞ্জ গ্রুপ
certificate-viewer-key-size = কী আকার
certificate-viewer-locality = বসতি
certificate-viewer-location = অবস্থান
certificate-viewer-method = পদ্ধতি
certificate-viewer-modulus = মডিউলস
certificate-viewer-name = নাম
certificate-viewer-not-after = পরে নয়
certificate-viewer-not-before = আগে নয়
certificate-viewer-organization = প্রতিষ্ঠান
certificate-viewer-organizational-unit = সাংগঠনিক ইউনিট
certificate-viewer-policy = নীতি
certificate-viewer-protocol = প্রোটোকল
certificate-viewer-public-value = জনসাধারণের মান
certificate-viewer-purposes = উদ্দেশ্যসমূহ
certificate-viewer-qualifier = যোগ্যতা
certificate-viewer-required = প্রয়োজনীয়
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = রাজ্য / প্রদেশ যুক্ত করুন
certificate-viewer-state-province = রাজ্য/প্রদেশ
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = ক্রমিক সংখ্যা
certificate-viewer-signature-algorithm = স্বাক্ষর অ্যালগরিদম
certificate-viewer-signature-scheme = সিগনেচার স্কিম
certificate-viewer-timestamp = টাইমস্ট্যাম্প
certificate-viewer-value = মান
certificate-viewer-version = সংস্করণ
certificate-viewer-subject-name = বিষয়ের নাম
certificate-viewer-issuer-name = ইস্যুকারীর নাম
certificate-viewer-validity = বৈধতা
certificate-viewer-miscellaneous = বিবিধ
certificate-viewer-fingerprints = ফিঙ্গারপ্রিন্ট
certificate-viewer-basic-constraints = প্রাথমিক সীমাবদ্ধতা

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = ডাউনলোড
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] হ্যাঁ
       *[false] না
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

## Labels for tabs displayed in stand-alone about:certificate page

