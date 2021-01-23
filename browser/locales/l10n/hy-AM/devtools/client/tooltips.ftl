# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Իմանալ ավելին</span>

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

inactive-css-not-grid-or-flex-container = <strong>{ $property }</strong> չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն սնուցիչ կամ ցանցային պահոց չէ։

inactive-css-not-grid-or-flex-container-or-multicol-container = <strong>{ $property }</strong> չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն սնուցիչ, ցանցային կամ բազմասյուն պահոց չէ։

inactive-css-not-grid-or-flex-item = <strong>{ $property }</strong> չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն ցանցային կամ սնուցիչ բաղադրիչ չէ։

inactive-css-not-grid-item = <strong>{ $property }</strong> չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն ցանցային բաղադրիչ չէ։

inactive-css-not-grid-container = <strong>{ $property }</strong> չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն ցանցային պահուստ չէ։

inactive-css-not-flex-item = <strong>{ $property }</strong> չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն սնուցման  բաղադրիչ չէ։

inactive-css-not-flex-container = <strong>{ $property }</strong> չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն սնուցման պահուստ չէ։

inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong>-ը չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն ներտողի կամ աղյուսակի-վանդակի բաղադրիչ չէ։

inactive-css-property-because-of-display = <strong>{ $property }</strong>-ը չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն ունի <strong>{ $display }</strong>-ի ցուցադրում։

inactive-css-not-display-block-on-floated = <strong>ցուցադրման</strong> արժեքը փոխվել է ենթահամակարգի կողմից <strong>արգելափակել</strong>, որովհետև բաղադրիչը <strong>տեղաշարժվել է<strong>։

inactive-css-property-is-impossible-to-override-in-visited = <strong>․այցելված</strong> սահմանափակման պատճառով անհնար է վերագրել <strong>{ $property }</strong>։

inactive-css-position-property-on-unpositioned-box = <strong>{ $property }</strong> չունի որևէ ազդեցություն այս տարրի վրա, քանզի այն ցանցային բաղադրիչ չէ։

inactive-text-overflow-when-no-overflow = <strong>{ $property }</strong> չունի որևէ ազդեցություն այս տարրի վրա, քանզի <strong>overflow:hidden</strong>-ը կայված չէ:

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = Փորձեք ավելացնել <strong>ցուցադրել․ցանցը</strong> կամ <strong>ցուցադրել։սնուցիչը</strong>։ { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = Փորձեք ավելացնել կամ <strong>ցուցադրել․ցանցը</strong>, <strong>ցուցադրել․սնուցիչը</strong> կամ<strong>սյունյակներ․2</strong>։{ learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = Փորձեք ավելացնել <strong>ցուցադրել․ցանցը</strong>, <strong>ցուցադրել․սնուցիչը</strong>, <strong>ցուցադրել․ներտողային-ցանցը</strong> կամ <strong>ցուցադրել․ներտողային-սնուցիչը</strong>։ { learn-more }

inactive-css-not-grid-item-fix-2 = Փորձեք բաղադրիչների վերդասում ավելացնել <strong>ցուցադրել․ցանցը</strong> կամ <strong>ցուցադրել․ներտողային֊ցանցը</strong>։ { learn-more }

inactive-css-not-grid-container-fix = Փորձեք ավելացնել <strong>ցուցադրել․ցանցը</strong> կամ <strong>ցուցադրել․ներտողային-ցանցը</strong>։ { learn-more }

inactive-css-not-flex-item-fix-2 = Փորձեք բաղադրիչների վերադասում ավելացնել <strong>ցուցադրել․սնուցիչը</strong> կամ <strong>ցուցադրել․ներտողային-սնուցիչը</strong>։ { learn-more }

inactive-css-not-flex-container-fix = Փորձեք ավելացնել <strong>ցուցադրել․սնուցիչը</strong> կամ <strong>ցուցադրել․ներտողային֊սնուցիչը</strong>։ { learn-more }

inactive-css-not-inline-or-tablecell-fix = Փորձե<strong>ցուցադրել․ներտող</strong> կամ <strong>ցուցադրել․աղյուսակի֊վանդակը</strong>։ { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = Փորձեք ավելացնել <strong>ցուցադրել․ներտողային-արգելափակումը</strong> կամ <strong>ցուցադրել․արգելափակումը</strong>։ { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = Փորձեք ավելացնել <strong>ցուցադրել․ներտողային-արգելափակումը</strong>։ { learn-more }

inactive-css-not-display-block-on-floated-fix = Փորձեք հեռացնել <strong>լողանցումը</strong> կամ ավելացնել <strong>ցուցադրման․արգելափակումը</strong>։ { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = Փորձեք կարգավորել իր </ strong>դիրքի</ strong> հատկությունը մեկ այլում, քան <strong>static</strong>-ը:{ learn-more }

inactive-text-overflow-when-no-overflow-fix = Փորձեք ավելացնել <strong>overflow:hidden</strong>. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

