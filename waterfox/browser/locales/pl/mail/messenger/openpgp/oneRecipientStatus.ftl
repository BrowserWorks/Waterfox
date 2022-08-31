# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-one-recipient-status-title =
    .title = Bezpieczeństwo wiadomości OpenPGP
openpgp-one-recipient-status-status =
    .label = Stan
openpgp-one-recipient-status-key-id =
    .label = Identyfikator klucza
openpgp-one-recipient-status-created-date =
    .label = Utworzono
openpgp-one-recipient-status-expires-date =
    .label = Wygasa
openpgp-one-recipient-status-open-details =
    .label = Otwórz informacje i modyfikuj akceptację…
openpgp-one-recipient-status-discover =
    .label = Wykryj nowy lub zaktualizowany klucz
openpgp-one-recipient-status-instruction1 = Aby wysłać zaszyfrowaną wiadomość do odbiorcy, musisz uzyskać jego klucz publiczny OpenPGP i oznaczyć go jako zaakceptowany.
openpgp-one-recipient-status-instruction2 = Aby uzyskać jego klucz publiczny, zaimportuj go z otrzymanej wiadomości e-mail, która go zawiera. Możesz także zamiast tego spróbować wykryć jego klucz publiczny w katalogu.
openpgp-key-own = Zaakceptowany (klucz osobisty)
openpgp-key-secret-not-personal = Nie nadaje się do użytku
openpgp-key-verified = Zaakceptowany (zweryfikowany)
openpgp-key-unverified = Zaakceptowany (niezweryfikowany)
openpgp-key-undecided = Niezaakceptowany (niezdecydowany)
openpgp-key-rejected = Niezaakceptowany (odrzucony)
openpgp-key-expired = Wygasły
openpgp-intro = Dostępne klucze publiczne dla { $key }
openpgp-pubkey-import-id = Identyfikator: { $kid }
openpgp-pubkey-import-fpr = Odcisk klucza: { $fpr }
openpgp-pubkey-import-intro =
    { $num ->
        [one] Plik zawiera jeden klucz publiczny, jak widać niżej:
        [few] Plik zawiera { $num } klucze publiczne, jak widać niżej:
       *[many] Plik zawiera { $num } kluczy publicznych, jak widać niżej:
    }
openpgp-pubkey-import-accept =
    { $num ->
        [one] Czy akceptujesz ten klucz do weryfikowania podpisów cyfrowych i szyfrowania wiadomości dla wszystkich wyświetlanych adresów e-mail?
       *[other] Czy akceptujesz te klucze do weryfikowania podpisów cyfrowych i szyfrowania wiadomości dla wszystkich wyświetlanych adresów e-mail?
    }
pubkey-import-button =
    .buttonlabelaccept = Importuj
    .buttonaccesskeyaccept = m
