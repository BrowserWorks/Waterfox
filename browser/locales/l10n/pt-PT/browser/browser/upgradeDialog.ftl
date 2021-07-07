# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Diga olá a um novo { -brand-short-name }
upgrade-dialog-new-subtitle = Projetado para levá-lo mais rápido, para onde quiser
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline
# style to be automatically added to the text inside it. { -brand-short-name }
# should stay inside the span.
upgrade-dialog-new-alt-subtitle = Comece por colocar o <span data-l10n-name="zap">{ -brand-short-name }</span> à distância de um clique
upgrade-dialog-new-item-menu-title = Barras de ferramentas e menus aperfeiçoados
upgrade-dialog-new-item-menu-description = Priorize as coisas importantes para encontrar o que precisa.
upgrade-dialog-new-item-tabs-title = Separadores modernos
upgrade-dialog-new-item-tabs-description = Mantém as informações organizada, apoiando a concentração e o movimento flexível.
upgrade-dialog-new-item-icons-title = Ícones novos e mensagens mais claras
upgrade-dialog-new-item-icons-description = Ajuda a encontrar o seu caminho, com um toque mais leve.
upgrade-dialog-new-primary-primary-button = Definir o { -brand-short-name } como o meu navegador principal
    .title = Define o { -brand-short-name } como o navegador principal e fixa o mesmo à barra de ferramentas
upgrade-dialog-new-primary-default-button = Tornar o { -brand-short-name } no meu navegador predefinido
upgrade-dialog-new-primary-pin-button = Fixar o { -brand-short-name } à minha barra de tarefas
upgrade-dialog-new-primary-pin-alt-button = Fixar na barra de tarefas
upgrade-dialog-new-primary-theme-button = Escolher um tema
upgrade-dialog-new-secondary-button = Agora não
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Ok, entendi!

## Pin Firefox screen
##
## These title, subtitle and button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-pin-title =
    { PLATFORM() ->
        [macos] Manter o { -brand-short-name } na sua Dock
       *[other] Fixar o { -brand-short-name } na sua barra de tarefas
    }
# The English macOS string avoids repeating "Keep" a third time, so if your
# translations don't repeat anyway, the same string can be used cross-platform.
upgrade-dialog-pin-subtitle =
    { PLATFORM() ->
        [macos] Tenha um acesso facilitado ao { -brand-short-name } mais recente.
       *[other] Mantenha o { -brand-short-name } mais recente por perto.
    }
upgrade-dialog-pin-primary-button =
    { PLATFORM() ->
        [macos] Manter na Doca
       *[other] Fixar na barra de tarefas
    }
upgrade-dialog-pin-secondary-button = Agora não

## Default browser screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title = Tornar o { -brand-short-name } no seu navegador predefinido?
upgrade-dialog-default-subtitle = Obtenha velocidade, segurança e privacidade sempre que navega.
upgrade-dialog-default-primary-button = Definir como navegador predefinido
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-default-title-2 = Predefinir o { -brand-short-name }
upgrade-dialog-default-subtitle-2 = Coloque a velocidade, segurança e privacidade em piloto automático.
upgrade-dialog-default-primary-button-2 = Definir como navegador predefinido
upgrade-dialog-default-secondary-button = Agora não

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title =
    Comece do zero
    com um tema atualizado
# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Comece do zero com um tema nítido
upgrade-dialog-theme-system = Tema de sistema
    .title = Segue o tema do sistema operativo para botões, menus e janelas
upgrade-dialog-theme-light = Claro
    .title = Utilizar um tema claro para botões, menus e janelas
upgrade-dialog-theme-dark = Escuro
    .title = Utilizar um tema escuro para botões, menus e janelas
upgrade-dialog-theme-alpenglow = Alpenglow
    .title = Utilizar um tema dinâmico e colorido para botões, menus e janelas
upgrade-dialog-theme-keep = Manter anterior
    .title = Utilizar um tema que tinha instalado antes de atualizar o { -brand-short-name }
upgrade-dialog-theme-primary-button = Guardar tema
upgrade-dialog-theme-secondary-button = Agora não
