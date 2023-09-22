# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = { -relay-brand-name } nie może wygenerować nowej maski. Kod błędu HTTP: { $status }.
firefox-relay-get-reusable-masks-failed = { -relay-brand-name } nie odnalazł masek wielokrotnego użytku. Kod błędu HTTP: { $status }.

##

firefox-relay-must-login-to-fxa = Do korzystania z { -relay-brand-name } wymagane jest zalogowanie na { -fxaccount-brand-name(case: "loc", capitalization: "lower") }.
firefox-relay-get-unlimited-masks =
    .label = Zarządzaj maskami
    .accesskey = Z
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = Chroń swój adres e-mail:
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = Użyj maski { -relay-brand-name } dla adresu e-mail
firefox-relay-use-mask-title = Użyj maski { -relay-brand-name } dla adresu e-mail
firefox-relay-opt-in-confirmation-enable-button =
    .label = Użyj maski dla adresu e-mail
    .accesskey = U
firefox-relay-opt-in-confirmation-disable =
    .label = Nie pokazuj ponownie
    .accesskey = o
firefox-relay-opt-in-confirmation-postpone =
    .label = Nie teraz
    .accesskey = N
