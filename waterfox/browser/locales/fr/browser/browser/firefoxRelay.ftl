# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Error messages for failed HTTP web requests.
## https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses
## Variables:
##   $status (Number) - HTTP status code, for example 403

firefox-relay-mask-generation-failed = { -relay-brand-name } n’a pas pu générer un nouvel alias. Code d’erreur HTTP : { $status }.
firefox-relay-get-reusable-masks-failed = { -relay-brand-name } n’a pas pu trouver d’alias réutilisables. Code d’erreur HTTP : { $status }.

##

firefox-relay-must-login-to-fxa = Vous devez vous connecter à votre { -fxaccount-brand-name } afin d’utiliser { -relay-brand-name }.
firefox-relay-must-login-to-account = Connectez-vous à votre compte pour utiliser vos alias de messagerie { -relay-brand-name }.
firefox-relay-get-unlimited-masks =
    .label = Gérer les alias de messagerie
    .accesskey = G
# This is followed, on a new line, by firefox-relay-opt-in-subtitle-1
firefox-relay-opt-in-title-1 = Protégez votre adresse e-mail :
# This is preceded by firefox-relay-opt-in-title-1 (on a different line), which
# ends with a colon. You might need to adapt the capitalization of this string.
firefox-relay-opt-in-subtitle-1 = utilisez les alias de messagerie de { -relay-brand-name }
firefox-relay-use-mask-title = Utilisez les alias de messagerie de { -relay-brand-name }
firefox-relay-opt-in-confirmation-enable-button =
    .label = Utiliser les alias de messagerie
    .accesskey = U
firefox-relay-opt-in-confirmation-disable =
    .label = Ne plus afficher ce message
    .accesskey = N
firefox-relay-opt-in-confirmation-postpone =
    .label = Plus tard
    .accesskey = P
