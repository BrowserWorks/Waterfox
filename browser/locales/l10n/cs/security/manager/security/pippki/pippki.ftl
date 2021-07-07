# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Kvalita hesla

## Change Password dialog

change-password-window =
    .title = Změna hlavního hesla
change-device-password-window =
    .title = Změna hesla
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Bezpečnostní zařízení: { $tokenName }
change-password-old = Současné heslo:
change-password-new = Nové heslo:
change-password-reenter = Nové heslo (znovu):

## Reset Password dialog

reset-password-window =
    .title = Obnovení hlavního hesla
    .style = width: 40em
pippki-failed-pw-change = Heslo nelze změnit.
pippki-incorrect-pw = Nezadali jste správně stávající heslo. Zkuste to prosím znovu.
pippki-pw-change-ok = Heslo bylo úspěšně změněno.
pippki-pw-empty-warning = Vaše uložená hesla, data pro formuláře a soukromé klíče nebudou chráněny.
pippki-pw-erased-ok = Varování! Odstranili jste své heslo. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Varování! Přestali jste používat své heslo. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Momentálně jste v režimu FIPS, který vyžaduje neprázdné heslo.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Obnovení hlavního hesla
    .style = width: 40em
reset-password-button-label =
    .label = Obnovit
reset-password-text = Pokud obnovíte hlavní heslo, všechna vaše uložená hesla z webových stránek a e-mailů, vyplněná data z formulářů, osobní certifikáty a klíče budou ztraceny. Chcete přesto hlavní heslo obnovit?
reset-primary-password-text = Pokud obnovíte hlavní heslo, všechna vaše uložená hesla z webových stránek a e-mailů, vyplněná data z formulářů, osobní certifikáty a klíče budou ztraceny. Chcete přesto hlavní heslo obnovit?
pippki-reset-password-confirmation-title = Obnovení hlavního hesla
pippki-reset-password-confirmation-message = Vaše hlavní heslo bylo obnoveno.

## Downloading cert dialog

download-cert-window =
    .title = Stažení certifikátu
    .style = width: 46em
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

client-auth-window =
    .title = Požadavek na identifikaci uživatele
client-auth-site-description = Tato stránka vyžaduje vaši identifikaci certifikátem:
client-auth-choose-cert = Vyberte certifikát, který vás identifikuje:
client-auth-cert-details = Podrobnosti o vybraném certifikátu:

## Set password (p12) dialog

set-password-window =
    .title = Zvolte heslo zálohy certifikátu
set-password-message = Heslo zálohy certifikátu, které si zde nastavíte, chrání vaše soubory zálohy, kterou se chystáte vytvořit. Abyste mohli pokračovat dále, musíte toto heslo zadat.
set-password-backup-pw =
    .value = Heslo zálohy certifikátu:
set-password-repeat-backup-pw =
    .value = Heslo zálohy certifikátu (znovu):
set-password-reminder = Důležité: Pokud zapomenete svoje heslo zálohy certifikátu, nebude později možno tuto zálohu obnovit. Heslo si poznamenejte na BEZPEČNÉ místo.

## Protected Auth dialog

protected-auth-window =
    .title = Zabezpečený autentizační token
protected-auth-msg = Autentizujte se prosím k vašemu tokenu. Autentizační postup závisí na druhu vašeho tokenu.
protected-auth-token = Token:
