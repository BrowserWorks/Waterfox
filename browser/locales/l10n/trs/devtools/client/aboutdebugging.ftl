# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Nagi'iaj hìo - Nagi'iaj riñaj

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Nagi'iaj hìo - Diû gi'iaj sunj / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Nan { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Chrej ganikò'

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = Nga 'iaj sun USB

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = Nitaj si 'iaj sun USB

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Hua konektadoj
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Nitaj si hua konektadoj

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Nu narì'ij gà' 'ngo aga' li

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Gatu'

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Hìaj 'iaj konektandoj...

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Gire' koneksiûn

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Hua nïn' hua koneksiûn, ni'iaj si hua mensâje riña ruhuât nana'uì't nuguan'an

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Ganahuij diû gayi'ì koneksiûn

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Hua konektadoj

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Ana'ui riña sa gache nu'

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Giri man

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Soportê gi'iaj depurandô'

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = ikonô ga'ue rugûñu'unj

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Nagi'iaj nakò' nej aga'a

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Chrej ganikò'

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Nagi'iaj dàj ga koneksiûn ruhuât nagi'iaj hìo ra'at si agâ't.

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = Garasun<a>{ about-debugging-this-firefox-runtime-name }</a> da' nagi'iaj hìot nej ekstensiûn ni nej sa 'iaj sun riña versiûn nikaj { -brand-shorter-name }.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Gi'iaj konektandô 'ngo aga'a

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Sisi nachrunt nan ni nadunïn ni nùtaj nej rasuun nagi'iaj hìo USB nikaj Android guendâ { -brand-shorter-name }.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Dugi'iaj sun nej aga' USB

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Duna'àj nej aga' USB

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Nagi'iaj nàkaj...

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Ngà 'iaj sunj
about-debugging-setup-usb-status-disabled = Nitaj si 'iaj sunj
about-debugging-setup-usb-status-updating = Nagi'iaj nàkaj

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Dugi'iaj sun si menû desarroyadôr riña si agâ't Android.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Dugi'iaj sun sa nagi'iaj hìo USB riña si Menû desarroyadôr Android.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Dugi'iaj sun sa nagi'iaj hìo USB riña si aga' Firefox

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Gi'iaj konektandô aga' Android riña aga' sikà' rà nikajt

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Chì' 'iaj da' gi'iaj konektandôj ngà si USB raj? <a>Ni'iaj nùj huin si ga'ue gi'iát</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Narì riña nu Red

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Chì' 'ia guendâ gi'iaj konektandôt asìj riña nu red aj? <a>Ni'iaj nùj huin si ga'ue gi'iát</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Nutà'

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Hua nï' nu natà' riña nuj red.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Sa nikaj ñu'unj

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Guxūn

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Nitaj si hua hue'ê Host "{ $host-value }". Nuguan' da'ui ga huin “hostname:portnumber”.

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Host "{ $host-value }" ngà tàj si yugui

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Nej extensiûn nu akuan'
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Nej extensiûn
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Nej rakïj ñaj
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Servisiô Workers
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Nej sa 'iaj sun hua nuguà'an
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = A'ngô nej s 'iaj suun
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Dukuán ganikò'

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Gā yichēj doj Perfî

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Konfugurasiûn nikaj riña sa nana'uî't nuguan'an ni nitaj si aran'anj ngà Service Workers. <a>Gahuin chrun doj</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/WebIDE/Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = Ginâj rukù sa riña nana'uî't nuguan'an ({ $runtimeVersion }). Sa ginâj rukù nï' ga'ue gi'iaj sunt huin ({ $minVersion }). Nitaj si a'ue garan'anj ngà konfigurasiûn nan ni ga'ue si gi'iaj sun hue'ê DevTools gi'ia. Gi'iaj sunuj u ni nagi'iaj nakàt riña nana'uî't nuguan arâj sunt akan' nïn. <a>Sa nagi'iaj sa hua a'nan'an</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/en-US/docs/Tools/WebIDE/Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Hua nakà doj riña sa nana'uî't nuguan' ({ $runtimeVersion }, buildID { $runtimeID }) ngà da' si { -brand-shorter-name }, ({ $localVersion }, buildID { $localID }). Nitaj si aran' konfigurasiûn nan ngàj ni ga'ue si gi'iaj suin DevTools gi'ia. Gi'iaj sunuj u ni nadunïnjt Firefox. <a>Sa nagi'iaj sa hua a'nan'an</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Gahui riña internet

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Dugi'iaj sun sa nachin' nì'iaj ga koneksiûn

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Dunâ'aj sa nachin' nì'iaj ga koneksiûn

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Sa a'min rayi'i'

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Nagi'iaj lî' / nagi'iaj gachrò'

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Nitaj nùnj hua akuan nïn.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Ni'io'

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Nuto' komplemento ginun akuan'...

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = Hua 'ngo sa gahui a'nan' nga na'nïn akuan' nej sa ruhuât nutà't.

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Nagi'iaj nakà

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Guxūn

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Nagui archibô manifest.json asi archibô .xpi/.zip

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = Sa nata' sa hua rayi'î nan ni mà si hua akuan' man. <a>Gahuin chrun doj</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = Nuguan' nikò' URL

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = UUID nu niñaa

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Danè' huin

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = Si ekstensiûn ID

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Guru'man ra'a
    .disabledTitle = Sa ru'man Service Worker nitaj si 'iaj sunj akuan' nïn guendâ multiprosêso { -brand-shorter-name }

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Gayi'ì
    .disabledTitle = Sa gayi'ì Service Worker nitaj si 'iaj sunj guendâ multiprosêso { -brand-shorter-name }

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Guxun' si yugui ma

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = sa nana'ui'
    .value = Gunïn' nej sa hua nana'uij

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Sa nana'ui'
    .value = si gunïn sa hua nana'uij

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Daj 'iaj sun man

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Duguanikïn'

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Nutà' si yugui

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Nda riña guchij

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Servisiô Push

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Sa asinìin

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Dukuán sinïn nikaj sa nana'uî' nuguan'an

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Nar'a riña mensâje

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Hua nej le'ej gahui a'nan'

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Nej le'ej ataj nan'anj 'ngo sa ga'ue gaa

# Label text used for default state of details of message component.
about-debugging-message-details-label = A'ngô nej le'ej nika
