# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = डिबगिंग - सेटअप

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = डिबगिंग - रनटाइम / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = यह { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = सेटअप

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB सक्रिय किया गया

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB निष्क्रिय किया गया

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = कनेक्ट किया गया
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = डिस्कनेक्ट किया गया

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = कोई उपकरण नहीं मिला

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = जुड़ें

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = जुड़ रहा है…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = कनेक्शन असफल रहा

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = कनेक्शन अभी भी लंबित है, लक्षित ब्राउज़र पर संदेशों की जांच करें

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = कनेक्शन का समय समाप्त

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = कनेक्ट किया गया

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = ब्राउज़र की प्रतीक्षा...

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = डिबगिंग समर्थन

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = मदद आइकन

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = उपकरणों को ताज़ा करें

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = सेटअप

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = एक डिवाइस कनेक्ट करें

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = USB उपकरणों को सक्रिय करें

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = USB उपकरणों को निष्क्रिय करें

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = अप्डेट हो रहा है...

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = सक्रिय किया गया
about-debugging-setup-usb-status-disabled = निष्क्रिय किया गया
about-debugging-setup-usb-status-updating = अप्डेट हो रहा है...

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = अपने Android उपकरण पर डेवलपर मेन्यू सक्रिय करें।

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Android डेवलपर मेन्यू में USB डिबगिंग सक्रिय करें।

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Android उपकरण पर Firefox में USB डिबगिंग सक्रिय करें।

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Android उपकरण को अपने कंप्यूटर से कनेक्ट करें।

# Network section of the Setup page
about-debugging-setup-network =
    .title = संजाल स्थान

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = जोड़ें

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = होस्ट

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = हटाएं

# Runtime Page strings

# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = एक्स्टेंशन्स
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = टैब्स
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = सेवा कर्मचारी
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = अन्य कर्मचारी
# Title of the processes category.
about-debugging-runtime-processes =
    .name = प्रक्रियाएं

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = प्रोफाइल प्रदर्शन

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = प्रोफाइलर

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = अभी तक कुछ नहीं.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = जाँचें

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = पुनः लोड करें

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = हटाएं

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = मैनिफेस्ट URL

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = आंतरिक UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = स्थान

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = एक्सटेंशन ID

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = अपंजीकृत करें

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = क्रियाशील

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = रुका हुआ

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = पंजीकृत किया जा रहा है

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = स्कोप

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = मुख्य प्रक्रिया

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = लक्षित ब्राउज़र के लिए मुख्य प्रक्रिया

# Label text used for the error details of message component.
about-debugging-message-details-label-error = त्रुटि विवरण

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = चेतावनी विवरण

# Label text used for default state of details of message component.
about-debugging-message-details-label = विवरण
