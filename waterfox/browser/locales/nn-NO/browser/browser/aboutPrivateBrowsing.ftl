# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Opne eit privat vindauge
    .accesskey = O
about-private-browsing-search-placeholder = Søk på nettet
about-private-browsing-info-title = Du er i eit privat vindauge
about-private-browsing-search-btn =
    .title = Søk på nettet
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Søk med { $engine } eller skriv inn ei adresse
about-private-browsing-handoff-no-engine =
    .title = Søk eller skriv inn ei adresse
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Søk med { $engine } eller skriv inn ei adresse
about-private-browsing-handoff-text-no-engine = Søk eller skriv inn ei adresse
about-private-browsing-not-private = Du er ikkje i eit privat vindauge no.
about-private-browsing-info-description-private-window = Private vindauge: { -brand-short-name } slettar søkje- og nettlesarloggen din når du lèt att alle private vindauge. Dette gjer deg ikkje anonym.
about-private-browsing-info-description-simplified = { -brand-short-name } slettar søkje- og nettlesarloggen din når du lèt att alle private vindauge, men dette gjer deg ikkje anonym.
about-private-browsing-learn-more-link = Les meir
about-private-browsing-hide-activity = Gøym aktiviteten og plasseringa di, same kvar du surfar
about-private-browsing-get-privacy = Få ivaretaking av personvernet overalt der du surfar
about-private-browsing-hide-activity-1 = Gøym nettlesaraktivitet og plasseringa di med { -mozilla-vpn-brand-name }. Eitt klikk skapar ei trygg tilkopling, sjølv på offentleg Wi-Fi.
about-private-browsing-prominent-cta = Hald deg privat med { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Last ned { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: Privat nettlesing medan du er på farten
about-private-browsing-focus-promo-text = Vår dedikerte mobilapp for privat nettlesing slettar historikken og infokapslane kvar gong.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Ta privat nettlesing til telefonen din
about-private-browsing-focus-promo-text-b = Bruk { -focus-brand-name } for dei private søka du ikkje vil at hovudmobilnettlesaren din skal sjå.
about-private-browsing-focus-promo-header-c = Personvern på neste nivå for mobile einingar
about-private-browsing-focus-promo-text-c = { -focus-brand-name } slettar historikken din kvar gong medan du blokkerer annonsar og sporarar.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } er standard søkjemotor i private vindauge
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] For å velje ein annan søkjemotor, gå til <a data-l10n-name="link-options">Innstillingar</a>.
       *[other] For å veje ein annan søkjemotor, gå til <a data-l10n-name="link-options">Innstillingar</a>.
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Lat att
about-private-browsing-promo-close-button =
    .title = Lat att

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Privat nettlesingsfridom med eitt klikk
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Behald i Dock
       *[other] Fest til oppgåvelinja
    }
about-private-browsing-pin-promo-title = Ingen lagra infokapslar eller historikk, rett frå skrivebordet. Surf som om ingen ser på.
