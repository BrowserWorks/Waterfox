# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Pangsukat ng kalidad ng password

## Change Password dialog

change-password-window =
    .title = Palitan ang Master Password
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Security Device: { $tokenName }
change-password-old = Kasalukuyang password:
change-password-new = Bagong password:
change-password-reenter = Bagong password (ulit):

## Reset Password dialog

reset-password-window =
    .title = Ireset ang Master Password
    .style = width: 40em

## Reset Primary Password dialog

reset-primary-password-window =
    .title = I-reset ang Primary Password
    .style = width: 40em
reset-password-button-label =
    .label = I-reset
reset-password-text = Pag nireset mo ang master password, makakalimutan lahat ng nakatagong web at email passwords, form data, personal certificates, at private keys. Gusto mo ba talagang ireset ang master password mo?

## Downloading cert dialog

download-cert-window =
    .title = Kinukuha ang Sertipiko
    .style = width: 46em
download-cert-message = Pinapakiusapan kang pagkatiwalaan ang isang bagong Certificate Authority (CA).
download-cert-trust-ssl =
    .label = Pagkatiwalaan ang CA na ito para matukoy ang mga website.
download-cert-trust-email =
    .label = Pagkatiwalaan ang CA na ito para matukoy ang mga email user.
download-cert-message-desc = Bago ng magtiwala dito sa  CA  para sa anumang layunin, dapat mong suriin ang sertipiko at ang patakaran at pamamaraan (kung kinakailangan).
download-cert-view-cert =
    .label = Tingnan
download-cert-view-text = Suriin ang CA certificate

## Client Authorization Ask dialog

client-auth-window =
    .title = User Identification Request
client-auth-site-description = Ang site na ito ay humiling sa iyo na makilala ang iyong sarili sa isang sertipiko:
client-auth-choose-cert = Pumili ng certificate na maipapakita bilang pagkakakilanlan:
client-auth-cert-details = Mga detalye ng piniling certificate:

## Set password (p12) dialog

set-password-window =
    .title = Pumili ng Certificate Backup Password
set-password-message = Poprotektahan ng certificate backup password ang backup file na gagawin mo. Kailangan mong magset ng password para magpatuloy sa pagbackup.
set-password-backup-pw =
    .value = Certificate backup password:
set-password-repeat-backup-pw =
    .value = Certificate backup password (pakiulit):
set-password-reminder = Mahalaga: Kung nakalimutan mo ang iyong password sa backup certificate, hindi mo magagawang ibalik ang backup na ito mamaya. Paki-record ang mga ito sa isang ligtas na lokasyon.

## Protected Auth dialog

protected-auth-window =
    .title = Protected Token Authentication
protected-auth-msg = Paki-authenticate sa token. Nagdedepende ang authentication method sa uri ng iyong token.
protected-auth-token = Token:
