# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Een privévenster openen
    .accesskey = p
about-private-browsing-search-placeholder = Zoeken op het web
about-private-browsing-info-title = U bevindt zich in een privévenster
about-private-browsing-info-myths = Veelgehoorde mythes over privénavigatie
about-private-browsing =
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
about-private-browsing-info-description = { -brand-short-name } wist uw zoek- en browsergeschiedenis zodra u de toepassing afsluit of alle privénavigatietabbladen en -vensters sluit. Hoewel privénavigatie u niet anoniem maakt voor websites of uw internetprovider, maakt dit het makkelijker om wat u online doet privé te houden ten opzichte van anderen die deze computer gebruiken.
about-private-browsing-need-more-privacy = Meer privacy nodig?
about-private-browsing-turn-on-vpn = Probeer { -mozilla-vpn-brand-name }
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
