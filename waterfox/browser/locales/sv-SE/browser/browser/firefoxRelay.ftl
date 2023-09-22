# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = { -relay-brand-name } kunde inte generera ett nytt alias. HTTP-felkod: { $status }.
firefox-relay-get-reusable-masks-failed = { -relay-brand-name } kunde inte hitta återanvändbara alias. HTTP-felkod: { $status }.

##

firefox-relay-must-login-to-fxa = Du måste logga in på { -fxaccount-brand-name } för att kunna använda { -relay-brand-name }.
firefox-relay-must-login-to-account = Logga in på ditt konto för att använda dina { -relay-brand-name } e-postalias.
firefox-relay-get-unlimited-masks =
    .label = Hantera alias
    .accesskey = H
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = Skydda din e-postadress:
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = Använd { -relay-brand-name } e-postalias
firefox-relay-use-mask-title = Använd { -relay-brand-name } e-postalias
firefox-relay-opt-in-confirmation-enable-button =
    .label = Använd e-postalias
    .accesskey = A
firefox-relay-opt-in-confirmation-disable =
    .label = Visa mig inte det här igen
    .accesskey = n
firefox-relay-opt-in-confirmation-postpone =
    .label = Inte nu
    .accesskey = n
