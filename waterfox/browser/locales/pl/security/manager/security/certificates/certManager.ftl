# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

certmgr-title =
    .title = Menedżer certyfikatów

certmgr-tab-mine =
    .label = Użytkownik

certmgr-tab-remembered =
    .label = Decyzje uwierzytelniania

certmgr-tab-people =
    .label = Osoby

certmgr-tab-servers =
    .label = Serwery

certmgr-tab-ca =
    .label = Organy certyfikacji

certmgr-mine = Masz identyfikujące certyfikaty z następujących organizacji:
certmgr-remembered = Następujące certyfikaty są używane do identyfikowania użytkownika przez witryny:
certmgr-people = Masz certyfikaty, które identyfikują następujące osoby:
certmgr-server = Następujące wpisy identyfikują wyjątki błędów certyfikatów serwera:
certmgr-ca = Masz certyfikaty, które identyfikują następujące organy certyfikacji:

certmgr-edit-ca-cert2 =
    .title = Edycja ustawień zaufania certyfikatu CA
    .style = min-width: 40em;

certmgr-edit-cert-edit-trust = Ustawienia zaufania:

certmgr-edit-cert-trust-ssl =
    .label = certyfikat identyfikuje witryny

certmgr-edit-cert-trust-email =
    .label = certyfikat identyfikuje użytkowników poczty

certmgr-delete-cert2 =
    .title = Usuń certyfikat
    .style = min-width: 48em; min-height: 24em;

certmgr-cert-host =
    .label = Host

certmgr-cert-name =
    .label = Nazwa certyfikatu

certmgr-cert-server =
    .label = Serwer

certmgr-token-name =
    .label = Urządzenie zabezpieczające

certmgr-begins-label =
    .label = Ważny od dnia:

certmgr-expires-label =
    .label = Wygasa dnia

certmgr-email =
    .label = Adres e-mail

certmgr-serial =
    .label = Numer seryjny

certmgr-fingerprint-sha-256 =
    .label = Odcisk SHA-256

certmgr-view =
    .label = Wyświetl…
    .accesskey = W

certmgr-edit =
    .label = Edytuj ustawienia zaufania…
    .accesskey = d

certmgr-export =
    .label = Eksportuj…
    .accesskey = E

certmgr-delete =
    .label = Usuń…
    .accesskey = U

certmgr-delete-builtin =
    .label = Usuń lub przestań ufać…
    .accesskey = U

certmgr-backup =
    .label = Kopia zapasowa…
    .accesskey = K

certmgr-backup-all =
    .label = Kopia zapasowa wszystkich…
    .accesskey = o

certmgr-restore =
    .label = Importuj…
    .accesskey = m

certmgr-add-exception =
    .label = Dodaj wyjątek…
    .accesskey = o

exception-mgr =
    .title = Dodanie wyjątku bezpieczeństwa

exception-mgr-extra-button =
    .label = Potwierdź wyjątek bezpieczeństwa
    .accesskey = P

exception-mgr-supplemental-warning = Godne zaufania witryny, banki i inne witryny publiczne nie powinny tego żądać.

exception-mgr-cert-location-url =
    .value = Adres:

exception-mgr-cert-location-download =
    .label = Pobierz certyfikat
    .accesskey = b

exception-mgr-cert-status-view-cert =
    .label = Wyświetl…
    .accesskey = W

exception-mgr-permanent =
    .label = Zachowaj ten wyjątek na stałe
    .accesskey = Z

pk11-bad-password = Wprowadzone hasło tokenu jest nieprawidłowe.
pkcs12-decode-err = Dekodowanie pliku się nie powiodło. Plik nie jest w formacie PKCS #12, jest uszkodzony lub wprowadzone hasło jest nieprawidłowe.
pkcs12-unknown-err-restore = Nie udało się odtworzyć kopii bezpieczeństwa PKCS #12 z nieznanych powodów.
pkcs12-unknown-err-backup = Nie udało się utworzyć kopii bezpieczeństwa PKCS #12 z nieznanych powodów.
pkcs12-unknown-err = Operacja PKCS #12 się nie powiodła z nieznanych powodów.
pkcs12-info-no-smartcard-backup = Zachowanie kopii certyfikatu zapisanego w urządzeniu zabezpieczającym, jak np. inteligentna karta, jest niemożliwe.
pkcs12-dup-data = To urządzenie zabezpieczające ma już certyfikat oraz klucz prywatny.

## PKCS#12 file dialogs

choose-p12-backup-file-dialog = Nazwa pliku kopii zapasowej
file-browse-pkcs12-spec = Pliki PKCS12
choose-p12-restore-file-dialog = Plik certyfikatu do zaimportowania

## Import certificate(s) file dialog

file-browse-certificate-spec = Pliki certyfikatów
import-ca-certs-prompt = Wybierz plik zawierający certyfikat(y) CA do zaimportowania
import-email-cert-prompt = Wybierz plik zawierający certyfikat e-mail innej osoby do zaimportowania

