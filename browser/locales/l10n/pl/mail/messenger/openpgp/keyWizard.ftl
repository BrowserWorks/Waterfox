# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

#   $identity (String) - the email address of the currently selected identity
key-wizard-dialog-window =
    .title = Dodaj klucz osobisty OpenPGP dla { $identity }
key-wizard-button =
    .buttonlabelaccept = Kontynuuj
    .buttonlabelhelp = Wróć
key-wizard-warning = <b>Jeśli masz już klucz osobisty</b> dla tego adresu e-mail, zaimportuj go. W przeciwnym razie nie będziesz mieć dostępu do swoich archiwów zaszyfrowanych wiadomości, ani nie będziesz w stanie odczytać przychodzących zaszyfrowanych wiadomości e-mail od osób, które nadal używają Twojego istniejącego klucza.
key-wizard-learn-more = Więcej informacji
radio-create-key =
    .label = Utwórz nowy klucz OpenPGP
    .accesskey = n
radio-import-key =
    .label = Importuj istniejący klucz OpenPGP
    .accesskey = m
radio-gnupg-key =
    .label = Użyj klucza zewnętrznego przez GnuPG (np. z karty inteligentnej)
    .accesskey = U

## Generate key section

openpgp-generate-key-title = Wygeneruj klucz OpenPGP
openpgp-generate-key-info = <b>Generowanie klucza może zająć nawet kilka minut.</b> Nie wyłączaj aplikacji w trakcie generowania. Aktywne przeglądanie Internetu i wykonywanie działań intensywnie korzystających z dysku podczas generowania klucza uzupełni „pulę losowości” i przyspieszy ten proces. Po ukończeniu generowania zostanie wyświetlony komunikat.
openpgp-keygen-expiry-title = Ważność klucza
openpgp-keygen-expiry-description = Określ czas wygaśnięcia nowo utworzonego klucza. Możesz później zmienić datę, aby w razie potrzeby przedłużyć ten czas.
radio-keygen-expiry =
    .label = Klucz wygasa za
    .accesskey = w
radio-keygen-no-expiry =
    .label = Klucz nie wygasa
    .accesskey = n
openpgp-keygen-days-label =
    .label = dni
openpgp-keygen-months-label =
    .label = mies.
openpgp-keygen-years-label =
    .label = lat(a)
openpgp-keygen-advanced-title = Ustawienia zaawansowane
openpgp-keygen-advanced-description = Zaawansowane ustawienia klucza OpenPGP.
openpgp-keygen-keytype =
    .value = Typ klucza:
    .accesskey = T
openpgp-keygen-keysize =
    .value = Rozmiar klucza:
    .accesskey = R
openpgp-keygen-type-rsa =
    .label = RSA
openpgp-keygen-type-ecc =
    .label = ECC (krzywa eliptyczna)
openpgp-keygen-button = Wygeneruj klucz
openpgp-keygen-progress-title = Generowanie nowego klucza OpenPGP…
openpgp-keygen-import-progress-title = Importowanie kluczy OpenPGP…
openpgp-import-success = Pomyślnie zaimportowano klucze OpenPGP.
openpgp-import-success-title = Dokończ proces importu
openpgp-import-success-description = Aby zacząć używać zaimportowanego klucza OpenPGP do szyfrowania wiadomości e-mail, zamknij to okno i przejdź do ustawień konta, aby go wybrać.
openpgp-keygen-confirm =
    .label = Potwierdź
openpgp-keygen-dismiss =
    .label = Anuluj
openpgp-keygen-cancel =
    .label = Anuluj proces…
openpgp-keygen-import-complete =
    .label = Zamknij
    .accesskey = m
