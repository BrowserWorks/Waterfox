# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Saiba mais
onboarding-button-label-get-started = Começar

## Welcome modal dialog strings

onboarding-welcome-header = Boas-vindas ao { -brand-short-name }
onboarding-welcome-body = Você instalou o navegador.<br/>Conheça outros produtos e serviços { -brand-product-name }.
onboarding-welcome-learn-more = Saiba mais sobre os benefícios.
onboarding-welcome-modal-get-body = Você instalou o navegador.<br/>Agora aproveite ao máximo o { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Potencialize sua proteção de privacidade.
onboarding-welcome-modal-privacy-body = Você instalou o navegador. Vamos adicionar mais proteção de privacidade.
onboarding-welcome-modal-family-learn-more = Saiba mais sobre a família de produtos  { -brand-product-name }.
onboarding-welcome-form-header = Início
onboarding-join-form-body = Digite seu endereço de e-mail para começar.
onboarding-join-form-email =
    .placeholder = Digite seu e-mail
onboarding-join-form-email-error = É necessário um e-mail válido
onboarding-join-form-legal = Ao continuar, você concorda com os <a data-l10n-name="terms">Termos do serviço</a> e o <a data-l10n-name="privacy">Aviso de privacidade</a>.
onboarding-join-form-continue = Continuar
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Já tem uma conta?
# Text for link to submit the sign in form
onboarding-join-form-signin = Entrar
onboarding-start-browsing-button-label = Comece a navegar
onboarding-cards-dismiss =
    .title = Dispensar
    .aria-label = Dispensar

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Boas-vindas ao <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = O navegador rápido, seguro e privativo, produzido por uma organização sem fins lucrativos.
onboarding-multistage-welcome-primary-button-label = Iniciar configuração
onboarding-multistage-welcome-secondary-button-label = Entrar
onboarding-multistage-welcome-secondary-button-text = Já tem uma conta?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importe suas senhas, favoritos e <span data-l10n-name="zap">mais</span>
onboarding-multistage-import-subtitle = Vindo de outro navegador? É fácil trazer tudo para o { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Iniciar importação
onboarding-multistage-import-secondary-button-label = Agora não
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Os sites listados aqui foram encontrados neste dispositivo. O { -brand-short-name } não salva nem sincroniza dados de outro navegador, a menos que você escolha importar.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Introdução: tela { $current } de { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Escolha uma <span data-l10n-name="zap">aparência</span>
onboarding-multistage-theme-subtitle = Personalize o { -brand-short-name } com um tema.
onboarding-multistage-theme-primary-button-label = Salvar tema
onboarding-multistage-theme-secondary-button-label = Agora não
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automático
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Usar tema do sistema
onboarding-multistage-theme-label-light = Claro
onboarding-multistage-theme-label-dark = Escuro
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title = Herdar a aparência do seu sistema operacional em botões, menus e janelas.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title = Usar uma aparência clara em botões, menus e janelas.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title = Usar uma aparência escura em botões, menus e janelas.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title = Usar uma aparência colorida em botões, menus e janelas.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title = Herdar a aparência do seu sistema operacional em botões, menus e janelas.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = Herdar a aparência do seu sistema operacional em botões, menus e janelas.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title = Usar uma aparência clara em botões, menus e janelas.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description = Usar uma aparência clara em botões, menus e janelas.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title = Usar uma aparência escura em botões, menus e janelas.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description = Usar uma aparência escura em botões, menus e janelas.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title = Usar uma aparência colorida em botões, menus e janelas.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description = Usar uma aparência colorida em botões, menus e janelas.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Vamos descobrir tudo o que você pode fazer.
onboarding-fullpage-form-email =
    .placeholder = Seu endereço de e-mail…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Leve o { -brand-product-name } com você
onboarding-sync-welcome-content = Tenha seus favoritos, histórico, senhas e outras configurações em todos os seus dispositivos.
onboarding-sync-welcome-learn-more-link = Saiba mais sobre a Conta Firefox
onboarding-sync-form-input =
    .placeholder = E-mail
onboarding-sync-form-continue-button = Continuar
onboarding-sync-form-skip-login-button = Pular essa etapa

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Insira seu email
onboarding-sync-form-sub-header = para continuar com o { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Faça as coisas com uma família de ferramentas que respeita sua privacidade em todos os seus dispositivos.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Tudo o que fazemos honra nossa promessa de como lidar com dados pessoais: Coletar pouco. Manter seguro. Sem segredos.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Tenha seus favoritos, senhas, histórico e muito mais onde quer que use o { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Seja notificado quando suas informações pessoais estiverem em um vazamento de dados conhecido.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Gerencie suas senhas de modo protegido e portátil.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Proteção contra rastreamento
onboarding-tracking-protection-text2 = O { -brand-short-name } ajuda a impedir que sites rastreiem você online, dificultando aos anúncios seguir você pela web.
onboarding-tracking-protection-button2 = Como funciona
onboarding-data-sync-title = Leve suas configurações com você
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sincronize favoritos, senhas e outras coisas em todo lugar que usar o { -brand-product-name }.
onboarding-data-sync-button2 = Entre no { -sync-brand-short-name }
onboarding-firefox-monitor-title = Fique atento a vazamentos de dados
onboarding-firefox-monitor-text2 = O { -monitor-brand-name } verifica se seu e-mail apareceu em um vazamento de dados conhecido e envia um alerta caso apareça em um novo vazamento.
onboarding-firefox-monitor-button = Cadastre-se para receber alertas
onboarding-browse-privately-title = Navegue com privacidade
onboarding-browse-privately-text = A navegação privativa limpa seu histórico de pesquisa e navegação para manter em segredo de qualquer um que use o computador.
onboarding-browse-privately-button = Abrir uma janela privativa
onboarding-firefox-send-title = Mantenha privativos seus arquivos compartilhados
onboarding-firefox-send-text2 = Envie seus arquivos para pelo { -send-brand-name } para compartilhar com criptografia de ponta a ponta e um link que expira automaticamente.
onboarding-firefox-send-button = Experimente o { -send-brand-name }
onboarding-mobile-phone-title = Instale o { -brand-product-name } no seu celular
onboarding-mobile-phone-text = Baixe o { -brand-product-name } para iOS ou Android e sincronize seus dados entre dispositivos.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Baixe o navegador para celular
onboarding-send-tabs-title = Envie abas para si mesmo instantaneamente
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Compartilhe páginas facilmente entre seus dispositivos sem precisar copiar links ou sair do navegador.
onboarding-send-tabs-button = Comece a usar o envio de abas
onboarding-pocket-anywhere-title = Leia e ouça em qualquer lugar
onboarding-pocket-anywhere-text2 = Salve localmente seus conteúdos preferidos com o aplicativo { -pocket-brand-name } e leia, ouça ou assista quando for conveniente para você.
onboarding-pocket-anywhere-button = Experimente o { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Crie e armazene senhas fortes
onboarding-lockwise-strong-passwords-text = O { -lockwise-brand-name } cria senhas fortes no local e salva todas elas em um só lugar.
onboarding-lockwise-strong-passwords-button = Gerencie suas contas de acesso
onboarding-facebook-container-title = Defina limites para o Facebook
onboarding-facebook-container-text2 = O { -facebook-container-brand-name } mantém seu perfil separado de tudo mais, tornando mais difícil para o Facebook direcionar propaganda para você.
onboarding-facebook-container-button = Adicionar a extensão
onboarding-import-browser-settings-title = Importe seus favoritos, senhas e muito mais
onboarding-import-browser-settings-text = Mergulhe direto - leve com facilidade seus sites e configurações do Chrome com você.
onboarding-import-browser-settings-button = Importar dados do Chrome
onboarding-personal-data-promise-title = Projetado para privacidade
onboarding-personal-data-promise-text = A { -brand-product-name } trata seus dados com respeito: coletamos menos, protegemos e deixamos claro como os usamos.
onboarding-personal-data-promise-button = Leia nosso compromisso

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Ótimo, você tem o { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Agora experimente o <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Adicionar a extensão
return-to-amo-get-started-button = Primeiros passos com { -brand-short-name }
