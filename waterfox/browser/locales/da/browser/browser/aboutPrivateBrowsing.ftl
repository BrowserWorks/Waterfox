# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Åbn et privat vindue
    .accesskey = p
about-private-browsing-search-placeholder = Søg på nettet
about-private-browsing-info-title = Du befinder dig i et privat vindue
about-private-browsing-search-btn =
    .title = Søg på nettet
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Søg med { $engine } eller indtast en adresse
about-private-browsing-handoff-no-engine =
    .title = Søg eller indtast en adresse
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Søg med { $engine } eller indtast en adresse
about-private-browsing-handoff-text-no-engine = Søg eller indtast adresse
about-private-browsing-not-private = Du befinder dig ikke i et privat vindue.
about-private-browsing-info-description-private-window = Privat vindue: { -brand-short-name } rydder din søge- og browsinghistorik, når du lukker alle private vinduer, men dette gør dig ikke anonym.
about-private-browsing-info-description-simplified = { -brand-short-name } rydder din søge- og browsing-historik, når du lukker alle private vinduer, men dette gør dig ikke anonym.
about-private-browsing-learn-more-link = Læs mere
about-private-browsing-hide-activity = Skjul din aktivitet og din placering
about-private-browsing-get-privacy = Få beskyttet dine private oplysninger overalt på nettet
about-private-browsing-hide-activity-1 = Skjul din placering og din aktivitet på nettet med { -mozilla-vpn-brand-name }. Med ét klik får du en sikker forbindelse, selv på offentlige netværk.
about-private-browsing-prominent-cta = Beskyt dit privatliv med { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Hent { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: Privat browsing på farten
about-private-browsing-focus-promo-text = Vores browser dedikeret til at beskytte dit privatliv sletter automatisk din historik og dine cookies.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Bring privat browsing til din telefon
about-private-browsing-focus-promo-text-b = Brug { -focus-brand-name } til de private søgninger, du ikke ønsker, at din primære mobilbrowser skal se.
about-private-browsing-focus-promo-header-c = Privatliv på næste niveau for mobilen
about-private-browsing-focus-promo-text-c = { -focus-brand-name } rydder din historik hver gang, og blokerer samtidig reklamer og sporings-mekanismer.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } er din standard-søgetjeneste i private vinduer
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Vælg en anden søgetjeneste ved at gå til <a data-l10n-name="link-options">indstillinger</a>
       *[other] Vælg en anden søgetjeneste ved at gå til <a data-l10n-name="link-options">indstillinger</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Luk
about-private-browsing-promo-close-button =
    .title = Luk

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Behold i Dock
       *[other] Fastgør til proceslinjen
    }
about-private-browsing-pin-promo-title = Ingen gemte cookies eller historik, direkte fra dit skrivebord. Brug nettet uden tilskuere.
