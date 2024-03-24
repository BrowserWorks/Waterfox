# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Apri una finestra anonima
    .accesskey = A
about-private-browsing-search-placeholder = Cerca sul Web
about-private-browsing-info-title = Ti trovi in una finestra anonima
about-private-browsing-search-btn =
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
about-private-browsing-info-description-private-window = Finestra anonima: { -brand-short-name } cancella la cronologia di ricerca e navigazione quando si chiudono tutte le finestre in Navigazione anonima. Questo non ti rende completamente anonimo.

about-private-browsing-info-description-simplified = { -brand-short-name } cancella la cronologia di ricerca e navigazione quando vengono chiuse tutte le finestre anonime, ma questo non ti rende completamente anonimo.
about-private-browsing-learn-more-link = Ulteriori informazioni

about-private-browsing-hide-activity = Nascondi la tua posizione e le tue attività online, ovunque navighi
about-private-browsing-get-privacy = Proteggi la tua privacy ovunque navighi
about-private-browsing-hide-activity-1 = Nascondi la tua posizione e le tue attività online con { -mozilla-vpn-brand-name }. Basta un clic per stabilire una connessione sicura, anche quando utilizzi una rete Wi-Fi pubblica.
about-private-browsing-prominent-cta = Proteggi la tua privacy con { -mozilla-vpn-brand-name }

about-private-browsing-focus-promo-cta = Scarica { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: navigazione anonima ovunque ti trovi
about-private-browsing-focus-promo-text = La nostra app mobile disegnata per la navigazione anonima elimina automaticamente cronologia e cookie.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Porta la navigazione anonima sul tuo telefono
about-private-browsing-focus-promo-text-b = Utilizza { -focus-brand-name } quando hai bisogno di cercare qualcosa senza lasciare tracce nel tuo browser principale.
about-private-browsing-focus-promo-header-c = Privacy a un livello superiore per i tuoi dispositivi mobili
about-private-browsing-focus-promo-text-c = { -focus-brand-name } elimina automaticamente la cronologia, oltre a bloccare pubblicità ed elementi traccianti.

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

about-private-browsing-promo-close-button =
  .title = Chiudi

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = La libertà della navigazione anonima in un clic
about-private-browsing-pin-promo-link-text = { PLATFORM() ->
    [macos] Mantieni nel Dock
   *[other] Aggiungi alla barra delle applicazioni
}
about-private-browsing-pin-promo-title = Niente cookie né cronologia, direttamente dal tuo desktop. Naviga come se nessuno ti stesse guardando.

## Strings used in a promotion message for cookie banner reduction

# Simplified version of the headline if the original text doesn't work
# in your language: `See fewer cookie requests`.
about-private-browsing-cookie-banners-promo-header = Stop ai banner per i cookie
about-private-browsing-cookie-banners-promo-button = Riduci i banner per i cookie
about-private-browsing-cookie-banners-promo-message = Consenti a { -brand-short-name } di rispondere automaticamente alle richieste nei pop-up per i cookie, così potrai ritornare a navigare senza distrazioni. Dove possibile, { -brand-short-name } rifiuterà tutte le richieste.

about-private-browsing-felt-privacy-v1-info-header = Non lasciare tracce su questo dispositivo
about-private-browsing-felt-privacy-v1-info-body = { -brand-short-name} elimina i cookie, la cronologia e i dati dei siti web quando chiudi tutte le finestre anonime.
about-private-browsing-felt-privacy-v1-info-link = Chi potrebbe vedere la mia attività?

