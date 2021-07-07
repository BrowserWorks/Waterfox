# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = 証明書

## Error messages

certificate-viewer-error-message = 証明書情報が見つからないか、証明書が破損しています。もう一度試してください。
certificate-viewer-error-title = 何か問題が発生しました。

## Certificate information labels
## (^^; 未訳

certificate-viewer-algorithm = Algorithm
certificate-viewer-certificate-authority = Certificate Authority
certificate-viewer-cipher-suite = Cipher Suite
certificate-viewer-common-name = Common Name
certificate-viewer-email-address = Email Address
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificate for { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Inc. Country
certificate-viewer-country = Country
certificate-viewer-curve = Curve
certificate-viewer-distribution-point = Distribution Point
certificate-viewer-dns-name = DNS Name
certificate-viewer-ip-address = IP Address
certificate-viewer-other-name = Other Name
certificate-viewer-exponent = Exponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Key Exchange Group
certificate-viewer-key-id = Key ID
certificate-viewer-key-size = Key Size
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Inc. Locality
certificate-viewer-locality = Locality
certificate-viewer-location = Location
certificate-viewer-logid = Log ID
certificate-viewer-method = Method
certificate-viewer-modulus = Modulus
certificate-viewer-name = Name
certificate-viewer-not-after = Not After
certificate-viewer-not-before = Not Before
certificate-viewer-organization = Organization
certificate-viewer-organizational-unit = Organizational Unit
certificate-viewer-policy = Policy
certificate-viewer-protocol = Protocol
certificate-viewer-public-value = Public Value
certificate-viewer-purposes = Purposes
certificate-viewer-qualifier = Qualifier
certificate-viewer-qualifiers = Qualifiers
certificate-viewer-required = Required
certificate-viewer-unsupported = &lt;unsupported&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Inc. State/Province
certificate-viewer-state-province = State/Province
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Serial Number
certificate-viewer-signature-algorithm = Signature Algorithm
certificate-viewer-signature-scheme = Signature Scheme
certificate-viewer-timestamp = Timestamp
certificate-viewer-value = Value
certificate-viewer-version = Version
certificate-viewer-business-category = Business Category
certificate-viewer-subject-name = Subject Name
certificate-viewer-issuer-name = Issuer Name
certificate-viewer-validity = Validity
certificate-viewer-subject-alt-names = Subject Alt Names
certificate-viewer-public-key-info = Public Key Info
certificate-viewer-miscellaneous = Miscellaneous
certificate-viewer-fingerprints = Fingerprints
certificate-viewer-basic-constraints = Basic Constraints
certificate-viewer-key-usages = Key Usages
certificate-viewer-extended-key-usages = Extended Key Usages
certificate-viewer-ocsp-stapling = OCSP Stapling
certificate-viewer-subject-key-id = Subject Key ID
certificate-viewer-authority-key-id = Authority Key ID
certificate-viewer-authority-info-aia = Authority Info (AIA)
certificate-viewer-certificate-policies = Certificate Policies
certificate-viewer-embedded-scts = Embedded SCTs
certificate-viewer-crl-endpoints = CRL Endpoints

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = ダウンロード
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean = { $boolean ->
  [true] Yes
 *[false] No
}

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (証明書)
  .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (チェーン)
  .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
  .title = この拡張には危険マークが付けられており、クライアントがこれを理解できない場合は証明書を却下すべきであることを意味します。
certificate-viewer-export = エクスポート
  .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (不明)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = 独自の証明書
certificate-viewer-tab-people = 人々
certificate-viewer-tab-servers = サーバー
certificate-viewer-tab-ca = 認証局
certificate-viewer-tab-unkonwn = 不明
