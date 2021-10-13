# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

openpgp-manage-keys-openpgp-cmd =
    .label = Gerenciador de chaves OpenPGP
    .accesskey = O

openpgp-ctx-decrypt-open =
    .label = Descriptografar e abrir
    .accesskey = D
openpgp-ctx-decrypt-save =
    .label = Descriptografar e salvar como…
    .accesskey = c
openpgp-ctx-import-key =
    .label = Importar chave OpenPGP
    .accesskey = I
openpgp-ctx-verify-att =
    .label = Verificar assinatura
    .accesskey = V

openpgp-has-sender-key = Esta mensagem alega conter a chave pública OpenPGP do remetente.
openpgp-be-careful-new-key = Aviso: A nova chave pública OpenPGP desta mensagem difere das chaves públicas que você aceitou anteriormente de { $email }.

openpgp-import-sender-key =
    .label = Importar…

openpgp-search-keys-openpgp =
    .label = Descobrir chave OpenPGP

openpgp-missing-signature-key = Esta mensagem foi assinada com uma chave que você ainda não tem.

openpgp-search-signature-key =
    .label = Descobrir…

# Don't translate the terms "OpenPGP" and "MS-Exchange"
openpgp-broken-exchange-opened = Esta é uma mensagem OpenPGP que foi aparentemente corrompida pelo MS-Exchange e não pode ser reparada porque foi aberta a partir de um arquivo local. Copie a mensagem para uma pasta de email para tentar um reparo automático.
openpgp-broken-exchange-info = Esta é uma mensagem OpenPGP que aparentemente foi corrompida pelo MS-Exchange. Se o conteúdo da mensagem não for exibido conforme o esperado, você pode tentar um reparo automático.
openpgp-broken-exchange-repair =
    .label = Reparar mensagem
openpgp-broken-exchange-wait = Aguarde…

openpgp-cannot-decrypt-because-mdc =
    Esta é uma mensagem criptografada que usa um mecanismo antigo e vulnerável.
    Pode ter sido modificado enquanto estava em trânsito, com a intenção de roubar seu conteúdo.
    Para evitar esse risco, o conteúdo não é exibido.

openpgp-cannot-decrypt-because-missing-key = A chave secreta necessária para descriptografar esta mensagem não está disponível.

openpgp-partially-signed =
    Somente um subconjunto desta mensagem foi assinado digitalmente usando OpenPGP.
    Se você clicar no botão de verificar, as partes desprotegidas serão ocultadas e o status da assinatura digital será exibido.

openpgp-partially-encrypted =
    Apenas um subconjunto desta mensagem foi criptografado usando OpenPGP.
    As partes legíveis da mensagem que já estão exibidas não foram criptografadas.
    Se você clicar no botão de descriptografar, o conteúdo das partes criptografadas será exibido.

openpgp-reminder-partial-display = Lembrete: A mensagem exibida abaixo é apenas um subconjunto da mensagem original.

openpgp-partial-verify-button = Verificar
openpgp-partial-decrypt-button = Descriptografar

