# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### Localization for Developer Tools options


## Default Developer Tools section

# The heading
options-select-default-tools-label = 기본 개발자 도구

# The label for the explanation of the * marker on a tool which is currently not supported
# for the target of the toolbox.
options-tool-not-supported-label = * 현재 도구상자 대상에서는 지원하지 않음

# The label for the heading of group of checkboxes corresponding to the developer tools
# added by add-ons. This heading is hidden when there is no developer tool installed by add-ons.
options-select-additional-tools-label = 부가 기능으로 설치된 개발자 도구

# The label for the heading of group of checkboxes corresponding to the default developer
# tool buttons.
options-select-enabled-toolbox-buttons-label = 사용 가능한 도구상자 버튼

# The label for the heading of the radiobox corresponding to the theme
options-select-dev-tools-theme-label = 테마

## Inspector section

# The heading
options-context-inspector = 검사기

# The label for the checkbox option to show user agent styles
options-show-user-agent-styles-label = 브라우저 스타일 보기
options-show-user-agent-styles-tooltip =
    .title = 이 옵션을 켜면 브라우저가 읽어들이는 기본 스타일을 보여줍니다.

# The label for the checkbox option to enable collapse attributes
options-collapse-attrs-label = DOM 속성 줄이기
options-collapse-attrs-tooltip =
    .title = 검사기에서 긴 속성을 줄입니다

## "Default Color Unit" options for the Inspector

options-default-color-unit-label = 기본 색상 단위
options-default-color-unit-authored = 작성된 대로
options-default-color-unit-hex = Hex
options-default-color-unit-hsl = HSL(A)
options-default-color-unit-rgb = RGB(A)
options-default-color-unit-name = 색상 이름

## Style Editor section

# The heading
options-styleeditor-label = 스타일 편집기

# The label for the checkbox that toggles autocompletion of css in the Style Editor
options-stylesheet-autocompletion-label = CSS 자동 완성
options-stylesheet-autocompletion-tooltip =
    .title = 스타일 편집기에서 입력하는 대로 CSS 속성, 값 및 선택자를 자동으로 완성합니다

## Screenshot section

# The heading
options-screenshot-label = 스크린샷 동작

# Label for the checkbox that toggles screenshot to clipboard feature
options-screenshot-clipboard-only-label = 스크린샷을 클립보드에 저장만
options-screenshot-clipboard-tooltip2 =
    .title = 스크린샷을 클립보드에 바로 저장합니다

# Label for the checkbox that toggles the camera shutter audio for screenshot tool
options-screenshot-audio-label = 카메라 셔터 소리 재생
options-screenshot-audio-tooltip =
    .title = 스크린샷을 찍을 때 카메라 셔터 소리를 재생합니다

## Editor section

# The heading
options-sourceeditor-label = 편집기 설정

options-sourceeditor-detectindentation-tooltip =
    .title = 소스 내용을 기반으로 들여 쓰기를 예측합니다
options-sourceeditor-detectindentation-label = 들여 쓰기 감지
options-sourceeditor-autoclosebrackets-tooltip =
    .title = 닫는 괄호를 자동으로 입력합니다
options-sourceeditor-autoclosebrackets-label = 닫는 괄호 자동 입력
options-sourceeditor-expandtab-tooltip =
    .title = 탭 문자 대신 공백 문자를 사용합니다
options-sourceeditor-expandtab-label = 들여 쓰기에 공백 문자 사용
options-sourceeditor-tabsize-label = 탭 길이
options-sourceeditor-keybinding-label = 키 바인딩
options-sourceeditor-keybinding-default-label = 기본 설정

## Advanced section

# The heading (this item is also used in perftools.ftl)
options-context-advanced-settings = 고급 설정

# The label for the checkbox that toggles the HTTP cache on or off
options-disable-http-cache-label = HTTP 캐시 사용 안 함 (도구상자가 열려 있을 때)
options-disable-http-cache-tooltip =
    .title = 이 옵션을 켜면 도구상자가 열려있는 모든 탭에서 HTTP 캐시를 비활성화합니다. Service Worker는 이 설정의 영향을 받지 않습니다.

# The label for checkbox that toggles JavaScript on or off
options-disable-javascript-label = JavaScript 사용 안 함*
options-disable-javascript-tooltip =
    .title = 이 옵션을 켜면 현재 탭의 JavaScript가 꺼집니다. 이 탭이나 도구상자가 닫히면 이 설정도 초기화됩니다.

# The label for checkbox that toggles chrome debugging, i.e. the devtools.chrome.enabled preference
options-enable-chrome-label = 브라우저 크롬 및 부가 기능 디버깅 도구상자 사용
options-enable-chrome-tooltip =
    .title = 이 옵션을 켜면 브라우저 컨텍스트에서 (도구 > 웹 개발자 > 브라우저 도구상자로 불러낸) 여러가지 개발자 도구를 사용하고 부가 기능 관리자에서 부가 기능을 디버깅 할 수 있습니다

# The label for checkbox that toggles remote debugging, i.e. the devtools.debugger.remote-enabled preference
options-enable-remote-label = 원격 디버깅 사용
options-enable-remote-tooltip2 =
    .title = 이 옵션을 켜면 이 브라우저 인스턴스를 원격으로 디버깅 할 수 있습니다

# The label for checkbox that toggles the service workers testing over HTTP on or off.
options-enable-service-workers-http-label = HTTP를 통한 Service Worker 사용 (도구상자가 열려 있을 때)
options-enable-service-workers-http-tooltip =
    .title = 이 옵션을 켜면 도구 상자가 열려 있는 모든 탭에서 HTTP를 통한 Service Worker를 사용할 수 있습니다.

# The label for the checkbox that toggles source maps in all tools.
options-source-maps-label = 소스맵 사용
options-source-maps-tooltip =
    .title = 이 옵션을 사용하면 소스가 도구에서 매핑됩니다.

# The message shown for settings that trigger page reload
options-context-triggers-page-refresh = * 현재 세션만 해당되며, 페이지를 새로 고침

# The label for the checkbox that toggles the display of the platform data in the
# Profiler i.e. devtools.profiler.ui.show-platform-data a boolean preference in about:config
options-show-platform-data-label = Gecko 플랫폼 데이터
options-show-platform-data-tooltip =
    .title = 이 옵션을 사용하면 JavaScript 프로파일러 보고서에 Gecko 플랫폼 기호가 들어갑니다
