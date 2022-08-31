# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = Assistant de clés OpenPGP
openpgp-key-assistant-rogue-warning = Évitez d’accepter une fausse clé. Pour vous assurer d’avoir obtenu la bonne clé, vous devriez la vérifier. <a data-l10n-name="openpgp-link">En savoir plus…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Impossible de chiffrer
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] Pour chiffrer, vous devez obtenir et accepter une clé utilisable pour un destinataire. <a data-l10n-name="openpgp-link">En savoir plus…</a>
       *[other] Pour chiffrer, vous devez obtenir et accepter des clés utilisables pour { $count } destinataires. <a data-l10n-name="openpgp-link">En savoir plus…</a>
    }
openpgp-key-assistant-info-alias = { -brand-short-name } requiert normalement que la clé publique du destinataire contienne un identifiant d’utilisateur avec une adresse électronique correspondante. Cela peut être outrepassé en utilisant les règles d’alias d’OpenPGP pour le destinataire. <a data-l10n-name="openpgp-link">En savoir plus…</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] Vous avez déjà une clé utilisable et acceptée pour un destinataire.
       *[other] Vous avez déjà des clés utilisables et acceptées pour { $count } destinataires.
    }
openpgp-key-assistant-recipients-description-no-issues = Ce message peut être chiffré. Vous disposez de clés utilisables et acceptées pour tous les destinataires.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] { -brand-short-name } a trouvé la clé suivante pour { $recipient }.
       *[other] { -brand-short-name } a trouvé les clés suivantes pour { $recipient }.
    }
openpgp-key-assistant-valid-description = Sélectionnez la clé que vous souhaitez accepter
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] La clé suivante ne peut pas être utilisée sans avoir obtenu au préalable une mise à jour de la clé.
       *[other] Les clés suivantes ne peuvent pas être utilisées sans avoir obtenu au préalable une mise à jour des clés.
    }
openpgp-key-assistant-no-key-available = Aucune clé disponible.
openpgp-key-assistant-multiple-keys = Plusieurs clés sont disponibles.
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] Une clé est disponible, mais elle n’a pas encore été acceptée.
       *[other] Plusieurs clés sont disponibles, mais aucune d’entre elles n’a encore été acceptée.
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Une clé acceptée a expiré le { $date }.
openpgp-key-assistant-keys-accepted-expired = Plusieurs clés acceptées ont expiré.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Cette clé a été acceptée mais a expiré le { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = La clé a expiré le { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Plusieurs clés ont expiré.
openpgp-key-assistant-key-fingerprint = Empreinte numérique
openpgp-key-assistant-key-source =
    { $count ->
        [one] Source
       *[other] Sources
    }
openpgp-key-assistant-key-collected-attachment = pièce jointe
# Autocrypt is the name of a standard.
openpgp-key-assistant-key-collected-autocrypt = En-tête Autocrypt
openpgp-key-assistant-key-collected-keyserver = Serveur de clés
# Web Key Directory (WKD) is a concept.
openpgp-key-assistant-key-collected-wkd = Annuaire de clés web
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] Une clé a été trouvée mais n’a pas encore été acceptée.
       *[other] Plusieurs clés ont été trouvées mais aucune d’entre elles n’a encore été acceptée.
    }
openpgp-key-assistant-key-rejected = Cette clé a été rejetée précédemment.
openpgp-key-assistant-key-accepted-other = Cette clé a déjà été associée à une autre adresse électronique.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Rechercher en ligne de nouvelles clés ou des clés mises à jour pour { $recipient } ou les importer depuis un fichier.

## Discovery section

openpgp-key-assistant-discover-title = Recherche en ligne en cours.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Recherche de clés pour { $recipient }…
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    Une clé précédemment acceptée a été mise à jour pour { $recipient }.
    Elle est donc à nouveau valide et peut être utilisée.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Rechercher des clés publiques en ligne…
openpgp-key-assistant-import-keys-button = Importer des clés publiques depuis un fichier…
openpgp-key-assistant-issue-resolve-button = Résoudre…
openpgp-key-assistant-view-key-button = Afficher la clé…
openpgp-key-assistant-recipients-show-button = Afficher
openpgp-key-assistant-recipients-hide-button = Masquer
openpgp-key-assistant-cancel-button = Annuler
openpgp-key-assistant-back-button = Retour
openpgp-key-assistant-accept-button = Accepter
openpgp-key-assistant-close-button = Fermer
openpgp-key-assistant-disable-button = Désactiver le chiffrement
openpgp-key-assistant-confirm-button = Envoyer chiffré
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = créée le { $date }
