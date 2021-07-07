# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the simplified onboarding modal / about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## These button action text can be split onto multiple lines, so use explicit
## newlines in translations to control where the line break appears (e.g., to
## avoid breaking quoted text).

onboarding-button-label-learn-more = Saber más
onboarding-button-label-get-started = Comenzar

## Welcome modal dialog strings


### UI strings for the simplified onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Bienvenido a { -brand-short-name }
onboarding-welcome-body = Ya tiene el navegador.<br/>Conozca el resto de { -brand-product-name }.
onboarding-welcome-learn-more = Saber más sobre las ventajas.
onboarding-welcome-modal-get-body = Ya tiene el navegador.<br/>Ahora aproveche { -brand-product-name } al máximo.
onboarding-welcome-modal-supercharge-body = Protección de privacidad al máximo nivel.
onboarding-welcome-modal-privacy-body = Ya tiene el navegador. Añadamos más protección de privacidad.
onboarding-welcome-modal-family-learn-more = Conozca más sobre la familia de productos { -brand-product-name }.
onboarding-welcome-form-header = Empezar aquí
onboarding-join-form-body = Para empezar, introduzca su dirección de correo.
onboarding-join-form-email =
    .placeholder = Introducir dirección de correo
onboarding-join-form-email-error = Una dirección de correo válida es obligatoria
onboarding-join-form-legal = Si continúas, aceptas los <a data-l10n-name="terms">Términos del servicio</a> y la <a data-l10n-name="privacy">Política de privacidad</a>.
onboarding-join-form-continue = Continuar
# This message is followed by a link using onboarding-join-form-signin ("Sign In") as text.
onboarding-join-form-signin-label = ¿Ya tiene una cuenta?
# Text for link to submit the sign in form
onboarding-join-form-signin = Iniciar sesión
onboarding-start-browsing-button-label = Empezar a navegar
onboarding-cards-dismiss =
    .title = Ignorar
    .aria-label = Ignorar

## Welcome full page string

onboarding-fullpage-welcome-subheader = Comencemos a explorar todo lo que puede hacer.
onboarding-fullpage-form-email =
    .placeholder = Su dirección de correo electrónico…

## Firefox Sync modal dialog strings.

onboarding-sync-welcome-header = Llévese { -brand-product-name } consigo
onboarding-sync-welcome-content = Acceda a sus marcadores, historial, contraseñas y más ajustes en todos sus dispositivos.
onboarding-sync-welcome-learn-more-link = Descubra más sobre las Cuentas de Firefox
onboarding-sync-form-input =
    .placeholder = Correo electrónico
onboarding-sync-form-continue-button = Continuar
onboarding-sync-form-skip-login-button = Saltar este paso

## This is part of the line "Enter your email to continue to Firefox Sync"

onboarding-sync-form-header = Introduzca su correo electrónico
onboarding-sync-form-sub-header = para acceder a { -sync-brand-name }.

## These are individual benefit messages shown with an image, title and
## description.

onboarding-benefit-products-text = Haga las cosas con una familia de herramientas que respete su privacidad en todos sus dispositivos.
# "Personal Data Promise" is a concept that should be translated consistently
# across the product. It refers to a concept shown elsewhere to the user: "The
# Firefox Personal Data Promise is the way we honor your data in everything we
# make and do. We take less data. We keep it safe. And we make sure that we are
# transparent about how we use it."
onboarding-benefit-privacy-text = Todo lo que hacemos respeta nuestra promesa de datos personales: Tomar menos. Mantenerlo seguro. Sin secretos.
onboarding-benefit-sync-title = { -sync-brand-short-name }
onboarding-benefit-sync-text = Lleve sus marcadores, contraseñas, historial y más a todos los lugares donde use { -brand-product-name }.
onboarding-benefit-monitor-title = { -monitor-brand-short-name }
onboarding-benefit-monitor-text = Reciba notificaciones cuando su información personal se encuentre en una filtración de datos conocida.
onboarding-benefit-lockwise-title = { -lockwise-brand-short-name }
onboarding-benefit-lockwise-text = Gestione sus contraseñas protegidas y portátiles.

