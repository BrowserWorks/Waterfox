# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Öppna ett privat fönster
    .accesskey = p
about-private-browsing-search-placeholder = Sök på nätet
about-private-browsing-info-title = Du är i ett privat fönster
about-private-browsing-info-myths = Vanliga myter om privat surfning
about-private-browsing =
    .title = Sök på nätet
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff =
    .title = Sök med { $engine } eller ange en adress
about-private-browsing-handoff-no-engine =
    .title = Sök eller ange adress
# Variables
#  $engine (String): the name of the user's default search engine
about-private-browsing-handoff-text = Sök med { $engine } eller ange en adress
about-private-browsing-handoff-text-no-engine = Sök eller ange adress
about-private-browsing-not-private = Du är för närvarande inte i ett privat fönster.
about-private-browsing-info-description = { -brand-short-name } rensar din sök- och surfhistorik när du avslutar appen eller stänger alla privata flikar och fönster. Även om det här inte gör dig anonym för webbplatser eller din internetleverantör, gör det det lättare att behålla det du gör online privat från någon annan som använder den här datorn.
about-private-browsing-need-more-privacy = Behöver du mer integritet?
about-private-browsing-turn-on-vpn = Prova { -mozilla-vpn-brand-name }
# This string is the title for the banner for search engine selection
# in a private window.
# Variables:
#   $engineName (String) - The engine name that will currently be used for the private window.
about-private-browsing-search-banner-title = { $engineName } är din standardsökmotor i privata fönster
about-private-browsing-search-banner-description =
    { PLATFORM() ->
        [windows] För att välja en annan sökmotor, gå till <a data-l10n-name="link-options">Inställningar</a>
       *[other] För att välja en annan sökmotor, gå till <a data-l10n-name="link-options">Inställningar</a>
    }
about-private-browsing-search-banner-close-button =
    .aria-label = Stäng
