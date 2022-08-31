# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### UI strings for the MR1 onboarding / multistage about:welcome
### Various strings use a non-breaking space to avoid a single dangling /
### widowed word, so test on various window sizes if you also want this.


## Welcome page strings

onboarding-welcome-header = Bienvenido a { -brand-short-name }
onboarding-start-browsing-button-label = Empieza a navegar
onboarding-not-now-button-label = Ahora no

## Custom Return To AMO onboarding strings

return-to-amo-subtitle = Genial, has instalado { -brand-short-name }
# <img data-l10n-name="icon"/> will be replaced with the icon belonging to the extension
#
# Variables:
#   $addon-name (String) - Name of the add-on
return-to-amo-addon-title = Ahora obtengamos <img data-l10n-name="icon"/> <b>{ $addon-name }</b> para ti.
return-to-amo-add-extension-label = Agregar la extensión
return-to-amo-add-theme-label = Agregar el tema

## Multistage onboarding strings (about:welcome pages)

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages
onboarding-welcome-steps-indicator =
    .aria-label = Primeros pasos: pantalla { $current } de { $total }

# Aria-label to make the "steps" of multistage onboarding visible to screen readers.
# Variables:
#   $current (Int) - Number of the current page
#   $total (Int) - Total number of pages

onboarding-welcome-steps-indicator2 =
    .aria-valuetext = Progreso: paso { $current } de { $total }
# "Hero Text" displayed on left side of welcome screen.
# The "Fire" in "Fire starts here" plays on the "Fire" in "Waterfox".
# It also signals the passion users bring to Waterfox, how they use
# Waterfox to pursue those passions, as well as the boldness in their
# choice to use Waterfox over a larger competitor browser.
# An alternative title for localization is: "It starts here".
# This text can be formatted to span multiple lines as needed.
mr1-welcome-screen-hero-text =
    El fuego comienza
    aquí
# Caption for background image in about:welcome. "Soraya Osorio" is the name
# of the person and shouldn't be translated.
# In case your language needs to adapt the nouns to a gender, Soraya is a female name (she/her).
# You can see the picture in about:welcome in Nightly 90.
mr1-onboarding-welcome-image-caption = Soraya Osorio — Diseñadora de muebles, fan de Waterfox
# This button will open system settings to turn on prefers-reduced-motion
mr1-onboarding-reduce-motion-button-label = Desactivar animaciones

## Title and primary button strings differ between platforms as they
## match the OS' application context menu item action where Windows uses "pin"
## and "taskbar" while macOS "keep" and "Dock" (proper noun).

# Title used on welcome page when Waterfox is not pinned
mr1-onboarding-pin-header =
    { PLATFORM() ->
        [macos] Mantener { -brand-short-name } en tu Dock para un acceso fácil
       *[other] Fijar { -brand-short-name } en tu barra de tareas para un acceso fácil
    }
# Primary button string used on welcome page when Waterfox is not pinned.
mr1-onboarding-pin-primary-button-label =
    { PLATFORM() ->
        [macos] Mantener en el Dock
       *[other] Fijar en la barra de tareas
    }

## Multistage MR1 onboarding strings (about:welcome pages)

# This string will be used on welcome page primary button label
# when Waterfox is both pinned and default
mr1-onboarding-get-started-primary-button-label = Comenzar
mr1-onboarding-welcome-header = Bienvenido a { -brand-short-name }
mr1-onboarding-set-default-pin-primary-button-label = Hacer de { -brand-short-name } mi navegador principal
    .title = Establece { -brand-short-name } como navegador predeterminado y lo ancla a la barra de tareas
# This string will be used on welcome page primary button label
# when Waterfox is not default but already pinned
mr1-onboarding-set-default-only-primary-button-label = Hacer { -brand-short-name } mi navegador predeterminado
mr1-onboarding-set-default-secondary-button-label = Ahora no
mr1-onboarding-sign-in-button-label = Iniciar sesión

## Title, subtitle and primary button string used on set default onboarding screen
## when Waterfox is not default browser

mr1-onboarding-default-header = Hacer que { -brand-short-name } sea tu navegador predeterminado
mr1-onboarding-default-subtitle = Obtén velocidad, seguridad y privacidad de forma automática.
mr1-onboarding-default-primary-button-label = Establecer como navegador predeterminado

## Multistage MR1 onboarding strings (about:welcome pages)

