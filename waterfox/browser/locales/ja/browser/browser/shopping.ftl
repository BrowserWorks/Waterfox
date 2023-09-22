# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = { -brand-product-name } ショッピング
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = レビューチェッカー
shopping-close-button =
    .title = 閉じる
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = 読み込み中...

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = 信頼できるレビュー
shopping-letter-grade-description-c = 信頼できるレビューとできないものが混在
shopping-letter-grade-description-df = 信頼できないレビュー
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = 更新可能
shopping-message-bar-warning-stale-analysis-message = { -fakespot-brand-full-name } アナライザーを起動して約 60 秒で更新情報を取得します。
shopping-message-bar-generic-error-title = 解析が利用できません
shopping-message-bar-generic-error-message = 現在、問題の解決に取り組んでいます。後でもう一度確認してください。
shopping-message-bar-warning-not-enough-reviews-title = まだ十分な数のレビューがありません
shopping-message-bar-warning-not-enough-reviews-message = この製品に解析可能な数のレビューが掲載されるまでお待ちください。
shopping-message-bar-warning-product-not-available-title = 製品が利用できません
shopping-message-bar-warning-product-not-available-message = この製品が再入荷されている場合はご報告ください。解析情報の更新に役立てられます。
shopping-message-bar-warning-product-not-available-button = 製品が再入荷されたことを報告する
shopping-message-bar-thanks-for-reporting-title = ご報告ありがとうございます。
shopping-message-bar-thanks-for-reporting-message = 解析情報は 24 時間以内に更新されます。後でもう一度確認してください。
shopping-message-bar-warning-product-not-available-reported-title = まもなく解析されます
shopping-message-bar-warning-product-not-available-reported-message = 解析情報が 24 時間以内に利用可能になります。後でもう一度確認してください。
shopping-message-bar-warning-offline-title = ネットワーク接続がありません
shopping-message-bar-warning-offline-message = ネットワーク接続を確認し、ページを再度読み込んでみてください。
shopping-message-bar-analysis-in-progress-title = まもなく解析されます
shopping-message-bar-analysis-in-progress-message = 解析完了後、ここに更新情報が自動的に表示されます。

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = { -fakespot-website-name } でアナライザーを起動

## Strings for the product review snippets card

shopping-highlights-label =
    .label = 最近の注目レビュー
shopping-highlight-price = 価格
shopping-highlight-quality = 品質
shopping-highlight-shipping = 出荷
shopping-highlight-competitiveness = 競争力
shopping-highlight-packaging = 梱包状態

## Strings for show more card

shopping-show-more-button = さらに表示
shopping-show-less-button = 表示を減らす

## Strings for the settings card

shopping-settings-label =
    .label = 設定
shopping-settings-recommendations-toggle =
    .label = レビューチェッカーに広告を表示する
shopping-settings-recommendations-learn-more = 時々、関連製品の広告が表示されます。すべての広告は私たちのレビュー品質標準に適合しています。<a data-l10n-name="review-quality-url">詳細情報</a>
shopping-settings-opt-out-button = レビューチェッカーをオフにする
powered-by-fakespot = レビューチェッカーは <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a> の機能です。

## Strings for the adjusted rating component

shopping-adjusted-rating-label =
    .label = レートが調整されています
shopping-adjusted-rating-unreliable-reviews = 信頼できないレビューを削除しました

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = これらのレビューはどのくらい信頼できますか？

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = レビュー品質の決定方法について
shopping-analysis-explainer-intro =
    私たちは、{ -fakespot-brand-full-name } の AI 技術を用いて製品レビューの信頼性を解析します。
    この解析は、製品そのものの品質ではなく、製品の信頼できるレビューへのアクセスを助けるものです。
shopping-analysis-explainer-grades-intro =
    私たちは、各製品のレビューを A から F までの <strong>レターグレード</strong> で評価します。
shopping-analysis-explainer-adjusted-rating-description =
    <strong>調整されたレート</strong> は私たちが信頼するに足ると評価したレビューのみを基にしています。
shopping-analysis-explainer-learn-more =
    詳細は、<a data-l10n-name="review-quality-url">{ -fakespot-brand-full-name } によるレビュー品質の決定方法について</a> をご覧ください。

# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = <strong>注目レビュー</strong> は最近 80 日以内の { $retailer } からのレビューで私たちが信頼するに足ると評価したものです。
shopping-analysis-explainer-review-grading-scale-reliable = 信頼できるレビューです。これは正直で偏見を持たない本物の顧客によるレビューであると思われます。
shopping-analysis-explainer-review-grading-scale-mixed = 信頼できるレビューと信頼できないレビューが混在していると思われます。
shopping-analysis-explainer-review-grading-scale-unreliable = 信頼できないレビューです。これは偽物または偏見を持ったレビュアーによるレビューであると思われます。

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = ショッピングサイドバーを開きます
shopping-sidebar-close-button =
    .tooltiptext = ショッピングサイドバーを閉じます

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header = これらのレビューはまだ解析されていません
shopping-unanalyzed-product-message = { -fakespot-brand-full-name } アナライザーを起動してください。約 60 秒以内にこの製品のレビューの信頼性が評価されます。
shopping-unanalyzed-product-analyze-link = { -fakespot-website-name } でアナライザーを起動

## Strings for the advertisement

more-to-consider-ad-label =
    .label = さらに検討する
ad-by-fakespot = { -fakespot-brand-name } による広告
