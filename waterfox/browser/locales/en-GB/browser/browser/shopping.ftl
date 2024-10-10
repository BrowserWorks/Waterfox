# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = { -brand-product-name } Shopping
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Review checker
shopping-close-button =
    .title = Close
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Loading…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Reliable reviews
shopping-letter-grade-description-c = Mix of reliable and unreliable reviews
shopping-letter-grade-description-df = Unreliable reviews
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Updates available
shopping-message-bar-warning-stale-analysis-message = Launch the { -fakespot-brand-full-name } analyser to get updated info in about 60 seconds.
shopping-message-bar-generic-error-title = Analysis not available right now
shopping-message-bar-generic-error-message = We’re working to resolve the issue. Please check back soon.
shopping-message-bar-warning-not-enough-reviews-title = Not enough reviews yet
shopping-message-bar-warning-not-enough-reviews-message = When this product has more reviews, we’ll be able to analyse them.
shopping-message-bar-warning-product-not-available-title = Product is not available
shopping-message-bar-warning-product-not-available-message = If you see that this product is back in stock, report it to us and we’ll work on updating the analysis.
shopping-message-bar-warning-product-not-available-button = Report this product is back in stock
shopping-message-bar-thanks-for-reporting-title = Thanks for reporting!
shopping-message-bar-thanks-for-reporting-message = We should have an updated analysis within 24 hours. Please check back.
shopping-message-bar-warning-product-not-available-reported-title = Analysis coming soon
shopping-message-bar-warning-product-not-available-reported-message = An updated analysis should be ready within 24 hours. Please check back.
shopping-message-bar-warning-offline-title = No network connection
shopping-message-bar-warning-offline-message = Check your network connection. Then, try reloading the page.
shopping-message-bar-analysis-in-progress-title = Analysis coming soon
shopping-message-bar-analysis-in-progress-message = When it’s done, we’ll automatically show the updated info here.
shopping-message-bar-page-not-supported-title = We can’t check these reviews
shopping-message-bar-page-not-supported-message = Unfortunately, we can’t check the review quality for certain types of products. For example, gift cards and streaming video, music, and games.

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Launch analyser on { -fakespot-website-name }

## Strings for the product review snippets card

shopping-highlights-label =
    .label = Highlights from recent reviews
shopping-highlight-price = Price
shopping-highlight-quality = Quality
shopping-highlight-shipping = Shipping
shopping-highlight-competitiveness = Competitiveness
shopping-highlight-packaging = Packaging

## Strings for show more card

shopping-show-more-button = Show more
shopping-show-less-button = Show less

## Strings for the settings card

shopping-settings-label =
    .label = Settings
shopping-settings-recommendations-toggle =
    .label = Show ads in review checker
shopping-settings-recommendations-learn-more = You’ll see occasional ads for relevant products. All ads must meet our review quality standards. <a data-l10n-name="review-quality-url">Learn more</a>
shopping-settings-opt-out-button = Turn off review checker
powered-by-fakespot = Review checker is powered by <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>.

## Strings for the adjusted rating component

shopping-adjusted-rating-label =
    .label = Adjusted rating
shopping-adjusted-rating-unreliable-reviews = Unreliable reviews removed

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = How reliable are these reviews?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = How we determine review quality
shopping-analysis-explainer-intro =
    We use AI technology from { -fakespot-brand-full-name } to analyze the reliability of product reviews.
    This analysis will only help you assess review quality, not product quality.
shopping-analysis-explainer-grades-intro = We assign each product’s reviews a <strong>letter grade</strong> from A to F.
shopping-analysis-explainer-adjusted-rating-description = The <strong>adjusted rating</strong> is based only on reviews we believe to be reliable.
shopping-analysis-explainer-learn-more = Learn more about <a data-l10n-name="review-quality-url">how { -fakespot-brand-full-name } determines review quality</a>.
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = <strong>Highlights</strong> are from { $retailer } reviews within the last 80 days that we believe to be reliable.
shopping-analysis-explainer-review-grading-scale-reliable = Reliable reviews. We believe the reviews are likely from real customers who left honest, unbiased reviews.
shopping-analysis-explainer-review-grading-scale-mixed = We believe there’s a mix of reliable and unreliable reviews.
shopping-analysis-explainer-review-grading-scale-unreliable = Unreliable reviews. We believe the reviews are likely fake or from biased reviewers.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = Open shopping sidebar
shopping-sidebar-close-button =
    .tooltiptext = Close shopping sidebar

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header = No analysis for these reviews yet
shopping-unanalyzed-product-message = Launch the { -fakespot-brand-full-name } analyser and you’ll know in about 60 seconds whether this product’s reviews are reliable.
shopping-unanalyzed-product-analyze-link = Launch analyser on { -fakespot-website-name }

## Strings for the advertisement

more-to-consider-ad-label =
    .label = More to consider
ad-by-fakespot = Ad by { -fakespot-brand-name }