mr1-onboarding-import-header = Tráelo todo contigo
mr1-onboarding-import-subtitle = Importa tus contraseñas, <br/>marcadores y más.
# The primary import button label will depend on whether we can detect which browser was used to download Waterfox.
# Variables:
#   $previous (Str) - Previous browser name, such as Edge, Chrome
mr1-onboarding-import-primary-button-label-attribution = Importar desde { $previous }
# This string will be used in cases where we can't detect the previous browser name.
mr1-onboarding-import-primary-button-label-no-attribution = Importar desde el navegador anterior
mr1-onboarding-import-secondary-button-label = Ahora no
mr2-onboarding-colorway-header = La vida a todo color
mr2-onboarding-colorway-subtitle = Nuevas combinaciones de colores vibrantes. Disponible por tiempo limitado.
mr2-onboarding-colorway-primary-button-label = Guardar combinación de colores
mr2-onboarding-colorway-secondary-button-label = Ahora no
mr2-onboarding-colorway-label-soft = Suave
mr2-onboarding-colorway-label-balanced = Equilibrado
# "Bold" is used in the sense of bravery or courage, not in the sense of
# emphasized text.
mr2-onboarding-colorway-label-bold = Fuerte
# Automatic theme uses operating system color settings
mr2-onboarding-theme-label-auto = Auto
# This string will be used for Default theme
mr2-onboarding-theme-label-default = Predeterminado
mr1-onboarding-theme-header = Hazlo tuyo
mr1-onboarding-theme-subtitle = Personaliza { -brand-short-name } con un tema.
mr1-onboarding-theme-primary-button-label = Guardar tema
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
# Tooltip displayed on hover of non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-tooltip =
    .title = Usar esta combinación de colores.
# Selector description for non-default colorway theme
# variations e.g. soft, balanced, bold
mr2-onboarding-theme-description =
    .aria-description = Usar esta combinación de colores.
# Tooltip displayed on hover of colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-tooltip =
    .title = Explorar combinaciones de colores de { $colorwayName }.
# Selector description for colorway
# Variables:
#   $colorwayName (String) - Name of colorway
mr2-onboarding-colorway-label = Explorar combinaciones de colores de { $colorwayName }.
# Tooltip displayed on hover of default themes
mr2-onboarding-default-theme-tooltip =
    .title = Explorar los temas predeterminados.
# Selector description for default themes
mr2-onboarding-default-theme-label = Explorar los temas predeterminados.

## Strings for Thank You page

mr2-onboarding-thank-you-header = Gracias por elegirnos
mr2-onboarding-thank-you-text = { -brand-short-name } es un navegador independiente respaldado por una organización sin ánimo de lucro. Juntos, estamos haciendo que la web sea más segura, saludable y privada.
mr2-onboarding-start-browsing-button-label = Comenzar a navegar

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

onboarding-live-language-header = Selecciona tu idioma
mr2022-onboarding-live-language-text = { -brand-short-name } habla en tu idioma
mr2022-language-mismatch-subtitle = Gracias a nuestra comunidad, { -brand-short-name } está traducido a más de 90 idiomas. Parece que tu sistema está usando { $systemLanguage } y { -brand-short-name } está usando { $appLanguage }.
onboarding-live-language-button-label-downloading = Descargar el paquete de idioma para { $negotiatedLanguage }…
onboarding-live-language-waiting-button = Obtener idiomas disponibles…
onboarding-live-language-installing = Instalando el paquete de idioma para { $negotiatedLanguage }…
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
       *[other] Fijar { -brand-short-name } en la barra de tareas
    }
fx100-upgrade-thanks-header = 100 Gracias
# Message shown with a start-browsing button. Emphasis <em> should be for "you"
# but "Thank" can be used instead if there's no "you" in the translation.
fx100-upgrade-thank-you-body = Es nuestro lanzamiento número 100 de { -brand-short-name }. <em>Gracias</em> por ayudarnos a construir un internet mejor y más saludable.
# Message shown with either a pin-to-taskbar or set-default button.
fx100-upgrade-thanks-keep-body = ¡Es nuestro lanzamiento número 100! Gracias por ser parte de nuestra comunidad. Mantén { -brand-short-name } a un clic de distancia de los próximos 100.
mr2022-onboarding-secondary-skip-button-label = Saltar este paso

## MR2022 New User Pin Waterfox screen strings