openpgp-keygen-missing-username = Dla bieżącego konta nie określono nazwy. Podaj wartość w polu „Imię i nazwisko” w ustawieniach konta.
openpgp-keygen-long-expiry = Nie można utworzyć klucza, który wygasa za więcej niż 100 lat.
openpgp-keygen-short-expiry = Klucz musi być ważny przez przynajmniej jeden dzień.
openpgp-keygen-ongoing = Generowanie klucza już trwa.
openpgp-keygen-error-core = Nie można zainicjować głównej usługi OpenPGP
openpgp-keygen-error-failed = Generowanie klucza OpenPGP nieoczekiwanie się nie powiodło
#   $identity (String) - the newly generate OpenPGP Key
openpgp-keygen-error-revocation = Pomyślnie utworzono klucz OpenPGP, ale uzyskanie unieważnienia klucza { $key } się nie powiodło
openpgp-keygen-abort-title = Przerwać generowanie klucza?
openpgp-keygen-abort = Obecnie trwa generowanie klucza OpenPGP. Czy na pewno je anulować?
#   $identity (String) - the name and email address of the currently selected identity
openpgp-key-confirm = Wygenerować publiczny klucz i tajny klucz dla „{ $identity }”?

## Import Key section

openpgp-import-key-title = Importuj istniejący klucz osobisty OpenPGP
openpgp-import-key-legend = Wybierz plik, w którym wcześniej wykonano kopię zapasową.
openpgp-import-key-description = Można zaimportować klucze osobiste utworzone za pomocą innego oprogramowania OpenPGP.
openpgp-import-key-info = Inne oprogramowanie może nazywać klucz osobisty inaczej, na przykład własny klucz, tajny klucz, klucz prywatny lub para kluczy.
#   $count (Number) - the number of keys found in the selected files
openpgp-import-key-list-amount =
    { $count ->
        [one] Thunderbird odnalazł jeden klucz, który można zaimportować.
        [few] Thunderbird odnalazł { $count } klucze, które można zaimportować.
       *[many] Thunderbird odnalazł { $count } kluczy, które można zaimportować.
    }
openpgp-import-key-list-description = Potwierdź, które klucze mają być traktowane jako klucze osobiste. Jako klucze osobiste należy używać wyłącznie kluczy, które utworzono samodzielnie i które noszą Twoją tożsamość. Możesz zmienić tę opcję później w oknie właściwości klucza.
openpgp-import-key-list-caption = Klucze oznaczone jako klucze osobiste będą wyświetlane w sekcji szyfrowania typu „end-to-end”. Pozostałe będą dostępne w menedżerze kluczy.
openpgp-passphrase-prompt-title = Wymagane jest hasło
#   $identity (String) - the id of the key being imported
openpgp-passphrase-prompt = Wprowadź hasło, aby odblokować ten klucz: { $key }
openpgp-import-key-button =
    .label = Wybierz plik do zaimportowania…
    .accesskey = W
import-key-file = Importuj plik klucza OpenPGP
import-key-personal-checkbox =
    .label = Traktuj ten klucz jako klucz osobisty
gnupg-file = Pliki GnuPG
import-error-file-size = <b>Błąd:</b> pliki większe niż 5 MB nie są obsługiwane.
#   $error (String) - the reported error from the failed key import method
import-error-failed = <b>Błąd:</b> zaimportowanie pliku się nie powiodło. { $error }
#   $error (String) - the reported error from the failed key import method
openpgp-import-keys-failed = <b>Błąd:</b> zaimportowanie kluczy się nie powiodło. { $error }
openpgp-import-identity-label = Tożsamość
openpgp-import-fingerprint-label = Odcisk klucza
openpgp-import-created-label = Utworzono
openpgp-import-bits-label = Bity
openpgp-import-key-props =
    .label = Właściwości klucza
    .accesskey = W

## External Key section

openpgp-external-key-title = Zewnętrzny klucz GnuPG
openpgp-external-key-description = Skonfiguruj zewnętrzny klucz GnuPG podając identyfikator klucza
openpgp-external-key-info = Ponadto musisz użyć menedżera kluczy do zaimportowania i zaakceptowania odpowiedniego klucza publicznego.
openpgp-external-key-warning = <b>Można skonfigurować tylko jeden zewnętrzny klucz GnuPG.</b> Poprzedni zostanie zastąpiony.
openpgp-save-external-button = Zapisz identyfikator klucza
openpgp-external-key-label = Identyfikator tajnego klucza:
openpgp-external-key-input =
    .placeholder = 123456789341298340
