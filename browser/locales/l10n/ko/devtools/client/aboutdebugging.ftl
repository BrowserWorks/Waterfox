# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = 디버깅 - 설정

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = 디버깅 - 런타임 / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Waterfox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = 이 { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Waterfox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = 설정

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB 사용함

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB 사용 안 함

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = 연결됨
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = 연결 끊김

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = 기기를 찾을 수 없음

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = 연결

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = 연결 중…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = 연결 실패

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = 연결이 아직 대기 중입니다. 대상 브라우저에서 메시지를 확인하세요

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = 연결 시간 초과

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Waterfox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Waterfox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = 브라우저를 기다리는 중…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = 분리됨

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = 디버깅 지원

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = 도움말 아이콘

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = 기기 새로 고침

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = 설정

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = 기기를 원격으로 디버깅할 연결 방법을 구성합니다.

# Explanatory text in the Setup page about what the 'This Waterfox' page is for
about-debugging-setup-this-firefox2 = 이 버전의 { -brand-shorter-name }에서 확장 기능 및 Service Worker를 디버그하려면 <a>{ about-debugging-this-firefox-runtime-name }</a>를 사용하세요.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = 기기 연결

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = 이것을 사용하면 필요한 Android USB 디버깅 구성 요소를 다운로드하여 { -brand-shorter-name }에 추가합니다.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = USB 기기 사용함

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = USB 기기 사용 안 함

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = 업데이트 중…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = 사용함
about-debugging-setup-usb-status-disabled = 사용 안 함
about-debugging-setup-usb-status-updating = 업데이트 중…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Android 기기에서 개발자 메뉴를 활성화합니다.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Android 개발자 메뉴에서 USB 디버깅을 활성화합니다.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Android 기기에서 Waterfox에서의 USB 디버깅을 활성화합니다.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Android 기기를 컴퓨터에 연결합니다.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = USB 기기에 연결하는데 문제가 있습니까? <a>문제 해결</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = 네트워크 위치

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = 네트워크 위치를 통해 연결하는데 문제가 있습니까? <a>문제 해결</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = 추가

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = 네트워크 위치가 아직 추가되지 않았습니다.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = 호스트

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = 제거

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = 유효하지 않은 호스트 “{ $host-value }” 입니다. 유효한 형식은 “호스트이름:포트번호” 입니다.

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = “{ $host-value }” 호스트는 이미 등록되었습니다.

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Waterfox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = 임시 확장 기능
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = 확장 기능
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = 탭
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Service Worker
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = 공유된 Worker
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = 다른 Worker
# Title of the processes category.
about-debugging-runtime-processes =
    .name = 프로세스

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = 성능 프로파일

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = 브라우저 구성이 Service Worker와 호환되지 않습니다. <a>더 알아보기</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Waterfox instance (same format)
about-debugging-browser-version-too-old = 연결된 브라우저에는 이전 버전 ({ $runtimeVersion })이 있습니다. 지원되는 최소 버전은 ({ $minVersion }) 입니다. 이것은 지원되지 않는 설정이며 DevTools가 실패할 수 있습니다. 연결된 브라우저를 업데이트하세요. <a>문제 해결</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Waterfox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = 이 Waterfox 버전은 Android용 Waterfox (68)를 디버깅 할 수 없습니다. 테스트를 위해 휴대폰에 Android Nightly용 Waterfox를 설치하는 것이 좋습니다. <a>추가 정보</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Waterfox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = 연결된 브라우저가 { -brand-shorter-name } ({ $localVersion }, buildID { $localID })보다 최근 버전({ $runtimeVersion }, buildID { $runtimeID })입니다. 이것은 지원되지 않는 설정이며 DevTools가 실패할 수 있습니다. Waterfox를 업데이트하세요. <a>문제 해결</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Waterfox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = 연결 끊기

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = 연결 프롬프트 사용

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = 연결 프롬프트 사용 안 함

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = 프로파일러

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = 접기 / 펼치기

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = 아직 없습니다.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = 검사

# Text of a button displayed in the "This Waterfox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = 임시 부가 기능 로드…

# Text displayed when trying to install a temporary extension in the "This Waterfox" page.
about-debugging-tmp-extension-install-error = 임시 부가 기능을 설치하는 동안 오류가 발생했습니다.

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = 새로 고침

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = 제거

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = manifest.json 파일 또는 .xpi/.zip 보관 파일을 선택하세요

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = 이 WebExtension에는 임시 ID가 있습니다. <a>더 알아보기</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = 매니페스트 URL

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = 내부 UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = 위치

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = 확장 기능 ID

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push
    .disabledTitle = Service Worker 푸시가 현재 다중 프로세스 { -brand-shorter-name }에 대해 비활성화되어 있습니다.

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = 시작
    .disabledTitle = Service Worker 시작이 현재 다중 프로세스 { -brand-shorter-name }에 대해 비활성화되어 있습니다

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = 등록해제

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = fetch 이벤트를 기다리는 중

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = fetch 이벤트를 기다리지 않습니다

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = 실행 중

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = 중지됨

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = 등록 중

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = 범위

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Push 서비스

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = Service Worker 검사가 현재 다중 프로세스 { -brand-shorter-name }에 대해 비활성화되어 있습니다.

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = 탭이 완전히 로드되지 않아 검사할 수 없습니다.

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = 메인 프로세스

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = 대상 브라우저의 메인 프로세스

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = 다중 프로세스 도구상자

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = 대상 브라우저의 메인 프로세스 및 콘텐츠 프로세스

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = 메시지 닫기

# Label text used for the error details of message component.
about-debugging-message-details-label-error = 오류 세부 정보

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = 경고 세부 정보

# Label text used for default state of details of message component.
about-debugging-message-details-label = 상세 정보
