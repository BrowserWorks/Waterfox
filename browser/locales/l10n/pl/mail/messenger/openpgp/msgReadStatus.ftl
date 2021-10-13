# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Message Header Encryption Button

message-header-show-security-info-key = S

#   $type (String) - the shortcut key defined in the message-header-show-security-info-key
message-security-button =
    .title =
        { PLATFORM() ->
            [macos] Wyświetl zabezpieczenia wiadomości (⌃ ⌘ { message-header-show-security-info-key })
           *[other] Wyświetl zabezpieczenia wiadomości (Ctrl+Alt+{ message-header-show-security-info-key })
        }

openpgp-view-signer-key =
    .label = Wyświetl klucz osoby podpisującej
openpgp-view-your-encryption-key =
    .label = Wyświetl swój klucz odszyfrowywania
openpgp-openpgp = OpenPGP

openpgp-no-sig = Brak podpisu cyfrowego
openpgp-uncertain-sig = Niepewny podpis cyfrowy
openpgp-invalid-sig = Nieprawidłowy podpis cyfrowy
openpgp-good-sig = Dobry podpis cyfrowy

openpgp-sig-uncertain-no-key = Ta wiadomość zawiera podpis cyfrowy, ale nie ma pewności, czy jest on właściwy. Aby zweryfikować ten podpis, musisz uzyskać kopię klucza publicznego nadawcy.
openpgp-sig-uncertain-uid-mismatch = Ta wiadomość zawiera podpis cyfrowy, ale wykryto niezgodność. Wiadomość została wysłana z adresu e-mail, który nie zgadza się z kluczem publicznym osoby podpisującej.
openpgp-sig-uncertain-not-accepted = Ta wiadomość zawiera podpis cyfrowy, ale nie zdecydowano jeszcze, czy klucz osoby podpisującej jest dla Ciebie akceptowalny.
openpgp-sig-invalid-rejected = Ta wiadomość zawiera podpis cyfrowy, ale wcześniej zdecydowano odrzucić klucz osoby podpisującej.
openpgp-sig-invalid-technical-problem = Ta wiadomość zawiera podpis cyfrowy, ale wykryto błąd techniczny. Wiadomość została uszkodzona albo zmieniona przez kogoś innego.
openpgp-sig-valid-unverified = Ta wiadomość zawiera prawidłowy podpis cyfrowy z klucza, który już zaakceptowano. Nie zweryfikowano jednak jeszcze, czy klucz jest rzeczywiście własnością nadawcy.
openpgp-sig-valid-verified = Ta wiadomość zawiera prawidłowy podpis cyfrowy ze zweryfikowanego klucza.
openpgp-sig-valid-own-key = Ta wiadomość zawiera prawidłowy podpis cyfrowy z własnego klucza osobistego.

openpgp-sig-key-id = Identyfikator klucza osoby podpisującej: { $key }
openpgp-sig-key-id-with-subkey-id = Identyfikator klucza osoby podpisującej: { $key } (identyfikator klucza podrzędnego: { $subkey })

openpgp-enc-key-id = Identyfikator Twojego klucza odszyfrowywania: { $key }
openpgp-enc-key-with-subkey-id = Identyfikator Twojego klucza odszyfrowywania: { $key } (identyfikator klucza podrzędnego: { $subkey })

openpgp-unknown-key-id = Nieznany klucz

openpgp-other-enc-additional-key-ids = Dodatkowo wiadomość została zaszyfrowana dla właścicieli tych kluczy:
openpgp-other-enc-all-key-ids = Wiadomość została zaszyfrowana dla właścicieli tych kluczy:

openpgp-message-header-encrypted-ok-icon =
    .alt = Pomyślne odszyfrowanie
openpgp-message-header-encrypted-notok-icon =
    .alt = Odszyfrowanie się nie powiodło

openpgp-message-header-signed-ok-icon =
    .alt = Dobry podpis
# Mismatch icon is used for notok state as well
openpgp-message-header-signed-mismatch-icon =
    .alt = Błędny podpis
openpgp-message-header-signed-unknown-icon =
    .alt = Nieznany stan podpisu
openpgp-message-header-signed-verified-icon =
    .alt = Zweryfikowany podpis
openpgp-message-header-signed-unverified-icon =
    .alt = Niezweryfikowany podpis
