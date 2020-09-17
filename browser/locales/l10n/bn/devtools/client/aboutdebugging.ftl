# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the about:debugging UI.


# Page Title strings

# Page title (ie tab title) for the Setup page
about-debugging-page-title-setup-page = ডিবাগিং - সেটআপ

# Page title (ie tab title) for the Runtime page
# { $selectedRuntimeId } is the id of the current runtime, such as "this-firefox", "localhost:6080", ...
about-debugging-page-title-runtime-page = ডিবাগিং - রানটাইম / { $selectedRuntimeId }

# Sidebar strings

# Display name of the runtime for the currently running instance of Firefox. Used in the
# Sidebar and in the Setup page.
about-debugging-this-firefox-runtime-name = এই { -brand-shorter-name }

# Sidebar heading for selecting the currently running instance of Firefox
about-debugging-sidebar-this-firefox =
    .name = { about-debugging-this-firefox-runtime-name }

# Sidebar heading for connecting to some remote source
about-debugging-sidebar-setup =
    .name = সেটআপ

# Text displayed in the about:debugging sidebar when USB devices discovery is enabled.
about-debugging-sidebar-usb-enabled = USB সক্রিয় হয়েছে

# Text displayed in the about:debugging sidebar when USB devices discovery is disabled
# (for instance because the mandatory ADB extension is not installed).
about-debugging-sidebar-usb-disabled = USB নিষ্ক্রিয় হয়েছে

# Connection status (connected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-connected = সংযুক্ত হয়েছে
# Connection status (disconnected) for runtime items in the sidebar
aboutdebugging-sidebar-runtime-connection-status-disconnected = সংযোগ বিচ্ছিন্ন হয়েছে

# Text displayed in the about:debugging sidebar when no device was found.
about-debugging-sidebar-no-devices = কোন ডিভাইস পাওয়া যায়নি

# Text displayed in buttons found in sidebar items representing remote runtimes.
# Clicking on the button will attempt to connect to the runtime.
about-debugging-sidebar-item-connect-button = সংযুক্ত করুন

# Text displayed in buttons found in sidebar items when the runtime is connecting.
about-debugging-sidebar-item-connect-button-connecting = সংযুক্ত করা হচ্ছে …

# Text displayed in buttons found in sidebar items when the connection failed.
about-debugging-sidebar-item-connect-button-connection-failed = সংযোগ ব্যর্থ হয়েছে

# Text displayed in connection warning on sidebar item of the runtime when connecting to
# the runtime is taking too much time.
about-debugging-sidebar-item-connect-button-connection-not-responding = সংযোগটি এখনও অমীমাংসিত, গন্তব্য ব্রাউজারের বার্তাগুলো দেখুন

# Text displayed as connection error in sidebar item when the connection has timed out.
about-debugging-sidebar-item-connect-button-connection-timeout = সংযোগের সময় উত্তীর্ণ হয়ে গেছে

# Temporary text displayed in sidebar items representing remote runtimes after
# successfully connecting to them. Temporary UI, do not localize.
about-debugging-sidebar-item-connected-label = সংযুক্ত হয়েছে

# Text displayed in sidebar items for remote devices where a compatible browser (eg
# Firefox) has not been detected yet. Typically, Android phones connected via USB with
# USB debugging enabled, but where Firefox is not started.
about-debugging-sidebar-runtime-item-waiting-for-browser = ব্রাউজার এর জন্য অপেক্ষা করা হচ্ছে…

# Text displayed in sidebar items for remote devices that have been disconnected from the
# computer.
about-debugging-sidebar-runtime-item-unplugged = অসংযুক্ত

# Title for runtime sidebar items that are related to a specific device (USB, WiFi).
about-debugging-sidebar-runtime-item-name =
    .title = { $displayName } ({ $deviceName })
# Title for runtime sidebar items where we cannot get device information (network
# locations).
about-debugging-sidebar-runtime-item-name-no-device =
    .title = { $displayName }

