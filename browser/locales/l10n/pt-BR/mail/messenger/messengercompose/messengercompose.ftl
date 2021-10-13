# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

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

# Attachment widget

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
add-attachment-notification-reminder =
    .label = Adicionar anexo…
    .tooltiptext = { toolbar-button-add-attachment.tooltiptext }
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
#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } anexo
            [one] { $count } anexo
           *[other] { $count } anexos
        }
    .accesskey = x
expand-attachment-pane-tooltip =
    .tooltiptext = Exibir painel de anexos ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
collapse-attachment-pane-tooltip =
    .tooltiptext = Ocultar painel de anexos ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })
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

# Reorder Attachment Panel

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

# Encryption

message-to-be-signed-icon =
    .alt = Assinar mensagem
message-to-be-encrypted-icon =
    .alt = Criptografar mensagem

# Addressing Area

to-compose-address-row-label =
    .value = Para
#   $key (String) - the shortcut key for this field
to-compose-show-address-row-menuitem =
    .label = Campo { to-compose-address-row-label.value }
    .accesskey = P
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
to-compose-show-address-row-label =
    .value = { to-compose-address-row-label.value }
    .tooltiptext = Exibir campo { to-compose-address-row-label.value } ({ to-compose-show-address-row-menuitem.acceltext })
cc-compose-address-row-label =
    .value = Cc
#   $key (String) - the shortcut key for this field
cc-compose-show-address-row-menuitem =
    .label = Campo { cc-compose-address-row-label.value }
    .accesskey = C
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
cc-compose-show-address-row-label =
    .value = { cc-compose-address-row-label.value }
    .tooltiptext = Exibir campo { cc-compose-address-row-label.value } ({ cc-compose-show-address-row-menuitem.acceltext })
bcc-compose-address-row-label =
    .value = Cco
#   $key (String) - the shortcut key for this field
bcc-compose-show-address-row-menuitem =
    .label = Campo { bcc-compose-address-row-label.value }
    .accesskey = o
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ $key }
bcc-compose-show-address-row-label =
    .value = { bcc-compose-address-row-label.value }
    .tooltiptext = Exibir campo { bcc-compose-address-row-label.value } ({ bcc-compose-show-address-row-menuitem.acceltext })
#   $count (Number) - the count of addresses in the "To" and "Cc" fields.
many-public-recipients-info = Os { $count } destinatários em Para e Cc irão ver os endereços uns dos outros. Você pode evitar revelar destinatários usando Cco.
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
encrypted-bcc-warning = Ao enviar uma mensagem criptografada, destinatários em Cco não ficam totalmente ocultos. Todos os destinatários podem conseguir identificá-los.
encrypted-bcc-ignore-button = Entendi

## Editing


# Tools

compose-tool-button-remove-text-styling =
    .tooltiptext = Remover estilo de texto
