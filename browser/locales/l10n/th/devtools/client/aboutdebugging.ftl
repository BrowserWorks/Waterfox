# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = การดีบั๊ก - ตั้งค่า

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = การดีบั๊ก - รันไทม์ / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = { -brand-shorter-name } นี้

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = ตั้งค่า

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = เปิดใช้งาน USB อยู่

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = ปิดใช้งาน USB อยู่

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = เชื่อมต่อแล้ว
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = ตัดการเชื่อมต่อแล้ว

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = ไม่พบอุปกรณ์

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = เชื่อมต่อ

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = กำลังเชื่อมต่อ…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = การเชื่อมต่อล้มเหลว

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = การเชื่อมต่อยังรอค้างอยู่ ตรวจสอบข้อความบนเบราว์เซอร์เป้าหมาย

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = การเชื่อมต่อหมดเวลา

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = เชื่อมต่อแล้ว

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = กำลังรอเบราว์เซอร์…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = ถอดปลั๊กแล้ว

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = ฝ่ายสนับสนุนการดีบั๊ก

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = ไอคอนช่วยเหลือ

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = เรียกอุปกรณ์ใหม่

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = ตั้งค่า

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = กำหนดค่าวิธีการเชื่อมต่อที่คุณต้องการดีบั๊กอุปกรณ์ของคุณจากระยะไกล

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = ใช้ <a>{ about-debugging-this-firefox-runtime-name }</a> เพื่อดีบั๊กส่วนขยายและตัวทำงานบริการบน { -brand-shorter-name } รุ่นนี้

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = เชื่อมต่ออุปกรณ์

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = การเปิดใช้งานสิ่งนี้จะดาวน์โหลดและเพิ่มส่วนประกอบการดีบั๊กผ่าน USB ของ Android ที่จำเป็นใน { -brand-shorter-name }

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = เปิดใช้งานอุปกรณ์ USB

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = ปิดใช้งานอุปกรณ์ USB

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = กำลังอัปเดต…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = เปิดใช้งานอยู่
about-debugging-setup-usb-status-disabled = ปิดใช้งานอยู่
about-debugging-setup-usb-status-updating = กำลังอัปเดต…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = เปิดใช้งานเมนูนักพัฒนาในอุปกรณ์ Android ของคุณ

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = เปิดใช้งานการดีบั๊ก USB ในเมนูนักพัฒนา Android

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = เปิดใช้งานการดีบั๊ก USB ใน Firefox ในอุปกรณ์ Android

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = เชื่อมต่ออุปกรณ์ Android กับคอมพิวเตอร์ของคุณ

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = มีปัญหาในการเชื่อมต่อกับอุปกรณ์ USB? <a>แก้ไขปัญหา</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = ตำแหน่งที่ตั้งเครือข่าย

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = มีปัญหาในการเชื่อมต่อผ่านตำแหน่งที่ตั้งเครือข่าย? <a>แก้ไขปัญหา</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = เพิ่ม

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = ยังไม่ได้เพิ่มตำแหน่งที่ตั้งเครือข่าย

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = โฮสต์

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = เอาออก

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = โฮสต์ “{ $host-value }” ไม่ถูกต้อง รูปแบบที่ต้องการคือ “hostname:portnumber”

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = โฮสต์ “{ $host-value }” ถูกลงทะเบียนแล้ว

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = ส่วนขยายชั่วคราว
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = ส่วนขยาย
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = แท็บ
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = ตัวทำงานบริการ
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = ตัวทำงานที่ใช้ร่วมกัน
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = ตัวทำงานอื่น ๆ
# Title of the processes category.
about-debugging-runtime-processes =
    .name = โปรเซส

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = ประสิทธิภาพโปรไฟล์

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = การกำหนดค่าเบราว์เซอร์ของคุณเข้ากันไม่ได้กับตัวทำงานบริการ <a>เรียนรู้เพิ่มเติม</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = เบราว์เซอร์ที่เชื่อมต่อมีรุ่นเก่า ({ $runtimeVersion }) รุ่นที่รองรับขั้นต่ำคือ ({ $minVersion }) นี่เป็นการตั้งค่าที่ไม่รองรับและอาจทำให้ DevTools ล้มเหลว โปรดอัปเดตเบราว์เซอร์ที่เชื่อมต่อ <a>การแก้ไขปัญหา</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Waterfox รุ่นนี้ไม่สามารถดีบั๊ก Firefox สำหรับ Android (68) ได้ เราแนะนำให้ติดตั้ง Firefox สำหรับ Android Nightly บนโทรศัพท์ของคุณเพื่อทำการทดสอบ <a>รายละเอียดเพิ่มเติม</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = เบราว์เซอร์ที่เชื่อมต่อเป็นรุ่น ({ $runtimeVersion }, buildID { $runtimeID }) ซึ่งใหม่กว่า { -brand-shorter-name } ({ $localVersion }, buildID { $localID }) ซึ่งไม่รองรับและอาจทำให้ DevTools ทำงานล้มเหลวได้ โปรดอัปเดต Firefox <a>การแก้ไขปัญหา</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = ตัดการเชื่อมต่อ

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = เปิดใช้งานพรอมต์การเชื่อมต่อ

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = ปิดใช้งานพรอมต์การเชื่อมต่อ

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = ตัวสร้างโปรไฟล์

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = ยุบ / ขยาย

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = ยังไม่มีสิ่งใด

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = ตรวจสอบ

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = โหลดส่วนเสริมชั่วคราว…

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = เกิดข้อผิดพลาดระหว่างติดตั้งส่วนเสริมแบบชั่วคราว

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = โหลดใหม่

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = เอาออก

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = เลือกไฟล์ manifest.json หรือไฟล์เก็บถาวร .xpi/.zip

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = WebExtension นี้มี ID ชั่วคราว <a>เรียนรู้เพิ่มเติม</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = URL ไฟล์กำกับ

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = UUID ภายใน

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = ตำแหน่งที่ตั้ง

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = ID ส่วนขยาย

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = ผลัก
    .disabledTitle = การผลักตัวทำงานบริการถูกปิดใช้งานอยู่สำหรับ { -brand-shorter-name } แบบหลายกระบวนการในขณะนี้

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = เริ่ม
    .disabledTitle = การเริ่มตัวทำงานบริการถูกปิดใช้งานอยู่สำหรับ { -brand-shorter-name } แบบหลายกระบวนการในขณะนี้

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = เลิกลงทะเบียน

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = ดึงข้อมูล
    .value = กำลังรับฟังเหตุการณ์การดึงข้อมูล

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = ดึงข้อมูล
    .value = ไม่ได้รับฟังเหตุการณ์การดึงข้อมูลอยู่

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = กำลังทำงาน

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = หยุดอยู่

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = กำลังลงทะเบียน

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = ขอบเขต

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = บริการผลัก

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = การตรวจสอบตัวทำงานบริการถูกปิดใช้งานอยู่สำหรับ { -brand-shorter-name } แบบหลายกระบวนการในขณะนี้

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = แท็บยังไม่ได้โหลดอย่างเต็มที่และไม่สามารถตรวจสอบได้

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = โปรเซสหลัก

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = โปรเซสหลักสำหรับเบราว์เซอร์เป้าหมาย

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = กล่องเครื่องมือแบบหลายกระบวนการ

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = กระบวนการหลักและกระบวนการเนื้อหาสำหรับเบราว์เซอร์เป้าหมาย

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = ปิดข้อความ

# Label text used for the error details of message component.
about-debugging-message-details-label-error = รายละเอียดข้อผิดพลาด

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = รายละเอียดคำเตือน

# Label text used for default state of details of message component.
about-debugging-message-details-label = รายละเอียด
