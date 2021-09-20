# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Application panel which is available
### by setting the preference `devtools-application-enabled` to true.


### The correct localization of this file might be to keep it in English, or another
### language commonly spoken among web developers. You want to make that choice consistent
### across the developer tools. A good criteria is the language in which you'd find the
### best documentation on web development on the web.

# Header for the list of Service Workers displayed in the application panel for the current page.
serviceworker-list-header = Service Worker

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = <a>about:debugging</a>을 열어서 다른 도메인의 Service Worker 보기

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = 등록 취소

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = 디버그
    .title = 실행되고 있는 Service Worker만 디버그할 수 있음

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = 디버그
    .title = 다중 e10s가 비활성화 된 경우에만 Service Worker를 디버깅 할 수 있습니다.

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = 시작
    .title = 다중 e10s가 비활성화 된 경우에만 Service Worker를 시작할 수 있습니다.

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = 검사

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = 시작

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>에 업데이트됨

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = 소스

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = 상태

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = 실행 중

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = 중지됨

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = 여기서 검사하려면 Service Worker를 등록해야 합니다. <a>더 알아보기</a>

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = 현재 페이지에 Service Worker가 있어야 한다면 몇가지 시도해 볼 수 있습니다

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = 콘솔에서 오류를 확인해 보세요. <a>콘솔 열기</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = Service Worker 등록과정을 살펴보고 예외를 확인해 보세요. <a>디버거 열기</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = 다른 도메인의 Service Worker를 조사해 보세요. <a>about:debugging 열기</a>

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = Service Worker 없음

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = 더 알아보기

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
# <a> and <span> are links that will open the webconsole and the debugger, respectively.
serviceworker-empty-suggestions2 = 현재 페이지에 Service Worker가 있어야 하는 경우, <a>콘솔</a>에서 오류를 찾거나 <span>디버거</span>에서 Service Worker 등록을 단계별로 진행할 수 있습니다.

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging2 = 다른 도메인의 Service Worker 보기

# Header for the Manifest page when we have an actual manifest
manifest-view-header = 앱 매니페스트

# Header for the Manifest page when there's no manifest to inspect
# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro = 여기서 검사하려면 웹 앱 매니페스트를 추가해야 합니다. <a>더 알아보기</a>

# Header for the Manifest page when there's no manifest to inspect
manifest-empty-intro2 = 웹 앱 매니페스트가 감지되지 않음

# The link will open https://developer.mozilla.org/en-US/docs/Web/Manifest
manifest-empty-intro-link = 매니페스트 추가 방법 알아보기

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = 오류 및 경고

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = 아이디

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = 프레젠테이션

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = 아이콘

# Text displayed while we are loading the manifest file
manifest-loading = 매니페스트 로드 중…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = 매니페스트가 로드되었습니다.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = 매니페스트를 로드하는 동안 오류가 발생했습니다:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Waterfox DevTools 오류

# Text displayed when the page has no manifest available
manifest-non-existing = 검사할 매니페스트가 없습니다.

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = 매니페스트는 데이터 URL에 포함됩니다.

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = 용도: <code> { $purpose } </code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = 아이콘

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = 아이콘 크기: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = 크기가 지정안된 아이콘

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = 매니페스트
    .alt = 매니페스트 아이콘
    .title = 매니페스트

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = Service Worker
    .alt = Service Worker 아이콘
    .title = Service Worker

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = 경고 아이콘
    .title = 경고

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = 오류 아이콘
    .title = 오류

