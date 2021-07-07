# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Zertifikat

## Error messages

certificate-viewer-error-message = Die Zertifikatsinformationen wurden nicht gefunden oder das Zertifikat ist beschädigt. Bitte versuchen Sie es erneut.
certificate-viewer-error-title = Es trat ein Problem auf.

## Certificate information labels

certificate-viewer-algorithm = Algorithmus
certificate-viewer-certificate-authority = Zertifizierungsstelle
certificate-viewer-cipher-suite = Cipher-Suite
certificate-viewer-common-name = Allgemeiner Name
certificate-viewer-email-address = E-Mail-Adresse
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Zertifikat für { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Unternehmenssitz: Land
certificate-viewer-country = Land
certificate-viewer-curve = Kurve
certificate-viewer-distribution-point = Verteilungsstelle
certificate-viewer-dns-name = DNS-Name
certificate-viewer-ip-address = IP-Adresse
certificate-viewer-other-name = Anderer Name
certificate-viewer-exponent = Exponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Schlüsselaustausch-Gruppe (Key Exchange Group)
certificate-viewer-key-id = Schlüssel-ID
certificate-viewer-key-size = Schlüssellänge
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Unternehmenssitz: Ort
certificate-viewer-locality = Ort
certificate-viewer-location = Ort
certificate-viewer-logid = Log ID
certificate-viewer-method = Methode
certificate-viewer-modulus = Modulus
certificate-viewer-name = Name
certificate-viewer-not-after = Ende
certificate-viewer-not-before = Beginn
certificate-viewer-organization = Organisation
certificate-viewer-organizational-unit = Organisationseinheit
certificate-viewer-policy = Regel
certificate-viewer-protocol = Protokoll
certificate-viewer-public-value = Öffentlicher Verifikationsschlüssel (Public Value)
certificate-viewer-purposes = Verwendungen
certificate-viewer-qualifier = Qualifizierer
certificate-viewer-qualifiers = Qualifizierer
certificate-viewer-required = Benötigt
certificate-viewer-unsupported = &lt;nicht unterstützt&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Unternehmenssitz: Bundesland/Provinz
certificate-viewer-state-province = Bundesland/Provinz
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Seriennummer
certificate-viewer-signature-algorithm = Signaturalgorithmus
certificate-viewer-signature-scheme = Signaturschema
certificate-viewer-timestamp = Zeitstempel
certificate-viewer-value = Wert
certificate-viewer-version = Version
certificate-viewer-business-category = Organisationsart
certificate-viewer-subject-name = Inhabername
certificate-viewer-issuer-name = Ausstellername
certificate-viewer-validity = Gültigkeit
certificate-viewer-subject-alt-names = Alternative Inhaberbezeichnungen
certificate-viewer-public-key-info = Öffentlicher Schlüssel - Informationen
certificate-viewer-miscellaneous = Verschiedenes
certificate-viewer-fingerprints = Fingerabdrücke
certificate-viewer-basic-constraints = Basiseinschränkungen
certificate-viewer-key-usages = Schlüsselverwendung
certificate-viewer-extended-key-usages = Erweitere Schlüsselverwendung
certificate-viewer-ocsp-stapling = TLS-Zertifizierungsabfrage-Erweiterung (OCSP Stapling)
certificate-viewer-subject-key-id = ID für verwendeten Schlüssel des Zertifikatinhabers (Subject Key ID)
certificate-viewer-authority-key-id = ID für verwendeten Schlüssel der Zertifizierungsstelle (Authority Key ID)
certificate-viewer-authority-info-aia = Zertifizierungsstelleninformationen - Authority Info (AIA)
certificate-viewer-certificate-policies = Zertifikatsregeln
certificate-viewer-embedded-scts = Enthaltene signierte Zertifikatzeitstempel (SCT)
certificate-viewer-crl-endpoints = Endpunkte für CRL (Zertifikatsperrliste)
# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Speichern
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Ja
       *[false] Nein
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (Zertifikat)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (Zertifikatskette)
    .download = { $fileName }-zertifikatskette.pem
# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Diese Erweiterung ist als kritisch gekennzeichnet, weshalb Geräte das Zertifikat zurückweisen müssen, wenn sie die Erweiterung nicht unterstützen.
certificate-viewer-export = Exportieren
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (unbekannt)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Ihre Zertifikate
certificate-viewer-tab-people = Personen
certificate-viewer-tab-servers = Server
certificate-viewer-tab-ca = Zertifizierungsstellen
certificate-viewer-tab-unkonwn = Unbekannt
