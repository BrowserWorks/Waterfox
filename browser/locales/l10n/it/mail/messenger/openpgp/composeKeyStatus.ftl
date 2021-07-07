# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = Per inviare un messaggio con cifratura end-to-end, è necessario ottenere e accettare una chiave pubblica per ciascun destinatario.
openpgp-compose-key-status-keys-heading = Disponibilità delle chiavi OpenPGP:
openpgp-compose-key-status-title =
    .title = Sicurezza messaggio OpenPGP
openpgp-compose-key-status-recipient =
    .label = Destinatario
openpgp-compose-key-status-status =
    .label = Stato
openpgp-compose-key-status-open-details = Gestisci le chiavi per il destinatario selezionato...
openpgp-recip-good = OK
openpgp-recip-missing = nessuna chiave disponibile
openpgp-recip-none-accepted = nessuna chiave accettata
openpgp-compose-general-info-alias = { -brand-short-name } normalmente richiede che la chiave pubblica del destinatario contenga un ID utente con un indirizzo email corrispondente. Questo può essere sovrascritto utilizzando le regole di OpenPGP per gli alias del destinatario.
openpgp-compose-general-info-alias-learn-more = Ulteriori informazioni
openpgp-compose-alias-status-direct =
    { $count ->
        [one] mappato a una chiave alias
       *[other] mappato a { $count } chiavi alias
    }
openpgp-compose-alias-status-error = chiave alias inutilizzabile/non disponibile
