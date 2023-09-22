# This Source Code Form is subject to the terms of the BrowserWorks Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.


## Credential panel
##
## Identity providers are websites you use to log in to another website, for
## example: Google when you Log in with Google.
##
## Variables:
##  $host (String): the hostname of the site that is being displayed.
##  $provider (String): the hostname of another website you are using to log in to the site being displayed

identity-credential-header-providers = Logg inn med ein innloggingsleverandør
identity-credential-header-accounts = Logg inn med { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Opne innloggingspanelet
identity-credential-cancel-button =
    .label = Avbryt
    .accesskey = A
identity-credential-accept-button =
    .label = Hald fram
    .accesskey = H
identity-credential-sign-in-button =
    .label = Logg inn
    .accesskey = L
identity-credential-policy-title = Bruk { $provider } som inloggningsleverandør
identity-credential-policy-description = Å logge på { $host } med en { $provider }-konto er underlagt <label data-l10n-name="privacy-url">personvernerklæringa</label> og <label data-l10n-name="tos-url">tenestevilkåra</label> deira.
