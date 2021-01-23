# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-view-signer-key =
    .label = Vis signatarnøkkel
openpgp-view-your-encryption-key =
    .label = Vis dekrypteringsnøkkelen din
openpgp-openpgp = OpenPGP

openpgp-no-sig = Ingen digital signatur
openpgp-uncertain-sig = Usikker digital signatur
openpgp-invalid-sig = Ugyldig digital signatur
openpgp-good-sig = Korrekt digital signatur

openpgp-sig-uncertain-no-key = Denne meldingen inneholder en digital signatur, men det er usikkert om den er riktig. For å bekrefte signaturen, må du skaffe en kopi av avsenderens offentlige nøkkel.
openpgp-sig-uncertain-uid-mismatch = Denne meldingen inneholder en digital signatur, men det ble oppdaget et misforhold. Meldingen ble sendt fra en e-postadresse som ikke samsvarer med signatarens offentlige nøkkel.
openpgp-sig-uncertain-not-accepted = Denne meldingen inneholder en digital signatur, men du har ennå ikke bestemt deg for om signatorens nøkkel er akseptabel for deg.
openpgp-sig-invalid-rejected = Denne meldingen inneholder en digital signatur, men du har tidligere bestemt deg for å avvise signatornøkkelen.
openpgp-sig-invalid-technical-problem = Denne meldingen inneholder en digital signatur, men en teknisk feil ble oppdaget. Enten er meldingen blitt ødelagt, eller så er meldingen blitt endret av noen andre.
openpgp-sig-valid-unverified = Denne meldingen inneholder en gyldig digital signatur fra en nøkkel som du allerede har akseptert. Du har imidlertid ennå ikke bekreftet at nøkkelen virkelig eies av avsenderen.
openpgp-sig-valid-verified = Denne meldingen inneholder en gyldig digital signatur fra en bekreftet nøkkel.
openpgp-sig-valid-own-key = Denne meldingen inneholder en gyldig digital signatur fra din personlige nøkkel.

openpgp-sig-key-id = Signatarnøkkel-ID: { $key }
openpgp-sig-key-id-with-subkey-id = Signatarnøkkel-ID: { $key } (Undernøkkel-ID: { $subkey })

openpgp-enc-key-id = Din dekrypteringsnøkkel-ID:  { $key }
openpgp-enc-key-with-subkey-id = Din dekrypteringsnøkkel-ID: { $key } (Undernøkkel-ID: { $subkey })

openpgp-unknown-key-id = Ukjent nøkkel

openpgp-other-enc-additional-key-ids = I tillegg ble meldingen kryptert til eierne av følgende nøkler:
openpgp-other-enc-all-key-ids = Meldingen ble kryptert til eierne av følgende nøkler:
