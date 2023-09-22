# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = Покупки в { -brand-product-name }
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Проверка отзывов
shopping-beta-marker = Бета
# This string is for ensuring that screen reader technology
# can read out the "Beta" part of the shopping sidebar header.
# Any changes to shopping-main-container-title and
# shopping-beta-marker should also be reflected here.
shopping-a11y-header =
    .aria-label = Проверка отзывов – бета
shopping-close-button =
    .title = Закрыть
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Загрузка…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Достоверные отзывы
shopping-letter-grade-description-c = Смесь достоверных и недостоверных отзывов
shopping-letter-grade-description-df = Недостоверные отзывы
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Доступны обновления
shopping-message-bar-warning-stale-analysis-message = Запустите анализатор { -fakespot-brand-full-name }, чтобы получить обновленную информацию примерно через 60 секунд.
shopping-message-bar-generic-error-title2 = На данный момент нет доступной информации
shopping-message-bar-generic-error-message = Мы работаем над решением проблемы. Пожалуйста, зайдите в ближайшее время.
shopping-message-bar-warning-not-enough-reviews-title = Пока недостаточно отзывов
shopping-message-bar-warning-not-enough-reviews-message2 = Когда у этого товара будет больше отзывов, мы сможем проверить его качество.
shopping-message-bar-warning-product-not-available-title = Товар недоступен
shopping-message-bar-warning-product-not-available-message2 = Если вы увидите, что этот товар снова в наличии, сообщите об этом, и мы проверим отзывы.
shopping-message-bar-warning-product-not-available-button = Сообщить, что этот товар снова в наличии
shopping-message-bar-thanks-for-reporting-title = Спасибо за сообщение!
shopping-message-bar-thanks-for-reporting-message2 = Мы должны получить информацию об отзывах на этот продукт в течение 24 часов. Пожалуйста, зайдите позже.
shopping-message-bar-warning-product-not-available-reported-title2 = Информация скоро появится
shopping-message-bar-warning-product-not-available-reported-message2 = Мы должны получить информацию об отзывах на этот продукт в течение 24 часов. Пожалуйста, зайдите позже.
shopping-message-bar-analysis-in-progress-title2 = Проверяем качество отзывов
shopping-message-bar-analysis-in-progress-message2 = Это может занять около 60 секунд.
shopping-message-bar-page-not-supported-title = Мы не можем проверить эти отзывы
shopping-message-bar-page-not-supported-message = К сожалению, мы не можем проверить качество отзывов на некоторые виды товаров. Например, подарочные карты и потоковое видео, музыку и игры.

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Запустите анализатор на { -fakespot-website-name }

## Strings for the product review snippets card

shopping-highlights-label =
    .label = Основные моменты из недавних обзоров
shopping-highlight-price = Цена
shopping-highlight-quality = Качество
shopping-highlight-shipping = Доставка
shopping-highlight-competitiveness = Конкурентоспособность
shopping-highlight-packaging = Упаковка

## Strings for show more card

shopping-show-more-button = Показать больше
shopping-show-less-button = Показать меньше

## Strings for the settings card

shopping-settings-label =
    .label = Настройки
shopping-settings-recommendations-toggle =
    .label = Показывать рекламу в инструменте проверки отзывов
shopping-settings-recommendations-learn-more = Время от времени вы будете видеть рекламу похожих продуктов. Все объявления должны соответствовать нашим стандартам качества проверки. <a data-l10n-name="review-quality-url">Подробнее</a>
shopping-settings-opt-out-button = Отключить инструмент проверки отзывов
powered-by-fakespot = Инструмент проверки отзывов работает на основе <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>.

## Strings for the adjusted rating component

# "Adjusted rating" means a star rating that has been adjusted to include only
# reliable reviews.
shopping-adjusted-rating-label =
    .label = Скорректированный рейтинг
