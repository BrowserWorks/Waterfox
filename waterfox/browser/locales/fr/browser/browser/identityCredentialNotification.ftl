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

identity-credential-header-providers = Se connecter avec un fournisseur de connexion
identity-credential-header-accounts = Se connecter avec { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Ouvrir le panneau de connexion
identity-credential-cancel-button =
    .label = Annuler
    .accesskey = A
identity-credential-accept-button =
    .label = Continuer
    .accesskey = C
identity-credential-sign-in-button =
    .label = Se connecter
    .accesskey = S
identity-credential-policy-title = Utiliser { $provider } comme fournisseur de connexion
identity-credential-policy-description = Se connecter à { $host } avec un compte { $provider } est soumis à la <label data-l10n-name="privacy-url">politique de confidentialité</label> et aux <label data-l10n-name="tos-url">conditions d’utilisation</label> de ce dernier.
