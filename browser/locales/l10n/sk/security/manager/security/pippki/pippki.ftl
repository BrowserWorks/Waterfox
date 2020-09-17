# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Ukazovateľ kvality hesla:

## Change Password dialog

change-password-window =
    .title = Zmena hlavného hesla

change-device-password-window =
    .title = Zmena hesla

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Bezpečnostné zariadenie: { $tokenName }
change-password-old = Aktuálne heslo:
change-password-new = Nové heslo:
change-password-reenter = Nové heslo (znova):

## Reset Password dialog

reset-password-window =
    .title = Vymazať hlavné heslo
    .style = width: 40em

pippki-failed-pw-change = Nie je možné zmeniť heslo.
pippki-incorrect-pw = Aktuálne heslo nebolo zadané správne. Skúste to znova.
pippki-pw-change-ok = Heslo bolo úspešne zmenené.

pippki-pw-empty-warning = Uložené heslá a súkromné kľúče nebudú chránené.
pippki-pw-erased-ok = Odstránili ste svoje heslo. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Upozornenie! Rozhodli ste sa nepoužívať heslo. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Momentálne používate režim FIPS. Tento režim vyžaduje nastavenie hesla.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Obnoviť hlavné heslo
    .style = width: 40em
reset-password-button-label =
    .label = Obnoviť
reset-password-text = Ak obnovíte svoje hlavné heslo, všetky uložené heslá, údaje formulárov, osobné certifikáty a súkromné kľúče budú vymazané. Naozaj chcete obnoviť svoje hlavné heslo?

reset-primary-password-text = Ak obnovíte svoje hlavné heslo, všetky uložené heslá, údaje formulárov, osobné certifikáty a súkromné kľúče budú vymazané. Naozaj chcete obnoviť svoje hlavné heslo?

pippki-reset-password-confirmation-title = Obnoviť hlavné heslo
pippki-reset-password-confirmation-message = Vaše hlavné heslo bolo obnovené.

## Downloading cert dialog

download-cert-window =
    .title = Preberá sa certifikát
    .style = width: 46em
download-cert-message = Vyžaduje sa dôverovať novej certifikačnej autorite.
download-cert-trust-ssl =
    .label = Dôverovať tejto certifikačnej autorite pri identifikácii serverov.
download-cert-trust-email =
    .label = Dôverovať tejto certifikačnej autorite pri identifikácii používateľov e-mailu.
download-cert-message-desc = Predtým, než sa rozhodnete dôverovať tejto CA pre akýkoľvek účel, mali by ste preskúmať jej certifikát, politiku a procedúry (ak sú k dispozícii).
download-cert-view-cert =
    .label = Zobraziť
download-cert-view-text = Preskúmať certifikát certifikačnej agentúry

## Client Authorization Ask dialog

client-auth-window =
    .title = Požiadavka na identifikáciu používateľa
client-auth-site-description = Tento server požaduje, aby ste sa identifikovali certifikátom:
client-auth-choose-cert = Vyberte certifikát, ktorý sa použije ako identifikácia:
client-auth-cert-details = Podrobnosti vybraného certifikátu:

## Set password (p12) dialog

set-password-window =
    .title = Vyberte heslo pre zálohu certifikátov
set-password-message = Heslo, ktoré tu nastavíte, bude chrániť záložný súbor, ktorý sa chystáte vytvoriť. Toto heslo je povinné.
set-password-backup-pw =
    .value = Heslo pre zálohu certifikátov
set-password-repeat-backup-pw =
    .value = Heslo pre zálohu certifikátov (znova)
set-password-reminder = Dôležité: ak zabudnete heslo pre zálohu certifikátov, nebude možné neskôr obnoviť túto zálohu. Uložte toto heslo na bezpečné miesto.

## Protected Auth dialog

protected-auth-window =
    .title = Overenie chráneného tokenu
protected-auth-msg = Overte token. Spôsob overenia závisí od typu tokenu.
protected-auth-token = Token:
