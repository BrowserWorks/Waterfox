# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-key-assistant-title = Asystent klucza OpenPGP
openpgp-key-assistant-rogue-warning = Unikaj akceptowania fałszywych kluczy. Aby upewnić się, że uzyskano właściwy klucz, należy go zweryfikować. <a data-l10n-name="openpgp-link">Więcej informacji…</a>

## Encryption status

openpgp-key-assistant-recipients-issue-header = Nie można zaszyfrować
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-issue-description =
    { $count ->
        [one] Aby zaszyfrować, musisz uzyskać i zaakceptować nadający się klucz jednego odbiorcy. <a data-l10n-name="openpgp-link">Więcej informacji…</a>
        [few] Aby zaszyfrować, musisz uzyskać i zaakceptować nadające się klucze { $count } odbiorców. <a data-l10n-name="openpgp-link">Więcej informacji…</a>
       *[many] Aby zaszyfrować, musisz uzyskać i zaakceptować nadające się klucze { $count } odbiorców. <a data-l10n-name="openpgp-link">Więcej informacji…</a>
    }
openpgp-key-assistant-info-alias = { -brand-short-name } zwykle wymaga, aby klucz publiczny odbiorcy zawierał identyfikator użytkownika z pasującym adresem e-mail. Można to zmienić za pomocą reguł aliasów odbiorców OpenPGP. <a data-l10n-name="openpgp-link">Więcej informacji…</a>
# Variables:
# $count (Number) - The number of recipients that need attention.
openpgp-key-assistant-recipients-description =
    { $count ->
        [one] Masz już nadający się i zaakceptowany klucz jednego odbiorcy.
        [few] Masz już nadające się i zaakceptowane klucze { $count } odbiorców.
       *[many] Masz już nadające się i zaakceptowane klucze { $count } odbiorców.
    }
openpgp-key-assistant-recipients-description-no-issues = Ta wiadomość może zostać zaszyfrowana. Masz nadające się i zaakceptowane klucze wszystkich odbiorców.

## Resolve section

# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
# $numKeys (Number) - The number of keys.
openpgp-key-assistant-resolve-title =
    { $numKeys ->
        [one] { -brand-short-name } odnalazł następujący klucz odbiorcy { $recipient }.
       *[other] { -brand-short-name } odnalazł następujące klucze odbiorców { $recipient }.
    }
openpgp-key-assistant-valid-description = Wybierz klucz do zaakceptowania
# Variables:
# $numKeys (Number) - The number of available keys.
openpgp-key-assistant-invalid-title =
    { $numKeys ->
        [one] Poniższy klucz nie może być używany, chyba że zostanie zaktualizowany.
       *[other] Poniższe klucze nie mogą być używane, chyba że zostaną zaktualizowane.
    }
openpgp-key-assistant-no-key-available = Brak dostępnych kluczy.
openpgp-key-assistant-multiple-keys = Dostępny jest więcej niż jeden klucz.
# Variables:
# $count (Number) - The number of unaccepted keys.
openpgp-key-assistant-key-unaccepted =
    { $count ->
        [one] Dostępny jest klucz, ale nie został jeszcze zaakceptowany.
       *[other] Dostępny jest więcej niż jeden klucz, ale żaden z nich nie został jeszcze zaakceptowany.
    }
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-accepted-expired = Zaakceptowany klucz wygasł { $date }.
openpgp-key-assistant-keys-accepted-expired = Więcej niż jeden zaakceptowany klucz wygasł.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-this-key-accepted-expired = Ten klucz został wcześniej zaakceptowany, ale wygasł { $date }.
# Variables:
# $date (String) - The expiration date of the key.
openpgp-key-assistant-key-unaccepted-expired-one = Klucz wygasł { $date }.
openpgp-key-assistant-key-unaccepted-expired-many = Więcej niż jeden klucz wygasł.
openpgp-key-assistant-key-fingerprint = Odcisk klucza
openpgp-key-assistant-key-source =
    { $count ->
        [one] Źródło
       *[other] Źródła
    }
openpgp-key-assistant-key-collected-attachment = załącznik e-mail
openpgp-key-assistant-key-collected-autocrypt = nagłówek Autocrypt
openpgp-key-assistant-key-collected-keyserver = serwer kluczy
openpgp-key-assistant-key-collected-wkd = katalog kluczy
openpgp-key-assistant-keys-has-collected =
    { $count ->
        [one] Odnaleziono klucz, ale nie został on jeszcze zaakceptowany.
       *[other] Odnaleziono więcej niż jeden klucz, ale żaden z nich nie został jeszcze zaakceptowany.
    }
openpgp-key-assistant-key-rejected = Ten klucz został wcześniej odrzucony.
openpgp-key-assistant-key-accepted-other = Ten klucz został wcześniej zaakceptowany dla innego adresu e-mail.
# Variables:
# $recipient (String) - The email address of the recipient needing resolution.
openpgp-key-assistant-resolve-discover-info = Wykryj dodatkowe lub zaktualizowane klucze odbiorcy { $recipient } w Internecie lub zaimportuj je z pliku.

## Discovery section

openpgp-key-assistant-discover-title = Trwa wykrywanie w Internecie.
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-discover-keys = Wykrywanie kluczy odbiorcy { $recipient }…
# Variables:
# $recipient (String) - The email address which we're discovering keys.
openpgp-key-assistant-expired-key-update =
    Odnaleziono aktualizację jednego z wcześniej zaakceptowanych kluczy odbiorcy { $recipient }.
    Można go teraz używać, ponieważ nie wygasł.

## Dialog buttons

openpgp-key-assistant-discover-online-button = Wykryj klucze publiczne w Internecie…
openpgp-key-assistant-import-keys-button = Importuj klucze publiczne z pliku…
openpgp-key-assistant-issue-resolve-button = Rozwiąż…
openpgp-key-assistant-view-key-button = Wyświetl klucz…
openpgp-key-assistant-recipients-show-button = Wyświetl
openpgp-key-assistant-recipients-hide-button = Ukryj
openpgp-key-assistant-cancel-button = Anuluj
openpgp-key-assistant-back-button = Wstecz
openpgp-key-assistant-accept-button = Zaakceptuj
openpgp-key-assistant-close-button = Zamknij
openpgp-key-assistant-disable-button = Wyłącz szyfrowanie
openpgp-key-assistant-confirm-button = Wyślij zaszyfrowane
# Variables:
# $date (String) - The key creation date.
openpgp-key-assistant-key-created = utworzono { $date }
