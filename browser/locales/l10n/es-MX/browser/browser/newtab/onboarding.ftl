# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Más información
onboarding-button-label-get-started = Comenzar

## Welcome modal dialog strings

onboarding-welcome-header = Bienvenido a { -brand-short-name }
onboarding-welcome-body = Conseguiste el navegador.<br/>Conoce el resto de la familia { -brand-product-name }.
onboarding-welcome-learn-more = Conoce más sobre los beneficios.
onboarding-welcome-modal-get-body = Tienes el navegador.<br/>Ahora sácale el máximo provecho a { -brand-product-name }.
onboarding-welcome-modal-supercharge-body = Maximiza tu protección de privacidad.
onboarding-welcome-modal-privacy-body = Tienes el navegador. Ahora agrega más protección de privacidad.
onboarding-welcome-modal-family-learn-more = Conoce acerca de la familia de productos de { -brand-product-name }.
onboarding-welcome-form-header = Comienza aquí
onboarding-join-form-body = Ingresa tu correo para comenzar.
onboarding-join-form-email =
    .placeholder = Ingresa tu correo
onboarding-join-form-email-error = Se necesita un correo válido
onboarding-join-form-legal = Al proceder, estás de acuerdo con los <a data-l10n-name="terms">Términos de Servicios</a> y el <a data-l10n-name="privacy">Aviso de Privacidad</a>.
onboarding-join-form-continue = Continuar
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = ¿Ya tienes una cuenta?
# Text for link to submit the sign in form
onboarding-join-form-signin = Iniciar sesión
onboarding-start-browsing-button-label = Empieza a navegar
onboarding-cards-dismiss =
    .title = Descartar
    .aria-label = Descartar

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Te damos la bienvenida a <span data-l10n-name = "zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = El navegador rápido, seguro y privado respaldado por una organización sin fines de lucro.
onboarding-multistage-welcome-primary-button-label = Iniciar configuración
onboarding-multistage-welcome-secondary-button-label = Iniciar sesión
onboarding-multistage-welcome-secondary-button-text = ¿Tienes una cuenta?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importa tus contraseñas, <br/>marcadores y <span data-l10n-name = "zap">más</span>
onboarding-multistage-import-subtitle = ¿Vienes de otro navegador? Es fácil traer todo a { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Iniciar importación
onboarding-multistage-import-secondary-button-label = Ahora no
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Los sitios listados aquí fueron encontrados en este dispositivo. { -brand-short-name } no guarda ni sincroniza datos de otro navegador a menos que elijas importarlos.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Primeros pasos: pantalla { $current } de { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Selecciona un <span data-l10n-name="zap">aspecto</span>
onboarding-multistage-theme-subtitle = Personaliza { -brand-short-name } con un tema.
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
        Heredar la apariencia de tu sistema
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
        Heredar la apariencia de tu sistema
        operativo para botones, menús y ventanas.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Heredar la apariencia de tu sistema
        operativo para botones, menús y ventanas.
# Tooltip displayed on hover of light theme
onboarding-multistage-theme-tooltip-light-2 =
    .title =
        Usar una apariencia clara para botones, 
        menús y ventanas.
# Input description for light theme
onboarding-multistage-theme-description-light =
    .aria-description =
        Usar una apariencia clara para botones, 
        menús y ventanas.
# Tooltip displayed on hover of dark theme
onboarding-multistage-theme-tooltip-dark-2 =
    .title =
        Usar una apariencia oscura para botones, 
        menús y ventanas.
# Input description for dark theme
onboarding-multistage-theme-description-dark =
    .aria-description =
        Usar una apariencia oscura para botones, 
        menús y ventanas.
# Tooltip displayed on hover of Alpenglow theme
onboarding-multistage-theme-tooltip-alpenglow-2 =
    .title =
        Usar una apariencia colorida para botones,
        menús y ventanas.
# Input description for Alpenglow theme
onboarding-multistage-theme-description-alpenglow =
    .aria-description =
        Usar una apariencia colorida para botones,
        menús y ventanas.

## Welcome full page string

onboarding-fullpage-welcome-subheader = Comencemos a explorar todo lo que puedes hacer.
onboarding-fullpage-form-email =
    .placeholder = Tu dirección de correo electrónico…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Lleva a { -brand-product-name } contigo
onboarding-sync-welcome-content = Accede a tus marcadores, historial, contraseñas y más ajustes en todos tus dispositivos.
onboarding-sync-welcome-learn-more-link = Conoce más acerca de Firefox Accounts
onboarding-sync-form-input =
    .placeholder = Correo electrónico
onboarding-sync-form-continue-button = Continuar
onboarding-sync-form-skip-login-button = Saltar este paso

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Ingresa tu correo electrónico
onboarding-sync-form-sub-header = para continuar a { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Termina tus pendientes con una familia de herramientas que respeta tu privacidad a través de tus dispositivos.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Todo lo que hacemos respeta nuestra promesa de datos personales: Tomar menos. Mantenerlo seguro. Sin secretos.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Lleva tus marcadores, contraseñas, historial y más a todas partes donde uses { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Recibe notificaciones cuando tu información personal sea encontrada en una filtración de datos conocida.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Administra tus contraseñas manteniéndolas protegidas y contigo.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Protección antirrastreo
onboarding-tracking-protection-text2 = { -brand-short-name } te ayuda a impedir que los sitios web te rastreen en línea, por lo que será más difícil que la publicidad te siga mientras navegas.
onboarding-tracking-protection-button2 = Cómo funciona
onboarding-data-sync-title = Lleva tu configuración contigo
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sincroniza tus marcadores, contraseñas y más donde sea que uses { -brand-product-name }.
onboarding-data-sync-button2 = Inicia sesión en { -sync-brand-short-name }
onboarding-firefox-monitor-title = Mantente alerta de filtraciones de datos
onboarding-firefox-monitor-text2 = { -monitor-brand-name } controla si tu dirección de correo apareció en una filtración de datos conocida y te avisa si aparece en una nueva filtración.
onboarding-firefox-monitor-button = Regístrate para alertas
onboarding-browse-privately-title = Navega con privacidad
onboarding-browse-privately-text = La navegación privada borra tu historial de búsqueda y navegación para mantenerlo en secreto de cualquier persona que use tu computadora.
onboarding-browse-privately-button = Abrir una ventana privada
onboarding-firefox-send-title = Mantén tus archivos compartidos en privado
onboarding-firefox-send-text2 = Subir tus archivos a { -send-brand-name } para compartirlos con una encriptación de punto a punto y un enlace que expira automáticamente.
onboarding-firefox-send-button = Probar { -send-brand-name }
onboarding-mobile-phone-title = Obtener { -brand-product-name } en tu teléfono
onboarding-mobile-phone-text = Descargar { -brand-product-name } para iOS o Android y sincroniza tus datos entre dispositivos.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Descargar navegador para celulares
onboarding-send-tabs-title = Envíate pestañas al instante
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Comparte fácilmente páginas entre tus dispositivos sin tener que copiar, pegar o salir del navegador.
onboarding-send-tabs-button = Empieza a usar Send Tabs
onboarding-pocket-anywhere-title = Lee y escucha en cualquier lugar
onboarding-pocket-anywhere-text2 = Guarda tu contenido favorito para disfrutarlo sin conexión con { -pocket-brand-name }. Lee, escucha y mira lo que quieras, cuando quieras.
onboarding-pocket-anywhere-button = Prueba { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Crea y almacena contraseñas fuertes
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } crea contraseñas fuertes en el acto y las guarda en un único lugar.
onboarding-lockwise-strong-passwords-button = Administra tus inicios de sesión
onboarding-facebook-container-title = Ponle límites a Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } mantiene tu perfil separado de todo lo demás, dificultando que Facebook te dirija anuncios personalizados.
onboarding-facebook-container-button = Añadir la extensión
onboarding-import-browser-settings-title = Importa tus marcadores, contraseñas y más
onboarding-import-browser-settings-text = Sumérgete por completo — lleva fácilmente tus sitios y configuraciones de Chrome contigo.
onboarding-import-browser-settings-button = Importar datos de Chrome
onboarding-personal-data-promise-title = Privado por diseño
onboarding-personal-data-promise-text = { -brand-product-name } trata tus datos con respeto recopilando menos, protegiéndolos e indicando claramente cómo los usamos.
onboarding-personal-data-promise-button = Lee nuestra promesa

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = Excelente, tienes { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Ahora vamos a conseguirte <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Agregar la extensión
return-to-amo-get-started-button = Comenzar con { -brand-short-name }
