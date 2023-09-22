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

identity-credential-header-providers = Log ind med en login-udbyder
identity-credential-header-accounts = Log ind med { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Åbn login-panelet
identity-credential-cancel-button =
    .label = Annuller
    .accesskey = A
identity-credential-accept-button =
    .label = Fortsæt
    .accesskey = F
identity-credential-sign-in-button =
    .label = Log ind
    .accesskey = L
identity-credential-policy-title = Brug { $provider } som login-udbyder
identity-credential-policy-description = Indlogning på { $host } med en { $provider }-konto er underlagt deres <label data-l10n-name="privacy-url">privatlivspolitik</label> og <label data-l10n-name="tos-url">tjenestevilkår</label>.
