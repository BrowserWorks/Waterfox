# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-setup-tab-title = Konfiguracja konta

## Header

account-setup-title = Konfiguracja istniejącego adresu e-mail
account-setup-description =
    Aby użyć obecnego adresu e-mail, wypełnij swoje dane logowania.<br/>
    { -brand-product-name } automatycznie wyszuka działającą i zalecaną konfigurację serwera.

## Form fields

account-setup-name-label = Imię i nazwisko
    .accesskey = I
# Note: "John Doe" is a multiple-use name that is used when the true name of a person is unknown. We use this fake name as an input placeholder. Translators should update this to reflect the placeholder name of their language/country.
account-setup-name-input =
    .placeholder = Jan Kowalski
account-setup-name-info-icon =
    .title = Twoje imię i nazwisko lub pseudonim, tak jak będą wyświetlane innym
account-setup-name-warning-icon =
    .title = Proszę podać imię i nazwisko lub pseudonim
account-setup-email-label = Adres e-mail
    .accesskey = s
account-setup-email-input =
    .placeholder = jan.kowalski@example.com
account-setup-email-info-icon =
    .title = Twój istniejący adres e-mail
account-setup-email-warning-icon =
    .title = Nieprawidłowy adres e-mail
account-setup-password-label = Hasło
    .accesskey = H
    .title = Opcjonalnie, zostanie użyte wyłącznie do sprawdzenia nazwy użytkownika
account-provisioner-button = Nowy adres e-mail
    .accesskey = N
account-setup-password-toggle =
    .title = Widoczne hasło
account-setup-remember-password = Zachowaj hasło
    .accesskey = Z
account-setup-exchange-label = Nazwa użytkownika
    .accesskey = N
#   YOURDOMAIN refers to the Windows domain in ActiveDirectory. yourusername refers to the user's account name in Windows.
account-setup-exchange-input =
    .placeholder = NAZWA-DOMENY\nazwa-użytkownika
#   Domain refers to the Windows domain in ActiveDirectory. We mean the user's login in Windows at the local corporate network.
account-setup-exchange-info-icon =
    .title = Nazwa użytkownika domeny

## Action buttons

account-setup-button-cancel = Anuluj
    .accesskey = A
account-setup-button-manual-config = Konfiguruj ręcznie
    .accesskey = o
account-setup-button-stop = Zatrzymaj
    .accesskey = m
account-setup-button-retest = Wykryj ponownie
    .accesskey = W
account-setup-button-continue = Kontynuuj
    .accesskey = K
account-setup-button-done = Gotowe
    .accesskey = G

## Notifications

account-setup-looking-up-settings = Wyszukiwanie konfiguracji…
account-setup-looking-up-settings-guess = Wyszukiwanie konfiguracji: odpytywanie typowych adresów serwerów…
account-setup-looking-up-settings-half-manual = Wyszukiwanie konfiguracji: testowanie serwera…
account-setup-looking-up-disk = Wyszukiwanie konfiguracji: w plikach instalacyjnych programu { -brand-short-name }…
account-setup-looking-up-isp = Wyszukiwanie konfiguracji: u dostawcy usługi pocztowej…
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-looking-up-db = Wyszukiwanie konfiguracji: w bazie danych Mozilli…
account-setup-looking-up-mx = Wyszukiwanie konfiguracji: w domenie poczty przychodzącej…
account-setup-looking-up-exchange = Wyszukiwanie konfiguracji: na serwerze Exchange…
account-setup-checking-password = Sprawdzanie hasła…
account-setup-installing-addon = Pobieranie i instalowanie dodatku…
account-setup-success-half-manual = Ustawienia znalezione w wyniku testowania wskazanego serwera:
account-setup-success-guess = Konfiguracja znaleziona poprzez odpytywanie typowych adresów serwerów.
account-setup-success-guess-offline = Program jest w trybie offline. Część konfiguracji została ustawiona na typowe wartości, należy jednak zweryfikować poprawność ustawień i uzupełnić konfigurację.
account-setup-success-password = Hasło poprawne
account-setup-success-addon = Pomyślnie zainstalowano dodatek
# Note: Do not translate or replace Mozilla. It stands for the public project mozilla.org, not Mozilla Corporation. The database is a generic, public domain facility usable by any client.
account-setup-success-settings-db = Konfiguracja znaleziona w bazie danych Mozilli.
account-setup-success-settings-disk = Konfiguracja znaleziona w plikach instalacyjnych programu { -brand-short-name }.
account-setup-success-settings-isp = Konfiguracja znaleziona u dostawcy usługi pocztowej.
# Note: Microsoft Exchange is a product name.
account-setup-success-settings-exchange = Konfiguracja znaleziona dla serwera Microsoft Exchange.

