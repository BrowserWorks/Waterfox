# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Miernik jakości hasła

## Change Password dialog

change-device-password-window =
    .title = Zmień hasło
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Urządzenie zabezpieczające: { $tokenName }
change-password-old = Bieżące hasło:
change-password-new = Nowe hasło:
change-password-reenter = Nowe hasło (ponownie):
pippki-failed-pw-change = Nie można zmienić hasła.
pippki-incorrect-pw = Nie podano właściwego hasła. Proszę spróbować ponownie.
pippki-pw-change-ok = Hasło zostało zmienione.
pippki-pw-empty-warning = Przechowywane hasła i klucze prywatne nie będą chronione.
pippki-pw-erased-ok = Usunięto hasło. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Uwaga! Hasło nie będzie używane. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Program pracuje obecnie w trybie FIPS. Tryb FIPS wymaga niepustego hasła.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Zresetuj hasło główne
    .style = min-width: 40em
reset-password-button-label =
    .label = Zresetuj
reset-primary-password-text = Po zresetowaniu hasła głównego wszystkie przechowywane hasła internetowe i hasła serwerów pocztowych, certyfikaty osobiste oraz prywatne klucze zostaną usunięte. Czy na pewno zresetować hasło główne?
pippki-reset-password-confirmation-title = Zresetuj hasło główne
pippki-reset-password-confirmation-message = Hasło główne zostało zresetowane.

## Downloading cert dialog

download-cert-window2 =
    .title = Pobieranie certyfikatu
    .style = min-width: 46em
download-cert-message = Otrzymano prośbę o dołączenie nowego organu certyfikacji do listy zaufanych organów.
download-cert-trust-ssl =
    .label = Zaufaj temu CA przy identyfikacji witryn internetowych.
download-cert-trust-email =
    .label = Zaufaj temu CA przy identyfikacji użytkowników poczty.
download-cert-message-desc = Jeżeli jest to możliwe, przed udzieleniem zgody należy zapoznać się z certyfikatem tego organu oraz jego polityką i stosowanymi procedurami.
download-cert-view-cert =
    .label = Wyświetl
download-cert-view-text = Sprawdź certyfikat CA

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Prośba o identyfikację użytkownika
client-auth-site-description = Ta witryna poprosiła o przedstawienia certyfikatu w celu dokonania identyfikacji:
client-auth-choose-cert = Wybierz certyfikat, który zostanie przedstawiony jako identyfikator użytkownika:
client-auth-send-no-certificate =
    .label = Nie wysyłaj certyfikatu
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = Witryna „{ $hostname }” poprosiła o przedstawienia certyfikatu w celu dokonania identyfikacji:
client-auth-cert-details = Szczegóły wybranego certyfikatu:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Wydany dla: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Numer seryjny: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Ważny od { $notBefore } do { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Zastosowania klucza: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = Adresy e-mail: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Wystawiony przez: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Przechowywany w: { $storedOn }
client-auth-cert-remember-box =
    .label = Pamiętaj decyzję

## Set password (p12) dialog

set-password-window =
    .title = Wybierz hasło kopii bezpieczeństwa certyfikatu
set-password-message = Wprowadzane hasło zabezpiecza tworzoną kopię certyfikatu. Utworzenie kopii certyfikatu bez podania hasła zabezpieczającego jest niemożliwe.
set-password-backup-pw =
    .value = Hasło kopii bezpieczeństwa certyfikatu:
set-password-repeat-backup-pw =
    .value = Hasło kopii bezpieczeństwa certyfikatu (ponownie):
set-password-reminder = Ważne: jeżeli hasło zabezpieczające kopię certyfikatu zostanie utracone, późniejsze odtworzenie certyfikatu będzie niemożliwe. Zaleca się zachowanie hasła w bezpiecznym miejscu.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Proszę uwierzytelnić się do tokenu „{ $tokenName }”. Metoda uwierzytelnienia zależy od tokenu (np. za pomocą czytnika linii papilarnych lub przez wpisanie kodu na specjalnej klawiaturze).
