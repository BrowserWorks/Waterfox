# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Kuaave</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> ndoguerekói mba’evéichagua mba’evai ko mba’epurúpe, ndaha’éi rupi mbyatyha hu’ũva ha avei mbyatyha osẽtava renda.

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> ndoguerekói mba’evéichagua mba’evai ko mba’epurúpe, ndaha’éi rupi mbyatyha hu’ũva, peteĩ mbyatyha ikora’ietáva, avei ndaha’éi mbyatyha hi’ytaetáva.

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> ndoguerekói mba’evéichagua mba’evai ko mba’epurúpe, ndaha’éi rupi osẽtava renda ha avei mba’epuru hu’ũva.

inactive-css-not-grid-item = <strong>{ $property }</strong> ndoguerekói mba’evéichagua mba’evai ko mba’epurúpe ndaha’éi rupi mba’epuru osẽtava renda.

inactive-css-not-grid-container = <strong>{ $property }</strong> ndoguerekói  mba’evai ko mba’epurúpe ndaha’éi rupi mbyatyha osẽtava renda.

inactive-css-not-flex-item = <strong>{ $property }</strong> ndoguerekói mba’evéichagua mba’evai ko mba’epurúpe, ndaha’éi rupi mba’epuru hu’ũva.

inactive-css-not-flex-container = <strong>{ $property }</strong> ndoguerekói mba’evéichagua mba’evai ko mba’epurúpe, ndaha’éi rupi mbyatyha hu’ũva.

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong> ndoguerekói mba’evéichagua mba’evai ko mba’epurúpe, ndaha’éi rupi mba’epuru eikundahakuévo térã tenda’iete.

inactive-css-property-because-of-display = <strong>{ $property }</strong> ndoguerekói mba’evai ko mba’epurúpe, oguereko rupi jehechaha <strong>{ $display }</strong>.

inactive-css-not-display-block-on-floated = Pe mongu’eha omoambue <strong>jehecha</strong> repykue <strong>jokoha</strong> pe mab’epuru oĩgui <strong>vevuihápe<strong>.

inactive-css-property-is-impossible-to-override-in-visited = Ndakatúi eipe’aite <strong>{ $property }</strong> jejoko <strong>:jehopyre</strong> rupive.

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> ndoguerekói mba’evéichagua mba’evai ko mba’epurúpe ndaha’éi rupi mba’epuru osẽtava renda.

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> ndoguerekói mba’eve ko mba’epurúpe <strong>overflow:hidden</strong> ndahekói rupi.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Eñeha’ã embojuaju <strong>display:grid</strong> térã <strong>display:flex</strong>. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Embojuaju <strong>display:grid</strong>, <strong>display:flex</strong> térã <strong>yta:2</strong>. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Embojuaju <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> térã <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-grid-item-fix-2 = Embojuaju <strong>display:grid</strong> térã <strong>display:inline-grid</strong> ítem rúpe. { learn-more }

inactive-css-not-grid-container-fix = Eñeha’ã embojuaju <strong>display:grid</strong> térã <strong>display:inline-grid</strong>. { learn-more }

inactive-css-not-flex-item-fix-2 = Embojuaju <strong>display:flex</strong> térã <strong>display:inline-flex</strong> mba’epuru rúpe. { learn-more }

inactive-css-not-flex-container-fix = Eñeha’ã embojuaju <strong>display:flex</strong> térã <strong>display:inline-flex</strong>. { learn-more }

inactive-css-not-inline-or-tablecell-fix = Eñeha’ã embojuaju <strong>display:inline</strong> térã <strong>display:table-cell</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Eñaha’ã embojuaju <strong>display:inline-block</strong> térã <strong>display:block</strong>. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Eñeha’ã embojuaju <strong>display:inline-block</strong>. { learn-more }

inactive-css-not-display-block-on-floated-fix = Embogue <strong>vevúiva</strong> térã embojuaju <strong>display:block</strong>. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Eñeha’ã emboheko <strong>rendatee</strong> mba’éva tuichavéva <strong>opytáva</strong>. { learn-more }

inactive-text-overflow-when-no-overflow-fix = Eñeha’ã embojuaju <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> ndorekói pytyvõ ko’ã kundahárape:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> ha’e peteĩ mba’etee ipyahúva ha ko’ág̃a ndoikovéima pe W3C he’iháicha. Ndojokupytýi ko’ã kundahára ndive:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> ha’e peteĩ mba’etee ipyahúva ha ko’ág̃a ndoikovéima pe W3C he’iháicha.

css-compatibility-deprecated-message = <strong>{ $property }</strong> ha’e peteĩ mba’etee ipyahúva ha ko’ág̃a ndoikovéima pe W3C he’iháicha. Ndojokupytýi ko’ã kundahára ndive:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> ndoikovéima pe W3C he’iháicha.

css-compatibility-experimental-message = <strong>{ $property }</strong> ha’e peteĩ mba’etee ipyahúva. Ndorekói ñepytyvõ ko’ã kundahárape:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> ha’e peteĩ mba’etee ipyahúva.

css-compatibility-learn-more-message = <span data-l10n-name="link">Eikuaave</span> rehegua <strong>{ $rootProperty }</strong>