## Illustrations

account-setup-step1-image =
    .title = Początkowa konfiguracja
account-setup-step2-image =
    .title = Wczytywanie…
account-setup-step3-image =
    .title = Znaleziono konfigurację
account-setup-step4-image =
    .title = Błąd połączenia
account-setup-privacy-footnote = Dane logowania będą używane zgodnie z naszymi <a data-l10n-name="privacy-policy-link">zasadami ochrony prywatności</a> i będą przechowywane wyłącznie lokalnie na komputerze użytkownika.
account-setup-selection-help = Nie wiesz, co wybrać?
account-setup-selection-error = Potrzebujesz pomocy?
account-setup-documentation-help = Dokumentacja konfiguracji
account-setup-forum-help = Forum pomocy

## Results area

# Variables:
#  $count (Number) - Number of available protocols.
account-setup-results-area-title =
    { $count ->
        [one] Dostępna konfiguracja
       *[other] Dostępne konfiguracje
    }
# Note: IMAP is the name of a protocol.
account-setup-result-imap = IMAP
account-setup-result-imap-description = Foldery i poczta synchronizowane na serwerze
# Note: POP3 is the name of a protocol.
account-setup-result-pop = POP3
account-setup-result-pop-description = Foldery i poczta na komputerze
# Note: Exchange is the name of a product.
account-setup-result-exchange = Exchange
account-setup-result-exchange-description = Serwer Microsoft Exchange
account-setup-incoming-title = Serwer poczty przychodzącej
account-setup-outgoing-title = Serwer poczty wychodzącej
account-setup-username-title = Nazwa użytkownika
account-setup-exchange-title = Serwer
account-setup-result-smtp = SMTP
account-setup-result-no-encryption = Bez szyfrowania
account-setup-result-ssl = SSL/TLS
account-setup-result-starttls = STARTTLS
account-setup-result-outgoing-existing = Użyj skonfigurowanego wcześniej serwera poczty wychodzącej
# Variables:
#  $incoming (String): The email/username used to log into the incoming server
#  $outgoing (String): The email/username used to log into the outgoing server
account-setup-result-username-different = Nazwa użytkownika dla serwera poczty przychodzącej: { $incoming }, nazwa użytkownika dla serwera poczty wychodzącej: { $outgoing }

## Error messages

# Note: The reference to "janedoe" (Jane Doe) is the name of an example person. You will want to translate it to whatever example persons would be named in your language. In the example, AD is the name of the Windows domain, and this should usually not be translated.
account-setup-credentials-incomplete = Uwierzytelnienie się nie powiodło. Podane dane logowania są niepoprawne lub do zalogowania wymagana jest oddzielna nazwa użytkownika. Ta nazwa użytkownika to zwykle login do domeny Windows z lub bez domeny (np. alicja lub AD\\alicja).
account-setup-credentials-wrong = Uwierzytelnienie się nie powiodło. Sprawdź poprawność nazwy użytkownika i hasła.
account-setup-find-settings-failed = { -brand-short-name } nie znalazł ustawień konta.
account-setup-exchange-config-unverifiable = Konfiguracja nie mogła zostać zweryfikowana. Jeśli nazwa użytkownika i hasło są poprawne, to prawdopodobnie administrator serwera wyłączył wybraną konfigurację dla tego konta. Spróbuj wybrać inny protokół.