# Title used on about:welcome for new users when Waterfox is not pinned.
# In this context, open up is synonymous with "Discover".
# The metaphor is that when they open their Waterfox browser, it helps them discover an amazing internet.
# If this translation does not make sense in your language, feel free to use the word "discover."
mr2022-onboarding-welcome-pin-header = Abre un Internet increíble
# Subtitle is used on onboarding page for new users page when Waterfox is not pinned
mr2022-onboarding-welcome-pin-subtitle = Inicia { -brand-short-name } desde cualquier lugar con un solo clic. Cada vez que lo haces, estás eligiendo una web más abierta e independiente.
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
mr2022-onboarding-set-default-only-subtitle = Comienza con un navegador respaldado por una organización sin fines de lucro. Defendemos tu privacidad mientras navegas por la web.

## MR2022 Existing User Pin Waterfox Screen Strings

# Title used on multistage onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-header = Gracias por querer a { -brand-product-name }
# Subtitle is used on onboarding page for existing users when Waterfox is not pinned
mr2022-onboarding-existing-pin-subtitle = Inicia un Internet más saludable desde cualquier lugar con un solo clic. Nuestra última actualización está repleta de cosas nuevas que creemos que te encantarán.
# Subtitle will be used on the welcome screen for existing users
# when they already have Waterfox pinned but not set as default
mr2022-onboarding-existing-set-default-only-subtitle = Usa un navegador que defiende tu privacidad mientras navegas por la web. Nuestra última actualiza está repleta de cosas que te encantarán.
mr2022-onboarding-existing-pin-checkbox-label = Agrega también navegación privada de { -brand-short-name }

## MR2022 New User Set Default screen strings

# This string is the title used when the user already has pinned the browser, but has not set default.
mr2022-onboarding-set-default-title = Haz de { -brand-short-name } tu navegador para llevar
mr2022-onboarding-set-default-primary-button-label = Establece { -brand-short-name } como navegador privado
# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-set-default-subtitle = Usa un navegador respaldado por una organización sin fines de lucro. Defendemos tu privacidad mientras navegas por la web.

## MR2022 Get Started screen strings.
## These strings will be used on the welcome page
## when Waterfox is already set to default and pinned.

# When translating "zip", please feel free to pick a verb that signifies movement and/or exploration
# and makes sense in the context of navigating the web.
mr2022-onboarding-get-started-primary-subtitle = Nuestra última versión está diseñada pensando en ti, lo que hace que navegar por la web sea más fácil que nunca. Está repleto de funciones que creemos que te encantarán.
mr2022-onboarding-get-started-primary-button-label = Configurar en segundos

## MR2022 Import Settings screen strings

mr2022-onboarding-import-header = Configuración ultrarrápida
mr2022-onboarding-import-subtitle = Configura { -brand-short-name } como quieras. Agrega tus marcadores, contraseñas y más desde tu antiguo navegador.
mr2022-onboarding-import-primary-button-label-no-attribution = Importar desde el navegador anterior

## If your language uses grammatical genders, in the description for the
## colorway feel free to switch from "You are a X. You…" (e.g. "You are a
## Playmaker. You create…") to "X: you…" ("Playmaker: You create…"). This might
## help creating a more inclusive translation.

mr2022-onboarding-colorway-title = Selecciona el color que te inspire
mr2022-onboarding-colorway-subtitle = Voces independientes puede cambiar la cultura.
mr2022-onboarding-colorway-primary-button-label = Establecer combinación de colores
mr2022-onboarding-existing-colorway-checkbox-label = Haz de { -firefox-home-brand-name } tu colorida página de inicio
mr2022-onboarding-colorway-label-default = Predeterminado
mr2022-onboarding-colorway-tooltip-default =
    .title = Predeterminado
mr2022-onboarding-colorway-description-default = <b>Usar mis colores actuales de { -brand-short-name }.</b>
mr2022-onboarding-colorway-label-playmaker = Creador de jugadas
mr2022-onboarding-colorway-tooltip-playmaker =
    .title = Creador de jugadas
mr2022-onboarding-colorway-description-playmaker = <b>Eres un Creador de Jugadas.</b> Creas oportunidades para ganar y ayudas a todos los que te rodean a mejorar su juego.
mr2022-onboarding-colorway-label-expressionist = Expresionista
mr2022-onboarding-colorway-tooltip-expressionist =
    .title = Expresionista
