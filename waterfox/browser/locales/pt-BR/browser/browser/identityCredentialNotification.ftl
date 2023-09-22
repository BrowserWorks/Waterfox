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

identity-credential-header-providers = Entrar com um provedor de autenticação
identity-credential-header-accounts = Entrar com { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Abrir painel de autenticação
identity-credential-cancel-button =
    .label = Cancelar
    .accesskey = C
identity-credential-accept-button =
    .label = Avançar
    .accesskey = A
identity-credential-sign-in-button =
    .label = Entrar
    .accesskey = E
identity-credential-policy-title = Usar { $provider } como provedor de autenticação
identity-credential-policy-description = Se autenticar em { $host } com uma conta { $provider } está sujeito à <label data-l10n-name="privacy-url">política de privacidade</label> e aos <label data-l10n-name="tos-url">termos do serviço</label> deste provedor.
