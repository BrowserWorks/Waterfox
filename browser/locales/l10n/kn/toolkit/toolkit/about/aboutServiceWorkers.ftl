# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


### The term "Service Workers" and "Workers" should not be translated

about-service-workers-title = ಸೇವಾ ವರ್ಕಸ್ ಬಗ್ಗೆ
about-service-workers-main-title = ನೊಂದಣಿಗೊಂಡ ಸರ್ವಿಸ್‌ ವರ್ಕರ್ಸ್
about-service-workers-warning-not-enabled = ಸೇವಾ ವರ್ಕರ್‌ಗಳನ್ನು ಸಕ್ರಿಯಗೊಳಿಸಲಾಗಿಲ್ಲ.
about-service-workers-warning-no-service-workers = ಯಾವುದೇ ಸೇವಾ ವರ್ಕರ್‌ಗಳು ನೊಂದಾಯಿಸಿಕೊಂಡಿಲ್ಲ.

# The original title of service workers' information
#
# Variables:
#   $originTitle: original title
origin-title = ಮೂಲ: { $originTitle }

## These strings are for showing the information of workers.
##
## Variables:
##  $name: the name of scope, active cache, waiting cache and the push end point.
##  $url: the url of script specification and current worker.

scope = <strong>ವ್ಯಾಪ್ತಿ:</strong> { $name }
script-spec = <strong>ಸ್ಕ್ರಿಪ್ಟ್ ಸ್ಪೆಕ್:</strong> <a data-l10n-name="link">{ $url }</a>
current-worker-url = <strong>ಪ್ರಸ್ತುತ ವರ್ಕರ್ URL:</strong> <a data-l10n-name="link">{ $url }</a>
active-cache-name = <strong>ಸಕ್ರಿಯ ಕ್ಯಾಶೆ ಹೆಸರು:</strong> { $name }
waiting-cache-name = <strong>ಕಾಯುತ್ತಿರುವ ಕ್ಯಾಶೆ ಹೆಸರು:</strong> { $name }
push-end-point-waiting = <strong>ಪುಶ್ ಎಂಡ್‌ಪಾಯಿಂಟ್:</strong> { waiting }
push-end-point-result = <strong>ಪುಶ್ ಎಂಡ್‌ಪಾಯಿಂಟ್:</strong> { $name }

# This term is used as a button label (verb, not noun).
update-button = ಪರಿಷ್ಕರಿಸು

unregister-button = ನೋಂದಣಿ ತೆಗೆದುಹಾಕು

unregister-error = ಈ ಸೇವಾ ವರ್ಕರ್ ನೊಂದಾವಣಿ ತೆಗೆಯುವುದು ವಿಫಲವಾಗಿದೆ.

waiting = ಕಾಯುತ್ತಿದೆ…
