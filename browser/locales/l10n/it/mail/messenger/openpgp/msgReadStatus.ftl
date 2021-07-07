# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = m
#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Visualizza informazioni sicurezza messaggio (⌘ ⌥ { message-header-show-security-info-key })
           *[other] Visualizza informazioni sicurezza messaggio (Ctrl+Alt+{ message-header-show-security-info-key })
        }
openpgp-view-signer-key =
    .label = Visualizza la chiave del firmatario
openpgp-view-your-encryption-key =
    .label = Visualizza la tua chiave di decrittazione
openpgp-openpgp = OpenPGP
openpgp-no-sig = Nessuna firma digitale
openpgp-uncertain-sig = Firma digitale dubbia
openpgp-invalid-sig = Firma digitale non valida
openpgp-good-sig = Firma digitale valida
openpgp-sig-uncertain-no-key = Questo messaggio contiene una firma digitale ma potrebbe non essere corretta. Per verificare la firma, è necessario ottenere una copia della chiave pubblica del mittente.
openpgp-sig-uncertain-uid-mismatch = Questo messaggio contiene una firma digitale ma è stata rilevata una mancata corrispondenza. Il messaggio è stato inviato da un indirizzo email che non corrisponde alla chiave pubblica del firmatario.
openpgp-sig-uncertain-not-accepted = Questo messaggio contiene una firma digitale, ma non si è ancora deciso se accettare la chiave del firmatario.
openpgp-sig-invalid-rejected = Questo messaggio contiene una firma digitale, ma in precedenza è stato deciso di rifiutare la chiave del firmatario.
openpgp-sig-invalid-technical-problem = Questo messaggio contiene una firma digitale ma è stato rilevato un errore tecnico. Il messaggio è stato danneggiato o è stato modificato da qualcun altro.
openpgp-sig-valid-unverified = Questo messaggio include una firma digitale valida da una chiave che è già stata accettata. Tuttavia, non è ancora stato verificato che la chiave sia realmente di proprietà del mittente.
openpgp-sig-valid-verified = Questo messaggio include una firma digitale valida da una chiave verificata.
openpgp-sig-valid-own-key = Questo messaggio include una firma digitale valida dalla tua chiave personale.
openpgp-sig-key-id = ID chiave del firmatario: { $key }
openpgp-sig-key-id-with-subkey-id = ID chiave del firmatario: { $key } (ID sottochiave: { $subkey })
openpgp-enc-key-id = ID della tua chiave di decrittazione: { $key }
openpgp-enc-key-with-subkey-id = ID della tua chiave di decrittazione: { $key } (ID sottochiave: { $subkey })
openpgp-unknown-key-id = Chiave sconosciuta
openpgp-other-enc-additional-key-ids = Inoltre, il messaggio è stato crittato per i proprietari delle seguenti chiavi:
openpgp-other-enc-all-key-ids = Il messaggio è stato crittato per i proprietari delle seguenti chiavi:
openpgp-message-header-encrypted-ok-icon =
    .alt = Decrittazione completata
openpgp-message-header-encrypted-notok-icon =
    .alt = Decrittazione non riuscita
openpgp-message-header-signed-ok-icon =
    .alt = Firma valida
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Firma non valida
openpgp-message-header-signed-unknown-icon =
    .alt = Stato firma sconosciuto
openpgp-message-header-signed-verified-icon =
    .alt = Firma verificata
openpgp-message-header-signed-unverified-icon =
    .alt = Firma non verificata
