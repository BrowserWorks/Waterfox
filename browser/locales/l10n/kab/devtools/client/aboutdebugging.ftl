# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Tamseɣtayt - Aswel

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Tamseɣtayt- Aselkem / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Aya { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Sebded

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB irmed

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB insa

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Iqqen
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Yeffeɣ

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Ulac ibenkan i yellan

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Qqen

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Tuqqna…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Tuqqna tecceḍ

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Tuqqna tezga tettraǧu, wali iznan deg yiminig asaḍas

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Akud n tuqqna yezri

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Iqqen

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Ittṛaǧu iminig...

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Yettwakkes

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName }{ $deviceName }
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Tallelt deg temseɣtayt

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Tignit n tallelt

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Smiren ibenkan

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Sebded

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Swel tarrayt n tuqqna swayes i tessarameḍ ad tseɣtiḍ s wudem anmeggag ibenk-ik.

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = Seqdec <a>{ about-debugging-this-firefox-runtime-name }</a> akken ad tesseɣtiḍ isiɣzaf akked imeẓla workers deg lqem-a n { -brand-shorter-name }.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Qen ibenk

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Arma ad isider daɣen ad isbedd isuddisen n temseɣtayt USB Android i { -brand-shorter-name }.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Rmed ibenkan USB

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Sens ibenkan USB

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Aleqqem...

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Irmed
about-debugging-setup-usb-status-disabled = Arurmid
about-debugging-setup-usb-status-updating = Aleqqem...

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Rmed umuɣ Aneflay deg yiben-ik Android.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Rmed tamseɣtayt USB deg umuɣ Aneflay Android.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Rmed tamseɣtayt USB def Firefox deg yibenk-ik android.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Qqen ibenk Andoid ɣer uselkim-ik/im.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Uguren n tuqqna ɣer yiben USB? <a>Fru uguren

# Network section of the Setup page
about-debugging-setup-network =
    .title = Adig n uẓeṭṭa

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Uguren n tuqqna s wadig n uẓeṭṭa? <a>Fru uguren</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Rnu

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Ulac adig n uẓeṭṭa yettwarnan.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Asenneftaɣ

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Kkes

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Asennftaɣ "{ $host-value }". Amasal yettwaṛǧa d “hostname:portnumber”.

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Asenneftaɣ "{ $host-value }" yettwasekles yakan

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Isiɣzaf iskudanen
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Isiɣzaf
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Tibzimin
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Ameẓlu Workers
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Inmahalen ibḍan
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Workers nniḍen
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Ikalan

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Tamellit n umaɣnu

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Tawila n iminig-inek ur temṣada ara akked Service Workers. <a>Issin ugar</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = Iminig yeqqnen ɣur-s lqem aqbuṛ { $runtimeVersion }. Lqem adday yettwasefraken d { $minVersion }. D tawila ur nettusefrak ara i yezemren ad d-teglu s wuguren akked ifecka n tneflit. Ma ulac aɣilif, leqqem iminig yeqqnen. <a>Fru uguren</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Lqem-a n Firefox ur izmir ara ad iseɣti Firefox i Android (68). Ad k-nwelleh ad tesbeddeḍ Firefox i Android Nightli deg tiliɣri-ik i usekyed. <a>Ugar n yisallen</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Iminig yeqqnen d amaynut { $runtimeVersion }, asulay n bennu { $runtimeID } ɣef wayla-k { -brand-shorter-name }{ -brand-shorter-name } ({ $localVersion }, asulay n bennu { $localID }). Wagu d tawila ur nettusefrak ara daɣen dayen ara yeǧǧen ifecka n tneflin ur leḥḥun ara. Leqqem Firefox ma ulac aɣilif. <a>Fru uguren</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Ffeɣ

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Rmed aneftaɣ n tiqqna

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Sens aneftaɣ n tuqqna

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Amaɣnay

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Fneẓ / Snefli

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Ulac yakan

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Ṣweḍ

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Sali-d izegrar iskudanen…

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = Teḍra-d tuccḍa deg usebded n uzegrir askudan.

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Smiren

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Kkes

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Fren afaylu manifest.json neɣ taṛcivt .xpi/.zip

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = WebExtension-agi ɣur-s asulay ID askudan. <a>Issin ugar</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = Tansa URL n Manifest

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = AgensanUUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Adig

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = ID n usiɣzef

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push
    .disabledTitle = Ameẓlu Worker Push yensa akka tura i uskar agetakala n { -brand-shorter-name }

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Start
    .disabledTitle = Ameẓlu Worker Push yensa akka tura i uskar agetakala n { -brand-shorter-name }

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Ksiggez

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = Asɣad n yineḍruyen Fetch

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = Ulac asɣad n yinuḍruyen Fetch

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Aselkem

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Yeḥbes

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Ajerred

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Tanerfadit

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Ameẓlu Push

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = Aswaḍ n umeẓlu Worker yensa akka tura deg uskar agentakala n { -brand-shorter-name }

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = Iccer ur d-yuli ara akk, ur yezmir ara ad yettusenqed

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Akala agejdan

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Akala agejdan i yiminig asaḍas

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Tabwaḍt n yifecka aget akala

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Akala agejdan akked ukala n ugbur i yiminig asaḍas

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Mdel izen

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Talqayt n tuccḍa

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Talɣayt n yilɣa

# Label text used for default state of details of message component.
about-debugging-message-details-label = Talqayt
