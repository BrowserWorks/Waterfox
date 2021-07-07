# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Application panel which is available
### by setting the preference `devtools-application-enabled` to true.


### The correct localization of this file might be to keep it in English, or another
### language commonly spoken among web developers. You want to make that choice consistent
### across the developer tools. A good criteria is the language in which you'd find the
### best documentation on web development on the web.

# Header for the list of Service Workers displayed in the application panel for the current page.
serviceworker-list-header = عمّال الخدمة

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = افتح <a>about:debugging</a> لتجد عمّال الخدمة من النطاقات الأخرى

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = ألغِ التسجيل

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = نقّح
    .title = يمكنك تنقيح أخطاء عمّال الخدمات فقط

# Alt text for the image icon displayed inside a debug link for a service worker.
serviceworker-worker-inspect-icon =
    .alt = افحص

# Text for the start link displayed for a registered but not running Service Worker.
# Clicking on the link will attempt to start the service worker.
serviceworker-worker-start3 = ابدأ

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = حُدّث في <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = يعمل

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = متوقف

# Text displayed when no service workers are visible for the current page.
serviceworker-empty-intro2 = لم يوجد عمّال خدمة

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = اطّلع على المزيد

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = الأخطاء والتحذيرات

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = الهويّة

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = الأيقونات

# Text displayed while we are loading the manifest file
manifest-loading = يُحمّل البيان…

# Text displayed when the manifest has been successfully loaded
manifest-loaded-ok = حُمّل البيان.

# Text displayed as a caption when there has been an error while trying to
# load the manifest
manifest-loaded-error = حدث خطأ أثناء تحميل البيان:

# Text displayed as an error when there has been a Waterfox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = خطأ في أدوات فَيَرفُكس للمطوّرين

# Text displayed when the page has no manifest available
manifest-non-existing = لم نجد بيانًا نفحصه.

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = أيقونة

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = أيقونة بالمقاسات: { $sizes }

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest, in case there's no icon size specified by the user
manifest-icon-img-title-no-sizes = مقاس الأيقونة غير محدّد

# Sidebar navigation item for Service Workers sidebar item section
sidebar-item-service-workers = عمّال الخدمة
    .alt = أيقونة عمّال الخدمة
    .title = عمّال الخدمة

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = أيقونة تحذير
    .title = تحذير

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = أيقونة خطأ
    .title = خطأ

