# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certificate-viewer-certificate-section-title = Certificat

## Error messages

certificate-viewer-error-message = Nous n’avons pas pu trouver les informations sur le certificat ou le certificat est corrompu. Veuillez réessayer.
certificate-viewer-error-title = Quelque chose s’est mal passé.

## Certificate information labels

certificate-viewer-algorithm = Algorithme
certificate-viewer-certificate-authority = Autorité de certification
certificate-viewer-cipher-suite = Suite de chiffrement
certificate-viewer-common-name = Nom courant
certificate-viewer-email-address = Adresse électronique
# Variables:
#   $firstCertName (String) - Common Name for the displayed certificate
certificate-viewer-tab-title = Certificat pour { $firstCertName }
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-country = Pays d’enregistrement
certificate-viewer-country = Pays
certificate-viewer-curve = Courbe
certificate-viewer-distribution-point = Point de distribution
certificate-viewer-dns-name = Nom DNS
certificate-viewer-ip-address = Adresse IP
certificate-viewer-other-name = Autre nom
certificate-viewer-exponent = Exposant
certificate-viewer-id = ID
certificate-viewer-key-exchange-group = Groupe d’échange de clés
certificate-viewer-key-id = ID de clé
certificate-viewer-key-size = Taille de la clé
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-locality = Siège social
certificate-viewer-locality = Localité
certificate-viewer-location = Emplacement
certificate-viewer-logid = ID de journal
certificate-viewer-method = Méthode
certificate-viewer-modulus = Module
certificate-viewer-name = Nom
certificate-viewer-not-after = Pas après
certificate-viewer-not-before = Pas avant
certificate-viewer-organization = Organisation
certificate-viewer-organizational-unit = Unité organisationnelle
certificate-viewer-policy = Politique
certificate-viewer-protocol = Protocole
certificate-viewer-public-value = Valeur publique
certificate-viewer-purposes = Usages
certificate-viewer-qualifier = Qualificatif
certificate-viewer-qualifiers = Qualificatifs
certificate-viewer-required = Requis
certificate-viewer-unsupported = &lt;non pris en charge&gt;
# Inc. means Incorporated, e.g GitHub is incorporated in Delaware
certificate-viewer-inc-state-province = État / Province d’enregistrement
certificate-viewer-state-province = État / Province
certificate-viewer-sha-1 = SHA-1
certificate-viewer-sha-256 = SHA-256
certificate-viewer-serial-number = Numéro de série
certificate-viewer-signature-algorithm = Algorithme de signature
certificate-viewer-signature-scheme = Schéma de signature
certificate-viewer-timestamp = Horodatage
certificate-viewer-value = Valeur
certificate-viewer-version = Version
certificate-viewer-business-category = Catégorie d’affaires
certificate-viewer-subject-name = Nom du sujet
certificate-viewer-issuer-name = Nom de l’émetteur
certificate-viewer-validity = Validité
certificate-viewer-subject-alt-names = Noms alternatifs du sujet
certificate-viewer-public-key-info = Informations sur la clé publique
certificate-viewer-miscellaneous = Divers
certificate-viewer-fingerprints = Empreintes numériques
certificate-viewer-basic-constraints = Contraintes de base
certificate-viewer-key-usages = Utilisations de la clé
certificate-viewer-extended-key-usages = Utilisations étendues de la clé
certificate-viewer-ocsp-stapling = Agrafage OCSP
certificate-viewer-subject-key-id = Identifiant de clé du sujet
certificate-viewer-authority-key-id = Identifiant de clé de l’autorité
certificate-viewer-authority-info-aia = Informations sur l’autorité (AIA)
certificate-viewer-certificate-policies = Politiques du certificat
certificate-viewer-embedded-scts = SCT intégrés
certificate-viewer-crl-endpoints = Points de terminaison CRL

# This message is used as a row header in the Miscellaneous section.
# The associated data cell contains links to download the certificate.
certificate-viewer-download = Télécharger
# This message is used to replace boolean values (true/false) in several certificate fields, e.g. Certificate Authority
# Variables:
#   $boolean (String) - true/false value for the specific field
certificate-viewer-boolean =
    { $boolean ->
        [true] Oui
       *[false] Non
    }

## Variables:
##   $fileName (String) - The file name to save the PEM data in, derived from the common name from the certificate being displayed.

certificate-viewer-download-pem = PEM (cert)
    .download = { $fileName }.pem
certificate-viewer-download-pem-chain = PEM (chain)
    .download = { $fileName }-chain.pem

# The title attribute for Critical Extension icon
certificate-viewer-critical-extension =
    .title = Cette extension a été marquée comme critique, ce qui signifie que les clients doivent rejeter le certificat s’ils ne le comprennent pas.
certificate-viewer-export = Exporter
    .download = { $fileName }.pem

##

# Label for a tab where we haven't found a better label:
certificate-viewer-unknown-group-label = (inconnu)

## Labels for tabs displayed in stand-alone about:certificate page

certificate-viewer-tab-mine = Vos certificats
certificate-viewer-tab-people = Personnes
certificate-viewer-tab-servers = Serveurs
certificate-viewer-tab-ca = Autorités
certificate-viewer-tab-unkonwn = Inconnu
