# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">Daha fazla bilgi al</span>

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

inactive-css-not-grid-or-flex-container = Bu eleman flex kapsayıcı veya grid kapsayıcı olmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-css-not-grid-or-flex-container-or-multicol-container = Bu eleman flex kapsayıcı, grid kapsayıcı veya çok sütunlu kapsayıcı olmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-css-not-grid-or-flex-item = Bu eleman bir flex veya grid öğesi olmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-css-not-grid-item = Bu eleman bir grid öğesi olmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-css-not-grid-container = Bu eleman bir grid kapsayıcı olmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-css-not-flex-item = Bu eleman bir flex öğesi olmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-css-not-flex-container = Bu eleman bir flex kapsayıcı olmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-css-not-inline-or-tablecell = Bu eleman bir inline veya table-cell öğesi olmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-css-property-because-of-display = Bu eleman <strong>{ $display }</strong> olarak görüntülendiği için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-css-not-display-block-on-floated = Bu eleman <strong>floated<strong> olduğu için <strong>display</strong> değeri motor tarafından <strong>block</strong> olarak değiştirildi.

inactive-css-property-is-impossible-to-override-in-visited = <strong>:visited</strong> kısıtlaması nedeniyle <strong>{ $property }</strong> geçersiz kılanamaz.

inactive-css-position-property-on-unpositioned-box = Bu elemanın pozisyonu olmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

inactive-text-overflow-when-no-overflow = <strong>overflow:hidden</strong> ayarlanmadığı için <strong>{ $property }</strong> özelliğinin bu eleman üzerinde etkisi yoktur.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = <strong>display:grid</strong> veya <strong>display:flex</strong> eklemeyi deneyin. { learn-more }

inactive-css-not-grid-or-flex-container-or-multicol-container-fix = <strong>display:grid</strong>, <strong>display:flex</strong> veya <strong>columns:2</strong> eklemeyi deneyin. { learn-more }

inactive-css-not-grid-or-flex-item-fix-2 = <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong> veya <strong>display:inline-flex</strong> eklemeyi deneyin. { learn-more }

inactive-css-not-grid-item-fix-2 = Bu elemanın üst elemanına <strong>display:grid</strong> veya <strong>display:inline-grid</strong> eklemeyi deneyin. { learn-more }

inactive-css-not-grid-container-fix = <strong>display:grid</strong> veya <strong>display:inline-grid</strong> eklemeyi deneyin. { learn-more }

inactive-css-not-flex-item-fix-2 = Bu elemanın üst elemanına <strong>display:flex</strong> veya <strong>display:inline-flex</strong> eklemeyi deneyin. { learn-more }

inactive-css-not-flex-container-fix = <strong>display:flex</strong> veya <strong>display:inline-flex</strong> eklemeyi deneyin. { learn-more }

inactive-css-not-inline-or-tablecell-fix = <strong>display:inline</strong> veya <strong>display:table-cell</strong> eklemeyi deneyin. { learn-more }

inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = <strong>display:inline-block</strong> veya <strong>display:block</strong> eklemeyi deneyin. { learn-more }

inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = <strong>display:inline-block</strong> eklemeyi deneyin. { learn-more }

inactive-css-not-display-block-on-floated-fix = <strong>float</strong>'u silmeyi veya <strong>display:block</strong> eklemeyi deneyin. { learn-more }

inactive-css-position-property-on-unpositioned-box-fix = <strong>position</strong> özelliğini <strong>static</strong> dışında bir şey yapmayı deneyin. { learn-more }

inactive-text-overflow-when-no-overflow-fix = <strong>overflow:hidden</strong> eklemeyi deneyin. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong> şu tarayıcılarda desteklenmiyor:

css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong> deneysel bir özellikti ve W3C standartlarınca kullanımdan kaldırıldı. Şu tarayıcılarda desteklenmemektedir:

css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong> deneysel bir özellikti ve W3C standartlarınca kullanımdan kaldırıldı.

css-compatibility-deprecated-message = <strong>{ $property }</strong> W3C standartlarınca kullanımdan kaldırıldı. Şu tarayıcılarda desteklenmemektedir:

css-compatibility-deprecated-supported-message = <strong>{ $property }</strong> W3C standartlarınca kullanımdan kaldırıldı.

css-compatibility-experimental-message = <strong>{ $property }</strong> deneysel bir özelliktir. Şu tarayıcılarda desteklenmemektedir:

css-compatibility-experimental-supported-message = <strong>{ $property }</strong> deneysel bir özelliktir.

css-compatibility-learn-more-message = <strong>{ $rootProperty }</strong> hakkında <span data-l10n-name="link">daha fazla bilgi alın</span>
