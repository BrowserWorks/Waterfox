# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-compose-key-status-intro-need-keys = Aby wysłać zaszyfrowaną wiadomość, musisz uzyskać i zaakceptować klucz publiczny każdego odbiorcy.
openpgp-compose-key-status-keys-heading = Dostępność kluczy OpenPGP:
openpgp-compose-key-status-title =
    .title = Bezpieczeństwo wiadomości OpenPGP
openpgp-compose-key-status-recipient =
    .label = Odbiorca
openpgp-compose-key-status-status =
    .label = Stan
openpgp-compose-key-status-open-details = Zarządzaj kluczami wybranego odbiorcy…
openpgp-recip-good = OK
openpgp-recip-missing = brak dostępnych kluczy
openpgp-recip-none-accepted = brak zaakceptowanych kluczy
openpgp-compose-general-info-alias = { -brand-short-name } zwykle wymaga, aby klucz publiczny odbiorcy zawierał identyfikator użytkownika z pasującym adresem e-mail. Można to zmienić za pomocą reguł aliasów odbiorców OpenPGP.
openpgp-compose-general-info-alias-learn-more = Więcej informacji
openpgp-compose-alias-status-direct =
    { $count ->
        [one] mapowane do klucza aliasu
        [few] mapowane do { $count } kluczy aliasu
       *[many] mapowane do { $count } kluczy aliasu
    }
openpgp-compose-alias-status-error = nienadający się do użytku/niedostępny klucz aliasu
