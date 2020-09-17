# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Depurar- Instalación
# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Depurar - Entorno de execución / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Este { -brand-shorter-name }
# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }
# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Instalación
# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB activau
# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB desactivau
# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Connectau
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Desconnectau
# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Garra dispositivo descubierto
# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Connectar
# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Se ye connectando…
# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Fallo de connexión
# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Connexión encara pendient, compreba los mensaches en o navegador obchetivo
# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = La connexión ha caducau
# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Connectau
# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Aguardando a lo navegador…
# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Desconnectau
# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } { $deviceName }
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }
# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Soporte de depuración
# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Icono d'aduya
# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Refrescar los dispositivos

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Instalación
# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Configurar lo metodo de connexión con que quiers depurar remotament lo tuyo dispositivo.
# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = Fer servir <a>{ about-debugging-this-firefox-runtime-name }</a> pa depurar las extensions y los servicios d'esta version de { -brand-shorter-name }.
# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Connectar un dispositivo
# USB section of the Setup page
about-debugging-setup-usb-title = USB
# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Activando esto se descargara y anyadira los componentes de depuración USB d'Android a { -brand-shorter-name }.
# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Activar dispositivos USB
# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Desactivar dispositivos USB
# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Esviellando...
# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Activau
about-debugging-setup-usb-status-disabled = Desactivau
about-debugging-setup-usb-status-updating = Esviellando...
# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Activando lo menu de desenvolvedor en o tuyo dispositivo Android.
# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Activando la depuración USB en el menu de desenvolvedor d'Android.
# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Activar la depuración USB en Firefox en el dispositivo Android.
# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Connectar lo dispositiu Android a lo tuyo ordinador.
# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Problemas connectando a lo dispositivo USB?<a>Guía de problemas</a>
# Network section of the Setup page
about-debugging-setup-network =
    .title = Plazamiento de ret
# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Problemas connectando via plazamiento de ret? <a>Guía de problemas</a>
# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Anyadir
# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = No s'ha anyadiu encara garra plazamiento de ret
# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Servidor
# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Eliminar
# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Servidor invalido "{ $host-value }". Lo formato esperau ye "hostname:portnumber".
# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Lo servidor "{ $host-value }" ya ye rechistrau

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
    .name = Pestanyas
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Procesos de treballo de servicio
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Procesos de treballo compartius
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Atros procesos de treballo
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Procesos
# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Rendimiento de perfil

# Debug Targets strings

