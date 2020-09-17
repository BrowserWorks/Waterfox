# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Подробнее</span>>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".


## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> не сработает для элемента, так как он не является flex- или сеточным контейнером.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> не сработает для элемента, так как он не является flex-, сеточным или многоколоночным контейнером.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> не сработает для элемента, так как он не является flex- или сеточным элементом.

inactive-css-not-grid-item = <strong>{ $property }</strong> не сработает для элемента, так как он не является сеточным элементом.

inactive-css-not-grid-container = <strong>{ $property }</strong> не сработает для элемента, так как он не является сеточным контейнером.

inactive-css-not-flex-item = <strong>{ $property }</strong> не сработает для элемента, так как он не является flex-элементом.

inactive-css-not-flex-container = <strong>{ $property }</strong> не сработает для элемента, так как он не является flex-контейнером.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> не сработает для элемента, так как он не является inline или table-cell элементом.

inactive-css-property-because-of-display = <strong>{ $property }</strong> не сработает для элемента, так как его свойство display задано как <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = Значение свойства <strong>display</strong> было изменено движком на <strong>block</strong>, так как элемент <strong>плавающий<strong>.

inactive-css-property-is-impossible-to-override-in-visited = Нельзя переопределить <strong>{ $property }</strong> из-за ограничений псевдокласса <strong>:visited</strong>.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> не сработает для элемента, так как он не является позиционированным элементом.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> не сработает для элемента, так как <strong>overflow:hidden</strong> не установлено.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Попробуйте добавить <strong>display:grid</strong> или <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Попробуйте добавить <strong>display:grid</strong>, <strong>display:flex</strong> или <strong>columns:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Попробуйте добавить <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> или <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Попробуйте добавить <strong>display:grid</strong> или <strong>display:inline-grid</strong> к родителю элемента. { learn-more }

inactive-css-not-grid-container-fix = Попробуйте добавить <strong>display:grid</strong> или <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Попробуйте добавить <strong>display:flex</strong> или <strong>display:inline-flex</strong> к родителю элемента. { learn-more }

inactive-css-not-flex-container-fix = Попробуйте добавить <strong>display:flex</strong> или <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Попробуйте добавить <strong>display:inline</strong> или <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Попробуйте добавить <strong>display:inline-block</strong> или <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Попробуйте добавить <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Попробуйте удалить свойство <strong>float</strong> или добавить <strong>display:block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Попробуйте установить для его свойства <strong>position</strong> значение, отличное от <strong>static</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Попробуйте добавить <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> не поддерживается в следующих браузерах:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> было экспериментальным свойством, которое теперь устарело по стандартам W3C. Оно не поддерживается в следующих браузерах:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> было экспериментальным свойством, которое теперь устарело по стандартам W3C.

css-compatibility-deprecated-message = <strong>{ $property }</strong> устарело по стандартам W3C. Оно не поддерживается в следующих браузерах:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> устарело по стандартам W3C.

css-compatibility-experimental-message = <strong>{ $property }</strong> является экспериментальным свойством. Оно не поддерживается в следующих браузерах:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> является экспериментальным свойством.

css-compatibility-learn-more-message = <span data-l10n-name="link">Узнайте больше</span> о <strong>{ $rootProperty }</strong>
