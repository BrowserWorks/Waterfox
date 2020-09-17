# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings


# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = یہ  { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = سیٹ اپ

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB فعال کریں

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB غیر فعال کریں

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = جڈے ہوئے ہے
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = جڈے ہوئے نہیں ہے

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = کوئی آلہ دریافت نہیں ہوا

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = جڑیں

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = جوڑ رہا ہے…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = رابطہ ناکام رہا

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = کنکشن ابھی باقی ہے ، ہدف شدہ براؤزر پر موجود پیغامات کی پڑتال کریں

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = کنکشن کا وقت ختم ہو گیا

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = جڈے ہوئے ہے

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = براؤزر کا انتظار کر رہا ہے…

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName }{ $deviceName }
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = مدد کا آئکن

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = الات تازہ کریں

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = سیٹ اپ

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = ایک آلہ جوڑیں

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = USB آلات کو فعال بنائیں

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = USB آلات کو غیر فعال بنائیں

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = تازہ کاری کر رہا ہے…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = فعال
about-debugging-setup-usb-status-disabled = غیر فعال
about-debugging-setup-usb-status-updating = تازہ کاری کر رہا ہے…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = اپنے Android آلہ پر ڈیولپر مینو کو فعال بنائیں۔

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Android آلہ کو اپنے کمپیوٹر سے مربوط کریں۔

# Network section of the Setup page
about-debugging-setup-network =
    .title = نیٹ ورک کا مقام

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = شامل کریں

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = ابھی تک نیٹ ورک کی کوئی  محل وقوع شامل نہیں کی گئیں۔

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = میزبان

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = ہٹائیں

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = عارضی ایکسٹینشن
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = ایکسٹینشن
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = ٹیبس
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = خدمت کارکنان
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = مشترکہ کارکنان
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = دیگر کارکنان
# Title of the processes category.
about-debugging-runtime-processes =
    .name = عوامل

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = پروفائل کی کارکردگی

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } { $version }

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = منقطع کریں

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = پروفائلر

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = غائب کریں/ وسیع کریں

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = ابھی تک کچھ نہیں

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = معائنہ کریں

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = عارضی ایڈ اون… شامل کریں

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = عارضی ایڈ اون انسٹالیشن  کے دوران ایک خامی تھی۔

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = دوبارہ لوڈ کریں

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = ہٹائیں

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = منشور کا URL

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = اندرونی UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = موجودہ مقام

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = ایکسٹینشن ID

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = ریجسٹریشن ختم کریں

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = چل رہا ہے

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = روک دیا گیا ہے

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = رجسٹریشن کر رہا ہے

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = دائرہ کار

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = پش سروس

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = مرکزی عمل

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = ہدف بشدہ راؤزر کے لئے اہم عمل

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = ملٹی پروسیس ٹول باکس

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = پیغام بند کریں

# Label text used for the error details of message component.
about-debugging-message-details-label-error = نقص کی تفصیلات

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = انتباہ کی تفصیلات

# Label text used for default state of details of message component.
about-debugging-message-details-label = تفصیلات
