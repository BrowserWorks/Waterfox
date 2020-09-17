# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Conocer más
onboarding-button-label-get-started = Comenzar

## Welcome modal dialog strings

onboarding-welcome-header = Bienvenido a { -brand-short-name }
onboarding-welcome-body = Tiene el navegador. <br/> Conozca el resto de { -brand-product-name }.
onboarding-welcome-learn-more = Conocer más sobre las ventajas.
onboarding-welcome-modal-get-body = Ya tiene el navegador. <br/> Ahora aproveche al máximo { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Sobrecargá la protección de su privacidad.
onboarding-welcome-modal-privacy-body = Tiene el navegador. Agreguemos más protección de privacidad.
onboarding-welcome-modal-family-learn-more = Obtenga información sobre la familia de productos { -brand-product-name }.
onboarding-welcome-form-header = Empezar aquí
onboarding-join-form-body = Para empezar, ingrese su dirección de correo electrónico.
onboarding-join-form-email =
    .placeholder = Ingresar la dirección de correo electrónico
onboarding-join-form-email-error = Se requiere una dirección de correo electrónico válida
onboarding-join-form-legal = Al continuar, acepta los <a data-l10n-name="terms">Términos del servicio</a> y <a data-l10n-name="privacy">la Nota de privacidad</a>.
onboarding-join-form-continue = Continuar
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = ¿Ya tiene una cuenta?
# Text for link to submit the sign in form
onboarding-join-form-signin = Iniciar sesión
onboarding-start-browsing-button-label = Empiece a navegar
onboarding-cards-dismiss =
    .title = Descartar
    .aria-label = Descartar

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Bienvenido a <span data-l10n-name = "zap"> { -brand-short-name } </span>
onboarding-multistage-welcome-subtitle = El navegador rápido, seguro y privado respaldado por una organización sin fines de lucro.
onboarding-multistage-welcome-primary-button-label = Iniciar configuración
onboarding-multistage-welcome-secondary-button-label = Iniciar sesión
onboarding-multistage-welcome-secondary-button-text = ¿Tiene una cuenta?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importe sus contraseñas, marcadores y <span data-l10n-name="zap">más</span>
onboarding-multistage-import-subtitle = ¿Viene de otro navegador? Es fácil llevar todo a { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Iniciar importación
onboarding-multistage-import-secondary-button-label = Ahora no
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = En este dispositivo se encontraron estos sitios. { -brand-short-name } no guarda ni sincroniza datos de otro navegador a menos que usted elija importarlo.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Primeros pasos: pantalla { $current } de { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Elija un aspecto<span data-l10n-name="zap"></span>
onboarding-multistage-theme-subtitle = Personalice { -brand-short-name } con un tema.
onboarding-multistage-theme-primary-button-label = Guardar tema
onboarding-multistage-theme-secondary-button-label = Ahora no
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automático
# System refers to the operating system
onboarding-multistage-theme-description-automatic = Usar tema del sistema
onboarding-multistage-theme-label-light = Claro
onboarding-multistage-theme-label-dark = Oscuro
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic =
    .title =
        Heredar la apariencia de su sistema
        operativo para botones, menús y ventanas.
    .aria-label = { onboarding-multistage-theme-tooltip-automatic.title }
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light =
    .title =
        Usar una apariencia clara para botones, 
        menús y ventanas.
    .aria-label = { onboarding-multistage-theme-tooltip-light.title }
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark =
    .title =
        Usar una apariencia oscura para botones, 
        menús y ventanas.
    .aria-label = { onboarding-multistage-theme-tooltip-dark.title }
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow =
    .title =
        Usar una apariencia colorida para botones,
        menús y ventanas.
    .aria-label = { onboarding-multistage-theme-tooltip-alpenglow.title }
# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Usar la apariencia del sistema operativo
        para botones, menúes y ventanas.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Usar la apariencia del sistema operativo
        para botones, menúes y ventanas.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Usar una apariencia clara para botones,
        menúes y ventanas.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Usar una apariencia clara para botones, 
        menúes y ventanas.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Usar una apariencia oscura para botones,
        menúes y ventanas.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Usar una apariencia oscura para botones, 
        menúes y ventanas.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Usar una apariencia colorida para botones,
        menúes y ventanas.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Usar una apariencia colorida para botones,
        menúes y ventanas.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Comencemos a explorar todo lo que puede hacer.
onboarding-fullpage-form-email =
    .placeholder = Su dirección de correo electrónico…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Lleve { -brand-product-name } con usted
onboarding-sync-welcome-content = Acceda a sus marcadores, historial, contraseñas y más ajustes en todos sus dispositivos.
onboarding-sync-welcome-learn-more-link = Descubrí más sobre las Cuentas de Firefox
onboarding-sync-form-input =
    .placeholder = Correo electrónico
onboarding-sync-form-continue-button = Continuar
onboarding-sync-form-skip-login-button = Saltear este paso

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Ingrese su correo electrónico
onboarding-sync-form-sub-header = para pasar a { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Haga las cosas con una grupo de herramientas que respete su privacidad en todos sus dispositivos.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Todo lo que hacemos respeta nuestra Promesa de datos personales: Toma menos información. La mantiene segura. Sin secretos.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Lleve sus marcadores, contraseñas, historial y más a todos los lugares donde usa { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Recibí notificaciones cuando tu información personal se encuentre en una violación de datos conocida.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Administrar contraseñas que sean protegidas y portátiles.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Protección contra rastreo
onboarding-tracking-protection-text2 = { -brand-short-name } lo ayuda a impedir que los sitios lo rastreen en línea, por lo que será más difícil que la publicidad lo siga mientras navega.
onboarding-tracking-protection-button2 = Cómo funciona
onboarding-data-sync-title = Lleve sus configuraciones con usted
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sincronice sus marcadores, contraseñas y mucho más use { -brand-product-name } donde lo use.
onboarding-data-sync-button2 = Ingresar a { -sync-brand-short-name }
onboarding-firefox-monitor-title = Manténgase alerta a las violaciones de datos
onboarding-firefox-monitor-text2 = { -monitor-brand-name } controla si su dirección de correo apareció en una violación de datos y le avisa si aparece en una nueva violación.
onboarding-firefox-monitor-button = Registrarse para recibir alertas
onboarding-browse-privately-title = Navegación privada
onboarding-browse-privately-text = La navegación privada borra las búsquedas y el historial de navegación para mantenerlo en secreto para cualquier persona que use la computadora.
onboarding-browse-privately-button = Abrir una ventana privada
onboarding-firefox-send-title = Mantenga privados sus archivos compartidos
onboarding-firefox-send-text2 = Suba sus archivos a { -send-brand-name } para compartirlos con cifrado de punta  a punta y un enlace que vence automáticamente.
onboarding-firefox-send-button = Probar { -send-brand-name }
onboarding-mobile-phone-title = Obtener { -brand-product-name } en el teléfono
onboarding-mobile-phone-text = Descargue { -brand-product-name } para iOS o Android y sincronice sus datos en todos los dispositivos.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Descargar navegador móvil
onboarding-send-tabs-title = Envíese las pestañas instantáneamente
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Comparta fácilmente páginas entre sus dispositivos sin tener que copiar enlaces o cerrar el navegador.
onboarding-send-tabs-button = Empiece a usar Send Tabs
onboarding-pocket-anywhere-title = Leer y escuchar en cualquier lugar
onboarding-pocket-anywhere-text2 = Guarde su contenido favorito sin conexión gracias a la aplicación { -pocket-brand-name } y léalo, escúchelo o véalo dónde y cuándo mejor le convenga.
onboarding-pocket-anywhere-button = Probar { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Crear y almacenar contraseñas seguras
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } crea contraseñas seguras en el acto y las guarda en un solo lugar.
onboarding-lockwise-strong-passwords-button = Administre sus inicios de sesión
onboarding-facebook-container-title = Configure límites con Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } separa su perfil de todo lo demás, haciendo más difícil que Facebook pueda mostrarle publicidad.
onboarding-facebook-container-button = Agregar la extensión
onboarding-import-browser-settings-title = Importe sus marcadores, contraseñas y más
onboarding-import-browser-settings-text = Métase por completo: lleve fácilmente sus sitios y configuraciones de Chrome con usted.
onboarding-import-browser-settings-button = Importar datos de Chrome
onboarding-personal-data-promise-title = Privado por diseño
onboarding-personal-data-promise-text = { -brand-product-name } trata sus datos con respeto al tomar menos, protegerlos y tener claro cómo los usamos.
onboarding-personal-data-promise-button = Lea nuestra promesa

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Excelente, tienes { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Ahora vamos a conseguirte <icon></icon><b>{ $addon-name }. </b>
return-to-amo-extension-button = Agregar la extensión
return-to-amo-get-started-button = Empezá con { -brand-short-name }
