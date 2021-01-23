# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = प्रमाणपत्र

## Error messages


## Certificate information labels

certificate-viewer-algorithm = एल्गोरिथ्म
certificate-viewer-certificate-authority = प्रमाणपत्र प्राधिकार
certificate-viewer-email-address = ईमेल पता
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = { $firstCertName } के लिए प्रमाणपत्र
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = सम्मिलित देश
certificate-viewer-country = देश
certificate-viewer-dns-name = DNS नाम
certificate-viewer-ip-address = IP पता
certificate-viewer-other-name = अन्य नाम
certificate-viewer-id = आईडी
certificate-viewer-location = स्थान
certificate-viewer-logid = लॉग आईडी
certificate-viewer-method = तरीका
certificate-viewer-name = नाम
certificate-viewer-not-after = इसके बाद नहीं
certificate-viewer-not-before = इसके पहले नहीं
certificate-viewer-policy = नीति
certificate-viewer-protocol = प्रोटोकॉल
certificate-viewer-purposes = उद्देश्य
certificate-viewer-required = आवश्यक
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = सम्मिलित राज्य/देश
certificate-viewer-state-province = राज्य/देश
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = सीरीयल नंबर
certificate-viewer-version = संस्करण
certificate-viewer-issuer-name = जारीकर्ता का नाम
certificate-viewer-validity = वैधता
certificate-viewer-authority-info-aia = प्राधिकरण जानकारी (AIA)
certificate-viewer-certificate-policies = प्रमाणपत्र नीतियां

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = डाउनलोड
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] हां
       *[false] नहीं
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.


## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = आपका प्रमाणपत्र
certificate-viewer-tab-servers = सर्वर
