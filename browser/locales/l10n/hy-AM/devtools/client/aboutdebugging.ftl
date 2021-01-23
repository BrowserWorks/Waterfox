# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = Վրիպազերծում - Տեղակայում

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = Վրիպազերծում - աշխատաժամանակ / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Waterfox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = Այս { -brand-shorter-name }-ը

# Sidebar heading for selecting the currently running instance of Waterfox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = Տեղակայում

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB-ն միացված է

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB-ն անջատված է

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = Կապակցված
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = Կապախզված

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = Սարքեր չեն հայտնաբերվել

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = Կապակցել

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = Կապակցում․․․

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = Կապակցումը ձախողվեց

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = Կապակցումը դեռ սպասվում է, զննարկիչում ստուգեք հաղորդագրությունները։

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = Կապակցումը ժամասպառվեց

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = Կապակցված

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Waterfox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Waterfox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = Սպասում է զննարկիչին...

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = Ապախրված

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = Վրիպազերծման աջակցություն

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = Օգնության պատկերակ

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = Թարմացնել սարքերը

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = Տեղակայում

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = Կարգավորեք կապի եղանակը, որի միջոցով ցանկանում եք հեռակա կարգաբերել ձեր սարքը։

# Explanatory text in the Setup page about what the 'This Waterfox' page is for
about-debugging-setup-this-firefox2 = Օգտագործել <a>{ about-debugging-this-firefox-runtime-name }</a> վրիպազերծելու ընդլայնումները և ծառայության աշխատողներին { -brand-shorter-name }-ի այս տարբերակի համար։

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = Միացրեք սարք

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = Թույլատրելով սա կներբեռնի և կավելացնի պահանջված Android USB բաղադրիչների վրիպազերծում { -brand-shorter-name }։

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = Միացնել USB սարքերը

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = Անջատել USB սարքերը

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = Թարմացվում է․․․

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = Միացված
about-debugging-setup-usb-status-disabled = Անջատված
about-debugging-setup-usb-status-updating = Թարմացվում է ...

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = Միացնել Մշակողի ցանկը ձեր Android սարքում։

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = Միացնել USB վրիպազերծումը Android-ի Մշակողի ցանկում։

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = Միացնել USB վրիպազերծումը Android սարքի Waterfox-ում։

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Միացրեք Android սարքը ձեր համակարգչին:

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = USB սարքին միացնելիս խնդիրներ են առաջացել։ <a>Խափանաշտկել</a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = Ցանցի գտնվելու վայրը

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = Ցանցի գտնվելու վայրի հետ կապող խնդիրներ։<a>անսարքություն</a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = Ավելացնել

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = Ցանցի վայրեր դեռ չեն ավելացվել։

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = Հանգույց

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = Հեռացնել

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = Անվավեր խնամորդ “{ $host-value }”: Սպասվող ձևաչափը “hostname:portnumber”֊ն է։

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = Խնամորդ՝ “{ $host-value }” ֊ն արդեն գրանցված է

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Waterfox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = Ժամանակավոր ընդլայնումներ
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = Ընդլայնումներ
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = Ներդիրներ
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = Ծառայության աշխատողներ
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = Համօգտագործվող աշխատողներ
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = Այլ Աշխատողներ
# Title of the processes category.
about-debugging-runtime-processes =
    .name = Գործընթացներ

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = Հատկագրի կատարումը

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = Ձեր զննարկչի կազմաձևը համատեղելի չէ աշխատակիցների ծառայության հետ։ <a>Իմանալ ավելին</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Waterfox instance (same format)
about-debugging-browser-version-too-old = Միացված զննարկիչը հին տարբերակ ունի  ({ $runtimeVersion })։ Նվազագույն աջակցվող տարբերակը ({ $minVersion }) է։ Սա չաջակցված կայանք է և կարող է DevTools֊ի ձախողման պատճառ դառնալ։ Խնդրում ենք թարմացնել միացված զննարկիչը։ <a>Խնդիրների լուծում</a>

