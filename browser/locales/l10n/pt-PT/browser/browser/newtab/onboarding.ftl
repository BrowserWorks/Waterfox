# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Saber mais
onboarding-button-label-get-started = Começar

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Bem-vindo(a) ao { -brand-short-name }
onboarding-welcome-body = Já tem o navegador.<br/>Conheça o resto do { -brand-product-name }.
onboarding-welcome-learn-more = Saiba mais acerca dos benefícios.
onboarding-welcome-modal-get-body = Já tem o navegador.<br/>Agora tire o máximo proveito do { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Melhore a sua proteção da privacidade.
onboarding-welcome-modal-privacy-body = Já tem o navegador. Vamos adicionar mais proteção à privacidade.
onboarding-welcome-modal-family-learn-more = Saber mais sobre a família de produtos do { -brand-product-name }.
onboarding-welcome-form-header = Comece aqui
onboarding-join-form-body = Insira o seu endereço de e-mail para começar.
onboarding-join-form-email =
    .placeholder = Insira o e-mail
onboarding-join-form-email-error = É necessário um e-mail válido
onboarding-join-form-legal = Ao continuar, concorda com os <a data-l10n-name="terms">Termos de serviço</a> e o <a data-l10n-name="privacy">Aviso de privacidade</a>.
onboarding-join-form-continue = Continuar
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Já tem uma conta?
# Text for link to submit the sign in form
onboarding-join-form-signin = Iniciar sessão
onboarding-start-browsing-button-label = Começar a navegar
onboarding-cards-dismiss =
    .title = Dispensar
    .aria-label = Dispensar

## Welcome full page string

onboarding-fullpage-welcome-subheader = Vamos começar por explorar tudo o que pode fazer.
onboarding-fullpage-form-email =
    .placeholder = O seu endereço de e-mail…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Leve o { -brand-product-name } consigo
onboarding-sync-welcome-content = Obtenha os seus marcadores, histórico, palavras-passe e outras definições em todos os seus dispositivos.
onboarding-sync-welcome-learn-more-link = Saber mais acerca do Contas Firefox
onboarding-sync-form-input =
    .placeholder = Email
onboarding-sync-form-continue-button = Continuar
onboarding-sync-form-skip-login-button = Saltar este passo

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Introduza o seu email
onboarding-sync-form-sub-header = para continuar para o { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Faça as coisas com a família de ferramentas que respeitam a sua privacidade entre dispositivos.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Tudo o que fazemos honra o nosso compromisso com os dados pessoais: Recolher menos. Manter seguro. Sem segredos.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Leve os seus marcadores, palavras-passe, histórico e muito mais para qualquer lugar onde utilize o { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Seja notificado quando a sua informação pessoal estiver numa violação de dados conhecida.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Faça a gestão de palavras-passe que estão protegidas e portáteis.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Proteção da monitorização
onboarding-tracking-protection-text2 = O { -brand-short-name } ajuda a impedir que os sites o rastreiem na Internet, tornando mais difícil que os anúncios o sigam na web.
onboarding-tracking-protection-button2 = Como funciona
onboarding-data-sync-title = Leve as suas definições consigo
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sincronize os seus marcadores, palavras-passe e mais onde quer que utilize o { -brand-product-name }.
onboarding-data-sync-button2 = Iniciar sessão no { -sync-brand-short-name }
onboarding-firefox-monitor-title = Fique atento(a) às brechas de dados
onboarding-firefox-monitor-text2 = O { -monitor-brand-name } monitoriza se o seu e-mail apareceu numa violação de dados conhecida e avisa-o se este aparecer numa nova violação de dados.
onboarding-firefox-monitor-button = Registar-se para alertas
onboarding-browse-privately-title = Navegue privadamente
onboarding-browse-privately-text = A navegação privada limpa o seu histórico de pesquisa e de navegação para os manter em segredo de quem utiliza o seu computador.
onboarding-browse-privately-button = Abrir uma janela privada
onboarding-firefox-send-title = Mantenha os seus ficheiros privados
onboarding-firefox-send-text2 = Carregue os seus ficheiros para o { -send-brand-name } para os partilhar com encriptação de ponta a ponta e uma ligação que expira automaticamente.
onboarding-firefox-send-button = Experimente o { -send-brand-name }
onboarding-mobile-phone-title = Obtenha o { -brand-product-name } no seu telefone
onboarding-mobile-phone-text = Transfira o { -brand-product-name } para iOS ou Android e sincronize os seus dados entre dispositivos.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Transferir navegador móvel
onboarding-send-tabs-title = Envie separadores para si instantaneamente
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Partilhe de forma fácil páginas entre os seus dispositivos sem ter de copiar ligações ou deixar o navegador.
onboarding-send-tabs-button = Começar a utilizar Enviar separadores
onboarding-pocket-anywhere-title = Leia e oiça em qualquer lugar
onboarding-pocket-anywhere-text2 = Guarde os seu conteúdo favorito offline com a aplicação do { -pocket-brand-name } e leia, ouça e veja quando lhe é conveniente.
onboarding-pocket-anywhere-button = Experimente o { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Crie e armazene palavras-passe seguras
onboarding-lockwise-strong-passwords-text = O { -lockwise-brand-name } cria passwords seguras no momento e guarda-as todas num único local.
onboarding-lockwise-strong-passwords-button = Gerir as suas credenciais
onboarding-facebook-container-title = Defina limites com o Facebook
onboarding-facebook-container-text2 = O { -facebook-container-brand-name } mantém o seu perfil separado de tudo o resto, tornando mais difícil com que o Facebook lhe segmente com anúncios.
onboarding-facebook-container-button = Adicionar a extensão
onboarding-import-browser-settings-title = Importe os seus marcadores, palavras-passe e muito mais
onboarding-import-browser-settings-text = Comece já — traga os seus sites e definições do Chrome consigo.
onboarding-import-browser-settings-button = Importar dados do Chrome
onboarding-personal-data-promise-title = Privacidade desde a conceção
onboarding-personal-data-promise-text = O { -brand-product-name } trata os seus dados com respeito, recolhendo menos, protegendo-os e sendo claro sobre como os utilizamos.
onboarding-personal-data-promise-button = Leia a nossa promessa

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Ótimo, você tem o { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Agora vamos obter-lhe <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Adicionar a extensão
return-to-amo-get-started-button = Começar com o { -brand-short-name }
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
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

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

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Firefox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = O fogo começa aqui
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio - Designer de mobiliário, fã do Firefox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Desativar as animações

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Mantenha o { -brand-short-name } na sua Doca para um acesso mais fácil
       *[other] Fixe o { -brand-short-name } na sua barra de tarefas para um acesso mais fácil
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Manter na Doca
       *[other] Fixar na barra de tarefas
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Começar
mr1-onboarding-welcome-header = Bem-vindo(a) ao { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Definir o { -brand-short-name } como o meu navegador principal
    .title = Define o { -brand-short-name } como o navegador principal e fixa o mesmo à barra de tarefas
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Definir o { -brand-short-name } no meu navegador principal
mr1-onboarding-set-default-secondary-button-label = Agora não
mr1-onboarding-sign-in-button-label = Iniciar sessão

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = Predefinir o { -brand-short-name }
mr1-onboarding-default-subtitle = Coloque a velocidade, segurança e privacidade em piloto automático.
mr1-onboarding-default-primary-button-label = Predefinir o navegador

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Leve tudo consigo
mr1-onboarding-import-subtitle = Importe as suas palavras-passe, <br/>marcadores e muito mais.
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importar de { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importar do navegador anterior
mr1-onboarding-import-secondary-button-label = Agora não
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
