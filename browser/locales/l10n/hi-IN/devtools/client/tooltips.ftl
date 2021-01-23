# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">अधिक जानें</span>

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


## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = <strong>display:grid</strong> या <strong>display:flex</strong> को जोड़ने की कोशिश करें। { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = <strong>display:grid</strong>, <strong>display:flex</strong>, या <strong>columns:2</strong> जोड़ने की कोशिश करें। { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, या <strong>display:inline-flex</strong> जोड़ने की कोशिश करें। { learn-more }

inactive-css-not-grid-container-fix = <strong>display:grid</strong> या <strong>display:inline-grid</strong> जोड़ने की कोशिश करें। { learn-more }

inactive-css-not-flex-container-fix = <strong>display:flex</strong> या <strong>display:inline-flex</strong> जोड़ने की कोशिश करें। { learn-more }

inactive-css-not-inline-or-tablecell-fix = <strong>display:inline</strong> या <strong>display:table-cell</strong> जोड़ने की कोशिश करें। { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = <strong>display:inline-block</strong> या <strong>display:block</strong> जोड़ने की कोशिश करें। { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = <strong>display:inline-block</strong> जोड़ने की कोशिश करें। { learn-more }

inactive-css-not-display-block-on-floated-fix = <strong>float</strong> को हटाने या <strong>display:block</strong> को जोड़ने की कोशिश करें। { learn-more }

inactive-text-overflow-when-no-overflow-fix = <strong>overflow:hidden</strong> को जोड़ने की कोशिश करें। { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

