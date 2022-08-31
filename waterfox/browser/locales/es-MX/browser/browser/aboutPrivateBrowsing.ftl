# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Abrir una ventana privada
    .accesskey = P
about-private-browsing-search-placeholder = Buscar en la web
about-private-browsing-info-title = Estás en una ventana privada
about-private-browsing-search-btn =
    .title = Buscar en la web
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Buscar con { $engine } o introducir una dirección
about-private-browsing-handoff-no-engine =
    .title = Buscar o escribir dirección
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Buscar con { $engine } o introducir una dirección
about-private-browsing-handoff-text-no-engine = Buscar o escribir dirección
about-private-browsing-not-private = En este momento no estás en una ventana privada.
about-private-browsing-info-description-private-window = Ventana privada: { -brand-short-name } borra tu historial de búsqueda y navegación cuando cierras todas las ventanas privadas. Esto no te hace anónimo.
about-private-browsing-info-description-simplified = { -brand-short-name } borra tu historial de búsqueda y navegación al cerrar todas las ventanas privadas, pero esto no le hace anónimo.
about-private-browsing-learn-more-link = Saber más
about-private-browsing-hide-activity = Oculta tu actividad y ubicación, donde sea que estés navegando
about-private-browsing-get-privacy = Obtén protecciones de privacidad dondequiera que navegues
about-private-browsing-hide-activity-1 = Oculta la actividad de navegación y la ubicación con { -mozilla-vpn-brand-name }. Un clic crea una conexión segura, incluso en Wi-Fi público.
about-private-browsing-prominent-cta = Mantente privado con { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Descargar { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: Navegación privada en cualquier lugar
about-private-browsing-focus-promo-text = Nuestra app dedicada a una navegación privada limpia tu historial y cookies.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Lleva la navegación privada en tu teléfono
about-private-browsing-focus-promo-text-b = Usa { -focus-brand-name } para aquellas búsquedas privadas que no quieres que el navegador principal de tu celular vea.
about-private-browsing-focus-promo-header-c = Privacidad de nivel superior en dispositivos móviles
about-private-browsing-focus-promo-text-c = { -focus-brand-name } siempre limpia tu historial cada vez que bloquea anuncios y rastreadores.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } es tu motor de búsqueda predeterminado en ventanas privadas
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Para seleccionar un buscador diferente, dirígete a <a data-l10n-name="link-options">Opciones</a>
       *[other] Para seleccionar un buscador diferente, dirígete a <a data-l10n-name="link-options">Preferencias</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Cerrar
about-private-browsing-promo-close-button =
    .title = Cerrar

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Libertad de navegación privada en un clic
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Fijar en el Dock
       *[other] Fijar en la barra de tareas
    }
about-private-browsing-pin-promo-title = Sin cookies guardadas ni historial, directamente desde tu escritorio. Navega como si nadie te estuviera mirando.
