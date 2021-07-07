# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">詳細</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = この要素はフレックスコンテナーでもグリッドコンテナーでもないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-not-grid-or-flex-container-or-multicol-container = この要素はフレックスコンテナーでもグリッドコンテナーでも、段組みコンテナーないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-not-grid-or-flex-item = この要素はグリッドアイテムでもフレックスアイテムでもないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-not-grid-item = この要素はグリッドアイテムではないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-not-grid-container = この要素はグリッドコンテナーではないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-not-flex-item = この要素はフレックスアイテムではないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-not-flex-container = この要素はフレックスコンテナーではないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-not-inline-or-tablecell = この要素はインライン要素でもテーブルのセル要素でもないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-property-because-of-display = この要素は <strong>{ $display }</strong> の display プロパティを持つため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-not-display-block-on-floated = この要素は <strong>floated</strong> であるため、<strong>display</strong> の値はエンジンによって <strong>block</strong> に変更されました。

inactive-css-property-is-impossible-to-override-in-visited = <strong>:visited</strong> の制限により、<strong>{ $property }</strong> をオーバーライドすることはできません。

inactive-css-position-property-on-unpositioned-box = この要素は配置の指定がないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-text-overflow-when-no-overflow = <strong>overflow:hidden</strong> が設定されてないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> はテーブルを構成する要素に影響を及ぼしません。

inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> はセル以外のテーブルを構成する要素に影響を及ぼしません。

inactive-css-not-table = テーブルではないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

inactive-scroll-padding-when-not-scroll-container = この要素はスクロールしないため、<strong>{ $property }</strong> はこの要素に影響を及ぼしません。

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = <strong>display:grid</strong> または <strong>display:flex</strong> を追加してみてください。{ learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = <strong>display:grid</strong>, <strong>display:flex</strong>, または <strong>columns:2</strong> のいずれかを追加してみてください。{ learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, または <strong>display:inline-flex</strong> を追加してみてください。{ learn-more }

inactive-css-not-grid-or-flex-item-fix-3 = <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, または <strong>display:inline-flex</strong> を親要素に追加してみてください。{ learn-more }

inactive-css-not-grid-item-fix-2 =<strong>display:grid</strong> または <strong>display:inline-grid</strong> を要素の親に追加してみてください。{ learn-more }

inactive-css-not-grid-container-fix = <strong>display:grid</strong> または <strong>display:inline-grid</strong> を追加してみてください。{ learn-more }

inactive-css-not-flex-item-fix-2 = <strong>display:flex</strong> または <strong>display:inline-flex</strong> を要素の親に追加してみてください。{ learn-more }

inactive-css-not-flex-container-fix = <strong>display:flex</strong> または <strong>display:inline-flex</strong> を追加してみてください。{ learn-more }

inactive-css-not-inline-or-tablecell-fix = <strong>display:inline</strong> または <strong>display:table-cell</strong> を追加してみてください。{ learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = <strong>display:inline-block</strong> または <strong>display:block</strong> を追加してみてください。{ learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = <strong>display:inline-block</strong> を追加してみてください。{ learn-more }

inactive-css-not-display-block-on-floated-fix = <strong>float</strong> を削除、または <strong>display:block</strong> を追加してみてください。{ learn-more }

inactive-css-position-property-on-unpositioned-box-fix = <strong>position</strong> プロパティに <strong>static</strong> 以外の値を設定してみてください。{ learn-more }

inactive-text-overflow-when-no-overflow-fix = <strong>overflow:hidden</strong> を追加してみてください。 { learn-more }

inactive-css-not-for-internal-table-elements-fix = <strong>セル</strong>、<strong>列</strong>、<strong>行</strong>、<strong>列グループ</strong>、<strong>行グループ</strong> または <strong>フッターグループ</strong> 以外の要素に <strong>display</strong> プロパティを設定してみてください。{ learn-more }

inactive-css-not-for-internal-table-elements-except-table-cells-fix = <strong>列</strong>、<strong>行</strong>、<strong>列グループ</strong>、<strong>行グループ</strong> または <strong>フッターグループ</strong> 以外の要素に <strong>display</strong> プロパティを設定してみてください。{ learn-more }

inactive-css-not-table-fix = <strong>display:table</strong> または <strong>display:inline-table</strong> を追加してみてください。{ learn-more }

inactive-scroll-padding-when-not-scroll-container-fix = <strong>overflow:auto</strong>、<strong>overflow:scroll</strong> または <strong>overflow:hidden</strong> を追加してみてください。{ learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> はこれらのブラウザーではサポートされていません:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> は実験的なプロパティでしたが、現在は W3C 標準により非推奨とされています。これらのブラウザーではサポートされていません:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> は実験的なプロパティでしたが、現在は W3C 標準により非推奨とされています。

css-compatibility-deprecated-message = <strong>{ $property }</strong> は W3C 標準により非推奨とされています。これらのブラウザーではサポートされていません:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> は W3C 標準により非推奨とされています。

css-compatibility-experimental-message = <strong>{ $property }</strong> は実験的なプロパティです。これらのブラウザーではサポートされていません:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> は実験的なプロパティです。

css-compatibility-learn-more-message = <strong>{ $rootProperty }</strong> についての <span data-l10n-name="link">詳細</span>
