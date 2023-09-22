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

identity-credential-header-providers = Zaloguj się za pomocą dostawcy logowania
identity-credential-header-accounts = Zaloguj się za pomocą konta { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Otwórz panel logowania
identity-credential-cancel-button =
    .label = Anuluj
    .accesskey = A
identity-credential-accept-button =
    .label = Kontynuuj
    .accesskey = K
identity-credential-sign-in-button =
    .label = Zaloguj się
    .accesskey = Z
identity-credential-policy-title = Używaj konta { $provider } jako dostawcę logowania
identity-credential-policy-description = Logowanie na { $host } za pomocą konta { $provider } podlega <label data-l10n-name="privacy-url">zasadom ochrony prywatności</label> i <label data-l10n-name="tos-url">regulaminowi usługi</label> danego konta.
