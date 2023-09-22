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

identity-credential-header-providers = Logga in med en inloggningsleverantör
identity-credential-header-accounts = Logga in med { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Öppna inloggningspanelen
identity-credential-cancel-button =
    .label = Avbryt
    .accesskey = v
identity-credential-accept-button =
    .label = Fortsätt
    .accesskey = F
identity-credential-sign-in-button =
    .label = Logga in
    .accesskey = L
identity-credential-policy-title = Använd { $provider } som inloggningsleverantör
identity-credential-policy-description = Att logga in på { $host } med ett { $provider }-konto omfattas av deras <label data-l10n-name="privacy-url">sekretesspolicy</label> och <label data-l10n-name="tos-url">användarvillkor</label>.
