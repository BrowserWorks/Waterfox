# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

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

addons-and-themes-button =
    .label = Extensões e temas
    .tooltip = Gerenciar extensões
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
    .toolbarname = Barra de ferramentas do painel de pastas
    .accesskey = B
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

## AppMenu

# Since v89 we dropped the platforms distinction between Options or Preferences
# and consolidated everything with Preferences.
appmenu-preferences =
    .label = Preferências
appmenu-addons-and-themes =
    .label = Extensões e temas
appmenu-help-enter-troubleshoot-mode =
    .label = Modo de solução de problemas…
appmenu-help-exit-troubleshoot-mode =
    .label = Desativar modo de solução de problemas
appmenu-help-more-troubleshooting-info =
    .label = Mais informações para resolver problemas
appmenu-redirect-msg =
    .label = Redirecionar

## Context menu

context-menu-redirect-msg =
    .label = Redirecionar

## Message header pane

other-action-redirect-msg =
    .label = Redirecionar

## Action Button Context Menu

toolbar-context-menu-manage-extension =
    .label = Gerenciar extensão
    .accesskey = e
toolbar-context-menu-remove-extension =
    .label = Remover extensão
    .accesskey = v

## Message headers

message-header-address-in-address-book-icon =
    .alt = O endereço está no catálogo de endereços
message-header-address-not-in-address-book-icon =
    .alt = O endereço não está no catálogo de endereços

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
