# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">详细了解</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = 由于不是弹性容器或网格容器，<strong>{ $property }</strong> 对此元素无效。
inactive-css-not-grid-or-flex-container-or-multicol-container = 由于不是 Flex 容器、Grid 容器或多栏容器， <strong>{ $property }</strong> 对此元素没有影响。
inactive-css-not-grid-or-flex-item = 由于不是弹性或网格项目，<strong>{ $property }</strong> 对此元素无效。
inactive-css-not-grid-item = 由于不是网格项目，<strong>{ $property }</strong> 对此元素无效。
inactive-css-not-grid-container = 由于不是网格容器，<strong>{ $property }</strong> 对此元素无效。
inactive-css-not-flex-item = 由于不是弹性项目，<strong>{ $property }</strong> 对此元素无效。
inactive-css-not-flex-container = 由于不是弹性容器，<strong>{ $property }</strong> 对此元素无效。
inactive-css-not-inline-or-tablecell = 由于不是内联或表格单元格元素，<strong>{ $property }</strong> 对此元素无效。
inactive-css-property-because-of-display = 由于其有 <strong>{ $display }</strong> 的 display 属性，<strong>{ $property }</strong> 对此元素没有影响。
inactive-css-not-display-block-on-floated = 由于是 <strong>floated<strong> 元素，引擎已将 <strong>display</strong> 值更改为 <strong>block</strong>。
inactive-css-property-is-impossible-to-override-in-visited = 由于 <strong>:visited</strong> 的限制，无法覆盖 <strong>{ $property }</strong>。
inactive-css-position-property-on-unpositioned-box = 由于不是定位元素，<strong>{ $property }</strong> 对此元素无效。
inactive-text-overflow-when-no-overflow = 由于未设置 <strong>overflow:hidden</strong>，<strong>{ $property }</strong> 对此元素无效。
inactive-outline-radius-when-outline-style-auto-or-none = 由于此元素的 <strong>outline-style</strong> 是 <strong>auto</strong> 或 <strong>none</strong>，<strong>{ $property }</strong> 对此元素没有影响。
inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> 对内部表格元素无影响。
inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> 对内部表格元素（表格单元格除外）无影响。
inactive-css-not-table = 由于不是表格项目，<strong>{ $property }</strong> 对此元素无效。
inactive-scroll-padding-when-not-scroll-container = 由于不会滚动，<strong>{ $property }</strong> 对此元素无效。

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = 请尝试添加 <strong>display:grid</ strong> 或 <strong>display:flex</strong>。{ learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = 请尝试加入 <strong>display:grid</strong>、<strong>display:flex</strong> 或 <strong>columns:2</strong>。{ learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = 请尝试添加 <strong>display:grid</ strong>、<strong>display:flex</strong>, <strong>display:inline-grid</strong> 或 <strong>display:inline-flex</strong>。{ learn-more }
inactive-css-not-grid-item-fix-2 = 请尝试为元素的父元素添加 <strong>display:grid</strong> 或 <strong>display:inline-grid</strong>。{ learn-more }
inactive-css-not-grid-container-fix = 请尝试添加 <strong>display:grid</strong> 或 <strong>display:inline-grid</strong>。{ learn-more }
inactive-css-not-flex-item-fix-2 = 请尝试为元素的父元素添加 <strong>display:flex</strong> 或 <strong>display:inline-flex</strong>。{ learn-more }
inactive-css-not-flex-container-fix = 请尝试添加 <strong>display:flex</strong> 或 <strong>display:inline-flex</strong>。{ learn-more }
inactive-css-not-inline-or-tablecell-fix = 请尝试添加 <strong>display:inline</strong> 或 <strong>display:table-cell</strong>。{ learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = 请尝试添加 <strong>display:inline-block</strong> 或 <strong>display:block</strong>。{ learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = 请尝试添加 <strong>display:inline-block</strong>。{ learn-more }
inactive-css-not-display-block-on-floated-fix = 请尝试移除 <strong>float</ strong> 或添加 <strong>display:block</strong>。{ learn-more }
inactive-css-position-property-on-unpositioned-box-fix = 请尝试将其 <strong>position</strong> 属性设为非 <strong>static</strong> 的值。{ learn-more }
inactive-text-overflow-when-no-overflow-fix = 请尝试添加 <strong>overflow:hidden</strong>。{ learn-more }
inactive-css-not-for-internal-table-elements-fix = 请尝试将其 <strong>display</strong> 设为 <strong>table-cell</strong>、<strong>table-column</strong>、<strong>table-row</strong>、<strong>table-column-group</strong>、<strong>table-row-group</strong> 或 <strong>table-footer-group</strong> 以外的值。{ learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = 请尝试将其 <strong>display</strong> 设为 <strong>table-column</strong>、<strong>table-row</strong>、<strong>table-column-group</strong>、<strong>table-row-group</strong> 或 <strong>table-footer-group</strong> 以外的值。{ learn-more }
inactive-outline-radius-when-outline-style-auto-or-none-fix = 请尝试将其 <strong>outline-style</strong> 属性设为非 <strong>auto</strong> 或 <strong>none</strong> 的值。{ learn-more }
inactive-css-not-table-fix = 请尝试添加 <strong>display:table</strong> 或 <strong>display:inline-table</strong>。{ learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = 请尝试添加 <strong>overflow:auto</strong>、<strong>overflow:scroll</strong> 或 <strong>overflow:hidden</strong>。{ learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = 下列浏览器不支持 <strong>{ $property }</strong>：
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> 原为实验性属性，现行 W3C 标准已不赞成使用，下列浏览器已不支持：
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> 原为实验性属性，现行 W3C 标准已不赞成使用。
css-compatibility-deprecated-message = <strong>{ $property }</strong> 在现行 W3C 标准中已不赞成使用，下列浏览器已不支持：
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> 在 W3C 标准中已不赞成使用。
css-compatibility-experimental-message = <strong>{ $property }</strong> 为实验性属性，在下列浏览器中已不支持：
css-compatibility-experimental-supported-message = <strong>{ $property }</strong> 为实验性属性。
css-compatibility-learn-more-message = <span data-l10n-name="link">详细了解</span>“<strong>{ $rootProperty }</strong>”