# Text to show in the footer of the sidebar that links to a help page
# (currently: https://developer.mozilla.org/docs/Tools/about:debugging)
about-debugging-sidebar-support = ডিবাগিং সাপোর্ট

# Text to show as the ALT attribute of a help icon that accompanies the help about
# debugging link in the footer of the sidebar
about-debugging-sidebar-support-icon =
    .alt = সাহায্য আইকন

# Text displayed in a sidebar button to refresh the list of USB devices. Clicking on it
# will attempt to update the list of devices displayed in the sidebar.
about-debugging-refresh-usb-devices-button = ডিভাইস রিফ্রেশ করুন

# Setup Page strings

# Title of the Setup page.
about-debugging-setup-title = সেটআপ

# Introduction text in the Setup page to explain how to configure remote debugging.
about-debugging-setup-intro = আপনি যে সংযোগ পদ্ধতিতে ডিভাইসটি রিমোটলি ডিবাগ করতে চান তা কনফিগার করুন।

# Explanatory text in the Setup page about what the 'This Firefox' page is for
about-debugging-setup-this-firefox2 = এক্সটেনশন এবং পরিষেবা কর্মীদের ডিবাগ করতে <a>{ about-debugging-this-firefox-runtime-name }</a>ব্যবহার করুন, { -brand-shorter-name }এই সংস্করণে।

# Title of the heading Connect section of the Setup page.
about-debugging-setup-connect-heading = একটি ডিভাইস সংযুক্ত করুন

# USB section of the Setup page
about-debugging-setup-usb-title = USB

# Explanatory text displayed in the Setup page when USB debugging is disabled
about-debugging-setup-usb-disabled = এটি সক্রিয় করার মাধ্যমে Andriod এর USB ডিবাগিং এর প্রয়োজনীয় কম্পোনেন্ট { -brand-shorter-name } ডাউনলোড হয়ে যুক্ত হবে।

# Text of the button displayed in the USB section of the setup page when USB debugging is disabled.
# Clicking on it will download components needed to debug USB Devices remotely.
about-debugging-setup-usb-enable-button = USB ডিভাইস সক্রিয় করুন

# Text of the button displayed in the USB section of the setup page when USB debugging is enabled.
about-debugging-setup-usb-disable-button = USB ডিভাইস নিষ্ক্রিয় করুন

# Text of the button displayed in the USB section of the setup page while USB debugging
# components are downloaded and installed.
about-debugging-setup-usb-updating-button = হালনাগাদ হচ্ছে...

# USB section of the Setup page (USB status)
about-debugging-setup-usb-status-enabled = সক্রিয় হয়েছে
about-debugging-setup-usb-status-disabled = নিষ্ক্রিয় হয়েছে
about-debugging-setup-usb-status-updating = হালনাগাদ হচ্ছে...

# USB section step by step guide
about-debugging-setup-usb-step-enable-dev-menu2 = আপনার অ্যান্ড্রয়েড ডিভাইসে ডেভেলপার মেনু সক্রিয় করুন।

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug2 = অ্যান্ড্রয়েড ডেভেলপার মেনুতে ইউএসবি ডিবাগিং সক্রিয় করুন।

# USB section step by step guide
about-debugging-setup-usb-step-enable-debug-firefox2 = অ্যান্ড্রয়েড ডিভাইসে Firefox এ ইউএসবি ডিবাগিং সক্রিয় করুন।

# USB section step by step guide
about-debugging-setup-usb-step-plug-device = Android ডিভাইসটিকে আপনার কম্পিউটারে সংযুক্ত করুন।

# Text shown in the USB section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/docs/Tools/Remote_Debugging/Debugging_over_USB
about-debugging-setup-usb-troubleshoot = ইউএসবি ডিভাইসে সংযোগ স্থাপনে সমস্যা?<a> ট্রাবলশুট </a>

# Network section of the Setup page
about-debugging-setup-network =
    .title = নেটওয়ার্ক এর অবস্থান

