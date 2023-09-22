# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

shopping-page-title = Compras no { -brand-product-name }
# Title for page showing where a user can check the
# review quality of online shopping product reviews
shopping-main-container-title = Verificador de avaliações
shopping-beta-marker = Beta
# This string is for ensuring that screen reader technology
# can read out the "Beta" part of the shopping sidebar header.
# Any changes to shopping-main-container-title and
# shopping-beta-marker should also be reflected here.
shopping-a11y-header =
    .aria-label = Verificador de avaliações - beta
shopping-close-button =
    .title = Fechar
# This string is for notifying screen reader users that the
# sidebar is still loading data.
shopping-a11y-loading =
    .aria-label = Carregando…

## Strings for the letter grade component.
## For now, we only support letter grades A, B, C, D and F.
## Letter A indicates the highest grade, and F indicates the lowest grade.
## Letters are hardcoded and cannot be localized.

shopping-letter-grade-description-ab = Avaliações confiáveis
shopping-letter-grade-description-c = Mistura de avaliações confiáveis e não confiáveis
shopping-letter-grade-description-df = Avaliações não confiáveis
# This string is displayed in a tooltip that appears when the user hovers
# over the letter grade component without a visible description.
# It is also used for screen readers.
#  $letter (String) - The letter grade as A, B, C, D or F (hardcoded).
#  $description (String) - The localized letter grade description. See shopping-letter-grade-description-* strings above.
shopping-letter-grade-tooltip =
    .title = { $letter } - { $description }

## Strings for the shopping message-bar

shopping-message-bar-warning-stale-analysis-title = Atualizações disponíveis
shopping-message-bar-warning-stale-analysis-message = Inicie o analisador do { -fakespot-brand-full-name } para obter informações atualizadas em cerca de 60 segundos.
shopping-message-bar-generic-error-title2 = Nenhuma informação disponível no momento
shopping-message-bar-generic-error-message = Estamos trabalhando para resolver o problema. Verifique novamente mais tarde.
shopping-message-bar-warning-not-enough-reviews-title = Ainda não há avaliações suficientes
shopping-message-bar-warning-not-enough-reviews-message2 = Quando este produto tiver mais avaliações, poderemos verificar sua qualidade.
shopping-message-bar-warning-product-not-available-title = O produto não está disponível
shopping-message-bar-warning-product-not-available-message2 = Se você perceber que tem este produto novamente em estoque, informe para nós e trabalharemos na verificação de avaliações.
shopping-message-bar-warning-product-not-available-button = Informar que tem este produto em estoque novamente
shopping-message-bar-thanks-for-reporting-title = Obrigado por informar!
shopping-message-bar-thanks-for-reporting-message2 = Devemos ter informações sobre as avaliações deste produto em até 24 horas. Verifique novamente mais tarde.
shopping-message-bar-warning-product-not-available-reported-title2 = Informações em breve
shopping-message-bar-warning-product-not-available-reported-message2 = Devemos ter informações sobre as avaliações deste produto em até 24 horas. Verifique novamente mais tarde.
shopping-message-bar-analysis-in-progress-title2 = Verificando a qualidade das avaliações
shopping-message-bar-analysis-in-progress-message2 = Isso pode demorar cerca de 60 segundos.
shopping-message-bar-page-not-supported-title = Não podemos verificar essas avaliações
shopping-message-bar-page-not-supported-message = Infelizmente, não podemos verificar a qualidade das avaliações de determinados tipos de produtos. Por exemplo, cartões-presente e transmissão de vídeo, música e jogos.

## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-message-bar-warning-stale-analysis-link = Inicie o analisador no { -fakespot-website-name }

## Strings for the product review snippets card

shopping-highlights-label =
    .label = Destaques de avaliações recentes
shopping-highlight-price = Preço
shopping-highlight-quality = Qualidade
shopping-highlight-shipping = Envio
shopping-highlight-competitiveness = Competitividade
shopping-highlight-packaging = Embalagem

## Strings for show more card

shopping-show-more-button = Mostrar mais
shopping-show-less-button = Mostrar menos

## Strings for the settings card

shopping-settings-label =
    .label = Configurações
shopping-settings-recommendations-toggle =
    .label = Mostrar anúncios no verificador de avaliações
shopping-settings-recommendations-learn-more = Aparecerão anúncios ocasionais de produtos relevantes. Todos os anúncios devem atender aos nossos padrões de qualidade de avaliação. <a data-l10n-name="review-quality-url">Saiba mais</a>
shopping-settings-opt-out-button = Desativar o verificador de avaliações
powered-by-fakespot = O verificador de avaliações é desenvolvido por <a data-l10n-name="fakespot-link">{ -fakespot-brand-full-name }</a>.

## Strings for the adjusted rating component

# "Adjusted rating" means a star rating that has been adjusted to include only
# reliable reviews.
shopping-adjusted-rating-label =
    .label = Classificação ajustada
shopping-adjusted-rating-unreliable-reviews = Avaliações não confiáveis removidas

## Strings for the review reliability component

shopping-review-reliability-label =
    .label = Quão confiáveis são essas avaliações?

## Strings for the analysis explainer component

shopping-analysis-explainer-label =
    .label = Como determinamos a qualidade da avaliação
shopping-analysis-explainer-intro2 = Usamos tecnologia de inteligência artificial do { -fakespot-brand-full-name } para analisar a confiabilidade das avaliações de produtos. Isso só ajuda a estimar a qualidade das avaliações, não a qualidade dos produtos.
shopping-analysis-explainer-grades-intro = Atribuímos às avaliações de cada produto uma <strong>nota com letra</strong> de A a F.
shopping-analysis-explainer-adjusted-rating-description = A <strong>classificação ajustada</strong> é baseada apenas em avaliações que acreditamos ser confiáveis.
shopping-analysis-explainer-learn-more = Saiba mais sobre <a data-l10n-name="review-quality-url">como o { -fakespot-brand-full-name } determina a qualidade da avaliação</a>.
# This string includes the short brand name of one of the three supported
# websites, which will be inserted without being translated.
#  $retailer (String) - capitalized name of the shopping website, for example, "Amazon".
shopping-analysis-explainer-highlights-description = Os <strong>destaques</strong> são provenientes de avaliações de { $retailer } feitas nos últimos 80 dias e que acreditamos ser confiáveis.
shopping-analysis-explainer-review-grading-scale-reliable = Avaliações confiáveis. Acreditamos que as avaliações provavelmente são de consumidores reais que deixaram avaliações honestas e imparciais.
shopping-analysis-explainer-review-grading-scale-mixed = Acreditamos que há uma mistura de avaliações confiáveis e não confiáveis.
shopping-analysis-explainer-review-grading-scale-unreliable = Avaliações não confiáveis. Acreditamos que as avaliações provavelmente são falsas ou de avaliadores tendenciosos.

## Strings for UrlBar button

shopping-sidebar-open-button =
    .tooltiptext = Abrir barra lateral de compras
shopping-sidebar-close-button =
    .tooltiptext = Fechar barra lateral de compras

## Strings for the unanalyzed product card.
## The word 'analyzer' when used here reflects what this tool is called on
## fakespot.com. If possible, a different word should be used for the Fakespot
## tool (the Fakespot by BrowserWorks 'analyzer') other than 'checker', which is
## used in the name of the Waterfox feature ('Review checker'). If that is not
## possible - if these terms are not meaningfully different - that is OK.

shopping-unanalyzed-product-header-2 = Ainda não há informações sobre estas avaliações
shopping-unanalyzed-product-message-2 = Para saber se as avaliações deste produto são confiáveis, verifique a qualidade das avaliações. Demora apenas cerca de 60 segundos.
shopping-unanalyzed-product-analyze-button = Verificar qualidade das avaliações

## Strings for the advertisement

more-to-consider-ad-label =
    .label = Mais a considerar
ad-by-fakespot = Anúncio do { -fakespot-brand-name }

## Shopping survey strings.

shopping-survey-headline = Ajude a melhorar o { -brand-product-name }
shopping-survey-question-one = Qual é seu nível de satisfação com a experiência de uso do verificador de avaliações no { -brand-product-name }?
shopping-survey-q1-radio-1-label = Muito satisfeito
shopping-survey-q1-radio-2-label = Satisfeito
shopping-survey-q1-radio-3-label = Neutro
shopping-survey-q1-radio-4-label = Insatisfeito
shopping-survey-q1-radio-5-label = Muito insatisfeito
shopping-survey-question-two = O verificador de avaliações facilita a tomada de decisões de compras?
shopping-survey-q2-radio-1-label = Sim
shopping-survey-q2-radio-2-label = Não
shopping-survey-q2-radio-3-label = Não sei
shopping-survey-next-button-label = Avançar
shopping-survey-submit-button-label = Enviar
shopping-survey-terms-link = Termos de uso
shopping-survey-thanks-message = Obrigado por sua opinião!

## Shopping Feature Callout strings.
## "price tag" refers to the price tag icon displayed in the address bar to
## access the feature.

shopping-callout-closed-opted-in-subtitle = Volte ao <strong>verificador de avaliações</strong> sempre que aparecer a etiqueta de preço.
shopping-callout-pdp-opted-in-title = Essas avaliações são confiáveis? Descubra rápido.
shopping-callout-pdp-opted-in-subtitle = Abra o verificador de avaliações para ver uma classificação ajustada com avaliações não confiáveis removidas. Além disso, veja destaques de avaliações autênticas recentes.
shopping-callout-closed-not-opted-in-title = Um clique para avaliações confiáveis
shopping-callout-closed-not-opted-in-subtitle = Experimente o verificador de avaliações sempre que aparecer a etiqueta de preço. Obtenha percepções de compradores reais rapidamente, antes de comprar.
