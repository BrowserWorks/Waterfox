# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = डीबगिंग - सेटअप

# Sidebar strings

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = सेटअप

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB सक्षम

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB अक्षम

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = जोडलेले
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = खंडीत

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = कोणतीही उपकरणे आढळली नाहीत

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = जोडा

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = जोडणी करत आहे…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = जोडणी अयशस्वी

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = जोडणी कालबाह्य

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = जोडलेले

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = ब्राउझरची प्रतीक्षा करीत आहे ...

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = प्लग न केलेले

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = डीबगिंग समर्थन

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = मदत चिन्ह

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = उपकरणे पुन्हा दाखल करा

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = सेटअप

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = उपकरण जोडा

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = USB उपकरणे सक्षम करा

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = USB उपकरणे अक्षम करा

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = अद्ययावत करत आहे...

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = सक्रिय
about-debugging-setup-usb-status-disabled = निष्क्रिय
about-debugging-setup-usb-status-updating = अद्ययावत करत आहे...

# Network section of the Setup page
about-debugging-setup-network =
    .title = नेटवर्क स्थान

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = जोडा

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = यजमान

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = काढून टाका

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = तात्पुरते विस्तार
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = विस्तार
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = टॅब
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Service Workers
# Title of the processes category.
about-debugging-runtime-processes =
    .name = प्रक्रिया

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = प्रोफाइल कामगिरी

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ( { $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = खंडीत करा

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = प्रोफाइलर

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = आतापर्यंत काहीही नाही.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = तपासा

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = पुनःदाखल करा

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = काढून टाका

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = स्थान

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = विस्तार ID

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = नोंदणी रद्द करा

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = सुरू आहे

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = थांबले आहे

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = नोंदणी करत आहे

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = मर्यादा

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = पुश सेवा

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = मुख्य प्रक्रिया

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = संदेश बंद करा

# Label text used for the error details of message component.
about-debugging-message-details-label-error = त्रुटी तपशील

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = चेतावणी तपशील

# Label text used for default state of details of message component.
about-debugging-message-details-label = तपशील
