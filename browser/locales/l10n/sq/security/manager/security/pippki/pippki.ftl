# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Matës cilësie fjalëkalimesh

## Change Password dialog

change-password-window =
    .title = Ndryshoni Fjalëkalimin e Përgjithshëm
change-device-password-window =
    .title = Ndryshoni Fjalëkalimin
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Pajisje Sigurie: { $tokenName }
change-password-old = Fjalëkalimi i tanishëm:
change-password-new = Fjalëkalimi i ri:
change-password-reenter = Fjalëkalimi i ri (sërish):

## Reset Password dialog

reset-password-window =
    .title = Ricaktoni Fjalëkalimin e Përgjithshëm
    .style = width: 40em
pippki-failed-pw-change = S’arrihet të ndryshohet fjalëkalimi.
pippki-incorrect-pw = S’dhatë fjalëkalimin e saktë të tanishëm. Ju lutemi, riprovoni.
pippki-pw-change-ok = Fjalëkalimi u ndryshua me sukses!
pippki-pw-empty-warning = Fjalëkalimet dhe kyçet tuaj privatë të ruajtur s’do të mbrohen.
pippki-pw-erased-ok = Keni fshirë fjalëkalimin tuaj. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Kujdes! Keni vendosur të mos përdorni fjalëkalim. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Gjendeni nën mënyrën FIPS. FIPS lyp një fjalëkalim jo të zbrazët.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Ricaktoni Fjalëkalimin e Përgjithshëm
    .style = width: 40em
reset-password-button-label =
    .label = Riktheje te parazgjedhjet
reset-password-text = Nëse ricaktoni fjalëkalimin tuaj të përgjithshëm, tërë fjalëkalimet tuaj të ruajtur për web dhe email, të dhëna formularësh, dëshmi vetjake, dhe kyçe private do të harrohen. Jeni i sigurt se doni të ricaktoni fjalëkalimin tuaj të përgjithshëm?
reset-primary-password-text = Nëse ricaktoni Fjalëkalimin tuaj të Përgjithshëm, tërë fjalëkalimet tuaj të ruajtur për web dhe email, dëshmi vetjake, dhe kyçe privatë, do të harrohen. Jeni i sigurt se doni të ricaktoni Fjalëkalimin tuaj të Përgjithshëm?
pippki-reset-password-confirmation-title = Ricaktoni Fjalëkalimin e Përgjithshëm
pippki-reset-password-confirmation-message = Fjalëkalimi juaj I Përgjithshëm u ricaktua.

## Downloading cert dialog

download-cert-window =
    .title = Shkarkim Dëshmie
    .style = width: 46em
download-cert-message = Ju është kërkuar të besoni një Autoritet të ri Dëshmish (AD).
download-cert-trust-ssl =
    .label = Beso këtë AD në identifikim sajtesh.
download-cert-trust-email =
    .label = Beso këtë AD për identifikim përdoruesish email.
download-cert-message-desc = Para se të besohet ky AD për çfarëdo qëllimi, duhet të shqyrtoni dëshminë e tij dhe rregullat e procedurat (nëse janë të mundshme).
download-cert-view-cert =
    .label = Shfaqje
download-cert-view-text = Shqyrtoni dëshmi AD-je

## Client Authorization Ask dialog

client-auth-window =
    .title = Kërkesë Identifikimi Përdoruesi
client-auth-site-description = Ky sajt ka kërkuar që të identifikoni vetveten përmes një dëshmie:
client-auth-choose-cert = Zgjidhni një dëshmi për ta paraqitur si identifikim:
client-auth-cert-details = Hollësi të dëshmisë së përzgjedhur:

## Set password (p12) dialog

set-password-window =
    .title = Zgjidhni një Fjalëkalim Kopjeruajtjeje Dëshmish
set-password-message = Fjalëkalimi për kopjeruajtje dëshmish që caktoni këtu, mbron kartelën kopjeruajtje që jeni duke krijuar. Duhet të caktoni këtë fjalëkalim për të vazhduar më tej me kopjeruajtjen.
set-password-backup-pw =
    .value = Fjalëkalim kopjeruajtjeje dëshmish:
set-password-repeat-backup-pw =
    .value = Fjalëkalim kopjeruajtjeje dëshmish (sërish):
set-password-reminder = E rëndësishme: Nëse harroni fjalëkalim kopjeruajtjeje dëshmish, nuk do të jeni në gjendje të riktheni më vonë këtë kopjeruajtje. Ju lutemi, regjistrojeni në një vend të parrezik.

## Protected Auth dialog

protected-auth-window =
    .title = Mirëfilltësim me Token të Mbrojtur
protected-auth-msg = Ju lutemi, kryeni mirëfilltësimin kundrejt tokenit. Metoda e mirëfilltësimit varet nga lloji i tokenit tuaj.
protected-auth-token = Token:
