# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Desbugatge - Configuracion

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Desbugatge - Temps passat / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = aqueste { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Configuracion

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB activat

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB desactivat

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Connectat
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Desconectat

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Cap de periferic pas detectat

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Connectar

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Connexion…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Fracàs de la connexion

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = La connexion es encara en espèra, verificatz los messatges sul navegador cibla

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = La connexion a expirat

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Connectat

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = En espèra del navegador…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Desconnectat

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Assisténcia al desbugatge

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Icòna d’ajuda

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Actualizar los periferics

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Configuracion

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Configuratz lo metòde de connexion que volètz emplegar per desbugar a distància vòstre periferic.

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = Utilizatz <a>{ about-debugging-this-firefox-runtime-name }</a> per desbugar las extensions e los service workers sus aquesta version de { -brand-shorter-name }.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Connectar un periferic

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = L’activacion lançarà lo telecargament e l’apondon dels compausants pel besbugatge USB Android per { -brand-shorter-name }.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Activar los periferics USB

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Desactivar los periferics USB

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Actualizacion…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Activat
about-debugging-setup-usb-status-disabled = Desactivat
about-debugging-setup-usb-status-updating = Actualizacion…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Activar lo menú Desvolopaire sus vòstre periferic Android.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Activatz lo desbugatge USB dins lo menú Desvolopaire Android.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Activatz lo desbugatge USB dins Firefox sul periferic Android.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Connectatz lo periferic Android a l’ordenador.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Avètz de problèma per vos connectar al periferic USB ? <a>Resolucion de problèmas</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Emplaçament ret

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Avètz de problèma per vos connectar via l’emplaçament ret ? <a>Resolucion de problèmas</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Apondre

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Cap d’emplaçament ret es pas estat apondut pel moment.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Òste

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Levar

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Òste invalid « { $host-value } » Lo format esperat es « hostname:portnumber ».

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = L’òste « { $host-value } »es ja enregistrat

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Extensions temporàrias
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Extensions
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Onglets
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Service Workers
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Workers partejats
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Autres Workers
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Processús

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Crear un perfil de las performanças

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = La configuracion del navegador es pas compatibla amb los Service Workers. <a>Ne saber mai</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = La version de l’environament connectat es vièlha ({ $runtimeVersion }). La version minimala presa en carga es ({ $minVersion }). Aquesta configuracion es pas presa en carga e pòt menar a un arrèst de DevTools. Mercés de metre a jorn l’environament connectat.<a>Diagnostic de connexion</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Aquesta version de Firefox pòt pas desbugar Firefox per Android (68). Recomandam d’installar Firefox per Android en version Nightly sus vòstre telefòn d’ensag. <a>Mai de detalhs</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Lo navegador connectat es mai recent ({ $runtimeVersion }, buildID { $runtimeID }) que lo vòstre { -brand-shorter-name } ({ $localVersion }, buildID { $localID }). Aquò es una configuracion pas compatibla e que pòt far fracassar las aisinas de desvolopament. Mercés de metre a nivèl Firefox. <a>Diagnostic de connexion</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Se desconectar

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Activar la demanda de connexion

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Desactivar la demanda de connexion

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Perfilaire

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Reduire / espandir

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Pas res pel moment

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Examinar

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Cargar un modul complementari temporari…

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = Una error s’es producha pendent l’installacion del modul complementari temporari.

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Tornar cargar

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Suprimir

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Seleccionatz un fichièr manifest.json o un archiu .xpi/.zip

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = Aquesta WebExtension a un ID temporari. <a>Ne saber mai</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = URL del manifest

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = UUID intèrn

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Emplaçament

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = ID d’extension

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push
    .disabledTitle = Lo Service Worker Push es actualament desactivat pel mòde multiprocessús de { -brand-shorter-name }

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Start
    .disabledTitle = Lo Service Worker Start es actualament desactivat pel mòde multiprocessús de { -brand-shorter-name }

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Desmarcar

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = Escota dels eveniments Fetch

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = Escota pas los eveniments Fetch

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Execucion

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Arrestat

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Inscripcion

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Encastre

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Servici Push

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = L’inspector Service Worker es actualament desactivat pel mòde multiprocessús de { -brand-shorter-name }

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = L’onglet es pas complètament cargat e se pòt pas examinar

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Processús principal

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Processús màger pel navegador cibla

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Bóstia d’aisina multiprocessús

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Processús màger e processús de contengut pel navegador cibla

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Tampar lo messatge

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Detalhs de l’error

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Detalhs de l’avís

# Label text used for default state of details of message component.
about-debugging-message-details-label = Detalhs
