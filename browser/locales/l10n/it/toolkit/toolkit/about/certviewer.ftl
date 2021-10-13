# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificato

## Error messages

certificate-viewer-error-message = Non è stato possibile trovare informazioni sul certificato oppure il certificato è danneggiato. Riprovare.
certificate-viewer-error-title = Si è verificato un problema

## Certificate information labels

certificate-viewer-algorithm = Algoritmo
certificate-viewer-certificate-authority = Autorità di certificazione
certificate-viewer-cipher-suite = Suite di cifratura
certificate-viewer-common-name = Nome comune
certificate-viewer-email-address = Indirizzo email
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificato per { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Paese di costituzione
certificate-viewer-country = Paese
certificate-viewer-curve = Curva
certificate-viewer-distribution-point = Punto di distribuzione
certificate-viewer-dns-name = Nome DNS
certificate-viewer-ip-address = Indirizzo IP
certificate-viewer-other-name = Altro nome
certificate-viewer-exponent = Esponente
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Gruppo per scambio di chiavi
certificate-viewer-key-id = ID chiave
certificate-viewer-key-size = Dimensione chiave
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Località di costituzione
certificate-viewer-locality = Località
certificate-viewer-location = Indirizzo
certificate-viewer-logid = ID log
certificate-viewer-method = Metodo
certificate-viewer-modulus = Modulo
certificate-viewer-name = Nome
certificate-viewer-not-after = Non dopo
certificate-viewer-not-before = Non prima
certificate-viewer-organization = Organizzazione
certificate-viewer-organizational-unit = Unità organizzativa
certificate-viewer-policy = Criterio
certificate-viewer-protocol = Protocollo
certificate-viewer-public-value = Valore pubblico
certificate-viewer-purposes = Utilizzi
certificate-viewer-qualifier = Qualificatore
certificate-viewer-qualifiers = Qualificatori
certificate-viewer-required = Obbligatorio
certificate-viewer-unsupported = (non supportato)
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = Stato/provincia di costituzione
certificate-viewer-state-province = Stato/provincia
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Numero di serie
certificate-viewer-signature-algorithm = Algoritmo di firma
certificate-viewer-signature-scheme = Schema di firma
certificate-viewer-timestamp = Data e ora
certificate-viewer-value = Valore
certificate-viewer-version = Versione
certificate-viewer-business-category = Categoria di business
certificate-viewer-subject-name = Nome soggetto
certificate-viewer-issuer-name = Nome autorità emittente
certificate-viewer-validity = Validità
certificate-viewer-subject-alt-names = Nomi alternativi soggetto
certificate-viewer-public-key-info = Informazioni chiave pubblica
certificate-viewer-miscellaneous = Varie
certificate-viewer-fingerprints = Impronte digitali
certificate-viewer-basic-constraints = Limitazioni di base
certificate-viewer-key-usages = Ambiti di utilizzo della chiave
certificate-viewer-extended-key-usages = Utilizzo chiave esteso
certificate-viewer-ocsp-stapling = Stapling OCSP
certificate-viewer-subject-key-id = ID chiave soggetto
certificate-viewer-authority-key-id = ID chiave autorità
certificate-viewer-authority-info-aia = Info autorità (AIA)
certificate-viewer-certificate-policies = Criteri certificato
certificate-viewer-embedded-scts = SCT inclusi
certificate-viewer-crl-endpoints = Endpoint CRL

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Download
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean = { $boolean ->
  [true] Sì
 *[false] No
}

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (certificato)
  .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (catena)
  .download = { $fileName }-catena.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
  .title = Questa estensione è stata contrassegnata come critica. Questo significa che un client deve rifiutare il certificato se non è in grado di interpretarla.

certificate-viewer-export = Esporta
  .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (sconosciuto)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Certificati personali
certificate-viewer-tab-people = Persone
certificate-viewer-tab-servers = Server
certificate-viewer-tab-ca = Autorità
certificate-viewer-tab-unkonwn = Sconosciuti