## For editing certificates trust

# Variables:
#   $certName: the name of certificate
edit-trust-ca = Certyfikat „{ $certName }” reprezentuje organ certyfikacji.

## For Deleting Certificates

delete-user-cert-title =
    .title = Usuń własne certyfikaty
delete-user-cert-confirm = Czy na pewno usunąć wybrane certyfikaty?
delete-user-cert-impact = Usunięcie jednego z certyfikatów użytkownika spowoduje, że ponowne wykorzystanie go do potwierdzenia tożsamości użytkownika będzie niemożliwe.


delete-ssl-override-title =
    .title = Usuń wyjątek dotyczący certyfikatu serwera
delete-ssl-override-confirm = Czy na pewno usunąć ten wyjątek dotyczący certyfikatu serwera?
delete-ssl-override-impact = Jeżeli wyjątek dotyczący certyfikatu serwera zostanie usunięty, przywrócone zostaną zwykłe procedury bezpieczeństwa dla tego serwera, w tym wymóg stosowania przez niego poprawnego certyfikatu.

delete-ca-cert-title =
    .title = Usuń lub przestań ufać certyfikatom CA
delete-ca-cert-confirm = Zażądano usunięcia certyfikatów CA. Certyfikaty wbudowane przestaną być zaufane, co ma taki sam skutek. Czy na pewno usunąć lub przestać ufać wybranym certyfikatom CA?
delete-ca-cert-impact = Jeżeli certyfikat organu certyfikacji (CA) zostanie usunięty lub przestanie być zaufany, certyfikaty wydane przez ten CA nie będą uznawane przez program za zaufane.


delete-email-cert-title =
    .title = Usuń certyfikaty e-mail
delete-email-cert-confirm = Czy na pewno usunąć certyfikaty e-mail wybranych osób?
delete-email-cert-impact = Jeśli certyfikat e-mail danej osoby zostanie usunięty, nie będzie można do niej wysłać zaszyfrowanych wiadomości.

# Used for semi-uniquely representing a cert.
#
# Variables:
#   $serialNumber : the serial number of the cert in AA:BB:CC hex format.
cert-with-serial =
    .value = Certyfikat o numerze seryjnym { $serialNumber }

# Used to indicate that the user chose not to send a client authentication certificate to a server that requested one in a TLS handshake.
send-no-client-certificate = Nie wysyłaj certyfikatu klienta

# Used when no cert is stored for an override
no-cert-stored-for-override = (nieprzechowywany)

# When a certificate is unavailable (for example, it has been deleted or the token it exists on has been removed).
certificate-not-available = (niedostępny)

## Used to show whether an override is temporary or permanent

permanent-override = Na stałe
temporary-override = Tymczasowy

## Add Security Exception dialog

add-exception-branded-warning = Próba zmiany sposobu, w jaki { -brand-short-name } identyfikuje tę witrynę.
add-exception-invalid-header = Ta witryna próbuje zidentyfikować się przy użyciu nieprawidłowych informacji.
add-exception-domain-mismatch-short = Niewłaściwa witryna
add-exception-domain-mismatch-long = Certyfikat należy do innej witryny, co może wskazywać na podszywanie się pod stronę.
add-exception-expired-short = Informacje nieaktualne
add-exception-expired-long = Certyfikat nie jest obecnie aktualny. Mógł zostać zagubiony lub skradziony i może być wykorzystywany do podszywania się pod stronę.
add-exception-unverified-or-bad-signature-short = Tożsamość nieznana
add-exception-unverified-or-bad-signature-long = Certyfikat nie jest zaufany, ponieważ nie został zweryfikowany jako wystawiony przez zaufany organ przy użyciu bezpiecznego podpisu.
add-exception-valid-short = Certyfikat prawidłowy
add-exception-valid-long = Ta witryna dostarcza prawidłowych i zweryfikowanych informacji identyfikujących. Nie ma potrzeby dodawania wyjątku.
add-exception-checking-short = Sprawdzanie informacji
add-exception-checking-long = Próba identyfikacji witryny…
add-exception-no-cert-short = Brak dostępnych informacji
add-exception-no-cert-long = Nie udało się pobrać stanu identyfikacji tej witryny.

## Certificate export "Save as" and error dialogs

save-cert-as = Zapisz certyfikat do pliku
cert-format-base64 = Certyfikat X.509 (PEM)
cert-format-base64-chain = Certyfikat X.509 z łańcuchem (PEM)
cert-format-der = Certyfikat X.509 (DER)
cert-format-pkcs7 = Certyfikat X.509 (PKCS#7)
cert-format-pkcs7-chain = Certyfikat X.509 z łańcuchem (PKCS#7)
write-file-failure = Błąd zapisu pliku
