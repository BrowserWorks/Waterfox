# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

password-quality-meter = Medidor de qualidade da senha

## Change Password dialog

change-device-password-window =
    .title = Alterar senha
# Variables:
# $tokenName (String) - Security device of the change password dialog
change-password-token = Dispositivo de segurança: { $tokenName }
change-password-old = Senha atual:
change-password-new = Nova senha:
change-password-reenter = Confirmar a nova senha:
pippki-failed-pw-change = Não foi possível alterar a senha.
pippki-incorrect-pw = Você não digitou corretamente a senha atual. Tente novamente.
pippki-pw-change-ok = Senha alterada com sucesso.
pippki-pw-empty-warning = Suas senhas e chaves privadas armazenadas não estarão protegidas.
pippki-pw-erased-ok = Você excluiu sua senha. { pippki-pw-empty-warning }
pippki-pw-not-wanted = Atenção! Você decidiu não usar uma senha. { pippki-pw-empty-warning }
pippki-pw-change2empty-in-fips-mode = Você está no momento no modo FIPS. O modo FIPS exige uma senha não vazia.

## Reset Primary Password dialog

reset-primary-password-window2 =
    .title = Redefinir senha principal
    .style = min-width: 40em
reset-password-button-label =
    .label = Redefinir
reset-primary-password-text = Se você redefinir a senha principal, todas as suas senhas de contas e emails, chaves privadas e certificados pessoais armazenados serão esquecidos. Tem certeza que quer redefinir sua senha principal?
pippki-reset-password-confirmation-title = Redefinir senha principal
pippki-reset-password-confirmation-message = Sua senha principal foi redefinida.

## Downloading cert dialog

download-cert-window2 =
    .title = Baixando certificado
    .style = min-width: 46em
download-cert-message = Você foi solicitado a marcar como confiável uma nova Autoridade Certificadora (CA).
download-cert-trust-ssl =
    .label = Confiar nesta CA para identificar sites.
download-cert-trust-email =
    .label = Confiar nesta autoridade certificadora para identificar usuários de email.
download-cert-message-desc = Antes de considerar confiável esta CA para algum fim, você deve examinar seu certificado, sua diretiva e procedimentos (se disponíveis).
download-cert-view-cert =
    .label = Ver
download-cert-view-text = Examinar certificado da CA

## Client Authorization Ask dialog


## Client Authentication Ask dialog

client-auth-window =
    .title = Solicitação de identificação do usuário
client-auth-site-description = Este site solicitou que você identifique-se com um certificado:
client-auth-choose-cert = Selecione um certificado para apresentar como identificação:
client-auth-send-no-certificate =
    .label = Não enviar um certificado
# Variables:
# $hostname (String) - The domain name of the site requesting the client authentication certificate
client-auth-site-identification = “{ $hostname }” solicitou que você identifique-se com um certificado:
client-auth-cert-details = Detalhes do certificado selecionado:
# Variables:
# $issuedTo (String) - The subject common name of the currently-selected client authentication certificate
client-auth-cert-details-issued-to = Emitido para: { $issuedTo }
# Variables:
# $serialNumber (String) - The serial number of the certificate (hexadecimal of the form "AA:BB:...")
client-auth-cert-details-serial-number = Número de série: { $serialNumber }
# Variables:
# $notBefore (String) - The date before which the certificate is not valid (e.g. Apr 21, 2023, 1:47:53 PM UTC)
# $notAfter (String) - The date after which the certificate is not valid
client-auth-cert-details-validity-period = Válido de { $notBefore } a { $notAfter }
# Variables:
# $keyUsages (String) - A list of already-localized key usages for which the certificate may be used
client-auth-cert-details-key-usages = Chaves usadas: { $keyUsages }
# Variables:
# $emailAddresses (String) - A list of email addresses present in the certificate
client-auth-cert-details-email-addresses = Endereços de email: { $emailAddresses }
# Variables:
# $issuedBy (String) - The issuer common name of the certificate
client-auth-cert-details-issued-by = Emitido por: { $issuedBy }
# Variables:
# $storedOn (String) - The name of the token holding the certificate (for example, "OS Client Cert Token (Modern)")
client-auth-cert-details-stored-on = Armazenado em: { $storedOn }
client-auth-cert-remember-box =
    .label = Memorizar esta decisão

## Set password (p12) dialog

set-password-window =
    .title = Escolha uma senha de backup do certificado
set-password-message = A senha de backup do certificado que você definir protege o arquivo backup que será criado. Você deve definir esta senha para prosseguir com o backup.
set-password-backup-pw =
    .value = Senha de backup do certificado:
set-password-repeat-backup-pw =
    .value = Senha de backup do certificado (confirmar):
set-password-reminder = Importante: Se você esquecer a senha do backup de certificados, não poderá restaurar esse backup mais tarde. Anote em um local seguro.

## Protected authentication alert

# Variables:
# $tokenName (String) - The name of the token to authenticate to (for example, "OS Client Cert Token (Modern)")
protected-auth-alert = Autentique-se no token “{ $tokenName }”. Como fazer isso depende do token (por exemplo, usando um leitor de impressão digital ou inserindo um código no teclado numérico).
