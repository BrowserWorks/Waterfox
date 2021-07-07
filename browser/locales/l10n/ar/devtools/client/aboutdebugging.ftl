# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = التنقيح - الإعداد
# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = التنقيح - زمن التشغيل / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = { -brand-shorter-name } هذا
# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }
# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = الإعداد
# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = الربط عبر USB يعمل
# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = الربط عبر USB لا يعمل
# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = متصّل
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = غير متصّل
# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = لم تُكتشف أي أجهزة
# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = اتّصل
# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = يتّصل…
# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = فشل الاتصال
# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = ما زال الاتصال جارٍ، طالِح الرسائل في المتصفح الهدف
# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = انتهت المهلة للاتصال
# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = متّصل
# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = ينتظر المتصفح…
# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = مفصول
# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }
# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = دعم التنقيح
# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = أيقونة المساعدة
# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = أنعِش الأجهزة

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = الإعداد
# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = اضبط الطريقة التي تريد بها الاتصال بجهازك لتنقيحه.
# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = استعمل <a>{ about-debugging-this-firefox-runtime-name }</a> لتنقّح الامتدادات وعمّال الخدمة في إصدارة { -brand-shorter-name } هذه.
# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = أوصِل جهازا
# USB section of the Setup page
about-debugging-setup-usb-title = USB
# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = بتفعيل هذا تُنزّل وتُضيف المكوّنات المطلوبة إلى { -brand-shorter-name } لتنقيح أجهزة أندرويد عبر USB.
# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = فعّل الأجهزة عبر USB
# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = عطّل الأجهزة عبر USB
# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = يحدّث…
# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = مفعّل
about-debugging-setup-usb-status-disabled = معطّل
about-debugging-setup-usb-status-updating = يحدّث…
# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = فعّل قائمة ”مطوّر البرامج/Developer“ في جهاز أندرويد لديك.
# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = فعّل ”تصحيح أخطاء USB/‏USB Debugging“ في قائمة ”مطور البرامج/Developer“.
# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = فعّل التنقيح عبر USB في متصفح Firefox على أجهزة أندرويد.
# USB section step by step guide
about-debugging-setup-usb-step-plug-device = أوصِل جهاز أندرويد بهذا الحاسوب.
# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = أتواجه مشاكل بالاتصال بجهازك عبر USB؟ <a>تعقّب المشكلة</a>
# Network section of the Setup page
about-debugging-setup-network =
    .title = مكان على الشبكة
# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = أتواجه مشاكل بالاتصال بمكان على الشبكة؟ <a>تعقّب المشكلة</a>
# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = أضِف
# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = لم تُضف أي أماكن على الشبكة بعد.
# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = المضيف
# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = أزِل
# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = المضيف ”{ $host-value }“ غير صالح. التنسيق الذي توقّعتُه هو ‎“hostname:portnumber”‎.
# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = المضيف ”{ $host-value }“ مسجّل فعلا

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = الامتدادات المؤقتة
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = الامتدادات
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = الألسنة
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = عمال الخدمة
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = العمال المشتركين
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = بقية العمّال
# Title of the processes category.
about-debugging-runtime-processes =
    .name = العمليات
# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = إعدادات المتصفح لديك غير متوافقة مع عمّال الخدمة. <a>اطّلع على المزيد</a>
# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = إصدارة المتصفّح المتّصل قديمة ({ $runtimeVersion }). أدنى إصدارة مدعومة هي ({ $minVersion }). عملية الإعداد هذه غير مدعومة وقد لا تعمل أدوات المطوّرين بناء على ذلك. من فضلك حدّث المتصفّح المتّصل. <a>مواجهة الأعطال</a>
# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = لا يمكن لإصدارة متصفّح Firefox هذه تنقيح Firefox لأندرويد (68). ننصح بتنزيل النسخة الليلية من Firefox لأندرويد على هاتفك لإجراء الاختبارات. <a>تفاصيل أكثر</a>
# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = إصدارة المتصفّح المتّصل ({ $runtimeVersion }، معرّف البناء { $runtimeID }) أحدث من إصدارة { -brand-shorter-name } هذه ({ $localVersion }، معرّف البناء { $localID }). عملية الإعداد هذه غير مدعومة وقد لا تعمل أدوات المطوّرين بناء على ذلك. من فضلك حدّث Firefox. <a>مواجهة الأعطال</a>
# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = ‏{ $name } ‏({ $version })
# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = اقطع الاتصال
# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = وسّع/اطوِ

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = لا شيء بعد.
# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = افحص
# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = حمّل إضافة مؤقتا…
# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = حدث عُطل أثناء تثبيت الإضافة مؤقتا.
# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = أعِد التحميل
# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = أزِل
# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = اختر ملف manifest.json أو أرشيف ‎.xpi/.zip
# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = لامتداد WebExtension هذا معرّف مؤقّت. <a>اطّلع على المزيد</a>
# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = المكان
# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = معرّف الامتداد
# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = ابدأ
    .disabledTitle = بدء عامل الخدمة معطّل حاليًا إذ { -brand-shorter-name } يعمل بأكثر من سيرورة
# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = يعمل
# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = متوقّف
# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = يُسجّل
# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = لم يُحمّل اللسان تمامًا ولا يمكن فحصه
# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = السيرورة الأساسية
# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = شريط أدوات السيرورات المتعددة
# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = أغلِق الرسالة
# Label text used for the error details of message component.
about-debugging-message-details-label-error = تفاصيل العُطل
# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = تفاصيل التحذير
# Label text used for default state of details of message component.
about-debugging-message-details-label = التفاصيل
