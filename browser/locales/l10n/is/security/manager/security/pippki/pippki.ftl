# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Gæðamæling lykilorðs

## Change Password dialog

change-password-window =
    .title = Breyta aðallykilorði

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Öryggistæki: { $tokenName }
change-password-old = Núverandi lykilorð:
change-password-new = Nýtt lykilorð:
change-password-reenter = Nýtt lykilorð (aftur):

## Reset Password dialog

reset-password-window =
    .title = Endurstilla aðallykilorð
    .style = width: 40em

## Reset Primary Password dialog

reset-password-button-label =
    .label = Endursetja
reset-password-text = Ef þú endurstillir aðallykilorðið, þá muntu missa öll geymd vef- og póstlykilorð, öll form gögn, öll skilríki, og alla einkalykla. Ertu viss um að þú viljir endurstilla aðallykilorðið?

## Downloading cert dialog

download-cert-window =
    .title = Hleð niður skilríki
    .style = width: 46em
download-cert-message = Þú ert beðinn um að treysta nýrri vottunarstöð (CA).
download-cert-trust-ssl =
    .label = Treysta CA til að auðkenna vefsvæði.
download-cert-trust-email =
    .label = Treysta CA til að auðkenna póst notendur.
download-cert-message-desc = Áður en þú treystir þessum CA fyrir einhverju, ættirðu að athuga skilríki þess, stefnur þess og aðferðir (ef til eru).
download-cert-view-cert =
    .label = Skoða
download-cert-view-text = Skoða CA skilríki

## Client Authorization Ask dialog

client-auth-window =
    .title = Beiðni um auðkenni notanda
client-auth-site-description = Þetta vefsvæði bað um að þú auðkennir þig með skilríki:
client-auth-choose-cert = Veldu skilríki til að sýna sem auðkenni:
client-auth-cert-details = Upplýsingar um valið skilríki:

## Set password (p12) dialog

set-password-window =
    .title = Veldu lykilorð öryggisafrits fyrir skilríki
set-password-message = Lykilorðið sem þú slærð hér inn verndar öryggisafritskrána sem verið er að fara að búa til.  Þú verður að slá inn lykilorð til að halda áfram með öryggisafritið.
set-password-backup-pw =
    .value = Lykilorð öryggisafrits:
set-password-repeat-backup-pw =
    .value = Lykilorð öryggisafrits (aftur):
set-password-reminder = Mikilvægt: Ef þú gleymir lykilorði öryggisafrits geturðu ekki endurheimt öryggisafritið seinna.  Vinsamlega geymið það öruggum stað.

## Protected Auth dialog

protected-auth-window =
    .title = Varin tóka sannvottun
protected-auth-msg = Vinsamlega auðkenndu þig með tóka. Hvernig auðkennt er fer eftir tegund tóka.
protected-auth-token = Lykill:
