# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">了解更多</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = 由於不是 Flex 容器也不是 Grid 容器，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-not-grid-or-flex-container-or-multicol-container = 由於不是 Flex 容器、Grid 容器，也不是多欄容器，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-not-grid-or-flex-item = 由於不是 Flex 或 Grid 項目，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-not-grid-item = 由於不是 Grid 項目，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-not-grid-container = 由於不是 Grid 容器，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-not-flex-item = 由於不是 Flex 項目，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-not-flex-container = 由於不是 Flex 容器，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-not-inline-or-tablecell = 由於不是行內或表格欄位元素，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-property-because-of-display = 由於此元素的 display 屬性值為 <strong>{ $display }</strong>，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-not-display-block-on-floated = 由於是 <strong>floated</strong> 元素，繪圖引擎已將 <strong>display</strong> 值更改為 <strong>block</strong>。

inactive-css-property-is-impossible-to-override-in-visited = 由於 <strong>:visited</strong> 的限制，無法蓋過 <strong>{ $property }</strong>。

inactive-css-position-property-on-unpositioned-box = 由於元素未置入，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-text-overflow-when-no-overflow = 由於未設定 <strong>overflow:hidden</strong>，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> 對內部表格元素沒有影響。

inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> 對表格欄位之外的內部表格元素沒有影響。

inactive-css-not-table = 由於不是表格，<strong>{ $property }</strong> 對此元素沒有影響。

inactive-scroll-padding-when-not-scroll-container = 由於不會捲動，<strong>{ $property }</strong> 對此元素沒有影響。

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = 請嘗試加入 <strong>display:grid</strong> 或 <strong>display:flex</strong>。{ learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = 請嘗試加入 <strong>display:grid</strong>、<strong>display:flex</strong> 或 <strong>columns:2</strong>。{ learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = 請嘗試加入 <strong>display:grid</strong>、<strong>display:flex</strong>、<strong>display:inline-grid</strong> 或 <strong>display:inline-flex</strong>。{ learn-more }

inactive-css-not-grid-or-flex-item-fix-3 = 請嘗試為元素的父元素加入 <strong>display:grid</strong>、<strong>display:flex</strong>、<strong>display:inline-grid</strong> 或 <strong>display:inline-flex</strong>。{ learn-more }

inactive-css-not-grid-item-fix-2 = 請嘗試為元素的父元素加入 <strong>display:grid</strong> 或 <strong>display:inline-grid</strong>。{ learn-more }

inactive-css-not-grid-container-fix = 請嘗試加入 <strong>display:grid</strong> 或 <strong>display:inline-grid</strong>。{ learn-more }

inactive-css-not-flex-item-fix-2 = 請嘗試為元素的父元素加入 <strong>display:flex</strong> 或 <strong>display:inline-flex</strong>。{ learn-more }

inactive-css-not-flex-container-fix = 請嘗試加入 <strong>display:flex</strong> 或 <strong>display:inline-flex</strong>。{ learn-more }

inactive-css-not-inline-or-tablecell-fix = 請嘗試加入 <strong>display:inline</strong> 或 <strong>display:table-cell</strong>。{ learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = 請嘗試加入 <strong>display:inline-block</strong> 或 <strong>display:block</strong>。{ learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = 請嘗試加入 <strong>display:inline-block</strong>。{ learn-more }

inactive-css-not-display-block-on-floated-fix = 可試著移除 <strong>float</strong> 或加入 <strong>display:block</strong>。{ learn-more }

inactive-css-position-property-on-unpositioned-box-fix = 請試著將 <strong>position</strong> 屬性設定為 <strong>static</strong> 以外的值。{ learn-more }

inactive-text-overflow-when-no-overflow-fix = 請嘗試加入 <strong>overflow:hidden</strong>。{ learn-more }

inactive-css-not-for-internal-table-elements-fix = 請嘗試將其 <strong>display</strong> 設定成 <strong>table-cell</strong>、<strong>table-column</strong>、<strong>table-row</strong>、<strong>table-column-group</strong>、<strong>table-row-group</strong> 或<strong>table-footer-group</strong> 以外的值。{ learn-more }

inactive-css-not-for-internal-table-elements-except-table-cells-fix = 請嘗試將其 <strong>display</strong> 設定成 <strong>table-column</strong>、<strong>table-row</strong>、<strong>table-column-group</strong>、<strong>table-row-group</strong> 或<strong>table-footer-group</strong> 以外的值。{ learn-more }

inactive-css-not-table-fix = 請嘗試加入 <strong>display:table</strong> 或 <strong>display:inline-table</strong>。{ learn-more }

inactive-scroll-padding-when-not-scroll-container-fix = 請嘗試加入 <strong>overflow:auto</strong>、<strong>overflow:scroll</strong> 或<strong>overflow:hidden</strong>。{ learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = 下列瀏覽器不支援 <strong>{ $property }</strong>:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> 原本是一個實驗性的屬性，現行 W3C 標準已經棄用。在下列瀏覽器中已不支援:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> 原本是一個實驗性的屬性，現行 W3C 標準已經棄用。

css-compatibility-deprecated-message = <strong>{ $property }</strong> 在現行 W3C 標準中已經棄用，於下列瀏覽器中已不支援:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> 在現行 W3C 標準中已經棄用。

css-compatibility-experimental-message = <strong>{ $property }</strong> 是一個實驗性的屬性，在下列瀏覽器中已不支援:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> 是一個實驗性的屬性。

css-compatibility-learn-more-message = <span data-l10n-name="link">了解更多</span>關於 <strong>{ $rootProperty }</strong> 的資訊
