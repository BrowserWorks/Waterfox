# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Send Format

compose-send-format-menu =
    .label = Formato de envio
    .accesskey = F
compose-send-auto-menu-item =
    .label = Automático
    .accesskey = A
compose-send-both-menu-item =
    .label = Tanto HTML quanto texto simples
    .accesskey = T
compose-send-html-menu-item =
    .label = Apenas HTML
    .accesskey = H
compose-send-plain-menu-item =
    .label = Apenas texto simples
    .accesskey = x

## Addressing widget

#   $type (String) - the type of the addressing row
remove-address-row-button =
    .title = Remover o campo { $type }
#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } com um endereço, use a tecla de seta para esquerda para colocar o foco nele.
       *[other] { $type } com { $count } endereços, use a tecla de seta para esquerda para colocar o foco neles.
    }
#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: tecle Enter para editar, Del para remover.
       *[other] { $email }, 1 de { $count }: tecle Enter para editar, Del para remover.
    }
#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } não é um endereço de email válido
#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } não está no seu catálogo de endereços
pill-action-edit =
    .label = Editar endereço
    .accesskey = e
#   $type (String) - the type of the addressing row, e.g. Cc, Bcc, etc.
pill-action-select-all-sibling-pills =
    .label = Selecionar todos os endereços em { $type }
    .accesskey = t
pill-action-select-all-pills =
    .label = Selecionar todos os endereços
    .accesskey = t
pill-action-move-to =
    .label = Mover para Para
    .accesskey = P
pill-action-move-cc =
    .label = Mover para Cc
    .accesskey = c
pill-action-move-bcc =
    .label = Mover para Cco
    .accesskey = o
pill-action-expand-list =
    .label = Expandir lista
    .accesskey = x

## Attachment widget

ctrl-cmd-shift-pretty-prefix =
    { PLATFORM() ->
        [macos] ⇧ ⌘{ " " }
       *[other] Ctrl+Shift+
    }
trigger-attachment-picker-key = A
toggle-attachment-pane-key = M
menuitem-toggle-attachment-pane =
    .label = Painel de anexos
    .accesskey = x
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key }
toolbar-button-add-attachment =
    .label = Anexar
    .tooltiptext = Adicionar um anexo ({ ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key })
add-attachment-notification-reminder2 =
    .label = Adicionar anexo…
    .accesskey = A
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
menuitem-attach-files =
    .label = Arquivos…
    .accesskey = A
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
context-menuitem-attach-files =
    .label = Anexar arquivos…
    .accesskey = n
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }
# Note: Do not translate the term 'vCard'.
context-menuitem-attach-vcard =
    .label = Meu vCard
    .accesskey = C
context-menuitem-attach-openpgp-key =
    .label = Minha chave pública OpenPGP
    .accesskey = v
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count-value =
    { $count ->
        [1] { $count } anexo
       *[other] { $count } anexos
    }
attachment-area-show =
    .title = Exibir painel de anexos ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
attachment-area-hide =
    .title = Ocultar painel de anexos ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
drop-file-label-attachment =
    { $count ->
        [one] Adicionar como anexo
       *[other] Adicionar como anexos
    }
drop-file-label-inline =
    { $count ->
        [one] Inserir na mensagem
       *[other] Inserir na mensagem
    }

## Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Mover para ser o primeiro
move-attachment-left-panel-button =
    .label = Mover para esquerda
move-attachment-right-panel-button =
    .label = Mover para direita
move-attachment-last-panel-button =
    .label = Mover para ser o último
button-return-receipt =
    .label = Confirmação
    .tooltiptext = Solicitar uma confirmação de leitura desta mensagem

## Encryption

encryption-menu =
    .label = Segurança
    .accesskey = g
encryption-toggle =
    .label = Criptografar
    .tooltiptext = Usar criptografia de ponta a ponta nesta mensagem
encryption-options-openpgp =
    .label = OpenPGP
    .tooltiptext = Ver ou alterar configurações de criptografia OpenPGP
encryption-options-smime =
    .label = S/MIME
    .tooltiptext = Ver ou alterar configurações de criptografia S/MIME
signing-toggle =
    .label = Assinar
    .tooltiptext = Usar assinatura digital nesta mensagem
menu-openpgp =
    .label = OpenPGP
    .accesskey = O
menu-smime =
    .label = S/MIME
    .accesskey = S
menu-encrypt =
    .label = Criptografar
    .accesskey = C
