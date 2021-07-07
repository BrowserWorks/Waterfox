# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Apri una finestra anonima
    .accesskey = A
about-private-browsing-search-placeholder = Cerca sul Web
about-private-browsing-info-title = Ti trovi in una finestra anonima
about-private-browsing-info-myths = Miti da sfatare sulla navigazione anonima
about-private-browsing =
    .title = Cerca sul Web

# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Cerca con { $engine } o inserisci un indirizzo
about-private-browsing-handoff-no-engine =
    .title = Cerca o inserisci un indirizzo
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Cerca con { $engine } o inserisci un indirizzo
about-private-browsing-handoff-text-no-engine = Cerca o inserisci un indirizzo

about-private-browsing-not-private = Questa non è una finestra anonima.
about-private-browsing-info-description = { -brand-short-name } cancella la cronologia di ricerca e navigazione quando si chiude l’applicazione o vengono chiuse tutte le finestre e schede in Navigazione anonima. Nonostante questa modalità non ti renda completamente anonimo nei confronti dei siti web o del tuo fornitore di servizi internet, si tratta comunque di uno strumento utile per impedire ad altri utilizzatori di questo computer di ottenere informazioni sulla tua attività online.

about-private-browsing-need-more-privacy = Vuoi ancora più privacy?
about-private-browsing-turn-on-vpn = Prova { -mozilla-vpn-brand-name }

# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } è il motore di ricerca predefinito nelle finestre anonime
about-private-browsing-search-banner-description = {
  PLATFORM() ->
     [windows] È possibile selezionare un altro motore di ricerca nelle <a data-l10n-name="link-options">opzioni</a>
    *[other] È possibile selezionare un altro motore di ricerca nelle <a data-l10n-name="link-options">preferenze</a>
  }
about-private-browsing-search-banner-close-button =
    .aria-label = Chiudi
