# This Source Code Form is subject to the terms of the Waterfox Public
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

## Reset Password dialog

pippki-failed-pw-change = Nie można zmienić hasła.
pippki-incorrect-pw = Nie podano właściwego hasła. Proszę spróbować ponownie.
pippki-pw-change-ok = Hasło zostało zmienione.

pippki-pw-empty-warning = Przechowywane hasła i klucze prywatne nie będą chronione.
pippki-pw-erased-ok = Usunięto hasło. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Uwaga! Hasło nie będzie używane. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Program pracuje obecnie w trybie FIPS. Tryb FIPS wymaga niepustego hasła.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Zresetuj hasło główne
    .style = width: 40em
reset-password-button-label =
    .label = Zresetuj

reset-primary-password-text = Po zresetowaniu hasła głównego wszystkie przechowywane hasła internetowe i hasła serwerów pocztowych, certyfikaty osobiste oraz prywatne klucze zostaną usunięte. Czy na pewno zresetować hasło główne?

pippki-reset-password-confirmation-title = Zresetuj hasło główne
pippki-reset-password-confirmation-message = Hasło główne zostało zresetowane.

## Downloading cert dialog

download-cert-window =
    .title = Pobieranie certyfikatu
    .style = width: 46em
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

client-auth-window =
    .title = Zażądano identyfikacji użytkownika
client-auth-site-description = Pobierana strona wysłała żądanie przedstawienia certyfikatu w celu dokonania identyfikacji:
client-auth-choose-cert = Wybierz certyfikat, który zostanie przedstawiony jako identyfikator użytkownika:
client-auth-cert-details = Szczegóły wybranego certyfikatu:

## Set password (p12) dialog

set-password-window =
    .title = Wybierz hasło kopii bezpieczeństwa certyfikatu
set-password-message = Wprowadzane hasło zabezpiecza tworzoną kopię certyfikatu. Utworzenie kopii certyfikatu bez podania hasła zabezpieczającego jest niemożliwe.
set-password-backup-pw =
    .value = Hasło kopii bezpieczeństwa certyfikatu:
set-password-repeat-backup-pw =
    .value = Hasło kopii bezpieczeństwa certyfikatu (ponownie):
set-password-reminder = Ważne: jeżeli hasło zabezpieczające kopię certyfikatu zostanie utracone, późniejsze odtworzenie certyfikatu będzie niemożliwe. Zaleca się zachowanie hasła w bezpiecznym miejscu.

## Protected Auth dialog

protected-auth-window =
    .title = Uwierzytelnienie do chronionego tokenu
protected-auth-msg = Należy uwierzytelnić się do tokenu. Metoda uwierzytelnienia zależy od rodzaju tokenu.
protected-auth-token = Token:
