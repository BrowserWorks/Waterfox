# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Bem-vindo(a) ao { -brand-short-name }
onboarding-start-browsing-button-label = Começar a navegar
onboarding-not-now-button-label = Agora não
mr1-onboarding-get-started-primary-button-label = Começar

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Ótimo, tem o { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Agora vamos obter o <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Adicionar a extensão
return-to-amo-add-theme-label = Adicionar o tema

##  Variables: $addon-name (String) - Name of the add-on to be installed

mr1-return-to-amo-subtitle = Diga olá a(ao) { -brand-short-name }
mr1-return-to-amo-addon-title = Tem um navegador rápido e privado ao seu alcance. Agora pode adicionar <b>{ $addon-name }</b> e fazer ainda mais com o { -brand-short-name }.
mr1-return-to-amo-add-extension-label = Adicionar { $addon-name }

## Multistage onboarding strings (about:welcome pages)


# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator-label =
    .aria-label = Progresso: passo { $current } de { $total }
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Desativar as animações
# String for the Waterfox Accounts button
mr1-onboarding-sign-in-button-label = Iniciar sessão
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importar de { $previous }
mr1-onboarding-theme-header = Personalize
mr1-onboarding-theme-subtitle = Personalize o { -brand-short-name } com um tema.
mr1-onboarding-theme-secondary-button-label = Agora não
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Tema do sistema
mr1-onboarding-theme-label-light = Claro
mr1-onboarding-theme-label-dark = Escuro
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Concluído

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

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
# Selector description for default themes
mr2-onboarding-default-theme-label = Explorar os temas predefinidos.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Obrigado por nos escolher
mr2-onboarding-thank-you-text = O { -brand-short-name } é um navegador independente apoiado por uma organização sem fins lucrativos. Juntos, estamos tornar a Internet mais segura, mais saudável e mais privada.
mr2-onboarding-start-browsing-button-label = Começar a navegar

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = Escolha o seu idioma
mr2022-onboarding-live-language-text = O { -brand-short-name } fala o seu idioma
mr2022-language-mismatch-subtitle = Graças à nossa comunidade, o { -brand-short-name } está traduzido em mais de 90 idiomas. Parece que seu sistema está a usar { $systemLanguage } e o { -brand-short-name } está a usar o { $appLanguage }.
onboarding-live-language-button-label-downloading = A transferir o pacote de idioma para { $negotiatedLanguage }…
onboarding-live-language-waiting-button = A obter os idiomas disponíveis…
onboarding-live-language-installing = A instalar o pacote de idioma para { $negotiatedLanguage }…
mr2022-onboarding-live-language-switch-to = Alterar para { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Continuar em { $appLanguage }
onboarding-live-language-secondary-cancel-download = Cancelar
onboarding-live-language-skip-button-label = Ignorar

## Waterfox 100 Thank You screens

# "Hero Text" displayed on left side of welcome screen. This text can be
# formatted to span multiple lines as needed. The <span data-l10n-name="zap">
# </span> in this string allows a "zap" underline style to be automatically
# added to the text inside it. "Yous" should stay inside the zap span, but
# "Thank" can be put inside instead if there's no "you" in the translation.
# The English text would normally be "100 Thank-Yous" i.e., plural noun, but for
# aesthetics of splitting it across multiple lines, the hyphen is omitted.
fx100-thank-you-hero-text = 100 <span data-l10n-name="zap">Obrigados</span>
fx100-thank-you-subtitle = É o nosso 100.º lançamento! Obrigado por nos ajudar a construir uma Internet melhor e mais saudável.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Fixar o { -brand-short-name } à Dock
       *[other] Fixar o { -brand-short-name } à barra de tarefas
    }
fx100-upgrade-thanks-header = 100 Obrigados
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = É nosso 100.º lançamento do { -brand-short-name }. <em>Obrigado</em> por nos ajudar a construir uma Internet melhor e mais saudável.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = É o nosso 100.º lançamento! Obrigado por fazer parte da nossa comunidade. Mantenha o { -brand-short-name } a um clique de distância para os próximos 100.
mr2022-onboarding-secondary-skip-button-label = Saltar este passo

## MR2022 New User Easy Setup screen strings

# Primary button string used on new user onboarding first screen showing multiple actions such as Set Default, Import from previous browser.
mr2022-onboarding-easy-setup-primary-button-label = Guardar e continuar
# Set Default action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-set-default-checkbox-label = Definir o { -brand-short-name } como o seu navegador predefinido
# Import action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-import-checkbox-label = Importar do navegador anterior

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Descubra uma Internet incrível
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Inicie o { -brand-short-name } de qualquer lugar com um único clique. Toda vez que faz isto, está a escolher uma Web mais aberta e independente.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Manter o { -brand-short-name } na Doca
       *[other] Fixar o { -brand-short-name } à barra de tarefas
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Comece com um navegador apoiado por uma organização sem fins lucrativos. Nós defendemos a sua privacidade enquanto navega pela Web.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Obrigado por gostar do { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Começe uma Internet mais saudável a partir de qualquer lugar, com um único clique. A nossa atualização mais recente está repleta de novidades que achamos que vai adorar.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Utilize um navegador que defende a sua privacidade enquanto navega pela Web. A nossa atualização mais recente está repleta de coisas que você adora.
mr2022-onboarding-existing-pin-checkbox-label = Adicione também a navegação privada do { -brand-short-name }

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Tornar o { -brand-short-name } no seu navegador predefinido
mr2022-onboarding-set-default-primary-button-label = Definir o { -brand-short-name } como o seu navegador predefinido
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Utilize um navegador apoiado por uma organização sem fins lucrativos. Nós defendemos a sua privacidade enquanto navega pela Web.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = A nossa versão mais recente foi desenvolvida para si, tornando mais fácil do que nunca a navegação na Web. Ela está repleta de funcionalidades que achamos que vai adorar.
mr2022-onboarding-get-started-primary-button-label = Configurar em segundos

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Configuração ultra-rápida
mr2022-onboarding-import-subtitle = Configure o { -brand-short-name } como preferir. Adicione os seus marcadores, palavras-passe e muito mais, do seu navegador antigo.
mr2022-onboarding-import-primary-button-label-no-attribution = Importar do navegador anterior

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Escolha a cor que o(a) inspira
mr2022-onboarding-colorway-subtitle = Vozes independentes podem mudar a cultura.
mr2022-onboarding-colorway-primary-button-label-continue = Definir e continuar
mr2022-onboarding-existing-colorway-checkbox-label = Faça do { -firefox-home-brand-name } a sua página inicial colorida
mr2022-onboarding-colorway-label-default = Predefinido
mr2022-onboarding-colorway-tooltip-default2 =
    .title = Cores atuais do { -brand-short-name }
mr2022-onboarding-colorway-description-default = <b>Utilizar as minhas cores atuais do { -brand-short-name }.</b>
mr2022-onboarding-colorway-label-playmaker = Impulsionador(a)
mr2022-onboarding-colorway-tooltip-playmaker2 =
    .title = Jogador (red)
mr2022-onboarding-colorway-description-playmaker = <b>É um(a) impulsionador(a).</b> Você cria oportunidades para vencer e ajudar a todos à sua volta a melhorar as suas capacidades.
mr2022-onboarding-colorway-label-expressionist = Expressionista
mr2022-onboarding-colorway-tooltip-expressionist2 =
    .title = Expressionista (amarelo)
mr2022-onboarding-colorway-description-expressionist = <b>É um(a) expressionista.</b> Você vê o mundo de maneira diferente e as suas criações despertam as emoções dos outros.
mr2022-onboarding-colorway-label-visionary = Visionário(a)
mr2022-onboarding-colorway-tooltip-visionary2 =
    .title = Visionário(a) (verde)
mr2022-onboarding-colorway-description-visionary = <b>É um visionário(a).</b> Você questiona o status-quo e leva os outros a imaginar um futuro melhor.
mr2022-onboarding-colorway-label-activist = Ativista
mr2022-onboarding-colorway-tooltip-activist2 =
    .title = Ativista (azul)
mr2022-onboarding-colorway-description-activist = <b>É um ativista.</b> Você deixa o mundo um lugar melhor do que aquele que encontrou e leva os outros a acreditar.
mr2022-onboarding-colorway-label-dreamer = Sonhador(a)
mr2022-onboarding-colorway-tooltip-dreamer2 =
    .title = Sonhador(a) (roxo)
mr2022-onboarding-colorway-description-dreamer = <b>Você é um(a) sonhador(a).</b> Você acredita que a sorte favorece os ousados e inspira os outros a serem corajosos.
mr2022-onboarding-colorway-label-innovator = Inovador(a)
mr2022-onboarding-colorway-tooltip-innovator2 =
    .title = Inovador(a) (laranja)
mr2022-onboarding-colorway-description-innovator = <b>Você é um(a) inovador(a).</b> Você vê oportunidades em todo o lado e causa impacto na vida de todos à sua volta.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Mude do portátil para o telemóvel e vice-versa
mr2022-onboarding-mobile-download-subtitle = Obtenha os separadores de um dispositivo e continue de onde parou noutro. Além disto, sincronize os seus marcadores e palavras-passe em qualquer sítio onde utilize o { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Digitalize o código QR para obter o { -brand-product-name } para telemóvel ou <a data-l10n-name="download-label">envie uma ligação de transferência para você mesmo.</a>
mr2022-onboarding-no-mobile-download-cta-text = Digitalize o código QR para obter o { -brand-product-name } para telemóveis.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Obtenha a liberdade da navegação privada num clique
mr2022-upgrade-onboarding-pin-private-window-subtitle = Sem cookies ou histórico guardados, diretamente a partir do seu ambiente de trabalho. Navegue como se ninguém estivesse a ver.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Manter a navegação privada do { -brand-short-name } na Doca
       *[other] Fixar a navegação privada do { -brand-short-name } à minha barra de tarefas
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Nós respeitamos sempre a sua privacidade
mr2022-onboarding-privacy-segmentation-subtitle = A partir de sugestões inteligentes para pesquisas mais inteligentes. Nós trabalhamos constantemente para criar um { -brand-product-name } melhor e mais pessoal.
mr2022-onboarding-privacy-segmentation-text-cta = O que quer ver quando oferecemos novas funcionalidades que utilizam os seus dados para melhorar a sua navegação?
mr2022-onboarding-privacy-segmentation-button-primary-label = Usar as recomendações do { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Mostrar informações detalhadas

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Está a ajudar-nos a construir uma Internet melhor.
mr2022-onboarding-gratitude-subtitle = Obrigado por utilizar o { -brand-short-name }, apoiado pela Fundação BrowserWorks. Com o seu apoio, estamos a trabalhar para tornar a Internet mais aberta, acessível e melhor para todos.
mr2022-onboarding-gratitude-primary-button-label = Veja as novidades
mr2022-onboarding-gratitude-secondary-button-label = Começar a navegar

## Onboarding spotlight for infrequent users

onboarding-infrequent-import-title = Sinta-se em casa
onboarding-infrequent-import-subtitle = Quer esteja a instalar-se ou apenas de passagem, lembre-se de que pode importar os seus marcadores, palavras-passe, e muito mais.
onboarding-infrequent-import-primary-button = Importar para { -brand-short-name }

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

mr2022-onboarding-pin-image-alt =
    .aria-label = Pessoa a trabalhar num portátil rodeado por estrelas e flores
mr2022-onboarding-default-image-alt =
    .aria-label = Pessoa a abraçar o logótipo do { -brand-product-name }
mr2022-onboarding-import-image-alt =
    .aria-label = Pessoa a andar de skate com uma caixa de ícones de programas
mr2022-onboarding-mobile-download-image-alt =
    .aria-label = Sapos a saltar nos lírios com um código QR para transferir o { -brand-product-name } para o telemóvel no centro
mr2022-onboarding-pin-private-image-alt =
    .aria-label = Varinha mágica faz com que o logótipo de navegação privada do { -brand-product-name } apareça de um chapéu
mr2022-onboarding-privacy-segmentation-image-alt =
    .aria-label = Uma mão de pele clara e outra de pele escura cumprimentam-se
mr2022-onboarding-gratitude-image-alt =
    .aria-label = Vista de um pôr do sol através de uma janela com uma raposa e uma planta doméstica no peitoril da janela
mr2022-onboarding-colorways-image-alt =
    .aria-label = Um spray de mão pinta uma montagem colorida de um olho verde, sapato laranja, bola de basquetebol vermelha, auscultadores roxos, coração azul e coroa amarela

## Device migration onboarding

onboarding-device-migration-image-alt =
    .aria-label = Uma raposa a acenar no ecrã de um portátil. O portátil tem um rato ligado.
onboarding-device-migration-title = Olá novamente!
onboarding-device-migration-subtitle = Entre na { -fxaccount-brand-name(capitalization: "sentence") } para levar os seus marcadores, palavras-passe e histórico consigo no seu novo dispositivo.
onboarding-device-migration-primary-button-label = Entrar
