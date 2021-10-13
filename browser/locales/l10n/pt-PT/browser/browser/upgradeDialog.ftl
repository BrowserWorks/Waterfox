# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Strings for the upgrade dialog that can be displayed on major version change.


## New changes screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-new-title = Diga olá a um novo { -brand-short-name }
upgrade-dialog-new-subtitle = Projetado para levá-lo mais rápido, para onde quiser
upgrade-dialog-new-item-menu-title = Barras de ferramentas e menus aperfeiçoados
upgrade-dialog-new-item-menu-description = Priorize as coisas importantes para encontrar o que precisa.
upgrade-dialog-new-item-tabs-title = Separadores modernos
upgrade-dialog-new-item-tabs-description = Mantém as informações organizada, apoiando a concentração e o movimento flexível.
upgrade-dialog-new-item-icons-title = Ícones novos e mensagens mais claras
upgrade-dialog-new-item-icons-description = Ajuda a encontrar o seu caminho, com um toque mais leve.
upgrade-dialog-new-primary-default-button = Tornar o { -brand-short-name } no meu navegador predefinido
upgrade-dialog-new-primary-theme-button = Escolher um tema
upgrade-dialog-new-secondary-button = Agora não
# This string is only shown on Windows 7, where we intentionally suppress the
# theme selection screen.
upgrade-dialog-new-primary-win7-button = Ok, entendi!

## Pin Waterfox screen
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
upgrade-dialog-default-title-2 = Predefinir o { -brand-short-name }
upgrade-dialog-default-subtitle-2 = Coloque a velocidade, segurança e privacidade em piloto automático.
upgrade-dialog-default-primary-button-2 = Definir como navegador predefinido
upgrade-dialog-default-secondary-button = Agora não

## Theme selection screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-theme-title-2 = Comece do zero com um tema nítido
upgrade-dialog-theme-system = Tema de sistema
    .title = Segue o tema do sistema operativo para botões, menus e janelas

## Start screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-start-title = Vida a cores
upgrade-dialog-start-subtitle = Esquemas de cor vibrantes. Disponíveis por tempo limitado.
upgrade-dialog-start-primary-button = Explorar esquemas de cor
upgrade-dialog-start-secondary-button = Agora não

## Colorway screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-colorway-title = Escolha a sua paleta
upgrade-dialog-colorway-home-checkbox = Mudar para o Waterfox Home com fundo baseado em temas
upgrade-dialog-colorway-primary-button = Guardar esquema de cor
upgrade-dialog-colorway-secondary-button = Manter o tema anterior
upgrade-dialog-colorway-theme-tooltip =
    .title = Explorar os temas predefinidos
# $colorwayName (String) - Name of colorway, e.g., Abstract, Cheers
upgrade-dialog-colorway-colorway-tooltip =
    .title = Explorar os esquema de cor { $colorwayName }
upgrade-dialog-colorway-default-theme = Predefinido
# "Auto" is short for "Automatic"
upgrade-dialog-colorway-theme-auto = Automático
    .title = Seguir o tema do sistema operativo para botões, menus e janelas
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
upgrade-dialog-colorway-variation-soft = Suave
    .title = Utilizar este esquema de cores
upgrade-dialog-colorway-variation-balanced = Equilibrado
    .title = Utilizar este esquema de cores
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
upgrade-dialog-colorway-variation-bold = Audacioso
    .title = Utilizar este esquema de cores

## Thank you screen

# This title can be explicitly wrapped to control which words are on which line.
upgrade-dialog-thankyou-title = Obrigado por nos escolher
upgrade-dialog-thankyou-subtitle = O { -brand-short-name } é um navegador independente apoiado por uma organização sem fins lucrativos. Juntos, estamos tornar a Internet mais segura, mais saudável e mais privada.
upgrade-dialog-thankyou-primary-button = Começar a navegar
