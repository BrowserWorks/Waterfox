# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings


# Sidebar strings

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Configuració

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB activat

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB desactivat

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Connectat
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Desconnectat

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = No s'ha descobert cap dispositiu

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Connecta

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = S'està connectant…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = La connexió ha fallat

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = S'ha esgotat el temps d'espera de la connexió

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Connectat

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = S'està esperant el navegador…

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
about-debugging-sidebar-support = Assistència per a la depuració

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Icona d'ajuda

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Actualitza els dispositius

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Configuració

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Connecteu un dispositiu

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Si activeu esta opció, es baixaran i s'afegiran els components necessaris de depuració USB de l'Android en el { -brand-shorter-name }.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Activa els dispositius USB

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Desactiva els dispositius USB

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = S'està actualitzant…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Activat
about-debugging-setup-usb-status-disabled = Desactivat
about-debugging-setup-usb-status-updating = S'està actualitzant…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Activeu el menú «Opcions per a desenvolupadors» en el dispositiu Android.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Activeu la «Depuració USB» en el menú «Opcions per a desenvolupadors» de l'Android.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Activeu la depuració USB en el Firefox en el dispositiu Android.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Connecteu el dispositiu Android a l'ordinador.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Teniu problemes per connectar-vos al dispositiu USB? <a>Resolució de problemes</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Ubicació de xarxa

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Teniu problemes per connectar-vos mitjançant la ubicació de xarxa? <a>Resolució de problemes</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Afig

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Encara no s'ha afegit cap ubicació de xarxa.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Amfitrió

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Elimina

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Extensions temporals
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Extensions
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Pestanyes
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Processos de treball de servei
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Processos de treball compartits
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Altres processos de treball
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Processos

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Analitza el rendiment

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = La configuració del navegador no és compatible amb els processos de treball de servei. <a>Més informació</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Desconnecta

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Analitzador de rendiment

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Redueix / amplia

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = De moment, cap.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Inspecciona

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Carrega un complement temporal…

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Torna a carregar

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Elimina

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = URL de manifest

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = UUID intern

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Ubicació

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = ID d'extensió

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Suprimeix el registre

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = S'està executant

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Parat

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = S'està registrant

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Àmbit

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Servei de transferència Push

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Procés principal

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Tanca el missatge

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Detalls de l'error

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Detalls de l'avís

# Label text used for default state of details of message component.
about-debugging-message-details-label = Detalls
