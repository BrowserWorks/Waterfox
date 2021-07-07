# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Diga olá a um novo { -brand-short-name }
upgrade-dialog-new-subtitle = Projetado para te levar onde você quiser, mais rápido
upgrade-dialog-new-item-menu-title = Menus e barra de ferramentas simplificados
upgrade-dialog-new-item-menu-description = Prioriza as coisas importantes para você encontrar o que precisa.
upgrade-dialog-new-item-tabs-title = Abas modernas
upgrade-dialog-new-item-tabs-description = Contêm informações de forma organizada, aceitando foco e movimento flexível.
upgrade-dialog-new-item-icons-title = Novos ícones e mensagens mais claras
upgrade-dialog-new-item-icons-description = Ajuda a encontrar as coisas com um toque mais leve.
upgrade-dialog-new-primary-default-button = Tornar o { -brand-short-name } meu navegador padrão
upgrade-dialog-new-primary-theme-button = Escolha um tema
upgrade-dialog-new-secondary-button = Agora não
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Ok, entendi

## Pin Waterfox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Manter o { -brand-short-name } no Dock
       *[other] Fixar o { -brand-short-name } na barra de tarefas
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Ainda tem acesso fácil ao { -brand-short-name } mais recente.
       *[other] Ainda mantém o { -brand-short-name } mais recente ao alcance.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Manter no Dock
       *[other] Fixar na barra de tarefas
    }
upgrade-dialog-pin-secondary-button = Agora não

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Tornar o { -brand-short-name } o navegador padrão
upgrade-dialog-default-subtitle-2 = Tenha velocidade, segurança e privacidade automaticamente.
upgrade-dialog-default-primary-button-2 = Definir como navegador padrão
upgrade-dialog-default-secondary-button = Agora não

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Experimente um tema nítido
upgrade-dialog-theme-system = Tema do sistema
    .title = Seguir o tema do sistema operacional em botões, menus e janelas

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = Vida em cores
upgrade-dialog-start-subtitle = Novos esquemas vibrantes de cores. Disponíveis por tempo limitado.
upgrade-dialog-start-primary-button = Conhecer esquemas de cores
upgrade-dialog-start-secondary-button = Agora não

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Escolha um esquema de cores
upgrade-dialog-colorway-home-checkbox = Mude para a página inicial do Waterfox com fundo temático
upgrade-dialog-colorway-primary-button = Salvar esquema de cores
upgrade-dialog-colorway-secondary-button = Manter tema anterior
upgrade-dialog-colorway-theme-tooltip =
    .title = Conheça os temas padrão
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Conheça os esquemas de cores { $colorwayName }
upgrade-dialog-colorway-default-theme = Padrão
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Automático
    .title = Seguir o tema do sistema operacional em botões, menus e janelas
upgrade-dialog-theme-light = Claro
    .title = Usar um tema claro em botões, menus e janelas
upgrade-dialog-theme-dark = Escuro
    .title = Usar um tema escuro em botões, menus e janelas
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Usar um tema dinâmico e colorido em botões, menus e janelas
upgrade-dialog-theme-keep = Manter anterior
    .title = Usar o tema que você tinha instalado antes de atualizar o { -brand-short-name }
upgrade-dialog-theme-primary-button = Salvar tema
upgrade-dialog-theme-secondary-button = Agora não
upgrade-dialog-colorway-variation-soft = Suave
    .title = Usar este esquema de cores
upgrade-dialog-colorway-variation-balanced = Equilibrado
    .title = Usar este esquema de cores
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Forte
    .title = Usar este esquema de cores

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Obrigado por nos escolher
upgrade-dialog-thankyou-subtitle = O { -brand-short-name } é um navegador independente, respaldado por uma organização sem fins lucrativos. Juntos, estamos tornando a web mais segura, mais saudável e mais privativa.
upgrade-dialog-thankyou-primary-button = Iniciar navegação
