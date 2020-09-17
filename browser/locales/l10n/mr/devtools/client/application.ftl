# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### These strings are used inside the Application panel which is available
### by setting the preference `devtools-application-enabled` to true.


### The correct localization of this file might be to keep it in English, or another
### language commonly spoken among web developers. You want to make that choice consistent
### across the developer tools. A good criteria is the language in which you'd find the
### best documentation on web development on the web.

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = अनोंदणीकृत करा

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = अद्ययावत <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = स्त्रोत

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = स्थिती

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = सुरू आहे

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = थांबले आहे

# Header for the Identity section of Manifest inspection displayed in the application panel.
manifest-item-identity = ओळख

# Header for the Presentation section of Manifest inspection displayed in the application panel.
manifest-item-presentation = सादरीकरण

# Header for the Icon section of Manifest inspection displayed in the application panel.
manifest-item-icons = चिन्हे

# Text displayed as the alt attribute for <img> tags showing the icons in the
# manifest.
manifest-icon-img =
    .alt = चिन्ह

# Text displayed as the title attribute for <img> tags showing the icons in the
# manifest. `$sizes` is a user-dependent string that has been parsed as a
# space-separated list of `<width>x<height>` sizes or the keyword `any`.
manifest-icon-img-title = आकार असलेले चिन्ह: { $sizes }

# Text for the ALT and TITLE attributes of the warning icon
icon-warning =
    .alt = चेतावनी चिन्ह
    .title = चेतावनी

# Text for the ALT and TITLE attributes of the error icon
icon-error =
    .alt = त्रुटी चिन्ह
    .title = त्रुटी

