# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Saber mais</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> não tem efeito neste elemento porque não é um contentor flex ou contentor grid.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> não tem efeito neste elemento pois este não é um contentor flex, contentor grid, ou um contentor multi-colunas.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> não tem efeito neste elemento porque não é um um item grid ou flex.

inactive-css-not-grid-item = <strong>{ $property }</strong> não tem efeito neste elemento porque não é um item grid.

inactive-css-not-grid-container = <strong>{ $property }</strong> não tem efeito neste elemento porque não é um contentor grid.

inactive-css-not-flex-item = <strong>{ $property }</strong> não tem efeito neste elemento porque não é um item flex.

inactive-css-not-flex-container = <strong>{ $property }</strong> não tem efeito neste elemento porque não é um contentor flex.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</ strong> não tem efeito neste elemento pois não é um elemento inline ou table-cell.

inactive-css-property-because-of-display = <strong>{ $property }</strong> não tem efeito neste elemento pois este tem um display de <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = O valor de <strong>display</strong> foi alterado pelo motor para <strong>block</strong> porque o elemento é <strong>floated</strong>.

inactive-css-property-is-impossible-to-override-in-visited = É impossível substituir <strong> { $property } </strong> devido à restrição <strong>:visited </strong>.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> não tem efeito neste elemento porque não é um elemento posicional.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> não tem qualquer efeito neste elemento dado que <strong>overflow:hidden</strong> não está definido.

inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> não tem qualquer efeito em elementos de tabelas.

inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> não tem qualquer efeito em elementos internos de tabelas com excepção das células da tabela.

inactive-css-not-table = <strong>{ $property }</strong> não tem efeito neste elemento porque não é uma tabela.

inactive-scroll-padding-when-not-scroll-container = <strong>{ $property }</strong> não tem efeito neste elemento porque o mesmo não desliza.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Experimente adicionar <strong>display:grid</strong> ou <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Experimente adicionar <strong>display:grid</strong>, <strong>display:flex</strong>, ou <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Experimente adicionar <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> ou <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-3 = Experimente adicionar <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, ou <strong>display:inline-flex</strong> ao elemento pai. { learn-more }

inactive-css-not-grid-item-fix-2 = Experimente adicionar <strong>display:grid</strong> ou <strong>display:inline-grid</strong> ao pai do elemento. { learn-more }

inactive-css-not-grid-container-fix = Experimente adicionar <strong>display:grid</strong> ou <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Experimente adicionar <strong>display:flex</strong> ou <strong>display:inline-flex</strong> ao pai do elemento. { learn-more }

inactive-css-not-flex-container-fix = Experimente adicionar <strong>display:flex</strong> ou <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Experimente adicionar <strong>display:inline</ strong> ou <strong>display:table-cell</ strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Experimente adicionar <strong>display:inline-block</strong> ou <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Experimente adicionar <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Tente remover o <strong>float</strong> ou adicione <strong>display: block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Tente definir a sua propriedade <strong>position</strong> para algo diferente de <strong>static</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Experimente adicionar <strong>overflow:hidden</strong>. { learn-more }

inactive-css-not-for-internal-table-elements-fix = Experimente definir a respetiva propriedade <strong>display</strong> para algo diferente de <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> ou <strong>table-footer-group</strong>. { learn-more }

inactive-css-not-for-internal-table-elements-except-table-cells-fix = Experimente definir a respetiva propriedade <strong>display</strong> para algo diferente de <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong> ou <strong>table-footer-group</strong>. { learn-more }

inactive-css-not-table-fix = Experimente adicionar <strong>display:table</strong> ou <strong>display:inline-table</strong>. { learn-more }

inactive-scroll-padding-when-not-scroll-container-fix = Experimente adicionar <strong>overflow:auto</strong>, <strong>overflow:scroll</strong> ou <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> não é suportado nos seguintes navegadores:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> foi uma propriedade experimental atualmente descontinuada nas normas do W3C. Não é suportada nos seguintes navegadores:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> foi uma propriedade experimental atualmente descontinuada nas normas do W3C.

css-compatibility-deprecated-message = <strong>{ $property }</strong> atualmente está descontinuado nas normas do W3C. Não é suportada nos seguintes navegadores:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> atualmente está descontinuado nas normas do W3C.

css-compatibility-experimental-message = <strong>{ $property }</strong> é uma propriedade experimental. Não é suportada nos seguintes navegadores:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> é uma propriedade experimental.

css-compatibility-learn-more-message = <span data-l10n-name="link">Saber mais</span> sobre <strong>{ $rootProperty }</strong>