menu-encrypt-subject =
    .label = Criptografar assunto
    .accesskey = s
menu-sign =
    .label = Assinar digitalmente
    .accesskey = i
menu-manage-keys =
    .label = Assistente de chaves
    .accesskey = A
menu-view-certificates =
    .label = Ver certificados de destinatários
    .accesskey = V
menu-open-key-manager =
    .label = Gerenciador de chaves
    .accesskey = G
openpgp-key-issue-notification-one = A criptografia de ponta a ponta requer a resolução de problemas de chave de { $addr }
openpgp-key-issue-notification-many = A criptografia de ponta a ponta requer a resolução de problemas de chave de { $count } destinatários.
smime-cert-issue-notification-one = A criptografia de ponta a ponta requer a resolução de problemas de certificado de { $addr }.
smime-cert-issue-notification-many = A criptografia de ponta a ponta requer a resolução de problemas de certificado de { $count } destinatários.
key-notification-disable-encryption =
    .label = Não criptografar
    .accesskey = N
    .tooltiptext = Desativar criptografia de ponta a ponta
key-notification-resolve =
    .label = Resolver…
    .accesskey = R
    .tooltiptext = Abrir o assistente de chaves OpenPGP
can-encrypt-smime-notification = É possível criptografia de ponta a ponta S/MIME.
can-encrypt-openpgp-notification = É possível criptografia de ponta a ponta OpenPGP.
can-e2e-encrypt-button =
    .label = Criptografar
    .accesskey = C

## Addressing Area

to-address-row-label =
    .value = Para
#   $key (String) - the shortcut key for this field
show-to-row-main-menuitem =
    .label = Campo Para
    .accesskey = P
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-to-row-button text.
show-to-row-extra-menuitem =
    .label = Para
    .accesskey = P
#   $key (String) - the shortcut key for this field
show-to-row-button = Para
    .title = Exibir o campo Para ({ ctrl-cmd-shift-pretty-prefix }{ $key })
cc-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
show-cc-row-main-menuitem =
    .label = Campo Cc
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-cc-row-button text.
show-cc-row-extra-menuitem =
    .label = Cc
    .accesskey = C
#   $key (String) - the shortcut key for this field
show-cc-row-button = Cc
    .title = Exibir campo Cc ({ ctrl-cmd-shift-pretty-prefix }{ $key })
bcc-address-row-label =
    .value = Cco
#   $key (String) - the shortcut key for this field
show-bcc-row-main-menuitem =
    .label = Campo Cco
    .accesskey = o
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
# No acceltext should be shown.
# The label should match the show-bcc-row-button text.
show-bcc-row-extra-menuitem =
    .label = Cco
    .accesskey = o
#   $key (String) - the shortcut key for this field
show-bcc-row-button = Cco
    .title = Exibir campo Cco ({ ctrl-cmd-shift-pretty-prefix }{ $key })
extra-address-rows-menu-button =
    .title = Outros campos de endereçamento a exibir
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-notice =
    { $count ->
        [one] Sua mensagem tem um destinatário público. Você pode evitar revelar destinatários usando Cco em vez de Para ou Cc.
       *[other] Os { $count } destinatários em Para e Cc irão ver os endereços uns dos outros. Você pode evitar revelar destinatários usando Cco.
    }
many-public-recipients-bcc =
    .label = Mudar para Cco (com cópia oculta)
    .accesskey = u
many-public-recipients-ignore =
    .label = Manter públicos os destinatários
    .accesskey = M
many-public-recipients-prompt-title = Destinatários públicos demais
#   $count (Number) - the count of addresses in the public recipients fields.
many-public-recipients-prompt-msg =
    { $count ->
        [one] Sua mensagem tem um destinatário público. Isso pode ser motivo de preocupação com privacidade. Você pode evitar movendo o destinatário de Para/Cc para Cco.
       *[other] Sua mensagem tem { $count } destinatários públicos, que poderão ver os endereços uns dos outros. Isso pode ser motivo de preocupação com privacidade. Você pode evitar revelar destinatários movendo de Para/Cc para Cco.
    }
many-public-recipients-prompt-cancel = Cancelar envio
many-public-recipients-prompt-send = Enviar assim mesmo

## Notifications

