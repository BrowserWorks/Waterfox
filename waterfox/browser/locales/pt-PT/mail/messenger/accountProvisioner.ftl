# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

account-provisioner-tab-title = Obter um novo endereço de e-mail de um fornecedor de serviços
provisioner-searching-icon =
    .alt = A pesquisar…
account-provisioner-title = Criar um novo endereço de email
account-provisioner-description = Utilize os nossos parceiros confiáveis para obter um novo endereço de e-mail privado e seguro.
account-provisioner-start-help = Os termos de pesquisa usados são enviados para { -vendor-short-name } (<a data-l10n-name="mozilla-privacy-link">Política de Privacidade</a>) e fornecedores de e-mail de terceiros <strong>mailfence.com </strong> (<a data-l10n-name="mailfence-privacy-link">Política de Privacidade</a>, <a data-l10n-name="mailfence-tou-link">Termos de Utilização</a >) e <strong>gandi.net</strong> (<a data-l10n-name="gandi-privacy-link">Política de Privacidade</a>, <a data-l10n-name="gandi-tou- link">Termos de Utilização</a>) para encontrar os endereços de e-mail disponíveis.
account-provisioner-mail-account-title = Comprar um novo endereço de e-mail
account-provisioner-mail-account-description = O Thunderbird fez uma parceria com <a data-l10n-name="mailfence-home-link">Mailfence</a> para lhe oferecer um novo e-mail privado e seguro. Nós acreditamos que todos devem ter um e-mail seguro.
account-provisioner-domain-title = Compre um e-mail e domínio próprios
account-provisioner-domain-description = O Thunderbird fez uma parceria com <a data-l10n-name="gandi-home-link">Gandi</a> para lhe oferecer um domínio personalizado. Isto permite que utilize qualquer endereço nesse domínio.

## Forms

account-provisioner-mail-input =
    .placeholder = O seu nome, apelido ou outro termo de pesquisa
account-provisioner-domain-input =
    .placeholder = O seu nome, apelido ou outro termo de pesquisa
account-provisioner-search-button = Pesquisar
account-provisioner-button-cancel = Cancelar
account-provisioner-button-existing = Usar uma conta de e-mail existente
account-provisioner-button-back = Retroceder

## Notifications

account-provisioner-connection-issues = Não foi possível contactar o nosso servidor de autenticação. Por favor, verifique a sua ligação.
account-provisioner-searching-email = A procurar contas de e-mail disponíveis…
account-provisioner-searching-domain = A procurar domínios disponíveis…
account-provisioner-searching-error = Não foi possível encontrar nenhum endereço para sugerir. Tente alterar os termos de pesquisa.

## Illustrations

account-provisioner-step1-image =
    .title = Escolha qual conta criar

## Search results

# Variables:
# $count (Number) - The number of domains found during search.
account-provisioner-results-title =
    { $count ->
        [one] Um endereço disponível encontrado para:
       *[other] { $count } endereços disponíveis encontrados para:
    }
account-provisioner-mail-results-caption = Pode tentar pesquisar por pseudónimos ou outros termos para encontrar mais endereços.
account-provisioner-domain-results-caption = Pode tentar pesquisar por pseudónimos ou outros termos para encontrar mais domínios.
account-provisioner-free-account = Gratuito
account-provision-price-per-year = { $price } por ano
account-provisioner-all-results-button = Mostrar todos os resultados
account-provisioner-open-in-tab-img =
    .title = Abre num novo separador
