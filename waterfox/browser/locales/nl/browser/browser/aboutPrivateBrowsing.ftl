# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Een privévenster openen
    .accesskey = p
about-private-browsing-search-placeholder = Zoeken op het web
about-private-browsing-info-title = U bevindt zich in een privévenster
about-private-browsing-search-btn =
    .title = Zoeken op het web
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Met { $engine } zoeken of voer adres in
about-private-browsing-handoff-no-engine =
    .title = Voer zoekterm of adres in
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Met { $engine } zoeken of voer adres in
about-private-browsing-handoff-text-no-engine = Voer zoekterm of adres in
about-private-browsing-not-private = U bevindt zich momenteel niet in een privévenster.
about-private-browsing-info-description-private-window = Privévenster: { -brand-short-name } wist uw zoek- en navigatiegeschiedenis wanneer u alle privévensters sluit. Dit maakt u niet anoniem.
about-private-browsing-info-description-simplified = { -brand-short-name } wist uw zoek- en navigatiegeschiedenis wanneer u alle privévensters sluit, maar dit maakt u niet anoniem.
about-private-browsing-learn-more-link = Meer info
about-private-browsing-hide-activity = Verberg uw activiteit en locatie, overal waar u surft
about-private-browsing-get-privacy = Ontvang privacybescherming overal waar u surft
about-private-browsing-hide-activity-1 = Verberg uw surfactiviteiten en locatie met { -mozilla-vpn-brand-name }. Met één klik maakt u een veilige verbinding, zelfs op openbare wifi.
about-private-browsing-prominent-cta = Blijf privé met { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = { -focus-brand-name } downloaden
about-private-browsing-focus-promo-header = { -focus-brand-name }: privénavigatie onderweg
about-private-browsing-focus-promo-text = Onze speciale mobiele app voor privénavigatie wist elke keer uw geschiedenis en cookies.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Breng privénavigatie naar uw telefoon
about-private-browsing-focus-promo-text-b = Gebruik { -focus-brand-name } voor die privézoekopdrachten waarvan u niet wilt dat uw mobiele standaardbrowser ze ziet.
about-private-browsing-focus-promo-header-c = Privacy op mobiel op het volgende niveau
about-private-browsing-focus-promo-text-c = { -focus-brand-name } wist elke keer uw geschiedenis, terwijl advertenties en trackers worden geblokkeerd.
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } is uw standaardzoekmachine in privévensters
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] Ga naar <a data-l10n-name="link-options">Opties</a> om een andere zoekmachine te selecteren
       *[other] Ga naar <a data-l10n-name="link-options">Voorkeuren</a> om een andere zoekmachine te selecteren
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Sluiten
about-private-browsing-promo-close-button =
    .title = Sluiten

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = De vrijheid van privénavigatie in één klik
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] In Dock zetten
       *[other] Aan taakbalk vastzetten
    }
about-private-browsing-pin-promo-title = Geen opgeslagen cookies of geschiedenis, rechtstreeks vanaf uw bureaublad. Surf alsof niemand kijkt.
