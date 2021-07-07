# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S
#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Üzenet biztonsági adatainak megjelenítése (⌘ ⌥ { message-header-show-security-info-key })
           *[other] Üzenet biztonsági adatainak megjelenítése (Ctrl + Alt + { message-header-show-security-info-key })
        }
openpgp-view-signer-key =
    .label = Aláíró kulcs megtekintése
openpgp-view-your-encryption-key =
    .label = Visszafejtési kulcs megtekintése
openpgp-openpgp = OpenPGP
openpgp-no-sig = Nincs digitális aláírás
openpgp-uncertain-sig = Bizonytalan digitális aláírás
openpgp-invalid-sig = Érvénytelen digitális aláírás
openpgp-good-sig = Jó digitális aláírás
openpgp-sig-uncertain-no-key = Ez az üzenet digitális aláírást tartalmaz, de nem biztos, hogy helyes. Az aláírás ellenőrzéséhez meg kell szereznie a feladó nyilvános kulcsának másolatát.
openpgp-sig-uncertain-uid-mismatch = Ez az üzenet digitális aláírást tartalmaz, de eltérést észleltek. Az üzenetet olyan e-mail-címről küldték, amely nem felel meg az aláíró nyilvános kulcsának.
openpgp-sig-uncertain-not-accepted = Ez az üzenet digitális aláírást tartalmaz, de még nem döntött arról, hogy az aláíró kulcsa elfogadható-e Ön számára.
openpgp-sig-invalid-rejected = Ez az üzenet digitális aláírást tartalmaz, de Ön korábban úgy döntött, hogy elutasítja az aláíró kulcsot.
openpgp-sig-invalid-technical-problem = Ez az üzenet digitális aláírást tartalmaz, de technikai hibát észleltek. Vagy az üzenet sérült meg, vagy valaki más módosította az üzenetet.
openpgp-sig-valid-unverified = Ez az üzenet érvényes digitális aláírást tartalmaz egy olyan kulcsból, amelyet már elfogadott. Viszont még nem erősítette meg, hogy a kulcs valóban a feladó tulajdonában van.
openpgp-sig-valid-verified = Ez az üzenet érvényes digitális aláírást tartalmaz egy ellenőrzött kulcsból.
openpgp-sig-valid-own-key = Ez az üzenet érvényes digitális aláírást tartalmaz a személyes kulcsából.
openpgp-sig-key-id = Aláíró kulcs azonosítója: { $key }
openpgp-sig-key-id-with-subkey-id = Aláíró kulcs azonosítója: { $key } (Alkulcs azonosítója: { $subkey })
openpgp-enc-key-id = A visszafejtési kulcs azonosítója: { $key }
openpgp-enc-key-with-subkey-id = A visszafejtési kulcs azonosítója: { $key } (Alkulcs azonosítója: { $subkey })
openpgp-unknown-key-id = Ismeretlen kulcs
openpgp-other-enc-additional-key-ids = Továbbá, az üzenetet a következő kulcsok tulajdonosai számára titkosították:
openpgp-other-enc-all-key-ids = Az üzenet a következő kulcsok tulajdonosainak lett titkosítva:
openpgp-message-header-encrypted-ok-icon =
    .alt = A visszafejtés sikeres
openpgp-message-header-encrypted-notok-icon =
    .alt = A visszafejtés nem sikerült
openpgp-message-header-signed-ok-icon =
    .alt = Helyes aláírás
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Hibás aláírás
openpgp-message-header-signed-unknown-icon =
    .alt = Ismeretlen aláírás-állapot
openpgp-message-header-signed-verified-icon =
    .alt = Ellenőrzött aláírás
openpgp-message-header-signed-unverified-icon =
    .alt = Nem ellenőrzött aláírás
