# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-view-signer-key =
    .label = Afișează cheia semnatarului
openpgp-view-your-encryption-key =
    .label = Afișează cheia de decriptare
openpgp-openpgp = OpenPGP

openpgp-no-sig = Nicio semnătură digitală
openpgp-uncertain-sig = Semnătură digitală incertă
openpgp-invalid-sig = Semnătură digitală nevalidă
openpgp-good-sig = Semnătură digitală bună

openpgp-sig-uncertain-no-key = Mesajul conține o semnătură digitală, dar nu este sigur dacă este corectă. Pentru verificarea semnăturii, trebuie să obții un exemplar al cheii publice a expeditorului.
openpgp-sig-uncertain-uid-mismatch = Mesajul conține o semnătură digitală, dar s-a depistat o nepotrivire. Mesajul a fost trimis de la o adresă de e-mail care nu se potrivește cu cheia publică a semnatarului.
openpgp-sig-uncertain-not-accepted = Mesajul conține o semnătură digitală, dar nu ai decis încă dacă această cheie a semnatarului este acceptabilă pentru tine.
openpgp-sig-invalid-rejected = Mesajul conține o semnătură digitală, dar ai decis anterior să respingi cheia semnatarului.
openpgp-sig-invalid-technical-problem = Mesajul conține o cheie digitală, dar s-a depistat o eroare tehnică. Mesajul este ori corupt, ori a fost modificat de altcineva.
openpgp-sig-valid-unverified = Mesajul include o semnătură digitală validă dintr-o cheie pe care ai acceptat-o deja. Dar încă nu ai verificat dacă expeditorul chiar deține cheia.
openpgp-sig-valid-verified = Mesajul include o semnătură digitală validă dintr-o cheie verificată.
openpgp-sig-valid-own-key = Mesajul include o semnătură digitală validă din cheia ta personală.

openpgp-sig-key-id = ID cheie semnatar: { $key }
openpgp-sig-key-id-with-subkey-id = ID cheie semnatar: { $key } (ID subcheie: { $subkey })

openpgp-enc-key-id = ID cheie de decriptare: { $key }
openpgp-enc-key-with-subkey-id = ID cheie de decriptare: { $key } (IS subcheie: { $subkey })

openpgp-unknown-key-id = Cheie necunoscută

openpgp-other-enc-additional-key-ids = În plus, mesajul a fost criptat pentru proprietarii cheilor următoare:
openpgp-other-enc-all-key-ids = Mesajul a fost criptat pentru proprietarii cheilor următoare:
