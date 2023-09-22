# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Boas-vindas ao { -brand-short-name }
onboarding-start-browsing-button-label = Comece a navegar
onboarding-not-now-button-label = Agora não
mr1-onboarding-get-started-primary-button-label = Introdução

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Ótimo, você instalou o { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Agora experimente o <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Adicionar a extensão
return-to-amo-add-theme-label = Adicionar o tema

##  Variables: $addon-name (String) - Name of the add-on to be installed

mr1-return-to-amo-subtitle = Conheça o { -brand-short-name }
mr1-return-to-amo-addon-title = Você tem em suas mãos um navegador rápido que respeita sua privacidade. Agora você pode adicionar <b>{ $addon-name }</b> e fazer ainda mais com o { -brand-short-name }.
mr1-return-to-amo-add-extension-label = Adicionar { $addon-name }

## Multistage onboarding strings (about:welcome pages)


# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator-label =
    .aria-label = Progresso: passo { $current } de { $total }
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Desativar animações
# String for the Waterfox Accounts button
mr1-onboarding-sign-in-button-label = Entrar
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importar do { $previous }
mr1-onboarding-theme-header = Deixe do seu jeito
mr1-onboarding-theme-subtitle = Personalize o { -brand-short-name } com um tema.
mr1-onboarding-theme-secondary-button-label = Agora não
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Tema do sistema
mr1-onboarding-theme-label-light = Claro
mr1-onboarding-theme-label-dark = Escuro
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow
onboarding-theme-primary-button-label = Pronto

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Seguir o tema do sistema operacional
        em botões, menus e janelas.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Seguir o tema do sistema operacional
        em botões, menus e janelas.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Usar um tema claro em botões,
        menus e janelas.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Usar um tema claro em botões,
        menus e janelas.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Usar um tema escuro em botões,
        menus e janelas.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Usar um tema escuro em botões,
        menus e janelas.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Usar um tema dinâmico e colorido em botões,
        menus e janelas.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Usar um tema dinâmico e colorido em botões,
        menus e janelas.
# Selector description for default themes
mr2-onboarding-default-theme-label = Conheça os temas padrão.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Obrigado por nos escolher
mr2-onboarding-thank-you-text = O { -brand-short-name } é um navegador independente, respaldado por uma organização sem fins lucrativos. Juntos, estamos tornando a web mais segura, mais saudável e mais privativa.
mr2-onboarding-start-browsing-button-label = Iniciar navegação

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = Escolha seu idioma
mr2022-onboarding-live-language-text = O { -brand-short-name } fala seu idioma
mr2022-language-mismatch-subtitle = Graças à nossa comunidade, o { -brand-short-name } está traduzido em mais de 90 idiomas. Parece que seu sistema está em { $systemLanguage } e o { -brand-short-name } está em { $appLanguage }.
onboarding-live-language-button-label-downloading = Baixando o pacote de idioma de { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Obtendo idiomas disponíveis…
onboarding-live-language-installing = Instalando o pacote de idioma de { $negotiatedLanguage }…
mr2022-onboarding-live-language-switch-to = Mudar para { $negotiatedLanguage }
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
fx100-thank-you-hero-text =
    100
    <span data-l10n-name="zap">agradecimentos</span>
fx100-thank-you-subtitle = É a nossa 100ª versão! Obrigado por nos ajudar a construir uma internet melhor e mais saudável.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Manter o { -brand-short-name } no Dock
       *[other] Fixar o { -brand-short-name } na barra de tarefas
    }
fx100-upgrade-thanks-header = 100 agradecimentos
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = É a nossa 100ª versão do { -brand-short-name }. Obrigado a <em>você</em> por nos ajudar a construir uma internet melhor e mais saudável.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = É a nossa 100ª versão! Obrigado por fazer parte da nossa comunidade. Mantenha o { -brand-short-name } a um clique de distância para os próximos 100.
mr2022-onboarding-secondary-skip-button-label = Pular esta etapa

## MR2022 New User Easy Setup screen strings

# Primary button string used on new user onboarding first screen showing multiple actions such as Set Default, Import from previous browser.
mr2022-onboarding-easy-setup-primary-button-label = Salvar e continuar
# Set Default action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-set-default-checkbox-label = Definir o { -brand-short-name } como navegador padrão
# Import action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-import-checkbox-label = Importar do navegador anterior

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Abra-se uma internet incrível
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Inicie o { -brand-short-name } de qualquer lugar com um único clique. Toda vez que faz isso, você está escolhendo uma web mais aberta e independente.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Manter o { -brand-short-name } no Dock
       *[other] Fixar o { -brand-short-name } na barra de tarefas
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Comece com um navegador respaldado por uma organização sem fins lucrativos. Defendemos sua privacidade enquanto você passeia pela web.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Obrigado por gostar do { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Inicie uma internet mais saudável de qualquer lugar com um único clique. Nossa versão mais recente está repleta de novidades que achamos que você vai adorar.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Use um navegador que defende sua privacidade enquanto você passeia pela web. Nossa versão mais recente está repleta de coisas que você adora.
mr2022-onboarding-existing-pin-checkbox-label = Adicione também a navegação privativa do { -brand-short-name }

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Torne o { -brand-short-name } seu navegador padrão
mr2022-onboarding-set-default-primary-button-label = Definir o { -brand-short-name } como navegador padrão
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Use um navegador respaldado por uma organização sem fins lucrativos. Defendemos sua privacidade enquanto você passeia pela web.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Nossa versão mais recente foi construída com base em vocês, tornando mais fácil do que nunca passear pela web. Está repleto de recursos que achamos que você vai adorar.
mr2022-onboarding-get-started-primary-button-label = Configure em segundos

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Configuração extremamente rápida
mr2022-onboarding-import-subtitle = Configure o { -brand-short-name } como você quiser. Adicione favoritos, senhas e muito mais do seu navegador antigo.
mr2022-onboarding-import-primary-button-label-no-attribution = Importar do navegador anterior

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Escolha uma cor que te inspira
mr2022-onboarding-colorway-subtitle = Vozes independentes podem mudar a cultura.
mr2022-onboarding-colorway-primary-button-label-continue = Definir e continuar
mr2022-onboarding-existing-colorway-checkbox-label = Torne a { -firefox-home-brand-name } sua tela inicial colorida
mr2022-onboarding-colorway-label-default = Padrão
mr2022-onboarding-colorway-tooltip-default2 =
    .title = Cores atuais do { -brand-short-name }
mr2022-onboarding-colorway-description-default = <b>Usar minhas cores atuais do { -brand-short-name }.</b>
mr2022-onboarding-colorway-label-playmaker = Jogador em equipe
mr2022-onboarding-colorway-tooltip-playmaker2 =
    .title = Jogador em equipe (vermelho)
mr2022-onboarding-colorway-description-playmaker = <b>Jogador em equipe.</b> Você cria oportunidades para vencer e ajuda todos ao seu redor a elevar seus jogos.
mr2022-onboarding-colorway-label-expressionist = Expressionista
mr2022-onboarding-colorway-tooltip-expressionist2 =
    .title = Expressionista (amarelo)
mr2022-onboarding-colorway-description-expressionist = <b>Expressionista.</b> Você vê o mundo de forma diferente e suas criações despertam emoções nos outros.
mr2022-onboarding-colorway-label-visionary = Visionário
mr2022-onboarding-colorway-tooltip-visionary2 =
    .title = Visionário (verde)
mr2022-onboarding-colorway-description-visionary = <b>Visionário.</b> Você questiona a situação atual e leva os outros a imaginar um futuro melhor.
mr2022-onboarding-colorway-label-activist = Ativista
mr2022-onboarding-colorway-tooltip-activist2 =
    .title = Ativista (azul)
mr2022-onboarding-colorway-description-activist = <b>Ativista.</b> Você torna o mundo um lugar melhor do que encontrou e leva os outros a acreditar.
mr2022-onboarding-colorway-label-dreamer = Sonhador
mr2022-onboarding-colorway-tooltip-dreamer2 =
    .title = Sonhador (roxo)
mr2022-onboarding-colorway-description-dreamer = <b>Sonhador.</b> Você acredita que a sorte favorece os ousados e inspira os outros a ser corajosos.
mr2022-onboarding-colorway-label-innovator = Inovador
mr2022-onboarding-colorway-tooltip-innovator2 =
    .title = Inovador (laranja)
mr2022-onboarding-colorway-description-innovator = <b>Inovador.</b> Você vê oportunidades em todo lugar e causa impacto na vida de todos ao seu redor.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Alterne entre computador e celular
mr2022-onboarding-mobile-download-subtitle = Pegue abas de um dispositivo e continue de onde parou em outro. Além disso, sincronize seus favoritos e senhas em qualquer lugar que use o { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Capture o código QR para instalar o { -brand-product-name } para celular ou <a data-l10n-name="download-label">envie um link de download para si mesmo</a>.
mr2022-onboarding-no-mobile-download-cta-text = Capture o código QR para instalar o { -brand-product-name } para dispositivos móveis.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Tenha liberdade de navegação privativa em apenas um clique
mr2022-upgrade-onboarding-pin-private-window-subtitle = Não salva cookies nem histórico, direto da sua área de trabalho. Navegue como se ninguém estivesse vendo.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Manter a navegação privativa do { -brand-short-name } no Dock
       *[other] Fixar a navegação privativa do { -brand-short-name } na barra de tarefas
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Sempre respeitamos sua privacidade
mr2022-onboarding-privacy-segmentation-subtitle = De sugestões inteligentes a pesquisas mais espertas, trabalhamos constantemente para criar um { -brand-product-name } melhor e mais pessoal.
mr2022-onboarding-privacy-segmentation-text-cta = O que você quer que apareça quando oferecemos novos recursos que usam seus dados para aprimorar sua navegação?
mr2022-onboarding-privacy-segmentation-button-primary-label = Usar recomendações do { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Mostrar informações detalhadas

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Você está nos ajudando a construir uma web melhor
mr2022-onboarding-gratitude-subtitle = Obrigado por usar o { -brand-short-name }, respaldado pela Fundação BrowserWorks. Com seu apoio, estamos trabalhando para tornar a internet mais aberta, acessível e melhor para todos.
mr2022-onboarding-gratitude-primary-button-label = Veja as novidades
mr2022-onboarding-gratitude-secondary-button-label = Iniciar navegação

## Onboarding spotlight for infrequent users

onboarding-infrequent-import-title = Sinta-se em casa
onboarding-infrequent-import-subtitle = Seja se instalando ou apenas de passagem, lembre que pode importar seus favoritos, senhas e mais.
onboarding-infrequent-import-primary-button = Importar para o { -brand-short-name }

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

mr2022-onboarding-pin-image-alt =
    .aria-label = Pessoa trabalhando em um notebook, cercada por estrelas e flores
mr2022-onboarding-default-image-alt =
    .aria-label = Pessoa abraçando o logotipo do { -brand-product-name }
mr2022-onboarding-import-image-alt =
    .aria-label = Pessoa andando de skate com uma caixa de ícones de software
mr2022-onboarding-mobile-download-image-alt =
    .aria-label = Sapos pulando em lírios com um código QR no centro para baixar o { -brand-product-name } para celular
mr2022-onboarding-pin-private-image-alt =
    .aria-label = Uma varinha mágica faz o logotipo de navegação privativa do { -brand-product-name } sair de dentro de um chapéu
mr2022-onboarding-privacy-segmentation-image-alt =
    .aria-label = Duas mãos de peles clara e escura se cumprimentando
mr2022-onboarding-gratitude-image-alt =
    .aria-label = Vista de um pôr do sol através de uma janela, com uma raposa e um vaso de planta no parapeito da janela
mr2022-onboarding-colorways-image-alt =
    .aria-label = Um spray manual pinta uma colagem colorida de um olho verde, um sapato laranja, uma bola de basquete vermelha, fones de ouvido roxos, um coração azul e uma coroa amarela

## Device migration onboarding

onboarding-device-migration-image-alt =
    .aria-label = Uma raposa acenando na tela de um notebook. O notebook tem um mouse conectado.
onboarding-device-migration-title = Bom ver você de volta!
onboarding-device-migration-subtitle = Entre na sua { -fxaccount-brand-name(capitalization: "sentence") } para ter com você seus favoritos, senhas e histórico em seu novo dispositivo.
onboarding-device-migration-subtitle2 = Entre na sua conta para ter seus favoritos, senhas e histórico em seu novo dispositivo.
onboarding-device-migration-primary-button-label = Entrar
