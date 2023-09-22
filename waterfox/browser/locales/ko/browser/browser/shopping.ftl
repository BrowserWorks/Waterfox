# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = { -brand-product-name } 쇼핑
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = 리뷰 검사기
shopping-beta-marker = Beta
# This string is for ensuring that screen reader technology
# can read out the "Beta" part of the shopping sidebar header.
# Any changes to shopping-main-container-title and
# shopping-beta-marker should also be reflected here.
shopping-a11y-header =
    .aria-label = 리뷰 검사기 - beta
shopping-close-button =
    .title = 닫기
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = 로드 중…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = 신뢰할 수 있는 리뷰
shopping-letter-grade-description-c = 신뢰할 수 있는 리뷰와 신뢰할 수 없는 리뷰가 혼합됨
shopping-letter-grade-description-df = 신뢰할 수 없는 리뷰
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = 업데이트 사용 가능
shopping-message-bar-warning-stale-analysis-message = { -fakespot-brand-full-name } 분석기를 실행하면 약 60초 안에 업데이트된 정보를 얻을 수 있습니다.
shopping-message-bar-generic-error-title2 = 현재 사용 가능한 정보가 없음
shopping-message-bar-generic-error-message = 문제를 해결하기 위해 노력하고 있습니다. 곧 다시 확인하시기 바랍니다.
shopping-message-bar-warning-not-enough-reviews-title = 아직 리뷰가 충분하지 않음
shopping-message-bar-warning-not-enough-reviews-message2 = 이 제품에 대한 리뷰가 더 많아지면 품질을 확인할 수 있을 것입니다.
shopping-message-bar-warning-product-not-available-title = 제품을 사용할 수 없음
shopping-message-bar-warning-product-not-available-message2 = 이 제품이 재입고된 것을 확인하시면, 보고해 주시면 리뷰를 확인하도록 하겠습니다.
shopping-message-bar-warning-product-not-available-button = 이 제품이 재입고되었다고 보고
shopping-message-bar-thanks-for-reporting-title = 보고해 주셔서 감사합니다!
shopping-message-bar-thanks-for-reporting-message2 = 24시간 이내에 이 제품의 리뷰에 대한 정보를 받아야 합니다. 다시 확인해 주세요.
shopping-message-bar-warning-product-not-available-reported-title2 = 곧 정보 제공 예정
shopping-message-bar-warning-product-not-available-reported-message2 = 24시간 이내에 이 제품의 리뷰에 대한 정보를 받아야 합니다. 다시 확인해 주세요.
shopping-message-bar-analysis-in-progress-title2 = 리뷰 품질 확인 중
shopping-message-bar-analysis-in-progress-message2 = 이 작업은 약 60초 정도 걸릴 수 있습니다.
shopping-message-bar-page-not-supported-title = 리뷰를 확인할 수 없음
shopping-message-bar-page-not-supported-message = 안타깝게도 특정 유형의 제품에 대해서는 리뷰 품질을 확인할 수 없습니다. 예를 들어 기프트 카드, 스트리밍 동영상, 음악, 게임 등이 있습니다.

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = { -fakespot-website-name }에서 분석기 실행

## Strings for the product review snippets card

shopping-highlights-label =
    .label = 최근 리뷰의 하이라이트
shopping-highlight-price = 가격
shopping-highlight-quality = 품질
shopping-highlight-shipping = 배송
shopping-highlight-competitiveness = 경쟁력
shopping-highlight-packaging = 포장

## Strings for show more card

shopping-show-more-button = 자세히 보기
shopping-show-less-button = 간단히 보기

## Strings for the settings card

shopping-settings-label =
    .label = 설정
shopping-settings-recommendations-toggle =
    .label = 리뷰 검사기에 광고 표시
shopping-settings-recommendations-learn-more = 관련 제품에 대한 광고가 가끔 표시됩니다. 모든 광고는 리뷰 품질 기준을 충족합니다. <a data-l10n-name="review-quality-url">더 알아보기</a>
shopping-settings-opt-out-button = 리뷰 검사기 끄기
powered-by-fakespot = 리뷰 검사기는 <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>을 통해 제공됩니다.

## Strings for the adjusted rating component

# "Adjusted rating" means a star rating that has been adjusted to include only
# reliable reviews.
shopping-adjusted-rating-label =
    .label = 조정된 평점
