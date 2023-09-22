# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = A { -relay-brand-name } nem tudott új maszkot létrehozni. HTTP hibakód: { $status }.
firefox-relay-get-reusable-masks-failed = A { -relay-brand-name } nem talált újrafelhasználható maszkokat. HTTP hibakód: { $status }.

##

firefox-relay-must-login-to-fxa = A { -relay-brand-name } használatához be kell jelentkeznie a { -fxaccount-brand-name }ba.
firefox-relay-must-login-to-account = Jelentkezzen be a fiókjába a { -relay-brand-name } e-mail-maszkok használatához.
firefox-relay-get-unlimited-masks =
    .label = Maszkok kezelése
    .accesskey = M
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = Védje meg az e-mail-címét:
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = Használjon { -relay-brand-name } e-mail-maszkot
firefox-relay-use-mask-title = Használjon { -relay-brand-name } e-mail-maszkot
firefox-relay-opt-in-confirmation-enable-button =
    .label = E-mail-maszk használata
    .accesskey = h
firefox-relay-opt-in-confirmation-disable =
    .label = Ne mutassa ezt újra
    .accesskey = N
firefox-relay-opt-in-confirmation-postpone =
    .label = Most nem
    .accesskey = n
