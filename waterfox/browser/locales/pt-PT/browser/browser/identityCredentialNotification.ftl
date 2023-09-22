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

identity-credential-header-providers = Iniciar sessão com um fornecedor de autenticação
identity-credential-header-accounts = Iniciar sessão com { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Abrir painel de autenticação
identity-credential-cancel-button =
    .label = Cancelar
    .accesskey = n
identity-credential-accept-button =
    .label = Continuar
    .accesskey = C
identity-credential-sign-in-button =
    .label = Iniciar sessão
    .accesskey = s
identity-credential-policy-title = Utilizar { $provider } como um fornecedor de autenticação
identity-credential-policy-description = Iniciar sessão em { $host } com uma conta { $provider } está sujeito à respetiva <label data-l10n-name="privacy-url">Política de Privacidade</label> e <label data-l10n-name="tos-url">Termos do Serviço</label>.
