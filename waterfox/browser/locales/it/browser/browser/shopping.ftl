# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = Shopping in { -brand-product-name }
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Verifica recensioni
shopping-beta-marker = Beta
# This string is for ensuring that screen reader technology
# can read out the "Beta" part of the shopping sidebar header.
# Any changes to shopping-main-container-title and
# shopping-beta-marker should also be reflected here.
shopping-a11y-header =
    .aria-label = Verifica recensioni - beta
shopping-close-button =
    .title = Chiudi
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Caricamento…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Recensioni affidabili
shopping-letter-grade-description-c = Un misto di recensioni affidabili e inaffidabili
shopping-letter-grade-description-df = Recensioni inaffidabili
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Aggiornamenti disponibili
shopping-message-bar-warning-stale-analysis-message = Avvia lo strumento di analisi di { -fakespot-brand-full-name } per ottenere informazioni aggiornate in circa 60 secondi.
shopping-message-bar-warning-stale-analysis-message-2 = Nuove informazioni da controllare
shopping-message-bar-warning-stale-analysis-button = Controlla adesso
shopping-message-bar-generic-error-title2 = Nessuna informazione disponibile al momento
shopping-message-bar-generic-error-message = Stiamo lavorando per risolvere il problema. Ricontrolla a breve.
shopping-message-bar-warning-not-enough-reviews-title = Non ci sono ancora abbastanza recensioni
shopping-message-bar-warning-not-enough-reviews-message2 = Non appena questo prodotto avrà più recensioni, saremo in grado di verificarne la qualità.
shopping-message-bar-warning-product-not-available-title = Il prodotto non è disponibile
shopping-message-bar-warning-product-not-available-message2 = Se noti che questo prodotto è di nuovo disponibile, segnalacelo e lavoreremo per verificarne le recensioni.
shopping-message-bar-warning-product-not-available-button = Segnala che questo prodotto è di nuovo disponibile
shopping-message-bar-thanks-for-reporting-title = Grazie per la segnalazione!
shopping-message-bar-thanks-for-reporting-message2 = Dovremmo avere informazioni su questo prodotto entro 24 ore. Ricontrolla più tardi.
shopping-message-bar-warning-product-not-available-reported-title2 = Informazioni disponibili a breve
shopping-message-bar-warning-product-not-available-reported-message2 = Dovremmo avere informazioni su questo prodotto entro 24 ore. Ricontrolla più tardi.
shopping-message-bar-analysis-in-progress-title2 = Verifica qualità recensioni
shopping-message-bar-analysis-in-progress-message2 = Questa operazione potrebbe richiedere circa 60 secondi.
shopping-message-bar-page-not-supported-title = Impossibile verificare queste recensioni
shopping-message-bar-page-not-supported-message = Purtroppo non è possibile verificare la qualità delle recensioni per alcuni tipi di prodotto come carte regalo, video in streaming e giochi.

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Avvia lo strumento di analisi su { -fakespot-website-name }

## Strings for the product review snippets card

shopping-highlights-label =
    .label = In evidenza dalle recensioni recenti
shopping-highlight-price = Prezzo
shopping-highlight-quality = Qualità
shopping-highlight-shipping = Spedizione
shopping-highlight-competitiveness = Competitività
shopping-highlight-packaging = Imballaggio

## Strings for show more card

shopping-show-more-button = Mostra dettagli
shopping-show-less-button = Nascondi dettagli

## Strings for the settings card

shopping-settings-label =
    .label = Impostazioni
shopping-settings-recommendations-toggle =
    .label = Mostra annunci nella verifica recensioni
shopping-settings-recommendations-learn-more = Verranno visualizzati annunci occasionali per prodotti pertinenti. Tutti gli annunci devono soddisfare i nostri standard di qualità per le recensioni. <a data-l10n-name="review-quality-url">Ulteriori informazioni</a>
shopping-settings-opt-out-button = Disattiva la verifica recensioni
powered-by-fakespot = Verifica recensioni con tecnologia <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>.

## Strings for the adjusted rating component

# "Adjusted rating" means a star rating that has been adjusted to include only
# reliable reviews.
shopping-adjusted-rating-label =
    .label = Valutazione rettificata
