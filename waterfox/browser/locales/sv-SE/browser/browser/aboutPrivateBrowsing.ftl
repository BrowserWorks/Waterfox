# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

privatebrowsingpage-open-private-window-label = Öppna ett privat fönster
    .accesskey = p
about-private-browsing-search-placeholder = Sök på nätet
about-private-browsing-info-title = Du är i ett privat fönster
about-private-browsing-search-btn =
    .title = Sök på webben
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
about-private-browsing-info-description-private-window = Privat fönster: { -brand-short-name } rensar din sök- och surfhistorik när du stänger alla privata fönster. Detta gör dig inte anonym.
about-private-browsing-info-description-simplified = { -brand-short-name } rensar din sök- och surfhistorik när du stänger alla privata fönster, men det gör dig inte anonym.
about-private-browsing-learn-more-link = Läs mer
about-private-browsing-hide-activity = Dölj din aktivitet och plats, var du än surfar
about-private-browsing-get-privacy = Få integritetsskydd överallt där du surfar
about-private-browsing-hide-activity-1 = Dölj surfaktivitet och plats med { -mozilla-vpn-brand-name }. Ett klick skapar en säker anslutning, även på offentligt Wi-Fi.
about-private-browsing-prominent-cta = Håll dig privat med { -mozilla-vpn-brand-name }
about-private-browsing-focus-promo-cta = Hämta { -focus-brand-name }
about-private-browsing-focus-promo-header = { -focus-brand-name }: Privat surfning när du är på språng
about-private-browsing-focus-promo-text = Vår dedikerade mobilapp för privat surfning rensar din historik och kakor varje gång.

## The following strings will be used for experiments in Fx99 and Fx100

about-private-browsing-focus-promo-header-b = Ta privat surfning till din telefon
about-private-browsing-focus-promo-text-b = Använd { -focus-brand-name } för de privata sökningar som du inte vill att din huvudsakliga mobilwebbläsare ska se.
about-private-browsing-focus-promo-header-c = Sekretess på nästa nivå för mobila enheter
about-private-browsing-focus-promo-text-c = { -focus-brand-name } rensar din historik varje gång, samtidigt som annonser och spårare blockeras.
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
about-private-browsing-promo-close-button =
    .title = Stäng

## Strings used in a “pin promotion” message, which prompts users to pin a private window

about-private-browsing-pin-promo-header = Privat surffrihet med ett klick
about-private-browsing-pin-promo-link-text =
    { PLATFORM() ->
        [macos] Behåll i Dock
       *[other] Fäst i aktivitetsfältet
    }
about-private-browsing-pin-promo-title = Inga sparade kakor eller historik, direkt från ditt skrivbord. Surfa som om ingen tittar.
