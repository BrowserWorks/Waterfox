# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S

#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        Zobrazit informace o zabezpečení zprávy
        { PLATFORM() ->
            [macos] (⌘ ⌥ { message-header-show-security-info-key })
           *[other] (Ctrl+Alt+{ message-header-show-security-info-key })
        }

openpgp-view-signer-key =
    .label = Zobrazit klíč podpisovatele
openpgp-view-your-encryption-key =
    .label = Zobrazit váš dešifrovací klíč
openpgp-openpgp = OpenPGP

openpgp-no-sig = Žádný elektronický podpis
openpgp-uncertain-sig = Pochybný elektronický podpis
openpgp-invalid-sig = Neplatný elektronický podpis
openpgp-good-sig = Platný elektronický podpis

openpgp-sig-uncertain-no-key = Tato zpráva obsahuje elektronický podpis, ale není jisté, zda je správný. Chcete-li ho ověřit, musíte získat kopii veřejného klíče odesílatele.
openpgp-sig-uncertain-uid-mismatch = Tato zpráva obsahuje elektronický podpis, ale byla zjištěna neshoda. Zpráva byla odeslána z e-mailové adresy, která neodpovídá veřejnému klíči podpisovatele.
openpgp-sig-uncertain-not-accepted = Tato zpráva obsahuje elektronický podpis, ale ještě jste nerozhodli, zda klíč podpisovatele přijímáte či ne.
openpgp-sig-invalid-rejected = Tato zpráva obsahuje elektronický podpis, ale dříve jste rozhodli klíč podpisovatele nepřijmout.
openpgp-sig-invalid-technical-problem = Tato zpráva obsahuje elektronický podpis, ale byla zjištěna technická chyba. Buď byla zpráva poškozena, nebo byla někým pozměněna.
openpgp-sig-valid-unverified = Tato zpráva obsahuje platný elektronický podpis provedený klíčem, který jste už přijali. Ještě jste ale neověřili, že vlastníkem klíče je skutečně odesílatel.
openpgp-sig-valid-verified = Tato zpráva obsahuje platný elektronický podpis provedený ověřeným klíčem.
openpgp-sig-valid-own-key = Tato zpráva obsahuje platný elektronický podpis provedený vaším osobním klíčem.

openpgp-sig-key-id = ID klíče podpisovatele: { $key }
openpgp-sig-key-id-with-subkey-id = ID klíče podpisovatele: { $key } (ID podklíče: { $subkey })

openpgp-enc-key-id = ID vašeho dešifrovacího klíče: { $key }
openpgp-enc-key-with-subkey-id = ID vašeho dešifrovacího klíče: { $key } (ID podklíče: { $subkey })

openpgp-unknown-key-id = Neznámý klíč

openpgp-other-enc-additional-key-ids = Kromě toho byla zpráva zašifrována pro vlastníky následujících klíčů:
openpgp-other-enc-all-key-ids = Zpráva byla zašifrována pro vlastníky následujících klíčů:

openpgp-message-header-encrypted-ok-icon =
    .alt = Úspěšně dešifrováno
openpgp-message-header-encrypted-notok-icon =
    .alt = Dešifrování se nezdařilo

openpgp-message-header-signed-ok-icon =
    .alt = Podpis je v pořádku
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Podpis není v pořádku
openpgp-message-header-signed-unknown-icon =
    .alt = Neznámý stav podpisu
openpgp-message-header-signed-verified-icon =
    .alt = Podpis ověřen
openpgp-message-header-signed-unverified-icon =
    .alt = Neověřený podpis
