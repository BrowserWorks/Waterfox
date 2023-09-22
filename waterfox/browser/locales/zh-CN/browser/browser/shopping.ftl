# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = { -brand-product-name } 购物
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = 核查评价
shopping-close-button =
    .title = 关闭
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = 正在加载…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = 可信评价
shopping-letter-grade-description-c = 可信与不可信评价混杂
shopping-letter-grade-description-df = 不可信评价
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = 有可用更新
shopping-message-bar-warning-stale-analysis-message = 启动 { -fakespot-brand-full-name } 分析工具约 60 秒可获得更新后的信息。
shopping-message-bar-generic-error-title = 暂时无法分析
shopping-message-bar-generic-error-message = 我们正努力解决此问题，请稍后再试。
shopping-message-bar-warning-not-enough-reviews-title = 还没有足够数量的评价
shopping-message-bar-warning-not-enough-reviews-message = 此商品获得更多评价后，我们就能开始分析。
shopping-message-bar-warning-product-not-available-title = 商品无货
shopping-message-bar-warning-product-not-available-message = 若您发现此商品已有货，请向我们反馈，以便更新分析结果。
shopping-message-bar-warning-product-not-available-button = 反馈此商品已有货
shopping-message-bar-thanks-for-reporting-title = 感谢反馈！
shopping-message-bar-thanks-for-reporting-message = 我们会在 24 小时内更新分析结果，请记得回来查看。
shopping-message-bar-warning-product-not-available-reported-title = 分析结果即将就绪
shopping-message-bar-warning-product-not-available-reported-message = 更新后的分析结果将在 24 小时内提供，请记得回来查看。
shopping-message-bar-warning-offline-title = 无网络连接
shopping-message-bar-warning-offline-message = 请检查网络连接，然后尝试重新加载此页面。
shopping-message-bar-analysis-in-progress-title = 分析结果即将就绪
shopping-message-bar-analysis-in-progress-message = 完成后，我们会自动将更新后的信息显示在此处。
shopping-message-bar-page-not-supported-title = 无法核查这些评价
shopping-message-bar-page-not-supported-message = 很抱歉，我们无法核查某些类型商品的评价质量，例如礼品卡、流媒体视频、音乐、游戏。

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = 在 { -fakespot-website-name } 上启动分析工具

## Strings for the product review snippets card

shopping-highlights-label =
    .label = 最有帮助的近期评价
shopping-highlight-price = 价格
shopping-highlight-quality = 质量
shopping-highlight-shipping = 购物
shopping-highlight-competitiveness = 竞争力
shopping-highlight-packaging = 包装

## Strings for show more card

shopping-show-more-button = 展开
shopping-show-less-button = 折叠

## Strings for the settings card

shopping-settings-label =
    .label = 设置
shopping-settings-recommendations-toggle =
    .label = 在核查评价中展示广告
shopping-settings-recommendations-learn-more = 您偶尔会看到相关商品的广告，所有广告均符合我们的评价质量标准。<a data-l10n-name="review-quality-url">详细了解</a>
shopping-settings-opt-out-button = 关闭核查评价
powered-by-fakespot = 核查评价由<a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>提供支持。

## Strings for the adjusted rating component

shopping-adjusted-rating-label =
    .label = 调整后的评分
shopping-adjusted-rating-unreliable-reviews = 已移除不可信的评价

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = 这些评价可信度如何？

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = 我们判断评价质量的流程
shopping-analysis-explainer-intro =
    我们使用 { -fakespot-brand-full-name } 的人工智能技术来分析商品评价的可信度。
    分析结果只能辅助您评估评价的质量，不能反映商品质量。
shopping-analysis-explainer-grades-intro = 我们会以<strong>字母等级</strong>（从 A 到 F）给商品评价打分。
shopping-analysis-explainer-adjusted-rating-description = <strong>调整后的评分</strong>仅基于我们认为可信的评价作出。
shopping-analysis-explainer-learn-more = 详细了解<a data-l10n-name="review-quality-url">{ -fakespot-brand-full-name } 判断评价质量的流程</a>。
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = <strong>最有帮助的评价</strong>选自我们认为可信的最近 80 天内的 { $retailer } 评价。
shopping-analysis-explainer-review-grading-scale-reliable = 评价可信。分析认为这些评价大概率是由真实消费者作出的诚实公正的评价。
shopping-analysis-explainer-review-grading-scale-mixed = 分析认为对此商品的评价鱼龙混杂。
shopping-analysis-explainer-review-grading-scale-unreliable = 评价不可信。分析认为这些评价大概率不实，或是由“水军”所作出。

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = 打开购物侧栏
shopping-sidebar-close-button =
    .tooltiptext = 关闭购物侧栏

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header = 尚无对于这些评价的分析
shopping-unanalyzed-product-message = 启动 { -fakespot-brand-full-name } 分析工具，只需 60 秒即可获知对此商品的评价是否可信。
shopping-unanalyzed-product-analyze-link = 在 { -fakespot-website-name } 上启动分析工具

## Strings for the advertisement

more-to-consider-ad-label =
    .label = 可参考其他商品
ad-by-fakespot = { -fakespot-brand-name } 提供的广告