mr2022-onboarding-colorway-description-expressionist = <b>Eres un Expresionista.</b> Miras el mundo de forma distinta y tus creaciones despiertan las emociones de los demás.
mr2022-onboarding-colorway-label-visionary = Visionario
mr2022-onboarding-colorway-tooltip-visionary =
    .title = Visionario
mr2022-onboarding-colorway-description-visionary = <b>Eres un Visionario.</b> Cuestiones el status quo y mueves a otros a imaginar un futuro mejor.
mr2022-onboarding-colorway-label-activist = Activista
mr2022-onboarding-colorway-tooltip-activist =
    .title = Activista
mr2022-onboarding-colorway-description-activist = <b>Eres un Activista.</b> Dejar el mundo como un lugar mejor de lo que encontraste y llevas a otros a creer.
mr2022-onboarding-colorway-label-dreamer = Soñador
mr2022-onboarding-colorway-tooltip-dreamer =
    .title = Soñador
mr2022-onboarding-colorway-description-dreamer = <b>Eres un soñador.</b> Crees que la fortuna favorece a los audaces e inspiras a otros a ser valientes.
mr2022-onboarding-colorway-label-innovator = Innovador
mr2022-onboarding-colorway-tooltip-innovator =
    .title = Innovador
mr2022-onboarding-colorway-description-innovator = <b>Eres un Innovador.</b> Ves oportunidades donde sea y creas un impacto en las vidas de quienes te rodean.

## MR2022 Multistage Mobile Download screen strings

mr2022-onboarding-mobile-download-title = Salta de la computadora al teléfono y viceversa
mr2022-onboarding-mobile-download-subtitle = Toma las pestañas de un dispositivo y retoma donde te quedaste en otro. Además, sincroniza tus marcadores y contraseñas en cualquier lugar donde uses { -brand-product-name }.
mr2022-onboarding-mobile-download-cta-text = Escanea el código QR para tener { -brand-product-name } para dispositivos móviles o <a data-l10n-name="download-label">envíate un enlace de descarga.</a>
mr2022-onboarding-no-mobile-download-cta-text = Escanea el código QR para tener { -brand-product-name } para dispositivos móviles.

## MR2022 Upgrade Dialog screens
## Pin private window screen shown only for users who don't have Waterfox private pinned

mr2022-upgrade-onboarding-pin-private-window-header = Obtén navegación privada gratuita con un solo clic
mr2022-upgrade-onboarding-pin-private-window-subtitle = Sin cookies guardadas ni historial, directamente desde tu escritorio. Navega como si nadie te estuviera mirando.
mr2022-upgrade-onboarding-pin-private-window-primary-button-label =
    { PLATFORM() ->
        [macos] Mantén la navegación privada de { -brand-short-name } en el Dock
       *[other] Fija la navegación privada de { -brand-short-name } en la barra de tareas
    }

## MR2022 Privacy Segmentation screen strings

mr2022-onboarding-privacy-segmentation-title = Siempre respetamos tu privacidad
mr2022-onboarding-privacy-segmentation-subtitle = Desde sugerencias inteligentes hasta búsquedas más inteligentes, trabajamos constantemente para crear un { -brand-product-name } mejor y más personal.
mr2022-onboarding-privacy-segmentation-cta-text = Cuando ofrecemos nuestras funciones que usan tus datos para mejorar la navegación, quieres ver:
mr2022-onboarding-privacy-segmentation-primary-button-label = Recomendaciones de { -brand-product-name }
mr2022-onboarding-privacy-segmentation-secondary-button-label = Información detallada
mr2022-onboarding-privacy-segmentation-text-cta = ¿Qué quieres ver cuando ofrezcamos nuevas funciones que utilicen tus datos para mejorar tu navegación?
mr2022-onboarding-privacy-segmentation-button-primary-label = Usar recomendaciones de { -brand-product-name }
mr2022-onboarding-privacy-segmentation-button-secondary-label = Mostrar información detallada

## MR2022 Multistage Gratitude screen strings

mr2022-onboarding-gratitude-title = Estas ayudándonos a crear un mejor internet.
mr2022-onboarding-gratitude-subtitle = Gracias por usar { -brand-short-name }, respaldado por la fundación Waterfox. Con tu ayuda, trabajamos para crear un internet más abierto, accesible y mejor para todas y todos.
mr2022-onboarding-gratitude-primary-button-label = Mira las novedades
mr2022-onboarding-gratitude-secondary-button-label = Empieza a navegar
