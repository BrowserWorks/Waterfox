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

identity-credential-header-providers = Mit einem Login-Anbieter anmelden
identity-credential-header-accounts = Mit { $provider } anmelden
identity-credential-urlbar-anchor =
    .tooltiptext = Login-Ansicht öffnen
identity-credential-cancel-button =
    .label = Abbrechen
    .accesskey = b
identity-credential-accept-button =
    .label = Weiter
    .accesskey = W
identity-credential-sign-in-button =
    .label = Anmelden
    .accesskey = A
identity-credential-policy-title = { $provider } als Login-Anbieter verwenden
identity-credential-policy-description = Die Anmeldung bei { $host } mit einem { $provider }-Konto unterliegt der <label data-l10n-name="privacy-url">Datenschutzrichtlinie</label> und den <label data-l10n-name="tos-url">Nutzungsbedingungen</label> des jeweiligen Anbieters.
