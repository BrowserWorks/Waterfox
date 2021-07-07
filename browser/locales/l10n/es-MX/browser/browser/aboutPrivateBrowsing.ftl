# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Abrir una ventana privada
    .accesskey = P
about-private-browsing-search-placeholder = Buscar en la web
about-private-browsing-info-title = Estás en una ventana privada
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
about-private-browsing-not-private = En este momento no estás en una ventana privada.
about-private-browsing-info-description = { -brand-short-name } elimina tu búsqueda y el historial de navegación cuando sales de la aplicación o cierras todas las pestañas y ventanas de navegación privada. Aunque esto no te vuelve anónimo en los sitios web o en tu proveedor de servicios de Internet, hace que sea más fácil mantener lo que haces en línea privado de cualquier otra persona que use esta computadora.
about-private-browsing-need-more-privacy = ¿necesitas más privacidad?
about-private-browsing-turn-on-vpn = Prueba { -mozilla-vpn-brand-name }
about-private-browsing-info-description-private-window = Ventana privada: { -brand-short-name } borra tu historial de búsqueda y navegación cuando cierras todas las ventanas privadas. Esto no te hace anónimo.
about-private-browsing-info-description-simplified = { -brand-short-name } borra tu historial de búsqueda y navegación al cerrar todas las ventanas privadas, pero esto no le hace anónimo.
about-private-browsing-learn-more-link = Saber más
about-private-browsing-hide-activity = Oculta tu actividad y ubicación, donde sea que estés navegando
about-private-browsing-prominent-cta = Mantente privado con { -mozilla-vpn-brand-name }
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
