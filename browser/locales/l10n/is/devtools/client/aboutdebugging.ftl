# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings


# Sidebar strings

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Uppsetning

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB skynjari virkur

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB skynjari óvirkur

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Tengd(ur)
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Ótengd(ur)

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Ekkert tæki fannst

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Tengja

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Tenging í gangi...

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Tengingin mistókst

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Tenging féll á tíma

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Tengd(ur)

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Beðið eftir vafra…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Ótengt

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName }{ $deviceName }
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Stuðningur við kembingu

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Hjálparíkon

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Endurglæða tæki

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Uppsetning

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Stilla tengileiðina sem þú vilt nota til að kemba tækið þitt með í fjarvinnslu.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Tengja tæki

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Viðeigandi Android USB kembunarhlutar fyrir { -brand-shorter-name } munu verða hlaðnir niður og bætt við ef þú virkjar þetta.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Virkja USB tæki

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Óvirkja USB tæki

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Uppfæri…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Virkt
about-debugging-setup-usb-status-disabled = Óvirkt
about-debugging-setup-usb-status-updating = Uppfæri…

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Tengja Android tækið við tölvuna þína.

# Network section of the Setup page
about-debugging-setup-network =
    .title = Netstaðsetning

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Bæta við

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Engum netstaðsetningum hefur verið bætt við ennþá.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Hýsill

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Fjarlægja

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Ógildur hýsill "{ $host-value }". Búist var við sniðmátinu "hostname:portnumber”.

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Tímabundnar viðbætur
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Viðbætur
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Flipar
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Þræðir

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Aftengja

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Fella saman/afþjappa

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Ekkert ennþá.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Skoða

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Endurhlaða

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Fjarlægja

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Staðsetning

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Afskrá

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Í gangi

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Stöðvað

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Umfang

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Villu upplýsingar

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Viðvörunarupplýsingar

# Label text used for default state of details of message component.
about-debugging-message-details-label = Nánar
