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

identity-credential-header-providers = Bejelentkezés egy szolgáltatóval
identity-credential-header-accounts = Bejelentkezés a következővel: { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Bejelentkezési panel megnyitása
identity-credential-cancel-button =
    .label = Mégse
    .accesskey = M
identity-credential-accept-button =
    .label = Folytatás
    .accesskey = F
identity-credential-sign-in-button =
    .label = Bejelentkezés
    .accesskey = B
identity-credential-policy-title = { $provider } használata bejelentkezési szolgáltatóként
identity-credential-policy-description = A(z) { $host } oldalon, a(z) { $provider }-fiókkal történő bejelentkezésre a szolgáltató <label data-l10n-name="privacy-url">adatvédelmi irányelvei</label> és <label data-l10n-name="tos-url">szolgáltatási feltételei</label> vonatkoznak.
