# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


# Addressing widget

#   $type (String) - the type of the addressing row
#   $count (Number) - the number of address pills currently present in the addressing row
address-input-type-aria-label =
    { $count ->
        [0] { $type }
        [one] { $type } com um endereço, utilize a tecla seta esquerda para focar o mesmo.
       *[other] { $type } com { $count } endereços, utilize a tecla seta esquerda para focar os mesmos.
    }

#   $email (String) - the email address
#   $count (Number) - the number of address pills currently present in the addressing row
pill-aria-label =
    { $count ->
        [one] { $email }: pressione Enter para editar, Eliminar para remover.
       *[other] { $email }, 1 de { $count }: pressione Enter para editar, Eliminar para remover.
    }

#   $email (String) - the email address
pill-tooltip-invalid-address = { $email } não é um endereço de e-mail válido

#   $email (String) - the email address
pill-tooltip-not-in-address-book = { $email } não está no seu livro de endereços

pill-action-edit =
    .label = Editar endereço
    .accesskey = e

pill-action-move-to =
    .label = Mover para Para
    .accesskey = p

pill-action-move-cc =
    .label = Mover para Cc
    .accesskey = c

pill-action-move-bcc =
    .label = Mover para Bcc
    .accesskey = B

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

menuitem-attach-files =
    .label = Ficheiro(s)...
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

context-menuitem-attach-files =
    .label = Anexar ficheiro(s)...
    .accesskey = F
    .acceltext = { ctrl-cmd-shift-pretty-prefix }{ trigger-attachment-picker-key }

#   $count (Number) - the number of attachments in the attachment bucket
attachment-bucket-count =
    .value =
        { $count ->
            [1] { $count } anexo
           *[other] { $count } anexos
        }
    .accesskey = x

expand-attachment-pane-tooltip =
    .tooltiptext = Mostrar o painel de anexos ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

collapse-attachment-pane-tooltip =
    .tooltiptext = Ocultar o painel de anexos ({ ctrl-cmd-shift-pretty-prefix }{ toggle-attachment-pane-key })

drop-file-label-attachment =
    { $count ->
        [one] Adicionar como anexo
       *[other] Adicionar como anexos
    }

drop-file-label-inline =
    { $count ->
        [one] Adicionar em linha
       *[other] Adicionar em linha
    }

# Reorder Attachment Panel

move-attachment-first-panel-button =
    .label = Mover para primeiro
move-attachment-left-panel-button =
    .label = Mover para a esquerda
move-attachment-right-panel-button =
    .label = Mover para a direita
move-attachment-last-panel-button =
    .label = Mover para o fim

button-return-receipt =
    .label = Recibo
    .tooltiptext = Solicitar um recibo de leitura para esta mensagem

# Encryption

# Addressing Area


many-public-recipients-bcc =
    .label = Utilize o Bcc
    .accesskey = B

many-public-recipients-ignore =
    .label = Manter os destinatários públicos
    .accesskey = p

## Notifications

## Editing

# Tools

