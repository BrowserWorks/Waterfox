# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Salasanan laadun mittari

## Change Password dialog

change-password-window =
    .title = Vaihda pääsalasana

change-device-password-window =
    .title = Vaihda salasana

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Turvallisuuslaite: { $tokenName }
change-password-old = Nykyinen salasana:
change-password-new = Uusi salasana:
change-password-reenter = Uusi salasana (uudestaan):

## Reset Password dialog

reset-password-window =
    .title = Poista pääsalasana
    .style = width: 40em

pippki-failed-pw-change = Salasanaa ei voitu vaihtaa.
pippki-incorrect-pw = Väärä salasana. Yritä uudestaan.
pippki-pw-change-ok = Salasana vaihdettiin onnistuneesti.

pippki-pw-empty-warning = Tallennettuja salasanoja ja salaisia avaimia ei suojata.
pippki-pw-erased-ok = Salasana poistettiin. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Varoitus! Olet ottanut salasanan pois käytöstä. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Olet parhaillaan FIPS-tilassa. FIPS edellyttää, että salasana ei ole tyhjä.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Nollaa pääsalasana
    .style = width: 40em
reset-password-button-label =
    .label = Poista
reset-password-text = Jos pääsalasana poistetaan, kaikki tallennetut sivusto- ja sähköpostisalasanat, lomaketiedot, henkilökohtaiset varmenteet ja salaiset avaimet unohdetaan. Poistetaanko pääsalasana?

reset-primary-password-text = Jos pääsalasana poistetaan, kaikki tallennetut sivusto- ja sähköpostisalasanat, henkilökohtaiset varmenteet ja salaiset avaimet unohdetaan. Poistetaanko pääsalasana?

pippki-reset-password-confirmation-title = Nollaa pääsalasana
pippki-reset-password-confirmation-message = Pääsalasanasi on nollattu.

## Downloading cert dialog

download-cert-window =
    .title = Ladataan varmennetta
    .style = width: 46em
download-cert-message = Aseta uuden varmentajan luotettavuus.
download-cert-trust-ssl =
    .label = Sivustojen todentajana.
download-cert-trust-email =
    .label = Sähköpostien lähettäjien todentajana.
download-cert-message-desc = Ennen kuin varmentaja lisätään yhdellekään luotettujen varmentajien listalle, tulisi sen varmenne, turvallisuuskäytännöt ja menettelytavat tarkistaa (jos ne ovat saatavilla).
download-cert-view-cert =
    .label = Näytä
download-cert-view-text = Tarkastele varmentajan varmennetta

## Client Authorization Ask dialog

client-auth-window =
    .title = Käyttäjän todentamispyyntö
client-auth-site-description = Sivusto pyytää sinua todentamaan itsesi varmenteella:
client-auth-choose-cert = Valitse todentavana esitettävä varmenne:
client-auth-cert-details = Valitun varmenteen yksityiskohdat:

## Set password (p12) dialog

set-password-window =
    .title = Valitse varmenteen varmuuskopion salasana
set-password-message = Varmenteen varmuuskopion salasana suojaa varmuuskopiota, jota ollaan luomassa. Salasana täytyy asettaa varmuuskopiolle.
set-password-backup-pw =
    .value = Varmenteen varmuuskopion salasana:
set-password-repeat-backup-pw =
    .value = Varmenteen varmuuskopion salasana (uudelleen):
set-password-reminder = Tärkeää: Jos varmenteen varmuuskopion salasana unohtuu, niin varmennetta ei voi palauttaa myöhemmin. Säilytä salasana turvallisessa paikassa.

## Protected Auth dialog

protected-auth-window =
    .title = Suojattu polettitodennus
protected-auth-msg = Todenna poletille. Todennustapa riippuu poletin tyypistä.
protected-auth-token = Poletti:
