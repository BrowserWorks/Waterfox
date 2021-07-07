# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools tooltips.

learn-more = <span data-l10n-name="link">더 알아보기</span>

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain why
## the property is not applied.
## Variables:
##   $property (string) - A CSS property name e.g. "color".
##   $display (string) - A CSS display value e.g. "inline-block".

inactive-css-not-grid-or-flex-container = 플렉스 컨테이너도 그리드 컨테이너도 아니기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-css-not-grid-or-flex-container-or-multicol-container = 플렉스 컨테이너, 그리드 컨테이너 또는 멀티 컬럼 컨테이너가 아니기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-css-not-grid-or-flex-item = 그리드 또는 플렉스 항목이 아니기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-css-not-grid-item = 그리드 항목이 아니기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-css-not-grid-container = 그리드 컨테이너가 아니기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-css-not-flex-item = 플렉스 항목이 아니기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-css-not-flex-container = 플렉스 컨테이너가 아니기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-css-not-inline-or-tablecell = <strong>{ $property }</strong>는 inline 또는 table-cell 요소가 아니기 때문에 이 요소에 아무런 영향을 미치지 않습니다.
inactive-css-property-because-of-display = <strong>{ $display }</strong>의 표시가 있으므로 <strong>{ $property }</strong>은 이 요소에 영향을 미치지 않습니다.
inactive-css-not-display-block-on-floated = 요소가 <strong>floated<strong>이므로 <strong>display</strong> 값이 엔진에 의해 <strong>block</strong>으로 변경되었습니다.
inactive-css-property-is-impossible-to-override-in-visited = <strong>:visited</strong> 제한으로 인해 <strong>{ $property }</strong>를 재정의 할 수 없습니다.
inactive-css-position-property-on-unpositioned-box = 위치가 지정된 요소가 아니기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-text-overflow-when-no-overflow = <strong>overflow:hidden</strong>이 설정되어 있지 않으므로 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-outline-radius-when-outline-style-auto-or-none = <strong>outline-style</strong> 속성이 <strong>auto</strong> 또는 <strong>none</strong>이기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-css-not-for-internal-table-elements = <strong>{ $property }</strong> 속성이 내부 테이블 요소에 영향을 미치지 않습니다.
inactive-css-not-for-internal-table-elements-except-table-cells = <strong>{ $property }</strong> 속성이 테이블 셀을 제외하고 내부 테이블 요소에 영향을 미치지 않습니다.
inactive-css-not-table = 테이블이 아니기 때문에 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.
inactive-scroll-padding-when-not-scroll-container = 스크롤하지 않으므로 <strong>{ $property }</strong> 속성이 이 요소에 영향을 미치지 않습니다.

## In the Rule View when a CSS property cannot be successfully applied we display
## an icon. When this icon is hovered this message is displayed to explain how
## the problem can be solved.

