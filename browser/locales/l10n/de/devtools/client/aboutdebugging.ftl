# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Debugging - Konfiguration

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Debugging - Umgebung / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Waterfox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Dieser { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Waterfox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Konfiguration

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB aktiviert

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB deaktiviert

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Verbunden
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Getrennt

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Keine Geräte gefunden

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Verbinden

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Verbindung wird hergestellt…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Verbindung fehlgeschlagen

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Verbindung nicht bestätigt, überprüfen Sie den Zielbrowser auf Mitteilungen.

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Zeitüberschreitung beim Verbindungsaufbau

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Waterfox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Waterfox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Warten auf Browser…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Vom Computer getrennt

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Debugging-Hilfe

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Hilfe-Symbol

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Geräteliste aktualisieren

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Konfiguration

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Wählen Sie die Verbindungsmethode für das externe Debugging des Geräts.

# Explanatory text in the Setup page about what the 'This Waterfox' page is for
about-debugging-setup-this-firefox2 = <a>{ about-debugging-this-firefox-runtime-name }</a> verwenden, um Erweiterungen und Service-Worker mit dieser Version von { -brand-shorter-name } zu untersuchen.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Gerät verbinden

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Das Aktivieren dieser Einstellung wird die benötigten Komponenten für das Debuggen von Android über USB in { -brand-shorter-name } herunterladen und installieren.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = USB-Geräte aktivieren

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = USB-Geräte deaktivieren

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Wird aktualisiert…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Aktiviert
about-debugging-setup-usb-status-disabled = Deaktiviert
about-debugging-setup-usb-status-updating = Wird aktualisiert…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Das "Entwicklermenü" in Android aktivieren.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = USB-Debugging in Androids Menü "Entwicklermenü" aktivieren.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = USB-Debugging in Waterfox auf dem Android-Gerät aktivieren.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Das Android-Gerät mit dem Computer verbinden.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Probleme mit der Verbindung mit dem USB-Gerät? <a>Anleitung zur Fehlerbehebung</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Netzwerk-Adresse

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Probleme mit der Verbindung mit der Netzwerk-Adresse? <a>Anleitung zur Fehlerbehebung</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Hinzufügen

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Es wurden noch keine Netzwerk-Adressen hinzugefügt.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Host

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Entfernen

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Ungültiger Host "{ $host-value }". Das erwartete Format ist "hostname:portnummer".

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Der Host "{ $host-value }" ist bereits registriert.

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Waterfox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Temporäre Erweiterungen
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Erweiterungen
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Tabs
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Service-Worker
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Shared-Worker
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Andere Worker
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Prozesse

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Leistung analysieren

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Ihre Browser-Einstellungen sind inkompatibel mit Service-Workern. <a>Weitere Informationen</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Waterfox instance (same format)
about-debugging-browser-version-too-old = Der verbundene Browser verwendet eine alte Version ({ $runtimeVersion }). Die niedrigste unterstützte Version ist ({ $minVersion }). Daher handelt es sich um eine nicht unterstützte Kombination und die Entwicklerwerkzeuge funktionieren eventuell nicht. Bitte aktualisieren Sie den verbundenen Browser. <a>Informationen zur Fehlerbehebung</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Waterfox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Diese Waterfox-Version kann Waterfox für Android (68) nicht debuggen. Es wird empfohlen, Waterfox für Android Nightly zum Testen auf dem Telefon zu installieren. <a>Weitere Informationen</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Waterfox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Der verbundene Browser ist aktueller ({ $runtimeVersion }, BuildID { $runtimeID }) als Ihr { -brand-shorter-name } ({ $localVersion }, BuildID { $localID }). Das ist eine nicht unterstützte Kombination und die Entwicklerwerkzeuge funktionieren eventuell nicht. Bitte aktualisieren Sie Waterfox. <a>Informationen zur Fehlerbehebung</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Waterfox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Trennen

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Verbindungsbestätigung aktivieren

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Verbindungsbestätigung deaktivieren

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Laufzeitanalyse

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Einklappen / erweitern

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Noch nichts

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Untersuchen

# Text of a button displayed in the "This Waterfox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Temporäres Add-on laden…

# Text displayed when trying to install a temporary extension in the "This Waterfox" page.
about-debugging-tmp-extension-install-error = Während der temporären Installation des Add-ons trat ein Fehler auf.

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Neu laden

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Entfernen

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = manifest.json-Datei oder .xpi/.zip-Archiv auswählen

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = Diese WebExtension hat eine temporäre ID. <a>Weitere Informationen</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = Manifest-Adresse

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = Interne UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Speicherort

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = Erweiterungs-ID

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push
    .disabledTitle = Push für Service-Worker ist derzeit deaktiviert, falls { -brand-shorter-name } mit mehr als einem Prozess ausgeführt wird.

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Starten
    .disabledTitle = Das Starten von Service-Workern ist derzeit deaktiviert, falls { -brand-shorter-name } mit mehr als einem Prozess ausgeführt wird.

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Abmelden

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = Wartet auf Fetch-Ereignisse

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = Wartet nicht auf Fetch-Ereignisse

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Wird ausgeführt

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Angehalten

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Wird registriert

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Geltungsbereich

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Push-Dienst

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = Das Untersuchen von Service-Workern ist derzeit deaktiviert, falls { -brand-shorter-name } mit mehr als einem Prozess ausgeführt wird.

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = Tab ist nicht vollständig geladen und kann nicht untersucht werden

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Hauptprozess

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Hauptprozess des Zielbrowsers

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Werkzeuge für mehrere Prozesse

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Hauptprozess und Inhaltsprozesse des Zielbrowsers

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Nachricht schließen

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Fehlerdetails

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Warnungsdetails

# Label text used for default state of details of message component.
about-debugging-message-details-label = Details