## These strings belong to the individual onboarding messages.


## Each message has a title and a description of what the browser feature is.
## Each message also has an associated button for the user to try the feature.
## The string for the button is found above, in the UI strings section

onboarding-tracking-protection-title2 = Protección contra rastreo
onboarding-tracking-protection-text2 = { -brand-short-name } le ayuda a impedir que los sitios le rastreen en línea, por lo que será más difícil que la publicidad le siga mientras navega.
onboarding-tracking-protection-button2 = Cómo funciona
onboarding-data-sync-title = Lleve sus ajustes consigo
# "Sync" is short for synchronize.
onboarding-data-sync-text2 = Sincronice sus marcadores, contraseñas y mucho más donde quiera que use { -brand-product-name }.
onboarding-data-sync-button2 = Iniciar sesión en { -sync-brand-short-name }
onboarding-firefox-monitor-title = Mantente al día sobre las filtraciones de datos
onboarding-firefox-monitor-text2 = { -monitor-brand-name } controla si su dirección de correo apareció en una filtración de datos conocida y le avisa si aparece en una nueva filtración.
onboarding-firefox-monitor-button = Suscríbase para recibir alertas
onboarding-browse-privately-title = Navegue de forma privada
onboarding-browse-privately-text = La navegación privada elimina tu historial de búsquedas y de navegación para que nadie que use tu equipo tenga acceso a ellos.
onboarding-browse-privately-button = Abrir una ventana privada
onboarding-firefox-send-title = Mantenga privados sus archivos compartidos
onboarding-firefox-send-text2 = Suba sus archivos a { -send-brand-name } para compartirlos con cifrado de extremo a extremo y un enlace que expira automáticamente.
onboarding-firefox-send-button = Pruebe { -send-brand-name }
onboarding-mobile-phone-title = Consiga { -brand-product-name } en su teléfono
onboarding-mobile-phone-text = Descargue { -brand-product-name } para iOS o Android y sincronice su información en todos los dispositivos.
# "Mobile" is short for mobile/cellular phone, "Browser" is short for web
# browser.
onboarding-mobile-phone-button = Descargar navegador móvil
onboarding-send-tabs-title = Envíese las pestañas instantáneamente
# "Send Tabs" refers to "Send Tab to Device" feature that appears when opening a
# tab's context menu.
onboarding-send-tabs-text2 = Comparta fácilmente páginas entre sus dispositivos sin tener que copiar enlaces o salir del navegador.
onboarding-send-tabs-button = Empieza a usar Send Tabs
onboarding-pocket-anywhere-title = Lee y escucha sea donde sea
onboarding-pocket-anywhere-text2 = Guarde su contenido favorito sin conexión gracias a la aplicación de { -pocket-brand-name } y léalo, escúchelo o véalo dónde y cuándo mejor le convenga.
onboarding-pocket-anywhere-button = Pruebe { -pocket-brand-name }
onboarding-lockwise-strong-passwords-title = Crear y almacenar contraseñas seguras
onboarding-lockwise-strong-passwords-text = { -lockwise-brand-name } crea contraseñas seguras en el acto y las guarda en un único lugar.
onboarding-lockwise-strong-passwords-button = Administrar sus inicios de sesión
onboarding-facebook-container-title = Establezca límites con Facebook
onboarding-facebook-container-text2 = { -facebook-container-brand-name } separa su identidad de Facebook de todo lo demás, dificultando así que Facebook pueda mostrarle publicidad personalizada.
onboarding-facebook-container-button = Agregar extensión
onboarding-import-browser-settings-title = Importe sus marcadores, contraseñas y más
onboarding-import-browser-settings-text = Sumérjase de lleno: lleve fácilmente sus sitios y configuraciones de Chrome con usted.
onboarding-import-browser-settings-button = Importar datos de Chrome
onboarding-personal-data-promise-title = Privado por diseño
onboarding-personal-data-promise-text = { -brand-product-name } trata sus datos con respeto recopilando menos, protegiéndolos e indicando claramente cómo los usamos.
onboarding-personal-data-promise-button = Lea nuestra promesa