# Text shown in the Network section of the setup page with a link to troubleshoot connection errors.
# The link goes to https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_over_a_network
about-debugging-setup-network-troubleshoot = নেটওয়ার্ক অবস্থানের মাধ্যমে সংযোগ স্থাপনে সমস্যা? <a>ট্রাবলশুট </a>

# Text of a button displayed after the network locations "Host" input.
# Clicking on it will add the new network location to the list.
about-debugging-network-locations-add-button = যোগ

# Text to display when there are no locations to show.
about-debugging-network-locations-empty-text = কোনও নেটওয়ার্ক অবস্থান এখনও যুক্ত করা হয়নি।

# Text of the label for the text input that allows users to add new network locations in
# the Connect page. A host is a hostname and a port separated by a colon, as suggested by
# the input's placeholder "localhost:6080".
about-debugging-network-locations-host-input-label = হোস্ট

# Text of a button displayed next to existing network locations in the Connect page.
# Clicking on it removes the network location from the list.
about-debugging-network-locations-remove-button = অপসারণ

# Text used as error message if the format of the input value was invalid in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-invalid = অবৈধ হোস্ট “{ $host-value }”। প্রত্যাশিত বিন্যাসটি “hostname:portnumber”।

# Text used as error message if the input value was already registered in the network locations form of the Setup page.
# Variables:
#   $host-value (string) - The input value submitted by the user in the network locations form
about-debugging-network-location-form-duplicate = হোস্ট "{ $host-value }" ইতিমধ্যে নিবন্ধিত

# Runtime Page strings

# Below are the titles for the various categories of debug targets that can be found
# on "runtime" pages of about:debugging.
# Title of the temporary extensions category (only available for "This Firefox" runtime).
about-debugging-runtime-temporary-extensions =
    .name = অস্থায়ী এক্সটেনশন
# Title of the extensions category.
about-debugging-runtime-extensions =
    .name = এক্সটেনশন
# Title of the tabs category.
about-debugging-runtime-tabs =
    .name = ট্যাব
# Title of the service workers category.
about-debugging-runtime-service-workers =
    .name = সার্ভিস ওয়ার্কার্স
# Title of the shared workers category.
about-debugging-runtime-shared-workers =
    .name = শেয়ার্ড ওয়ার্কার্স
# Title of the other workers category.
about-debugging-runtime-other-workers =
    .name = অন্যান্য ওয়ার্কারস
# Title of the processes category.
about-debugging-runtime-processes =
    .name = প্রক্রিয়া

# Label of the button opening the performance profiler panel in runtime pages for remote
# runtimes.
about-debugging-runtime-profile-button2 = প্রোফাইল কর্মক্ষমতা

# This string is displayed in the runtime page if the current configuration of the
# target runtime is incompatible with service workers. "Learn more" points to MDN.
# https://developer.mozilla.org/en-US/docs/Tools/about%3Adebugging#Service_workers_not_compatible
about-debugging-runtime-service-workers-not-compatible = আপনার ব্রাউজার কনফিগারেশন পরিষেবা কর্মীদের সামঞ্জস্যপূর্ণ নয়। <a>আরো জানুন</a>

# This string is displayed in the runtime page if the remote browser version is too old.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $minVersion } is the minimum version that is compatible with the current Firefox instance (same format)
about-debugging-browser-version-too-old = সংযুক্ত ব্রাউজারটির একটু পুরানো সংস্করণ ({ $runtimeVersion }) রয়েছে। সর্বনিম্ন সমর্থিত সংস্করণ হলো ({ $minVersion })। এই অসমর্থিত সেটআপ DevTools কে বিকল করে দেয়ার জন্য দায়ি হতে পারে। অনুগ্রহ করে সংযুক্ত ব্রাউজার হালনাগাদ করুন। <a>সমস্যার সমাধান</a>