inactive-css-not-grid-or-flex-container-fix = <strong>display:grid</strong> 또는 <strong>display:flex</strong>를 추가해보세요. { learn-more }
inactive-css-not-grid-or-flex-container-or-multicol-container-fix = <strong>display:grid</strong>나 <strong>display:flex</strong>, <strong>columns:2</strong>를 추가해보세요. { learn-more }
inactive-css-not-grid-or-flex-item-fix-2 = <strong>display:grid</strong>, <strong>display:flex</strong>, <strong>display:inline-grid</strong>, 또는 <strong>display:inline-flex</strong>를 추가해보세요. { learn-more }
inactive-css-not-grid-item-fix-2 = <strong>display:grid</strong> 또는 <strong>display:inline-grid</strong>를 요소의 부모에 추가해보세요. { learn-more }
inactive-css-not-grid-container-fix = <strong>display:grid</strong> 또는 <strong>display:inline-grid</strong>을 추가하세요. { learn-more }
inactive-css-not-flex-item-fix-2 = <strong>display:flex</strong> 또는 <strong>display:inline-flex</strong>를 요소의 부모에 추가해보세요. { learn-more }
inactive-css-not-flex-container-fix = <strong>display:flex</strong> 또는 <strong>display:inline-flex</strong>을 추가해보세요. { learn-more }
inactive-css-not-inline-or-tablecell-fix = <strong>display:inline</strong> 또는 <strong>display:table-cell</strong>을 추가해보세요. { learn-more }
inactive-css-non-replaced-inline-or-table-row-or-row-group-fix = <strong>display:inline-block</strong> 또는 <strong>display:block</strong>을 추가해보세요. { learn-more }
inactive-css-non-replaced-inline-or-table-column-or-column-group-fix = <strong>display:inline-block</strong>을 추가해보세요. { learn-more }
inactive-css-not-display-block-on-floated-fix = <strong>float</strong>를 제거하거나 <strong>display:block</strong>을 추가해보세요. { learn-more }
inactive-css-position-property-on-unpositioned-box-fix = <strong>position</strong> 속성을 <strong>static</strong> 이외의 것으로 설정해 보세요. { learn-more }
inactive-text-overflow-when-no-overflow-fix = <strong>overflow:hidden</strong>을 추가해보세요. { learn-more }
inactive-css-not-for-internal-table-elements-fix = <strong>display</strong> 속성을 <strong>table-cell</strong>, <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong>, 또는 <strong>table-footer-group</strong> 이외의 것으로 설정해 보세요. { learn-more }
inactive-css-not-for-internal-table-elements-except-table-cells-fix = <strong>display</strong> 속성을 <strong>table-column</strong>, <strong>table-row</strong>, <strong>table-column-group</strong>, <strong>table-row-group</strong>, 또는 <strong>table-footer-group</strong> 이외의 것으로 설정해 보세요. { learn-more }
inactive-outline-radius-when-outline-style-auto-or-none-fix = <strong>outline-style</strong> 속성을 <strong>auto</strong> 또는 <strong>none</strong> 이외의 것으로 설정해보세요. { learn-more }
inactive-css-not-table-fix = <strong>display:table</strong> 또는 <strong>display:inline-table</strong>을 추가해보세요. { learn-more }
inactive-scroll-padding-when-not-scroll-container-fix = <strong>overflow:auto</strong>, <strong>overflow:scroll</strong>, 또는 <strong>overflow:hidden</strong>을 추가해보세요. { learn-more }

## In the Rule View when a CSS property may have compatibility issues with other browsers
## we display an icon. When this icon is hovered this message is displayed to explain why
## the property is incompatible and the platforms it is incompatible on.
## Variables:
##   $property (string) - A CSS declaration name e.g. "-moz-user-select" that can be a platform specific alias.
##   $rootProperty (string) - A raw CSS property name e.g. "user-select" that is not a platform specific alias.

css-compatibility-default-message = <strong>{ $property }</strong>은(는) 다음 브라우저에서는 지원되지 않습니다:
css-compatibility-deprecated-experimental-message = <strong>{ $property }</strong>은(는) W3C 표준에서 더 이상 사용되지 않는 실험적 속성입니다. 다음 브라우저에서는 지원되지 않습니다:
css-compatibility-deprecated-experimental-supported-message = <strong>{ $property }</strong>은(는) W3C 표준에서 더 이상 사용되지 않는 실험적 속성입니다.
css-compatibility-deprecated-message = <strong>{ $property }</strong>은(는) W3C 표준에서 더 이상 사용되지 않습니다. 다음 브라우저에서는 지원되지 않습니다:
css-compatibility-deprecated-supported-message = <strong>{ $property }</strong>은(는) W3C 표준에서 더 이상 사용되지 않습니다.
css-compatibility-experimental-message = <strong>{ $property }</strong>은(는) 실험적 속성입니다. 다음 브라우저에서는 지원되지 않습니다:
css-compatibility-experimental-supported-message = <strong>{ $property }</strong>은(는) 실험적 속성입니다.
css-compatibility-learn-more-message = <strong>{ $rootProperty }</strong>에 대해 <span data-l10n-name="link">더 알아보기</span>