## Message strings belonging to the Return to AMO flow

return-to-amo-sub-header = ¡Bien! Ya tiene { -brand-short-name }
# <icon></icon> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-header = Ahora obtenga <icon></icon><b>{ $addon-name }.</b>
return-to-amo-extension-button = Añadir la extensión
return-to-amo-get-started-button = Comenzar con { -brand-short-name }
onboarding-not-now-button-label = Ahora no

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Genial, ha instalado { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Ahora obtengamos <img data-l10n-name="icon"/> <b>{ $addon-name }</b> para usted.
return-to-amo-add-extension-label = Añadir la extensión

## Multistage 3-screen onboarding flow strings (about:welcome pages)

# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-welcome-header = Bienvenido a <span data-l10n-name="zap">{ -brand-short-name }</span>
onboarding-multistage-welcome-subtitle = El navegador rápido, seguro y privado respaldado por una organización sin ánimo de lucro.
onboarding-multistage-welcome-primary-button-label = Iniciar configuración
onboarding-multistage-welcome-secondary-button-label = Iniciar sesión
onboarding-multistage-welcome-secondary-button-text = ¿Tiene una cuenta?
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "default" should stay inside the span.
onboarding-multistage-set-default-header = Establecer { -brand-short-name } como <span data-l10n-name="zap">predeterminado</span>
onboarding-multistage-set-default-subtitle = Velocidad, seguridad y privacidad cada vez que navega.
onboarding-multistage-set-default-primary-button-label = Convertir en predeterminado
onboarding-multistage-set-default-secondary-button-label = Ahora no
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. { -brand-short-name } should stay inside the span.
onboarding-multistage-pin-default-header = Empiece poniendo <span data-l10n-name="zap">{ -brand-short-name }</span> a un clic de distancia
onboarding-multistage-pin-default-subtitle = Navegación rápida, segura y privada cada vez que usa la web.
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-waiting-subtitle = Elija { -brand-short-name } en "Navegador web" cuando se abra la configuración
# The "settings" here refers to "Windows 10 Settings App" and not the browser's
onboarding-multistage-pin-default-help-text = Esto fijará { -brand-short-name } en la barra de tareas y abrirá la configuración
onboarding-multistage-pin-default-primary-button-label = Hacer de { -brand-short-name } mi navegador principal
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "more" should stay inside the span.
onboarding-multistage-import-header = Importe sus contraseñas, marcadores y <span data-l10n-name="zap">más</span>
onboarding-multistage-import-subtitle = ¿Viene de otro navegador? Es fácil llevar todo a { -brand-short-name }.
onboarding-multistage-import-primary-button-label = Iniciar importación
onboarding-multistage-import-secondary-button-label = Ahora no
# Info displayed in the footer of import settings screen during onboarding flow.
# This supports welcome screen showing top sites imported from the user's default browser.
onboarding-import-sites-disclaimer = Los sitios listados se han encontrado en este dispositivo. { -brand-short-name } no guarda ni sincroniza datos de otro navegador a menos que usted elija importarlos.
# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Primeros pasos: pantalla { $current } de { $total }
# The <span data-l10n-name="zap"></span> in this string allows a "zap" underline style to be
# automatically added to the text inside it. "look" should stay inside the span.
onboarding-multistage-theme-header = Elija un <span data-l10n-name="zap">aspecto</span>
onboarding-multistage-theme-subtitle = Personalice { -brand-short-name } con un tema.
onboarding-multistage-theme-primary-button-label2 = Hecho
onboarding-multistage-theme-secondary-button-label = Ahora no
# Automatic theme uses operating system color settings
onboarding-multistage-theme-label-automatic = Automático
onboarding-multistage-theme-label-light = Claro
onboarding-multistage-theme-label-dark = Oscuro
# "Firefox Alpenglow" here is the name of the theme, and should be kept in English.
onboarding-multistage-theme-label-alpenglow = Firefox Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of automatic theme
onboarding-multistage-theme-tooltip-automatic-2 =
    .title =
        Heredar la apariencia de su sistema
        operativo para botones, menús y ventanas.
# Input description for automatic theme
onboarding-multistage-theme-description-automatic-2 =
    .aria-description =
        Heredar la apariencia de su sistema
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

## Multistage MR1 onboarding strings (MR1 about:welcome pages)

# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Firefox".
# It also signals the passion users bring to Firefox, how they use
# Firefox to pursue those passions, as well as the boldness in their
# choice to use Firefox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text = Todo empieza aquí
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio - Diseñadora de muebles, fan de Firefox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Desactivar animaciones

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Firefox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Mantenga { -brand-short-name } en su Dock para un fácil acceso
       *[other] Fije { -brand-short-name } a la barra de tareas para un fácil acceso
    }
# Primary button string used on welcome page when Firefox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Mantener en el Dock
       *[other] Fijar a la barra de tareas
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Firefox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Comenzar
mr1-onboarding-welcome-header = Te damos la bienvenida a { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Hacer de { -brand-short-name } mi navegador principal
    .title = Establece { -brand-short-name } como navegador predeterminado y lo ancla a la barra de tareas
# This string will be used on welcome page primary button label
# when Firefox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Hacer de { -brand-short-name } mi navegador predeterminado
mr1-onboarding-set-default-secondary-button-label = Ahora no
mr1-onboarding-sign-in-button-label = Iniciar sesión

## Title, subtitle and primary button string used on set default onboarding screen
## when Firefox is not default browser

mr1-onboarding-default-header = Hacer que{ -brand-short-name } sea su navegador predeterminado
mr1-onboarding-default-subtitle = Obtenga velocidad, seguridad y privacidad de forma automática.
mr1-onboarding-default-primary-button-label = Establecer como navegador predeterminado

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Llévelo todo con usted
mr1-onboarding-import-subtitle = Importe sus contraseñas, <br/>marcadores y más.
# The primary import button label will depend on whether we can detect which browser was used to download Firefox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importar desde { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importar desde el navegador anterior
mr1-onboarding-import-secondary-button-label = Ahora no
mr1-onboarding-theme-header = Hágalo suyo
mr1-onboarding-theme-subtitle = Personalizar { -brand-short-name } con un tema
mr1-onboarding-theme-primary-button-label = Guardar tema
mr1-onboarding-theme-secondary-button-label = Ahora no
# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Tema del sistema
mr1-onboarding-theme-label-light = Claro
mr1-onboarding-theme-label-dark = Oscuro
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

## Please make sure to split the content of the title attribute into lines whose
## width corresponds to about 40 Latin characters, to ensure that the tooltip
## doesn't become too long. Line breaks will be preserved when displaying the
## tooltip.

# Tooltip displayed on hover of system theme
mr1-onboarding-theme-tooltip-system =
    .title =
        Seguir el tema del sistema operativo
        para botones, menús y ventanas.
# Input description for system theme
mr1-onboarding-theme-description-system =
    .aria-description =
        Seguir el tema del sistema operativo
        para botones, menús y ventanas.
# Tooltip displayed on hover of light theme
mr1-onboarding-theme-tooltip-light =
    .title =
        Usar un tema claro para botones,
        menús y ventanas.
# Input description for light theme
mr1-onboarding-theme-description-light =
    .aria-description =
        Usar un tema claro para botones,
        menús y ventanas.
# Tooltip displayed on hover of dark theme
mr1-onboarding-theme-tooltip-dark =
    .title =
        Usar un tema oscuro para botones,
        menús y ventanas.
# Input description for dark theme
mr1-onboarding-theme-description-dark =
    .aria-description =
        Usar un tema oscuro para botones,
        menús y ventanas.
# Tooltip displayed on hover of Alpenglow theme
mr1-onboarding-theme-tooltip-alpenglow =
    .title =
        Usar un tema dinámico y colorido para botones,
        menús y ventanas.
# Input description for Alpenglow theme
mr1-onboarding-theme-description-alpenglow =
    .aria-description =
        Usar un tema dinámico y colorido para botones,
        menús y ventanas.
