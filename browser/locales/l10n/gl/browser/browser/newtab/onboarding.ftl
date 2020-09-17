# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Máis información
onboarding-button-label-get-started = Comezar

## Welcome modal dialog strings

onboarding-welcome-header = Benvida ao { -brand-short-name }
onboarding-welcome-body = Ten o navegador.<br/>Coñeza o resto de { -brand-product-name }.
onboarding-welcome-learn-more = Aprenda máis sobre os beneficios.
onboarding-welcome-modal-get-body = Ten o navegador. <br/> Obteña o máximo proveito de { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Sobrecargue a súa protección de privacidade.
onboarding-welcome-modal-privacy-body = Ten o navegador. Engadimos máis protección de privacidade.
onboarding-welcome-modal-family-learn-more = Aprenda sobre a familia de produtos { -brand-product-name }.
onboarding-welcome-form-header = Comece aquí
onboarding-join-form-body = Introduza o seu enderezo de correo electrónico para comezar.
onboarding-join-form-email =
    .placeholder = Introduza o correo electrónico
onboarding-join-form-email-error = Requírese un correo válido
onboarding-join-form-legal = Ao continuar, acepta os <a data-l10n-name="terms">Termos do servizo</a> e a <a data-l10n-name="privacy">Política de privacidade</a>.
onboarding-join-form-continue = Continuar
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Xa ten unha conta?
# Text for link to submit the sign in form
onboarding-join-form-signin = Identificarse
onboarding-start-browsing-button-label = Iniciar a navegación
onboarding-cards-dismiss =
    .title = Rexeitar
    .aria-label = Rexeitar

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Benvido a <span data-l10n-name = "zap"> { -brand-short-name } </span>
onboarding-multistage-welcome-subtitle = O navegador rápido, seguro e privado apoiado por unha organización sen ánimo de lucro.
onboarding-multistage-welcome-primary-button-label = Comece a configuración
onboarding-multistage-welcome-secondary-button-label = Identificarse
onboarding-multistage-welcome-secondary-button-text = Ten unha conta?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importe os seus contrasinais, <br/>marcadores e <span data-l10n-name = "zap">máis</span>
onboarding-multistage-import-subtitle = Procede doutro navegador? É fácil traelo todo a { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Comece a importar
onboarding-multistage-import-secondary-button-label = Agora non
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Os sitios enumerados aquí atopáronse neste dispositivo. { -brand-short-name } non garda ou sincroniza datos doutro navegador a menos que vostede opte por importalos.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Primeiros pasos: pantalla { $current } de { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Escolla un <span data-l10n-name = "zap">aspecto</span>
onboarding-multistage-theme-subtitle = Personalice { -brand-short-name } cun tema.
onboarding-multistage-theme-primary-button-label = Garde o tema
onboarding-multistage-theme-secondary-button-label = Agora non
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automático
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Usar o tema do sistema
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
    .title = Herdar o aspecto do seu sistema operativo para botóns, menús e xanelas.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Use un aspecto claro para os botóns,
        menús e xanelas.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Use un aspecto escuro para botóns,
        menús e xanelas.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Use un aspecto colorido para botóns,
        menús e xanelas.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title = Herdar o aspecto do seu sistema operativo para botóns, menús e xanelas.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description = Herdar o aspecto do seu sistema operativo para botóns, menús e xanelas.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Use un aspecto claro para os botóns,
        menús e xanelas.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Use un aspecto claro para os botóns,
        menús e xanelas.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Use un aspecto escuro para botóns,
        menús e xanelas.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Use un aspecto escuro para botóns,
        menús e xanelas.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Use un aspecto colorido para botóns,
        menús e xanelas.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Use un aspecto colorido para botóns,
        menús e xanelas.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Comecemos a explorar todo o que pode facer.
onboarding-fullpage-form-email =
    .placeholder = O seu enderezo de correo...

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Leve o { -brand-product-name } consigo
onboarding-sync-welcome-content = Acceda aos seus marcadores, historial, contrasinais e outras configuracións en todos os seus dispositivos.
onboarding-sync-welcome-learn-more-link = Obteña máis información sobre as contas Firefox
onboarding-sync-form-input =
    .placeholder = Correo electrónico
onboarding-sync-form-continue-button = Continuar
onboarding-sync-form-skip-login-button = Ignorar este paso

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Escriba o seu correo
onboarding-sync-form-sub-header = para continuar a { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Faga cousas cunha familia de ferramentas que respecte a súa privacidade nos seus dispositivos.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Todo o que facemos honra a nosa Promesa de datos persoais: Tomar menos. Mantelo a salvo. Sen segredos.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Leve os seus marcadores, contrasinais, historial e moito máis onde queira que use { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Reciba notificacións cando a información persoal se atope nunh vulneración de datos coñecida.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Xestionar contrasinais protexidos e portátiles.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Protección contra o rastreo
onboarding-tracking-protection-text2 = { -brand-short-name } axuda a impedir que os sitios web rastrexen a súa presentza na Rede, facendo máis difícil que os anuncios o sigan ao redor do web.
onboarding-tracking-protection-button2 = Como funciona
onboarding-data-sync-title = Leve a súa configuración con vostede
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sincronice os seus marcadores, contrasinais e moito máis onde queira que use { -brand-product-name }.
onboarding-data-sync-button2 = Conectarse a { -sync-brand-short-name }
onboarding-firefox-monitor-title = Estea alerta sobre vulneracións de datos
onboarding-firefox-monitor-text2 = { -monitor-brand-name } supervisa se o seu correo electrónico apareceu nunha vulneración de datos coñecida e avisa se aparece nunha vulneración nova.
onboarding-firefox-monitor-button = Inscríbase para alertas
onboarding-browse-privately-title = Navegar privadamente
onboarding-browse-privately-text = A navegación privada elimina o historial de busca e de navegación para mantelo en segredo de calquera que use o seu ordenador.
onboarding-browse-privately-button = Abrir unha xanela privada
onboarding-firefox-send-title = Manteña os seus ficheiros compartidos privados
onboarding-firefox-send-text2 = Cargue os seus ficheiros no { -send-brand-name } para compartilos con cifrado de punta a punta e unha ligazón que caduca automaticamente.
onboarding-firefox-send-button = Probe { -send-brand-name }
onboarding-mobile-phone-title = Obter { -brand-product-name } no seu teléfono
onboarding-mobile-phone-text = Descargue { -brand-product-name } para iOS ou Android e sincronice os seus datos entre os dispositivos.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Descargue o navegador móbil
onboarding-send-tabs-title = Envíese lapelas a vostede mesmo ao instante
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Comparta facilmente páxinas entre os seus dispositivos sen ter que copiar ligazóns nin deixar o navegador.
onboarding-send-tabs-button = Comece a usar lapelas de envío
onboarding-pocket-anywhere-title = Lea e escoite en calquera lugar
onboarding-pocket-anywhere-text2 = Garde o seu contido favorito fóra da rede coa aplicación { -pocket-brand-name } e lea, escoite e mire cando sexa cómodo para vostede.
onboarding-pocket-anywhere-button = Probe { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Crear e almacenar contrasinais fortes
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } cree contrasinais contidos e gárdeos todos eles nun só lugar.
onboarding-lockwise-strong-passwords-button = Xestionar os seus inicios de sesión
onboarding-facebook-container-title = Establecer límites con Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } mantén o seu perfil separado de todo o que faga máis difícil que Facebook o axude cos anuncios.
onboarding-facebook-container-button = Engada a extensión
onboarding-import-browser-settings-title = Importe os seus favoritos, contrasinais e moito máis
onboarding-import-browser-settings-text = Mergúllese de cheo—traia con facilidade os seus sitios e configuracións de Chrome.
onboarding-import-browser-settings-button = Importar datos de Chrome
onboarding-personal-data-promise-title = Privado por deseño
onboarding-personal-data-promise-text = { -brand-product-name } trata os seus datos con respecto ao tomar menos elementos, protexelos e ter claro como o usamos.
onboarding-personal-data-promise-button = Lea a nosa Promesa

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Ben, xa ten o { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Agora deixámoslle <icon></icon> <b> { $addon-name }. </b>
return-to-amo-extension-button = Engadir a extensión
return-to-amo-get-started-button = Comece con { -brand-short-name }
