# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Window controls

messenger-window-minimize-button =
    .tooltiptext = Minimizar
messenger-window-maximize-button =
    .tooltiptext = Maximizar
messenger-window-restore-down-button =
    .tooltiptext = Restaurar tamanho
messenger-window-close-button =
    .tooltiptext = Fechar
# Variables:
# $count (Number) - Number of unread messages.
unread-messages-os-tooltip =
    { $count ->
        [one] 1 mensagem não lida
       *[other] { $count } mensagens não lidas
    }
about-rights-notification-text = O { -brand-short-name } é um software livre e de código aberto, criado por uma comunidade de milhares de pessoas do mundo todo.

## Content tabs

content-tab-page-loading-icon =
    .alt = A página está carregando
content-tab-security-high-icon =
    .alt = A conexão é segura
content-tab-security-broken-icon =
    .alt = A conexão não é segura

## Toolbar

addons-and-themes-toolbarbutton =
    .label = Extensões e temas
    .tooltiptext = Gerenciar extensões e temas
quick-filter-toolbarbutton =
    .label = Filtro rápido
    .tooltiptext = Filtrar mensagens
redirect-msg-button =
    .label = Redirecionar
    .tooltiptext = Redirecionar mensagens selecionadas

## Folder Pane

folder-pane-toolbar =
    .toolbarname = Barra do painel de pastas
    .accesskey = p
folder-pane-toolbar-options-button =
    .tooltiptext = Opções do painel de pastas
folder-pane-header-label = Pastas

## Folder Toolbar Header Popup

folder-toolbar-hide-toolbar-toolbarbutton =
    .label = Ocultar barra de ferramentas
    .accesskey = O
show-all-folders-label =
    .label = Todas as pastas
    .accesskey = T
show-unread-folders-label =
    .label = Pastas não lidas
    .accesskey = n
show-favorite-folders-label =
    .label = Pastas favoritas
    .accesskey = f
show-smart-folders-label =
    .label = Pastas unificadas
    .accesskey = u
show-recent-folders-label =
    .label = Pastas recentes
    .accesskey = r
folder-toolbar-toggle-folder-compact-view =
    .label = Visão compacta
    .accesskey = c

## Menu

redirect-msg-menuitem =
    .label = Redirecionar
    .accesskey = d
menu-file-save-as-file =
    .label = Arquivo…
    .accesskey = A

## AppMenu

appmenu-save-as-file =
    .label = Arquivo…
appmenu-settings =
    .label = Configurações
appmenu-addons-and-themes =
    .label = Extensões e temas
appmenu-help-enter-troubleshoot-mode =
    .label = Modo de solução de problemas…
appmenu-help-exit-troubleshoot-mode =
    .label = Desativar modo de solução de problemas
appmenu-help-more-troubleshooting-info =
    .label = Informações técnicas
appmenu-redirect-msg =
    .label = Redirecionar

## Context menu

context-menu-redirect-msg =
    .label = Redirecionar
mail-context-delete-messages =
    .label =
        { $count ->
            [one] Excluir mensagem
           *[other] Excluir mensagens selecionadas
        }
context-menu-decrypt-to-folder =
    .label = Copiar como descriptografado para
    .accesskey = d

## Message header pane

other-action-redirect-msg =
    .label = Redirecionar
message-header-msg-flagged =
    .title = Com estrela
    .aria-label = Com estrela
message-header-msg-not-flagged =
    .title = Mensagem não marcada com estrela
# Variables:
# $address (String) - The email address of the recipient this picture belongs to.
message-header-recipient-avatar =
    .alt = Foto do perfil de { $address }.

## Message header cutomize panel

message-header-customize-panel-title = Configurações do cabeçalho de mensagens
message-header-customize-button-style =
    .value = Estilo de botões
    .accesskey = b
message-header-button-style-default =
    .label = Ícones e texto
message-header-button-style-text =
    .label = Texto
message-header-button-style-icons =
    .label = Ícones
message-header-show-sender-full-address =
    .label = Sempre mostrar o endereço completo do remetente
    .accesskey = c
message-header-show-sender-full-address-description = O endereço de email é exibido abaixo do nome de exibição.
message-header-show-recipient-avatar =
    .label = Mostrar foto de perfil do remetente
    .accesskey = p
message-header-hide-label-column =
    .label = Ocultar coluna de rótulos
    .accesskey = O
message-header-large-subject =
    .label = Campo de assunto grande
    .accesskey = s

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Gerenciar extensão
    .accesskey = e
toolbar-context-menu-remove-extension =
    .label = Remover extensão
    .accesskey = v

## Add-on removal warning

