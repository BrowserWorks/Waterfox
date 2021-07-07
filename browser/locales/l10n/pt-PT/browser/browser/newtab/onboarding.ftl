# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Bem-vindo(a) ao { -brand-short-name }
onboarding-start-browsing-button-label = Começar a navegar
onboarding-not-now-button-label = Agora não

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Ótimo, você tem o { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Agora vamos obter o <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Adicionar a extensão

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Bem-vindo ao <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = O navegador rápido, seguro e privado, apoiado por uma organização sem fins lucrativos.
onboarding-multistage-welcome-primary-button-label = Iniciar configuração
onboarding-multistage-welcome-secondary-button-label = Iniciar sessão
onboarding-multistage-welcome-secondary-button-text = Tem uma conta?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = <span data-l10n-name="zap">Predefinir</span> o { -brand-short-name }
onboarding-multistage-set-default-subtitle = Velocidade, segurança e privacidade sempre que navegar.
onboarding-multistage-set-default-primary-button-label = Predefinir
onboarding-multistage-set-default-secondary-button-label = Agora não
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Comece por colocar o <span data-l10n-name="zap">{ -brand-short-name }</span> à distância de um clique
onboarding-multistage-pin-default-subtitle = Navegação rápida, segura e privada, sempre que utiliza a Internet.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Escolha { -brand-short-name } sob navegador de Internet quando as suas definições foram apresentadas
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Isto irá fixar o { -brand-short-name } na barra de tarefas e irá abrir as definições
onboarding-multistage-pin-default-primary-button-label = Definir o { -brand-short-name } como o meu navegador principal
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importar as suas palavras-passe, marcadores, <span data-l10n-name="zap">entre outros</span>
onboarding-multistage-import-subtitle = Era um utilizador de outro navegador? É simples trazer tudo para o { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Iniciar importação
onboarding-multistage-import-secondary-button-label = Agora não
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer =
    Foram encontrados neste dispositivo os sites listados.
    O { -brand-short-name } não guarda ou sincroniza dados de 
    outro navegador a menos que opte por
    importar os mesmos.

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Primeiros passos: ecrã { $current } de { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Escolha um <span data-l10n-name="zap">visual</span>
onboarding-multistage-theme-subtitle = Personalize o { -brand-short-name } com um tema.
onboarding-multistage-theme-primary-button-label2 = Concluído
onboarding-multistage-theme-secondary-button-label = Agora não
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automático
onboarding-multistage-theme-label-light = Claro
onboarding-multistage-theme-label-dark = Escuro
# "Waterfox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Waterfox Alpenglow
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = O fogo começa aqui
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio - Designer de mobiliário, fã do Waterfox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Desativar as animações

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Mantenha o { -brand-short-name } na sua Doca para um acesso mais fácil
       *[other] Fixe o { -brand-short-name } na sua barra de tarefas para um acesso mais fácil
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Manter na Doca
       *[other] Fixar na barra de tarefas
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Começar
mr1-onboarding-welcome-header = Bem-vindo(a) ao { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Definir o { -brand-short-name } como o meu navegador principal
    .title = Define o { -brand-short-name } como o navegador principal e fixa o mesmo à barra de tarefas
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Definir o { -brand-short-name } no meu navegador principal
mr1-onboarding-set-default-secondary-button-label = Agora não
mr1-onboarding-sign-in-button-label = Iniciar sessão

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Predefinir o { -brand-short-name }
mr1-onboarding-default-subtitle = Coloque a velocidade, segurança e privacidade em piloto automático.
mr1-onboarding-default-primary-button-label = Predefinir o navegador

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Leve tudo consigo
mr1-onboarding-import-subtitle = Importe as suas palavras-passe, <br/>marcadores e muito mais.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importar de { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importar do navegador anterior
mr1-onboarding-import-secondary-button-label = Agora não
mr2-onboarding-colorway-header = Vida a cores
mr2-onboarding-colorway-subtitle = Esquemas de cor vibrantes. Disponíveis por tempo limitado.
mr2-onboarding-colorway-primary-button-label = Guardar esquema de cor
mr2-onboarding-colorway-secondary-button-label = Agora não
mr2-onboarding-colorway-label-soft = Suave
mr2-onboarding-colorway-label-balanced = Equilibrado
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Audacioso
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Automático
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Predefinido
mr1-onboarding-theme-header = Personalize
mr1-onboarding-theme-subtitle = Personalize o { -brand-short-name } com um tema.
mr1-onboarding-theme-primary-button-label = Guardar tema
mr1-onboarding-theme-secondary-button-label = Agora não
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Tema do sistema
mr1-onboarding-theme-label-light = Claro
mr1-onboarding-theme-label-dark = Escuro
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.


## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Herdar a aparência do seu sistema 
        operativo para botões, menus e janelas.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Herdar a aparência do seu sistema 
        operativo para botões, menus e janelas.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Utilizar uma aparência clara para 
        botões, menus e janelas.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Utilizar uma aparência clara para 
        botões, menus e janelas.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Utilizar uma aparência escura para 
        botões, menus e janelas.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Utilizar uma aparência escura para 
        botões, menus e janelas.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Utilizar uma aparência colorida para 
        botões, menus e janelas.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Utilizar uma aparência colorida para 
        botões, menus e janelas.

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Seguir o tema do sistema operativo 
        para botões, menus e janelas.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Seguir o tema do sistema operativo 
        para botões, menus e janelas.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Utilizar um tema claro para 
        botões, menus e janelas.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Utilizar um tema claro para 
        botões, menus e janelas.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Utilizar um tema escuro para 
        botões, menus e janelas.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Utilizar um tema escuro para 
        botões, menus e janelas.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Utilizar um tema dinâmico e colorido para 
        botões, menus e janelas.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Utilizar um tema dinâmico e colorido para 
        botões, menus e janelas.
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Utilizar este esquema de cor.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Utilizar este esquema de cor.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Explorar os esquema de cor { $colorwayName }.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-description =
    .aria-description = Explorar os esquema de cor { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Explorar os temas predefinidos.
# Selector description for default themes
mr2-onboarding-default-theme-description =
    .aria-description = Explorar os temas predefinidos.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Obrigado por nos escolher
mr2-onboarding-thank-you-text = O { -brand-short-name } é um navegador independente apoiado por uma organização sem fins lucrativos. Juntos, estamos tornar a Internet mais segura, mais saudável e mais privada.
mr2-onboarding-start-browsing-button-label = Começar a navegar