# Dedicated message for a backward compatibility issue that occurs when connecting:
# from Fx 70+ to the old Waterfox for Android (aka Fennec) which uses Fx 68.
about-debugging-browser-version-too-old-fennec = Waterfox-ի այս տարբերակը չի կարող վրիպազերծել Waterfox-ը Android-ի համար (68): Թեստավորման համար խորհուրդ ենք տալիս տեղադրել ձեր հեռախոսում Waterfox- ը Android-ի համար Nightly-ին: <a> Լրացուցիչ մանրամասներ</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Waterfox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = Միացված զննարկիչը ավելի նոր է ({ $runtimeVersion }, buildID { $runtimeID }) քան ձեր { -brand-shorter-name } ({ $localVersion }, buildID { $localID })։ Սա չաջակցված կարգավորում է և կարող է հանգեցնել DevTools-ին չստացվել։ Խնդրում ենք թարմացրել Waterfox-ը։ <a>Անսարքությունների կարգավորում</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = Անջատել

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = Միացնել հուշման միացումը

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = Անջատել հուշման միացումը

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = Հատկագրիչ

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = Կոծկել / Ընդարձակել

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = Դեռ ոչինչ։

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = Ստուգել

# Text of a button displayed in the "This Waterfox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = Բեռնել ժամանակավոր հավելում…

# Text displayed when trying to install a temporary extension in the "This Waterfox" page.
about-debugging-tmp-extension-install-error = Ժամանակավոր հավելման տեղակայման ժամանակ սխալ տեղի ունեցավ:

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = Վերբեռնել

# Text of a button displayed for a temporary extension loaded in the "This Waterfox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = Հեռացնել

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Ընտրե՛ք manifest.json նիշը կամ .xpi/.zip արխիվը

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = Այս Վեբ ընդլայնումը ունի ժամանակավոր նույնացուցիչ։ <a>Իմանալ ավելին</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = Մանիֆեստի URL֊ն

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = Ներքին UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = Տեղադրություն

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = Ընդլայնման նույնացուցիչ

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = Սեղմել
    .disabledTitle = Սպասարկման աշխատողի սեղմումը ներկայումս բազմամշակման համար անջատված է{ -brand-shorter-name }

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = Մեկնարկ
    .disabledTitle = Սպասարկման աշխատողի մեկնարկը ներկայումս բազմամշակման համար անջատված է { -brand-shorter-name }

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = Ապագրանցել

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = Դուրսբերում
    .value = Դուրսբերման իրադարձությունների լսում

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = Դուրսբերում
    .value = Դուրսբերման իրադարձությունների չլսում

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = Գործուն

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = Կանգնեցված

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = Գրանցում

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = Շրջանակ

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = Սեղմման ծառայություն

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = Սպասարկման աշխատողի ստուգումը ներկայումս բազմամշակման համար անջատված է { -brand-shorter-name }

# Displayed as title of the inspect button for zombie tabs (e.g. tabs loaded via a session restore).
about-debugging-zombie-tab-inspect-action-disabled =
    .title = Ներդիրը ամբողջությամբ բեռնված չէ և չի կարող ստուգվել

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = Հիմնական գործընթաց

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = Հիմնական գործընթաց թիրախային զննարկչի համար։

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = Բազմամշակման գործիքատուփ

# Description for the Multiprocess Toolbox target.
about-debugging-multiprocess-toolbox-description = Թիրախային դիտարկչի համար հիմնական գործընթաց և բովանդակության գործընթացներ

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = Փակել նամակը

# Label text used for the error details of message component.
about-debugging-message-details-label-error = Սխալի մանրամասնություններ

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = Զգուշացման մանրամասնություններ

# Label text used for default state of details of message component.
about-debugging-message-details-label = Մանրամասնություններ
