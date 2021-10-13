# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Hibakeresés – Beállítás

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Hibakeresés – Futtatókörnyezet / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Waterfox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Ez a { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Waterfox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Beállítások

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB engedélyezve

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB letiltva

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Kapcsolódva
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Bontva

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Nincs felfedezett eszköz

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Kapcsolódás

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Kapcsolódás…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Kapcsolódás sikertelen

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = A kapcsolódás még függőben van, ellenőrizze a célböngésző üzeneteit

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = A kapcsolat időtúllépés miatt megszakadt.

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Waterfox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Waterfox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Várakozás a böngészőre…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Leválasztva

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Hibakeresési támogatás

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Súgó ikon

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Eszközök frissítése

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Beállítások

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Állítsa be a kapcsolódási módot, amellyel távolról akar hibát keresni a készüléken.

# Explanatory text in the Setup page about what the 'This Waterfox' page is for
about-debugging-setup-this-firefox2 = Használja a <a>{ about-debugging-this-firefox-runtime-name }</a> lehetőséget a kiegészítők és service workerek hibakeresésére a { -brand-shorter-name } ezen verzióján.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Eszköz csatlakoztatása

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Ennek engedélyezése letölti és hozzáadja a szükséges Android USB hibakeresési összetevőket a { -brand-shorter-name }hoz.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = USB-eszközök engedélyezése

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = USB-eszközök letiltása

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Frissítés…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Engedélyezve
about-debugging-setup-usb-status-disabled = Tiltva
about-debugging-setup-usb-status-updating = Frissítés…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Engedélyezze a fejlesztői menüt az androidos eszközén.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Engedélyezze az USB-s hibakeresést az androidos fejlesztői menüben.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Engedélyezze az USB-s hibakeresést a Waterfoxban az androidos eszközén.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Csatlakoztassa az androidos eszközt a számítógépéhez.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Problémája van az USB-s eszköz csatlakoztatásakor? <a>Hibaelhárítás</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Hálózat helye

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Problémája van a hálózati helyhez csatlakozáskor? <a>Hibaelhárítás</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Hozzáadás

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Még nincsenek hálózati helyek hozzáadva.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Gép

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Eltávolítás

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Érvénytelen gazda: „{ $host-value }”. A várt formátum: „gépnév:portszám”.

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = A „{ $host-value }” gazdagép már regisztrálva van

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Waterfox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Ideiglenes kiegészítők
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Kiegészítők
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Lapok
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Service Workerek
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Megosztott workerek
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Egyéb workerek
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Folyamatok

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Profil teljesítménye

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = A böngésző beállításai nem kompatibilisek a Service Workerekkel. <a>További információk</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Waterfox instance (same format)
about-debugging-browser-version-too-old = A csatlakoztatott böngésző régi verziójú ({ $runtimeVersion }). A minimális támogatott verzió: ({ $minVersion }). Ez egy nem támogatott összeállítás és a fejlesztői eszközök hibáját okozhatja. Frissítse a csatlakoztatott böngészőt. <a>Hibaelhárítás</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Waterfox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = A Waterfox ezen verziója nem tud hibát keresni a Waterfox for Androidban (68). Javasoljuk, hogy a teszteléshez telepítse a Waterfox for Android Nightlyt a telefonjára. <a>További részletek</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Waterfox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = A csatlakoztatott böngésző frissebb ({ $runtimeVersion }, összeállítási azonosító: { $runtimeID }) mint az Ön { -brand-shorter-name }a ({ $localVersion }, összeállítási azonosító: { $localID }). Ez egy nem támogatott összeállítás és a fejlesztői eszközök hibáját okozhatja. Frissítse a csatlakoztatott böngészőt. Frissítse a Waterfoxot. <a>Hibaelhárítás</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Waterfox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Kapcsolat bontása

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Kapcsolódási kérdés engedélyezése

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Kapcsolódási kérdés letiltása

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Profilkészítő

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Összecsukás / kinyitás

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Még nincs.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Vizsgálat

# Text of a button displayed in the "This Waterfox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Ideiglenes kiegészítő betöltése…

# Text displayed when trying to install a temporary extension in the "This Waterfox" page.
about-debugging-tmp-extension-install-error = Hiba történt az ideiglenes kiegészítő telepítésekor.

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Újratöltés

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Eltávolítás

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Válassza ki a manifest.json fájlt vagy egy .xpi/.zip archívumot

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = Ez a WebExtension ideiglenes azonosítóval rendelkezik. <a>További információ</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = Jegyzékfájl URL

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = Belső UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Hely

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = Kiegészítőazonosító

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push üzenetek
    .disabledTitle = A Service Worker push üzenetek jelenleg le vannak tiltva a többfolyamatos { -brand-shorter-name }ban

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Kezdés
    .disabledTitle = A Service Worker indítása jelenleg le van tiltva a többfolyamatos { -brand-shorter-name }ban

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Regisztráció megszüntetése

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = Fetch események figyelése

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = Fetch események figyelése

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Fut

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Leállítva

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Regisztráció

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Hatáskör

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Küldési szolgáltatás

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = A Service Worker ellenőrzés jelenleg le van tiltva a többfolyamatos { -brand-shorter-name }ban.

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = A lap nincs teljesen betöltve, és nem vizsgálható

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Fő folyamat

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = A célböngésző fő folyamata

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Többfolyamatos eszköztár

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Fő folyamat és tartalomfolyamatok a cél böngészőhöz

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Üzenet bezárása

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Hiba részletei

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Figyelmeztetés részletei

# Label text used for default state of details of message component.
about-debugging-message-details-label = Részletek
