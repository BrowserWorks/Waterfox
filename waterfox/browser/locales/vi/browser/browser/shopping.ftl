# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = { -brand-product-name } Shopping
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Trình kiểm tra đánh giá
shopping-beta-marker = Beta
# This string is for ensuring that screen reader technology
# can read out the "Beta" part of the shopping sidebar header.
# Any changes to shopping-main-container-title and
# shopping-beta-marker should also be reflected here.
shopping-a11y-header =
    .aria-label = Trình kiểm tra đánh giá - beta
shopping-close-button =
    .title = Đóng
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Đang tải…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Đánh giá đáng tin cậy
shopping-letter-grade-description-c = Kết hợp các đánh giá đáng tin cậy và không đáng tin cậy
shopping-letter-grade-description-df = Đánh giá không đáng tin cậy
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Đã có bản cập nhật
shopping-message-bar-warning-stale-analysis-message = Khởi chạy trình phân tích { -fakespot-brand-full-name } để nhận thông tin cập nhật sau khoảng 60 giây.
shopping-message-bar-generic-error-title2 = Hiện không có thông tin nào
shopping-message-bar-generic-error-message = Chúng tôi đang làm việc để giải quyết sự cố. Hãy kiểm tra lại sau.
shopping-message-bar-warning-not-enough-reviews-title = Chưa đủ đánh giá
shopping-message-bar-warning-not-enough-reviews-message2 = Khi sản phẩm này có nhiều đánh giá hơn, chúng tôi sẽ có thể kiểm tra chất lượng của chúng.
shopping-message-bar-warning-product-not-available-title = Sản phẩm không có sẵn
shopping-message-bar-warning-product-not-available-message2 = Nếu bạn thấy sản phẩm này đã có hàng trở lại, hãy báo cáo và chúng tôi sẽ kiểm tra đánh giá.
shopping-message-bar-warning-product-not-available-button = Báo sản phẩm này đã có hàng trở lại
shopping-message-bar-thanks-for-reporting-title = Cảm ơn bạn đã báo cáo!
shopping-message-bar-thanks-for-reporting-message2 = Chúng tôi sẽ có thông tin về đánh giá của sản phẩm này trong vòng 24 giờ. Hãy kiểm tra lại sau.
shopping-message-bar-warning-product-not-available-reported-title2 = Thông tin sắp ra mắt
shopping-message-bar-warning-product-not-available-reported-message2 = Chúng tôi sẽ có thông tin về đánh giá của sản phẩm này trong vòng 24 giờ. Hãy kiểm tra lại sau.
shopping-message-bar-analysis-in-progress-title2 = Đang kiểm tra chất lượng đánh giá
shopping-message-bar-analysis-in-progress-message2 = Quá trình này có thể mất khoảng 60 giây.
shopping-message-bar-page-not-supported-title = Chúng tôi không thể kiểm tra những đánh giá này
shopping-message-bar-page-not-supported-message = Rất tiếc, chúng tôi không thể kiểm tra chất lượng đánh giá đối với một số loại sản phẩm nhất định. Ví dụ: thẻ quà tặng và truyền phát video, âm nhạc và trò chơi.

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Khởi chạy trình phân tích trên { -fakespot-website-name }

## Strings for the product review snippets card

shopping-highlights-label =
    .label = Điểm nổi bật từ các đánh giá gần đây
shopping-highlight-price = Giá
shopping-highlight-quality = Chất lượng
shopping-highlight-shipping = Phương thức giao hàng
shopping-highlight-competitiveness = Tính cạnh tranh
shopping-highlight-packaging = Đóng gói

## Strings for show more card

shopping-show-more-button = Xem thêm
shopping-show-less-button = Xem ít hơn

## Strings for the settings card

shopping-settings-label =
    .label = Cài đặt
shopping-settings-recommendations-toggle =
    .label = Hiển thị quảng cáo trong trình kiểm tra đánh giá
shopping-settings-recommendations-learn-more = Bạn sẽ thấy quảng cáo không thường xuyên cho các sản phẩm có liên quan. Tất cả quảng cáo phải đáp ứng các tiêu chuẩn chất lượng đánh giá của chúng tôi. <a data-l10n-name="review-quality-url">Tìm hiểu thêm</a>
shopping-settings-opt-out-button = Tắt trình kiểm tra đánh giá
powered-by-fakespot = Trình kiểm tra đánh giá được cung cấp bởi <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>.

## Strings for the adjusted rating component

# "Adjusted rating" means a star rating that has been adjusted to include only
# reliable reviews.
shopping-adjusted-rating-label =
    .label = Đánh giá đã được điều chỉnh