## Manual configuration area

account-setup-manual-config-title = Konfiguracja serwera
account-setup-incoming-server-legend = Serwer poczty przychodzącej
account-setup-protocol-label = Protokół:
protocol-imap-option = { account-setup-result-imap }
protocol-pop-option = { account-setup-result-pop }
protocol-exchange-option = { account-setup-result-exchange }
account-setup-hostname-label = Adres serwera:
account-setup-port-label = Port:
    .title = Wartość 0 spowoduje użycie automatycznego wykrywania
account-setup-auto-description = { -brand-short-name } spróbuje automatycznie wykryć wartości pól, które są puste.
account-setup-ssl-label = Bezpieczeństwo połączenia:
account-setup-outgoing-server-legend = Serwer poczty wychodzącej

## Incoming/Outgoing SSL Authentication options

ssl-autodetect-option = Wykryj
ssl-no-authentication-option = Bez uwierzytelniania
ssl-cleartext-password-option = Zwykłe hasło
ssl-encrypted-password-option = Szyfrowane hasło

## Incoming/Outgoing SSL options

ssl-noencryption-option = Bez szyfrowania
account-setup-auth-label = Metoda uwierzytelniania:
account-setup-username-label = Nazwa użytkownika:
account-setup-advanced-setup-button = Utwórz konto i edytuj jego ustawienia
    .accesskey = e

## Warning insecure server dialog

account-setup-insecure-title = Ostrzeżenie!
account-setup-insecure-incoming-title = Ustawienia poczty przychodzącej:
account-setup-insecure-outgoing-title = Ustawienia poczty wychodzącej:
# Variables:
#  $server (String): The name of the hostname of the server the user was trying to connect to.
account-setup-warning-cleartext = Serwer <b>{ $server }</b> nie obsługuje szyfrowania połączeń.
account-setup-warning-cleartext-details = Skonfigurowany serwer nie zapewnia szyfrowania połączeń, hasła i wszystkie inne dane będą przesyłane otwartym tekstem, co grozi ich przechwyceniem przez osoby trzecie.
account-setup-insecure-server-checkbox = Rozumiem ryzyko
    .accesskey = R
account-setup-insecure-description = { -brand-short-name } użyje dostarczonej konfiguracji dla tego konta, jednakże administrator lub operator usługi pocztowej powinien zostać powiadomiony o tych nieprawidłowych połączeniach. Więcej informacji na ten temat można znaleźć w <a data-l10n-name="thunderbird-faq-link">dokumencie FAQ Thunderbirda</a>.
insecure-dialog-cancel-button = Zmień ustawienia
    .accesskey = Z
insecure-dialog-confirm-button = Potwierdź
    .accesskey = P

## Warning Exchange confirmation dialog

# Variables:
#  $domain (String): The name of the server where the configuration was found, e.g. rackspace.com.
exchange-dialog-question = { -brand-short-name } znalazł informacje o konfiguracji tego konta w serwisie { $domain }. Czy chcesz kontynuować i wysłać swoje dane logowania?
exchange-dialog-confirm-button = Zaloguj się
exchange-dialog-cancel-button = Anuluj

## Alert dialogs

account-setup-creation-error-title = Błąd przy tworzeniu konta
account-setup-error-server-exists = Serwer poczty przychodzącej już istnieje.
account-setup-confirm-advanced-title = Potwierdź konfigurację zaawansowaną
account-setup-confirm-advanced-description = To okno zostanie zamknięte, a konto z obecnymi ustawieniami zostanie utworzone, nawet jeśli konfiguracja jest niepoprawna. Czy chcesz kontynuować?

## Addon installation section

account-setup-addon-install-title = Zainstaluj
account-setup-addon-install-intro = Dodatek dostarczany przez zewnętrznego producenta może umożliwić dostęp do konta pocztowego na tym serwerze:
account-setup-addon-no-protocol = Ten serwer poczty nie obsługuje otwartych protokołów. { account-setup-addon-install-intro }
