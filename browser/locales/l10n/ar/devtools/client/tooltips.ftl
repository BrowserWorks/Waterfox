# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">اطّلع على المزيد</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ ليس في حاويًا مرنًا/flex ولا في حاويًا شبكيًا/grid.
inactive-css-not-grid-or-flex-container-or-multicol-container = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ ليس في حاويًا مرنًا/flex ولا في حاويًا شبكيًا/grid ولا في حاويًا متعدّد الأعمدة.
inactive-css-not-grid-or-flex-item = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ ليس في شبكة/grid ولا في عنصر مرن/flex.
inactive-css-not-grid-item = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ ليس في عنصر شبكة/grid.
inactive-css-not-grid-container = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ ليس في حاويًا شبكيًا/grid.
inactive-css-not-flex-item = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ ليس في عنصر مرن/flex.
inactive-css-not-flex-container = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ ليس في حاويًا مرنًا/flex.
inactive-css-not-inline-or-tablecell = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ ليس عنصرًا مضمّنًا/inline ولا خلية جدول/table-cell.
inactive-css-property-because-of-display = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ قيمة العرض/display له هي <strong>{ $display }</strong>.
inactive-css-not-display-block-on-floated = غيّر المحرّك قيمةَ العرض/<strong>display</strong> لتصير <strong>block</strong> إذ العنصر <strong>طافٍ/float</strong>.
inactive-css-position-property-on-unpositioned-box = ليس للصفة <strong>{ $property }</strong> أيّ تأثير على هذا العنصر إذ ليس عنصرًا متموضعًا/positioned.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = جرّب إضافة <strong>display:grid</strong> أو <strong>display:flex</strong>. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = جرّب إضافة <strong>display:grid</strong> أو <strong>display:flex</strong> أو <strong>columns:2</strong>. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = جرّب إضافة <strong>display:grid</strong> أو <strong>display:flex</strong> أو <strong>display:inline-grid</strong> أو <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-grid-item-fix-2 = جرّب إضافة <strong>display:grid</strong> أو <strong>display:inline-grid</strong> إلى العنصر الأب. { learn-more }
inactive-css-not-grid-container-fix = جرّب إضافة <strong>display:grid</strong> أو <strong>display:inline-grid</strong>. { learn-more }
inactive-css-not-flex-item-fix-2 = جرّب إضافة <strong>display:flex</strong> أو <strong>display:inline-flex</strong> إلى العنصر الأب. { learn-more }
inactive-css-not-flex-container-fix = جرّب إضافة <strong>display:flex</strong> أو <strong>display:inline-flex</strong>. { learn-more }
inactive-css-not-inline-or-tablecell-fix = جرّب إضافة <strong>display:inline</strong> أو <strong>display:table-cell</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = جرّب إضافة <strong>display:inline-block</strong> أو <strong>display:block</strong>. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = جرّب إضافة <strong>display:inline-block</strong>. { learn-more }
inactive-css-not-display-block-on-floated-fix = جرّب إمّا إزالة <strong>float</strong> أو إضافة<strong>display:block</strong>. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = جرّب ضبط خاصية <strong>position</strong> إلى شيء آخر عدا <strong>static</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-deprecated-experimental-message = كانت <strong>{ $property }</strong> صفة تجريبية وباتت بائدة الآن حسب معايير W3C. لم تعد مدعومة في المتصفحات الآتية:
css-compatibility-deprecated-experimental-supported-message = كانت <strong>{ $property }</strong> صفة تجريبية وباتت بائدة الآن حسب معايير W3C.
