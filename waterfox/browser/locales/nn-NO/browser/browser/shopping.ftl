# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = { -brand-product-name }-shopping
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Vurderingskontrollør
shopping-beta-marker = Beta
# This string is for ensuring that screen reader technology
# can read out the "Beta" part of the shopping sidebar header.
# Any changes to shopping-main-container-title and
# shopping-beta-marker should also be reflected here.
shopping-a11y-header =
    .aria-label = vurderingskontrollør - beta
shopping-close-button =
    .title = Lat att
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Lastar…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Pålitelege vurderingar
shopping-letter-grade-description-c = Blanding av pålitelege og upålitelege vurderingar
shopping-letter-grade-description-df = Upålitelege vurderingar
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Tilgjengelege oppdateringar
shopping-message-bar-warning-stale-analysis-message = Start analysatoren { -fakespot-brand-full-name } for å få uppdatert informasjon om ca. 60 sekund.
shopping-message-bar-generic-error-title2 = Ingen informasjon tilgjengeleg akkurat no
shopping-message-bar-generic-error-message = Vi jobbar med å løyse problemet. Prøv på nytt, snart.
shopping-message-bar-warning-not-enough-reviews-title = Ikkje nok vurderingar enno
shopping-message-bar-warning-product-not-available-title = Produktet er ikkje tilgjengeleg
shopping-message-bar-warning-product-not-available-button = Rapporter at dette produktet er på lager igjen
shopping-message-bar-thanks-for-reporting-title = Takk for at du rapporterer!
shopping-message-bar-warning-product-not-available-reported-title2 = Info kjem snart
shopping-message-bar-analysis-in-progress-title2 = Kontrollerer kvaliteten på vurderinga
shopping-message-bar-analysis-in-progress-message2 = Dette vil ta omlag 60 sekund.
shopping-message-bar-page-not-supported-title = Vi klarer ikkje å kontrollere desse vurderingane

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Start analysator på { -fakespot-website-name }

## Strings for the product review snippets card

shopping-highlights-label =
    .label = Høgdepunkt frå nylege vurderingar
shopping-highlight-price = Pris
shopping-highlight-quality = Kvalitet
shopping-highlight-shipping = Frakt
shopping-highlight-competitiveness = Konkurranseevne
shopping-highlight-packaging = Innpakking

## Strings for show more card

shopping-show-more-button = Vis meir
shopping-show-less-button = Vis mindre

## Strings for the settings card

shopping-settings-label =
    .label = Innstillingar
shopping-settings-recommendations-toggle =
    .label = Vis annonsar i vurderingskontrolløren
shopping-settings-opt-out-button = Slå av vurderingskontrolløren

## Strings for the adjusted rating component

# "Adjusted rating" means a star rating that has been adjusted to include only
# reliable reviews.
shopping-adjusted-rating-label =
    .label = Juster vurdering
shopping-adjusted-rating-unreliable-reviews = Upålitelege vurderingar er fjerna

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = Kor pålitelege er vurderingane?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = Korleis vi bestemmer kvaliteten på ei vurdering
shopping-analysis-explainer-adjusted-rating-description = Den <strong>justerte vurderinga</strong> er berre basert på vurderingar som vi meinar er pålitelege.
shopping-analysis-explainer-review-grading-scale-reliable = Pålitelege vurderingar. Vi meinar at vureringane truleg kjem frå ekte kundar som har lagt att ærlege, upartiske vurderingar.
shopping-analysis-explainer-review-grading-scale-mixed = Vi meinar at det finst ei blanding av pålitelege og upålitelege vurderingar.
shopping-analysis-explainer-review-grading-scale-unreliable = Upålitelege vurderingar. Vi meinar at vurderingane sannsynlegvis er falske eller frå partiske vurderarar.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = Opne sidestolpen Shopping
shopping-sidebar-close-button =
    .tooltiptext = Lat att sidestolpen Shopping

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header-2 = Ingen informasjon om desse vurderingane enno
shopping-unanalyzed-product-analyze-button = Kontroller kvaliteten på vurderinga

## Strings for the advertisement

more-to-consider-ad-label =
    .label = Meir å vurdere
ad-by-fakespot = Reklame frå { -fakespot-brand-name }

## Shopping survey strings.

shopping-survey-headline = Hjelp til med å forbetre { -brand-product-name }
shopping-survey-q1-radio-1-label = Svært fornøgd
shopping-survey-q1-radio-2-label = Fornøgd
shopping-survey-q1-radio-3-label = Nøytral
shopping-survey-q1-radio-4-label = Misfornøgd
shopping-survey-q1-radio-5-label = Veldig misfornøgd
shopping-survey-q2-radio-1-label = Ja
shopping-survey-q2-radio-2-label = Nei
shopping-survey-q2-radio-3-label = Eg veit ikkje
shopping-survey-next-button-label = Neste
shopping-survey-submit-button-label = Send inn
shopping-survey-terms-link = Brukarvilkår
shopping-survey-thanks-message = Takk for tilbakemeldinga di!

## Shopping Feature Callout strings.
## "price tag" refers to the price tag icon displayed in the address bar to
## access the feature.

shopping-callout-pdp-opted-in-title = Er desse vurderingane pålitelege? Finn raskt ut av det.
shopping-callout-closed-not-opted-in-title = Eitt klikk frå pålitelege vurderingar