# Variables:
# $identity (string) - The name of the used identity, most likely an email address.
compose-missing-identity-warning = Não foi encontrada uma identidade única correspondente ao endereço do remetente. A mensagem será enviada usando o campo De atual e as configurações da identidade { $identity }.
encrypted-bcc-warning = Ao enviar uma mensagem criptografada, destinatários em Cco não ficam totalmente ocultos. Todos os destinatários podem conseguir identificar.
encrypted-bcc-ignore-button = Entendi

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Remover estilo de texto

## Filelink

# A text used in a tooltip of Filelink attachments, whose account has been
# removed or is unknown.
cloud-file-unknown-account-tooltip = Enviado para uma conta Filelink desconhecida.

# Placeholder file

# Title for the html placeholder file.
# $filename - name of the file
cloud-file-placeholder-title = { $filename } - Anexo online
# A text describing that the file was attached as a Filelink and can be downloaded
# from the link shown below.
# $filename - name of the file
cloud-file-placeholder-intro = O arquivo { $filename } foi anexado como um anexo online. Ele pode ser baixado a partir do link abaixo.

# Template

# A line of text describing how many uploaded files have been appended to this
# message. Emphasis should be on sharing as opposed to attaching. This item is
# used as a header to a list, hence the colon.
cloud-file-count-header =
    { $count ->
        [one] Vinculei { $count } arquivo a este email:
       *[other] Vinculei { $count } arquivos a este email:
    }
# A text used in a footer, instructing the reader where to find additional
# information about the used service provider.
# $link (string) - html a-tag for a link pointing to the web page of the provider
cloud-file-service-provider-footer-single = Saiba mais sobre o { $link }.
# A text used in a footer, instructing the reader where to find additional
# information about the used service providers. Links for the used providers are
# split into a comma separated list of the first n-1 providers and a single entry
# at the end.
# $firstLinks (string) - comma separated list of html a-tags pointing to web pages
#                        of the first n-1 used providers
# $lastLink (string) - html a-tag pointing the web page of the n-th used provider
cloud-file-service-provider-footer-multiple = Saiba mais sobre { $firstLinks } e { $lastLink }.
# Tooltip for an icon, indicating that the link is protected by a password.
cloud-file-tooltip-password-protected-link = Link protegido por senha
# Used in a list of stats about a specific file
# Service - the used service provider to host the file (Filelink Service: BOX.com)
# Size - the size of the file (Size: 4.2 MB)
# Link - the link to the file (Link: https://some.provider.com)
# Expiry Date - stating the date the link will expire (Expiry Date: 12.12.2022)
# Download Limit - stating the maximum allowed downloads, before the link becomes invalid
#                  (Download Limit: 6)
cloud-file-template-service-name = Serviço de anexo online:
cloud-file-template-size = Tamanho:
cloud-file-template-link = Link:
cloud-file-template-password-protected-link = Link protegido por senha:
cloud-file-template-expiry-date = Data de validade:
cloud-file-template-download-limit = Limite de downloads:

# Messages

# $provider (string) - name of the online storage service that reported the error
cloud-file-connection-error-title = Erro de conexão
cloud-file-connection-error = O { -brand-short-name } está offline. Não foi possível conectar com { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was uploaded and caused the error
cloud-file-upload-error-with-custom-message-title = Falha no envio de { $filename } para { $provider }
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-title = Erro ao renomear
cloud-file-rename-error = Houve um problema ao renomear { $filename } em { $provider }.
# $provider (string) - name of the online storage service that reported the error
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-rename-error-with-custom-message-title = Falha ao renomear { $filename } em { $provider }
# $provider (string) - name of the online storage service that reported the error
cloud-file-rename-not-supported = { $provider } não aceita renomear arquivos já enviados.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-attachment-error-title = Erro ao anexar em anexo online
cloud-file-attachment-error = Falha ao atualizar o anexo online { $filename } porque seu arquivo local foi movido ou excluído.
# $filename (string) - name of the file that was renamed and caused the error
cloud-file-account-error-title = Erro de conta de anexo online
cloud-file-account-error = Falha ao atualizar o anexo online { $filename } porque sua conta de anexo online foi excluída.

## Link Preview

link-preview-title = Visualização de links
link-preview-description = O { -brand-short-name } pode adicionar uma visualização incorporada ao colar links.
link-preview-autoadd = Adicionar automaticamente visualização de links quando possível
link-preview-replace-now = Adicionar uma visualização deste link?
link-preview-yes-replace = Sim

## Dictionary selection popup

spell-add-dictionaries =
    .label = Adicionar dicionários…
    .accesskey = A
