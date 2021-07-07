# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Debugowanie — konfiguracja
# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Debugowanie — środowisko/{ $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Ten { -brand-shorter-name }
# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }
# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Konfiguracja
# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = Włączono USB
# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = Wyłączono USB
# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Połączono
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Rozłączono
# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Nie wykryto żadnych urządzeń
# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Połącz
# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Łączenie…
# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Połączenie się nie powiodło
# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Połączenie nadal oczekuje, sprawdź komunikaty w przeglądarce docelowej
# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Upłynął limit czasu połączenia
# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Połączono
# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Oczekiwanie na przeglądarkę…
# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Odłączone
# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }
# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Pomoc debugowania
# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Ikona pomocy
# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Odśwież urządzenia

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Konfiguracja
# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Skonfiguruj metodę połączenia do zdalnego debugowania urządzenia.
# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = Użyj „<a>{ about-debugging-this-firefox-runtime-name }</a>” do debugowania rozszerzeń i wątków usługowych w tej wersji przeglądarki { -brand-shorter-name }.
# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Połącz z urządzeniem
# USB section of the Setup page
about-debugging-setup-usb-title = USB
# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Włączenie spowoduje pobranie i dodanie wymaganych składników debugowania Androida przez USB do przeglądarki { -brand-shorter-name }.
# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Włącz urządzenia USB
# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Wyłącz urządzenia USB
# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Uaktualnianie…
# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Włączono
about-debugging-setup-usb-status-disabled = Wyłączono
about-debugging-setup-usb-status-updating = Uaktualnianie…
# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Włącz menu programisty na urządzeniu z Androidem.
# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Włącz debugowanie przez USB w menu programisty Androida.
# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Włącz debugowanie przez USB w Firefoksie na urządzeniu z Androidem.
# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Podłącz urządzenie z Androidem do komputera.
# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = Problemy z łączeniem przez USB? <a>Rozwiązywanie problemów</a>
# Network section of the Setup page
about-debugging-setup-network =
    .title = Położenie sieciowe
# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Problemy z łączeniem przez położenie sieciowe? <a>Rozwiązywanie problemów</a>
# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Dodaj
# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Nie dodano jeszcze żadnych położeń sieciowych.
# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Host
# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Usuń
# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Nieprawidłowy host „{ $host-value }”. Oczekiwany format to „nazwa-hosta:numer-portu”.
# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Host „{ $host-value }” jest już zarejestrowany

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Rozszerzenia tymczasowe
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Rozszerzenia
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Karty
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Wątki usługowe
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Wątki współdzielone
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Inne wątki
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Procesy
# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Profiluj wydajność
# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Konfiguracja przeglądarki jest niezgodna z wątkami usługowymi. <a>Więcej informacji</a>.
# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = Połączona przeglądarka ma starą wersję ({ $runtimeVersion }). Minimalna obsługiwana wersja to { $minVersion }. Taka konfiguracja jest nieobsługiwana i może spowodować awarię narzędzi. Proszę uaktualnić połączoną przeglądarkę. <a>Rozwiązywanie problemów</a>.
# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Ta wersja Firefoksa nie może debugować Firefoksa na Androida (68). Do testowania zalecamy zainstalowanie na telefonie Firefoksa na Androida w wydaniu Nightly. <a>Więcej informacji</a>
# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Połączona przeglądarka jest nowsza ({ $runtimeVersion }, identyfikator kompilacji { $runtimeID }) niż używana przeglądarka { -brand-shorter-name } ({ $localVersion }, identyfikator kompilacji { $localID }). Taka konfiguracja jest nieobsługiwana i może spowodować awarię narzędzi. Proszę uaktualnić Firefoksa. <a>Rozwiązywanie problemów</a>.
# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })
# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Rozłącz
# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Włącz pytanie o połączenie
# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Wyłącz pytanie o połączenie
# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Profiler
# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Zwiń/rozwiń

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Jeszcze nic nie ma.
# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Zbadaj
# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Tymczasowo wczytaj dodatek…
# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = Wystąpił błąd podczas tymczasowej instalacji dodatku.
# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Wczytaj ponownie
# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Usuń
# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Wybierz plik manifest.json lub archiwum .xpi/.zip
# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = To rozszerzenie WebExtension ma identyfikator tymczasowy. <a>Więcej informacji</a>.
# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = Adres URL manifestu
# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = Wewnętrzny UUID
# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Położenie
# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = Identyfikator rozszerzenia
# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Wyślij push
    .disabledTitle = Wysyłanie push wątków usługowych jest obecnie wyłączone w programie { -brand-shorter-name } z obsługą wielu procesów
# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Uruchom
    .disabledTitle = Uruchamianie wątków usługowych jest obecnie wyłączone w programie { -brand-shorter-name } z obsługą wielu procesów
# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Wyrejestruj
# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Fetch
    .value = Obserwuje zdarzenia Fetch
# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Fetch
    .value = Nie obserwuje zdarzeń Fetch
# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Uruchomiony
# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Zatrzymany
# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Rejestrowanie
# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Zakres
# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Usługa push
# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = Badanie wątków usługowych jest obecnie wyłączone w programie { -brand-shorter-name } z obsługą wielu procesów
# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = Karta nie jest w pełni wczytana i nie można jej zbadać
# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Główny proces
# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Główny proces dla przeglądarki docelowej
# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Narzędzia wieloprocesowe
# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Główny proces i procesy treści dla przeglądarki docelowej
# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Zamknij komunikat
# Label text used for the error details of message component.
about-debugging-message-details-label-error = Informacje o błędzie
# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Informacje o ostrzeżeniu
# Label text used for default state of details of message component.
about-debugging-message-details-label = Informacje
