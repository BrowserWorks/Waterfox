# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = { -relay-brand-name } konnte keine neue Maske generieren. HTTP-Fehlercode: { $status }.
firefox-relay-get-reusable-masks-failed = { -relay-brand-name } konnte keine wiederverwendbaren Masken finden. HTTP-Fehlercode: { $status }.

##

firefox-relay-must-login-to-fxa = Sie müssen sich bei { -fxaccount-brand-name } anmelden, um { -relay-brand-name } verwenden zu können.
firefox-relay-get-unlimited-masks =
    .label = Masken verwalten
    .accesskey = v
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = Schützen Sie Ihre E-Mail-Adresse:
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = { -relay-brand-name }-E-Mail-Maske verwenden
firefox-relay-use-mask-title = { -relay-brand-name }-E-Mail-Maske verwenden
firefox-relay-opt-in-confirmation-enable-button =
    .label = E-Mail-Maske verwenden
    .accesskey = v
firefox-relay-opt-in-confirmation-disable =
    .label = Nicht mehr anzeigen
    .accesskey = m
firefox-relay-opt-in-confirmation-postpone =
    .label = Nicht jetzt
    .accesskey = N
