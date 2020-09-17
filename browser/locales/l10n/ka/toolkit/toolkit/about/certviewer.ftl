# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = სერტიფიკატი

## Error messages

certificate-viewer-error-message = სერტიფიკატის მონაცემები ვერ მოიძებნა, ან სერტიფიკატი დაზიანებულია. გთხოვთ, კვლავ სცადოთ.
certificate-viewer-error-title = რაღაც ხარვეზი წარმოიქმნა.

## Certificate information labels

certificate-viewer-algorithm = ალგორითმი
certificate-viewer-certificate-authority = სერტიფიკატის გამცემი
certificate-viewer-cipher-suite = შიფრის ნაკრები
certificate-viewer-common-name = საერთო სახელი
certificate-viewer-email-address = ელფოსტის მისამართი
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = სერტიფიკატი { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = წარმ. ქვეყანა
certificate-viewer-country = ქვეყანა
certificate-viewer-curve = მრუდი
certificate-viewer-distribution-point = განაწილების წერტილი
certificate-viewer-dns-name = DNS-სახელი
certificate-viewer-ip-address = IP-მისამართი
certificate-viewer-other-name = Სხვა სახელი
certificate-viewer-exponent = ხარისხის მაჩვენებელი
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = გასაღებთა მიმოცვლის ჯგუფი
certificate-viewer-key-id = გასაღების ID
certificate-viewer-key-size = გასაღების ზომა
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = რეგისტრ. ადგილი
certificate-viewer-locality = ადგილსამყოფელი
certificate-viewer-location = მდებარეობა
certificate-viewer-logid = აღრიცხვის ID
certificate-viewer-method = მეთოდი
certificate-viewer-modulus = მოდული
certificate-viewer-name = სახელი
certificate-viewer-not-after = არა უგვიანეს
certificate-viewer-not-before = არა უადრეს
certificate-viewer-organization = დაწესებულება
certificate-viewer-organizational-unit = დაწესებულების განყოფილება
certificate-viewer-policy = დებულება
certificate-viewer-protocol = ოქმი
certificate-viewer-public-value = ღია მნიშვნელობა
certificate-viewer-purposes = მიზნობრიობა
certificate-viewer-qualifier = განმსაზღვრელი
certificate-viewer-qualifiers = განმსაზღვრელები
certificate-viewer-required = აუცილებელი
certificate-viewer-unsupported = &lt;მხარდაუჭერელი&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = წარმ. მხარე/რეგიონი
certificate-viewer-state-province = მხარე/რეგიონი
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = სერიული ნომერი
certificate-viewer-signature-algorithm = ხელმოწერის ალგორითმი
certificate-viewer-signature-scheme = ხელმოწერის სქემა
certificate-viewer-timestamp = დროის ნიშნული
certificate-viewer-value = მნიშვნელობა
certificate-viewer-version = ვერსია
certificate-viewer-business-category = ბიზნესის კატეგორია
certificate-viewer-subject-name = სუბიექტის დასახელება
certificate-viewer-issuer-name = გამომცემის დასახელება
certificate-viewer-validity = ძალამოსილობა
certificate-viewer-subject-alt-names = სუბიექტის სხვა სახელები
certificate-viewer-public-key-info = საჯარო გასაღების მონაცემები
certificate-viewer-miscellaneous = სხვადასხვა
certificate-viewer-fingerprints = ანაბეჭდები
certificate-viewer-basic-constraints = ძირითადი შეზღუდვები
certificate-viewer-key-usages = გასაღების გამოყენება
certificate-viewer-extended-key-usages = გაფართოებული გასაღების გამოყენება
certificate-viewer-ocsp-stapling = OCSP-მიმაგრება
certificate-viewer-subject-key-id = სუბიექტის გასაღების ID
certificate-viewer-authority-key-id = უფლებამოსილი მხარის გასაღების ID
certificate-viewer-authority-info-aia = უფლებამოსილი მხარის მონაცემები (AIA)
certificate-viewer-certificate-policies = სერტიფიკატის პირობები
certificate-viewer-embedded-scts = ჩაშენებული SCT- ები
certificate-viewer-crl-endpoints = CRL-ს მომწოდებლები
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = ჩამოტვირთვა
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] დიახ
       *[false] არა
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (სერტიფიკატი)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (ჯაჭვი)
    .download = { $fileName }-chain.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = ეს გაფართოება მიჩნეულია გადამწვეტად, რაც ნიშნავს, რომ კლიენტებმა უნდა უარყონ სერტიფიკატი, თუ მათთვის გაუგებარია.
certificate-viewer-export = ცალკე შენახვა
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = თქვენი სერტიფიკატები
certificate-viewer-tab-people = ხალხი
certificate-viewer-tab-servers = სერვერები
certificate-viewer-tab-ca = გამომცემები
certificate-viewer-tab-unkonwn = უცნობი
