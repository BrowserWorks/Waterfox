# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

### These strings are used inside the about:debugging UI.

# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Debugging - Opsætning

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Debugging - Runtime / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Denne { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
  .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
  .name = Opsætning

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB er aktiveret

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB er deaktiveret

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Forbundet
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Afbrudt

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Ingen enheder blev fundet

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Opret forbindelse

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Opretter forbindelse…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Forbindelse mislykkedes

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Forbindelsen venter stadig på at blive oprettet. Kontrollér eventuelle meddelelser i mål-browseren

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Forbindelsens tidsfrist udløb

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Forbundet

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Venter på browser…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Fjernet

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
  .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
  .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Hjælp til debugging

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
  .alt = Hjælp-ikon

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Genindlæs enheder

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Opsætning

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Indstil hvilken type af forbindelse, du vil bruge til at fjern-debugge din enhed.

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = Brug <a>{ about-debugging-this-firefox-runtime-name }</a> til at debugge udvidelser og service-workers i denne version af { -brand-shorter-name }.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Opret forbindelse til en enhed

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Aktivering af dette vil hente de nødvendige komponenter til USB-debugging af Android og føje dem til { -brand-shorter-name }.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Aktiver USB-enheder

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Deaktiver USB-enheder

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Opdaterer…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Aktiveret
about-debugging-setup-usb-status-disabled = Deaktiveret
about-debugging-setup-usb-status-updating = Opdaterer…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Aktiver udvikler-menuen på din Android-enhed. 

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Aktiver USB-debugging i udvikler-menuen på Android-enheden. 

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Aktiver USB-debugging i Firefox på Android-enheden.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Opret forbindelse til Android-enheden på din computer.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Har du problemer med at oprette forbindelse til USB-enheden? <a>Fejlsøg</a>

# Network section of the Setup page
about-debugging-setup-network =
  .title = Netværksplacering

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Har du problemer med netværksplaceringen? <a>Fejlsøg</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Tilføj

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Ingen netværksplacering er blevet tilføjet endnu.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Vært

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Fjern

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Ugyldig vært "{ $host-value }". Det forventede format er "hostname:portnumber".

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Værten "{ $host-value }" er allerede registreret

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
  .name = Midlertidige udvidelser
# Title of the extensions category.
about-debugging-runtime-extensions =
  .name = Udvidelser
# Title of the tabs category.
about-debugging-runtime-tabs =
  .name = Faneblade
# Title of the service workers category.
about-debugging-runtime-service-workers =
  .name = Service-workers
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
  .name = Delte workers
# Title of the other workers category.
about-debugging-runtime-other-workers =
  .name = Andre workers
# Title of the processes category.
about-debugging-runtime-processes =
  .name = Processer

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Ydelsesprofilering

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Din browser-opsætning er ikke kompatibel med service-workers. <a>Læs mere</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/WebIDE/Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = Den forbundne browser har en gammel version ({ $runtimeVersion }). Den ældste understøttede version er ({ $minVersion }). Denne opsætning understøttes ikke og kan forhindre Udviklerværktøj i at køre korrekt. Opdater den forbundne browser. <a>Fejlsøgning</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Denne version af Firefox kan ikke bruges til at debugge Firefox til Android (68). Vi anbefaler, at du installerer Firefox Nightly til Android for at kunne teste. < a>Læs mere</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/en-US/docs/Tools/WebIDE/Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Den forbundne browser er nyere ({ $runtimeVersion }, buildID { $runtimeID }) end din { -brand-shorter-name } ({ $localVersion }, buildID { $localID }). Denne opsætning understøttes ikke og kan forhindre Udviklerværktøj i at køre korrekt. Opdater Firefox. <a>Fejlsøgning</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Afbryd

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Aktiver forbindelses-prompt

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Deaktiver forbindelses-prompt

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Profilering

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Sammenfold / udvid

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Ingenting endnu.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Inspicer

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Indlæs midlertidig tilføjelse…

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = Der opstod en fejl under installering af den midlertidige tilføjelse.

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Genindlæs

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Fjern

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Vælg manifest.json-fil eller .xpi/.zip-arkiv

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = Denne WebExtension har et midlertidigt ID. <a>Learn more</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
  .label = Manifest-URL

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
  .label = Internt UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
  .label = Placering

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
  .label = Udvidelsens ID

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push
  .disabledTitle = Service-worker-push er i øjeblikket deaktiveret for multiproces { -brand-shorter-name }

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Start
  .disabledTitle = Start af service-workers er i øjeblikket deaktiveret i multiproces { -brand-shorter-name }

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Afregistrer

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
  .label = Fetch
  .value = Lytter efter fetch-events

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
  .label = Fetch
  .value = Lytter ikke efter fetch-events

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Kører

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Stoppet

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Registrerer

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
  .label = Scope

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
  .label = Push-service

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
  .title = Inspektion af service-workers er i øjeblikket deaktiveret for multiproces { -brand-shorter-name }

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
  .title = Fanebladet er ikke helt indlæst og kan ikke inspiceres

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Hoved-proces

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Hovedproces for mål-browser

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Multiproces-værktøj

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Hovedproces og indholdsprocesser for mål-browseren

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
  .alt = Luk besked

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Detaljer om fejl

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Detaljer om advarsel

# Label text used for default state of details of message component.
about-debugging-message-details-label = Detaljer
