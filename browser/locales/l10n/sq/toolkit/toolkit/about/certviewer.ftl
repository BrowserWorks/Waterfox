# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Dëshmi

## Error messages

certificate-viewer-error-message = S’qemë në gjendje të gjejmë të dhënat e dëshmisë, ose dëshmia është dëmtuar. Ju lutemi, riprovoni.
certificate-viewer-error-title = Diçka shkoi ters.

## Certificate information labels

certificate-viewer-algorithm = Algoritëm
certificate-viewer-certificate-authority = Autoritet Dëshmish
certificate-viewer-cipher-suite = Suitë Shifrimi
certificate-viewer-common-name = Emër i Rëndomtë
certificate-viewer-email-address = Adresë Email
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Dëshmi për { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Vend Regjistrimi
certificate-viewer-country = Vend
certificate-viewer-curve = Lakore
certificate-viewer-distribution-point = Pikë Shpërndarjeje
certificate-viewer-dns-name = Emër DNS
certificate-viewer-ip-address = Adresë IP
certificate-viewer-other-name = Emër Tjetër
certificate-viewer-exponent = Eksponent
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Grup Shkëmbimi Kyçesh
certificate-viewer-key-id = ID Kyçi
certificate-viewer-key-size = Madhësi Kyçi
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Lokalitet i Inc.
certificate-viewer-locality = Lokalitet
certificate-viewer-location = Vendndodhje
certificate-viewer-logid = ID Regjistri
certificate-viewer-method = Metodë
certificate-viewer-modulus = Modul
certificate-viewer-name = Emër
certificate-viewer-not-after = Jo Pas
certificate-viewer-not-before = Jo Para
certificate-viewer-organization = Ent
certificate-viewer-organizational-unit = Njësi Organizative
certificate-viewer-policy = Rregull
certificate-viewer-protocol = Protokoll
certificate-viewer-public-value = Vlerë Publike
certificate-viewer-purposes = Qëllime
certificate-viewer-required = E domosdoshme
certificate-viewer-unsupported = &lt;e pambuluar&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Shtet/Provincë Regjistrimi
certificate-viewer-state-province = Shtet/Provincë
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Numër Serial
certificate-viewer-signature-algorithm = Algoritëm Nënshkrimi
certificate-viewer-signature-scheme = Skemë Nënshkrimi
certificate-viewer-timestamp = Vulë kohore
certificate-viewer-value = Vlerë
certificate-viewer-version = Version
certificate-viewer-business-category = Kategori Biznesi
certificate-viewer-subject-name = Emër Subjekti
certificate-viewer-issuer-name = Emër Lëshuesi
certificate-viewer-validity = Vlefshmëri
certificate-viewer-subject-alt-names = Emra Alternativë Subjekti
certificate-viewer-public-key-info = Të dhëna Kyçi Publik
certificate-viewer-miscellaneous = Të ndryshme
certificate-viewer-fingerprints = Shenja gishtash
certificate-viewer-basic-constraints = Kufizime Elementare
certificate-viewer-key-usages = Përdorime Kyçi
certificate-viewer-extended-key-usages = Përdorime të Zgjeruara Kyçi
certificate-viewer-subject-key-id = ID Kyçi Subjekti
certificate-viewer-authority-key-id = ID Kyçi Autoriteti
certificate-viewer-authority-info-aia = Të dhëna Autoriteti (AIA)
certificate-viewer-certificate-policies = Rregulla Dëshmish
certificate-viewer-embedded-scts = SCT-ra të Trupëzuara
certificate-viewer-crl-endpoints = Pikëmbarime CRL

# This message is used as a row header in the Miscellaneous section. 
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Shkarkoje
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Po
       *[false] Jo
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (dëshmi)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (zinxhir)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Këtij zgjerimi i është vënë shenjë si kritik, që do të thotë se klientët duhet ta hedhin tej dëshminë, nëse nuk e kuptojnë.
certificate-viewer-export = Eksporto
    .download = { $fileName }.pem

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Dëshmitë Tuaja
certificate-viewer-tab-people = Persona
certificate-viewer-tab-servers = Shërbyes
certificate-viewer-tab-ca = Autoritete
certificate-viewer-tab-unkonwn = E panjohur
