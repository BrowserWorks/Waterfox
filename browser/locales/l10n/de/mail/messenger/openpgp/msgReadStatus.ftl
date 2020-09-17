# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-view-signer-key =
    .label = Schlüssel der digitalen Unterschrift anzeigen
openpgp-view-your-encryption-key =
    .label = Ihren Schlüssel für Entschlüsselung anzeigen
openpgp-openpgp = OpenPGP

openpgp-no-sig = Keine digitale Unterschrift
openpgp-uncertain-sig = Nicht gesicherte digitale Unterschrift
openpgp-invalid-sig = Ungültige digitale Unterschrift
openpgp-good-sig = Gute digitale Unterschrift

openpgp-sig-uncertain-no-key = Diese Nachricht enthält eine digitale Unterschrift, aber es ist nicht gesichert, dass diese korrekt ist. Um die digitale Unterschrift zu verifizieren, müssen Sie eine Kopie des öffentlichen Schlüssels des Absenders erhalten.
openpgp-sig-uncertain-uid-mismatch = Diese Nachricht enthält eine digitale Unterschrift, aber es gab einen Fehler bei der Übereinstimmung. Die Nachricht wurde von einer E-Mail-Adresse gesendet, welche nicht mit der im öffentlichen Schlüssel des Unterschriftengebers übereinstimmt.
openpgp-sig-uncertain-not-accepted = Diese Nachricht enthält eine digitale Unterschrift, aber Sie haben noch nicht entschieden, ob Sie den Schlüssel des Unterschriftengebers akzeptieren.
openpgp-sig-invalid-rejected = Diese Nachricht enthält eine digitale Unterschrift, aber Sie haben den Schlüssel des Unterschriftengebers zu einem früheren Zeitpunkt als abzulehnen eingestuft.
openpgp-sig-invalid-technical-problem = Diese Nachricht enthält eine digitale Unterschrift, aber ein technischer Fehler wurde erkannt. Entweder ist die Nachricht beschädigt oder sie wurde von jemandem anders verändert.
openpgp-sig-valid-unverified = Diese Nachricht enthält eine gültige digitale Unterschrift mit einem bereits von Ihnen akzeptierten Schlüssel. Bislang haben Sie aber nicht verifiziert, dass der Schlüssel wirklich dem Sender gehört.
openpgp-sig-valid-verified = Diese Nachricht enthält eine gültige digitale Unterschrift mit einem verifizierten Schlüssel.
openpgp-sig-valid-own-key = Diese Nachricht enthält eine gültige digitale Unterschrift mit Ihrem persönlichen Schlüssel.

openpgp-sig-key-id = Schlüssel-ID der digitalen Unterschrift: { $key }
openpgp-sig-key-id-with-subkey-id = Schlüssel-ID der digitalen Unterschrift: { $key } (Unterschlüssel-ID: { $subkey })

openpgp-enc-key-id = Ihr Schlüssel für Entschlüsselung: { $key }
openpgp-enc-key-with-subkey-id = Ihre Schlüssel-ID für Entschlüsselung: { $key } (Unterschlüssel-ID: { $subkey })

openpgp-unknown-key-id = Unbekannter Schlüssel

openpgp-other-enc-additional-key-ids = Zusätzlich wurde die Nachricht an die Besitzer der folgenden Schlüssel verschlüsselt gesendet:
openpgp-other-enc-all-key-ids = Die Nachricht wurde an die Besitzer der folgenden Schlüssel verschlüsselt gesendet:
