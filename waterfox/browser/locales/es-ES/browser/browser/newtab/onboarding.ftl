# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Bienvenido a { -brand-short-name }
onboarding-start-browsing-button-label = Empezar a navegar
onboarding-not-now-button-label = Ahora no
mr1-onboarding-get-started-primary-button-label = Comenzar

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Genial, ha instalado { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Ahora obtenga <img data-l10n-name="icon"/> <b>{ $addon-name }</b>.
return-to-amo-add-extension-label = Añadir la extensión
return-to-amo-add-theme-label = Añadir el tema

##  Variables: $addon-name (String) - Name of the add-on to be installed

mr1-return-to-amo-subtitle = Salude a { -brand-short-name }
mr1-return-to-amo-addon-title = Tiene un navegador rápido y privado al alcance de su mano. Ahora puede añadir <b>{ $addon-name }</b> y hacer aún más con { -brand-short-name }.
mr1-return-to-amo-add-extension-label = Añadir { $addon-name }

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator-label =
    .aria-label = Progreso: paso { $current } de { $total }

# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Desactivar animaciones

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

## Multistage MR1 onboarding strings (about:welcome pages)

# String for the Waterfox Accounts button
mr1-onboarding-sign-in-button-label = Iniciar sesión

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

## Multistage MR1 onboarding strings (about:welcome pages)

# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importar desde { $previous }

mr1-onboarding-theme-header = Hágalo suyo
mr1-onboarding-theme-subtitle = Personalizar { -brand-short-name } con un tema
mr1-onboarding-theme-secondary-button-label = Ahora no

# System theme uses operating system color settings
mr1-onboarding-theme-label-system = Tema del sistema

mr1-onboarding-theme-label-light = Claro
mr1-onboarding-theme-label-dark = Oscuro
# "Alpenglow" here is the name of the theme, and should be kept in English.
mr1-onboarding-theme-label-alpenglow = Alpenglow

onboarding-theme-primary-button-label = Hecho

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

# Selector description for default themes
mr2-onboarding-default-theme-label = Explorar los temas predeterminados.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Gracias por elegirnos
mr2-onboarding-thank-you-text = { -brand-short-name } es un navegador independiente respaldado por una organización sin ánimo de lucro. Juntos, estamos haciendo que la web sea más segura, saludable y privada.
mr2-onboarding-start-browsing-button-label = Empezar a navegar

## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"


## Multistage live language reloading onboarding strings (about:welcome pages)
##
## The following language names are generated by the browser's Intl.DisplayNames API.
##
## Variables:
##   $negotiatedLanguage (String) - The name of the langpack's language, e.g. "Español (ES)"
##   $systemLanguage (String) - The name of the system language, e.g "Español (ES)"
##   $appLanguage (String) - The name of the language shipping in the browser build, e.g. "English (EN)"

onboarding-live-language-header = Elija su idioma

mr2022-onboarding-live-language-text = { -brand-short-name } habla su idioma

mr2022-language-mismatch-subtitle = Gracias a nuestra comunidad, { -brand-short-name } está traducido a más de 90 idiomas. Parece que su sistema está usando { $systemLanguage } y { -brand-short-name } está usando { $appLanguage }.

onboarding-live-language-button-label-downloading = Descargando el paquete de idioma para { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Obteniendo idiomas disponibles…
onboarding-live-language-installing = Instalando el pack de idioma para { $negotiatedLanguage }…

mr2022-onboarding-live-language-switch-to = Cambiar a { $negotiatedLanguage }
mr2022-onboarding-live-language-continue-in = Continuar en { $appLanguage }

onboarding-live-language-secondary-cancel-download = Cancelar
onboarding-live-language-skip-button-label = Saltar

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
    <span data-l10n-name="zap">Gracias</span>
fx100-thank-you-subtitle = ¡Es nuestro lanzamiento número 100! Gracias por ayudarnos a construir un Internet mejor y más saludable.
fx100-thank-you-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Mantener { -brand-short-name } en el Dock
       *[other] Fijar { -brand-short-name } a la barra de tareas
    }

fx100-upgrade-thanks-header = 100 gracias
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Es nuestro lanzamiento número 100 de { -brand-short-name }. Gracias <em>a ti</em> por ayudarnos a construir un Internet mejor y más saludable.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = ¡Es nuestro lanzamiento número 100! Gracias por ser parte de nuestra comunidad. Mantén { -brand-short-name } a un clic de distancia para los próximos 100.

mr2022-onboarding-secondary-skip-button-label = Saltar este paso

## MR2022 New User Easy Setup screen strings

# Primary button string used on new user onboarding first screen showing multiple actions such as Set Default, Import from previous browser.
mr2022-onboarding-easy-setup-primary-button-label = Guardar y continuar
# Set Default action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-set-default-checkbox-label = Establecer { -brand-short-name } como navegador predeterminado
# Import action checkbox label used on new user onboarding first screen
mr2022-onboarding-easy-setup-import-checkbox-label = Importar desde el navegador anterior

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Abra una Internet increíble
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Inicie { -brand-short-name } desde cualquier lugar con un solo clic. Cada vez que lo haga, estará eligiendo una web más abierta e independiente.
# Primary button string used on welcome page for when Waterfox is not pinned.
mr2022-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Mantener { -brand-short-name } en el Dock
       *[other] Fijar { -brand-short-name } en la barra de tareas
    }
