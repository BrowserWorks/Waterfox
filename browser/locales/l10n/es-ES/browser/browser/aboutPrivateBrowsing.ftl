# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Abrir una ventana privada
    .accesskey = P
about-private-browsing-search-placeholder = Buscar en la web
about-private-browsing-info-title = Está en una ventana privada
about-private-browsing-info-myths = Mitos comunes sobre la navegación privada
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
about-private-browsing-not-private = No está actualmente en una ventana privada.
about-private-browsing-info-description = { -brand-short-name } borra su historial de búsqueda y navegación al salir de la aplicación o al cerrar todas las ventanas y pestañas de navegación privada. Aunque esto no le hace anónimo para los sitios web o para su proveedor de servicios de Internet, hace que sea más fácil mantener en privado lo que hace en línea de cualquier otra persona que utilice este equipo.
about-private-browsing-need-more-privacy = ¿Necesita más privacidad?
about-private-browsing-turn-on-vpn = Pruebe { -mozilla-vpn-brand-name }
about-private-browsing-info-description-private-window = Ventana privada:{ -brand-short-name } borra su historial de búsqueda y navegación al cerrar todas las ventanas privadas, pero esto no le hace anónimo.
about-private-browsing-info-description-simplified = { -brand-short-name } borra su historial de búsqueda y navegación al cerrar todas las ventanas privadas, pero esto no le hace anónimo.
about-private-browsing-learn-more-link = Saber más
about-private-browsing-hide-activity = Oculte su actividad y ubicación, dondequiera que esté navegando
about-private-browsing-get-privacy = Obtenga protecciones de privacidad dondequiera que navegue
about-private-browsing-hide-activity-1 = Oculte la actividad de navegación y la ubicación con { -mozilla-vpn-brand-name }. Un clic crea una conexión segura, incluso en Wi-Fi público.
about-private-browsing-prominent-cta = Proteja su privacidad con { -mozilla-vpn-brand-name }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } es su buscador predeterminado en ventanas privadas
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Para seleccionar un buscador diferente, vaya a <a data-l10n-name="link-options">Opciones</a>
       *[other] Para seleccionar un buscador diferente, vaya a <a data-l10n-name="link-options">Preferencias</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Cerrar
