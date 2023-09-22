# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = Einkaufen in { -brand-product-name }
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Rezensionsprüfer
shopping-close-button =
    .title = Schließen
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Wird geladen…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Zuverlässige Bewertungen
shopping-letter-grade-description-c = Mischung aus zuverlässigen und unzuverlässigen Bewertungen
shopping-letter-grade-description-df = Unzuverlässige Bewertungen
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } – { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Updates verfügbar
shopping-message-bar-warning-stale-analysis-message = Starten Sie den { -fakespot-brand-full-name }-Analysierer, um in ca. 60 Sekunden aktuelle Informationen zu erhalten.
shopping-message-bar-generic-error-title = Analyse derzeit nicht verfügbar
shopping-message-bar-generic-error-message = Wir arbeiten an einer Lösung des Problems. Bitte schauen Sie bald wieder vorbei.
shopping-message-bar-warning-not-enough-reviews-title = Noch nicht genügend Bewertungen
shopping-message-bar-warning-not-enough-reviews-message = Wenn dieses Produkt mehr Bewertungen hat, können wir diese analysieren.
shopping-message-bar-warning-product-not-available-title = Produkt ist nicht verfügbar
shopping-message-bar-warning-product-not-available-message = Wenn Sie sehen, dass dieses Produkt wieder auf Lager ist, melden Sie es uns und wir arbeiten an der Aktualisierung der Analyse.
shopping-message-bar-warning-product-not-available-button = Melden, dass dieses Produkt wieder auf Lager ist
shopping-message-bar-thanks-for-reporting-title = Danke für die Meldung!
shopping-message-bar-thanks-for-reporting-message = Wir sollten innerhalb von 24 Stunden eine aktualisierte Analyse haben. Bitte versuchen Sie es später noch einmal.
shopping-message-bar-warning-product-not-available-reported-title = Die Analyse kommt in Kürze
shopping-message-bar-warning-product-not-available-reported-message = Eine aktualisierte Analyse sollte innerhalb von 24 Stunden bereit sein. Bitte versuchen Sie es später noch einmal.
shopping-message-bar-warning-offline-title = Keine Netzwerkverbindung
shopping-message-bar-warning-offline-message = Überprüfen Sie Ihre Netzwerkverbindung. Versuchen Sie dann, die Seite neu zu laden.
shopping-message-bar-analysis-in-progress-title = Die Analyse kommt in Kürze
shopping-message-bar-analysis-in-progress-message = Wenn es fertig ist, zeigen wir hier automatisch die aktualisierten Informationen an.
shopping-message-bar-page-not-supported-title = Wir können diese Bewertungen nicht überprüfen
shopping-message-bar-page-not-supported-message = Leider können wir die Qualität der Bewertungen für bestimmte Arten von Produkten nicht überprüfen. Zum Beispiel Geschenkkarten und Video-Streaming, Musik und Spiele.

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Analysierer auf { -fakespot-website-name } starten

## Strings for the product review snippets card

shopping-highlights-label =
    .label = Highlights aus den neuesten Bewertungen
shopping-highlight-price = Preis
shopping-highlight-quality = Qualität
shopping-highlight-shipping = Versand
shopping-highlight-competitiveness = Wettbewerbsfähigkeit
shopping-highlight-packaging = Verpackung

## Strings for show more card

shopping-show-more-button = Mehr anzeigen
shopping-show-less-button = Weniger anzeigen

## Strings for the settings card

shopping-settings-label =
    .label = Einstellungen
shopping-settings-recommendations-toggle =
    .label = Werbung im Rezensionsprüfer anzeigen
shopping-settings-recommendations-learn-more = Sie sehen gelegentlich Anzeigen für relevante Produkte. Alle Anzeigen müssen unseren Qualitätsstandards für Bewertungen entsprechen. <a data-l10n-name="review-quality-url">Weitere Informationen</a>
shopping-settings-opt-out-button = Rezensionsprüfer abschalten
powered-by-fakespot = Der Rezensionsprüfer wird bereitgestellt von <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>.

## Strings for the adjusted rating component

shopping-adjusted-rating-label =
    .label = Bewertungen angepasst
shopping-adjusted-rating-unreliable-reviews = Unzuverlässige Bewertungen entfernt

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = Wie zuverlässig sind diese Bewertungen?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = Wie wir die Qualität einer Bewertung bestimmen
shopping-analysis-explainer-intro =
    Wir verwenden die KI-Technologie von { -fakespot-brand-full-name }, um die Zuverlässigkeit von Produktbewertungen zu analysieren.
    Diese Analyse hilft Ihnen nur bei der Bewertung der Qualität der Bewertung, nicht der Produktqualität.
shopping-analysis-explainer-grades-intro = Wir geben den Bewertungen jedes Produkts eine <strong>Bewertung</strong> von A bis F.
shopping-analysis-explainer-adjusted-rating-description = Die <strong>angepasste Bewertung</strong> basiert nur auf Bewertungen, die wir für zuverlässig halten.
shopping-analysis-explainer-learn-more = Erfahren Sie mehr darüber, <a data-l10n-name="review-quality-url">wie { -fakespot-brand-full-name } die Qualität von Bewertungen</a> bestimmt.
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = <strong>Highlights</strong> stammen von { $retailer }-Bewertungen innerhalb der letzten 80 Tage, die wir für zuverlässig halten.
shopping-analysis-explainer-review-grading-scale-reliable = Zuverlässige Bewertungen. Wir glauben, dass die Bewertungen von echten Kunden stammen, die ehrliche und unvoreingenommene Bewertungen hinterlassen.
shopping-analysis-explainer-review-grading-scale-mixed = Wir glauben, dass es eine Mischung aus zuverlässigen und unzuverlässigen Bewertungen gibt.
shopping-analysis-explainer-review-grading-scale-unreliable = Unzuverlässige Bewertungen. Wir glauben, dass die Bewertungen wahrscheinlich gefälscht, oder von voreingenommenen Bewertern sind.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = Einkaufen-Sidebar öffnen
shopping-sidebar-close-button =
    .tooltiptext = Einkaufen-Sidebar schließen

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header = Noch keine Analyse für diese Bewertungen
shopping-unanalyzed-product-message = Starten Sie den { -fakespot-brand-full-name }-Analysierer und in etwa 60 Sekunden wissen Sie, ob die Bewertungen dieses Produkts zuverlässig sind.
shopping-unanalyzed-product-analyze-link = Analysierer auf { -fakespot-website-name } starten

## Strings for the advertisement

more-to-consider-ad-label =
    .label = Weitere Möglichkeiten
ad-by-fakespot = Anzeige von { -fakespot-brand-name }
