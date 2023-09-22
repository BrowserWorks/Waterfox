# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = Shopping i { -brand-product-name }
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Verificering af anmeldelser
shopping-close-button =
    .title = Luk
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Indlæser…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Pålidelige anmeldelser
shopping-letter-grade-description-c = Blanding af pålidelige og upålidelige anmeldelser
shopping-letter-grade-description-df = Upålidelige anmeldelser
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Tilgængelige opdateringer
shopping-message-bar-warning-stale-analysis-message = Start værktøjet { -fakespot-brand-full-name } for at få opdaterede oplysninger om cirka 60 sekunder.
shopping-message-bar-generic-error-title = Analyse er ikke tilgængelig lige nu
shopping-message-bar-generic-error-message = Vi arbejder på at løse problemet. Prøv igen om lidt.
shopping-message-bar-warning-not-enough-reviews-title = Ikke nok anmeldelser lige nu
shopping-message-bar-warning-not-enough-reviews-message = Vi kan analysere anmeldelserne af produktet, når der er kommet flere af dem.
shopping-message-bar-warning-product-not-available-title = Produktet er ikke tilgængeligt
shopping-message-bar-warning-product-not-available-message = Hvis du lægger mærke til at produkter er på lager igen, må du gerne rapportere det til os. Så kan vi opdatere analysen.
shopping-message-bar-warning-product-not-available-button = Rapporter at produktet er på lager igen
shopping-message-bar-thanks-for-reporting-title = Tak for hjælpen!
shopping-message-bar-thanks-for-reporting-message = Vi burde have en opdateret analyse klar indenfor 24 timer. Tjek igen senere.
shopping-message-bar-warning-product-not-available-reported-title = Analyse kommer snart
shopping-message-bar-warning-product-not-available-reported-message = En opdateret analyse burde være klar indenfor 24 timer. Tjek igen senere.
shopping-message-bar-warning-offline-title = Ingen netværksforbindelse
shopping-message-bar-warning-offline-message = Kontroller din netværksforbindelse. Genindlæs derefter siden.
shopping-message-bar-analysis-in-progress-title = Analyse kommer snart
shopping-message-bar-analysis-in-progress-message = Når den er klar, viser vi automatisk opdateret info her.

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Start analyse på { -fakespot-website-name }

## Strings for the product review snippets card

shopping-highlights-label =
    .label = Højdepunkter fra de seneste anmeldelser
shopping-highlight-price = Pris
shopping-highlight-quality = Kvalitet
shopping-highlight-shipping = Forsendelse
shopping-highlight-competitiveness = Konkurrencedygtighed
shopping-highlight-packaging = Emballage

## Strings for show more card

shopping-show-more-button = Vis flere
shopping-show-less-button = Vis færre

## Strings for the settings card

shopping-settings-label =
    .label = Indstillinger
shopping-settings-recommendations-toggle =
    .label = Vis reklamer i verificering af anmeldelser
shopping-settings-recommendations-learn-more = Du vil til tider få vist reklamer for relevante produkter. Alle reklamer skal overholde vores standarder for anmeldelses-kvalitet. <a data-l10n-name="review-quality-url">Læs mere</a>
shopping-settings-opt-out-button = Slå verificering af anmeldelser fra
powered-by-fakespot = Verificering af anmeldelser er leveret af <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>.

## Strings for the adjusted rating component

shopping-adjusted-rating-label =
    .label = Justeret bedømmelse
shopping-adjusted-rating-unreliable-reviews = Upålidelige anmeldelser er blevet fjernet

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = Hvor pålidelige er anmeldelserne?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = Sådan afgør vi kvaliteten af anmeldelser
shopping-analysis-explainer-intro =
    Vi bruger kunstig intelligens fra { -fakespot-brand-full-name } til at analysere pålideligheden af produktanmeldelser.
    Denne analyse hjælper dig kun med at bedømme kvaliteten af anmeldelserne, ikke selve produkternes kvalitet.
shopping-analysis-explainer-grades-intro = Vi giver hver produkts anmeldelser en <strong>karakter</strong> fra A til F.
shopping-analysis-explainer-adjusted-rating-description = Den <strong>justerede bedømmelse</strong> er udelukkende baseret på anmeldelser, som vi vurderer er pålidelige.
shopping-analysis-explainer-learn-more = Læs mere om, <a data-l10n-name="review-quality-url">hvordan { -fakespot-brand-full-name } afgør kvaliteten af anmeldelser</a>.
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = <strong>Højdepunkter</strong> stammer fra { $retailer }-anmeldelser fra de seneste 80 dage, som vi vurderer er pålidelige.
shopping-analysis-explainer-review-grading-scale-reliable = Pålidelige anmeldelser. Vi vurderer, at anmeldelserne sandsynligvis stammer fra rigtige kunder, der har givet ærlige og upartiske anmeldelser.
shopping-analysis-explainer-review-grading-scale-mixed = Vi vurderer, at der findes en blanding af pålidelige og upålidelige anmeldelser.
shopping-analysis-explainer-review-grading-scale-unreliable = Upålidelige anmeldelser. Vi vurderer, at anmeldelserne sandsynligvis er forfalskede eller stammer fra partiske anmeldere.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = Vis sidepanelet Shopping
shopping-sidebar-close-button =
    .tooltiptext = Luk sidepanelet Shopping

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header = Ingen analyse af disse anmeldelser endnu
shopping-unanalyzed-product-message = Start { -fakespot-brand-full-name }-analysen og få om cirka 60 sekunder at vide, om anmeldelser af dette produkter er pålidelige.
shopping-unanalyzed-product-analyze-link = Start analyse på { -fakespot-website-name }

## Strings for the advertisement

more-to-consider-ad-label =
    .label = Mere at overveje
ad-by-fakespot = Reklame fra { -fakespot-brand-name }