shopping-adjusted-rating-unreliable-reviews = Недостоверные отзывы удалены

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = Насколько достоверны эти отзывы?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = Как мы определяем качество отзывов
shopping-analysis-explainer-intro2 = Мы используем технологию ИИ от { -fakespot-brand-full-name } для проверки достоверности обзоров продуктов. Это поможет вам оценить только качество отзывов, а не качество продукта.
shopping-analysis-explainer-grades-intro = Мы присваиваем отзывам каждого продукта <strong>буквенную оценку</strong> от A до F.
shopping-analysis-explainer-adjusted-rating-description = <strong>Скорректированная оценка</strong> основана только на отзывах, которые мы считаем достоверными.
shopping-analysis-explainer-learn-more = Узнайте больше о том, <a data-l10n-name="review-quality-url">как { -fakespot-brand-full-name } определяет качество отзывов</a>.
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = <strong>Основные сведения</strong> взяты из отзывов на { $retailer } за последние 80 дней, которые мы считаем надежными.
shopping-analysis-explainer-review-grading-scale-reliable = Достоверные отзывы. Мы считаем, что эти отзывы, скорее всего, написаны реальными клиентами, которые оставили честные и объективные отзывы.
shopping-analysis-explainer-review-grading-scale-mixed = Мы считаем, что здесь находится смесь достоверных и недостоверных отзывов.
shopping-analysis-explainer-review-grading-scale-unreliable = Недостоверные отзывы. Мы считаем, что эти отзывы, скорее всего, фейковые или написаны предвзятыми рецензентами.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = Открыть боковую панель покупок
shopping-sidebar-close-button =
    .tooltiptext = Закрыть боковую панель покупок

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header-2 = Информации об этих отзывах пока нет
shopping-unanalyzed-product-message-2 = Чтобы узнать, достоверны ли отзывы на этот продукт, проверьте качество отзывов. Это займет всего около 60 секунд.
shopping-unanalyzed-product-analyze-button = Проверить качество отзывов

## Strings for the advertisement

more-to-consider-ad-label =
    .label = На что ещё обратить внимание
ad-by-fakespot = Реклама от { -fakespot-brand-name }

## Shopping survey strings.

shopping-survey-headline = Помогите улучшить { -brand-product-name }
shopping-survey-question-one = Насколько вы удовлетворены функцией проверки отзывов в { -brand-product-name }?
shopping-survey-q1-radio-1-label = Очень доволен
shopping-survey-q1-radio-2-label = Удовлетворен
shopping-survey-q1-radio-3-label = Нейтрален
shopping-survey-q1-radio-4-label = Недоволен
shopping-survey-q1-radio-5-label = Очень недоволен
shopping-survey-question-two = Облегчает ли вам средство проверки отзывов принятие решения о покупке?
shopping-survey-q2-radio-1-label = Да
shopping-survey-q2-radio-2-label = Нет
shopping-survey-q2-radio-3-label = Я не знаю
shopping-survey-next-button-label = Далее
shopping-survey-submit-button-label = Отправить
shopping-survey-terms-link = Условия использования
shopping-survey-thanks-message = Спасибо за ваш отзыв!

## Shopping Feature Callout strings.
## "price tag" refers to the price tag icon displayed in the address bar to
## access the feature.

shopping-callout-closed-opted-in-subtitle = Возвращайтесь к <strong>проверке отзывов</strong> всякий раз, когда увидите ценник.
shopping-callout-pdp-opted-in-title = Эти отзывы заслуживают доверия? Узнайте это быстро.
shopping-callout-pdp-opted-in-subtitle = Откройте инструмент проверки отзывов, чтобы увидеть скорректированную оценку и удалить ненадежные отзывы. Кроме того, посмотрите основные моменты из недавних достоверных обзоров.
shopping-callout-closed-not-opted-in-title = Одно нажатие для надежных отзывов
shopping-callout-closed-not-opted-in-subtitle = Используйте инструмент проверки отзывов каждый раз, когда увидите цену. Быстро получите информацию от реальных покупателей — прежде чем совершить покупку.
