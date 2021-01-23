# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = ਸਰਟੀਫਿਕੇਟ

## Error messages

certificate-viewer-error-message = ਅਸੀਂ ਸਰਟੀਫਿਕੇਟ ਜਾਣਕਾਰੀ ਲੱਭਣ ਲਈ ਅਸਮਰੱਥ ਸਾਂ ਜਾਂ ਸਰਟੀਫਿਕੇਟ ਨਿਕਾਰਾ ਹੈ। ਮੁੜ ਕੋਸ਼ਿਸ਼ ਕਰੋ।
certificate-viewer-error-title = ਕੁਝ ਗਲਤ ਵਾਪਰਿਆ।

## Certificate information labels

certificate-viewer-algorithm = ਐਲਗੋਰਿਥਮ
certificate-viewer-certificate-authority = ਸਰਟੀਫਿਕੇਟ ਅਥਾਰਟੀ
certificate-viewer-cipher-suite = ਸੀਫ਼ਰ ਸੂਟ
certificate-viewer-common-name = ਆਮ ਨਾਂ
certificate-viewer-email-address = ਈਮੇਲ ਸਿਰਨਾਵਾਂ
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = ਇੰਕਾ. ਦੇਸ਼
certificate-viewer-country = ਦੇਸ਼
certificate-viewer-curve = ਕਰਵ
certificate-viewer-distribution-point = ਵੰਡ ਸਥਾਨ
certificate-viewer-dns-name = DNS ਨਾਂ
certificate-viewer-ip-address = IP ਸਿਰਨਾਵਾਂ
certificate-viewer-other-name = ਹੋਰ ਨਾਂ
certificate-viewer-id = ਪਛਾਣ
certificate-viewer-key-exchange-group = ਕੁੰਜੀ ਤਬਾਦਲਾ ਗਰੁੱਪ
certificate-viewer-key-id = ਕੁੰਜੀ ਪਛਾਣ
certificate-viewer-key-size = ਕੁੰਜੀ ਆਕਾਰ
certificate-viewer-locality = ਟਿਕਾਣਾ
certificate-viewer-location = ਟਿਕਾਣਾ
certificate-viewer-logid = ਲਾਗ ਪਛਾਣ
certificate-viewer-method = ਢੰਗ
certificate-viewer-modulus = ਮੋਡੀਊਲ
certificate-viewer-name = ਨਾਂ
certificate-viewer-not-after = ਇਸ ਦੇ ਬਾਅਦ ਨਹੀਂ
certificate-viewer-not-before = ਇਸ ਤੋਂ ਪਹਿਲਾਂ ਨਹੀਂ
certificate-viewer-organization = ਸੰਗਠਨ
certificate-viewer-organizational-unit = ਸੰਗਠਨ ਇਕਾਈ
certificate-viewer-policy = ਨੀਤੀ
certificate-viewer-protocol = ਪਰੋਟੋਕਾਲ
certificate-viewer-public-value = ਪਬਲਿਕ ਮੁੱਲ
certificate-viewer-purposes = ਮਕਸਦ
certificate-viewer-required = ਚਾਹੀਦਾ
certificate-viewer-unsupported = &lt;ਗ਼ੈਰ-ਸਹਾਇਕ&gt;
certificate-viewer-state-province = ਰਾਜ/ਪ੍ਰਾਂਤ
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = ਲੜੀ ਨੰਬਰ
certificate-viewer-signature-algorithm = ਦਸਤਖਤੀ ਐਲਗੋਰਿਥਮ
certificate-viewer-signature-scheme = ਦਸਤਖਤੀ ਸਕੀਮ
certificate-viewer-timestamp = ਸਮਾਂ-ਮੋਹਰ
certificate-viewer-value = ਮੁੱਲ
certificate-viewer-version = ਵਰਜ਼ਨ
certificate-viewer-business-category = ਕਾਰੋਬਾਰੀ ਵਰਗ
certificate-viewer-subject-name = ਵਿਸ਼ਾ ਨਾਂ
certificate-viewer-issuer-name = ਜਾਰੀਕਰਤਾ ਨਾਂ
certificate-viewer-validity = ਵੈਧਤਾ
certificate-viewer-subject-alt-names = ਵਿਸ਼ੇ ਦਾ ਬਦਲਵਾਂ ਨਾਂ
certificate-viewer-public-key-info = ਪਬਲਿਕ ਕੁੰਜੀ ਜਾਣਕਾਰੀ
certificate-viewer-miscellaneous = ਫੁਟਕਲ
certificate-viewer-fingerprints = ਫਿੰਗਰਪਰਿੰਟ
certificate-viewer-basic-constraints = ਮੁੱਢਲੀਆਂ ਸ਼ਰਤਾਂ
certificate-viewer-key-usages = ਕੁੰਜੀ ਵਰਤੋ
certificate-viewer-extended-key-usages = ਐਕਸਟੈਂਡਡ ਕੁੰਜੀ ਵਰਤੋਂ
certificate-viewer-authority-info-aia = ਅਥਾਰਟੀ ਜਾਣਕਾਰੀ (AIA)
certificate-viewer-certificate-policies = ਸਰਟੀਫਿਕੇਟ ਨੀਤੀਆਂ

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = ਡਾਊਨਲੋਡ ਕਰੋ
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] ਹਾਂ
       *[false] ਨਹੀਂ
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (ਸਰਟੀਫਿਕੇਟ)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (ਚੇਨ)
    .download = { $fileName }-chain.pem

## Labels for tabs displayed in stand-alone about:certificate page