shopping-adjusted-rating-unreliable-reviews = 신뢰할 수 없는 리뷰는 삭제됨

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = 이 리뷰는 얼마나 신뢰할 수 있나요?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = 리뷰 품질을 결정하는 방법
shopping-analysis-explainer-intro2 =
    { -fakespot-brand-full-name }의 AI 기술을 사용하여 제품 리뷰의 신뢰성을 확인합니다.
    이는 제품 품질이 아닌 리뷰 품질을 평가하는 데에만 도움이 됩니다.
shopping-analysis-explainer-grades-intro = 각 제품의 리뷰에는 A부터 F까지 <strong>문자 등급</strong>이 부여됩니다.
shopping-analysis-explainer-adjusted-rating-description = <strong>조정된 평점</strong>은 신뢰할 수 있다고 믿는 리뷰만을 기반으로 합니다.
shopping-analysis-explainer-learn-more = <a data-l10n-name="review-quality-url">{ -fakespot-brand-full-name }이 리뷰 품질을 결정하는 방법</a>에 대해 더 알아보세요.
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = <strong>하이라이트</strong>는 지난 80일 동안 신뢰할 수 있는 { $retailer } 리뷰에서 나온 것입니다.
shopping-analysis-explainer-review-grading-scale-reliable = 신뢰할 수 있는 리뷰. 솔직하고 공정한 리뷰를 남긴 실제 고객의 리뷰일 가능성이 높다고 생각합니다.
shopping-analysis-explainer-review-grading-scale-mixed = 신뢰할 수 있는 리뷰와 신뢰할 수 없는 리뷰가 혼합되어 있다고 생각합니다.
shopping-analysis-explainer-review-grading-scale-unreliable = 신뢰할 수 없는 리뷰. 리뷰가 가짜이거나 편향된 리뷰어의 리뷰일 가능성이 있다고 생각합니다.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = 쇼핑 사이드바 열기
shopping-sidebar-close-button =
    .tooltiptext = 쇼핑 사이드바 닫기

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header-2 = 이 리뷰에 대한 정보가 아직 없음
shopping-unanalyzed-product-message-2 = 이 제품의 리뷰가 신뢰할 수 있는지 확인하려면 리뷰 품질을 확인하세요. 약 60초밖에 걸리지 않습니다.
shopping-unanalyzed-product-analyze-button = 리뷰 품질 확인

## Strings for the advertisement

more-to-consider-ad-label =
    .label = 더 보기
ad-by-fakespot = { -fakespot-brand-name }의 광고

## Shopping survey strings.

shopping-survey-headline = { -brand-product-name } 개선에 참여해 주세요.
shopping-survey-question-one = { -brand-product-name }의 리뷰 검사기 경험에 얼마나 만족하시나요?
shopping-survey-q1-radio-1-label = 매우 만족
shopping-survey-q1-radio-2-label = 만족
shopping-survey-q1-radio-3-label = 보통
shopping-survey-q1-radio-4-label = 불만족
shopping-survey-q1-radio-5-label = 매우 불만족
shopping-survey-question-two = 리뷰 검사기를 사용하면 구매 결정을 더 쉽게 내리실 수 있나요?
shopping-survey-q2-radio-1-label = 예
shopping-survey-q2-radio-2-label = 아니오
shopping-survey-q2-radio-3-label = 모름
shopping-survey-next-button-label = 다음
shopping-survey-submit-button-label = 제출
shopping-survey-terms-link = 사용 약관
shopping-survey-thanks-message = 피드백 주셔서 감사합니다!

## Shopping Feature Callout strings.
## "price tag" refers to the price tag icon displayed in the address bar to
## access the feature.

shopping-callout-closed-opted-in-subtitle = 가격표를 볼 때마다 <strong>리뷰 검사기</strong>로 돌아가세요.
shopping-callout-pdp-opted-in-title = 이 리뷰는 신뢰할 수 있나요? 빨리 알아보세요.
shopping-callout-pdp-opted-in-subtitle = 신뢰할 수 없는 리뷰가 제거된 조정된 평점을 보려면 리뷰 검사기를 여세요. 또한 최근 실제 리뷰의 하이라이트를 확인하세요.
shopping-callout-closed-not-opted-in-title = 클릭 한 번으로 신뢰할 수 있는 리뷰를 얻을 수 있습니다.
shopping-callout-closed-not-opted-in-subtitle = 가격표를 볼 때마다 리뷰 검사기를 사용해 보세요. 구매하기 전에 실제 쇼핑객으로부터 빠르게 통찰력을 얻으세요.
