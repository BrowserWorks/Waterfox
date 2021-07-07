# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Indicador de qualidade da palavra-passe

## Change Password dialog

change-password-window =
    .title = Alterar palavra-passe mestra

change-device-password-window =
    .title = Alterar palavra-passe

# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Dispositivo de segurança: { $tokenName }
change-password-old = Palavra-passe atual:
change-password-new = Nova palavra-passe:
change-password-reenter = Nova palavra-passe (novamente):

## Reset Password dialog

reset-password-window =
    .title = Repor palavra-passe mestra
    .style = width: 40em

pippki-failed-pw-change = Não foi possível alterar a palavra-passe.
pippki-incorrect-pw = A palavra-passe que digitou não corresponde à palavra-passe principal atual. Por favor, tente novamente.
pippki-pw-change-ok = Palavra-passe alterada com sucesso.

pippki-pw-empty-warning = As suas palavras-passe armazenadas e chaves privadas não serão protegidas.
pippki-pw-erased-ok = Eliminou a sua palavra-passe. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Aviso! Decidiu não utilizar uma palavra-passe. { pippki-pw-empty-warning }

pippki-pw-change2empty-in-fips-mode = Atualmente, está no modo FIPS. Este modo requer uma palavra-passe não vazia.

## Reset Primary Password dialog

reset-primary-password-window =
    .title = Repor palavra-passe principal
    .style = width: 40em
reset-password-button-label =
    .label = Repor
reset-password-text = Se remover a palavra-passe mestra, todas as suas palavras-passe da Internet e e-mail, dados de formulários, certificados pessoais e chaves privadas guardadas serão esquecidas. Tem a certeza que pretende repor a palavra-passe mestra?

reset-primary-password-text = Se remover a sua palavra-passe principal, todas as suas palavras-passe da Internet e e-mail, certificados pessoais e chaves privadas guardadas serão esquecidas. Tem a certeza de que pretende repor a sua palavra-passe principal?

pippki-reset-password-confirmation-title = Repor palavra-passe principal
pippki-reset-password-confirmation-message = A sua palavra-passe principal foi reposta.

## Downloading cert dialog

download-cert-window =
    .title = A transferir certificado
    .style = width: 46em
download-cert-message = Foi-lhe pedido para confiar numa nova autoridade certificadora (CA).
download-cert-trust-ssl =
    .label = Confiar nesta entidade de certificação para identificar sites.
download-cert-trust-email =
    .label = Confiar nesta CA para identificar utilizadores de email.
download-cert-message-desc = Antes de confiar nesta CA para qualquer fim, deve examinar o seu certificado, a sua política e os seus procedimentos (se disponíveis).
download-cert-view-cert =
    .label = Ver
download-cert-view-text = Examinar certificado da CA

## Client Authorization Ask dialog

client-auth-window =
    .title = Pedido de identificação do utilizador
client-auth-site-description = Este site pediu que se identificasse com um certificado:
client-auth-choose-cert = Escolher um certificado para utilizar como identificação:
client-auth-cert-details = Detalhes do certificado selecionado:

## Set password (p12) dialog

set-password-window =
    .title = Escolha uma palavra-passe para a cópia do certificado
set-password-message = A palavra-passe para a cópia do certificado que definir aqui, protege o ficheiro com a cópia que está prestes a criar.  Tem de definir esta palavra-passe para prosseguir com a criação da cópia.
set-password-backup-pw =
    .value = Palavra-passe da cópia do certificado:
set-password-repeat-backup-pw =
    .value = Palavra-passe da cópia do certificado (novamente):
set-password-reminder = Importante: se esquecer a palavra-passe da cópia do seu certificado, não será possível restaurar esta cópia mais tarde.  Por favor guarde-a numa localização segura.

## Protected Auth dialog

protected-auth-window =
    .title = Autenticação por token protegido
protected-auth-msg = Por favor autentique o token. O método de autenticação depende do tipo do seu token.
protected-auth-token = Token:
