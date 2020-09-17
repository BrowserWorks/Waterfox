# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Ne saber mai
onboarding-button-label-get-started = Per començar

## Welcome modal dialog strings

onboarding-welcome-header = La benvenguda a { -brand-short-name }
onboarding-welcome-body = Avètz ja lo navegador.<br/>Descobrissètz la rèsta de { -brand-product-name }.
onboarding-welcome-learn-more = Mai d’informacion suls avantatges.
onboarding-welcome-modal-get-body = Avètz ja lo navegador.<br/>Ara aprofechatz de tot { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Maximalizatz vòstra proteccion privada.
onboarding-welcome-modal-privacy-body = Avètz ja lo navegador. Ara ajustem mai de proteccion de la vida privada.
onboarding-welcome-modal-family-learn-more = Ne saber mai sus la familha de produches { -brand-product-name }.
onboarding-welcome-form-header = Començatz aquí
onboarding-join-form-body = Picatz vòstra adreça electronica per començar.
onboarding-join-form-email =
    .placeholder = Picatz una adreça electronica
onboarding-join-form-email-error = Cal una adreça electronica valida
onboarding-join-form-legal = Se contunhatz, acceptatz las <a data-l10n-name="terms">Condicions d’utilizacion</a> e l’<a data-l10n-name="privacy">Avís de privacitat</a>.
onboarding-join-form-continue = Contunhar
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = Avètz ja un compte ?
# Text for link to submit the sign in form
onboarding-join-form-signin = Connectatz-vos
onboarding-start-browsing-button-label = Començar de navegar
onboarding-cards-dismiss =
    .title = Tirar
    .aria-label = Tirar

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = La benvenguda dins <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = Lo navegador rapid, segur e privat sostengut per una organizacion sens tòca lucrativa.
onboarding-multistage-welcome-primary-button-label = Començar la configuracion
onboarding-multistage-welcome-secondary-button-label = Se connectar
onboarding-multistage-welcome-secondary-button-text = Avètz un compte ?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importatz los senhals, <br/>marcapaginas, e <span data-l10n-name="zap">mai</span>
onboarding-multistage-import-subtitle = Venètz d’un autre navegador ? O importar tot a { -brand-short-name } es facil.
onboarding-multistage-import-primary-button-label = Començar l’import
onboarding-multistage-import-secondary-button-label = Pas ara
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Avèm trobat los sites listats aquí sul periferic. { -brand-short-name } garda o sincroniza pas las donadas de cap autre navegador levat se causissètz de las importar.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Primièrs passes : ecran { $current } sus { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Causissètz una <span data-l10n-name="zap">aparéncia</span>
onboarding-multistage-theme-subtitle = Personalizatz { -brand-short-name } amb un tèma.
onboarding-multistage-theme-primary-button-label = Enregistrar tèma
onboarding-multistage-theme-secondary-button-label = Pas ara
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automatic
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Utilizar lo tèma sistèma
onboarding-multistage-theme-label-light = Clar
onboarding-multistage-theme-label-dark = Escur
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Heretar de l’aparéncia del sistèma operatiu
        pels botons, menús e las fenèstras.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Utilizar una aparéncia clara pels
        botons, menús e las fenèstras.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Utilizar una aparéncia fosca pels
        botons, menús e las fenèstras.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Utilizar una aparéncia colorada pels
        botons, menús e las fenèstras.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Heretar de l’aparéncia del sistèma operatiu
        pels botons, menús e las fenèstras.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Heretar de l’aparéncia del sistèma operatiu
        pels botons, menús e las fenèstras.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Utilizar una aparéncia clara pels
        botons, menús e las fenèstras.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Utilizar una aparéncia clara pels
        botons, menús e las fenèstras.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Utilizar una aparéncia fosca pels
        botons, menús e las fenèstras.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Utilizar una aparéncia fosca pels
        botons, menús e las fenèstras.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Utilizar una aparéncia colorada pels
        botons, menús e las fenèstras.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Utilizar una aparéncia colorada pels
        botons, menús e las fenèstras.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Descobrissèm tot çò que podètz far.
onboarding-fullpage-form-email =
    .placeholder = Vòstra adreça electronica…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Emportatz { -brand-product-name } amb vos
onboarding-sync-welcome-content = Accedissètz als marcapaginas, istoric, senhals d’autres paramètres de totes vòstres periferics.
onboarding-sync-welcome-learn-more-link = Mai d’explicacions tocant los comptes Firefox
onboarding-sync-form-input =
    .placeholder = Adreça electronica
onboarding-sync-form-continue-button = Contunhar
onboarding-sync-form-skip-login-button = Passar aquesta etapa

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Picatz vòstra adreça electronica
onboarding-sync-form-sub-header = per contunhar amb { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Melhoratz la productiviatat amb una familha d'aisinas que respèctan vòstra vida privada sus totes vòstres periferics.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Tot çò que fasèm respècta nòstra « promesa al subjècte de las donadas personalas »  : reculhir mens de donadas. Las protegir e cap de secrèt.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Emportatz vòstres marcapaginas, senhals, istoric e mai pertot ont utilizatz { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Recebètz una notification quand vòstras informacions personalas se trapan dins una violacion de donadas coneguda.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }{ -lockwise-brand-short-name }{ -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Gerissètz vòstres senhals protegits e portables.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Proteccion contra lo seguiment
onboarding-tracking-protection-text2 = { -brand-short-name } empacha que los sites web vos pisten en linha, fa venir complicat que la publicitat vos pòsca seguir per Internet.
onboarding-tracking-protection-button2 = Cossí fonciona
onboarding-data-sync-title = Emportatz vòstres paramètres pertot
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sincronizatz los marcapaginas, senhals e encara mai pertot ont utilizatz { -brand-product-name }.
onboarding-data-sync-button2 = Se connectar a { -sync-brand-short-name }
onboarding-firefox-monitor-title = Siatz al fial de las pèrdas de donadas
onboarding-firefox-monitor-text2 = { -monitor-brand-name } verifica se vòstra adreça electronica apareis dins una pèrda de donadas e vos alèrta s’apareis dins una nòva divulgacion.
onboarding-firefox-monitor-button = S’abonar a las alèrtas
onboarding-browse-privately-title = Navegatz d’un biais privat
onboarding-browse-privately-text = La navegacion privada escafa vòstre istoric de recèrcas e de navegacion per los gardar secrets de monde qu’utilizan vòstre ordenador.
onboarding-browse-privately-button = Dobrir una fenèstra de navegacion privada
onboarding-firefox-send-title = Gardatz privats los fichièrs que partejatz
onboarding-firefox-send-text2 = Enviatz vòstres fichièrs amb { -send-brand-name } per los partejar amb un chiframent del cap a la fin e un ligam qu’expira automaticament.
onboarding-firefox-send-button = Ensajatz { -send-brand-name }
onboarding-mobile-phone-title = Installatz { -brand-product-name } sus vòstre mobil
onboarding-mobile-phone-text = Telecargatz { -brand-product-name } per iOS o Android e sincronizatz vòstras donadas entre periferics.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Telecargar lo navegador mobil
onboarding-send-tabs-title = Enviatz-vos d’onglets
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Partejatz aisidament de paginas entre vòstres periferics sens aver a copiar los ligams o quitar lo navegador.
onboarding-send-tabs-button = Començar d’utilizar « Enviar l’onglet »
onboarding-pocket-anywhere-title = Legissètz e escotatz pertot
onboarding-pocket-anywhere-text2 = Enregistratz vòstre contengut preferit fòra linha amb l’aplicacion { -pocket-brand-name } per lo legir, escotar e gaitar quand vos agrada.
onboarding-pocket-anywhere-button = Ensajar { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Creatz e gardatz de senhals fòrts.
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } crèa de senhals fòrts sul pic e los garda en un sòl lòc.
onboarding-lockwise-strong-passwords-button = Gerir vòstres identificants
onboarding-facebook-container-title = Botatz de limitas amb Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } garda vòstre perfil separat de la rèsta, fa venir mai dificil per Facebook de vos ciblar amb de publicitats personalizadas.
onboarding-facebook-container-button = Apondre l’extension
onboarding-import-browser-settings-title = Importatz vòstres marcapaginas, senhals, e encara mai
onboarding-import-browser-settings-text = Emportatz aisidament vòstres sites e paramètres Chrome.
onboarding-import-browser-settings-button = Importar las donadas de Chrome
onboarding-personal-data-promise-title = Concebut per la confidencialitat
onboarding-personal-data-promise-text = { -brand-product-name } tracta vòstras donadas amb respècte en ne prendre mes, en las protegir e en èsser clar a prepaus de lor utilizacion.
onboarding-personal-data-promise-button = Legir nòstra promessa

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Qué crane, avètz { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Ara anem vos installar <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Apondre l’extension
return-to-amo-get-started-button = Ben començar amb { -brand-short-name }
