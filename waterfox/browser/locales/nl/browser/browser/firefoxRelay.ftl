# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = { -relay-brand-name } kan geen nieuw masker aanmaken. HTTP-foutcode: { $status }.
firefox-relay-get-reusable-masks-failed = { -relay-brand-name } kan geen herbruikbare maskers vinden. HTTP-foutcode: { $status }.

##

firefox-relay-must-login-to-fxa = U dient zich aan te melden bij { -fxaccount-brand-name } om { -relay-brand-name } te kunnen gebruiken.
firefox-relay-must-login-to-account = Meld u aan bij uw account om uw { -relay-brand-name }-e-mailmaskers te gebruiken.
firefox-relay-get-unlimited-masks =
    .label = Maskers beheren
    .accesskey = b
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = Bescherm uw e-mailadres:
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = { -relay-brand-name }-e-mailmasker gebruiken
firefox-relay-use-mask-title = { -relay-brand-name }-e-mailmasker gebruiken
firefox-relay-opt-in-confirmation-enable-button =
    .label = E-mailmasker gebruiken
    .accesskey = g
firefox-relay-opt-in-confirmation-disable =
    .label = Dit niet meer tonen
    .accesskey = n
firefox-relay-opt-in-confirmation-postpone =
    .label = Niet nu
    .accesskey = N