# This string is displayed in the runtime page if the remote browser version is too recent.
# "Troubleshooting" link points to https://developer.mozilla.org/docs/Tools/about:debugging#Troubleshooting
# { $runtimeID } is the build ID of the remote browser (for instance "20181231", format is yyyyMMdd)
# { $localID } is the build ID of the current Firefox instance (same format)
# { $runtimeVersion } is the version of the remote browser (for instance "67.0a1")
# { $localVersion } is the version of your current browser (same format)
about-debugging-browser-version-too-recent = সংযুক্ত ব্রাউজারটি ({ $runtimeVersion }, buildID { $runtimeID }) আপনার { -brand-shorter-name } ({ $localVersion }, buildID { $localID }) এর তুলনায় অধিক নতুন। এটি একটি অসমর্থিত সেটআপ এবং DevTools কে বিকল করে দিতে পারে। অনুগ্রহ করে Firefox হালনাগাদ করুন। <a>সমস্যা সমাধান</a>

# Displayed for runtime info in runtime pages.
# { $name } is brand name such as "Firefox Nightly"
# { $version } is version such as "64.0a1"
about-debugging-runtime-name = { $name } ({ $version })

# Text of a button displayed in Runtime pages for remote runtimes.
# Clicking on the button will close the connection to the runtime.
about-debugging-runtime-disconnect-button = বিচ্ছিন্ন

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is false on the target runtime.
about-debugging-connection-prompt-enable-button = দ্রুত সংযোগ সক্রিয় করুন

# Text of the connection prompt button displayed in Runtime pages, when the preference
# "devtools.debugger.prompt-connection" is true on the target runtime.
about-debugging-connection-prompt-disable-button = দ্রুত সংযোগ নিষ্ক্রিয় করুন

# Title of a modal dialog displayed on remote runtime pages after clicking on the Profile Runtime button.
about-debugging-profiler-dialog-title2 = প্রোফাইলার

# Clicking on the header of a debug target category will expand or collapse the debug
# target items in the category. This text is used as ’title’ attribute of the header,
# to describe this feature.
about-debugging-collapse-expand-debug-targets = সংকুচিত / প্রসারিত

# Debug Targets strings

# Displayed in the categories of "runtime" pages that don't have any debug target to
# show. Debug targets depend on the category (extensions, tabs, workers...).
about-debugging-debug-target-list-empty = এখনো কিছু না।

# Text of a button displayed next to debug targets of "runtime" pages. Clicking on this
# button will open a DevTools toolbox that will allow inspecting the target.
# A target can be an addon, a tab, a worker...
about-debugging-debug-target-inspect-button = পরীক্ষা

# Text of a button displayed in the "This Firefox" page, in the Temporary Extension
# section. Clicking on the button will open a file picker to load a temporary extension
about-debugging-tmp-extension-install-button = অস্থায়ী অ্যাড-অন লোড করুন…

# Text displayed when trying to install a temporary extension in the "This Firefox" page.
about-debugging-tmp-extension-install-error = অস্থায়ী অ্যাড-অন ইনস্টলেশনের সময় একটি ত্রুটি হয়েছিল।

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will reload the extension.
about-debugging-tmp-extension-reload-button = পুনরায় লোড

# Text of a button displayed for a temporary extension loaded in the "This Firefox" page.
# Clicking on the button will uninstall the extension and remove it from the page.
about-debugging-tmp-extension-remove-button = অপসারণ

# Message displayed in the file picker that opens to select a temporary extension to load
# (triggered by the button using "about-debugging-tmp-extension-install-button")
# manifest.json .xpi and .zip should not be localized.
# Note: this message is only displayed in Windows and Linux platforms.
about-debugging-tmp-extension-install-message = Manifest.json ফাইল অথবা .xpi/.zip archive নির্বাচন করুন

# This string is displayed as a message about the add-on having a temporaryID.
about-debugging-tmp-extension-temporary-id = এই ওয়েব ওয়েবএক্সটেনশনের একটি অস্থায়ী আইডি রয়েছে। <a>আরও জানুন</a>

# Text displayed for extensions in "runtime" pages, before displaying a link the extension's
# manifest URL.
about-debugging-extension-manifest-url =
    .label = মেনিফেস্ট URL

