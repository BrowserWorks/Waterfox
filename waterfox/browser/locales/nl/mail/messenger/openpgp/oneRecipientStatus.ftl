# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = OpenPGP-berichtbeveiliging
openpgp-one-recipient-status-status =
    .label = Status
openpgp-one-recipient-status-key-id =
    .label = Sleutel-ID
openpgp-one-recipient-status-created-date =
    .label = Aangemaakt
openpgp-one-recipient-status-expires-date =
    .label = Vervalt op
openpgp-one-recipient-status-open-details =
    .label = Details openen en acceptatie bewerken…
openpgp-one-recipient-status-discover =
    .label = Nieuwe of bijgewerkte sleutel ontdekken

openpgp-one-recipient-status-instruction1 = Om een end-to-end-versleuteld bericht naar een ontvanger te sturen, dient u diens publieke OpenPGP-sleutel te verkrijgen en deze als geaccepteerd te markeren.
openpgp-one-recipient-status-instruction2 = Om de publieke sleutel te verkrijgen, importeert u deze vanuit het e-mailbericht dat ze u hebben verzonden waarin de sleutel is opgenomen. U kunt ook proberen hun publieke sleutel in een directory te vinden.

openpgp-key-own = Geaccepteerd (persoonlijke sleutel)
openpgp-key-secret-not-personal = Niet bruikbaar
openpgp-key-verified = Geaccepteerd (geverifieerd)
openpgp-key-unverified = Geaccepteerd (niet geverifieerd)
openpgp-key-undecided = Niet geaccepteerd (onbeslist)
openpgp-key-rejected = Niet geaccepteerd (afgewezen)
openpgp-key-expired = Verlopen

openpgp-intro = Beschikbare publieke sleutels voor { $key }

openpgp-pubkey-import-id = ID: { $kid }
openpgp-pubkey-import-fpr = Vingerafdruk: { $fpr }

openpgp-pubkey-import-intro =
    { $num ->
        [one] Het bestand bevat een publieke sleutel zoals hieronder getoond:
       *[other] Het bestand bevat { $num } publieke sleutels zoals hieronder getoond:
    }

openpgp-pubkey-import-accept =
    { $num ->
        [one] Accepteert u deze sleutel voor het verifiëren van digitale handtekeningen en voor het versleutelen van berichten, voor alle getoonde e-mailadressen?
       *[other] Accepteert u deze sleutels voor het verifiëren van digitale handtekeningen en voor het versleutelen van berichten, voor alle getoonde e-mailadressen?
    }

pubkey-import-button =
    .buttonlabelaccept = Importeren
    .buttonaccesskeyaccept = I
