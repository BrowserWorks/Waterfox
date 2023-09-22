# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title =
    { -brand-product-name.case-status ->
        [with-cases] Nákupy { -brand-product-name(case: "gen") }
       *[no-cases] Nákupy aplikace { -brand-product-name }
    }
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Kontrola recenzí
shopping-close-button =
    .title = Zavřít
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Načítání…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Spolehlivé recenze
shopping-letter-grade-description-c = Směs spolehlivých a nespolehlivých recenzí
shopping-letter-grade-description-df = Nespolehlivé recenze
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Dostupné aktualizace
shopping-message-bar-warning-stale-analysis-message = Spusťte analýzu { -fakespot-brand-full-name } pro načtení aktuálních informací za přibližně 60 sekund.
shopping-message-bar-generic-error-title = Analýza není v tuto chvíli k dispozici
shopping-message-bar-generic-error-message = Pracujeme na vyřešení problému. Zkuste to prosím později.
shopping-message-bar-warning-not-enough-reviews-title = Zatím nemá dostatek recenzí
shopping-message-bar-warning-not-enough-reviews-message = Až bude mít tento produkt více recenzí, budeme je moci analyzovat.
shopping-message-bar-warning-product-not-available-title = Produkt není k dispozici
shopping-message-bar-warning-product-not-available-message = Pokud zjistíte, že je tento produkt opět skladem, nahlaste nám to a my se pokusíme analýzu aktualizovat.
shopping-message-bar-warning-product-not-available-button = Nahlaste, že je tento produkt opět skladem
shopping-message-bar-thanks-for-reporting-title = Děkujeme za nahlášení!
shopping-message-bar-thanks-for-reporting-message = Aktualizovanou analýzu bychom měli mít k dispozici během 24 hodin. Zkuste to prosím později.
shopping-message-bar-warning-product-not-available-reported-title = Analýza bude brzy k dispozici
shopping-message-bar-warning-product-not-available-reported-message = Aktualizovaná analýza by měla být připravena během 24 hodin. Zkuste to prosím později.
shopping-message-bar-warning-offline-title = Žádné připojení k síti
shopping-message-bar-warning-offline-message = Zkontrolujte své připojení k síti. Potom zkuste obnovit stránku.
shopping-message-bar-analysis-in-progress-title = Analýza bude brzy k dispozici
shopping-message-bar-analysis-in-progress-message = Po dokončení se zde automaticky zobrazí aktualizované informace.
shopping-message-bar-page-not-supported-title = Tyto recenze nemůžeme zkontrolovat
shopping-message-bar-page-not-supported-message = Kvalitu recenzí některých typů produktů bohužel nemůžeme kontrolovat. Například dárkové karty a streamovaná videa, hudbu a hry.

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Spustit analýzu na { -fakespot-website-name(case: "loc") }

## Strings for the product review snippets card

shopping-highlights-label =
    .label = Vybrané nedávné recenze
shopping-highlight-price = Cena
shopping-highlight-quality = Kvalita
shopping-highlight-shipping = Doprava
shopping-highlight-competitiveness = Konkurenceschopnost
shopping-highlight-packaging = Balení

## Strings for show more card

shopping-show-more-button = Zobrazit více
shopping-show-less-button = Zobrazit méně

## Strings for the settings card

shopping-settings-label =
    .label = Nastavení
shopping-settings-recommendations-toggle =
    .label = Zobrazovat reklamy v kontrole recenzí
shopping-settings-recommendations-learn-more = Občas uvidíte reklamy na související produkty. Všechny reklamy musí splnit naše standardy kvality. <a data-l10n-name="review-quality-url">Zjistit více</a>
shopping-settings-opt-out-button = Vypnout kontrolu recenzí
powered-by-fakespot = Kontrolu recenzí zajišťuje <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>.

## Strings for the adjusted rating component

shopping-adjusted-rating-label =
    .label = Upravené hodnocení
shopping-adjusted-rating-unreliable-reviews = Nespolehlivé recenze odebrány

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = Jak spolehlivé jsou tyto recenze?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = Jak určujeme kvalitu recenze
shopping-analysis-explainer-intro =
    K analýze spolehlivosti recenzí produktů používáme technologii AI od { -fakespot-brand-full-name(case: "gen") }.
    Tato analýza vám pomůže posoudit pouze kvalitu recenze, nikoli kvalitu produktu.
shopping-analysis-explainer-grades-intro = Recenzím každého produktu přidělujeme <strong>známku písmenem</strong> od A do F.
shopping-analysis-explainer-adjusted-rating-description = <strong>Upravené hodnocení</strong> je založeno pouze na recenzích, které považujeme za spolehlivé.
shopping-analysis-explainer-learn-more = Přečtěte si další informace o tom, <a data-l10n-name="review-quality-url">jak { -fakespot-brand-full-name } určuje kvalitu recenze</a>.
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = <strong>Výběr</strong> z recenzí { $retailer } za posledních 80 dní, které považujeme za spolehlivé.
shopping-analysis-explainer-review-grading-scale-reliable = Spolehlivé recenze. Věříme, že recenze pocházejí pravděpodobně od skutečných zákazníků, kteří zanechali upřímné a nezaujaté recenze.
shopping-analysis-explainer-review-grading-scale-mixed = Věříme, že je zde směs spolehlivých a nespolehlivých recenzí.
shopping-analysis-explainer-review-grading-scale-unreliable = Nespolehlivé recenze. Domníváme se, že tyto recenze jsou pravděpodobně falešné a nebo od zaujatých recenzentů.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = Otevřít postranní lištu nakupování
shopping-sidebar-close-button =
    .tooltiptext = Zavřít postranní lištu nakupování

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header = Analýza těchto recenzí ještě neexistuje
shopping-unanalyzed-product-message = Spusťte analýzu pomocí { -fakespot-brand-full-name(case: "gen") } a přibližně za 60 sekund budete vědět, zda jsou recenze tohoto produktu spolehlivé.
shopping-unanalyzed-product-analyze-link = Spustit analýzu na { -fakespot-website-name(case: "loc") }

## Strings for the advertisement

more-to-consider-ad-label =
    .label = Další ke zvážení
ad-by-fakespot = Reklama od { -fakespot-brand-name(case: "gen") }
