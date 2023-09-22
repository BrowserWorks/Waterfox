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

identity-credential-header-providers = Войти с помощью провайдера входа
identity-credential-header-accounts = Войти с помощью { $provider }
identity-credential-urlbar-anchor =
    .tooltiptext = Открыть панель входа
identity-credential-cancel-button =
    .label = Отмена
    .accesskey = м
identity-credential-accept-button =
    .label = Продолжить
    .accesskey = ж
identity-credential-sign-in-button =
    .label = Войти
    .accesskey = й
identity-credential-policy-title = Использовать { $provider } в качестве провайдера входа
identity-credential-policy-description = Вход в { $host } с помощью аккаунта { $provider } регулируется его <label data-l10n-name="privacy-url">Политикой конфиденциальности</label> и <label data-l10n-name="tos-url">Условиями использования</label>.
