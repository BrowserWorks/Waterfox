# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Diagnostikim - Rregullim

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Diagnostikim - Runtime / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Ky { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Rregullim

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = Aktivizuar për USB

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = Çaktivizuar për USB

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = I lidhur
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = I shkëputur

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = S’u pikasën pajisje

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Lidhu

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Po lidhet…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Lidhja dështoi

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Lidhja ende pezull, shihni për mesazhe në shfletuesin e synuar

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Lidhjes i mbaroi koha

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = I lidhur

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Po pritet për shfletues…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Të shkëputura

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Mbulim Për Diagnostikime

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Ikonë ndihme

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Rifresko pajisjet

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Rregullim

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Formësoni metodë lidhjeje që doni për diagnostikim të largët të pajisjes tuaj.

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = Përdorni <a>{ about-debugging-this-firefox-runtime-name }</a> që të diagnostikoni zgjerime dhe <em>service workers</em> në këtë version të { -brand-shorter-name }.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Lidhni një Pajisje

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Aktivizimi i kësaj do të shkarkojë dhe shtojë te { -brand-shorter-name } përbërësit e domosdoshëm për diagnostikim USB Android.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Aktivizo Pajisje USB

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Çaktivizo Pajisje USB

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Po përditësohet…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = E aktivizuar
about-debugging-setup-usb-status-disabled = E çaktivizuar
about-debugging-setup-usb-status-updating = Po përditësohet…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Aktivizoni menu Zhvilluesi te pajisja juaj Android.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Aktivizoni Diagnostikim USB te Menuja Zhvillues e Android-it.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Aktivizoni Diagnostikim USB te Firefox-i në pajisjen Android.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Lidheni pajisjen Android me kompjuterin tuaj.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Probleme lidhjeje me një pajisje USB? <a>Diagnostikojeni</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Vendndodhje Në Rrjet

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Probleme lidhjeje përmes vendndodhjeje rrjeti? <a>Diagnostikojeni</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Shtoje

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = S’janë shtuar ende vendndodhje rrjeti.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Strehë

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Hiqe

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Strehë e pavlefshme “{ $host-value }”. Formati i pritshëm është “hostname:portnumber”.

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Streha “{ $host-value }” është e regjistruar tashmë

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Zgjerime të Përkohshme
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Zgjerime
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Skeda
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Service Workers
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Workers të Përbashkët
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Workers të Tjerë
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Procese

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Funksionim profili

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Formësimi i shfletuesit tuaj s’është i përputhshëm me Service Workers. <a>Mësoni më tepër</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old =
    Shfletuesi i lidhur ka një version të vjetër ({ $runtimeVersion }). Versioni minimum që mbulohet është ({ $minVersion }). Ky është formësim i pambuluar dhe mund të bëjë që DevTools të mos funksionojnë. Ju lutemi, përditësoni shfletuesin.
    <a>Diagnostikim</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Ky version i Firefox-it s’mund të diagnostikojë Firefox-in për Android (68). Rekomandojmë që për testime në telefonin tuaj të instaloni Firefox-in për Android Nightly. <a>Më tepër hollësi</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Shfletuesi i lidhur është më i freskët ({ $runtimeVersion }, buildID { $runtimeID }) se sa i juaji { -brand-shorter-name } ({ $localVersion }, buildID { $localID }). Ky është një rast që nuk mbulohet dhe mund të bëjë që DevTools të dështojnë. Ju lutemi, përditësoni Firefox-in. <a>Diagnostikim</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Shkëputu

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Aktivizo kërkesë lidhjeje

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Çaktivizo kërkesë lidhjeje

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Profilizues

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Tkurre / zgjeroje

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Ende pa gjë.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Shqyrtoje

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Ngarko Shtesën e Përkohshme…

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = Pati një gabim gjatë instalimit të shtesës së përkohshme.

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Ringarkoje

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Hiqe

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Përzgjidhni kartelë manifest.json ose arkiv .xpi/.zip

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = Ky WebExtension ka një ID të përkohshme. <a>Mësoni më tepër</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = URL Manifesti

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = UUID i brendshëm

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Vendndodhje

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = ID Zgjerimi

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push
    .disabledTitle = Service Worker push është aktualisht e çaktivizuar për { -brand-shorter-name } multiproces

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Start
    .disabledTitle = Service Worker start është aktualisht e çaktivizuar për { -brand-shorter-name } multiproces

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Çregjistroje

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = Po përgjon për akte fetch

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = S’po përgjohet për akte fetch

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Në xhirim

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = I ndalur

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Po regjistrohet

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Fokus

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Shërbim Push

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = Mbikëqyrja e Service Worker-it është aktualisht e çaktivizuar për { -brand-shorter-name } multiproces

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = Skeda s’është ngarkuar plotësisht dhe s’mund të inspektohet

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Procesi Kryesor

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Proces Kryesor për shfletuesin e synuar

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Kuti mjetesh Multiproces

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Procesi Kryesor dhe Procese Lënde për shfletuesin e synuar

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Mbylle mesazhin

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Hollësi gabimi

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Hollësi sinjalizimi

# Label text used for default state of details of message component.
about-debugging-message-details-label = Hollësi
