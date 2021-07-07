# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S

#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Vi meddelelsens sikkerhedsoplysninger (⌃ ⌘ { message-header-show-security-info-key })
           *[other] Vi meddelelsens sikkerhedsoplysninger (Ctrl+Alt+{ message-header-show-security-info-key })
        }

openpgp-view-signer-key =
    .label = Se underskriftsnøgle
openpgp-view-your-encryption-key =
    .label = Se din dekrypteringsnøgle
openpgp-openpgp = OpenPGP

openpgp-no-sig = Ingen digital signatur
openpgp-uncertain-sig = Usikker digital signatur
openpgp-invalid-sig = Ugyldig digital signatur
openpgp-good-sig = God digital signatur

openpgp-sig-uncertain-no-key = Denne meddelelse indeholder en digital signatur, men det er usikkert, om den er korrekt. For at bekræfte signaturen, skal du få fat i en kopi af afsenderens offentlige nøgle.
openpgp-sig-uncertain-uid-mismatch = Denne meddelelse indeholder en digital signatur, men der er en uoverensstemmelse. Meddelelsen er sendt fra en mailadresse, der ikke matcher underskriverens offentlige nøgle.
openpgp-sig-uncertain-not-accepted = Denne meddelelse indeholder en digital signatur, men du har endnu ikke angivet, om du kan acceptere underskriverens nøgle.
openpgp-sig-invalid-rejected = Denne meddelelse indeholder en digital signatur, men du har tidligere besluttet at afvise underskriverens nøgle.
openpgp-sig-invalid-technical-problem = Denne meddelelse indeholder en digital signatur, men der er opstået en teknisk fejl. Enten er meddelelsen blevet ødelagt, eller også er den blevet ændret af en anden.
openpgp-sig-valid-unverified = Denne meddelelse indeholder en gyldig digital signatur fra en nøgle, som du allerede har accepteret. Du har dog endnu ikke verificeret, om nøglen rent faktisk tilhører afsenderen.
openpgp-sig-valid-verified = Denne meddelelse indeholder en gyldig digital signatur fra en verificeret nøgle.
openpgp-sig-valid-own-key = Denne meddelelse indeholder en gyldig digital signatur fra din personlige nøgle.

openpgp-sig-key-id = Underskrivers nøgle-id: { $key }
openpgp-sig-key-id-with-subkey-id = Underskrivers nøgle-id: { $key } (Undernøgle-id: { $subkey })

openpgp-enc-key-id = Dit dekrypteringsnøgle-id: { $key }
openpgp-enc-key-with-subkey-id = Dit dekrypteringsnøgle-id: { $key } (Undernøgle-id: { $subkey })

openpgp-unknown-key-id = Ukendt nøgle

openpgp-other-enc-additional-key-ids = Derudover er meddelelsen krypteret til ejerne af følgende nøgler:
openpgp-other-enc-all-key-ids = Meddelelsen er krypteret til ejerne af følgende nøgler:

openpgp-message-header-encrypted-ok-icon =
    .alt = Dekryptering færdig
openpgp-message-header-encrypted-notok-icon =
    .alt = Dekryptering mislykkedes

openpgp-message-header-signed-ok-icon =
    .alt = God signatur
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Dårlig signatur
openpgp-message-header-signed-unknown-icon =
    .alt = Ukendt signaturstatus
openpgp-message-header-signed-verified-icon =
    .alt = Verificeret signatur
openpgp-message-header-signed-unverified-icon =
    .alt = Ikke-verificeret signatur