# Variables:
#  $name (String): The name of the addon that will be removed.
addon-removal-title = Remover { $name }?
addon-removal-confirmation-button = Remover
addon-removal-confirmation-message = Remover { $name } junto com suas configurações e dados do { -brand-short-name }?
caret-browsing-prompt-title = Navegação com cursor do teclado
caret-browsing-prompt-text = A tecla F7 ativa ou desativa a navegação com cursor do teclado. Este recurso coloca um cursor móvel em alguns conteúdos, permitindo selecionar texto usando o teclado. Quer ativar a navegação com cursor do teclado?
caret-browsing-prompt-check-text = Não perguntar novamente.
repair-text-encoding-button =
    .label = Reparar codificação de texto
    .tooltiptext = Estimar codificação de texto correta a partir do conteúdo da mensagem

## no-reply handling

no-reply-title = Sem suporte a resposta
no-reply-message = O endereço de resposta ({ $email }) parece não ser um endereço monitorado. Mensagens para este endereço provavelmente não serão lidas por ninguém.
no-reply-reply-anyway-button = Responder assim mesmo

## error messages

decrypt-and-copy-failures = { $failures } de { $total } mensagens não puderam ser descriptografadas e não foram copiadas.

## Spaces toolbar

spaces-toolbar-element =
    .toolbarname = Barra de áreas
    .aria-label = Barra de áreas
    .aria-description = Barra de ferramentas vertical para alternar entre áreas diferentes. Use as teclas de setas para navegar nos botões disponíveis.
spaces-toolbar-button-mail2 =
    .title = Email
spaces-toolbar-button-address-book2 =
    .title = Catálogo de endereços
spaces-toolbar-button-calendar2 =
    .title = Agenda
spaces-toolbar-button-tasks2 =
    .title = Tarefas
spaces-toolbar-button-chat2 =
    .title = Conversa
spaces-toolbar-button-overflow =
    .title = Mais áreas…
spaces-toolbar-button-settings2 =
    .title = Configurações
spaces-toolbar-button-hide =
    .title = Ocultar barra de áreas
spaces-toolbar-button-show =
    .title = Exibir barra de áreas
spaces-context-new-tab-item =
    .label = Abrir em nova aba
spaces-context-new-window-item =
    .label = Abrir em nova janela
# Variables:
# $tabName (String) - The name of the tab this item will switch to.
spaces-context-switch-tab-item =
    .label = Mudar para { $tabName }
settings-context-open-settings-item2 =
    .label = Configurações
settings-context-open-account-settings-item2 =
    .label = Configurações de contas
settings-context-open-addons-item2 =
    .label = Extensões e temas

## Spaces toolbar pinned tab menupopup

spaces-toolbar-pinned-tab-button =
    .tooltiptext = Menu de áreas
spaces-pinned-button-menuitem-mail =
    .label = { spaces-toolbar-button-mail.title }
spaces-pinned-button-menuitem-address-book =
    .label = { spaces-toolbar-button-address-book.title }
spaces-pinned-button-menuitem-calendar =
    .label = { spaces-toolbar-button-calendar.title }
spaces-pinned-button-menuitem-tasks =
    .label = { spaces-toolbar-button-tasks.title }
spaces-pinned-button-menuitem-chat =
    .label = { spaces-toolbar-button-chat.title }
spaces-pinned-button-menuitem-settings =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-mail2 =
    .label = { spaces-toolbar-button-mail2.title }
spaces-pinned-button-menuitem-address-book2 =
    .label = { spaces-toolbar-button-address-book2.title }
spaces-pinned-button-menuitem-calendar2 =
    .label = { spaces-toolbar-button-calendar2.title }
spaces-pinned-button-menuitem-tasks2 =
    .label = { spaces-toolbar-button-tasks2.title }
spaces-pinned-button-menuitem-chat2 =
    .label = { spaces-toolbar-button-chat2.title }
spaces-pinned-button-menuitem-settings2 =
    .label = { spaces-toolbar-button-settings2.title }
spaces-pinned-button-menuitem-show =
    .label = { spaces-toolbar-button-show.title }
# Variables:
# $count (Number) - Number of unread messages.
chat-button-unread-messages = { $count }
    .title =
        { $count ->
            [one] Uma mensagem não lida
           *[other] { $count } mensagens não lidas
        }

## Spaces toolbar customize panel

menuitem-customize-label =
    .label = Personalizar…
spaces-customize-panel-title = Configurações da barra de áreas
spaces-customize-background-color = Cor de fundo
spaces-customize-icon-color = Cor dos botões
# The background color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-background-color = Cor de fundo do botão selecionado
# The icon color used on the buttons of the spaces toolbar when they are
# `current`, meaning the related space/tab is active and visible.
spaces-customize-accent-text-color = Cor do botão selecionado
spaces-customize-button-restore = Restaurar padrão
    .accesskey = R
customize-panel-button-save = Pronto
    .accesskey = P
