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

identity-credential-header-providers = Přihlaste se s pomocí poskytovatele přihlášení
identity-credential-header-accounts = Přihlášení pomocí { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Otevřít přihlašovací panel
identity-credential-cancel-button =
    .label = Zrušit
    .accesskey = Z
identity-credential-accept-button =
    .label = Pokračovat
    .accesskey = P
identity-credential-sign-in-button =
    .label = Přihlásit se
    .accesskey = h
identity-credential-policy-title = Jako poskytovatele přihlášení použít { $provider }
identity-credential-policy-description = Přihlášení na stránku { $host } pomocí účtu { $provider } podléhá jejich <label data-l10n-name="privacy-url">Zásadami ochrany osobních údajů</label> a <label data-l10n-name="tos-url">Podmínkami poskytování služby</label>.
