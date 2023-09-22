# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### This file contains strings used in highlighters.
### Highlighters are visualizations that DevTools draws on top of content to aid
### in understanding content sizing, etc.

# The row and column position of a grid cell shown in the grid cell infobar when hovering
# over the CSS grid outline.
# Variables
# $row (integer) - The row index
# $column (integer) - The column index
grid-row-column-positions = 행 { $row } / 열 { $column }

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a grid container.
gridtype-container = 그리드 컨테이너

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a grid item.
gridtype-item = 그리드 항목

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is both a grid container and a grid item.
gridtype-dual = 그리드 컨테이너/항목

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a flex container.
flextype-container = 플렉스 컨테이너

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is a flex item.
flextype-item = 플렉스 항목

# The layout type of an element shown in the infobar when hovering over a DOM element and
# it is both a flex container and a flex item.
flextype-dual = 플렉스 컨테이너/항목

# The message displayed in the content page when the user clicks on the
# "Pick an element from the page" in about:devtools-toolbox inspector panel, when
# debugging a remote page.
# Variables
# $action (string) - Will either be remote-node-picker-notice-action-desktop or
#                    remote-node-picker-notice-action-touch
remote-node-picker-notice = 개발자 도구 노드 선택기가 활성화되었습니다. { $action }

# Text displayed in `remote-node-picker-notice`, when the remote page is on desktop
remote-node-picker-notice-action-desktop = 검사기에서 요소를 선택하려면 클릭하세요

# Text displayed in `remote-node-picker-notice`, when the remote page is on Android
remote-node-picker-notice-action-touch = 검사기에서 요소를 선택하려면 누르세요

# The text displayed in the button that is in the notice in the content page when the user
# clicks on the "Pick an element from the page" in about:devtools-toolbox inspector panel,
# when debugging a remote page.
remote-node-picker-notice-hide-button = 숨기기

# The text displayed in a toolbox notification message which is only displayed
# if prefers-reduced-motion is enabled (via OS-level settings or by using the
# ui.prefersReducedMotion=1 preference).
simple-highlighters-message = prefers-reduced-motion이 활성화되면 깜박임을 피하기 위해 설정 패널에서 단순한 하이라이터를 활성화할 수 있습니다.

# Text displayed in a button inside the "simple-highlighters-message" toolbox
# notification. "Settings" here refers to the DevTools settings panel.
simple-highlighters-settings-button = 설정 열기
