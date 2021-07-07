# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = Pour envoyer un message chiffré de bout en bout, vous devez obtenir et accepter une clé publique pour chaque destinataire.
openpgp-compose-key-status-keys-heading = Disponibilité des clés OpenPGP :
openpgp-compose-key-status-title =
    .title = Sécurité des messages OpenPGP
openpgp-compose-key-status-recipient =
    .label = Destinataire
openpgp-compose-key-status-status =
    .label = État
openpgp-compose-key-status-open-details = Gérer les clés du destinataire sélectionné…
openpgp-recip-good = ok
openpgp-recip-missing = aucune clé disponible
openpgp-recip-none-accepted = aucune clé acceptée
openpgp-compose-general-info-alias = { -brand-short-name } requiert normalement que la clé publique du destinataire contienne un identifiant d’utilisateur avec une adresse électronique correspondante. Cela peut être outrepassé en utilisant les règles d’alias d’OpenPGP pour le destinataire.
openpgp-compose-general-info-alias-learn-more = En savoir plus
openpgp-compose-alias-status-direct =
    { $count ->
        [one] mappé sur une clé d’alias
       *[other] mappé sur { $count } clés d’alias
    }
openpgp-compose-alias-status-error = Clé d’alias inutilisable/indisponible
