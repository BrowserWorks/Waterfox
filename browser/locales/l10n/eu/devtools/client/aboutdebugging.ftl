# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Arazketa - Konfigurazioa

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Arazketa - Exekuzio-ingurunea / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = { -brand-shorter-name } hau

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Konfigurazioa

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB gaituta

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB desgaituta

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Konektatuta
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Deskonektatuta

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Ez da gailurik aurkitu

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Konektatu

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Konektatzen…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Konexioak huts egin du

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Konexioa oraindik zain, egiaztatu mezurik dagoen helburuko nabigatzailean

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Konexioa denboraz kanpo

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Konektatuta

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Nabigatzailearen zain…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Desentxufatuta

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Arazketarako laguntza

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Laguntzaren ikonoa

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Berritu gailuak

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Konfigurazioa

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Konfiguratu zure gailua urrunetik arazteko nahi duzun konexio-metodoa.

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = Erabili <a>{ about-debugging-this-firefox-runtime-name }</a> { -brand-shorter-name }(r)en bertsio honetan hedapenak eta zerbitzu-langileak arazteko.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Konektatu gailua

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Gaituz gero, Android USB arazketarako beharrezkoak diren osagaiak deskargatu eta gehituko dira { -brand-shorter-name }(r)en.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Gaitu USB gailuak

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Desgaitu USB gailuak

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Eguneratzen…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Gaituta
about-debugging-setup-usb-status-disabled = Desgaituta
about-debugging-setup-usb-status-updating = Eguneratzen…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Gaitu garatzaile-menua zure Android gailuan.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Gaitu USB arazketa Android garatzaile-menuan.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Gaitu Firefoxen USB arazketa Android gailuan.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Konektatu Android gailua zure ordenagailura.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Arazoak USB gailura konektatzerakoan? <a>Arazo-konpontzea</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Sareko kokalekua

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Arazoak sareko kokaleku baten bidez konektatzerakoan? <a>Arazo-konpontzea</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Gehitu

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Ez da sareko kokalekurik gehitu oraindik.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Ostalaria

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Kendu

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Ostalari baliogabea: "{ $host-value }". Esperotako formatua "ostalari-izena:ataka-zenbakia" da.

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Dagoeneko erregistratuta dago "{ $host-value }" ostalaria

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Behin-behineko hedapenak
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Hedapenak
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Fitxak
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Zerbitzu-langileak
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Partekatutako langileak
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Bestelako langileak
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Prozesuak

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Errendimenduaren profila

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Zure nabigatzailearen konfigurazioa ez da zerbitzu-langileekin bateragarria. <a>Argibide gehiago</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = Konektatutako nabigatzaileak bertsio zaharra dauka ({ $runtimeVersion }). Onartutako bertsio minimoa ({ $minVersion }) da. Euskarririk gabeko konfigurazioa da hau eta garatzaile-tresnek huts egitea eragin lezake. Mesedez eguneratu konektatutako nabigatzailea. <a>Arazo-konpontzea</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Firefoxen bertsio honek ezin du Androiderako Firefox (68) araztu. Probak egiteko, Androiderako Firefoxen Nightly bertsioa instalatzea gomendatzen dugu. <a>Xehetasun gehiago</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Konektatutako nabigatzailea berriagoa da ({ $runtimeVersion }, { $runtimeID } eraikitze-IDa) zure { -brand-shorter-name } ({ $localVersion }, { $localID } eraikitze-IDa) baino. Euskarririk gabeko konfigurazioa da hau eta garatzaile-tresnek huts egitea eragin lezake. Mesedez eguneratu Firefox. <a>Arazo-konpontzea</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Deskonektatu

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Gaitu konexioaren gonbita

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Desgaitu konexioaren gonbita

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Profil sortzailea

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Tolestu / zabaldu

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Ezer ez oraindik.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Ikuskatu

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Kargatu behin-behineko gehigarria…

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = Errorea gertatu da behin-behineko gehigarria instalatzean.

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Berritu

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Kendu

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Hautatu manifest.json fitxategia edo .xpi/zip artxiboa

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = WebExtension honek behin-behineko IDa du. <a>Argibide gehiago</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = Manifestuaren URLa

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = Barneko UUIDa

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Kokalekua

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = Hedapenaren IDa

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push
    .disabledTitle = Zerbitzu Langileen 'push' ekintza desgaituta dago une honetan prozesu anitzeko { -brand-shorter-name }(e)rako

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Start
    .disabledTitle = Zerbitzu Langileen 'start' ekintza desgaituta dago une honetan prozesu anitzeko { -brand-shorter-name }(e)rako

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Utzi erregistratuta egoteari

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = 'fetch' gertaerak entzuten

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = 'fetch' gertaerak ez dira entzuten

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Exekutatzen

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Geldituta

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Erregistratzen

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Esparrua

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Push zerbitzua

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = Zerbitzu Langileak ikuskatzea desgaituta dago une honetan prozesu anitzeko { -brand-shorter-name }(e)rako

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Prozesu nagusia

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Helburu-nabigatzailearen prozesu nagusia

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Multiprozesuko tresna-kutxa

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Helburu-nabigatzailearen prozesu nagusia eta eduki-prozesua

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Itxi mezua

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Errorearen xehetasunak

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Abisuaren xehetasunak

# Label text used for default state of details of message component.
about-debugging-message-details-label = Xehetasunak