# Text displayed for extensions in "runtime" pages, before displaying the extension's uuid.
# UUIDs look like b293e463-481e-5148-a487-5aaf7a130429
about-debugging-extension-uuid =
    .label = আভ্যন্তরিণ UUID

# Text displayed for extensions (temporary extensions only) in "runtime" pages, before
# displaying the location of the temporary extension.
about-debugging-extension-location =
    .label = অবস্থান

# Text displayed for extensions in "runtime" pages, before displaying the extension's ID.
# For instance "geckoprofiler@mozilla.com" or "{ed26ddcb-5611-4512-a89a-51b8db81cfb2}".
about-debugging-extension-id =
    .label = এক্সটেনশন ID

# This string is displayed as a label of the button that pushes a test payload
# to a service worker.
# Note this relates to the "Push" API, which is normally not localized so it is
# probably better to not localize it.
about-debugging-worker-action-push2 = পুশ করুন
    .disabledTitle = { -brand-shorter-name } মাল্টিপ্রসেসের জন্য সার্ভিস ওয়ার্কার পুশ বর্তমানে নিষ্ক্রিয় রয়েছে

# This string is displayed as a label of the button that starts a service worker.
about-debugging-worker-action-start2 = শুরু করুন
    .disabledTitle = { -brand-shorter-name } মাল্টিপ্রসেসের জন্য সার্ভিস ওয়ার্কারের শুরু বর্তমানে নিষ্ক্রিয়

# This string is displayed as a label of the button that unregisters a service worker.
about-debugging-worker-action-unregister = অনিবন্ধিত

# Displayed for service workers in runtime pages that listen to Fetch events.
about-debugging-worker-fetch-listening =
    .label = ফেচ
    .value = ফেচ ইভেন্ট এর জন্য শোনা হচ্ছে

# Displayed for service workers in runtime pages that do not listen to Fetch events.
about-debugging-worker-fetch-not-listening =
    .label = ফেচ
    .value = ফেচ ইভেন্ট এর জন্য শোনা হচ্ছেনা

# Displayed for service workers in runtime pages that are currently running (service
# worker instance is active).
about-debugging-worker-status-running = চলমান

# Displayed for service workers in runtime pages that are registered but stopped.
about-debugging-worker-status-stopped = বন্ধ করা হয়েছে

# Displayed for service workers in runtime pages that are registering.
about-debugging-worker-status-registering = রেজিস্টার করা হচ্ছে

# Displayed for service workers in runtime pages, to label the scope of a worker
about-debugging-worker-scope =
    .label = স্কোপ

# Displayed for service workers in runtime pages, to label the push service endpoint (url)
# of a worker
about-debugging-worker-push-service =
    .label = পুশ সার্ভিস

# Displayed as title of the inspect button when service worker debugging is disabled.
about-debugging-worker-inspect-action-disabled =
    .title = Service Worker পরিদর্শন বর্তমানে { -brand-shorter-name } মাল্টিপ্রসেসের জন্য বন্ধ আছে

# Displayed as name for the Main Process debug target in the Processes category. Only for
# remote runtimes, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-name = প্রধান প্রক্রিয়া

# Displayed as description for the Main Process debug target in the Processes category.
# Only for remote browsers, if `devtools.aboutdebugging.process-debugging` is true.
about-debugging-main-process-description2 = কাঙ্খিত ব্রাউজারের জন্য মূল প্রসেস

# Displayed instead of the Main Process debug target when the preference
# `devtools.browsertoolbox.fission` is true.
about-debugging-multiprocess-toolbox-name = মাল্টিপ্রসেস টুলবক্স

# Alt text used for the close icon of message component (warnings, errors and notifications).
about-debugging-message-close-icon =
    .alt = বার্তা বন্ধ করুন

# Label text used for the error details of message component.
about-debugging-message-details-label-error = ত্রুটির বিস্তারিত

# Label text used for the warning details of message component.
about-debugging-message-details-label-warning = সতর্কবার্তার বিস্তারিত

# Label text used for default state of details of message component.
about-debugging-message-details-label = বিস্তারিত
