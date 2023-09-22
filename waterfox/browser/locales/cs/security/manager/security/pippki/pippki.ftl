# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Kvalita hesla

## Change Password dialog

change-device-password-window =
    .title = Změna hesla
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Bezpečnostní zařízení: { $tokenName }
change-password-old = Současné heslo:
change-password-new = Nové heslo:
change-password-reenter = Nové heslo (znovu):
pippki-failed-pw-change = Heslo nelze změnit.
pippki-incorrect-pw = Nezadali jste správně stávající heslo. Zkuste to prosím znovu.
pippki-pw-change-ok = Heslo bylo úspěšně změněno.
pippki-pw-empty-warning = Vaše uložená hesla, data pro formuláře a soukromé klíče nebudou chráněny.
pippki-pw-erased-ok = Varování! Odstranili jste své heslo. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Varování! Přestali jste používat své heslo. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Momentálně jste v režimu FIPS, který vyžaduje neprázdné heslo.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Obnovení hlavního hesla
    .style = min-width: 40em
reset-password-button-label =
    .label = Obnovit
reset-primary-password-text = Pokud obnovíte hlavní heslo, všechna vaše uložená hesla z webových stránek a e-mailů, vyplněná data z formulářů, osobní certifikáty a klíče budou ztraceny. Chcete přesto hlavní heslo obnovit?
pippki-reset-password-confirmation-title = Obnovení hlavního hesla
pippki-reset-password-confirmation-message = Vaše hlavní heslo bylo obnoveno.

## Downloading cert dialog

download-cert-window2 =
    .title = Stažení certifikátu
    .style = min-width: 46em
download-cert-message = Byli jste požádáni o uznání nové Certifikační Autority (CA).
download-cert-trust-ssl =
    .label = Uznat tuto CA pro identifikaci serverů.
download-cert-trust-email =
    .label = Uznat tuto CA pro identifikaci uživatelů pošty.
download-cert-message-desc = Před uznáním této CA, a to pro jakýkoliv účel, byste měli prozkoumat její certifikát, její pravidla a podmínky (pokud jsou dostupné).
download-cert-view-cert =
    .label = Zobrazit
download-cert-view-text = Zobrazit certifikát CA

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Požadavek na identifikaci uživatele
client-auth-site-description = Tato stránka vyžaduje vaši identifikaci certifikátem:
client-auth-choose-cert = Vyberte certifikát, který vás identifikuje:
client-auth-send-no-certificate =
    .label = Neodesílat certifikát
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = Server “{ $hostname }” požaduje, abyste se identifikovali certifikátem:
client-auth-cert-details = Podrobnosti o vybraném certifikátu:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Vydáno pro: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Sériové číslo: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Platnost od { $notBefore } do { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Využívané klíče: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = E-mailové adresy: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Vydal: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Uloženo na: { $storedOn }
client-auth-cert-remember-box =
    .label = Zapamatovat si toto rozhodnutí

## Set password (p12) dialog

set-password-window =
    .title = Zvolte heslo zálohy certifikátu
set-password-message = Heslo zálohy certifikátu, které si zde nastavíte, chrání vaše soubory zálohy, kterou se chystáte vytvořit. Abyste mohli pokračovat dále, musíte toto heslo zadat.
set-password-backup-pw =
    .value = Heslo zálohy certifikátu:
set-password-repeat-backup-pw =
    .value = Heslo zálohy certifikátu (znovu):
set-password-reminder = Důležité: Pokud zapomenete svoje heslo zálohy certifikátu, nebude později možno tuto zálohu obnovit. Heslo si poznamenejte na BEZPEČNÉ místo.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Ověřte prosím token „{ $tokenName }“. Jak to udělat, závisí na tokenu (například pomocí čtečky otisků prstů nebo zadáním kódu pomocí klávesnice).