shopping-adjusted-rating-unreliable-reviews = Đã xóa các đánh giá không đáng tin cậy

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = Những đánh giá này đáng tin cậy đến mức nào?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = Cách chúng tôi xác định chất lượng đánh giá
shopping-analysis-explainer-intro2 = Chúng tôi sử dụng công nghệ AI của { -fakespot-brand-full-name } để kiểm tra độ tin cậy của các đánh giá sản phẩm. Điều này chỉ giúp bạn đánh giá được chất lượng đánh giá chứ không phải chất lượng sản phẩm.
shopping-analysis-explainer-grades-intro = Chúng tôi đưa ra đánh giá cho từng sản phẩm một <strong>điểm bằng chữ cái</strong> từ A đến F.
shopping-analysis-explainer-adjusted-rating-description = <strong>Đánh giá đã được điều chỉnh</strong> chỉ dựa trên những đánh giá mà chúng tôi tin là đáng tin cậy.
shopping-analysis-explainer-learn-more = Tìm hiểu thêm về <a data-l10n-name="review-quality-url">cách { -fakespot-brand-full-name } quyết định chất lượng đánh giá</a>.
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = <strong>Điểm nổi bật</strong> từ { $retailer } đánh giá trong vòng 80 ngày qua mà chúng tôi tin là đáng tin cậy.
shopping-analysis-explainer-review-grading-scale-reliable = Đánh giá đáng tin cậy. Chúng tôi tin rằng các đánh giá có thể đến từ những khách hàng thực sự đã để lại những đánh giá trung thực, không thiên vị.
shopping-analysis-explainer-review-grading-scale-mixed = Chúng tôi tin rằng có sự kết hợp giữa các đánh giá đáng tin cậy và không đáng tin cậy.
shopping-analysis-explainer-review-grading-scale-unreliable = Đánh giá không đáng tin cậy. Chúng tôi tin rằng các đánh giá có thể là giả mạo hoặc từ những người đánh giá thiên vị.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = Mở thanh lề mua sắm
shopping-sidebar-close-button =
    .tooltiptext = Đóng thanh lề mua sắm

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header-2 = Chưa có thông tin về những đánh giá này
shopping-unanalyzed-product-message-2 = Để biết liệu đánh giá của sản phẩm này có đáng tin cậy hay không, hãy kiểm tra chất lượng đánh giá. Chỉ mất khoảng 60 giây.
shopping-unanalyzed-product-analyze-button = Kiểm tra chất lượng đánh giá

## Strings for the advertisement

more-to-consider-ad-label =
    .label = Thêm điều cần xem xét
ad-by-fakespot = Quảng cáo bởi { -fakespot-brand-name }

## Shopping survey strings.

shopping-survey-headline = Giúp cải thiện { -brand-product-name }
shopping-survey-question-one = Bạn hài lòng như thế nào với trải nghiệm của trình kiểm tra đánh giá trong { -brand-product-name }?
shopping-survey-q1-radio-1-label = Rất hài lòng
shopping-survey-q1-radio-2-label = Hài lòng
shopping-survey-q1-radio-3-label = Trung lập
shopping-survey-q1-radio-4-label = Không hài lòng
shopping-survey-q1-radio-5-label = Rất không hài lòng
shopping-survey-question-two = Trình kiểm tra đánh giá có giúp bạn đưa ra quyết định mua hàng dễ dàng hơn không?
shopping-survey-q2-radio-1-label = Có
shopping-survey-q2-radio-2-label = Không
shopping-survey-q2-radio-3-label = Tôi không biết
shopping-survey-next-button-label = Tiếp
shopping-survey-submit-button-label = Gửi
shopping-survey-terms-link = Điều khoản sử dụng
shopping-survey-thanks-message = Cảm ơn phản hồi của bạn!

## Shopping Feature Callout strings.
## "price tag" refers to the price tag icon displayed in the address bar to
## access the feature.

shopping-callout-closed-opted-in-subtitle = Quay lại <strong>trình kiểm tra đánh giá</strong> bất cứ khi nào bạn nhìn thấy tag giá.
shopping-callout-pdp-opted-in-title = Những đánh giá này có đáng tin cậy không? Tìm hiểu chúng nhanh chóng.
shopping-callout-pdp-opted-in-subtitle = Mở trình kiểm tra đánh giá để xem xếp hạng đã điều chỉnh và đã xóa các đánh giá không đáng tin cậy. Ngoài ra, hãy xem những điểm nổi bật từ các đánh giá xác thực gần đây.
shopping-callout-closed-not-opted-in-title = Một cú nhấp chuột để đánh giá đáng tin cậy
shopping-callout-closed-not-opted-in-subtitle = Hãy dùng thử trình kiểm tra đánh giá bất cứ khi nào bạn nhìn thấy tag giá. Nhận thông tin chi tiết từ những người mua sắm thực sự một cách nhanh chóng — trước khi bạn mua.
