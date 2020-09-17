# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-view-signer-key =
    .label = Visa undertecknarens nyckel
openpgp-view-your-encryption-key =
    .label = Visa din dekrypteringsnyckel
openpgp-openpgp = OpenPGP

openpgp-no-sig = Ingen digital signatur
openpgp-uncertain-sig = Osäker digital signatur
openpgp-invalid-sig = Ogiltig digital signatur
openpgp-good-sig = Bra digital signatur

openpgp-sig-uncertain-no-key = Det här meddelandet innehåller en digital signatur, men det är osäkert om den är korrekt. För att verifiera signaturen måste du skaffa en kopia av avsändarens publika nyckel.
openpgp-sig-uncertain-uid-mismatch = Det här meddelandet innehåller en digital signatur, men en felmatchning upptäcktes. Meddelandet skickades från en e-postadress som inte stämmer med undertecknarens publika nyckel.
openpgp-sig-uncertain-not-accepted = Det här meddelandet innehåller en digital signatur, men du har ännu inte beslutat om undertecknarens nyckel är acceptabel för dig.
openpgp-sig-invalid-rejected = Det här meddelandet innehåller en digital signatur, men du har tidigare beslutat att avvisa undertecknarens nyckel.
openpgp-sig-invalid-technical-problem = Det här meddelandet innehåller en digital signatur, men ett tekniskt fel upptäcktes. Antingen har meddelandet skadats eller så har meddelandet ändrats av någon annan.
openpgp-sig-valid-unverified = Det här meddelandet innehåller en giltig digital signatur från en nyckel som du redan har accepterat. Du har dock ännu inte verifierat att nyckeln verkligen ägs av avsändaren.
openpgp-sig-valid-verified = Det här meddelandet innehåller en giltig digital signatur från en verifierad nyckel.
openpgp-sig-valid-own-key = Det här meddelandet innehåller en giltig digital signatur från din personliga nyckel.

openpgp-sig-key-id = Undertecknarens nyckel-ID: { $key }
openpgp-sig-key-id-with-subkey-id = Undertecknarens nyckel-ID: { $key } (Undernyckel-ID: { $subkey })

openpgp-enc-key-id = Ditt dekrypteringsnyckel-ID: { $key }
openpgp-enc-key-with-subkey-id = Ditt dekrypteringsnyckel-ID: { $key } (Undernyckel-ID: { $subkey })

openpgp-unknown-key-id = Okänd nyckel

openpgp-other-enc-additional-key-ids = Dessutom krypterades meddelandet till ägarna av följande nycklar:
openpgp-other-enc-all-key-ids = Meddelandet krypterades till ägarna av följande nycklar:
