# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Жөндеу - Баптау

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Жөндеу - Орындалу ортасы / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Бұл { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Баптау

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB іске қосылған

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB сөндірілген

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Байланысқан
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Ажыратылған

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Құрылғылар табылмады

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Байланысу

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Байланысу…

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Байланысу сәтсіз аяқталды

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Байланыс әлі жасалуда, мақсат браузерде хабарламаларды тексеріңіз

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Байланысты орнату уақыты біткен

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Байланысқан

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Браузерді күту…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Ажыратылған

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Жөндеуді қолдау

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Көмек таңбашасы

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Құрылғыларды жаңарту

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Баптау

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Құрылғыңызды қашықтан жөндеуге қолданатын байланыс тәсілін баптаңыз.

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = { -brand-shorter-name } бұл нұсқасында кеңейтулер және қызметтік үрдістерді жөндеу үшін <a>{ about-debugging-this-firefox-runtime-name }</a> қолданыңыз.

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Құрылғыны байланыстыру

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Осыны іске қосу керек етілген Android USB жөндеу құраушыларын жүктеп алады және { -brand-shorter-name } ішіне қосады.

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = USB құрылғыларын іске қосу

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = USB құрылғыларын сөндіру

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Жаңарту…

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Іске қосылған
about-debugging-setup-usb-status-disabled = Сөндірілген
about-debugging-setup-usb-status-updating = Жаңартылу…

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Android құрылғыңызда Әзірлеуші мәзірін іске қосыңыз.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Android Әзірлеуші мәзірінде USB жөндеуін іске қосыңыз.

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Android құрылғыңыздағы Firefox ішінде USB жөндеуін іске қосыңыз.

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Android құрылғысын компьютерге қосыңыз.

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = USB құрылғысына байланысу мәселелері бар ма? <a>Шешімін табу</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Желілік орналасу

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Желілік орналасу арқылы байланысу мәселелері бар ма? <a>Шешімін табу</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Қосу

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Желілік орналасулар әлі қосылмаған.

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Хост

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Өшіру

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = "{ $host-value }" хост аты жарамсыз. Күтілген пішімі "hostname:portnumber".

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = "{ $host-value }" хост аты тіркелген болып тұр

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Уақытша кеңейтулер
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Кеңейтулер
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Беттер
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Қызметтік жұмыс үрдістері
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Ортақ жұмыс үрдістері
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Басқа жұмыс үрдістері
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Процестер

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Профиль өнімділігі

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Сіздің браузеріңіздің баптаулары Service Workers қолдамайды. <a>Көбірек білу</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = Байланысқан браузер нұсқасы ескілеу ({ $runtimeVersion }). Қолдауы бар минималды нұсқасы ({ $minVersion }). Бұл баптауға қолдау жоқ және оның салдарынан Әзірлеуші құралдары құлауы мүмкін. Байланысқан браузерді жаңартыңыз. <a>Мәселелерді шешу</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Firefox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Firefox-тың бұл нұсқасы Android үшін Firefox-ті (68) жөндей алмайды. Сынау үшін телефонға Android үшін Firefox Nightly орнатуды ұсынамыз. <a>Көбірек білу</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Байланысқан браузер нұсқасы ({ $runtimeVersion }, buildID { $runtimeID }) сіздің браузер нұсқасынан { -brand-shorter-name } ({ $localVersion }, buildID { $localID }) жаңалау. Бұл баптауға қолдау жоқ және оның салдарынан Әзірлеуші құралдары құлауы мүмкін. Firefox-ты жаңартыңыз. <a>Мәселелерді шешу</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Байланысты үзу

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Қосылу туралы сұрауды іске қосу

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Қосылу туралы сұрауды сөндіру

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Профильдеуші

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Бүктеу / жазық қылу

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Әлі ешнәрсе жоқ.

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Бақылау

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Уақытша қосымшаны жүктеу…

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = Уақытша кеңейтуді орнату кезінде қате кетті.

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Қайта жүктеу

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Өшіру

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Manifest.json немесе .xpi/.zip архивін таңдаңыз

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = Бұл WebExtension-нің уақытша ID бар. <a>Көбірек білу</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = Манифест URL

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = Ішкі UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Орналасу

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = Кеңейту ID-і

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Push
    .disabledTitle = Service Worker push қазір көппроцестік { -brand-shorter-name } үшін сөндірілген

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Іске қосу
    .disabledTitle = Service Worker іске қосу қазір көппроцестік { -brand-shorter-name } үшін сөндірілген

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Тіркеуден шығару

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Алу
    .value = Алу оқиғаларын күтуде

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Алу
    .value = Алу қызметтерін күтуде емес

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Орындалуда

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Тоқтатылған

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Тіркелуде

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Аумағы

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Push қызметі

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = Service Worker бақылау қазір көппроцестік { -brand-shorter-name } үшін сөндірілген

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = Бет толығымен жүктелмеген, оны бақылау мүмкін емес

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Басты процесс

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Мақсат браузеріне арналған басты процесс

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Көппроцестік саймандар жинағы

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Мақсат браузері үшін басты процесс және мазмұн процестері

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Хабарламаны жабу

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Қате ақпараты

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Ескерту ақпараты

# Label text used for default state of details of message component.
about-debugging-message-details-label = Ақпараты
