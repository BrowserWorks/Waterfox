# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Ladění - nastavení

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Ladění - běhové prostředí / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Waterfox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name =
    { -brand-shorter-name.gender ->
        [masculine] Tento { -brand-shorter-name }
        [feminine] Tato { -brand-shorter-name }
        [neuter] Toto { -brand-shorter-name }
       *[other] Tato aplikace { -brand-shorter-name }
    }

# Sidebar heading for selecting the currently running instance of Waterfox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Nastavení

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB povoleno

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB zakázáno

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Připojeno
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Odpojeno

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Nebyla nalezena žádná zařízení

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Připojit

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Připojování…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Připojení se nepodařilo

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Připojování stále probíhá, zkontrolujte zprávu v cílovém prohlížeči

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Čas pro připojení vypršel

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Waterfox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Waterfox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Čekání na prohlížeč…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Odpojeno

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Podpora ladění

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Ikona podpory

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Obnovit seznam zařízení

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Nastavení

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Nastavte si způsob připojení pro vzdálení ladění vašeho zařízení.

# Explanatory text in the Setup page about what the 'This Waterfox' page is for
about-debugging-setup-this-firefox2 = Použijte <a>{ about-debugging-this-firefox-runtime-name }</a> pro ladění rozšíření a service workerů v této verzi { -brand-shorter-name(case: "loc") }

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Připojit zařízení

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled =
    Povolení této možnosti stáhne do { -brand-shorter-name.gender ->
        [masculine] { -brand-shorter-name(case: "gen") }
        [feminine] { -brand-shorter-name(case: "gen") }
        [neuter] { -brand-shorter-name(case: "gen") }
       *[other] aplikace { -brand-shorter-name }
    } komponenty potřebné pro ladění v Androidu pomocí USB.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Povolit USB zařízení

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Zakázat USB zařízení

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Probíhá aktualizace…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Povoleno
about-debugging-setup-usb-status-disabled = Zakázáno
about-debugging-setup-usb-status-updating = Probíhá aktualizace…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Zapněte nabídku vývojáře na vašem zařízení s Androidem.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Povolte ladění přes USB v nabídce pro vývojáře Androidu.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Povolte ladění přes USB ve Waterfoxu pro Android.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Připojte zařízení s Androidem k vašemu počítači.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Problémy s připojením k zařízení přes USB? <a>Poradce při potížích</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Síťové umístění

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Problémy s připojením přes síť? <a>Poradce při potížích</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Přidat

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Zatím nebylo přidáno žádné umístění v síti.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Server

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Odebrat

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Neplatný hostitel „{ $host-value }“. Očekávaný formát je „hostname:port“.

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Server „{ $host-value }“ je již registrován

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Waterfox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Dočasná rozšíření
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Rozšíření
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Panely
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Service Workers
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Shared Workers
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Ostatní Workers
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Procesy

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Profilování výkonu

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Konfigurace vašeho prohlížeče není kompatibilní se Service Workers. <a>Zjistit více</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Waterfox instance (same format)
about-debugging-browser-version-too-old = Připojený prohlížeč má starou verzi ({ $runtimeVersion }). Minimální podporovaná verze je ({ $minVersion }). Toto je nepodporovaná konfigurace a může způsobit nefunkčnost nástrojů pro vývojáře. Prosím aktualizujte připojený prohlížeč. <a> Poradce při potížích</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Waterfox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Tato verze Waterfoxu nemůže ladit Waterfox pro Android (68). Pro testování doporučujeme do telefonu nainstalovat Waterfox Nightly pro Android. <a>Více informací</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Waterfox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Připojený prohlížeč je novější ({ $runtimeVersion }, buildID { $runtimeID }) než váš { -brand-shorter-name } ({ $localVersion }, buildID { $localID }). Taková situace není podporována a může způsobit selhání nástrojů pro vývojáře. Aktualizujte prosím svůj Waterfox. <a>Řešení potíží</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Waterfox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Odpojit

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Povolit výzvu k připojení

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Zakázat výzvu k připojení

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Profiler

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Sbalit / rozbalit

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Ještě nic.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Prozkoumat

# Text of a button displayed in the "This Waterfox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Načíst dočasný doplněk…

# Text displayed when trying to install a temporary extension in the "This Waterfox" page.
about-debugging-tmp-extension-install-error = Při instalaci dočasného doplňku došlo k chybě.

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Znovu načíst

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Odebrat

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Vyberte soubor manifest.json nebo archiv .xpi/.zip

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = Toto rozšíření typu WebExtension má dočasné ID. <a>Zjistit více</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = URL manifestu

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = Interní UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Umístění

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = ID rozšíření

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push
    .disabledTitle =
        Push od service workeru je pro { -brand-shorter-name.gender ->
            [masculine] víceprocesový { -brand-shorter-name(case: "acc") }
            [feminine] víceprocesovou { -brand-shorter-name(case: "acc") }
            [neuter] víceprocesové { -brand-shorter-name(case: "acc") }
           *[other] víceprocesovou aplikaci { -brand-shorter-name }
        } zakázán

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Spustit
    .disabledTitle =
        Spuštění service workeru je pro { -brand-shorter-name.gender ->
            [masculine] víceprocesový { -brand-shorter-name(case: "acc") }
            [feminine] víceprocesovou { -brand-shorter-name(case: "acc") }
            [neuter] víceprocesové { -brand-shorter-name(case: "acc") }
           *[other] víceprocesovou aplikaci { -brand-shorter-name }
        } zakázáno

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Zrušit registraci

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = Sleduje události pro fetch

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = Nesleduje události pro fetch

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Spuštěno

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Zastaveno

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Registruje se

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Rozsah

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Služba Push

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title =
        Zkoumání service workerů je pro { -brand-shorter-name.gender ->
            [masculine] víceprocesový { -brand-shorter-name(case: "acc") }
            [feminine] víceprocesovou { -brand-shorter-name(case: "acc") }
            [neuter] víceprocesové { -brand-shorter-name(case: "acc") }
           *[other] víceprocesovou aplikaci { -brand-shorter-name }
        } zakázáno

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = Panel není plně načtený a nelze ho v průzkumníku otevřít

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Hlavní proces

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Hlavní proces pro cílový prohlížeč

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Sada nástrojů pro práci s více procesy

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Hlavní procesy a procesy pro obsah v cílovém prohlížeči

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Zavřít zprávu

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Podrobnosti o chybě

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Podrobnosti upozornění

# Label text used for default state of details of message component.
about-debugging-message-details-label = Podrobnosti
