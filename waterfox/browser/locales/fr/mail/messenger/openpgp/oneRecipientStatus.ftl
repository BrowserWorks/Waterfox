# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = Sécurité des messages OpenPGP
openpgp-one-recipient-status-status =
    .label = État
openpgp-one-recipient-status-key-id =
    .label = Identifiant de clé
openpgp-one-recipient-status-created-date =
    .label = Date de création
openpgp-one-recipient-status-expires-date =
    .label = Date d’expiration
openpgp-one-recipient-status-open-details =
    .label = Ouvrir les détails et modifier l’acceptation…
openpgp-one-recipient-status-discover =
    .label = Rechercher une clé nouvelle ou mise à jour

openpgp-one-recipient-status-instruction1 = Pour envoyer un message chiffré de bout en bout à un destinataire, vous devez obtenir sa clé publique OpenPGP et la marquer comme acceptée.
openpgp-one-recipient-status-instruction2 = Pour obtenir les clés publiques de vos destinataires, importez-les à partir des courriels qui vous ont été envoyés et qui les incluent. Vous pouvez également essayer de rechercher leur clé publique sur un annuaire.

openpgp-key-own = Acceptée (clé personnelle)
openpgp-key-secret-not-personal = Non utilisable
openpgp-key-verified = Acceptée (vérifiée)
openpgp-key-unverified = Acceptée (non vérifiée)
openpgp-key-undecided = Non acceptée (aucune décision)
openpgp-key-rejected = Non acceptée (rejetée)
openpgp-key-expired = Expirée

openpgp-intro = Clés publiques disponibles pour { $key }

openpgp-pubkey-import-id = ID : { $kid }
openpgp-pubkey-import-fpr = Empreinte numérique : { $fpr }

openpgp-pubkey-import-intro =
    { $num ->
        [one] Le fichier contient une clé publique, comme indiqué ci-dessous :
       *[other] Le fichier contient { $num } clés publiques, comme indiqué ci-dessous :
    }

openpgp-pubkey-import-accept =
    { $num ->
        [one] Acceptez-vous cette clé pour vérifier les signatures numériques et pour chiffrer les messages, pour toutes les adresses affichées ?
       *[other] Acceptez-vous ces clés pour vérifier les signatures numériques et pour chiffrer les messages, pour toutes les adresses affichées ?
    }

pubkey-import-button =
    .buttonlabelaccept = Importer
    .buttonaccesskeyaccept = I
