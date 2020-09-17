# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Application panel which is available
### by setting the preference `devtools-application-enabled` to true.


### The correct localization of this file might be to keep it in English, or another
### language commonly spoken among web developers. You want to make that choice consistent
### across the developer tools. A good criteria is the language in which you'd find the
### best documentation on web development on the web.

# Header for the list of Service Workers displayed in the application panel for the current page.
serviceworker-list-header = সার্ভিস ওয়ার্কার্স

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = অন্য ডোমেইনের সেবা কর্মীদের জন্য <a>about:debugging</a> খুলুন

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = Unregister

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = ডিবাগ
    .title = কেবলমাত্র চলন্ত সার্ভিস ওয়ার্কার ডিবাগ করা যাবে

# Text for the debug link displayed for an already started Service Worker, when we
# are in multi e10s mode, which effectively disables this link.
serviceworker-worker-debug-forbidden = ডিবাগ করুন
    .title = যদি মাল্টি e10s নিষ্ক্রিয় থাকে তাহলে শুধুমাত্র সার্ভিস ওয়ার্কার্স ডিবাগ করতে পারেন

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start2 = শুরু
    .title = কেবল তখনই সেবাকর্মীরা শুরু করবে যদি  e10s নিষ্ক্রিয় থাকে

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = হালনাগাদ হয়েছে <time> { DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") } </time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = উৎস

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = অবস্থা

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = চলছে

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = থেমে গেছে

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = কনসোলে ত্রুটি সন্ধান করুন। <a> কনসোল খুলুন </a>

# Header for the Manifest page when we have an actual manifest
manifest-view-header = অ্যাপ ম্যানিফেস্ট

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = ত্রুটি এবং সতর্কতা

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = পরিচয়

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = উপস্থাপনা

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = আইকনগুলো

# Text displayed while we are loading the manifest file
manifest-loading = ম্যানিফেস্ট লোড হচ্ছে...

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = ম্যানিফেস্ট লোড হয়েছে।

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = ম্যানিফেস্টটি লোড করার সময় একটি ত্রুটি হয়েছিল:

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Firefox DevTools ত্রুটি

# Text displayed when the page has no manifest available
manifest-non-existing = পরিদর্শন করার মতো কোনও ম্যানিফেস্ট পাওয়া যায় নি।

# Text displayed when the page has a manifest embedded in a Data URL and
# thus we cannot link to it.
manifest-json-link-data-url = ম্যানিফেস্ট একটি ডাটা URL- এ বসানো হয়েছে।

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = উদ্দেশ্য: <code>{ $purpose }</code>

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = আইকন

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = মাপ সহ আইকন: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = আইকনের মাপ ঠিক নেই

# Sidebar navigation item for Manifest sidebar item section
sidebar-item-manifest = ম্যানিফেস্ট
    .alt = ম্যানিফেস্ট আইকন
    .title = ম্যানিফেস্ট

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = সতর্কতা আইকন
    .title = সতর্কতা

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = ত্রুটি আইকন
    .title = ত্রুটি