shopping-adjusted-rating-unreliable-reviews = Recensioni inaffidabili rimosse

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = Quanto sono affidabili queste recensioni?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = Come determiniamo la qualità delle recensioni
shopping-analysis-explainer-intro2 = Utilizziamo la tecnologia IA di { -fakespot-brand-full-name } per analizzare l’affidabilità delle recensioni sui prodotti. Questa analisi ti aiuterà a valutare solo la qualità delle recensioni, non quella del prodotto.
shopping-analysis-explainer-grades-intro = Assegniamo alle recensioni di ogni prodotto un <strong>voto in lettere</strong> dalla A alla F.
shopping-analysis-explainer-adjusted-rating-description = La <strong>valutazione rettificata</strong> si basa esclusivamente su recensioni che riteniamo affidabili.
shopping-analysis-explainer-learn-more = Scopri ulteriori informazioni su <a data-l10n-name="review-quality-url">come { -fakespot-brand-full-name } determina la qualità delle recensioni</a>.
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = Gli elementi <strong>in evidenza</strong> provengono dalle recensioni su { $retailer } degli ultimi 80 giorni che riteniamo affidabili.
shopping-analysis-explainer-review-grading-scale-reliable = Recensioni affidabili. Riteniamo che le recensioni provengano con buona probabilità da clienti reali che hanno lasciato recensioni oneste e imparziali.
shopping-analysis-explainer-review-grading-scale-mixed = Crediamo che ci sia un misto di recensioni affidabili e inaffidabili.
shopping-analysis-explainer-review-grading-scale-unreliable = Recensioni inaffidabili. Riteniamo che le recensioni siano false o provenienti da revisori di parte.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = Apri la barra laterale per lo shopping
shopping-sidebar-close-button =
    .tooltiptext = Chiudi la barra laterale per lo shopping

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header-2 = Non ci sono ancora informazioni su queste recensioni
shopping-unanalyzed-product-message-2 = Per sapere se le recensioni di questo prodotto sono affidabili, verificane la qualità. Ci vogliono solo circa 60 secondi.
shopping-unanalyzed-product-analyze-button = Verifica qualità recensioni

## Strings for the advertisement

more-to-consider-ad-label =
    .label = Altri prodotti da valutare
ad-by-fakespot = Annuncio di { -fakespot-brand-name }

## Shopping survey strings.

shopping-survey-headline = Aiutaci a migliorare { -brand-product-name }
shopping-survey-question-one = Quanto sei soddisfatto della tua esperienza con la verifica recensioni di { -brand-product-name }?
shopping-survey-q1-radio-1-label = Molto soddisfatto
shopping-survey-q1-radio-2-label = Soddisfatto
shopping-survey-q1-radio-3-label = Indifferente
shopping-survey-q1-radio-4-label = Insoddisfatto
shopping-survey-q1-radio-5-label = Molto insoddisfatto
shopping-survey-question-two = La verifica recensioni ti ha aiutato a prendere decisioni prima dell’acquisto?
shopping-survey-q2-radio-1-label = Sì
shopping-survey-q2-radio-2-label = No
shopping-survey-q2-radio-3-label = Non so
shopping-survey-next-button-label = Successivo
shopping-survey-submit-button-label = Invia
shopping-survey-terms-link = Condizioni di utilizzo del servizio
shopping-survey-thanks-message = Grazie per aver condiviso la tua opinione.

## Shopping Feature Callout strings.
## "price tag" refers to the price tag icon displayed in the address bar to
## access the feature.

shopping-callout-closed-opted-in-subtitle = Torna alla <strong>verifica recensioni</strong> quando vedi l’icona con il cartellino del prezzo.
shopping-callout-pdp-opted-in-title = Queste recensioni sono affidabili? Scoprilo velocemente.
shopping-callout-pdp-opted-in-subtitle = Apri verifica recensioni per visualizzare la valutazione rettificata dopo aver rimosso le recensioni inaffidabili. Inoltre, scopri i punti salienti estratti da recensioni autentiche inserite di recente.
shopping-callout-closed-not-opted-in-title = Recensioni affidabili in un clic
shopping-callout-closed-not-opted-in-subtitle = Prova verifica recensioni ogni volta che vedi l’icona con il cartellino del prezzo. Ottieni rapidamente informazioni dettagliate da veri acquirenti, prima di acquistare.

## Onboarding message strings.

shopping-onboarding-headline = Prova la nostra guida alle recensioni di prodotti

# Dynamic subtitle. Sites are limited to Amazon, Walmart or Best Buy.
# Variables:
#   $currentSite (str) - The current shopping page name
#   $secondSite (str) - A second shopping page name
#   $thirdSite (str) - A third shopping page name
shopping-onboarding-dynamic-subtitle = Scopri quanto sono affidabili le recensioni dei prodotti su <b>{ $currentSite }</b> prima di acquistarli. Verifica recensioni, una funzione sperimentale di { -vendor-short-name }, è integrata direttamente in { -brand-product-name }. Funziona anche su <b>{ $secondSite }</b> e <b>{ $thirdSite }</b>.
shopping-onboarding-body = Utilizzando la tecnologia di { -fakespot-brand-full-name }, ti aiutiamo a evitare recensioni di parte e non autentiche. Il nostro modello di intelligenza artificiale migliora costantemente per proteggerti mentre fai acquisti. <a data-l10n-name="learn_more">Ulteriori informazioni</a>
shopping-onboarding-opt-in-privacy-policy-and-terms-of-use = Selezionando “{ shopping-onboarding-opt-in-button }“ accetti l’<a data-l10n-name="privacy_policy">informativa sulla privacy</a> e le <a data-l10n-name="terms_of_use">condizioni di utilizzo del servizio</a> di { -fakespot-brand-full-name }.
shopping-onboarding-opt-in-button = Sì, provala
shopping-onboarding-not-now-button = Non adesso
shopping-onboarding-dialog-close-button =
    .title = Chiudi
    .aria-label = Chiudi