# Subtitle will be used when user already has Waterfox pinned, but
# has not set it as their default browser.
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-only-subtitle = Comience con un navegador respaldado por una organización sin ánimo de lucro. Defendemos su privacidad mientras navega por la web.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Gracias por amar { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Inicie una Internet más saludable desde cualquier lugar con un solo clic. Nuestra última actualización está repleta de cosas nuevas que creemos que le encantarán.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Use un navegador que defiende su privacidad mientras navega por la web. Nuestra última actualización está repleta de cosas que le encantarán.
mr2022-onboarding-existing-pin-checkbox-label = Añada también la navegación privada de { -brand-short-name }

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Haga de { -brand-short-name } su navegador favorito
mr2022-onboarding-set-default-primary-button-label = Establezca { -brand-short-name } como su navegador predeterminado
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Use un navegador respaldado por una organización sin ánimo de lucro. Defendemos su privacidad mientras navega por la web.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Nuestra última versión está diseñada pensando en usted, haciendo que navegar por la web sea más fácil que nunca. Está repleto de funciones que creemos que le encantarán.
mr2022-onboarding-get-started-primary-button-label = Configurar en segundos

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Configuración ultrarrápida
mr2022-onboarding-import-subtitle = Configure { -brand-short-name } como más le guste. Añada sus marcadores, contraseñas y más desde su antiguo navegador.
mr2022-onboarding-import-primary-button-label-no-attribution = Importar desde el navegador anterior

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Elija el color que le inspira
mr2022-onboarding-colorway-subtitle = Las voces independientes pueden cambiar la cultura.
mr2022-onboarding-colorway-primary-button-label-continue = Establecer y continuar
mr2022-onboarding-existing-colorway-checkbox-label = Hacer de { -firefox-home-brand-name } su colorida página de inicio

mr2022-onboarding-colorway-label-default = Predeterminado
mr2022-onboarding-colorway-tooltip-default2 =
    .title = Colores actuales de { -brand-short-name }
mr2022-onboarding-colorway-description-default = <b>Seguir usando mis colores actuales de { -brand-short-name }.</b>

mr2022-onboarding-colorway-label-playmaker = Creador de juego
mr2022-onboarding-colorway-tooltip-playmaker2 =
    .title = Creador de juego (rojo)
mr2022-onboarding-colorway-description-playmaker = <b>Usted es un creador de juego.</b> Usted crea oportunidades para ganar y ayudar a los que le rodean a mejorar su juego.

mr2022-onboarding-colorway-label-expressionist = Expresionista
mr2022-onboarding-colorway-tooltip-expressionist2 =
    .title = Expresionista (amarillo)
mr2022-onboarding-colorway-description-expressionist = <b>Usted es un expresionista.</b> Ve el mundo de manera diferente y sus creaciones despiertan emociones en los demás.

mr2022-onboarding-colorway-label-visionary = Visionario
mr2022-onboarding-colorway-tooltip-visionary2 =
    .title = Visionario (verde)
mr2022-onboarding-colorway-description-visionary = <b>Usted es un visionario</b> Cuestiona el status quo y mueve a otros a imaginar un futuro mejor.

mr2022-onboarding-colorway-label-activist = Activista
mr2022-onboarding-colorway-tooltip-activist2 =
    .title = Activista (azul)
mr2022-onboarding-colorway-description-activist = <b>Usted es un activista</b> Deja el mundo como un lugar mejor de lo que lo encontró y convence a otros a creer en el cambio.

mr2022-onboarding-colorway-label-dreamer = Soñador
mr2022-onboarding-colorway-tooltip-dreamer2 =
    .title = Soñador (púrpura)
mr2022-onboarding-colorway-description-dreamer = <b>Usted es un soñador.</b> Cree que la suerte favorece a los audaces e inspira a otros a ser valientes.

mr2022-onboarding-colorway-label-innovator = Innovador
mr2022-onboarding-colorway-tooltip-innovator2 =
    .title = Innovador (naranja)
mr2022-onboarding-colorway-description-innovator = <b>Usted es un innovador.</b> Ve oportunidades en todas partes y tiene un impacto en la vida de los que le rodean.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Pase del ordenador a su teléfono y viceversa.
mr2022-onboarding-mobile-download-subtitle = Recupere las pestañas de un dispositivo y continúe donde lo dejó en otro. Además, sincronice sus marcadores y contraseñas en cualquier lugar donde use { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Escanee el código QR para obtener { -brand-product-name } para dispositivos móviles o <a data-l10n-name="download-label">envíese un enlace de descarga.</a>
mr2022-onboarding-no-mobile-download-cta-text = Escanee el código QR para obtener { -brand-product-name } en su móvil.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Obtenga la libertad de la navegación privada en un clic
mr2022-upgrade-onboarding-pin-private-window-subtitle = Sin cookies guardadas ni historial, directamente desde su escritorio. Navegue como si nadie le estuviera mirando.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Mantener la navegación privada de { -brand-short-name } en el Dock
       *[other] Fijar la navegación privada de { -brand-short-name } a la barra de tareas
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Siempre respetamos su privacidad
mr2022-onboarding-privacy-segmentation-subtitle = Desde sugerencias inteligentes hasta búsquedas más eficientes, trabajamos constantemente para crear un { -brand-product-name } mejor y más personal.
mr2022-onboarding-privacy-segmentation-text-cta = ¿Qué quiere ver cuando ofrezcamos nuevas funciones que usen sus datos para mejorar la navegación?
mr2022-onboarding-privacy-segmentation-button-primary-label = Use las recomendaciones de { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Mostrar información detallada

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Nos está ayudando a construir una web mejor
mr2022-onboarding-gratitude-subtitle = Gracias por usar { -brand-short-name }, respaldado por la Fundación BrowserWorks. Con su apoyo, estamos trabajando para que Internet sea más abierta, accesible y mejor para todos.
mr2022-onboarding-gratitude-primary-button-label = Novedades
mr2022-onboarding-gratitude-secondary-button-label = Empezar a navegar

## Onboarding spotlight for infrequent users

onboarding-infrequent-import-title = Siéntase como en casa
onboarding-infrequent-import-subtitle = No importa si está de paso o si va a quedarse por aquí, recuerde que puede importar sus marcadores, contraseñas y demás.
onboarding-infrequent-import-primary-button = Importar a { -brand-short-name }

## MR2022 Illustration alt tags
## Descriptive tags for illustrations used by screen readers and other assistive tech

mr2022-onboarding-pin-image-alt =
    .aria-label = Persona que trabaja en un portátil rodeada de estrellas y flores.
mr2022-onboarding-default-image-alt =
    .aria-label = Persona abrazando el logo de { -brand-product-name }
mr2022-onboarding-import-image-alt =
    .aria-label = Persona montando en skate con una caja de iconos de software
mr2022-onboarding-mobile-download-image-alt =
    .aria-label = Ranas saltando sobre nenúfares con un código QR para descargar { -brand-product-name } para dispositivos móviles en el centro
mr2022-onboarding-pin-private-image-alt =
    .aria-label = Una varita mágica hace que el logo de navegación privada de { -brand-product-name } aparezca de un sombrero
mr2022-onboarding-privacy-segmentation-image-alt =
    .aria-label = Manos de piel clara y de piel oscura chocan los cinco
mr2022-onboarding-gratitude-image-alt =
    .aria-label = Vista de una puesta de sol a través de una ventana con un zorro y una planta de casa en un alféizar
mr2022-onboarding-colorways-image-alt =
    .aria-label = Un spray pinta un colorido collage de un ojo verde, un zapato naranja, una pelota de baloncesto roja, unos auriculares morados, un corazón azul y una corona amarilla

## Device migration onboarding

onboarding-device-migration-image-alt =
    .aria-label = Un zorro en la pantalla de un portátil, saludando. El portátil tiene un ratón conectado.
onboarding-device-migration-title = Le damos de nuevo la bienvenida
onboarding-device-migration-subtitle = Inicie sesión en su { -fxaccount-brand-name(capitalization: "sentence") } para recuperar sus marcadores, contraseñas e historial en su nuevo dispositivo.
onboarding-device-migration-primary-button-label = Iniciar sesión
