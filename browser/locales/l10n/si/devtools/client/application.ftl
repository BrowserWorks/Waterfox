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
serviceworker-list-header = සේවා ක්‍රියාකරුවන්

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = වෙනත් වසම් වල සේවා ක්‍රියාකරුවන් සඳහා <a>about:debugging</a> විවෘත කරන්න

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = ලියාපදිංචිය ඉවත් කරන්න

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = යාවත් කල <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time>

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = මූලය

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = තත්ත්වය

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = ක්‍රියාත්මක වෙමින්

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = නවතා ඇත

