# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Diga olá a um novo { -brand-short-name }
upgrade-dialog-new-subtitle = Projetado para te levar onde você quiser, mais rápido
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Comece deixando o <span data-l10n-name="zap">{ -brand-short-name }</span> a um clique de distância
upgrade-dialog-new-item-menu-title = Menus e barra de ferramentas simplificados
upgrade-dialog-new-item-menu-description = Prioriza as coisas importantes para você encontrar o que precisa.
upgrade-dialog-new-item-tabs-title = Abas modernas
upgrade-dialog-new-item-tabs-description = Contêm informações de forma organizada, aceitando foco e movimento flexível.
upgrade-dialog-new-item-icons-title = Novos ícones e mensagens mais claras
upgrade-dialog-new-item-icons-description = Ajuda a encontrar as coisas com um toque mais leve.
upgrade-dialog-new-primary-primary-button = Tornar o { -brand-short-name } meu navegador principal
    .title = Definir o { -brand-short-name } como navegador padrão e fixar na barra de tarefas
upgrade-dialog-new-primary-default-button = Tornar o { -brand-short-name } meu navegador padrão
upgrade-dialog-new-primary-pin-button = Fixar o { -brand-short-name } na barra de tarefas
upgrade-dialog-new-primary-pin-alt-button = Fixar na barra de tarefas
upgrade-dialog-new-primary-theme-button = Escolha um tema
upgrade-dialog-new-secondary-button = Agora não
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Ok, entendi

## Pin Firefox screen
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
upgrade-dialog-default-title = Tornar o { -brand-short-name } seu navegador padrão?
upgrade-dialog-default-subtitle = Tenha velocidade, segurança e privacidade sempre que você navegar.
upgrade-dialog-default-primary-button = Definir como navegador padrão
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Tornar o { -brand-short-name } o navegador padrão
upgrade-dialog-default-subtitle-2 = Tenha velocidade, segurança e privacidade automaticamente.
upgrade-dialog-default-primary-button-2 = Definir como navegador padrão
upgrade-dialog-default-secondary-button = Agora não

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title = Experimente um novo tema
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Experimente um tema nítido
upgrade-dialog-theme-system = Tema do sistema
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
