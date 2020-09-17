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
serviceworker-list-header = सेवा कार्यकर्त्ता

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = अपंजीकृत

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = दोषशोधन करे
    .title = केवल निरंतर सेवा कार्यकर्ताओं का ही दोषशोधन किया जा सकता है

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = स्रोत

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = स्थिति

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = क्रियाशील

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = रुकी हुई

# Link will open https://developer.mozilla.org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro-link = अधिक जानें

# Header for the Errors and Warnings section of Manifest inspection displayed in the application panel.
manifest-item-warnings = त्रुटियां तथा चेतावनीयां

# Text displayed as an error when there has been a Firefox DevTools error while
# trying to load the manifest
manifest-loaded-devtools-error = Firefox DevTools त्रुटि

# Text displayed at manifest icons to label their purpose, as declared
# in the manifest.
manifest-icon-purpose = उद्देश्य: <code>{ $purpose }</code>

