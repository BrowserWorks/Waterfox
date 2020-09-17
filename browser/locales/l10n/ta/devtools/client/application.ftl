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
serviceworker-list-header = சேவையாட்கள்

# Text displayed next to the list of Service Workers to encourage users to check out
# about:debugging to see all registered Service Workers.
serviceworker-list-aboutdebugging = <a>about:debugging</a>  மற்ற பிரிவு சேவையாட்களுக்குத் திறந்துள்ளது.

# Text for the button to unregister a Service Worker. Displayed for active Service Workers.
serviceworker-worker-unregister = பதிவிலகு

# Text for the debug link displayed for an already started Service Worker. Clicking on the
# link opens a new devtools toolbox for this service worker. The title attribute is only
# displayed when the link is disabled.
serviceworker-worker-debug = வழுநீக்கு
    .title = இயக்கத்திலுள்ள சேவையாட்கள் மட்டுமே வழுநீக்கலாம்

# Text displayed for the updated time of the service worker. The <time> element will
# display the last update time of the service worker script.
serviceworker-worker-updated = <time>{ DATETIME($date, month: "long", year: "numeric", day: "numeric", hour: "numeric", minute: "numeric", second: "numeric") }</time> புதுப்பிக்கப்பட்டது

# Text displayed next to the URL for the source of the service worker (e-g. "Source my/path/to/worker-js")
serviceworker-worker-source = மூலம்

# Text displayed next to the current status of the service worker.
serviceworker-worker-status = நிலைப்பாடு

## Service Worker status strings: all serviceworker-worker-status-* strings are also
## defined in aboutdebugging.properties and should be synchronized with them.

# Service Worker status. A running service worker is registered, currently executed, can
# be debugged and stopped.
serviceworker-worker-status-running = இயக்கத்தில்

# Service Worker status. A stopped service worker is registered but not currently active.
serviceworker-worker-status-stopped = நிறுத்தப்பட்டது

# Text displayed when no service workers are visible for the current page. Clicking on the
# link will open https://developer-mozilla-org/docs/Web/API/Service_Worker_API/Using_Service_Workers
serviceworker-empty-intro = இங்கு ஆய்வை மேற்கொள்ள நீங்கள் சேவையாளராகப் பதிந்திருக்க வேண்டும். <a>மேலும் காண்ன</a> 

# Text displayed when there are no Service Workers to display for the current page,
# introducing hints to debug Service Worker issues.
serviceworker-empty-suggestions = தற்போதைய பக்கத்தில் சேவையாட்கள் இருப்பின், நீங்கள் முயற்சிப்பதற்குச் சில செயல்கள் உள்ளன.

# Suggestion to check for errors in the Console to investigate why a service worker is not
# registered. Clicking on the link opens the webconsole.
serviceworker-empty-suggestions-console = முனையத்தில் காணப்படும் தவறுகளைக் கண்டறிக. <a>முனையத்தைத் திற</a>

# Suggestion to use the debugger to investigate why a service worker is not registered.
# Clicking on the link will switch from the Application panel to the debugger.
serviceworker-empty-suggestions-debugger = உங்கள் சேவையாள் பதிவை அடுத்து விதிவிலக்குகளைக் கண்டறிக. <a>வழுநீக்கியைத் திற</a>

# Suggestion to go to about:debugging in order to see Service Workers for all domains.
# Clicking on the link will open about:debugging in a new tab.
serviceworker-empty-suggestions-aboutdebugging = மற்ற பிரிவு சேவையாட்களை ஆராய்க.<a> about:debugging திறக்கவும்</a>

