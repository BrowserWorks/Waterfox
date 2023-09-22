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

identity-credential-header-providers = Aanmelden met een aanmeldprovider
identity-credential-header-accounts = Aanmelden met { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Aanmeldpaneel openen
identity-credential-cancel-button =
    .label = Annuleren
    .accesskey = n
identity-credential-accept-button =
    .label = Doorgaan
    .accesskey = D
identity-credential-sign-in-button =
    .label = Aanmelden
    .accesskey = A
identity-credential-policy-title = { $provider } gebruiken als aanmeldprovider
identity-credential-policy-description = Aanmelden bij { $host } met een { $provider }-account is onderworpen aan hun <label data-l10n-name="privacy-url">Privacybeleid</label> en <label data-l10n-name="tos-url">Servicevoorwaarden</label>.
