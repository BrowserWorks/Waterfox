# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = Αγορές { -brand-product-name }
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Έλεγχος κριτικών
shopping-beta-marker = Beta
# This string is for ensuring that screen reader technology
# can read out the "Beta" part of the shopping sidebar header.
# Any changes to shopping-main-container-title and
# shopping-beta-marker should also be reflected here.
shopping-a11y-header =
    .aria-label = Έλεγχος κριτικών - beta
shopping-close-button =
    .title = Κλείσιμο
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Φόρτωση…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Αξιόπιστες κριτικές
shopping-letter-grade-description-c = Μίγμα αξιόπιστων και αναξιόπιστων κριτικών
shopping-letter-grade-description-df = Αναξιόπιστες κριτικές
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Διαθέσιμες ενημερώσεις
shopping-message-bar-warning-not-enough-reviews-title = Δεν υπάρχουν ακόμα αρκετές κριτικές
shopping-message-bar-warning-product-not-available-title = Το προϊόν δεν είναι διαθέσιμο
shopping-message-bar-thanks-for-reporting-title = Ευχαριστούμε για την αναφορά!

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Εκκίνηση ανάλυσης στο { -fakespot-website-name }

## Strings for the product review snippets card

shopping-highlight-price = Τιμή
shopping-highlight-quality = Ποιότητα
shopping-highlight-shipping = Αποστολή
shopping-highlight-competitiveness = Ανταγωνισμός
shopping-highlight-packaging = Συσκευασία

## Strings for show more card

shopping-show-more-button = Εμφάνιση περισσότερων
shopping-show-less-button = Εμφάνιση λιγότερων

## Strings for the settings card

shopping-settings-label =
    .label = Ρυθμίσεις
shopping-settings-recommendations-toggle =
    .label = Εμφάνιση διαφημίσεων στον έλεγχο κριτικών
shopping-settings-opt-out-button = Απενεργοποίηση ελέγχου κριτικών
powered-by-fakespot = Ο έλεγχος κριτικών παρέχεται από το <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>.

## Strings for the adjusted rating component

# "Adjusted rating" means a star rating that has been adjusted to include only
# reliable reviews.
shopping-adjusted-rating-label =
    .label = Προσαρμοσμένη βαθμολογία

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = Πόσο αξιόπιστες είναι αυτές οι κριτικές;

## Strings for the analysis explainer component


## Strings for UrlBar button


## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.


## Strings for the advertisement

more-to-consider-ad-label =
    .label = Περισσότερες εναλλακτικές
ad-by-fakespot = Διαφήμιση από το { -fakespot-brand-name }

## Shopping survey strings.

shopping-survey-q1-radio-1-label = Πολύ ικανοποιημένος/-η
shopping-survey-q1-radio-2-label = Ικανοποιημένος/-η
shopping-survey-q1-radio-3-label = Ουδέτερος/-η
shopping-survey-q1-radio-4-label = Δυσαρεστημένος/-η
shopping-survey-q1-radio-5-label = Πολύ δυσαρεστημένος/-η
shopping-survey-q2-radio-1-label = Ναι
shopping-survey-q2-radio-2-label = Όχι
shopping-survey-q2-radio-3-label = Δεν γνωρίζω
shopping-survey-next-button-label = Επόμενο
shopping-survey-submit-button-label = Υποβολή

## Shopping Feature Callout strings.
## "price tag" refers to the price tag icon displayed in the address bar to
## access the feature.

